package pe.pasarelaandina.modelo;

import java.util.Date;

/**
 * Desconocimiento de un cargo por parte del tarjetahabiente.
 */
public class Contracargo {

    private String id;
    private String idTransaccion;
    private double monto;
    private Date fecha;
    private MotivoContracargo motivo;
    private EstadoContracargo estado;

    public Contracargo() {
    }

    public Contracargo(String id, String idTransaccion, double monto, Date fecha,
                       MotivoContracargo motivo, EstadoContracargo estado) {
        this.id = id;
        this.idTransaccion = idTransaccion;
        this.monto = monto;
        this.fecha = fecha;
        this.motivo = motivo;
        this.estado = estado;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdTransaccion() {
        return idTransaccion;
    }

    public void setIdTransaccion(String idTransaccion) {
        this.idTransaccion = idTransaccion;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public MotivoContracargo getMotivo() {
        return motivo;
    }

    public void setMotivo(MotivoContracargo motivo) {
        this.motivo = motivo;
    }

    public EstadoContracargo getEstado() {
        return estado;
    }

    public void setEstado(EstadoContracargo estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return "Contracargo{" + id + ", " + idTransaccion + ", " + monto + ", " + estado + "}";
    }
}
