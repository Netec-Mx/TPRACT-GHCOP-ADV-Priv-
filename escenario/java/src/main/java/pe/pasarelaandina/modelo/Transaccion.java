package pe.pasarelaandina.modelo;

import java.util.Date;

/**
 * Venta autorizada a traves de la pasarela.
 */
public class Transaccion {

    private String id;
    private String idComercio;
    private double monto;
    private String moneda;
    private Date fechaHora;
    private MedioPago medioPago;
    private int cuotas;
    private EstadoTransaccion estado;
    private String codigoAutorizacion;

    public Transaccion() {
    }

    public Transaccion(String id, String idComercio, double monto, String moneda,
                       Date fechaHora, MedioPago medioPago, int cuotas,
                       EstadoTransaccion estado, String codigoAutorizacion) {
        this.id = id;
        this.idComercio = idComercio;
        this.monto = monto;
        this.moneda = moneda;
        this.fechaHora = fechaHora;
        this.medioPago = medioPago;
        this.cuotas = cuotas;
        this.estado = estado;
        this.codigoAutorizacion = codigoAutorizacion;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdComercio() {
        return idComercio;
    }

    public void setIdComercio(String idComercio) {
        this.idComercio = idComercio;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    public String getMoneda() {
        return moneda;
    }

    public void setMoneda(String moneda) {
        this.moneda = moneda;
    }

    public Date getFechaHora() {
        return fechaHora;
    }

    public void setFechaHora(Date fechaHora) {
        this.fechaHora = fechaHora;
    }

    public MedioPago getMedioPago() {
        return medioPago;
    }

    public void setMedioPago(MedioPago medioPago) {
        this.medioPago = medioPago;
    }

    public int getCuotas() {
        return cuotas;
    }

    public void setCuotas(int cuotas) {
        this.cuotas = cuotas;
    }

    public EstadoTransaccion getEstado() {
        return estado;
    }

    public void setEstado(EstadoTransaccion estado) {
        this.estado = estado;
    }

    public String getCodigoAutorizacion() {
        return codigoAutorizacion;
    }

    public void setCodigoAutorizacion(String codigoAutorizacion) {
        this.codigoAutorizacion = codigoAutorizacion;
    }

    @Override
    public String toString() {
        return "Transaccion{" + id + ", " + idComercio + ", " + monto + ", " + estado + "}";
    }
}
