-- Los viewers (familias) ven el calendario y las estadísticas finales sin
-- necesidad de iniciar sesión, según CLAUDE.md ("viewer: sin login").
-- Ampliamos a "to public" (anon + authenticated) el SELECT de las tablas
-- necesarias para esa vista. perfiles, convocatorias y comentarios se
-- quedan como estaban (solo para usuarios autenticados: son datos internos
-- del staff, no pensados para las familias).

drop policy "equipos_select_authenticated" on public.equipos;
create policy "equipos_select_public"
  on public.equipos for select to public using (true);

drop policy "jugadoras_select_authenticated" on public.jugadoras;
create policy "jugadoras_select_public"
  on public.jugadoras for select to public using (true);

drop policy "partidos_select_authenticated" on public.partidos;
create policy "partidos_select_public"
  on public.partidos for select to public using (true);

drop policy "estadisticas_jugadora_select_authenticated" on public.estadisticas_jugadora;
create policy "estadisticas_jugadora_select_public"
  on public.estadisticas_jugadora for select to public using (true);

drop policy "estadisticas_equipo_select_authenticated" on public.estadisticas_equipo;
create policy "estadisticas_equipo_select_public"
  on public.estadisticas_equipo for select to public using (true);
