using System;
using Pe.PasarelaAndina.Calculo;
using Xunit;

namespace Pe.PasarelaAndina.Pruebas.Calculo
{
    /// <summary>
    /// Pruebas del fin de periodo. FinDePeriodo no lee el reloj del sistema: calcula el
    /// ultimo dia con DateTime.DaysInMonth, asi que el resultado es el mismo cualquier dia
    /// que se ejecute, tambien un dia 31.
    /// </summary>
    public class UtilidadesFechaPruebas
    {
        [Fact]
        public void ElFinDeUnMesDeTreintaDiasNoDependeDeQueHoySeaDia31()
        {
            var utilidades = new UtilidadesFecha();

            Assert.Equal(new DateTime(2026, 4, 30, 23, 59, 59), utilidades.FinDePeriodo("2026-04"));
        }
    }
}
