package pe.pasarelaandina.calculo;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import pe.pasarelaandina.modelo.Comercio;
import pe.pasarelaandina.modelo.Contracargo;
import pe.pasarelaandina.modelo.DetalleLiquidacion;
import pe.pasarelaandina.modelo.EstadoComercio;
import pe.pasarelaandina.modelo.EstadoContracargo;
import pe.pasarelaandina.modelo.EstadoTransaccion;
import pe.pasarelaandina.modelo.Liquidacion;
import pe.pasarelaandina.modelo.PlanComisiones;
import pe.pasarelaandina.modelo.TramoComision;
import pe.pasarelaandina.modelo.Transaccion;
import pe.pasarelaandina.repositorio.CargadorDatos;
import pe.pasarelaandina.repositorio.RepositorioMemoria;
import pe.pasarelaandina.util.ConfiguracionRegional;

/**
 * Proceso de cierre mensual.
 *
 * Toma las transacciones del periodo, calcula las comisiones de cada comercio,
 * descuenta contracargos y retenciones, y entrega la liquidacion resultante.
 */
public class CalculadoraLiquidacion {

    private RepositorioMemoria repositorio;
    private final UtilidadesFecha utilidadesFecha = new UtilidadesFecha();

    private double acumuladoGeneralTransado = 0.0;
    private double acumuladoGeneralComisiones = 0.0;
    private int transaccionesDescartadas = 0;

    public CalculadoraLiquidacion() {
    }

    public CalculadoraLiquidacion(RepositorioMemoria repositorio) {
        this.repositorio = repositorio;
    }

    /**
     * Carga los datos desde el directorio indicado y deja el repositorio listo.
     */
    public void prepararDatos(String rutaDirectorioDatos) {
        this.repositorio = new RepositorioMemoria();
        CargadorDatos cargador = new CargadorDatos();
        cargador.cargarTodo(this.repositorio, rutaDirectorioDatos);
    }

    /**
     * Verifica que la transaccion tenga los datos necesarios para ser liquidada.
     */
    private boolean validarTransaccion(Transaccion transaccion) {
        if (transaccion == null) {
            transaccionesDescartadas++;
            return false;
        }
        if (transaccion.getFechaHora() == null) {
            transaccionesDescartadas++;
            return false;
        }
        if (transaccion.getMoneda() == null || !transaccion.getMoneda().equals("PEN")) {
            transaccionesDescartadas++;
            return false;
        }
        if (transaccion.getMonto() <= 0) {
            transaccionesDescartadas++;
            return false;
        }
        acumuladoGeneralTransado = acumuladoGeneralTransado + transaccion.getMonto();
        return true;
    }

    /**
     * Genera las liquidaciones de todos los comercios para el periodo indicado,
     * las imprime por consola y devuelve la lista resultante.
     */
    public List<Liquidacion> procesarLiquidacionCompleta(String periodo, String rutaDirectorioDatos) {

        List<Liquidacion> resultado = new ArrayList<>();

        if (this.repositorio == null) {
            this.repositorio = new RepositorioMemoria();
            CargadorDatos cargador = new CargadorDatos();
            cargador.cargarTodo(this.repositorio, rutaDirectorioDatos + File.separator);
        }

        Date inicioPeriodo = utilidadesFecha.inicioDePeriodo(periodo);
        Date finPeriodo = utilidadesFecha.finDePeriodo(periodo);

        SimpleDateFormat formatoSalida =
                new SimpleDateFormat("dd/MM/yyyy HH:mm", ConfiguracionRegional.REGION_DE_SALIDA);

        System.out.println("==========================================================");
        System.out.println("  PASARELA ANDINA - LIQUIDACION DE COMERCIOS");
        System.out.println("  Periodo: " + periodo);
        System.out.println("  Desde: " + formatoSalida.format(inicioPeriodo));
        System.out.println("  Hasta: " + formatoSalida.format(finPeriodo));
        System.out.println("==========================================================");
        System.out.println();

        List<Comercio> comercios = repositorio.buscarComerciosActivos();

        for (Comercio comercio : comercios) {

            if (comercio.getEstado() == EstadoComercio.DE_BAJA) {
                continue;
            }

            PlanComisiones plan = repositorio.buscarPlanPorId(comercio.getIdPlanComisiones());

            if (plan != null) {

                Liquidacion liquidacion = new Liquidacion();
                liquidacion.setIdComercio(comercio.getId());
                liquidacion.setRazonSocial(comercio.getRazonSocial());
                liquidacion.setPeriodo(periodo);
                liquidacion.setFechaGeneracion(new Date());

                double totalTransado = 0.0;
                double totalComisiones = 0.0;
                int cantidadTransacciones = 0;

                List<Transaccion> transacciones = repositorio.buscarTransaccionesDeComercio(comercio.getId());

                for (Transaccion transaccion : transacciones) {

                    if (validarTransaccion(transaccion)) {

                        Date fechaTransaccion = transaccion.getFechaHora();

                        if (!fechaTransaccion.before(inicioPeriodo) && !fechaTransaccion.after(finPeriodo)) {

                            if (transaccion.getEstado() == EstadoTransaccion.APROBADA) {

                                double montoTransaccion = transaccion.getMonto();
                                double porcentajeAplicado = 0.0;
                                boolean tramoEncontrado = false;

                                for (TramoComision tramo : plan.getTramos()) {

                                    if (!tramoEncontrado) {

                                        if (montoTransaccion >= tramo.getMontoDesde()
                                                && montoTransaccion < tramo.getMontoHasta()) {

                                            porcentajeAplicado = tramo.getPorcentaje();
                                            tramoEncontrado = true;
                                        }
                                    }
                                }

                                if (!tramoEncontrado) {
                                    if (!plan.getTramos().isEmpty()) {
                                        porcentajeAplicado = plan.getTramos()
                                                .get(plan.getTramos().size() - 1).getPorcentaje();
                                    }
                                }

                                double comisionBase = montoTransaccion * porcentajeAplicado / 100.0;
                                comisionBase = comisionBase + plan.getMontoFijoPorTransaccion();

                                double recargo = 0.0;

                                if (transaccion.getCuotas() > 1) {

                                    double porcentajeRecargo = (transaccion.getCuotas() - 1) * 0.5;

                                    if (porcentajeRecargo > 3.0) {
                                        porcentajeRecargo = 3.0;
                                    }

                                    recargo = comisionBase * porcentajeRecargo / 100.0;
                                }

                                double comisionTotal = comisionBase + recargo;

                                DetalleLiquidacion linea = new DetalleLiquidacion();
                                linea.setIdTransaccion(transaccion.getId());
                                linea.setMontoTransaccion(montoTransaccion);
                                linea.setComisionBase(comisionBase);
                                linea.setRecargoCuotas(recargo);
                                linea.setComisionTotal(comisionTotal);
                                linea.setCuotas(transaccion.getCuotas());
                                linea.setMedioPago(transaccion.getMedioPago().name());
                                liquidacion.agregarDetalle(linea);

                                totalTransado = totalTransado + montoTransaccion;
                                totalComisiones = totalComisiones + comisionTotal;
                                cantidadTransacciones++;

                                acumuladoGeneralComisiones = acumuladoGeneralComisiones + comisionTotal;
                            }
                        }
                    }
                }

                if (totalComisiones > plan.getTopeMensual()) {
                    totalComisiones = plan.getTopeMensual();
                    liquidacion.setTopeAplicado(true);
                }

                double totalContracargos = 0.0;

                List<Contracargo> contracargos = repositorio.buscarContracargosDeComercio(comercio.getId());

                for (Contracargo contracargo : contracargos) {

                    if (contracargo.getEstado() == EstadoContracargo.APROBADO) {

                        Date fechaContracargo = contracargo.getFecha();

                        if (fechaContracargo != null) {

                            if (!fechaContracargo.before(inicioPeriodo)
                                    && !fechaContracargo.after(finPeriodo)) {

                                totalContracargos = totalContracargos + contracargo.getMonto();
                            }
                        }
                    }
                }

                double retenciones = 0.0;

                Date fechaAfiliacion = comercio.getFechaAfiliacion();

                if (fechaAfiliacion != null) {

                    int meses = utilidadesFecha.mesesEntre(fechaAfiliacion, inicioPeriodo);

                    if (meses < 6) {

                        double baseRetencion = totalTransado - totalComisiones - totalContracargos;

                        if (baseRetencion > 0) {
                            retenciones = baseRetencion * 0.05;
                        }
                    }
                }

                totalTransado = Math.round(totalTransado * 100.0) / 100.0;
                totalComisiones = Math.round(totalComisiones * 100.0) / 100.0;
                totalContracargos = Math.round(totalContracargos * 100.0) / 100.0;
                retenciones = Math.round(retenciones * 100.0) / 100.0;

                liquidacion.setTotalTransado(totalTransado);
                liquidacion.setTotalComisiones(totalComisiones);
                liquidacion.setTotalContracargos(totalContracargos);
                liquidacion.setRetenciones(retenciones);
                liquidacion.setCantidadTransacciones(cantidadTransacciones);

                double neto = liquidacion.obtenerMontoNeto();
                neto = Math.round(neto * 100.0) / 100.0;
                liquidacion.setMontoNeto(neto);

                String observacionRegistro = "";

                try {
                    String registro = comercio.getRegistroTributario();

                    if (registro != null) {

                        if (registro.length() == 11) {

                            String prefijo = registro.substring(0, 2);

                            if (!prefijo.equals("10") && !prefijo.equals("20")
                                    && !prefijo.equals("15") && !prefijo.equals("17")) {

                                observacionRegistro = "registro con prefijo no habitual";
                            }
                        } else {
                            observacionRegistro = "registro de largo invalido";
                        }
                    }
                } catch (Exception e) {
                }

                double montoCredito = 0.0;
                double montoDebito = 0.0;
                double montoBilletera = 0.0;
                double montoTransferencia = 0.0;
                int transaccionesEnCuotas = 0;

                for (DetalleLiquidacion linea : liquidacion.getDetalle()) {

                    if (linea.getMedioPago() != null) {

                        if (linea.getMedioPago().equals("TARJETA_CREDITO")) {

                            montoCredito = montoCredito + linea.getMontoTransaccion();

                            if (linea.getCuotas() > 1) {
                                transaccionesEnCuotas++;
                            }
                        } else {

                            if (linea.getMedioPago().equals("TARJETA_DEBITO")) {
                                montoDebito = montoDebito + linea.getMontoTransaccion();
                            } else {

                                if (linea.getMedioPago().equals("BILLETERA_MOVIL")) {
                                    montoBilletera = montoBilletera + linea.getMontoTransaccion();
                                } else {
                                    montoTransferencia = montoTransferencia + linea.getMontoTransaccion();
                                }
                            }
                        }
                    }
                }

                if (cantidadTransacciones > 0) {

                    resultado.add(liquidacion);

                    System.out.println("Comercio " + comercio.getId() + " - " + comercio.getRazonSocial());
                    System.out.println("  Transacciones liquidadas : " + cantidadTransacciones);
                    System.out.println("  Total transado           : S/ " + formatearMonto(totalTransado));
                    System.out.println("  Total comisiones         : S/ " + formatearMonto(totalComisiones)
                            + (liquidacion.isTopeAplicado() ? "  (tope aplicado)" : ""));
                    System.out.println("  Contracargos             : S/ " + formatearMonto(totalContracargos));
                    System.out.println("  Retenciones              : S/ " + formatearMonto(retenciones));
                    System.out.println("  Monto neto a pagar       : S/ " + formatearMonto(neto));

                    if (montoCredito > 0 || montoDebito > 0 || montoBilletera > 0 || montoTransferencia > 0) {

                        System.out.println("  Desglose por medio de pago:");

                        if (montoCredito > 0) {
                            System.out.println("    Tarjeta de credito     : S/ " + formatearMonto(montoCredito)
                                    + (transaccionesEnCuotas > 0 ? "  (" + transaccionesEnCuotas + " en cuotas)" : ""));
                        }
                        if (montoDebito > 0) {
                            System.out.println("    Tarjeta de debito      : S/ " + formatearMonto(montoDebito));
                        }
                        if (montoBilletera > 0) {
                            System.out.println("    Billetera movil        : S/ " + formatearMonto(montoBilletera));
                        }
                        if (montoTransferencia > 0) {
                            System.out.println("    Transferencia          : S/ " + formatearMonto(montoTransferencia));
                        }
                    }

                    if (!observacionRegistro.isEmpty()) {
                        System.out.println("  Observacion              : " + observacionRegistro);
                    }

                    System.out.println();
                }
            }
        }

        System.out.println("==========================================================");
        System.out.println("  Comercios liquidados     : " + resultado.size());
        System.out.println("  Transacciones descartadas: " + transaccionesDescartadas);
        System.out.println("==========================================================");

        return resultado;
    }

    private String formatearMonto(double monto) {
        return String.format(ConfiguracionRegional.REGION_DE_SALIDA, "%.2f", monto);
    }

    public double getAcumuladoGeneralTransado() {
        return acumuladoGeneralTransado;
    }

    public double getAcumuladoGeneralComisiones() {
        return acumuladoGeneralComisiones;
    }

    public int getTransaccionesDescartadas() {
        return transaccionesDescartadas;
    }

    public RepositorioMemoria getRepositorio() {
        return repositorio;
    }
}
