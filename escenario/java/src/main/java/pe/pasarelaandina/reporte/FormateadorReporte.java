package pe.pasarelaandina.reporte;

import java.util.List;

import pe.pasarelaandina.modelo.DetalleLiquidacion;
import pe.pasarelaandina.modelo.Liquidacion;

/**
 * Arma la representacion en texto de las liquidaciones para su revision.
 */
public class FormateadorReporte {

    private static final String SEPARADOR =
            "----------------------------------------------------------";

    public String formatearResumenGeneral(List<Liquidacion> liquidaciones) {
        StringBuilder texto = new StringBuilder();

        double sumaTransado = 0.0;
        double sumaComisiones = 0.0;
        double sumaContracargos = 0.0;
        double sumaRetenciones = 0.0;
        double sumaNeto = 0.0;
        int sumaTransacciones = 0;
        int conTope = 0;

        for (Liquidacion liquidacion : liquidaciones) {
            sumaTransado += liquidacion.getTotalTransado();
            sumaComisiones += liquidacion.getTotalComisiones();
            sumaContracargos += liquidacion.getTotalContracargos();
            sumaRetenciones += liquidacion.getRetenciones();
            sumaNeto += liquidacion.obtenerMontoNeto();
            sumaTransacciones += liquidacion.getCantidadTransacciones();
            if (liquidacion.isTopeAplicado()) {
                conTope++;
            }
        }

        texto.append(SEPARADOR).append("\n");
        texto.append("  RESUMEN DEL PERIODO\n");
        texto.append(SEPARADOR).append("\n");
        texto.append("  Comercios liquidados      : ").append(liquidaciones.size()).append("\n");
        texto.append("  Transacciones liquidadas  : ").append(sumaTransacciones).append("\n");
        texto.append("  Comercios con tope        : ").append(conTope).append("\n");
        texto.append("  Total transado            : S/ ").append(monto(sumaTransado)).append("\n");
        texto.append("  Total comisiones          : S/ ").append(monto(sumaComisiones)).append("\n");
        texto.append("  Total contracargos        : S/ ").append(monto(sumaContracargos)).append("\n");
        texto.append("  Total retenciones         : S/ ").append(monto(sumaRetenciones)).append("\n");
        texto.append("  Total neto a pagar        : S/ ").append(monto(sumaNeto)).append("\n");
        texto.append(SEPARADOR).append("\n");

        return texto.toString();
    }

    public String formatearDetalle(Liquidacion liquidacion, int maximoLineas) {
        StringBuilder texto = new StringBuilder();

        texto.append(SEPARADOR).append("\n");
        texto.append("  DETALLE DE ").append(liquidacion.getIdComercio());
        texto.append(" - ").append(liquidacion.getRazonSocial()).append("\n");
        texto.append("  Periodo ").append(liquidacion.getPeriodo()).append("\n");
        texto.append(SEPARADOR).append("\n");
        texto.append(String.format("  %-12s %12s %10s %10s %8s%n",
                "TRANSACCION", "MONTO", "COMISION", "RECARGO", "CUOTAS"));

        int impresas = 0;
        for (DetalleLiquidacion linea : liquidacion.getDetalle()) {
            if (impresas >= maximoLineas) {
                texto.append("  ... y ")
                     .append(liquidacion.getDetalle().size() - impresas)
                     .append(" lineas mas\n");
                break;
            }
            texto.append(String.format("  %-12s %12s %10s %10s %8d%n",
                    linea.getIdTransaccion(),
                    monto(linea.getMontoTransaccion()),
                    monto(linea.getComisionTotal()),
                    monto(linea.getRecargoCuotas()),
                    linea.getCuotas()));
            impresas++;
        }

        texto.append(SEPARADOR).append("\n");
        return texto.toString();
    }

    private String monto(double valor) {
        return String.format("%.2f", valor);
    }
}
