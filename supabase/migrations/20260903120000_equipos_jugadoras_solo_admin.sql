-- Crear/editar/eliminar equipos y jugadoras pasa a ser solo de admin
-- (igual que ya ocurre con partidos). Editor sigue pudiendo leerlo todo.
drop policy "equipos_insert_admin_editor" on public.equipos;
drop policy "equipos_update_admin_editor" on public.equipos;
drop policy "equipos_delete_admin_editor" on public.equipos;

create policy "equipos_insert_admin"
  on public.equipos for insert to authenticated
  with check (public.es_admin());

create policy "equipos_update_admin"
  on public.equipos for update to authenticated
  using (public.es_admin())
  with check (public.es_admin());

create policy "equipos_delete_admin"
  on public.equipos for delete to authenticated
  using (public.es_admin());

drop policy "jugadoras_insert_admin_editor" on public.jugadoras;
drop policy "jugadoras_update_admin_editor" on public.jugadoras;
drop policy "jugadoras_delete_admin_editor" on public.jugadoras;

create policy "jugadoras_insert_admin"
  on public.jugadoras for insert to authenticated
  with check (public.es_admin());

create policy "jugadoras_update_admin"
  on public.jugadoras for update to authenticated
  using (public.es_admin())
  with check (public.es_admin());

create policy "jugadoras_delete_admin"
  on public.jugadoras for delete to authenticated
  using (public.es_admin());
