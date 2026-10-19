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
