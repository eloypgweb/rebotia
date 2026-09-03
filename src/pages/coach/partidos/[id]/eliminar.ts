import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ params, locals, redirect }) => {
  if (locals.perfil?.rol !== 'admin') {
    return redirect('/coach/partidos');
  }

  const { error, count } = await locals.supabase
    .from('partidos')
    .delete({ count: 'exact' })
    .eq('id', params.id);

  if (error) {
    return redirect(`/coach/partidos?error=${encodeURIComponent(error.message)}`);
  }

  if (!count) {
    return redirect(`/coach/partidos?error=${encodeURIComponent('No se ha eliminado nada (revisa los permisos).')}`);
  }

  return redirect('/coach/partidos');
};
