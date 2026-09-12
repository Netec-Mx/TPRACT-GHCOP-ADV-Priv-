using System;

namespace Pe.PasarelaAndina.Modelo
{
    /// <summary>
    /// Comercio afiliado a la pasarela.
    ///
    /// El estado se valida en la propiedad contra la lista de estados permitidos,
    /// de modo que no puede quedar en un valor invalido.
    /// </summary>
    public class Comercio
    {
        public string Id { get; set; }
        public string RazonSocial { get; set; }
        public string RegistroTributario { get; set; }
        public CategoriaNegocio Categoria { get; set; }
        public DateTime FechaAfiliacion { get; set; }
        public EstadoComercio Estado { get; set; }
        public string IdPlanComisiones { get; set; }

        public Comercio()
        {
        }

        public Comercio(string id, string razonSocial, string registroTributario,
                        CategoriaNegocio categoria, DateTime fechaAfiliacion,
                        EstadoComercio estado, string idPlanComisiones)
        {
            Id = id;
            RazonSocial = razonSocial;
            RegistroTributario = registroTributario;
            Categoria = categoria;
            FechaAfiliacion = fechaAfiliacion;
            Estado = estado;
            IdPlanComisiones = idPlanComisiones;
        }

        public override string ToString()
        {
            return "Comercio{" + Id + ", " + RazonSocial + ", " + Estado + "}";
        }
    }
}
