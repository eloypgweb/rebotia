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
  admin — no pueden crear ni editar equipos, jugadoras ni partidos. Sí
  pueden marcar y valorar objetivos de entrenamiento (crear/editar/borrar
  el catálogo de objetivos es solo admin).
- **viewer**: familias y jugadoras. Solo lectura, sin login (acceso público
  al calendario y a las fichas de partido), no pueden crear ni modificar
  nada.

## Estructura de navegación
- **Sección "Coach"** (privada, admin + editor): gestión de equipos rivales
  y plantilla de jugadoras (solo admin), creación/edición/borrado de
  partidos (solo admin), registro de convocatoria/estadísticas/comentarios
  en las fases de cada partido (admin + editor), catálogo de objetivos de
  entrenamiento con su seguimiento (admin + editor; el catálogo en sí solo
  lo edita admin), y planificador de entrenamientos por día (admin +
  editor).
- **Sección "Calendario de partidos"** (pública, sin login): próximos
  partidos y partidos jugados, ficha de partido con estadísticas finales
  por jugadora y de equipo (propio vs. rival).

## Flujo de un partido
1. **Creación**: admin da de alta el partido (rival, localía, tipo/jornada;
   día, horas y ubicación del pabellón son opcionales y se pueden rellenar
   más tarde)
2. **Pre-Partido**: convocatoria (marcar convocada/lesionada/ausente y
   titular) y comentarios previos
3. **Post-Partido**: estadísticas finales (acumulado de todo el partido),
   marca el partido como finalizado y calcula el marcador, + valoración

("Al descanso" existió como fase intermedia pero no se usa: la página se
eliminó. El enum de la BD conserva los valores `primera_parte`/`descanso`
sin usarlos, para no complicar una migración innecesaria.)

## Estadísticas

### Por jugadora (solo equipo propio — datos que también da la FBM)
Tiempo jugado (MM:SS, guardado en segundos), puntos, tiros de 2 metidos, tiros de 3 metidos, tiros libres
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
- `jugadoras` (id, equipo_id, nombre, dorsal [texto, permite "00"], posicion) — siempre del
  equipo propio, sin selector de equipo en el formulario
- `partidos` (id, equipo_local_id, equipo_visitante_id, fecha_partido,
  hora_inicio, hora_convocatoria, ubicacion, ubicacion_url, tipo, jornada,
  fase_actual, puntos_local, puntos_visitante, creado_por) — fecha_partido/
  hora_inicio/hora_convocatoria son independientes entre sí y opcionales
  (se puede crear un partido sin horario aún definido)
- `convocatorias` (partido_id, jugadora_id, estado ['convocada'|'lesionada'|
  'ausente'], titular, minutos_jugados)
- `estadisticas_jugadora` (id, partido_id, jugadora_id, fase, segundos,
  puntos, t2_metidos, t3_metidos, tl_metidos, tl_intentados, faltas,
  autor_id, created_at)
- `estadisticas_equipo` (id, partido_id, fase, lado ['propio'|'rival'],
  puntos, t2_metidos, t3_metidos, tl_metidos, tl_intentados, faltas
  [solo relevantes para 'rival'; para 'propio' se calculan sumando
  estadisticas_jugadora], rebotes_ofensivos, rebotes_defensivos, perdidas,
  robos [estos sí en ambos lados], autor_id, created_at)
- `comentarios` (id, partido_id, fase, autor_id, texto, created_at)
- `objetivos` (id, categoria, titulo, descripcion, orden, en_trabajo,
  valor_actual [1-5, null si en_trabajo es false], creado_por, created_at)
  — catálogo de objetivos de entrenamiento que da el club, agrupados por
  categoría; `en_trabajo` y `valor_actual` son el estado actual (switch +
  escala), no histórico
- `objetivos_valoraciones` (id, objetivo_id, valor [1-5], autor_id,
  created_at) — histórico append-only: se añade una fila cada vez que
  cambia el valor de un objetivo (apagar el switch no borra el historial)
- `sesiones_entrenamiento` (id, fecha [única], contenido [notas generales,
  texto libre], intensidad, autor_id, created_at) — un entrenamiento por
  día. Se ve y edita desde `/coach/entrenamientos` (vista semanal
  navegable con `?inicio=<lunes ISO>`) y `/coach/entrenamientos/<fecha
  ISO>` (un día). Solo se entrena martes/jueves/viernes (`DIAS_ENTRENO`
  en `lib/semana.ts`); cualquier otra fecha redirige. Cada sesión tiene
  un número correlativo calculado (no guardado en BD) a partir de un
  ancla fija: el martes 20 de octubre de 2026 es la sesión 29
  (`numeroSesion()` en `lib/semana.ts`).
- `sesion_objetivos` (fecha, objetivo_id) — qué objetivos del catálogo se
  trabajan en una sesión concreta (no por semana completa, por día). Se
  marca con checkboxes agrupados por categoría en la propia página de la
  sesión; se guarda reemplazando todo el conjunto de esa fecha de golpe
  (borra e inserta), no por diferencias.
- `sesiones_entrenamiento.intensidad` (1-5, opcional) — única parte
  editable de la cabecera de una sesión. El resto de la cabecera (horario
  de pista, pabellón, duración, nº de sesión) no se guarda en BD: se
  calcula a partir de un horario fijo por día de la semana
  (`HORARIO_POR_DIA` en `lib/semana.ts`) — martes/jueves/viernes, cada uno
  con su pabellón y horario de pista. Si ese horario cambia de verdad en
  la realidad, se cambia ahí, no desde la app.
- `ejercicios_sesion` (id, fecha, titulo, detalle, duracion_minutos,
  orden) — lista plana de ejercicios de una sesión (sin agrupar por
  franjas pista/físico — se decidió no complicarlo así). `detalle` es
  texto libre para normas/variantes. Sin fotos ni diagramas todavía
  (aplazado: de momento solo texto en `detalle`). Se guarda igual que
  `sesion_objetivos`: borra todo lo de esa fecha e inserta de nuevo.

Toda estadística y comentario debe guardar autoría (`autor_id`) y
`created_at`, para saber quién escribió cada dato y cuándo.

## Visión a futuro (no implementar aún, pero dejar la puerta abierta)
- Filtro dinámico de fase (1ª parte / 2ª parte / Final) en la ficha pública
  de partido, calculando la 2ª parte por diferencia (Final − 1ª parte)
- Gestión por temporadas
- Perfil histórico de cada rival
- Exportar resumen de partido en PDF
- Diagramas/imágenes por ejercicio (`ejercicios_sesion`): adjuntar una
  foto/captura en vez de solo texto en `detalle`. Se decidió que sea
  subir una imagen (reutilizando Supabase Storage), no un editor de
  dibujo interactivo — pero ojo, ya hay un bug sin resolver justo en
  Storage (ver "Pendiente / conocido roto"), probar con cuidado.
- Plantilla recurrente de entrenamientos (horario fijo por día de la
  semana) — ya existe como constante en código (`HORARIO_POR_DIA` en
  `lib/semana.ts`), no como algo configurable desde la app. Solo haría
  falta una pantalla de administración si ese horario empezara a cambiar
  a menudo.

## Filosofía de diseño
Minimizar fricción durante el partido: registro rápido tipo formulario de
totales (no contadores en vivo) en vez de formularios largos y repetitivos,
sin login pesado para las familias (acceso público sin cuenta).

## Pendiente / conocido roto
- Subida de foto de perfil (`/perfil`): falla con "new row violates row
  level security policy" al subir a Supabase Storage pese a que las
  políticas y el JWT del usuario son correctos. Pausado, sin resolver.
