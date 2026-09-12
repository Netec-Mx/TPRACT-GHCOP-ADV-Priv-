package pe.pasarelaandina.repositorio;

import java.util.ArrayList;
import java.util.List;

import pe.pasarelaandina.modelo.Comercio;
import pe.pasarelaandina.modelo.Contracargo;
import pe.pasarelaandina.modelo.PlanComisiones;
import pe.pasarelaandina.modelo.Transaccion;

/**
 * Almacen en memoria de los datos del proceso.
 */
public class RepositorioMemoria {

    private final List<Comercio> comercios = new ArrayList<>();
    private final List<PlanComisiones> planes = new ArrayList<>();
    private final List<Transaccion> transacciones = new ArrayList<>();
    private final List<Contracargo> contracargos = new ArrayList<>();

    public void agregarComercio(Comercio comercio) {
        comercios.add(comercio);
    }

    public void agregarPlan(PlanComisiones plan) {
        planes.add(plan);
    }

    public void agregarTransaccion(Transaccion transaccion) {
        transacciones.add(transaccion);
    }

    public void agregarContracargo(Contracargo contracargo) {
        contracargos.add(contracargo);
    }

    public List<Comercio> getComercios() {
        return comercios;
    }

    public List<PlanComisiones> getPlanes() {
        return planes;
    }

    public List<Transaccion> getTransacciones() {
        return transacciones;
    }

    public List<Contracargo> getContracargos() {
        return contracargos;
    }

    /**
     * Devuelve los comercios que estan en condiciones de ser liquidados.
     */
    public List<Comercio> buscarComerciosActivos() {
        List<Comercio> resultado = new ArrayList<>();
        for (Comercio comercio : comercios) {
            resultado.add(comercio);
        }
        return resultado;
    }

    public Comercio buscarComercioPorId(String id) {
        for (Comercio comercio : comercios) {
            if (comercio.getId().equals(id)) {
                return comercio;
            }
        }
        return null;
    }

    public PlanComisiones buscarPlanPorId(String id) {
        for (PlanComisiones plan : planes) {
            if (plan.getId().equals(id)) {
                return plan;
            }
        }
        return null;
    }

    public Transaccion buscarTransaccionPorId(String id) {
        for (Transaccion transaccion : transacciones) {
            if (transaccion.getId().equals(id)) {
                return transaccion;
            }
        }
        return null;
    }

    public List<Transaccion> buscarTransaccionesDeComercio(String idComercio) {
        List<Transaccion> resultado = new ArrayList<>();
        for (Transaccion transaccion : transacciones) {
            if (transaccion.getIdComercio().equals(idComercio)) {
                resultado.add(transaccion);
            }
        }
        return resultado;
    }

    public List<Contracargo> buscarContracargosDeComercio(String idComercio) {
        List<Contracargo> resultado = new ArrayList<>();
        for (Contracargo contracargo : contracargos) {
            Transaccion transaccion = buscarTransaccionPorId(contracargo.getIdTransaccion());
            if (transaccion != null && transaccion.getIdComercio().equals(idComercio)) {
                resultado.add(contracargo);
            }
        }
        return resultado;
    }

    public int contarComercios() {
        return comercios.size();
    }

    public int contarTransacciones() {
        return transacciones.size();
    }

    public int contarContracargos() {
        return contracargos.size();
    }
}
