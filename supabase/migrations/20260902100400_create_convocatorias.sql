create table public.convocatorias (
  partido_id uuid not null references public.partidos (id) on delete cascade,
  jugadora_id uuid not null references public.jugadoras (id) on delete cascade,
  titular boolean not null default false,
  minutos_jugados integer not null default 0,
  primary key (partido_id, jugadora_id)
);

create index convocatorias_jugadora_id_idx on public.convocatorias (jugadora_id);

alter table public.convocatorias enable row level security;

create policy "convocatorias_select_authenticated"
  on public.convocatorias
  for select
  to authenticated
  using (true);

create policy "convocatorias_insert_admin_editor"
  on public.convocatorias
  for insert
  to authenticated
  with check (public.es_admin_o_editor());

create policy "convocatorias_update_admin_editor"
  on public.convocatorias
  for update
  to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());
