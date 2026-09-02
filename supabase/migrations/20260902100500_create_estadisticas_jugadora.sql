-- Fase de juego usada para filtrar estadísticas y comentarios
-- (1ª parte / 2ª parte / Final).
create type public.fase_juego as enum ('primera_parte', 'segunda_parte', 'final');

create table public.estadisticas_jugadora (
  id uuid primary key default gen_random_uuid(),
  partido_id uuid not null references public.partidos (id) on delete cascade,
  jugadora_id uuid not null references public.jugadoras (id) on delete cascade,
  fase public.fase_juego not null,
  minutos integer not null default 0,
  puntos integer not null default 0,
  t2_metidos integer not null default 0,
  t3_metidos integer not null default 0,
  tl_metidos integer not null default 0,
  tl_intentados integer not null default 0,
  faltas integer not null default 0,
  autor_id uuid references public.perfiles (id),
  created_at timestamptz not null default now()
);

create index estadisticas_jugadora_partido_id_idx on public.estadisticas_jugadora (partido_id);
create index estadisticas_jugadora_jugadora_id_idx on public.estadisticas_jugadora (jugadora_id);

alter table public.estadisticas_jugadora enable row level security;

create policy "estadisticas_jugadora_select_authenticated"
  on public.estadisticas_jugadora
  for select
  to authenticated
  using (true);

create policy "estadisticas_jugadora_insert_admin_editor"
  on public.estadisticas_jugadora
  for insert
  to authenticated
  with check (public.es_admin_o_editor());

create policy "estadisticas_jugadora_update_admin_editor"
  on public.estadisticas_jugadora
  for update
  to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());
