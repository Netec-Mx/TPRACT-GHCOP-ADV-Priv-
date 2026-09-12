using System;
using System.Globalization;

namespace Pe.PasarelaAndina.Calculo
{
    /// <summary>
    /// Manejo de fechas del proceso de liquidacion.
    ///
    /// El periodo corre desde el primer dia del mes a las cero horas hasta el
    /// ultimo dia a las 23:59:59, en hora de Lima.
    /// </summary>
    public class UtilidadesFecha
    {
        private const string FormatoFechaHora = "yyyy-MM-dd HH:mm:ss";
        private const string FormatoFecha = "yyyy-MM-dd";

        public DateTime ParsearFechaHora(string texto)
        {
            DateTime resultado;
            if (DateTime.TryParseExact(texto, FormatoFechaHora,
                    CultureInfo.InvariantCulture, DateTimeStyles.None, out resultado))
            {
                return resultado;
            }
            return DateTime.MinValue;
        }

        public DateTime ParsearFecha(string texto)
        {
            DateTime resultado;
            if (DateTime.TryParseExact(texto, FormatoFecha,
                    CultureInfo.InvariantCulture, DateTimeStyles.None, out resultado))
            {
                return resultado;
            }
            return DateTime.MinValue;
        }

        public string FormatearFechaHora(DateTime fecha)
        {
            if (fecha == DateTime.MinValue)
            {
                return "";
            }
            return fecha.ToString(FormatoFechaHora, CultureInfo.InvariantCulture);
        }

        public string FormatearFecha(DateTime fecha)
        {
            if (fecha == DateTime.MinValue)
            {
                return "";
            }
            return fecha.ToString(FormatoFecha, CultureInfo.InvariantCulture);
        }

        /// <summary>
        /// Primer instante del periodo indicado en formato aaaa-mm.
        /// </summary>
        public DateTime InicioDePeriodo(string periodo)
        {
            int anio = int.Parse(periodo.Substring(0, 4), CultureInfo.InvariantCulture);
            int mes = int.Parse(periodo.Substring(5, 2), CultureInfo.InvariantCulture);

            return new DateTime(anio, mes, 1, 0, 0, 0);
        }

        /// <summary>
        /// Ultimo instante del periodo indicado en formato aaaa-mm.
        /// </summary>
        public DateTime FinDePeriodo(string periodo)
        {
            int anio = int.Parse(periodo.Substring(0, 4), CultureInfo.InvariantCulture);
            int mes = int.Parse(periodo.Substring(5, 2), CultureInfo.InvariantCulture);

            int ultimoDia = DateTime.DaysInMonth(anio, mes);
            return new DateTime(anio, mes, ultimoDia, 23, 59, 59);
        }

        /// <summary>
        /// Indica si la fecha cae dentro del periodo.
        /// </summary>
        public bool EstaEnPeriodo(DateTime fecha, string periodo)
        {
            if (fecha == DateTime.MinValue)
            {
                return false;
            }
            DateTime inicio = InicioDePeriodo(periodo);
            DateTime fin = FinDePeriodo(periodo);
            return fecha >= inicio && fecha <= fin;
        }

        /// <summary>
        /// Meses completos transcurridos entre dos fechas.
        /// </summary>
        public int MesesEntre(DateTime desde, DateTime hasta)
        {
            if (desde == DateTime.MinValue || hasta == DateTime.MinValue)
            {
                return 0;
            }

            int anios = hasta.Year - desde.Year;
            int meses = hasta.Month - desde.Month;
            int total = anios * 12 + meses;

            if (hasta.Day < desde.Day)
            {
                total = total - 1;
            }
            return total;
        }

        public string PeriodoDe(DateTime fecha)
        {
            if (fecha == DateTime.MinValue)
            {
                return "";
            }
            int anio = fecha.Year;
            int mes = fecha.Month;
            return anio + "-" + (mes < 10 ? "0" + mes : mes.ToString(CultureInfo.InvariantCulture));
        }
    }
}
