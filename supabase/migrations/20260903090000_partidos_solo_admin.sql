-- Crear/editar/borrar partidos pasa a ser exclusivo de admin (antes lo
-- podían hacer admin y editor). Editores conservan lectura y siguen
-- pudiendo gestionar equipos/jugadoras.
create or replace function public.es_admin()
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
      and rol = 'admin'
  );
$$;

drop policy "partidos_insert_admin_editor" on public.partidos;
drop policy "partidos_update_admin_editor" on public.partidos;

create policy "partidos_insert_admin"
  on public.partidos
  for insert
  to authenticated
  with check (public.es_admin());

create policy "partidos_update_admin"
  on public.partidos
  for update
  to authenticated
  using (public.es_admin())
  with check (public.es_admin());

create policy "partidos_delete_admin"
  on public.partidos
  for delete
  to authenticated
  using (public.es_admin());
