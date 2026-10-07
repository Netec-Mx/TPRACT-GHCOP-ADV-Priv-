package pe.pasarelaandina.calculo;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.junit.jupiter.api.Test;

/**
 * Pruebas del fin de periodo con el reloj fijado.
 */
class UtilidadesFechaTest {

    /** Utilidades de fecha con el reloj del sistema fijado en el dia indicado. */
    private static UtilidadesFecha conRelojEn(int anio, int mes, int dia) {
        return new UtilidadesFecha() {
            @Override
            Calendar calendarioDeTrabajo() {
                Calendar calendario = super.calendarioDeTrabajo();
                calendario.clear();
                calendario.set(anio, mes - 1, dia, 10, 0, 0);
                return calendario;
            }
        };
    }

    @Test
    void elFinDeUnMesDeTreintaDiasNoDependeDeQueHoySeaDia31() {
        UtilidadesFecha utilidades = conRelojEn(2026, 10, 31);
        SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        assertEquals("2026-04-30 23:59:59", formato.format(utilidades.finDePeriodo("2026-04")));
    }
}
