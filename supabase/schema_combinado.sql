-- Schema completo de Rebotia (combinación de supabase/migrations/*.sql)
-- Pega este archivo entero en el SQL Editor de Supabase y ejecútalo.
-- No es un archivo de migración en sí: es solo una copia para pegar a mano.

-- =========================================================
-- 1. perfiles
-- =========================================================
create type public.rol_usuario as enum ('admin', 'editor', 'viewer');

create table public.perfiles (
  id uuid primary key references auth.users (id) on delete cascade,
  nombre text not null,
  rol public.rol_usuario not null default 'viewer',
  avatar_url text,
  created_at timestamptz not null default now()
);

create or replace function public.es_admin_o_editor()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.perfiles
    where id = auth.uid()
      and rol in ('admin', 'editor')
  );
$$;

alter table public.perfiles enable row level security;

create policy "perfiles_select_authenticated"
  on public.perfiles for select to authenticated using (true);

create policy "perfiles_insert_admin_editor"
  on public.perfiles for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "perfiles_update_admin_editor"
  on public.perfiles for update to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());

-- =========================================================
-- 2. equipos
-- =========================================================
create table public.equipos (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  escudo_url text,
  categoria text,
  es_propio boolean not null default false
);

alter table public.equipos enable row level security;

create policy "equipos_select_authenticated"
  on public.equipos for select to authenticated using (true);

create policy "equipos_insert_admin_editor"
  on public.equipos for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "equipos_update_admin_editor"
  on public.equipos for update to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());

create policy "equipos_delete_admin_editor"
  on public.equipos for delete to authenticated
  using (public.es_admin_o_editor());

-- =========================================================
-- 3. jugadoras
-- =========================================================
create table public.jugadoras (
  id uuid primary key default gen_random_uuid(),
  equipo_id uuid not null references public.equipos (id) on delete cascade,
  nombre text not null,
  dorsal integer,
  posicion text
);

create index jugadoras_equipo_id_idx on public.jugadoras (equipo_id);

alter table public.jugadoras enable row level security;

create policy "jugadoras_select_authenticated"
  on public.jugadoras for select to authenticated using (true);

create policy "jugadoras_insert_admin_editor"
  on public.jugadoras for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "jugadoras_update_admin_editor"
  on public.jugadoras for update to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());

create policy "jugadoras_delete_admin_editor"
  on public.jugadoras for delete to authenticated
  using (public.es_admin_o_editor());

-- =========================================================
-- 4. partidos
-- =========================================================
create type public.estado_partido as enum (
  'pre_partido',
  'primera_parte',
  'descanso',
  'segunda_parte',
  'finalizado'
);

create type public.tipo_partido as enum ('liga', 'amistoso');

create table public.partidos (
  id uuid primary key default gen_random_uuid(),
  equipo_local_id uuid not null references public.equipos (id),
  equipo_visitante_id uuid not null references public.equipos (id),
  fecha_inicio timestamptz not null,
  fecha_convocatoria timestamptz not null,
  tipo public.tipo_partido not null default 'liga',
  jornada integer,
  fase_actual public.estado_partido not null default 'pre_partido',
  goles_local integer not null default 0,
  goles_visitante integer not null default 0,
  creado_por uuid references public.perfiles (id)
);

create index partidos_equipo_local_id_idx on public.partidos (equipo_local_id);
create index partidos_equipo_visitante_id_idx on public.partidos (equipo_visitante_id);

alter table public.partidos enable row level security;

create policy "partidos_select_authenticated"
  on public.partidos for select to authenticated using (true);

create policy "partidos_insert_admin_editor"
  on public.partidos for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "partidos_update_admin_editor"
  on public.partidos for update to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());

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

-- =========================================================
-- 5. convocatorias
-- =========================================================
create table public.convocatorias (
  partido_id uuid not null references public.partidos (id) on delete cascade,
  jugadora_id uuid not null references public.jugadoras (id) on delete cascade,
  titular boolean not null default false,
  minutos_jugados integer not null default 0,
  primary key (partido_id, jugadora_id)
);

create index convocatorias_jugadora_id_idx on public.convocatorias (jugadora_id);

alter table public.convocatorias enable row level security;

create policy "convocatorias_select_authenticated"
  on public.convocatorias for select to authenticated using (true);

create policy "convocatorias_insert_admin_editor"
  on public.convocatorias for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "convocatorias_update_admin_editor"
  on public.convocatorias for update to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());

-- =========================================================
-- 6. estadisticas_jugadora
-- =========================================================
create type public.fase_juego as enum ('primera_parte', 'segunda_parte', 'final');

create table public.estadisticas_jugadora (
  id uuid primary key default gen_random_uuid(),
  partido_id uuid not null references public.partidos (id) on delete cascade,
  jugadora_id uuid not null references public.jugadoras (id) on delete cascade,
  fase public.fase_juego not null,
  minutos integer not null default 0,
  puntos integer not null default 0,
  t2_metidos integer not null default 0,
  t3_metidos integer not null default 0,
  tl_metidos integer not null default 0,
  tl_intentados integer not null default 0,
  faltas integer not null default 0,
  autor_id uuid references public.perfiles (id),
  created_at timestamptz not null default now()
);

create index estadisticas_jugadora_partido_id_idx on public.estadisticas_jugadora (partido_id);
create index estadisticas_jugadora_jugadora_id_idx on public.estadisticas_jugadora (jugadora_id);

alter table public.estadisticas_jugadora enable row level security;

create policy "estadisticas_jugadora_select_authenticated"
  on public.estadisticas_jugadora for select to authenticated using (true);

create policy "estadisticas_jugadora_insert_admin_editor"
  on public.estadisticas_jugadora for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "estadisticas_jugadora_update_admin_editor"
  on public.estadisticas_jugadora for update to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());

-- =========================================================
-- 7. estadisticas_equipo
-- =========================================================
create type public.lado_equipo as enum ('propio', 'rival');

create table public.estadisticas_equipo (
  id uuid primary key default gen_random_uuid(),
  partido_id uuid not null references public.partidos (id) on delete cascade,
  fase public.fase_juego not null,
  lado public.lado_equipo not null,
  puntos integer not null default 0,
  t2_metidos integer not null default 0,
  t3_metidos integer not null default 0,
  tl_metidos integer not null default 0,
  tl_intentados integer not null default 0,
  faltas integer not null default 0,
  rebotes_ofensivos integer not null default 0,
  rebotes_defensivos integer not null default 0,
  perdidas integer not null default 0,
  robos integer not null default 0,
  autor_id uuid references public.perfiles (id),
  created_at timestamptz not null default now()
);

create index estadisticas_equipo_partido_id_idx on public.estadisticas_equipo (partido_id);

alter table public.estadisticas_equipo enable row level security;

create policy "estadisticas_equipo_select_authenticated"
  on public.estadisticas_equipo for select to authenticated using (true);

create policy "estadisticas_equipo_insert_admin_editor"
  on public.estadisticas_equipo for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "estadisticas_equipo_update_admin_editor"
  on public.estadisticas_equipo for update to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());

-- =========================================================
-- 8. comentarios
-- =========================================================
create table public.comentarios (
  id uuid primary key default gen_random_uuid(),
  partido_id uuid not null references public.partidos (id) on delete cascade,
  fase public.fase_juego not null,
  autor_id uuid references public.perfiles (id),
  texto text not null,
  created_at timestamptz not null default now()
);

create index comentarios_partido_id_idx on public.comentarios (partido_id);

alter table public.comentarios enable row level security;

create policy "comentarios_select_authenticated"
  on public.comentarios for select to authenticated using (true);

create policy "comentarios_insert_admin_editor"
  on public.comentarios for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "comentarios_update_admin_editor"
  on public.comentarios for update to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());

-- =========================================================
-- 9. trigger: crear perfil automáticamente al registrarse (rol viewer)
-- =========================================================
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

-- =========================================================
-- 10. avatares de perfil (Storage)
-- =========================================================
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

create policy "avatares_insert_propio"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "avatares_update_propio"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );

-- =========================================================
-- Nota: crear el primer admin (ejecutar aparte, después de que ese
-- usuario ya exista en auth.users -- lo crea el admin desde
-- Authentication → Users con email + contraseña -- y el trigger le haya
-- creado su perfil viewer; este UPDATE lo asciende a admin):
--
-- update public.perfiles set rol = 'admin' where id = '<uuid-del-usuario>';
-- =========================================================
