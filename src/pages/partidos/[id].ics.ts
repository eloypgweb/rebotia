import type { APIRoute } from 'astro';
import { generarIcsPartido } from '../../lib/ics';
import { enlaceMapa } from '../../lib/mapas';

export const GET: APIRoute = async ({ params, locals }) => {
  const { data: partido } = await locals.supabase
    .from('partidos')
    .select(
      'fecha_partido, hora_inicio, hora_convocatoria, ubicacion, ubicacion_url, tipo, jornada, local:equipo_local_id(nombre), visitante:equipo_visitante_id(nombre)',
    )
    .eq('id', params.id)
    .single();

  if (!partido || !partido.fecha_partido) {
    return new Response('Este partido todavía no tiene fecha definida.', { status: 404 });
  }

  const resumen = `${partido.local?.nombre ?? '¿?'} vs ${partido.visitante?.nombre ?? '¿?'}`;

  const detalles: string[] = [];
  if (partido.hora_convocatoria) detalles.push(`Convocatoria: ${partido.hora_convocatoria.slice(0, 5)}`);
  if (partido.hora_inicio) detalles.push(`Inicio del partido: ${partido.hora_inicio.slice(0, 5)}`);
  detalles.push(
    partido.tipo === 'amistoso' ? 'Amistoso' : `Liga${partido.jornada != null ? ` · Jornada ${partido.jornada}` : ''}`,
  );
  if (partido.ubicacion) {
    detalles.push(`Ubicación: ${partido.ubicacion} — ${enlaceMapa(partido.ubicacion, partido.ubicacion_url)}`);
  }

  const ics = generarIcsPartido({
    id: String(params.id),
    resumen,
    fecha: partido.fecha_partido,
    hora: partido.hora_convocatoria ?? partido.hora_inicio ?? null,
    ubicacion: partido.ubicacion,
    descripcion: detalles.join('\n'),
  });

  return new Response(ics, {
    headers: { 'Content-Type': 'text/calendar; charset=utf-8' },
  });
};
