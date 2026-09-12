using System;

namespace Pe.PasarelaAndina.Modelo
{
    /// <summary>
    /// Desconocimiento de un cargo por parte del tarjetahabiente.
    /// </summary>
    public class Contracargo
    {
        public string Id { get; set; }
        public string IdTransaccion { get; set; }
        public double Monto { get; set; }
        public DateTime Fecha { get; set; }
        public MotivoContracargo Motivo { get; set; }
        public EstadoContracargo Estado { get; set; }

        public Contracargo()
        {
        }

        public Contracargo(string id, string idTransaccion, double monto, DateTime fecha,
                           MotivoContracargo motivo, EstadoContracargo estado)
        {
            Id = id;
            IdTransaccion = idTransaccion;
            Monto = monto;
            Fecha = fecha;
            Motivo = motivo;
            Estado = estado;
        }

        public override string ToString()
        {
            return "Contracargo{" + Id + ", " + IdTransaccion + ", " + Monto + ", " + Estado + "}";
        }
    }
}
