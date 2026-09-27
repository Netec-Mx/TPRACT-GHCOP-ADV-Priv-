package pe.pasarelaandina.calculo;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import pe.pasarelaandina.util.ConfiguracionRegional;

/**
 * Manejo de fechas del proceso de liquidacion.
 *
 * El periodo corre desde el primer dia del mes a las cero horas hasta el
 * ultimo dia a las 23:59:59, en hora de Lima.
 */
public class UtilidadesFecha {

    private static final String FORMATO_FECHA_HORA = "yyyy-MM-dd HH:mm:ss";
    private static final String FORMATO_FECHA = "yyyy-MM-dd";

    /**
     * Devuelve un calendario con la configuracion regional fijada.
     *
     * Sin fijarla, Calendar.getInstance() usa la de la maquina, y hay idiomas cuyo
     * calendario por omision no es el gregoriano. Con la maquina en tailandes devuelve
     * un BuddhistCalendar, de modo que al establecer el año 2026 el programa calcula
     * sobre el año 1483 y el periodo de liquidacion queda completamente desplazado.
     * Eso no es un problema de formato: cambia los datos que entran al calculo.
     *
     * Se usa el constructor que solo recibe la configuracion regional. La zona horaria
     * sigue siendo la del sistema, igual que antes y sin mencionarla aqui: ese es un
     * comportamiento que este metodo conserva sin cambios.
     */
    private Calendar calendarioDeTrabajo() {
        return Calendar.getInstance(ConfiguracionRegional.REGION_DE_SALIDA);
    }

    public Date parsearFechaHora(String texto) {
        SimpleDateFormat formato =
                new SimpleDateFormat(FORMATO_FECHA_HORA, ConfiguracionRegional.REGION_DE_SALIDA);
        try {
            return formato.parse(texto);
        } catch (ParseException e) {
            return null;
        }
    }

    public Date parsearFecha(String texto) {
        SimpleDateFormat formato =
                new SimpleDateFormat(FORMATO_FECHA, ConfiguracionRegional.REGION_DE_SALIDA);
        try {
            return formato.parse(texto);
        } catch (ParseException e) {
            return null;
        }
    }

    public String formatearFechaHora(Date fecha) {
        if (fecha == null) {
            return "";
        }
        return new SimpleDateFormat(FORMATO_FECHA_HORA,
                ConfiguracionRegional.REGION_DE_SALIDA).format(fecha);
    }

    public String formatearFecha(Date fecha) {
        if (fecha == null) {
            return "";
        }
        return new SimpleDateFormat(FORMATO_FECHA,
                ConfiguracionRegional.REGION_DE_SALIDA).format(fecha);
    }

    /**
     * Primer instante del periodo indicado en formato aaaa-mm.
     */
    public Date inicioDePeriodo(String periodo) {
        int anio = Integer.parseInt(periodo.substring(0, 4));
        int mes = Integer.parseInt(periodo.substring(5, 7));

        Calendar calendario = calendarioDeTrabajo();
        calendario.set(Calendar.YEAR, anio);
        calendario.set(Calendar.MONTH, mes - 1);
        calendario.set(Calendar.DAY_OF_MONTH, 1);
        calendario.set(Calendar.HOUR_OF_DAY, 0);
        calendario.set(Calendar.MINUTE, 0);
        calendario.set(Calendar.SECOND, 0);
        calendario.set(Calendar.MILLISECOND, 0);
        return calendario.getTime();
    }

    /**
     * Ultimo instante del periodo indicado en formato aaaa-mm.
     */
    public Date finDePeriodo(String periodo) {
        int anio = Integer.parseInt(periodo.substring(0, 4));
        int mes = Integer.parseInt(periodo.substring(5, 7));

        Calendar calendario = calendarioDeTrabajo();
        calendario.set(Calendar.YEAR, anio);
        calendario.set(Calendar.MONTH, mes - 1);
        calendario.set(Calendar.DAY_OF_MONTH, calendario.getActualMaximum(Calendar.DAY_OF_MONTH));
        calendario.set(Calendar.HOUR_OF_DAY, 23);
        calendario.set(Calendar.MINUTE, 59);
        calendario.set(Calendar.SECOND, 59);
        calendario.set(Calendar.MILLISECOND, 0);
        return calendario.getTime();
    }

    /**
     * Indica si la fecha cae dentro del periodo.
     */
    public boolean estaEnPeriodo(Date fecha, String periodo) {
        if (fecha == null) {
            return false;
        }
        Date inicio = inicioDePeriodo(periodo);
        Date fin = finDePeriodo(periodo);
        return !fecha.before(inicio) && !fecha.after(fin);
    }

    /**
     * Meses completos transcurridos entre dos fechas.
     */
    public int mesesEntre(Date desde, Date hasta) {
        if (desde == null || hasta == null) {
            return 0;
        }

        Calendar calendarioDesde = calendarioDeTrabajo();
        calendarioDesde.setTime(desde);
        Calendar calendarioHasta = calendarioDeTrabajo();
        calendarioHasta.setTime(hasta);

        int anios = calendarioHasta.get(Calendar.YEAR) - calendarioDesde.get(Calendar.YEAR);
        int meses = calendarioHasta.get(Calendar.MONTH) - calendarioDesde.get(Calendar.MONTH);
        int total = anios * 12 + meses;

        if (calendarioHasta.get(Calendar.DAY_OF_MONTH) < calendarioDesde.get(Calendar.DAY_OF_MONTH)) {
            total = total - 1;
        }
        return total;
    }

    public String periodoDe(Date fecha) {
        if (fecha == null) {
            return "";
        }
        Calendar calendario = calendarioDeTrabajo();
        calendario.setTime(fecha);
        int anio = calendario.get(Calendar.YEAR);
        int mes = calendario.get(Calendar.MONTH) + 1;
        return anio + "-" + (mes < 10 ? "0" + mes : String.valueOf(mes));
    }
}
