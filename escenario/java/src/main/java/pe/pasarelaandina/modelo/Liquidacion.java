package pe.pasarelaandina.modelo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Resultado del proceso de cierre para un comercio en un periodo.
 */
public class Liquidacion {

    private String idComercio;
    private String razonSocial;
    private String periodo;
    private double totalTransado;
    private double totalComisiones;
    private double totalContracargos;
    private double retenciones;
    private double montoNeto;
    private Date fechaGeneracion;
    private int cantidadTransacciones;
    private boolean topeAplicado;
    private List<DetalleLiquidacion> detalle = new ArrayList<>();

    public Liquidacion() {
    }

    public String getIdComercio() {
        return idComercio;
    }

    public void setIdComercio(String idComercio) {
        this.idComercio = idComercio;
    }

    public String getRazonSocial() {
        return razonSocial;
    }

    public void setRazonSocial(String razonSocial) {
        this.razonSocial = razonSocial;
    }

    public String getPeriodo() {
        return periodo;
    }

    public void setPeriodo(String periodo) {
        this.periodo = periodo;
    }

    public double getTotalTransado() {
        return totalTransado;
    }

    public void setTotalTransado(double totalTransado) {
        this.totalTransado = totalTransado;
    }

    public double getTotalComisiones() {
        return totalComisiones;
    }

    public void setTotalComisiones(double totalComisiones) {
        this.totalComisiones = totalComisiones;
    }

    public double getTotalContracargos() {
        return totalContracargos;
    }

    public void setTotalContracargos(double totalContracargos) {
        this.totalContracargos = totalContracargos;
    }

    public double getRetenciones() {
        return retenciones;
    }

    public void setRetenciones(double retenciones) {
        this.retenciones = retenciones;
    }

    /**
     * Devuelve el monto neto a pagar al comercio.
     */
    public double obtenerMontoNeto() {
        this.montoNeto = this.totalTransado - this.totalComisiones - this.totalContracargos - this.retenciones;
        return this.montoNeto;
    }

    public void setMontoNeto(double montoNeto) {
        this.montoNeto = montoNeto;
    }

    public Date getFechaGeneracion() {
        return fechaGeneracion;
    }

    public void setFechaGeneracion(Date fechaGeneracion) {
        this.fechaGeneracion = fechaGeneracion;
    }

    public int getCantidadTransacciones() {
        return cantidadTransacciones;
    }

    public void setCantidadTransacciones(int cantidadTransacciones) {
        this.cantidadTransacciones = cantidadTransacciones;
    }

    public boolean isTopeAplicado() {
        return topeAplicado;
    }

    public void setTopeAplicado(boolean topeAplicado) {
        this.topeAplicado = topeAplicado;
    }

    public List<DetalleLiquidacion> getDetalle() {
        return detalle;
    }

    public void setDetalle(List<DetalleLiquidacion> detalle) {
        this.detalle = detalle;
    }

    public void agregarDetalle(DetalleLiquidacion linea) {
        this.detalle.add(linea);
    }

    @Override
    public String toString() {
        return "Liquidacion{" + idComercio + ", " + periodo + ", neto=" + montoNeto + "}";
    }
}
