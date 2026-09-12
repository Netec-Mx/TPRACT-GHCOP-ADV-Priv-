using System;

namespace Pe.PasarelaAndina.Modelo
{
    /// <summary>
    /// Venta autorizada a traves de la pasarela.
    /// </summary>
    public class Transaccion
    {
        public string Id { get; set; }
        public string IdComercio { get; set; }
        public double Monto { get; set; }
        public string Moneda { get; set; }
        public DateTime FechaHora { get; set; }
        public MedioPago MedioPago { get; set; }
        public int Cuotas { get; set; }
        public EstadoTransaccion Estado { get; set; }
        public string CodigoAutorizacion { get; set; }

        public Transaccion()
        {
        }

        public Transaccion(string id, string idComercio, double monto, string moneda,
                           DateTime fechaHora, MedioPago medioPago, int cuotas,
                           EstadoTransaccion estado, string codigoAutorizacion)
        {
            Id = id;
            IdComercio = idComercio;
            Monto = monto;
            Moneda = moneda;
            FechaHora = fechaHora;
            MedioPago = medioPago;
            Cuotas = cuotas;
            Estado = estado;
            CodigoAutorizacion = codigoAutorizacion;
        }

        public override string ToString()
        {
            return "Transaccion{" + Id + ", " + IdComercio + ", " + Monto + ", " + Estado + "}";
        }
    }
}
