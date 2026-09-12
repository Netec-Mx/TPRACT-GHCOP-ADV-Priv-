using System.Collections.Generic;

namespace Pe.PasarelaAndina.Modelo
{
    /// <summary>
    /// Tarifario asignado a un comercio.
    ///
    /// Los tramos son acumulativos: el monto de cada transaccion se reparte entre
    /// los tramos que atraviesa y cada porcion paga el porcentaje de su tramo.
    /// </summary>
    public class PlanComisiones
    {
        public string Id { get; set; }
        public string Nombre { get; set; }
        public List<TramoComision> Tramos { get; set; } = new List<TramoComision>();
        public double MontoFijoPorTransaccion { get; set; }
        public double TopeMensual { get; set; }

        public PlanComisiones()
        {
        }

        public PlanComisiones(string id, string nombre, double montoFijoPorTransaccion, double topeMensual)
        {
            Id = id;
            Nombre = nombre;
            MontoFijoPorTransaccion = montoFijoPorTransaccion;
            TopeMensual = topeMensual;
        }

        public void AgregarTramo(TramoComision tramo)
        {
            Tramos.Add(tramo);
        }

        public override string ToString()
        {
            return "Plan{" + Id + ", " + Nombre + ", tramos=" + Tramos.Count + "}";
        }
    }
}
