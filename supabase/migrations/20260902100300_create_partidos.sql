-- Estado/fase general del partido (distinto del filtro de fase de
-- estadísticas y comentarios, ver fase_juego en estadisticas_jugadora).
create type public.estado_partido as enum (
  'pre_partido',
  'primera_parte',
  'descanso',
  'segunda_parte',
  'finalizado'
);

create table public.partidos (
  id uuid primary key default gen_random_uuid(),
  equipo_local_id uuid not null references public.equipos (id),
  equipo_visitante_id uuid not null references public.equipos (id),
  fecha date not null,
  jornada integer,
  fase_actual public.estado_partido not null default 'pre_partido',
  goles_local integer not null default 0,
  goles_visitante integer not null default 0,
  creado_por uuid references public.perfiles (id)
);

create index partidos_equipo_local_id_idx on public.partidos (equipo_local_id);
create index partidos_equipo_visitante_id_idx on public.partidos (equipo_visitante_id);

alter table public.partidos enable row level security;

create policy "partidos_select_authenticated"
  on public.partidos
  for select
  to authenticated
  using (true);

create policy "partidos_insert_admin_editor"
  on public.partidos
  for insert
  to authenticated
  with check (public.es_admin_o_editor());

create policy "partidos_update_admin_editor"
  on public.partidos
  for update
  to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());
