# Rebotia — Contexto del proyecto

## Qué es
Aplicación web para gestionar los partidos de un equipo infantil femenino de
baloncesto: creación de partidos y rivales, registro de estadísticas en
tiempo real durante el partido, y consulta de histórico por parte de las
familias.

## Stack
- **Frontend**: Astro (TypeScript, modo strict)
- **Backend / BD**: Supabase (PostgreSQL + Auth + RLS)
- **Autenticación**: Magic link de Supabase Auth (sin contraseñas)

## Roles de usuario
- **admin**: entrenador principal. Gestión completa.
- **editor**: ayudantes + preparador físico. Crean partidos, registran
  estadísticas y comentarios en directo. Acceden por magic link.
- **viewer**: familias y jugadoras. Solo lectura, sin login (o login simple),
  no pueden crear ni modificar nada.

## Estructura de navegación
- **Sección "Coach"** (privada, admin + editor): gestión de equipos rivales,
  plantilla de jugadoras, creación de partidos/jornadas, registro en directo
  de estadísticas, comentarios y parciales por cuarto.
- **Sección "Partidos jugados"** (pública, familias): listado de partidos,
  ficha de partido con filtro dinámico de fase (1ª parte / 2ª parte / Final
  — Final por defecto), parciales por cuarto.

## Flujo de un partido
1. **Creación**: admin/editor da de alta el partido (rival, fecha, jornada)
2. **Pre-Partido**: convocatoria y notas previas
3. **Al descanso**: estadísticas de la 1ª parte + comentarios
4. **Post-Partido**: estadísticas completas, resultado final, valoración

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
- `perfiles` (id, nombre, rol, created_at) — extiende auth.users
- `equipos` (id, nombre, escudo_url, categoria, es_propio)
- `jugadoras` (id, equipo_id, nombre, dorsal, posicion)
- `partidos` (id, equipo_local_id, equipo_visitante_id, fecha, jornada,
  fase_actual, goles_local, goles_visitante, creado_por)
- `convocatorias` (partido_id, jugadora_id, titular, minutos_jugados)
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
- Gestión por temporadas
- Perfil histórico de cada rival
- Exportar resumen de partido en PDF
- Estadísticas acumuladas de temporada por jugadora

## Filosofía de diseño
Minimizar fricción durante el partido: registro rápido tipo contador en vez
de formularios largos, sin login pesado para editores (magic link).
