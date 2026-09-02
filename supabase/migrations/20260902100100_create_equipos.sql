create table public.equipos (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  escudo_url text,
  categoria text,
  es_propio boolean not null default false
);

alter table public.equipos enable row level security;

create policy "equipos_select_authenticated"
  on public.equipos
  for select
  to authenticated
  using (true);

create policy "equipos_insert_admin_editor"
  on public.equipos
  for insert
  to authenticated
  with check (public.es_admin_o_editor());

create policy "equipos_update_admin_editor"
  on public.equipos
  for update
  to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());
