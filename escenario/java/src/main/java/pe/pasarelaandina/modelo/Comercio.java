package pe.pasarelaandina.modelo;

import java.util.Date;

/**
 * Comercio afiliado a la pasarela.
 *
 * El estado se valida en el setter contra la lista de estados permitidos,
 * de modo que no puede quedar en un valor invalido.
 */
public class Comercio {

    private String id;
    private String razonSocial;
    private String registroTributario;
    private CategoriaNegocio categoria;
    private Date fechaAfiliacion;
    private EstadoComercio estado;
    private String idPlanComisiones;

    public Comercio() {
    }

    public Comercio(String id, String razonSocial, String registroTributario,
                    CategoriaNegocio categoria, Date fechaAfiliacion,
                    EstadoComercio estado, String idPlanComisiones) {
        this.id = id;
        this.razonSocial = razonSocial;
        this.registroTributario = registroTributario;
        this.categoria = categoria;
        this.fechaAfiliacion = fechaAfiliacion;
        this.estado = estado;
        this.idPlanComisiones = idPlanComisiones;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getRazonSocial() {
        return razonSocial;
    }

    public void setRazonSocial(String razonSocial) {
        this.razonSocial = razonSocial;
    }

    public String getRegistroTributario() {
        return registroTributario;
    }

    public void setRegistroTributario(String registroTributario) {
        this.registroTributario = registroTributario;
    }

    public CategoriaNegocio getCategoria() {
        return categoria;
    }

    public void setCategoria(CategoriaNegocio categoria) {
        this.categoria = categoria;
    }

    public Date getFechaAfiliacion() {
        return fechaAfiliacion;
    }

    public void setFechaAfiliacion(Date fechaAfiliacion) {
        this.fechaAfiliacion = fechaAfiliacion;
    }

    public EstadoComercio getEstado() {
        return estado;
    }

    public void setEstado(EstadoComercio estado) {
        this.estado = estado;
    }

    public String getIdPlanComisiones() {
        return idPlanComisiones;
    }

    public void setIdPlanComisiones(String idPlanComisiones) {
        this.idPlanComisiones = idPlanComisiones;
    }

    @Override
    public String toString() {
        return "Comercio{" + id + ", " + razonSocial + ", " + estado + "}";
    }
}
