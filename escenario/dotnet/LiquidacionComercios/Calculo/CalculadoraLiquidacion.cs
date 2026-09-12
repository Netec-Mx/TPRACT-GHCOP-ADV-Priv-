using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;

using Pe.PasarelaAndina.Modelo;
using Pe.PasarelaAndina.Repositorio;
using Pe.PasarelaAndina.Util;

namespace Pe.PasarelaAndina.Calculo
{
    /// <summary>
    /// Proceso de cierre mensual.
    ///
    /// Toma las transacciones del periodo, calcula las comisiones de cada comercio,
    /// descuenta contracargos y retenciones, y entrega la liquidacion resultante.
    /// </summary>
    public class CalculadoraLiquidacion
    {
        private RepositorioMemoria repositorio;
        private readonly UtilidadesFecha utilidadesFecha = new UtilidadesFecha();

        private double acumuladoGeneralTransado = 0.0;
        private double acumuladoGeneralComisiones = 0.0;
        private int transaccionesDescartadas = 0;

        public CalculadoraLiquidacion()
        {
        }

        public CalculadoraLiquidacion(RepositorioMemoria repositorio)
        {
            this.repositorio = repositorio;
        }

        /// <summary>
        /// Carga los datos desde el directorio indicado y deja el repositorio listo.
        /// </summary>
        public void PrepararDatos(string rutaDirectorioDatos)
        {
            this.repositorio = new RepositorioMemoria();
            CargadorDatos cargador = new CargadorDatos();
            cargador.CargarTodo(this.repositorio, rutaDirectorioDatos);
        }

        /// <summary>
        /// Verifica que la transaccion tenga los datos necesarios para ser liquidada.
        /// </summary>
        private bool ValidarTransaccion(Transaccion transaccion)
        {
            if (transaccion == null)
            {
                transaccionesDescartadas++;
                return false;
            }
            if (transaccion.FechaHora == DateTime.MinValue)
            {
                transaccionesDescartadas++;
                return false;
            }
            if (transaccion.Moneda == null || transaccion.Moneda != "PEN")
            {
                transaccionesDescartadas++;
                return false;
            }
            if (transaccion.Monto <= 0)
            {
                transaccionesDescartadas++;
                return false;
            }
            acumuladoGeneralTransado = acumuladoGeneralTransado + transaccion.Monto;
            return true;
        }

        /// <summary>
        /// Genera las liquidaciones de todos los comercios para el periodo indicado,
        /// las imprime por consola y devuelve la lista resultante.
        /// </summary>
        public List<Liquidacion> ProcesarLiquidacionCompleta(string periodo, string rutaDirectorioDatos)
        {
            List<Liquidacion> resultado = new List<Liquidacion>();

            if (this.repositorio == null)
            {
                this.repositorio = new RepositorioMemoria();
                CargadorDatos cargador = new CargadorDatos();
                cargador.CargarTodo(this.repositorio, rutaDirectorioDatos + Path.DirectorySeparatorChar);
            }

            DateTime inicioPeriodo = utilidadesFecha.InicioDePeriodo(periodo);
            DateTime finPeriodo = utilidadesFecha.FinDePeriodo(periodo);

            Console.WriteLine("==========================================================");
            Console.WriteLine("  PASARELA ANDINA - LIQUIDACION DE COMERCIOS");
            Console.WriteLine("  Periodo: " + periodo);
            Console.WriteLine("  Desde: " + inicioPeriodo.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture));
            Console.WriteLine("  Hasta: " + finPeriodo.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture));
            Console.WriteLine("==========================================================");
            Console.WriteLine();

            List<Comercio> comercios = repositorio.BuscarComerciosActivos();

            foreach (Comercio comercio in comercios)
            {
                if (comercio.Estado == EstadoComercio.DE_BAJA)
                {
                    continue;
                }

                PlanComisiones plan = repositorio.BuscarPlanPorId(comercio.IdPlanComisiones);

                if (plan != null)
                {
                    Liquidacion liquidacion = new Liquidacion();
                    liquidacion.IdComercio = comercio.Id;
                    liquidacion.RazonSocial = comercio.RazonSocial;
                    liquidacion.Periodo = periodo;
                    liquidacion.FechaGeneracion = DateTime.Now;

                    double totalTransado = 0.0;
                    double totalComisiones = 0.0;
                    int cantidadTransacciones = 0;

                    List<Transaccion> transacciones = repositorio.BuscarTransaccionesDeComercio(comercio.Id);

                    foreach (Transaccion transaccion in transacciones)
                    {
                        if (ValidarTransaccion(transaccion))
                        {
                            DateTime fechaTransaccion = transaccion.FechaHora;

                            if (fechaTransaccion >= inicioPeriodo && fechaTransaccion <= finPeriodo)
                            {
                                if (transaccion.Estado == EstadoTransaccion.APROBADA)
                                {
                                    double montoTransaccion = transaccion.Monto;
                                    double porcentajeAplicado = 0.0;
                                    bool tramoEncontrado = false;

                                    foreach (TramoComision tramo in plan.Tramos)
                                    {
                                        if (!tramoEncontrado)
                                        {
                                            if (montoTransaccion >= tramo.MontoDesde
                                                    && montoTransaccion < tramo.MontoHasta)
                                            {
                                                porcentajeAplicado = tramo.Porcentaje;
                                                tramoEncontrado = true;
                                            }
                                        }
                                    }

                                    if (!tramoEncontrado)
                                    {
                                        if (plan.Tramos.Count > 0)
                                        {
                                            porcentajeAplicado = plan.Tramos[plan.Tramos.Count - 1].Porcentaje;
                                        }
                                    }

                                    double comisionBase = montoTransaccion * porcentajeAplicado / 100.0;
                                    comisionBase = comisionBase + plan.MontoFijoPorTransaccion;

                                    double recargo = 0.0;

                                    if (transaccion.Cuotas > 1)
                                    {
                                        double porcentajeRecargo = (transaccion.Cuotas - 1) * 0.5;

                                        if (porcentajeRecargo > 3.0)
                                        {
                                            porcentajeRecargo = 3.0;
                                        }

                                        recargo = comisionBase * porcentajeRecargo / 100.0;
                                    }

                                    double comisionTotal = comisionBase + recargo;

                                    DetalleLiquidacion linea = new DetalleLiquidacion();
                                    linea.IdTransaccion = transaccion.Id;
                                    linea.MontoTransaccion = montoTransaccion;
                                    linea.ComisionBase = comisionBase;
                                    linea.RecargoCuotas = recargo;
                                    linea.ComisionTotal = comisionTotal;
                                    linea.Cuotas = transaccion.Cuotas;
                                    linea.MedioPago = transaccion.MedioPago.ToString();
                                    liquidacion.AgregarDetalle(linea);

                                    totalTransado = totalTransado + montoTransaccion;
                                    totalComisiones = totalComisiones + comisionTotal;
                                    cantidadTransacciones++;

                                    acumuladoGeneralComisiones = acumuladoGeneralComisiones + comisionTotal;
                                }
                            }
                        }
                    }

                    if (totalComisiones > plan.TopeMensual)
                    {
                        totalComisiones = plan.TopeMensual;
                        liquidacion.TopeAplicado = true;
                    }

                    double totalContracargos = 0.0;

                    List<Contracargo> contracargos = repositorio.BuscarContracargosDeComercio(comercio.Id);

                    foreach (Contracargo contracargo in contracargos)
                    {
                        if (contracargo.Estado == EstadoContracargo.APROBADO)
                        {
                            DateTime fechaContracargo = contracargo.Fecha;

                            if (fechaContracargo != DateTime.MinValue)
                            {
                                if (fechaContracargo >= inicioPeriodo
                                        && fechaContracargo <= finPeriodo)
                                {
                                    totalContracargos = totalContracargos + contracargo.Monto;
                                }
                            }
                        }
                    }

                    double retenciones = 0.0;

                    DateTime fechaAfiliacion = comercio.FechaAfiliacion;

                    if (fechaAfiliacion != DateTime.MinValue)
                    {
                        int meses = utilidadesFecha.MesesEntre(fechaAfiliacion, inicioPeriodo);

                        if (meses < 6)
                        {
                            double baseRetencion = totalTransado - totalComisiones - totalContracargos;

                            if (baseRetencion > 0)
                            {
                                retenciones = baseRetencion * 0.05;
                            }
                        }
                    }

                    totalTransado = CompatibilidadJava.RedondearADosDecimales(totalTransado);
                    totalComisiones = CompatibilidadJava.RedondearADosDecimales(totalComisiones);
                    totalContracargos = CompatibilidadJava.RedondearADosDecimales(totalContracargos);
                    retenciones = CompatibilidadJava.RedondearADosDecimales(retenciones);

                    liquidacion.TotalTransado = totalTransado;
                    liquidacion.TotalComisiones = totalComisiones;
                    liquidacion.TotalContracargos = totalContracargos;
                    liquidacion.Retenciones = retenciones;
                    liquidacion.CantidadTransacciones = cantidadTransacciones;

                    double neto = liquidacion.ObtenerMontoNeto();
                    neto = CompatibilidadJava.RedondearADosDecimales(neto);
                    liquidacion.EstablecerMontoNeto(neto);

                    string observacionRegistro = "";

                    try
                    {
                        string registro = comercio.RegistroTributario;

                        if (registro != null)
                        {
                            if (registro.Length == 11)
                            {
                                string prefijo = registro.Substring(0, 2);

                                if (prefijo != "10" && prefijo != "20"
                                        && prefijo != "15" && prefijo != "17")
                                {
                                    observacionRegistro = "registro con prefijo no habitual";
                                }
                            }
                            else
                            {
                                observacionRegistro = "registro de largo invalido";
                            }
                        }
                    }
                    catch (Exception)
                    {
                    }

                    double montoCredito = 0.0;
                    double montoDebito = 0.0;
                    double montoBilletera = 0.0;
                    double montoTransferencia = 0.0;
                    int transaccionesEnCuotas = 0;

                    foreach (DetalleLiquidacion linea in liquidacion.Detalle)
                    {
                        if (linea.MedioPago != null)
                        {
                            if (linea.MedioPago == "TARJETA_CREDITO")
                            {
                                montoCredito = montoCredito + linea.MontoTransaccion;

                                if (linea.Cuotas > 1)
                                {
                                    transaccionesEnCuotas++;
                                }
                            }
                            else
                            {
                                if (linea.MedioPago == "TARJETA_DEBITO")
                                {
                                    montoDebito = montoDebito + linea.MontoTransaccion;
                                }
                                else
                                {
                                    if (linea.MedioPago == "BILLETERA_MOVIL")
                                    {
                                        montoBilletera = montoBilletera + linea.MontoTransaccion;
                                    }
                                    else
                                    {
                                        montoTransferencia = montoTransferencia + linea.MontoTransaccion;
                                    }
                                }
                            }
                        }
                    }

                    if (cantidadTransacciones > 0)
                    {
                        resultado.Add(liquidacion);

                        Console.WriteLine("Comercio " + comercio.Id + " - " + comercio.RazonSocial);
                        Console.WriteLine("  Transacciones liquidadas : " + cantidadTransacciones);
                        Console.WriteLine("  Total transado           : S/ " + FormatearMonto(totalTransado));
                        Console.WriteLine("  Total comisiones         : S/ " + FormatearMonto(totalComisiones)
                                + (liquidacion.TopeAplicado ? "  (tope aplicado)" : ""));
                        Console.WriteLine("  Contracargos             : S/ " + FormatearMonto(totalContracargos));
                        Console.WriteLine("  Retenciones              : S/ " + FormatearMonto(retenciones));
                        Console.WriteLine("  Monto neto a pagar       : S/ " + FormatearMonto(neto));

                        if (montoCredito > 0 || montoDebito > 0 || montoBilletera > 0 || montoTransferencia > 0)
                        {
                            Console.WriteLine("  Desglose por medio de pago:");

                            if (montoCredito > 0)
                            {
                                Console.WriteLine("    Tarjeta de credito     : S/ " + FormatearMonto(montoCredito)
                                        + (transaccionesEnCuotas > 0 ? "  (" + transaccionesEnCuotas + " en cuotas)" : ""));
                            }
                            if (montoDebito > 0)
                            {
                                Console.WriteLine("    Tarjeta de debito      : S/ " + FormatearMonto(montoDebito));
                            }
                            if (montoBilletera > 0)
                            {
                                Console.WriteLine("    Billetera movil        : S/ " + FormatearMonto(montoBilletera));
                            }
                            if (montoTransferencia > 0)
                            {
                                Console.WriteLine("    Transferencia          : S/ " + FormatearMonto(montoTransferencia));
                            }
                        }

                        if (observacionRegistro.Length > 0)
                        {
                            Console.WriteLine("  Observacion              : " + observacionRegistro);
                        }

                        Console.WriteLine();
                    }
                }
            }

            Console.WriteLine("==========================================================");
            Console.WriteLine("  Comercios liquidados     : " + resultado.Count);
            Console.WriteLine("  Transacciones descartadas: " + transaccionesDescartadas);
            Console.WriteLine("==========================================================");

            return resultado;
        }

        private string FormatearMonto(double monto)
        {
            return CompatibilidadJava.FormatearDosDecimales(monto);
        }

        public double AcumuladoGeneralTransado { get { return acumuladoGeneralTransado; } }

        public double AcumuladoGeneralComisiones { get { return acumuladoGeneralComisiones; } }

        public int TransaccionesDescartadas { get { return transaccionesDescartadas; } }

        public RepositorioMemoria Repositorio { get { return repositorio; } }
    }
}
