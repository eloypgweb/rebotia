-- Estado de cada jugadora convocada a un partido concreto.
create type public.estado_convocatoria as enum ('convocada', 'lesionada', 'ausente');

alter table public.convocatorias
  add column estado public.estado_convocatoria not null default 'convocada';

-- Los comentarios también se podrán escribir antes del partido (no solo
-- en 1ª/2ª parte o al final).
alter type public.fase_juego add value 'pre_partido' before 'primera_parte';

-- Permitir borrar comentarios (antes solo se podía crear/editar).
create policy "comentarios_delete_admin_editor"
  on public.comentarios
  for delete
  to authenticated
  using (public.es_admin_o_editor());
