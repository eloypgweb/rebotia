create table public.sesiones_entrenamiento (
  id uuid primary key default gen_random_uuid(),
  fecha date not null unique,
  contenido text,
  autor_id uuid references public.perfiles (id),
  created_at timestamptz not null default now()
);

alter table public.sesiones_entrenamiento enable row level security;

create policy "sesiones_entrenamiento_select_authenticated"
  on public.sesiones_entrenamiento for select to authenticated using (true);

create policy "sesiones_entrenamiento_insert_admin_editor"
  on public.sesiones_entrenamiento for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "sesiones_entrenamiento_update_admin_editor"
  on public.sesiones_entrenamiento for update to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());
