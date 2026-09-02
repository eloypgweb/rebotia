-- Roles de usuario de la aplicación.
create type public.rol_usuario as enum ('admin', 'editor', 'viewer');

-- Extiende auth.users con datos propios de la app.
create table public.perfiles (
  id uuid primary key references auth.users (id) on delete cascade,
  nombre text not null,
  rol public.rol_usuario not null default 'viewer',
  created_at timestamptz not null default now()
);

-- True si el usuario autenticado es admin o editor.
-- security definer: evita que la política de perfiles quede atrapada en
-- una recursión al consultar la propia tabla perfiles.
create or replace function public.es_admin_o_editor()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.perfiles
    where id = auth.uid()
      and rol in ('admin', 'editor')
  );
$$;

alter table public.perfiles enable row level security;

create policy "perfiles_select_authenticated"
  on public.perfiles
  for select
  to authenticated
  using (true);

create policy "perfiles_insert_admin_editor"
  on public.perfiles
  for insert
  to authenticated
  with check (public.es_admin_o_editor());

create policy "perfiles_update_admin_editor"
  on public.perfiles
  for update
  to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());

-- Nota: al no existir todavía ningún admin/editor, el primer perfil admin
-- debe insertarse desde el SQL Editor de Supabase (o con la service_role
-- key), ya que estas políticas bloquean la auto-elevación de rol.
