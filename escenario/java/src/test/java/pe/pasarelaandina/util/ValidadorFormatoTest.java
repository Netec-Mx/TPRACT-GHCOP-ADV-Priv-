package pe.pasarelaandina.util;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

/**
 * Pruebas de las validaciones de formato.
 */
class ValidadorFormatoTest {

    @Test
    void aceptaRegistrosTributariosConPrefijoValido() {
        assertTrue(ValidadorFormato.esRegistroTributarioValido("20123456789"));
        assertTrue(ValidadorFormato.esRegistroTributarioValido("10123456789"));
        assertTrue(ValidadorFormato.esRegistroTributarioValido("15123456789"));
        assertTrue(ValidadorFormato.esRegistroTributarioValido("17123456789"));
    }

    @Test
    void rechazaRegistrosTributariosMalFormados() {
        assertFalse(ValidadorFormato.esRegistroTributarioValido(null));
        assertFalse(ValidadorFormato.esRegistroTributarioValido(""));
        assertFalse(ValidadorFormato.esRegistroTributarioValido("2012345678"));
        assertFalse(ValidadorFormato.esRegistroTributarioValido("201234567890"));
        assertFalse(ValidadorFormato.esRegistroTributarioValido("2012345678A"));
        assertFalse(ValidadorFormato.esRegistroTributarioValido("30123456789"));
    }

    @Test
    void aceptaCodigosDeAutorizacionDeSeisAlfanumericos() {
        assertTrue(ValidadorFormato.esCodigoAutorizacionValido("ABC123"));
        assertTrue(ValidadorFormato.esCodigoAutorizacionValido("000000"));
        assertTrue(ValidadorFormato.esCodigoAutorizacionValido("ZZZZZZ"));
    }

    @Test
    void rechazaCodigosDeAutorizacionInvalidos() {
        assertFalse(ValidadorFormato.esCodigoAutorizacionValido(null));
        assertFalse(ValidadorFormato.esCodigoAutorizacionValido("ABC12"));
        assertFalse(ValidadorFormato.esCodigoAutorizacionValido("ABC1234"));
        assertFalse(ValidadorFormato.esCodigoAutorizacionValido("abc123"));
        assertFalse(ValidadorFormato.esCodigoAutorizacionValido("ABC-12"));
    }

    @Test
    void aceptaIdentificadoresDeComercioBienFormados() {
        assertTrue(ValidadorFormato.esIdComercioValido("CM0001"));
        assertTrue(ValidadorFormato.esIdComercioValido("CM9999"));
    }

    @Test
    void rechazaIdentificadoresDeComercioMalFormados() {
        assertFalse(ValidadorFormato.esIdComercioValido(null));
        assertFalse(ValidadorFormato.esIdComercioValido("CM001"));
        assertFalse(ValidadorFormato.esIdComercioValido("XX0001"));
        assertFalse(ValidadorFormato.esIdComercioValido("CM00A1"));
    }

    @Test
    void aceptaPeriodosEnFormatoAnioMes() {
        assertTrue(ValidadorFormato.esPeriodoValido("2026-01"));
        assertTrue(ValidadorFormato.esPeriodoValido("2026-06"));
        assertTrue(ValidadorFormato.esPeriodoValido("2026-12"));
    }

    @Test
    void rechazaPeriodosInvalidos() {
        assertFalse(ValidadorFormato.esPeriodoValido(null));
        assertFalse(ValidadorFormato.esPeriodoValido("2026/06"));
        assertFalse(ValidadorFormato.esPeriodoValido("2026-13"));
        assertFalse(ValidadorFormato.esPeriodoValido("2026-00"));
        assertFalse(ValidadorFormato.esPeriodoValido("202606"));
        assertFalse(ValidadorFormato.esPeriodoValido("abcd-ef"));
    }
}
