alter table public.perfiles add column avatar_url text;

-- Bucket público para las fotos de perfil.
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- Cada usuario solo puede subir/reemplazar su propia foto, guardada bajo
-- una carpeta con su propio uid (avatars/<uid>/...).
create policy "avatares_insert_propio"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "avatares_update_propio"
  on storage.objects
  for update
  to authenticated
  using (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );
