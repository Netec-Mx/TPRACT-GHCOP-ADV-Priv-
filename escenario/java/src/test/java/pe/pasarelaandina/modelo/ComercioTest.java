package pe.pasarelaandina.modelo;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

import java.util.Date;

import org.junit.jupiter.api.Test;

/**
 * Pruebas del modelo de comercio.
 */
class ComercioTest {

    @Test
    void elConstructorVacioDejaLosCamposSinValor() {
        Comercio comercio = new Comercio();

        assertNull(comercio.getId());
        assertNull(comercio.getRazonSocial());
        assertNull(comercio.getRegistroTributario());
        assertNull(comercio.getCategoria());
        assertNull(comercio.getEstado());
    }

    @Test
    void elConstructorCompletoAsignaTodosLosCampos() {
        Date afiliacion = new Date();
        Comercio comercio = new Comercio("CM0001", "Comercial Andina S.A.C.", "20123456789",
                CategoriaNegocio.RETAIL, afiliacion, EstadoComercio.ACTIVO, "PL01");

        assertEquals("CM0001", comercio.getId());
        assertEquals("Comercial Andina S.A.C.", comercio.getRazonSocial());
        assertEquals("20123456789", comercio.getRegistroTributario());
        assertEquals(CategoriaNegocio.RETAIL, comercio.getCategoria());
        assertEquals(afiliacion, comercio.getFechaAfiliacion());
        assertEquals(EstadoComercio.ACTIVO, comercio.getEstado());
        assertEquals("PL01", comercio.getIdPlanComisiones());
    }

    @Test
    void losSetterGuardanElValorRecibido() {
        Comercio comercio = new Comercio();

        comercio.setId("CM0042");
        comercio.setRazonSocial("Servicios Pacifico E.I.R.L.");
        comercio.setRegistroTributario("20987654321");
        comercio.setCategoria(CategoriaNegocio.SERVICIOS);
        comercio.setEstado(EstadoComercio.SUSPENDIDO);
        comercio.setIdPlanComisiones("PL03");

        assertEquals("CM0042", comercio.getId());
        assertEquals("Servicios Pacifico E.I.R.L.", comercio.getRazonSocial());
        assertEquals("20987654321", comercio.getRegistroTributario());
        assertEquals(CategoriaNegocio.SERVICIOS, comercio.getCategoria());
        assertEquals(EstadoComercio.SUSPENDIDO, comercio.getEstado());
        assertEquals("PL03", comercio.getIdPlanComisiones());
    }

    @Test
    void elTextoDelComercioIncluyeIdentificadorYRazonSocial() {
        Comercio comercio = new Comercio();
        comercio.setId("CM0007");
        comercio.setRazonSocial("Inversiones Andina S.R.L.");
        comercio.setEstado(EstadoComercio.ACTIVO);

        String texto = comercio.toString();

        assertNotNull(texto);
        assertEquals(true, texto.contains("CM0007"));
        assertEquals(true, texto.contains("Inversiones Andina S.R.L."));
    }

    @Test
    void lasCategoriasDeNegocioEstanCompletas() {
        assertEquals(8, CategoriaNegocio.values().length);
        assertEquals(CategoriaNegocio.RETAIL, CategoriaNegocio.valueOf("RETAIL"));
        assertEquals(CategoriaNegocio.TRANSPORTE, CategoriaNegocio.valueOf("TRANSPORTE"));
    }

    @Test
    void losEstadosDeComercioEstanCompletos() {
        assertEquals(3, EstadoComercio.values().length);
        assertEquals(EstadoComercio.ACTIVO, EstadoComercio.valueOf("ACTIVO"));
        assertEquals(EstadoComercio.DE_BAJA, EstadoComercio.valueOf("DE_BAJA"));
    }
}
