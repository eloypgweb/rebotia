alter table public.estadisticas_equipo alter column rebotes_ofensivos drop not null;
alter table public.estadisticas_equipo alter column rebotes_ofensivos drop default;
alter table public.estadisticas_equipo alter column rebotes_defensivos drop not null;
alter table public.estadisticas_equipo alter column rebotes_defensivos drop default;
alter table public.estadisticas_equipo alter column perdidas drop not null;
alter table public.estadisticas_equipo alter column perdidas drop default;
alter table public.estadisticas_equipo alter column robos drop not null;
alter table public.estadisticas_equipo alter column robos drop default;
notify pgrst, 'reload schema';
