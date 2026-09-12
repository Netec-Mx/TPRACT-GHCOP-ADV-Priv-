using Pe.PasarelaAndina.Modelo;
using Pe.PasarelaAndina.Util;

namespace Pe.PasarelaAndina.Calculo
{
    /// <summary>
    /// Calculo de la comision de una transaccion individual.
    ///
    /// El monto incluye el impuesto general a las ventas, de modo que la comision
    /// se aplica sobre el valor de venta neto y no sobre el total facturado.
    /// </summary>
    public class CalculadoraComision
    {
        /// <summary>
        /// Determina el tramo del tarifario en el que cae un monto.
        /// </summary>
        public TramoComision DeterminarTramo(PlanComisiones plan, double monto)
        {
            if (plan == null || plan.Tramos.Count == 0)
            {
                return null;
            }
            foreach (TramoComision tramo in plan.Tramos)
            {
                if (monto >= tramo.MontoDesde && monto <= tramo.MontoHasta)
                {
                    return tramo;
                }
            }
            return plan.Tramos[plan.Tramos.Count - 1];
        }

        /// <summary>
        /// Comision base de una transaccion, sin recargo por cuotas.
        /// </summary>
        public double CalcularComisionBase(PlanComisiones plan, Transaccion transaccion)
        {
            TramoComision tramo = DeterminarTramo(plan, transaccion.Monto);
            if (tramo == null)
            {
                return 0.0;
            }
            double porcentaje = tramo.Porcentaje;
            double comision = transaccion.Monto * porcentaje / 100.0;
            comision = comision + plan.MontoFijoPorTransaccion;
            return comision;
        }

        /// <summary>
        /// Recargo por venta en cuotas. Medio punto porcentual por cada cuota
        /// posterior a la primera, con tope de tres puntos.
        /// </summary>
        public double CalcularRecargoCuotas(double comisionBase, int cuotas)
        {
            if (cuotas <= 1)
            {
                return 0.0;
            }
            double porcentajeRecargo = (cuotas - 1) * 0.5;
            if (porcentajeRecargo > 3.5)
            {
                porcentajeRecargo = 3.5;
            }
            return comisionBase * porcentajeRecargo / 100.0;
        }

        /// <summary>
        /// Comision total de una transaccion, con recargo por cuotas incluido.
        /// </summary>
        public double CalcularComisionTotal(PlanComisiones plan, Transaccion transaccion)
        {
            double comisionBase = CalcularComisionBase(plan, transaccion);
            double recargo = CalcularRecargoCuotas(comisionBase, transaccion.Cuotas);
            return comisionBase + recargo;
        }

        /// <summary>
        /// Redondea un monto a dos decimales, con medio hacia arriba.
        /// </summary>
        public double Redondear(double monto)
        {
            return CompatibilidadJava.RedondearADosDecimales(monto);
        }
    }
}
