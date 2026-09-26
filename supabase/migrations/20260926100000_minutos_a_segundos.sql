alter table public.estadisticas_jugadora rename column minutos to segundos;
update public.estadisticas_jugadora set segundos = segundos * 60;
