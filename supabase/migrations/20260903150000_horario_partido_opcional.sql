-- Permite crear un partido sin día/hora todavía definidos (p. ej. cuando la
-- federación anuncia la jornada antes de confirmar fecha y hora).
alter table public.partidos alter column fecha_inicio drop not null;
alter table public.partidos alter column fecha_convocatoria drop not null;
