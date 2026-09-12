package pe.pasarelaandina.modelo;

/**
 * Linea de la liquidacion. Representa el aporte de una transaccion al
 * total de comisiones del periodo.
 */
public class DetalleLiquidacion {

    private String idTransaccion;
    private double montoTransaccion;
    private double comisionBase;
    private double recargoCuotas;
    private double comisionTotal;
    private int cuotas;
    private String medioPago;

    public DetalleLiquidacion() {
    }

    public String getIdTransaccion() {
        return idTransaccion;
    }

    public void setIdTransaccion(String idTransaccion) {
        this.idTransaccion = idTransaccion;
    }

    public double getMontoTransaccion() {
        return montoTransaccion;
    }

    public void setMontoTransaccion(double montoTransaccion) {
        this.montoTransaccion = montoTransaccion;
    }

    public double getComisionBase() {
        return comisionBase;
    }

    public void setComisionBase(double comisionBase) {
        this.comisionBase = comisionBase;
    }

    public double getRecargoCuotas() {
        return recargoCuotas;
    }

    public void setRecargoCuotas(double recargoCuotas) {
        this.recargoCuotas = recargoCuotas;
    }

    public double getComisionTotal() {
        return comisionTotal;
    }

    public void setComisionTotal(double comisionTotal) {
        this.comisionTotal = comisionTotal;
    }

    public int getCuotas() {
        return cuotas;
    }

    public void setCuotas(int cuotas) {
        this.cuotas = cuotas;
    }

    public String getMedioPago() {
        return medioPago;
    }

    public void setMedioPago(String medioPago) {
        this.medioPago = medioPago;
    }
}
