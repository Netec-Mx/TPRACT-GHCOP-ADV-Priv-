package pe.pasarelaandina.modelo;

/**
 * Tramo de un tarifario. Define el porcentaje que se aplica a las
 * transacciones cuyo monto cae dentro del rango.
 */
public class TramoComision {

    private double montoDesde;
    private double montoHasta;
    private double porcentaje;

    public TramoComision() {
    }

    public TramoComision(double montoDesde, double montoHasta, double porcentaje) {
        this.montoDesde = montoDesde;
        this.montoHasta = montoHasta;
        this.porcentaje = porcentaje;
    }

    public double getMontoDesde() {
        return montoDesde;
    }

    public void setMontoDesde(double montoDesde) {
        this.montoDesde = montoDesde;
    }

    public double getMontoHasta() {
        return montoHasta;
    }

    public void setMontoHasta(double montoHasta) {
        this.montoHasta = montoHasta;
    }

    public double getPorcentaje() {
        return porcentaje;
    }

    public void setPorcentaje(double porcentaje) {
        this.porcentaje = porcentaje;
    }

    @Override
    public String toString() {
        return "Tramo[" + montoDesde + " - " + montoHasta + " = " + porcentaje + "%]";
    }
}
