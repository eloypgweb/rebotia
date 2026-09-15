-- Ubicación del pabellón donde se juega, opcional y por partido (no por
-- equipo, ya que un mismo rival puede jugar en distintas pistas según la
-- jornada o el torneo).
alter table public.partidos add column ubicacion text;
