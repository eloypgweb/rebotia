create table public.comentarios (
  id uuid primary key default gen_random_uuid(),
  partido_id uuid not null references public.partidos (id) on delete cascade,
  fase public.fase_juego not null,
  autor_id uuid references public.perfiles (id),
  texto text not null,
  created_at timestamptz not null default now()
);

create index comentarios_partido_id_idx on public.comentarios (partido_id);

alter table public.comentarios enable row level security;

create policy "comentarios_select_authenticated"
  on public.comentarios
  for select
  to authenticated
  using (true);

create policy "comentarios_insert_admin_editor"
  on public.comentarios
  for insert
  to authenticated
  with check (public.es_admin_o_editor());

create policy "comentarios_update_admin_editor"
  on public.comentarios
  for update
  to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());
