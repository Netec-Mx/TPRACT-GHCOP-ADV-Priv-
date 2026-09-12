package pe.pasarelaandina.calculo;

import pe.pasarelaandina.modelo.PlanComisiones;
import pe.pasarelaandina.modelo.TramoComision;
import pe.pasarelaandina.modelo.Transaccion;

/**
 * Calculo de la comision de una transaccion individual.
 *
 * El monto incluye el impuesto general a las ventas, de modo que la comision
 * se aplica sobre el valor de venta neto y no sobre el total facturado.
 */
public class CalculadoraComision {

    /**
     * Determina el tramo del tarifario en el que cae un monto.
     */
    public TramoComision determinarTramo(PlanComisiones plan, double monto) {
        if (plan == null || plan.getTramos().isEmpty()) {
            return null;
        }
        for (TramoComision tramo : plan.getTramos()) {
            if (monto >= tramo.getMontoDesde() && monto <= tramo.getMontoHasta()) {
                return tramo;
            }
        }
        return plan.getTramos().get(plan.getTramos().size() - 1);
    }

    /**
     * Comision base de una transaccion, sin recargo por cuotas.
     */
    public double calcularComisionBase(PlanComisiones plan, Transaccion transaccion) {
        TramoComision tramo = determinarTramo(plan, transaccion.getMonto());
        if (tramo == null) {
            return 0.0;
        }
        double porcentaje = tramo.getPorcentaje();
        double comision = transaccion.getMonto() * porcentaje / 100.0;
        comision = comision + plan.getMontoFijoPorTransaccion();
        return comision;
    }

    /**
     * Recargo por venta en cuotas. Medio punto porcentual por cada cuota
     * posterior a la primera, con tope de tres puntos.
     */
    public double calcularRecargoCuotas(double comisionBase, int cuotas) {
        if (cuotas <= 1) {
            return 0.0;
        }
        double porcentajeRecargo = (cuotas - 1) * 0.5;
        if (porcentajeRecargo > 3.5) {
            porcentajeRecargo = 3.5;
        }
        return comisionBase * porcentajeRecargo / 100.0;
    }

    /**
     * Comision total de una transaccion, con recargo por cuotas incluido.
     */
    public double calcularComisionTotal(PlanComisiones plan, Transaccion transaccion) {
        double base = calcularComisionBase(plan, transaccion);
        double recargo = calcularRecargoCuotas(base, transaccion.getCuotas());
        return base + recargo;
    }

    /**
     * Redondea un monto a dos decimales, con medio hacia arriba.
     */
    public double redondear(double monto) {
        return Math.round(monto * 100.0) / 100.0;
    }
}
