# Rebotia — Contexto del proyecto

## Qué es
Aplicación web para gestionar los partidos de un equipo infantil femenino de
baloncesto: creación de partidos y rivales, registro de estadísticas en
tiempo real durante el partido, y consulta de histórico por parte de las
familias.

## Stack
- **Frontend**: Astro (TypeScript, modo strict)
- **Backend / BD**: Supabase (PostgreSQL + Auth + RLS)
- **Autenticación**: Email + contraseña de Supabase Auth. Los usuarios se
  autoprovisionan desde el dashboard de Supabase (no hay registro público);
  un trigger les crea el perfil con rol `viewer` por defecto, y el primer
  admin se asciende a mano por SQL.

## Roles de usuario
- **admin**: entrenador principal. Gestión completa: equipos, jugadoras,
  creación/edición/borrado de partidos, y todo lo de editor.
- **editor**: ayudantes + preparador físico. Solo pueden registrar
  convocatoria, estadísticas y comentarios en partidos ya creados por el
  admin — no pueden crear ni editar equipos, jugadoras ni partidos.
- **viewer**: familias y jugadoras. Solo lectura, sin login (acceso público
  al calendario y a las fichas de partido), no pueden crear ni modificar
  nada.

## Estructura de navegación
- **Sección "Coach"** (privada, admin + editor): gestión de equipos rivales
  y plantilla de jugadoras (solo admin), creación/edición/borrado de
  partidos (solo admin), y registro de convocatoria/estadísticas/
  comentarios en las 3 fases de cada partido (admin + editor).
- **Sección "Calendario de partidos"** (pública, sin login): próximos
  partidos y partidos jugados, ficha de partido con estadísticas finales
  por jugadora y de equipo (propio vs. rival).

## Flujo de un partido
1. **Creación**: admin da de alta el partido (rival, localía, tipo/jornada;
   día, horas y ubicación del pabellón son opcionales y se pueden rellenar
   más tarde)
2. **Pre-Partido**: convocatoria (marcar convocada/lesionada/ausente y
   titular) y comentarios previos
3. **Al descanso**: estadísticas acumuladas hasta el descanso + comentarios
4. **Post-Partido**: estadísticas finales (acumulado de todo el partido),
   marca el partido como finalizado y calcula el marcador, + valoración

## Estadísticas

### Por jugadora (solo equipo propio — datos que también da la FBM)
Minutos, puntos, tiros de 2 metidos, tiros de 3 metidos, tiros libres
metidos/intentados, faltas cometidas.

### De equipo (propio Y rival — la FBM no las da)
Rebotes ofensivos, rebotes defensivos, pérdidas, robos.
Se registran como contador rápido (+1) sin necesidad de identificar
jugadora, para agilidad durante el partido en directo.

### Del rival, a nivel de equipo (sin desglose por jugadora — sí las da la FBM)
Puntos, tiros de 2 y 3 metidos, tiros libres metidos/intentados, faltas.

## Modelo de datos (resumen)
- `perfiles` (id, nombre, rol, avatar_url, created_at) — extiende auth.users
- `equipos` (id, nombre, escudo_url, categoria, es_propio) — jugadoras solo
  se llevan del equipo propio; los rivales son solo para enfrentar partidos
- `jugadoras` (id, equipo_id, nombre, dorsal, posicion) — siempre del
  equipo propio, sin selector de equipo en el formulario
- `partidos` (id, equipo_local_id, equipo_visitante_id, fecha_partido,
  hora_inicio, hora_convocatoria, ubicacion, ubicacion_url, tipo, jornada,
  fase_actual, puntos_local, puntos_visitante, creado_por) — fecha_partido/
  hora_inicio/hora_convocatoria son independientes entre sí y opcionales
  (se puede crear un partido sin horario aún definido)
- `convocatorias` (partido_id, jugadora_id, estado ['convocada'|'lesionada'|
  'ausente'], titular, minutos_jugados)
- `estadisticas_jugadora` (id, partido_id, jugadora_id, fase, minutos,
  puntos, t2_metidos, t3_metidos, tl_metidos, tl_intentados, faltas,
  autor_id, created_at)
- `estadisticas_equipo` (id, partido_id, fase, lado ['propio'|'rival'],
  puntos, t2_metidos, t3_metidos, tl_metidos, tl_intentados, faltas
  [solo relevantes para 'rival'; para 'propio' se calculan sumando
  estadisticas_jugadora], rebotes_ofensivos, rebotes_defensivos, perdidas,
  robos [estos sí en ambos lados], autor_id, created_at)
- `comentarios` (id, partido_id, fase, autor_id, texto, created_at)

Toda estadística y comentario debe guardar autoría (`autor_id`) y
`created_at`, para saber quién escribió cada dato y cuándo.

## Visión a futuro (no implementar aún, pero dejar la puerta abierta)
- Filtro dinámico de fase (1ª parte / 2ª parte / Final) en la ficha pública
  de partido, calculando la 2ª parte por diferencia (Final − 1ª parte)
- Gestión por temporadas
- Perfil histórico de cada rival
- Exportar resumen de partido en PDF
- Estadísticas acumuladas de temporada por jugadora

## Filosofía de diseño
Minimizar fricción durante el partido: registro rápido tipo formulario de
totales (no contadores en vivo) en vez de formularios largos y repetitivos,
sin login pesado para las familias (acceso público sin cuenta).

## Pendiente / conocido roto
- Subida de foto de perfil (`/perfil`): falla con "new row violates row
  level security policy" al subir a Supabase Storage pese a que las
  políticas y el JWT del usuario son correctos. Pausado, sin resolver.
