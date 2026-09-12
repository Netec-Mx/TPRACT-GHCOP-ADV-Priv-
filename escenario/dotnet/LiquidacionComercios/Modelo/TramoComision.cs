namespace Pe.PasarelaAndina.Modelo
{
    /// <summary>
    /// Tramo de un tarifario. Define el porcentaje que se aplica a las
    /// transacciones cuyo monto cae dentro del rango.
    /// </summary>
    public class TramoComision
    {
        public double MontoDesde { get; set; }
        public double MontoHasta { get; set; }
        public double Porcentaje { get; set; }

        public TramoComision()
        {
        }

        public TramoComision(double montoDesde, double montoHasta, double porcentaje)
        {
            MontoDesde = montoDesde;
            MontoHasta = montoHasta;
            Porcentaje = porcentaje;
        }

        public override string ToString()
        {
            return "Tramo[" + MontoDesde + " - " + MontoHasta + " = " + Porcentaje + "%]";
        }
    }
}
