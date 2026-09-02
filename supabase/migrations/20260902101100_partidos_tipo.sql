create type public.tipo_partido as enum ('liga', 'amistoso');

alter table public.partidos add column tipo public.tipo_partido not null default 'liga';
