import { createBrowserClient } from '@supabase/ssr';

// Cliente para usar en scripts de cliente (páginas .astro / componentes).
// Guarda la sesión en cookies (no localStorage) para que el middleware y
// las rutas del servidor puedan leerla en cada petición.
export const supabase = createBrowserClient(
  import.meta.env.PUBLIC_SUPABASE_URL,
  import.meta.env.PUBLIC_SUPABASE_KEY,
);
