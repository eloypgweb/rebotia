alter table public.sesiones_entrenamiento
  add column intensidad smallint check (intensidad between 1 and 5);

create table public.ejercicios_sesion (
  id uuid primary key default gen_random_uuid(),
  fecha date not null references public.sesiones_entrenamiento (fecha) on delete cascade,
  titulo text not null,
  detalle text,
  duracion_minutos integer,
  orden integer not null default 0,
  created_at timestamptz not null default now()
);

create index ejercicios_sesion_fecha_idx on public.ejercicios_sesion (fecha);

alter table public.ejercicios_sesion enable row level security;

create policy "ejercicios_sesion_select_authenticated"
  on public.ejercicios_sesion for select to authenticated using (true);

create policy "ejercicios_sesion_insert_admin_editor"
  on public.ejercicios_sesion for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "ejercicios_sesion_update_admin_editor"
  on public.ejercicios_sesion for update to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());

create policy "ejercicios_sesion_delete_admin_editor"
  on public.ejercicios_sesion for delete to authenticated
  using (public.es_admin_o_editor());
