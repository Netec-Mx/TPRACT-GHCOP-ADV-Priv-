package pe.pasarelaandina.modelo;

import java.util.ArrayList;
import java.util.List;

/**
 * Tarifario asignado a un comercio.
 *
 * Los tramos son acumulativos: el monto de cada transaccion se reparte entre
 * los tramos que atraviesa y cada porcion paga el porcentaje de su tramo.
 */
public class PlanComisiones {

    private String id;
    private String nombre;
    private List<TramoComision> tramos = new ArrayList<>();
    private double montoFijoPorTransaccion;
    private double topeMensual;

    public PlanComisiones() {
    }

    public PlanComisiones(String id, String nombre, double montoFijoPorTransaccion, double topeMensual) {
        this.id = id;
        this.nombre = nombre;
        this.montoFijoPorTransaccion = montoFijoPorTransaccion;
        this.topeMensual = topeMensual;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public List<TramoComision> getTramos() {
        return tramos;
    }

    public void setTramos(List<TramoComision> tramos) {
        this.tramos = tramos;
    }

    public void agregarTramo(TramoComision tramo) {
        this.tramos.add(tramo);
    }

    public double getMontoFijoPorTransaccion() {
        return montoFijoPorTransaccion;
    }

    public void setMontoFijoPorTransaccion(double montoFijoPorTransaccion) {
        this.montoFijoPorTransaccion = montoFijoPorTransaccion;
    }

    public double getTopeMensual() {
        return topeMensual;
    }

    public void setTopeMensual(double topeMensual) {
        this.topeMensual = topeMensual;
    }

    @Override
    public String toString() {
        return "Plan{" + id + ", " + nombre + ", tramos=" + tramos.size() + "}";
    }
}
