alter table public.jugadoras alter column dorsal type text using dorsal::text;
notify pgrst, 'reload schema';
