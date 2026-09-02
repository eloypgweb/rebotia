create type public.lado_equipo as enum ('propio', 'rival');

create table public.estadisticas_equipo (
  id uuid primary key default gen_random_uuid(),
  partido_id uuid not null references public.partidos (id) on delete cascade,
  fase public.fase_juego not null,
  lado public.lado_equipo not null,
  puntos integer not null default 0,
  t2_metidos integer not null default 0,
  t3_metidos integer not null default 0,
  tl_metidos integer not null default 0,
  tl_intentados integer not null default 0,
  faltas integer not null default 0,
  rebotes_ofensivos integer not null default 0,
  rebotes_defensivos integer not null default 0,
  perdidas integer not null default 0,
  robos integer not null default 0,
  autor_id uuid references public.perfiles (id),
  created_at timestamptz not null default now()
);

create index estadisticas_equipo_partido_id_idx on public.estadisticas_equipo (partido_id);

alter table public.estadisticas_equipo enable row level security;

create policy "estadisticas_equipo_select_authenticated"
  on public.estadisticas_equipo
  for select
  to authenticated
  using (true);

create policy "estadisticas_equipo_insert_admin_editor"
  on public.estadisticas_equipo
  for insert
  to authenticated
  with check (public.es_admin_o_editor());

create policy "estadisticas_equipo_update_admin_editor"
  on public.estadisticas_equipo
  for update
  to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());
