-- "fecha" (solo día) se sustituye por fecha_inicio y fecha_convocatoria
-- (con hora), necesarias para avisar a las jugadoras.
alter table public.partidos drop column fecha;
alter table public.partidos add column fecha_inicio timestamptz not null;
alter table public.partidos add column fecha_convocatoria timestamptz not null;

-- Un partido siempre debe enfrentar a nuestro equipo (es_propio) contra un
-- rival: nunca dos propios ni dos rivales entre sí.
create or replace function public.validar_equipos_partido()
returns trigger
language plpgsql
as $$
declare
  local_propio boolean;
  visitante_propio boolean;
begin
  select es_propio into local_propio from public.equipos where id = new.equipo_local_id;
  select es_propio into visitante_propio from public.equipos where id = new.equipo_visitante_id;

  if local_propio is not distinct from visitante_propio then
    raise exception 'Un partido debe ser entre nuestro equipo y un rival.';
  end if;

  return new;
end;
$$;

create trigger validar_equipos_partido
  before insert or update on public.partidos
  for each row
  execute function public.validar_equipos_partido();
