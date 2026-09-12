package pe.pasarelaandina.calculo;

import java.util.List;

import pe.pasarelaandina.modelo.Comercio;
import pe.pasarelaandina.modelo.EstadoTransaccion;
import pe.pasarelaandina.modelo.PlanComisiones;
import pe.pasarelaandina.modelo.Transaccion;
import pe.pasarelaandina.repositorio.RepositorioMemoria;

/**
 * Consulta puntual que usa el area comercial para estimar cuanto pagaria un
 * comercio por una venta antes de cerrar el periodo.
 */
public class SimuladorComision {

    private final RepositorioMemoria repositorio;
    private final CalculadoraComision calculadoraComision = new CalculadoraComision();

    public SimuladorComision(RepositorioMemoria repositorio) {
        this.repositorio = repositorio;
    }

    public double simularComision(String idComercio, double monto, int cuotas) {
        Comercio comercio = repositorio.buscarComercioPorId(idComercio);
        if (comercio == null) {
            return 0.0;
        }
        PlanComisiones plan = repositorio.buscarPlanPorId(comercio.getIdPlanComisiones());
        if (plan == null) {
            return 0.0;
        }

        Transaccion simulada = new Transaccion();
        simulada.setId("SIMULADA");
        simulada.setIdComercio(idComercio);
        simulada.setMonto(monto);
        simulada.setMoneda("PEN");
        simulada.setCuotas(cuotas);
        simulada.setEstado(EstadoTransaccion.APROBADA);

        return calculadoraComision.redondear(
                calculadoraComision.calcularComisionTotal(plan, simulada));
    }

    public double simularComisionDeTransaccion(String idTransaccion) {
        Transaccion transaccion = repositorio.buscarTransaccionPorId(idTransaccion);
        if (transaccion == null) {
            return 0.0;
        }
        return simularComision(transaccion.getIdComercio(),
                transaccion.getMonto(), transaccion.getCuotas());
    }

    public double simularTotalDeComercio(String idComercio) {
        double total = 0.0;
        List<Transaccion> transacciones = repositorio.buscarTransaccionesDeComercio(idComercio);
        for (Transaccion transaccion : transacciones) {
            if (transaccion.getEstado() == EstadoTransaccion.APROBADA) {
                total += simularComision(transaccion.getIdComercio(),
                        transaccion.getMonto(), transaccion.getCuotas());
            }
        }
        return calculadoraComision.redondear(total);
    }
}
