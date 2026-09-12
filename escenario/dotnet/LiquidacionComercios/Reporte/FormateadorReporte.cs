using System.Collections.Generic;
using System.Globalization;
using System.Text;

using Pe.PasarelaAndina.Modelo;
using Pe.PasarelaAndina.Util;

namespace Pe.PasarelaAndina.Reporte
{
    /// <summary>
    /// Arma la representacion en texto de las liquidaciones para su revision.
    /// </summary>
    public class FormateadorReporte
    {
        private const string Separador =
                "----------------------------------------------------------";

        public string FormatearResumenGeneral(List<Liquidacion> liquidaciones)
        {
            StringBuilder texto = new StringBuilder();

            double sumaTransado = 0.0;
            double sumaComisiones = 0.0;
            double sumaContracargos = 0.0;
            double sumaRetenciones = 0.0;
            double sumaNeto = 0.0;
            int sumaTransacciones = 0;
            int conTope = 0;

            foreach (Liquidacion liquidacion in liquidaciones)
            {
                sumaTransado += liquidacion.TotalTransado;
                sumaComisiones += liquidacion.TotalComisiones;
                sumaContracargos += liquidacion.TotalContracargos;
                sumaRetenciones += liquidacion.Retenciones;
                sumaNeto += liquidacion.ObtenerMontoNeto();
                sumaTransacciones += liquidacion.CantidadTransacciones;
                if (liquidacion.TopeAplicado)
                {
                    conTope++;
                }
            }

            texto.Append(Separador).Append("\n");
            texto.Append("  RESUMEN DEL PERIODO\n");
            texto.Append(Separador).Append("\n");
            texto.Append("  Comercios liquidados      : ").Append(liquidaciones.Count).Append("\n");
            texto.Append("  Transacciones liquidadas  : ").Append(sumaTransacciones).Append("\n");
            texto.Append("  Comercios con tope        : ").Append(conTope).Append("\n");
            texto.Append("  Total transado            : S/ ").Append(Monto(sumaTransado)).Append("\n");
            texto.Append("  Total comisiones          : S/ ").Append(Monto(sumaComisiones)).Append("\n");
            texto.Append("  Total contracargos        : S/ ").Append(Monto(sumaContracargos)).Append("\n");
            texto.Append("  Total retenciones         : S/ ").Append(Monto(sumaRetenciones)).Append("\n");
            texto.Append("  Total neto a pagar        : S/ ").Append(Monto(sumaNeto)).Append("\n");
            texto.Append(Separador).Append("\n");

            return texto.ToString();
        }

        public string FormatearDetalle(Liquidacion liquidacion, int maximoLineas)
        {
            StringBuilder texto = new StringBuilder();

            texto.Append(Separador).Append("\n");
            texto.Append("  DETALLE DE ").Append(liquidacion.IdComercio);
            texto.Append(" - ").Append(liquidacion.RazonSocial).Append("\n");
            texto.Append("  Periodo ").Append(liquidacion.Periodo).Append("\n");
            texto.Append(Separador).Append("\n");
            texto.Append(string.Format(CultureInfo.InvariantCulture, "  {0,-12} {1,12} {2,10} {3,10} {4,8}\n",
                    "TRANSACCION", "MONTO", "COMISION", "RECARGO", "CUOTAS"));

            int impresas = 0;
            foreach (DetalleLiquidacion linea in liquidacion.Detalle)
            {
                if (impresas >= maximoLineas)
                {
                    texto.Append("  ... y ")
                         .Append(liquidacion.Detalle.Count - impresas)
                         .Append(" lineas mas\n");
                    break;
                }
                texto.Append(string.Format(CultureInfo.InvariantCulture, "  {0,-12} {1,12} {2,10} {3,10} {4,8}\n",
                        linea.IdTransaccion,
                        Monto(linea.MontoTransaccion),
                        Monto(linea.ComisionTotal),
                        Monto(linea.RecargoCuotas),
                        linea.Cuotas));
                impresas++;
            }

            texto.Append(Separador).Append("\n");
            return texto.ToString();
        }

        private string Monto(double valor)
        {
            return CompatibilidadJava.FormatearDosDecimales(valor);
        }
    }
}
