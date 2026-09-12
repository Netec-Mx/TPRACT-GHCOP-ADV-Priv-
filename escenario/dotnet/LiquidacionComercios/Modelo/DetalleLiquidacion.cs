namespace Pe.PasarelaAndina.Modelo
{
    /// <summary>
    /// Linea de la liquidacion. Representa el aporte de una transaccion al
    /// total de comisiones del periodo.
    /// </summary>
    public class DetalleLiquidacion
    {
        public string IdTransaccion { get; set; }
        public double MontoTransaccion { get; set; }
        public double ComisionBase { get; set; }
        public double RecargoCuotas { get; set; }
        public double ComisionTotal { get; set; }
        public int Cuotas { get; set; }
        public string MedioPago { get; set; }
    }
}
