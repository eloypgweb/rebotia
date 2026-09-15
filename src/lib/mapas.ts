export function enlaceMapa(nombre: string, url?: string | null) {
  if (url) return url;

  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(nombre)}`;
}
