export function formatearTiempo(segundos: number) {
  const total = Math.max(0, Math.round(segundos));
  const minutos = Math.floor(total / 60);
  const resto = total % 60;
  return `${minutos}:${String(resto).padStart(2, '0')}`;
}

// Acepta "12:30" (min:seg) o "12" (solo minutos). Devuelve segundos.
export function parsearTiempo(texto: string | null | undefined) {
  const limpio = (texto ?? '').trim();
  if (!limpio) return 0;

  const [minutosTexto, segundosTexto] = limpio.split(':');
  const minutos = Number(minutosTexto);
  const segundos = segundosTexto === undefined ? 0 : Number(segundosTexto);

  if (!Number.isFinite(minutos) || !Number.isFinite(segundos) || minutos < 0 || segundos < 0) return 0;
  return Math.round(minutos * 60 + Math.min(segundos, 59));
}
