-- Necesario para poder hacer upsert (guardar y volver a guardar sin duplicar
-- filas) desde el formulario de Post-Partido.
alter table public.estadisticas_jugadora
  add constraint estadisticas_jugadora_partido_jugadora_fase_key
  unique (partido_id, jugadora_id, fase);

alter table public.estadisticas_equipo
  add constraint estadisticas_equipo_partido_fase_lado_key
  unique (partido_id, fase, lado);
