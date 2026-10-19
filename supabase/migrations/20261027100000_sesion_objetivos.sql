create table public.sesion_objetivos (
  fecha date not null references public.sesiones_entrenamiento (fecha) on delete cascade,
  objetivo_id uuid not null references public.objetivos (id) on delete cascade,
  primary key (fecha, objetivo_id)
);

create index sesion_objetivos_objetivo_id_idx on public.sesion_objetivos (objetivo_id);

alter table public.sesion_objetivos enable row level security;

create policy "sesion_objetivos_select_authenticated"
  on public.sesion_objetivos for select to authenticated using (true);

create policy "sesion_objetivos_insert_admin_editor"
  on public.sesion_objetivos for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "sesion_objetivos_delete_admin_editor"
  on public.sesion_objetivos for delete to authenticated
  using (public.es_admin_o_editor());
