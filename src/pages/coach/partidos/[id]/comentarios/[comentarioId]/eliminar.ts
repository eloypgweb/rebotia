import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ params, locals, redirect }) => {
  await locals.supabase.from('comentarios').delete().eq('id', params.comentarioId);

  return redirect(`/coach/partidos/${params.id}/pre-partido`);
};
