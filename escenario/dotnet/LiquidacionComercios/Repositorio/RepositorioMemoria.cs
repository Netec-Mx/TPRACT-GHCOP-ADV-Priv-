using System.Collections.Generic;

using Pe.PasarelaAndina.Modelo;

namespace Pe.PasarelaAndina.Repositorio
{
    /// <summary>
    /// Almacen en memoria de los datos del proceso.
    /// </summary>
    public class RepositorioMemoria
    {
        private readonly List<Comercio> comercios = new List<Comercio>();
        private readonly List<PlanComisiones> planes = new List<PlanComisiones>();
        private readonly List<Transaccion> transacciones = new List<Transaccion>();
        private readonly List<Contracargo> contracargos = new List<Contracargo>();

        public void AgregarComercio(Comercio comercio)
        {
            comercios.Add(comercio);
        }

        public void AgregarPlan(PlanComisiones plan)
        {
            planes.Add(plan);
        }

        public void AgregarTransaccion(Transaccion transaccion)
        {
            transacciones.Add(transaccion);
        }

        public void AgregarContracargo(Contracargo contracargo)
        {
            contracargos.Add(contracargo);
        }

        public List<Comercio> Comercios { get { return comercios; } }

        public List<PlanComisiones> Planes { get { return planes; } }

        public List<Transaccion> Transacciones { get { return transacciones; } }

        public List<Contracargo> Contracargos { get { return contracargos; } }

        /// <summary>
        /// Devuelve los comercios que estan en condiciones de ser liquidados.
        /// </summary>
        public List<Comercio> BuscarComerciosActivos()
        {
            List<Comercio> resultado = new List<Comercio>();
            foreach (Comercio comercio in comercios)
            {
                resultado.Add(comercio);
            }
            return resultado;
        }

        public Comercio BuscarComercioPorId(string id)
        {
            foreach (Comercio comercio in comercios)
            {
                if (comercio.Id == id)
                {
                    return comercio;
                }
            }
            return null;
        }

        public PlanComisiones BuscarPlanPorId(string id)
        {
            foreach (PlanComisiones plan in planes)
            {
                if (plan.Id == id)
                {
                    return plan;
                }
            }
            return null;
        }

        public Transaccion BuscarTransaccionPorId(string id)
        {
            foreach (Transaccion transaccion in transacciones)
            {
                if (transaccion.Id == id)
                {
                    return transaccion;
                }
            }
            return null;
        }

        public List<Transaccion> BuscarTransaccionesDeComercio(string idComercio)
        {
            List<Transaccion> resultado = new List<Transaccion>();
            foreach (Transaccion transaccion in transacciones)
            {
                if (transaccion.IdComercio == idComercio)
                {
                    resultado.Add(transaccion);
                }
            }
            return resultado;
        }

        public List<Contracargo> BuscarContracargosDeComercio(string idComercio)
        {
            List<Contracargo> resultado = new List<Contracargo>();
            foreach (Contracargo contracargo in contracargos)
            {
                Transaccion transaccion = BuscarTransaccionPorId(contracargo.IdTransaccion);
                if (transaccion != null && transaccion.IdComercio == idComercio)
                {
                    resultado.Add(contracargo);
                }
            }
            return resultado;
        }

        public int ContarComercios()
        {
            return comercios.Count;
        }

        public int ContarTransacciones()
        {
            return transacciones.Count;
        }

        public int ContarContracargos()
        {
            return contracargos.Count;
        }
    }
}
