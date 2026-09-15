-- Separa el nombre del pabellón (lo que se muestra) del enlace exacto de
-- Google Maps (opcional, a dónde lleva el clic). Si no hay enlace, se
-- genera una búsqueda a partir del nombre.
alter table public.partidos add column ubicacion_url text;
