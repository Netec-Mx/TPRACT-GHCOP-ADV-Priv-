package pe.pasarelaandina;

import java.io.FileDescriptor;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import java.util.List;

import pe.pasarelaandina.calculo.CalculadoraLiquidacion;
import pe.pasarelaandina.calculo.SimuladorComision;
import pe.pasarelaandina.modelo.Liquidacion;
import pe.pasarelaandina.reporte.FormateadorReporte;
import pe.pasarelaandina.util.ConfiguracionRegional;
import pe.pasarelaandina.repositorio.RepositorioMemoria;

/**
 * Punto de entrada del proceso de cierre.
 *
 * Uso:
 *   java -jar liquidacion-comercios.jar [periodo] [ruta de datos]
 *
 * Si no se indican argumentos usa el periodo 2026-06 y el directorio datos.
 */
public class AplicacionLiquidacion {

    private static final String PERIODO_POR_DEFECTO = "2026-06";
    // Los datos son compartidos con el escenario .NET y viven un nivel mas arriba,
    // en escenario/datos, para que ninguno de los dos proyectos sea su dueño.
    private static final String DIRECTORIO_POR_DEFECTO = "../datos";

    public static void main(String[] args) {

        // La codificacion de salida se fija de forma explicita y no se hereda de la
        // maquina.
        //
        // El juego de caracteres de la consola tambien depende de la configuracion
        // regional. Con la maquina en tailandes la JVM elige una codificacion que no
        // tiene la letra ñ, y razones sociales como "Representaciones Breña S.R.L."
        // salen impresas como "Bre?a". El escenario .NET escribe UTF-8 siempre, asi que
        // sin esto las dos salidas dejan de coincidir aunque los numeros esten bien.
        System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out),
                true, StandardCharsets.UTF_8));

        String periodo = args.length > 0 ? args[0] : PERIODO_POR_DEFECTO;
        String rutaDatos = args.length > 1 ? args[1] : DIRECTORIO_POR_DEFECTO;

        CalculadoraLiquidacion calculadora = new CalculadoraLiquidacion();
        calculadora.prepararDatos(rutaDatos);

        RepositorioMemoria repositorio = calculadora.getRepositorio();

        System.out.println();
        System.out.println("Datos cargados desde: " + rutaDatos);
        System.out.println("  Comercios    : " + repositorio.contarComercios());
        System.out.println("  Transacciones: " + repositorio.contarTransacciones());
        System.out.println("  Contracargos : " + repositorio.contarContracargos());
        System.out.println();

        List<Liquidacion> liquidaciones = calculadora.procesarLiquidacionCompleta(periodo, rutaDatos);

        FormateadorReporte formateador = new FormateadorReporte();
        System.out.println();
        System.out.println(formateador.formatearResumenGeneral(liquidaciones));

        if (!liquidaciones.isEmpty()) {
            System.out.println(formateador.formatearDetalle(liquidaciones.get(0), 10));
        }

        SimuladorComision simulador = new SimuladorComision(repositorio);
        System.out.println("Simulacion de comision para el area comercial:");
        for (Liquidacion liquidacion : primeras(liquidaciones, 3)) {
            double estimada = simulador.simularComision(liquidacion.getIdComercio(), 1500.00, 3);
            System.out.println("  " + liquidacion.getIdComercio()
                    + " venta de S/ 1500.00 en 3 cuotas -> comision S/ "
                    + String.format(ConfiguracionRegional.REGION_DE_SALIDA, "%.2f", estimada));
        }
        System.out.println();
    }

    private static List<Liquidacion> primeras(List<Liquidacion> origen, int cantidad) {
        if (origen.size() <= cantidad) {
            return origen;
        }
        return origen.subList(0, cantidad);
    }
}
