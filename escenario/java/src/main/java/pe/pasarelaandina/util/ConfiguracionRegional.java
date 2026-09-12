package pe.pasarelaandina.util;

import java.util.Locale;

/**
 * Configuracion regional fija de la salida del escenario.
 *
 * ESTA CLASE ES UNA DECISION DELIBERADA Y NO SE DEBE REVERTIR.
 *
 * Los dos escenarios del taller deben producir salidas identicas hasta el ultimo
 * centavo, porque en clase hay participantes de ambos stacks comparando resultados.
 * El formateo de numeros y fechas en Java depende de la configuracion regional de la
 * maquina, de modo que el mismo programa sobre los mismos datos imprime cosas distintas
 * segun donde corra.
 *
 * Medido sobre este escenario antes de la correccion:
 *
 *   por defecto   S/ 26074.08     checksum 61f2c13f
 *   es-ES, de-DE  S/ 26074,08     checksum cffb6271    separador decimal distinto
 *   ar-SA         S/ ٢٦٠٧٤٫٠٨      checksum cc652d12    otros digitos
 *
 * Las maquinas virtuales del taller estan en Peru y hay alta probabilidad de que esten
 * configuradas en español, asi que el caso de la coma decimal no es hipotetico.
 *
 * El equivalente de esta decision en el escenario .NET esta en
 * Util/CompatibilidadJava.cs y en la fijacion de CultureInfo.InvariantCulture al
 * arrancar. Locale.ROOT es el neutro de Java, igual que la cultura invariante lo es
 * de .NET.
 *
 * Si alguien quita este Locale de las llamadas de formateo, el escenario vuelve a
 * depender del idioma de la maquina y la comparacion entre escenarios falla en cuanto
 * alguien lo ejecute en una VM en español.
 *
 * IMPORTANTE: esto fija la configuracion regional y nada mas. La zona horaria sigue
 * siendo la del sistema, que es un defecto plantado a proposito (DEF-04) y no se toca.
 */
public final class ConfiguracionRegional {

    /**
     * Configuracion regional neutra que se usa en todo formateo de salida.
     */
    public static final Locale REGION_DE_SALIDA = Locale.ROOT;

    private ConfiguracionRegional() {
    }
}
