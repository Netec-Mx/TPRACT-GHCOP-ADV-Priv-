using System;

using Pe.PasarelaAndina.Modelo;
using Xunit;

namespace Pe.PasarelaAndina.Pruebas.Modelo
{
    /// <summary>
    /// Pruebas del modelo de comercio.
    /// </summary>
    public class ComercioPruebas
    {
        [Fact]
        public void ElConstructorVacioDejaLosCamposSinValor()
        {
            Comercio comercio = new Comercio();

            Assert.Null(comercio.Id);
            Assert.Null(comercio.RazonSocial);
            Assert.Null(comercio.RegistroTributario);
            Assert.Null(comercio.IdPlanComisiones);
        }

        [Fact]
        public void ElConstructorCompletoAsignaTodosLosCampos()
        {
            DateTime afiliacion = new DateTime(2025, 3, 14);
            Comercio comercio = new Comercio("CM0001", "Comercial Andina S.A.C.", "20123456789",
                    CategoriaNegocio.RETAIL, afiliacion, EstadoComercio.ACTIVO, "PL01");

            Assert.Equal("CM0001", comercio.Id);
            Assert.Equal("Comercial Andina S.A.C.", comercio.RazonSocial);
            Assert.Equal("20123456789", comercio.RegistroTributario);
            Assert.Equal(CategoriaNegocio.RETAIL, comercio.Categoria);
            Assert.Equal(afiliacion, comercio.FechaAfiliacion);
            Assert.Equal(EstadoComercio.ACTIVO, comercio.Estado);
            Assert.Equal("PL01", comercio.IdPlanComisiones);
        }

        [Fact]
        public void LasPropiedadesGuardanElValorRecibido()
        {
            Comercio comercio = new Comercio();

            comercio.Id = "CM0042";
            comercio.RazonSocial = "Servicios Pacifico E.I.R.L.";
            comercio.RegistroTributario = "20987654321";
            comercio.Categoria = CategoriaNegocio.SERVICIOS;
            comercio.Estado = EstadoComercio.SUSPENDIDO;
            comercio.IdPlanComisiones = "PL03";

            Assert.Equal("CM0042", comercio.Id);
            Assert.Equal("Servicios Pacifico E.I.R.L.", comercio.RazonSocial);
            Assert.Equal("20987654321", comercio.RegistroTributario);
            Assert.Equal(CategoriaNegocio.SERVICIOS, comercio.Categoria);
            Assert.Equal(EstadoComercio.SUSPENDIDO, comercio.Estado);
            Assert.Equal("PL03", comercio.IdPlanComisiones);
        }

        [Fact]
        public void ElTextoDelComercioIncluyeIdentificadorYRazonSocial()
        {
            Comercio comercio = new Comercio();
            comercio.Id = "CM0007";
            comercio.RazonSocial = "Inversiones Andina S.R.L.";
            comercio.Estado = EstadoComercio.ACTIVO;

            string texto = comercio.ToString();

            Assert.NotNull(texto);
            Assert.Contains("CM0007", texto);
            Assert.Contains("Inversiones Andina S.R.L.", texto);
        }

        [Fact]
        public void LasCategoriasDeNegocioEstanCompletas()
        {
            Assert.Equal(8, Enum.GetValues(typeof(CategoriaNegocio)).Length);
            Assert.Equal(CategoriaNegocio.RETAIL, Enum.Parse<CategoriaNegocio>("RETAIL"));
            Assert.Equal(CategoriaNegocio.TRANSPORTE, Enum.Parse<CategoriaNegocio>("TRANSPORTE"));
        }

        [Fact]
        public void LosEstadosDeComercioEstanCompletos()
        {
            Assert.Equal(3, Enum.GetValues(typeof(EstadoComercio)).Length);
            Assert.Equal(EstadoComercio.ACTIVO, Enum.Parse<EstadoComercio>("ACTIVO"));
            Assert.Equal(EstadoComercio.DE_BAJA, Enum.Parse<EstadoComercio>("DE_BAJA"));
        }
    }
}
