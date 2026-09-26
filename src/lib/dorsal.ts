// Ordena por número; el "00" va antes que el "0"; sin dorsal al final.
export function compararDorsal(a: string | null, b: string | null) {
  if (a == null && b == null) return 0;
  if (a == null) return 1;
  if (b == null) return -1;
  return Number(a) - Number(b) || b.length - a.length;
}

export function normalizarDorsal(texto: string | null | undefined) {
  const limpio = (texto ?? '').trim();
  return /^\d{1,2}$/.test(limpio) ? limpio : null;
}
