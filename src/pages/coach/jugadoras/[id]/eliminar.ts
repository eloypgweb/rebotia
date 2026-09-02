import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ params, locals, redirect }) => {
  const { error, count } = await locals.supabase
    .from('jugadoras')
    .delete({ count: 'exact' })
    .eq('id', params.id);

  if (error) {
    return redirect(`/coach/jugadoras?error=${encodeURIComponent(error.message)}`);
  }

  if (!count) {
    return redirect(`/coach/jugadoras?error=${encodeURIComponent('No se ha eliminado nada (revisa los permisos).')}`);
  }

  return redirect('/coach/jugadoras');
};
