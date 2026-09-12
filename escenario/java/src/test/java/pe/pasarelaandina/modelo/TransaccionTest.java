package pe.pasarelaandina.modelo;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.util.Date;

import org.junit.jupiter.api.Test;

/**
 * Pruebas del modelo de transaccion.
 */
class TransaccionTest {

    @Test
    void elConstructorCompletoAsignaTodosLosCampos() {
        Date fecha = new Date();
        Transaccion transaccion = new Transaccion("TX000001", "CM0001", 250.50, "PEN",
                fecha, MedioPago.TARJETA_CREDITO, 3, EstadoTransaccion.APROBADA, "ABC123");

        assertEquals("TX000001", transaccion.getId());
        assertEquals("CM0001", transaccion.getIdComercio());
        assertEquals(250.50, transaccion.getMonto());
        assertEquals("PEN", transaccion.getMoneda());
        assertEquals(fecha, transaccion.getFechaHora());
        assertEquals(MedioPago.TARJETA_CREDITO, transaccion.getMedioPago());
        assertEquals(3, transaccion.getCuotas());
        assertEquals(EstadoTransaccion.APROBADA, transaccion.getEstado());
        assertEquals("ABC123", transaccion.getCodigoAutorizacion());
    }

    @Test
    void losSetterGuardanElValorRecibido() {
        Transaccion transaccion = new Transaccion();

        transaccion.setId("TX000999");
        transaccion.setIdComercio("CM0040");
        transaccion.setMonto(1800.00);
        transaccion.setMoneda("PEN");
        transaccion.setMedioPago(MedioPago.BILLETERA_MOVIL);
        transaccion.setCuotas(1);
        transaccion.setEstado(EstadoTransaccion.ANULADA);
        transaccion.setCodigoAutorizacion("ZZ9988");

        assertEquals("TX000999", transaccion.getId());
        assertEquals("CM0040", transaccion.getIdComercio());
        assertEquals(1800.00, transaccion.getMonto());
        assertEquals(MedioPago.BILLETERA_MOVIL, transaccion.getMedioPago());
        assertEquals(1, transaccion.getCuotas());
        assertEquals(EstadoTransaccion.ANULADA, transaccion.getEstado());
        assertEquals("ZZ9988", transaccion.getCodigoAutorizacion());
    }

    @Test
    void elTextoDeLaTransaccionIncluyeSuIdentificador() {
        Transaccion transaccion = new Transaccion();
        transaccion.setId("TX000123");
        transaccion.setIdComercio("CM0003");
        transaccion.setMonto(99.90);
        transaccion.setEstado(EstadoTransaccion.APROBADA);

        String texto = transaccion.toString();

        assertNotNull(texto);
        assertEquals(true, texto.contains("TX000123"));
    }

    @Test
    void losMediosDePagoEstanCompletos() {
        assertEquals(4, MedioPago.values().length);
        assertEquals(MedioPago.TRANSFERENCIA, MedioPago.valueOf("TRANSFERENCIA"));
    }

    @Test
    void losEstadosDeTransaccionEstanCompletos() {
        assertEquals(4, EstadoTransaccion.values().length);
        assertEquals(EstadoTransaccion.PENDIENTE, EstadoTransaccion.valueOf("PENDIENTE"));
    }

    @Test
    void elDetalleDeLiquidacionGuardaSusValores() {
        DetalleLiquidacion detalle = new DetalleLiquidacion();
        detalle.setIdTransaccion("TX000500");
        detalle.setMontoTransaccion(1000.00);
        detalle.setComisionBase(29.30);
        detalle.setRecargoCuotas(0.29);
        detalle.setComisionTotal(29.59);
        detalle.setCuotas(2);
        detalle.setMedioPago("TARJETA_CREDITO");

        assertEquals("TX000500", detalle.getIdTransaccion());
        assertEquals(1000.00, detalle.getMontoTransaccion());
        assertEquals(29.30, detalle.getComisionBase());
        assertEquals(0.29, detalle.getRecargoCuotas());
        assertEquals(29.59, detalle.getComisionTotal());
        assertEquals(2, detalle.getCuotas());
        assertEquals("TARJETA_CREDITO", detalle.getMedioPago());
    }
}
