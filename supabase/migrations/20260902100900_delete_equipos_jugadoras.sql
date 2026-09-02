-- Faltaba permiso de borrado (solo había select/insert/update) para poder
-- ofrecer un CRUD completo de equipos y jugadoras en la zona Coach.
create policy "equipos_delete_admin_editor"
  on public.equipos
  for delete
  to authenticated
  using (public.es_admin_o_editor());

create policy "jugadoras_delete_admin_editor"
  on public.jugadoras
  for delete
  to authenticated
  using (public.es_admin_o_editor());
