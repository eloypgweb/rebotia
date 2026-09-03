-- Baloncesto: se anotan puntos, no goles. Corrige el nombre heredado por
-- error de las migraciones iniciales.
alter table public.partidos rename column goles_local to puntos_local;
alter table public.partidos rename column goles_visitante to puntos_visitante;
