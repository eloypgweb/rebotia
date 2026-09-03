-- Antes fecha_inicio/fecha_convocatoria eran un único timestamptz cada una,
-- lo que obligaba a saber día Y hora a la vez. Se separan en día del
-- partido + horas sueltas para poder guardar, por ejemplo, solo el día
-- sin la hora todavía.
alter table public.partidos add column fecha_partido date;
alter table public.partidos add column hora_inicio time;
alter table public.partidos add column hora_convocatoria time;

update public.partidos
set
  fecha_partido = (fecha_inicio at time zone 'Europe/Madrid')::date,
  hora_inicio = (fecha_inicio at time zone 'Europe/Madrid')::time,
  hora_convocatoria = (fecha_convocatoria at time zone 'Europe/Madrid')::time
where fecha_inicio is not null;

alter table public.partidos drop column fecha_inicio;
alter table public.partidos drop column fecha_convocatoria;
