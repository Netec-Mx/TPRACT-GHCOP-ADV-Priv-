using System;
using System.Collections.Generic;

namespace Pe.PasarelaAndina.Modelo
{
    /// <summary>
    /// Resultado del proceso de cierre para un comercio en un periodo.
    /// </summary>
    public class Liquidacion
    {
        private double montoNeto;

        public string IdComercio { get; set; }
        public string RazonSocial { get; set; }
        public string Periodo { get; set; }
        public double TotalTransado { get; set; }
        public double TotalComisiones { get; set; }
        public double TotalContracargos { get; set; }
        public double Retenciones { get; set; }
        public DateTime FechaGeneracion { get; set; }
        public int CantidadTransacciones { get; set; }
        public bool TopeAplicado { get; set; }
        public List<DetalleLiquidacion> Detalle { get; set; } = new List<DetalleLiquidacion>();

        public Liquidacion()
        {
        }

        /// <summary>
        /// Devuelve el monto neto a pagar al comercio.
        /// </summary>
        public double ObtenerMontoNeto()
        {
            montoNeto = TotalTransado - TotalComisiones - TotalContracargos - Retenciones;
            return montoNeto;
        }

        public void EstablecerMontoNeto(double valor)
        {
            montoNeto = valor;
        }

        public void AgregarDetalle(DetalleLiquidacion linea)
        {
            Detalle.Add(linea);
        }

        public override string ToString()
        {
            return "Liquidacion{" + IdComercio + ", " + Periodo + ", neto=" + montoNeto + "}";
        }
    }
}
