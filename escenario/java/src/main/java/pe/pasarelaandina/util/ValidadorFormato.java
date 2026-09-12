package pe.pasarelaandina.util;

/**
 * Validaciones de formato de los identificadores que maneja la pasarela.
 */
public final class ValidadorFormato {

    private ValidadorFormato() {
    }

    /**
     * El registro tributario peruano tiene once digitos y empieza en 10, 15, 17 o 20.
     */
    public static boolean esRegistroTributarioValido(String registro) {
        if (registro == null || registro.length() != 11) {
            return false;
        }
        for (int i = 0; i < registro.length(); i++) {
            if (!Character.isDigit(registro.charAt(i))) {
                return false;
            }
        }
        String prefijo = registro.substring(0, 2);
        return prefijo.equals("10") || prefijo.equals("15")
                || prefijo.equals("17") || prefijo.equals("20");
    }

    /**
     * El codigo de autorizacion son seis caracteres alfanumericos en mayuscula.
     */
    public static boolean esCodigoAutorizacionValido(String codigo) {
        if (codigo == null || codigo.length() != 6) {
            return false;
        }
        for (int i = 0; i < codigo.length(); i++) {
            char caracter = codigo.charAt(i);
            boolean digito = caracter >= '0' && caracter <= '9';
            boolean mayuscula = caracter >= 'A' && caracter <= 'Z';
            if (!digito && !mayuscula) {
                return false;
            }
        }
        return true;
    }

    /**
     * El identificador de comercio tiene el formato CM seguido de cuatro digitos.
     */
    public static boolean esIdComercioValido(String id) {
        if (id == null || id.length() != 6) {
            return false;
        }
        if (!id.startsWith("CM")) {
            return false;
        }
        for (int i = 2; i < id.length(); i++) {
            if (!Character.isDigit(id.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    /**
     * El periodo se expresa como aaaa-mm.
     */
    public static boolean esPeriodoValido(String periodo) {
        if (periodo == null || periodo.length() != 7) {
            return false;
        }
        if (periodo.charAt(4) != '-') {
            return false;
        }
        try {
            int anio = Integer.parseInt(periodo.substring(0, 4));
            int mes = Integer.parseInt(periodo.substring(5, 7));
            return anio >= 2000 && anio <= 2100 && mes >= 1 && mes <= 12;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
