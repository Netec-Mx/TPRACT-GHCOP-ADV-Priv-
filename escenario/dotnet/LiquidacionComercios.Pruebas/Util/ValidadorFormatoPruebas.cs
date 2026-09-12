using Pe.PasarelaAndina.Util;
using Xunit;

namespace Pe.PasarelaAndina.Pruebas.Util
{
    /// <summary>
    /// Pruebas de las validaciones de formato.
    /// </summary>
    public class ValidadorFormatoPruebas
    {
        [Fact]
        public void AceptaRegistrosTributariosConPrefijoValido()
        {
            Assert.True(ValidadorFormato.EsRegistroTributarioValido("20123456789"));
            Assert.True(ValidadorFormato.EsRegistroTributarioValido("10123456789"));
            Assert.True(ValidadorFormato.EsRegistroTributarioValido("15123456789"));
            Assert.True(ValidadorFormato.EsRegistroTributarioValido("17123456789"));
        }

        [Fact]
        public void RechazaRegistrosTributariosMalFormados()
        {
            Assert.False(ValidadorFormato.EsRegistroTributarioValido(null));
            Assert.False(ValidadorFormato.EsRegistroTributarioValido(""));
            Assert.False(ValidadorFormato.EsRegistroTributarioValido("2012345678"));
            Assert.False(ValidadorFormato.EsRegistroTributarioValido("201234567890"));
            Assert.False(ValidadorFormato.EsRegistroTributarioValido("2012345678A"));
            Assert.False(ValidadorFormato.EsRegistroTributarioValido("30123456789"));
        }

        [Fact]
        public void AceptaCodigosDeAutorizacionDeSeisAlfanumericos()
        {
            Assert.True(ValidadorFormato.EsCodigoAutorizacionValido("ABC123"));
            Assert.True(ValidadorFormato.EsCodigoAutorizacionValido("000000"));
            Assert.True(ValidadorFormato.EsCodigoAutorizacionValido("ZZZZZZ"));
        }

        [Fact]
        public void RechazaCodigosDeAutorizacionInvalidos()
        {
            Assert.False(ValidadorFormato.EsCodigoAutorizacionValido(null));
            Assert.False(ValidadorFormato.EsCodigoAutorizacionValido("ABC12"));
            Assert.False(ValidadorFormato.EsCodigoAutorizacionValido("ABC1234"));
            Assert.False(ValidadorFormato.EsCodigoAutorizacionValido("abc123"));
            Assert.False(ValidadorFormato.EsCodigoAutorizacionValido("ABC-12"));
        }

        [Fact]
        public void AceptaIdentificadoresDeComercioBienFormados()
        {
            Assert.True(ValidadorFormato.EsIdComercioValido("CM0001"));
            Assert.True(ValidadorFormato.EsIdComercioValido("CM9999"));
        }

        [Fact]
        public void RechazaIdentificadoresDeComercioMalFormados()
        {
            Assert.False(ValidadorFormato.EsIdComercioValido(null));
            Assert.False(ValidadorFormato.EsIdComercioValido("CM001"));
            Assert.False(ValidadorFormato.EsIdComercioValido("XX0001"));
            Assert.False(ValidadorFormato.EsIdComercioValido("CM00A1"));
        }

        [Fact]
        public void AceptaPeriodosEnFormatoAnioMes()
        {
            Assert.True(ValidadorFormato.EsPeriodoValido("2026-01"));
            Assert.True(ValidadorFormato.EsPeriodoValido("2026-06"));
            Assert.True(ValidadorFormato.EsPeriodoValido("2026-12"));
        }

        [Fact]
        public void RechazaPeriodosInvalidos()
        {
            Assert.False(ValidadorFormato.EsPeriodoValido(null));
            Assert.False(ValidadorFormato.EsPeriodoValido("2026/06"));
            Assert.False(ValidadorFormato.EsPeriodoValido("2026-13"));
            Assert.False(ValidadorFormato.EsPeriodoValido("2026-00"));
            Assert.False(ValidadorFormato.EsPeriodoValido("202606"));
            Assert.False(ValidadorFormato.EsPeriodoValido("abcd-ef"));
        }
    }
}
