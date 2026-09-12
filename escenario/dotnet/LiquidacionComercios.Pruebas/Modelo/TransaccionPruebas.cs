using System;

using Pe.PasarelaAndina.Modelo;
using Xunit;

namespace Pe.PasarelaAndina.Pruebas.Modelo
{
    /// <summary>
    /// Pruebas del modelo de transaccion.
    /// </summary>
    public class TransaccionPruebas
    {
        [Fact]
        public void ElConstructorCompletoAsignaTodosLosCampos()
        {
            DateTime fecha = new DateTime(2026, 6, 18, 16, 32, 34);
            Transaccion transaccion = new Transaccion("TX000001", "CM0001", 250.50, "PEN",
                    fecha, MedioPago.TARJETA_CREDITO, 3, EstadoTransaccion.APROBADA, "ABC123");

            Assert.Equal("TX000001", transaccion.Id);
            Assert.Equal("CM0001", transaccion.IdComercio);
            Assert.Equal(250.50, transaccion.Monto);
            Assert.Equal("PEN", transaccion.Moneda);
            Assert.Equal(fecha, transaccion.FechaHora);
            Assert.Equal(MedioPago.TARJETA_CREDITO, transaccion.MedioPago);
            Assert.Equal(3, transaccion.Cuotas);
            Assert.Equal(EstadoTransaccion.APROBADA, transaccion.Estado);
            Assert.Equal("ABC123", transaccion.CodigoAutorizacion);
        }

        [Fact]
        public void LasPropiedadesGuardanElValorRecibido()
        {
            Transaccion transaccion = new Transaccion();

            transaccion.Id = "TX000999";
            transaccion.IdComercio = "CM0040";
            transaccion.Monto = 1800.00;
            transaccion.Moneda = "PEN";
            transaccion.MedioPago = MedioPago.BILLETERA_MOVIL;
            transaccion.Cuotas = 1;
            transaccion.Estado = EstadoTransaccion.ANULADA;
            transaccion.CodigoAutorizacion = "ZZ9988";

            Assert.Equal("TX000999", transaccion.Id);
            Assert.Equal("CM0040", transaccion.IdComercio);
            Assert.Equal(1800.00, transaccion.Monto);
            Assert.Equal(MedioPago.BILLETERA_MOVIL, transaccion.MedioPago);
            Assert.Equal(1, transaccion.Cuotas);
            Assert.Equal(EstadoTransaccion.ANULADA, transaccion.Estado);
            Assert.Equal("ZZ9988", transaccion.CodigoAutorizacion);
        }

        [Fact]
        public void ElTextoDeLaTransaccionIncluyeSuIdentificador()
        {
            Transaccion transaccion = new Transaccion();
            transaccion.Id = "TX000123";
            transaccion.IdComercio = "CM0003";
            transaccion.Monto = 99.90;
            transaccion.Estado = EstadoTransaccion.APROBADA;

            string texto = transaccion.ToString();

            Assert.NotNull(texto);
            Assert.Contains("TX000123", texto);
        }

        [Fact]
        public void LosMediosDePagoEstanCompletos()
        {
            Assert.Equal(4, Enum.GetValues(typeof(MedioPago)).Length);
            Assert.Equal(MedioPago.TRANSFERENCIA, Enum.Parse<MedioPago>("TRANSFERENCIA"));
        }

        [Fact]
        public void LosEstadosDeTransaccionEstanCompletos()
        {
            Assert.Equal(4, Enum.GetValues(typeof(EstadoTransaccion)).Length);
            Assert.Equal(EstadoTransaccion.PENDIENTE, Enum.Parse<EstadoTransaccion>("PENDIENTE"));
        }

        [Fact]
        public void ElDetalleDeLiquidacionGuardaSusValores()
        {
            DetalleLiquidacion detalle = new DetalleLiquidacion();
            detalle.IdTransaccion = "TX000500";
            detalle.MontoTransaccion = 1000.00;
            detalle.ComisionBase = 29.30;
            detalle.RecargoCuotas = 0.29;
            detalle.ComisionTotal = 29.59;
            detalle.Cuotas = 2;
            detalle.MedioPago = "TARJETA_CREDITO";

            Assert.Equal("TX000500", detalle.IdTransaccion);
            Assert.Equal(1000.00, detalle.MontoTransaccion);
            Assert.Equal(29.30, detalle.ComisionBase);
            Assert.Equal(0.29, detalle.RecargoCuotas);
            Assert.Equal(29.59, detalle.ComisionTotal);
            Assert.Equal(2, detalle.Cuotas);
            Assert.Equal("TARJETA_CREDITO", detalle.MedioPago);
        }
    }
}
