-- Crea automáticamente la fila en perfiles (rol viewer por defecto) cada
-- vez que se da de alta un usuario en auth.users (p. ej. tras su primer
-- login por magic link).
create or replace function public.crear_perfil_para_nuevo_usuario()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.perfiles (id, nombre, rol)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'nombre', new.email),
    'viewer'
  );

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function public.crear_perfil_para_nuevo_usuario();
