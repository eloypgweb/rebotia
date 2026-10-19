import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ params, locals, redirect }) => {
  if (locals.perfil?.rol !== 'admin') {
    return redirect('/coach/objetivos');
  }

  const { error, count } = await locals.supabase.from('objetivos').delete({ count: 'exact' }).eq('id', params.id);

  if (error) {
    return redirect(`/coach/objetivos?error=${encodeURIComponent(error.message)}`);
  }

  if (!count) {
    return redirect(`/coach/objetivos?error=${encodeURIComponent('No se ha eliminado nada (revisa los permisos).')}`);
  }

  return redirect('/coach/objetivos');
};
