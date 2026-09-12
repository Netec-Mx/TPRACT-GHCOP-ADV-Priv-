using System.Collections.Generic;

using Pe.PasarelaAndina.Modelo;
using Pe.PasarelaAndina.Repositorio;

namespace Pe.PasarelaAndina.Calculo
{
    /// <summary>
    /// Consulta puntual que usa el area comercial para estimar cuanto pagaria un
    /// comercio por una venta antes de cerrar el periodo.
    /// </summary>
    public class SimuladorComision
    {
        private readonly RepositorioMemoria repositorio;
        private readonly CalculadoraComision calculadoraComision = new CalculadoraComision();

        public SimuladorComision(RepositorioMemoria repositorio)
        {
            this.repositorio = repositorio;
        }

        public double SimularComision(string idComercio, double monto, int cuotas)
        {
            Comercio comercio = repositorio.BuscarComercioPorId(idComercio);
            if (comercio == null)
            {
                return 0.0;
            }
            PlanComisiones plan = repositorio.BuscarPlanPorId(comercio.IdPlanComisiones);
            if (plan == null)
            {
                return 0.0;
            }

            Transaccion simulada = new Transaccion();
            simulada.Id = "SIMULADA";
            simulada.IdComercio = idComercio;
            simulada.Monto = monto;
            simulada.Moneda = "PEN";
            simulada.Cuotas = cuotas;
            simulada.Estado = EstadoTransaccion.APROBADA;

            return calculadoraComision.Redondear(
                    calculadoraComision.CalcularComisionTotal(plan, simulada));
        }

        public double SimularComisionDeTransaccion(string idTransaccion)
        {
            Transaccion transaccion = repositorio.BuscarTransaccionPorId(idTransaccion);
            if (transaccion == null)
            {
                return 0.0;
            }
            return SimularComision(transaccion.IdComercio,
                    transaccion.Monto, transaccion.Cuotas);
        }

        public double SimularTotalDeComercio(string idComercio)
        {
            double total = 0.0;
            List<Transaccion> transacciones = repositorio.BuscarTransaccionesDeComercio(idComercio);
            foreach (Transaccion transaccion in transacciones)
            {
                if (transaccion.Estado == EstadoTransaccion.APROBADA)
                {
                    total += SimularComision(transaccion.IdComercio,
                            transaccion.Monto, transaccion.Cuotas);
                }
            }
            return calculadoraComision.Redondear(total);
        }
    }
}
