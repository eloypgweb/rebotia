export const NOMBRES_DIA = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

export function lunesDeFecha(fecha: Date): Date {
  const copia = new Date(fecha);
  copia.setHours(0, 0, 0, 0);
  const diaSemana = copia.getDay();
  const offset = diaSemana === 0 ? -6 : 1 - diaSemana;
  copia.setDate(copia.getDate() + offset);
  return copia;
}

export function sumarDias(fecha: Date, dias: number): Date {
  const copia = new Date(fecha);
  copia.setDate(copia.getDate() + dias);
  return copia;
}

export function aFechaISO(fecha: Date): string {
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${fecha.getFullYear()}-${pad(fecha.getMonth() + 1)}-${pad(fecha.getDate())}`;
}

export function fechaDesdeISO(iso: string): Date {
  return new Date(`${iso}T00:00:00`);
}

// Días de la semana en los que hay entrenamiento: martes, jueves, viernes
// (getDay(): domingo=0, lunes=1, ... sábado=6).
export const DIAS_ENTRENO = [2, 4, 5];

export function esDiaEntreno(fecha: Date): boolean {
  return DIAS_ENTRENO.includes(fecha.getDay());
}

// Numeración de sesiones: el martes 20 de octubre de 2026 es la sesión 29,
// y a partir de ahí se cuenta +1 por cada día de entrenamiento (solo
// martes/jueves/viernes), hacia delante y hacia atrás.
const ANCLA_FECHA_ISO = '2026-10-20';
const ANCLA_NUMERO = 29;

export function numeroSesion(fechaISO: string): number {
  const objetivo = fechaDesdeISO(fechaISO);
  const ancla = fechaDesdeISO(ANCLA_FECHA_ISO);

  let numero = ANCLA_NUMERO;

  if (objetivo.getTime() > ancla.getTime()) {
    let cursor = sumarDias(ancla, 1);
    while (cursor.getTime() <= objetivo.getTime()) {
      if (esDiaEntreno(cursor)) numero++;
      cursor = sumarDias(cursor, 1);
    }
  } else if (objetivo.getTime() < ancla.getTime()) {
    let cursor = sumarDias(ancla, -1);
    while (cursor.getTime() >= objetivo.getTime()) {
      if (esDiaEntreno(cursor)) numero--;
      cursor = sumarDias(cursor, -1);
    }
  }

  return numero;
}
