function offsetMadridHoras(fecha: string): number {
  const referencia = new Date(`${fecha}T12:00:00Z`);
  const formateador = new Intl.DateTimeFormat('en-US', { timeZone: 'Europe/Madrid', timeZoneName: 'shortOffset' });
  const parte = formateador.formatToParts(referencia).find((p) => p.type === 'timeZoneName')?.value ?? 'GMT+1';
  const coincidencia = parte.match(/GMT([+-]\d+)/);
  return coincidencia ? parseInt(coincidencia[1], 10) : 1;
}

function aFechaHoraUtc(fecha: string, hora: string): Date {
  const offset = offsetMadridHoras(fecha);
  const [horas, minutos] = hora.split(':').map(Number);
  const utc = new Date(`${fecha}T00:00:00Z`);
  utc.setUTCHours(horas - offset, minutos, 0, 0);
  return utc;
}

function formatearFechaHoraICS(fecha: Date): string {
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${fecha.getUTCFullYear()}${pad(fecha.getUTCMonth() + 1)}${pad(fecha.getUTCDate())}T${pad(fecha.getUTCHours())}${pad(fecha.getUTCMinutes())}00Z`;
}

function escaparTexto(texto: string): string {
  return texto.replace(/\\/g, '\\\\').replace(/;/g, '\\;').replace(/,/g, '\\,').replace(/\n/g, '\\n');
}

function plegarLinea(linea: string): string {
  if (linea.length <= 75) return linea;
  const partes: string[] = [];
  let resto = linea;
  while (resto.length > 75) {
    partes.push(resto.slice(0, 75));
    resto = resto.slice(75);
  }
  partes.push(resto);
  return partes.join('\r\n ');
}

interface DatosEventoPartido {
  id: string;
  resumen: string;
  fecha: string;
  hora: string;
  ubicacion: string | null;
  descripcion: string;
}

export function generarIcsPartido(datos: DatosEventoPartido): string {
  const dtstamp = formatearFechaHoraICS(new Date());

  const inicio = aFechaHoraUtc(datos.fecha, datos.hora);
  const fin = new Date(inicio.getTime() + 2 * 60 * 60 * 1000);

  const lineas = [
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//Rebotia//Calendario de partidos//ES',
    'CALSCALE:GREGORIAN',
    'BEGIN:VEVENT',
    `UID:partido-${datos.id}@rebotia`,
    `DTSTAMP:${dtstamp}`,
    `DTSTART:${formatearFechaHoraICS(inicio)}`,
    `DTEND:${formatearFechaHoraICS(fin)}`,
    `SUMMARY:${escaparTexto(datos.resumen)}`,
    ...(datos.ubicacion ? [`LOCATION:${escaparTexto(datos.ubicacion)}`] : []),
    `DESCRIPTION:${escaparTexto(datos.descripcion)}`,
    'END:VEVENT',
    'END:VCALENDAR',
  ];

  return lineas.map(plegarLinea).join('\r\n') + '\r\n';
}
