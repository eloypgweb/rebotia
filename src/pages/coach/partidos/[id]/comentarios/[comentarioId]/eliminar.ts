import type { APIRoute } from 'astro';

const FASE_A_RUTA: Record<string, string> = {
  pre_partido: 'pre-partido',
  primera_parte: 'descanso',
  segunda_parte: 'descanso',
  final: 'post-partido',
};

export const POST: APIRoute = async ({ params, locals, redirect }) => {
  const { data: comentario } = await locals.supabase
    .from('comentarios')
    .select('fase')
    .eq('id', params.comentarioId)
    .single();

  await locals.supabase.from('comentarios').delete().eq('id', params.comentarioId);

  const destino = FASE_A_RUTA[comentario?.fase ?? ''] ?? 'pre-partido';
  return redirect(`/coach/partidos/${params.id}/${destino}`);
};
