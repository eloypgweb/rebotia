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

create or replace function public.es_admin()
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
      and rol = 'admin'
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

create policy "equipos_select_public"
  on public.equipos for select to public using (true);

create policy "equipos_insert_admin"
  on public.equipos for insert to authenticated
  with check (public.es_admin());

create policy "equipos_update_admin"
  on public.equipos for update to authenticated
  using (public.es_admin())
  with check (public.es_admin());

create policy "equipos_delete_admin"
  on public.equipos for delete to authenticated
  using (public.es_admin());

-- =========================================================
-- 3. jugadoras
-- =========================================================
create table public.jugadoras (
  id uuid primary key default gen_random_uuid(),
  equipo_id uuid not null references public.equipos (id) on delete cascade,
  nombre text not null,
  dorsal text,
  posicion text
);

create index jugadoras_equipo_id_idx on public.jugadoras (equipo_id);

alter table public.jugadoras enable row level security;

create policy "jugadoras_select_public"
  on public.jugadoras for select to public using (true);

create policy "jugadoras_insert_admin"
  on public.jugadoras for insert to authenticated
  with check (public.es_admin());

create policy "jugadoras_update_admin"
  on public.jugadoras for update to authenticated
  using (public.es_admin())
  with check (public.es_admin());

create policy "jugadoras_delete_admin"
  on public.jugadoras for delete to authenticated
  using (public.es_admin());

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
  fecha_partido date,
  hora_inicio time,
  hora_convocatoria time,
  ubicacion text,
  ubicacion_url text,
  tipo public.tipo_partido not null default 'liga',
  jornada integer,
  fase_actual public.estado_partido not null default 'pre_partido',
  puntos_local integer not null default 0,
  puntos_visitante integer not null default 0,
  creado_por uuid references public.perfiles (id)
);

create index partidos_equipo_local_id_idx on public.partidos (equipo_local_id);
create index partidos_equipo_visitante_id_idx on public.partidos (equipo_visitante_id);

alter table public.partidos enable row level security;

create policy "partidos_select_public"
  on public.partidos for select to public using (true);

create policy "partidos_insert_admin"
  on public.partidos for insert to authenticated
  with check (public.es_admin());

create policy "partidos_update_admin"
  on public.partidos for update to authenticated
  using (public.es_admin())
  with check (public.es_admin());

create policy "partidos_delete_admin"
  on public.partidos for delete to authenticated
  using (public.es_admin());

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
create type public.estado_convocatoria as enum ('convocada', 'lesionada', 'ausente');

create table public.convocatorias (
  partido_id uuid not null references public.partidos (id) on delete cascade,
  jugadora_id uuid not null references public.jugadoras (id) on delete cascade,
  titular boolean not null default false,
  minutos_jugados integer not null default 0,
  estado public.estado_convocatoria not null default 'convocada',
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
create type public.fase_juego as enum ('pre_partido', 'primera_parte', 'segunda_parte', 'final');

create table public.estadisticas_jugadora (
  id uuid primary key default gen_random_uuid(),
  partido_id uuid not null references public.partidos (id) on delete cascade,
  jugadora_id uuid not null references public.jugadoras (id) on delete cascade,
  fase public.fase_juego not null,
  segundos integer not null default 0,
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

alter table public.estadisticas_jugadora
  add constraint estadisticas_jugadora_partido_jugadora_fase_key
  unique (partido_id, jugadora_id, fase);

alter table public.estadisticas_jugadora enable row level security;

create policy "estadisticas_jugadora_select_public"
  on public.estadisticas_jugadora for select to public using (true);

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
  rebotes_ofensivos integer,
  rebotes_defensivos integer,
  perdidas integer,
  robos integer,
  autor_id uuid references public.perfiles (id),
  created_at timestamptz not null default now()
);

create index estadisticas_equipo_partido_id_idx on public.estadisticas_equipo (partido_id);

alter table public.estadisticas_equipo
  add constraint estadisticas_equipo_partido_fase_lado_key
  unique (partido_id, fase, lado);

alter table public.estadisticas_equipo enable row level security;

create policy "estadisticas_equipo_select_public"
  on public.estadisticas_equipo for select to public using (true);

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

create policy "comentarios_delete_admin_editor"
  on public.comentarios for delete to authenticated
  using (public.es_admin_o_editor());

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
-- 11. objetivos (entrenamientos)
-- =========================================================
create table public.objetivos (
  id uuid primary key default gen_random_uuid(),
  categoria text not null,
  titulo text not null,
  descripcion text,
  orden integer not null default 0,
  en_trabajo boolean not null default false,
  valor_actual smallint check (valor_actual between 1 and 5),
  creado_por uuid references public.perfiles (id),
  created_at timestamptz not null default now()
);

create index objetivos_categoria_orden_idx on public.objetivos (categoria, orden);

alter table public.objetivos enable row level security;

create policy "objetivos_select_authenticated"
  on public.objetivos for select to authenticated using (true);

create policy "objetivos_insert_admin_editor"
  on public.objetivos for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "objetivos_update_admin_editor"
  on public.objetivos for update to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());

create policy "objetivos_delete_admin"
  on public.objetivos for delete to authenticated
  using (public.es_admin());

create table public.objetivos_valoraciones (
  id uuid primary key default gen_random_uuid(),
  objetivo_id uuid not null references public.objetivos (id) on delete cascade,
  valor smallint not null check (valor between 1 and 5),
  autor_id uuid references public.perfiles (id),
  created_at timestamptz not null default now()
);

create index objetivos_valoraciones_objetivo_id_idx on public.objetivos_valoraciones (objetivo_id);

alter table public.objetivos_valoraciones enable row level security;

create policy "objetivos_valoraciones_select_authenticated"
  on public.objetivos_valoraciones for select to authenticated using (true);

create policy "objetivos_valoraciones_insert_admin_editor"
  on public.objetivos_valoraciones for insert to authenticated
  with check (public.es_admin_o_editor());

-- Catálogo inicial de objetivos del club, por categoría.
insert into public.objetivos (categoria, titulo, orden) values
  ('Técnica individual ataque', 'Tiro en suspensión (distancias cortas)', 1),
  ('Técnica individual ataque', 'Técnica de tiro tras bote', 2),
  ('Técnica individual ataque', 'Recepción de pívot en poste medio/bajo', 3),
  ('Técnica individual ataque', 'Bote tras recepción de espaldas al aro', 4),
  ('Técnica individual defensa', 'Posición defensiva sin manos', 5),
  ('Técnica individual defensa', 'No relajación sin balón: negar línea de pase', 6),
  ('Técnica individual defensa', 'Cobertura y ayuda corta', 7),
  ('Técnica individual defensa', 'Lado débil activo', 8),
  ('Técnica individual defensa', 'Defensa de los cortes y del pasar y cortar', 9),
  ('Técnica individual defensa', 'Concepto de línea de balón', 10),
  ('Técnica individual defensa', 'Closeout en desventaja defensiva', 11),
  ('Técnica individual defensa', 'Defensa de interiores: por delante o 3/4', 12),
  ('Táctica colectiva ataque', '1x1 sin balón: leer la ayuda de su defensora', 13),
  ('Táctica colectiva ataque', 'Dar línea de pase a compañera que penetra', 14),
  ('Táctica colectiva ataque', '1x1 contra defensora recuperando', 15),
  ('Táctica colectiva ataque', '1x1 exterior durante el bote', 16),
  ('Táctica colectiva ataque', '2x2: pase mano a mano tras bote', 17),
  ('Táctica colectiva ataque', 'Aplicación del paso 0 en pase mano a mano', 18),
  ('Táctica colectiva ataque', '2x2 + dividir y pasar/finalizar', 19),
  ('Táctica colectiva ataque', '2x2 + aclarado', 20),
  ('Táctica colectiva ataque', '2x2 + cambio de lado', 21),
  ('Táctica colectiva ataque', '2x2 + puerta atrás', 22),
  ('Táctica colectiva ataque', '2x2 + pasar y cortar', 23),
  ('Táctica colectiva ataque', '2x2 + juego de la L', 24),
  ('Táctica colectiva ataque', 'Contraataque: pase de salida en diagonal', 25),
  ('Táctica colectiva ataque', 'Contraataque: ocupación 5 calles y trailer', 26),
  ('Táctica colectiva ataque', 'Contraataque: igualdad numérica (2º ataque)', 27),
  ('Táctica colectiva ataque', 'Salida de presión (sistema preestablecido)', 28),
  ('Táctica colectiva ataque', 'Ataque libre: equilibrio de espacios/córner', 29),
  ('Táctica colectiva ataque', 'Ataque libre: leer y reaccionar sin balón', 30),
  ('Táctica colectiva defensa', 'Anticipación defensiva al pase/bote', 31),
  ('Táctica colectiva defensa', 'Triángulos defensivos: 1ª ayuda (o a la penetración)', 32),
  ('Táctica colectiva defensa', '2ª ayuda defensiva', 33),
  ('Táctica colectiva defensa', 'Defensa del bloqueo directo: receptora', 34),
  ('Táctica colectiva defensa', 'Defensa del bloqueo directo: bloqueadora', 35),
  ('Táctica colectiva defensa', 'Defensa del bloqueo directo: última jugadora', 36),
  ('Táctica colectiva defensa', 'Defensa del bloqueo directo: cambio', 37),
  ('Táctica colectiva defensa', 'Defensa pase mano a mano: cambio', 38),
  ('Táctica colectiva defensa', 'Defensa pase mano a mano: arriba y mostrándose', 39),
  ('Táctica colectiva defensa', 'Situación defensiva + pasar y cortar', 40),
  ('Táctica colectiva defensa', 'Situación defensiva + puerta atrás', 41),
  ('Táctica colectiva defensa', 'Defensa de inferioridad 3x4', 42),
  ('Táctica colectiva defensa', 'Defensa individual medio campo: penetraciones', 43),
  ('Táctica colectiva defensa', 'Defensa individual medio campo: pase lado a lado', 44),
  ('Táctica colectiva defensa', 'Defensa individual todo el campo', 45),
  ('Táctica colectiva defensa', 'Áreas de juego: 4x4 espacios', 46),
  ('Físicos', 'Coordinación óptico-motriz y dinámica general', 47),
  ('Físicos', 'Agilidad y cambios de dirección', 48),
  ('Físicos', 'Velocidad de reacción y aceleración', 49),
  ('Físicos', 'Equilibrio y propiocepción (prevención lesiones)', 50),
  ('Físicos', 'Fuerza general con el propio peso corporal', 51),
  ('Físicos', 'Flexibilidad y movilidad articular', 52),
  ('Físicos', 'Resistencia aeróbica de base (mediante el juego)', 53),
  ('Actitudinales', 'Actitud competitiva sana, sin ansiedad', 54),
  ('Actitudinales', 'Trabajo en equipo y compañerismo', 55),
  ('Actitudinales', 'Deportividad: respeto a rivales/árbitros/normas', 56),
  ('Actitudinales', 'Esfuerzo y constancia en el entrenamiento', 57),
  ('Actitudinales', 'Responsabilidad y compromiso (puntualidad, material)', 58),
  ('Actitudinales', 'Gestión de la frustración ante el error', 59),
  ('Actitudinales', 'Dar la mano a los entrenadores al final del entrenamiento', 60),
  ('Actitudinales', 'Dejar las mochilas juntas en el fondo de la pista', 61),
  ('Higiénicos', 'Calentamiento general y específico', 62),
  ('Higiénicos', 'Vuelta a la calma y estiramientos', 63),
  ('Higiénicos', 'Hidratación antes/durante/después', 64),
  ('Higiénicos', 'Hábitos de descanso y sueño', 65),
  ('Higiénicos', 'Alimentación básica en días de entreno/partido', 66),
  ('Higiénicos', 'Cuidado del material y prevención de lesiones', 67);

-- =========================================================
-- 12. sesiones_entrenamiento
-- =========================================================
create table public.sesiones_entrenamiento (
  id uuid primary key default gen_random_uuid(),
  fecha date not null unique,
  contenido text,
  autor_id uuid references public.perfiles (id),
  created_at timestamptz not null default now()
);

alter table public.sesiones_entrenamiento enable row level security;

create policy "sesiones_entrenamiento_select_authenticated"
  on public.sesiones_entrenamiento for select to authenticated using (true);

create policy "sesiones_entrenamiento_insert_admin_editor"
  on public.sesiones_entrenamiento for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "sesiones_entrenamiento_update_admin_editor"
  on public.sesiones_entrenamiento for update to authenticated
  using (public.es_admin_o_editor())
  with check (public.es_admin_o_editor());

-- =========================================================
-- 13. sesion_objetivos
-- =========================================================
create table public.sesion_objetivos (
  fecha date not null references public.sesiones_entrenamiento (fecha) on delete cascade,
  objetivo_id uuid not null references public.objetivos (id) on delete cascade,
  primary key (fecha, objetivo_id)
);

create index sesion_objetivos_objetivo_id_idx on public.sesion_objetivos (objetivo_id);

alter table public.sesion_objetivos enable row level security;

create policy "sesion_objetivos_select_authenticated"
  on public.sesion_objetivos for select to authenticated using (true);

create policy "sesion_objetivos_insert_admin_editor"
  on public.sesion_objetivos for insert to authenticated
  with check (public.es_admin_o_editor());

create policy "sesion_objetivos_delete_admin_editor"
  on public.sesion_objetivos for delete to authenticated
  using (public.es_admin_o_editor());

-- =========================================================
-- Nota: crear el primer admin (ejecutar aparte, después de que ese
-- usuario ya exista en auth.users -- lo crea el admin desde
-- Authentication → Users con email + contraseña -- y el trigger le haya
-- creado su perfil viewer; este UPDATE lo asciende a admin):
--
-- update public.perfiles set rol = 'admin' where id = '<uuid-del-usuario>';
-- =========================================================
