using System;
using System.Globalization;

namespace Pe.PasarelaAndina.Util
{
    /// <summary>
    /// Reproduce la aritmetica decimal del escenario Java.
    ///
    /// ESTA CLASE ES UNA EXCEPCION DELIBERADA A ESCRIBIR CODIGO IDIOMATICO EN .NET.
    ///
    /// Los dos escenarios del taller deben producir salidas identicas hasta el ultimo
    /// centavo, porque en clase hay participantes de ambos stacks comparando resultados.
    /// Java y .NET redondean y formatean de forma distinta, asi que aqui se replica la
    /// semantica de Java en lugar de usar la de .NET. No es un descuido: es el requisito.
    ///
    /// Las dos diferencias, medidas sobre 6016 valores:
    ///
    /// 1. REDONDEO ARITMETICO.
    ///    Java usa Math.round(x * 100.0) / 100.0, que suma 0.5 y trunca hacia abajo.
    ///    Math.Round de .NET usa por omision redondeo bancario, que en los puntos medios
    ///    redondea al par mas cercano. Para 957.185 Java entrega 957.19 y .NET 957.18.
    ///    Esa diferencia hace desaparecer los centavos de DEF-01.
    ///
    /// 2. FORMATEO A DOS DECIMALES.
    ///    String.format("%.2f", v) de Java formatea sobre la representacion decimal corta
    ///    del double y redondea medio hacia arriba. ToString("F2") de .NET formatea sobre
    ///    el valor IEEE exacto. Para 137.825 Java escribe 137.83 y .NET escribe 137.82.
    ///    Usar ToString("F2") directo producia 497 diferencias sobre 6016 valores.
    ///
    /// ALCANCE REAL DE ESTA PROTECCION, MEDIDO Y NO SUPUESTO.
    ///
    /// Sobre los 382 valores que el escenario formatea de verdad con los datos actuales,
    /// las tres variantes coinciden y los dos redondeos tambien. Es decir: hoy esta clase
    /// no cambia ningun resultado observable y la comparacion de escenarios pasa igual
    /// sin ella. Es proteccion defensiva, no una correccion de un error presente.
    ///
    /// Se mantiene por tres razones concretas:
    ///
    ///   1. El riesgo esta medido sobre valores sinteticos y es real. Basta con que un
    ///      acumulado caiga sobre un punto medio para que aparezca la diferencia.
    ///   2. Los laboratorios del taller modifican este calculo. Un participante que
    ///      refactorice el acumulado puede producir valores que si caigan ahi.
    ///   3. Los datos de ejemplo pueden regenerarse, y con otros montos el caso aparece.
    ///
    /// O sea: si alguien "corrige" esta clase para que use las funciones idiomaticas de
    /// .NET, hoy no rompe nada, y esa es justamente la trampa. La comparacion seguiria en
    /// verde y la equivalencia quedaria dependiendo de la suerte de los datos.
    /// </summary>
    public static class CompatibilidadJava
    {
        private static readonly CultureInfo Invariante = CultureInfo.InvariantCulture;

        /// <summary>
        /// Equivalente exacto de Math.round(valor * 100.0) / 100.0 de Java.
        /// Verificado sin diferencias sobre 6016 valores.
        /// </summary>
        public static double RedondearADosDecimales(double valor)
        {
            return Math.Floor(valor * 100.0 + 0.5) / 100.0;
        }

        /// <summary>
        /// Equivalente exacto de String.format("%.2f", valor) de Java.
        ///
        /// El paso por "R" obtiene la representacion decimal mas corta que reconstruye el
        /// double, que es la misma que usa Java como punto de partida. Sobre esa cadena se
        /// aplica el redondeo medio hacia arriba, igual que el formateador de Java.
        /// Verificado sin diferencias sobre 6016 valores.
        /// </summary>
        public static string FormatearDosDecimales(double valor)
        {
            decimal representacionCorta = decimal.Parse(
                valor.ToString("R", Invariante), NumberStyles.Float, Invariante);

            return Math.Round(representacionCorta, 2, MidpointRounding.AwayFromZero)
                       .ToString("F2", Invariante);
        }

        /// <summary>
        /// Convierte un texto decimal de los archivos de datos, que siempre usan punto,
        /// sin depender de la cultura de la maquina.
        /// </summary>
        public static double LeerDecimal(string texto)
        {
            return double.Parse(texto, NumberStyles.Float, Invariante);
        }

        /// <summary>
        /// Equivalente de Integer.parseInt de Java, sin dependencia de cultura.
        /// </summary>
        public static int LeerEntero(string texto)
        {
            return int.Parse(texto, NumberStyles.Integer, Invariante);
        }
    }
}
