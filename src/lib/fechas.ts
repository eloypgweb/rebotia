const formateadorFechaCompleta = new Intl.DateTimeFormat('es-ES', { dateStyle: 'full' });
const formateadorFechaMedia = new Intl.DateTimeFormat('es-ES', { dateStyle: 'medium' });

function aFecha(fechaPartido: string) {
  return new Date(`${fechaPartido}T00:00:00`);
}

export function formatearDia(fechaPartido: string | null, estilo: 'completo' | 'medio' = 'medio') {
  if (!fechaPartido) return null;
  const formateador = estilo === 'completo' ? formateadorFechaCompleta : formateadorFechaMedia;
  return formateador.format(aFecha(fechaPartido));
}

export function formatearHora(hora: string | null) {
  return hora ? hora.slice(0, 5) : null;
}

export const HORARIO_POR_DEFINIR = 'Horario aún por definir';
