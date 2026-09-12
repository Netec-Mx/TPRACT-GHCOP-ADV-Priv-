using System;
using System.Collections.Generic;
using System.Globalization;
using System.Threading;

using Pe.PasarelaAndina.Calculo;
using Pe.PasarelaAndina.Modelo;
using Pe.PasarelaAndina.Reporte;
using Pe.PasarelaAndina.Repositorio;

namespace Pe.PasarelaAndina
{
    /// <summary>
    /// Punto de entrada del proceso de cierre.
    ///
    /// Uso:
    ///   dotnet LiquidacionComercios.dll [periodo] [ruta de datos]
    ///
    /// Si no se indican argumentos usa el periodo 2026-06 y el directorio ../datos.
    /// </summary>
    public static class AplicacionLiquidacion
    {
        private const string PeriodoPorDefecto = "2026-06";

        // Los datos son compartidos con el escenario Java y viven un nivel mas arriba,
        // en escenario/datos, para que ninguno de los dos proyectos sea su dueño.
        private const string DirectorioPorDefecto = "../datos";

        public static void Main(string[] args)
        {
            // La cultura se fija de forma explicita y no se hereda de la maquina.
            //
            // Una maquina virtual configurada en español imprime los decimales con coma y
            // lee "1234.56" como 123456. Cualquiera de las dos cosas rompe la equivalencia
            // con el escenario Java sin que el calculo este mal. Esto no es opcional.
            CultureInfo.DefaultThreadCurrentCulture = CultureInfo.InvariantCulture;
            CultureInfo.DefaultThreadCurrentUICulture = CultureInfo.InvariantCulture;
            Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;
            Thread.CurrentThread.CurrentUICulture = CultureInfo.InvariantCulture;

            string periodo = args.Length > 0 ? args[0] : PeriodoPorDefecto;
            string rutaDatos = args.Length > 1 ? args[1] : DirectorioPorDefecto;

            CalculadoraLiquidacion calculadora = new CalculadoraLiquidacion();
            calculadora.PrepararDatos(rutaDatos);

            RepositorioMemoria repositorio = calculadora.Repositorio;

            Console.WriteLine();
            Console.WriteLine("Datos cargados desde: " + rutaDatos);
            Console.WriteLine("  Comercios    : " + repositorio.ContarComercios());
            Console.WriteLine("  Transacciones: " + repositorio.ContarTransacciones());
            Console.WriteLine("  Contracargos : " + repositorio.ContarContracargos());
            Console.WriteLine();

            List<Liquidacion> liquidaciones = calculadora.ProcesarLiquidacionCompleta(periodo, rutaDatos);

            FormateadorReporte formateador = new FormateadorReporte();
            Console.WriteLine();
            Console.WriteLine(formateador.FormatearResumenGeneral(liquidaciones));

            if (liquidaciones.Count > 0)
            {
                Console.WriteLine(formateador.FormatearDetalle(liquidaciones[0], 10));
            }

            SimuladorComision simulador = new SimuladorComision(repositorio);
            Console.WriteLine("Simulacion de comision para el area comercial:");
            foreach (Liquidacion liquidacion in Primeras(liquidaciones, 3))
            {
                double estimada = simulador.SimularComision(liquidacion.IdComercio, 1500.00, 3);
                Console.WriteLine("  " + liquidacion.IdComercio
                        + " venta de S/ 1500.00 en 3 cuotas -> comision S/ "
                        + Util.CompatibilidadJava.FormatearDosDecimales(estimada));
            }
            Console.WriteLine();
        }

        private static List<Liquidacion> Primeras(List<Liquidacion> origen, int cantidad)
        {
            if (origen.Count <= cantidad)
            {
                return origen;
            }
            return origen.GetRange(0, cantidad);
        }
    }
}
