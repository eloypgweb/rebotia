create table public.jugadoras (
  id uuid primary key default gen_random_uuid(),
  equipo_id uuid not null references public.equipos (id) on delete cascade,
  nombre text not null,
  dorsal integer,
  posicion text
);

create index jugadoras_equipo_id_idx on public.jugadoras (equipo_id);

alter table public.jugadoras enable row level security;

create policy "jugadoras_select_authenticated"
  on public.jugadoras
  for select
  to authenticated
  using (true);

create policy "jugadoras_insert_admin_editor"
  on public.jugadoras
  for insert
  to authenticated
  with check (public.es_admin_o_editor());

create policy "jugadoras_update_admin_editor"
  on public.jugadoras
  for update
  to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());
