using System;
using System.Globalization;

namespace Pe.PasarelaAndina.Util
{
    /// <summary>
    /// Validaciones de formato de los identificadores que maneja la pasarela.
    /// </summary>
    public static class ValidadorFormato
    {
        /// <summary>
        /// El registro tributario peruano tiene once digitos y empieza en 10, 15, 17 o 20.
        /// </summary>
        public static bool EsRegistroTributarioValido(string registro)
        {
            if (registro == null || registro.Length != 11)
            {
                return false;
            }
            for (int i = 0; i < registro.Length; i++)
            {
                if (!char.IsDigit(registro[i]))
                {
                    return false;
                }
            }
            string prefijo = registro.Substring(0, 2);
            return prefijo == "10" || prefijo == "15"
                    || prefijo == "17" || prefijo == "20";
        }

        /// <summary>
        /// El codigo de autorizacion son seis caracteres alfanumericos en mayuscula.
        /// </summary>
        public static bool EsCodigoAutorizacionValido(string codigo)
        {
            if (codigo == null || codigo.Length != 6)
            {
                return false;
            }
            for (int i = 0; i < codigo.Length; i++)
            {
                char caracter = codigo[i];
                bool digito = caracter >= '0' && caracter <= '9';
                bool mayuscula = caracter >= 'A' && caracter <= 'Z';
                if (!digito && !mayuscula)
                {
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// El identificador de comercio tiene el formato CM seguido de cuatro digitos.
        /// </summary>
        public static bool EsIdComercioValido(string id)
        {
            if (id == null || id.Length != 6)
            {
                return false;
            }
            if (!id.StartsWith("CM", StringComparison.Ordinal))
            {
                return false;
            }
            for (int i = 2; i < id.Length; i++)
            {
                if (!char.IsDigit(id[i]))
                {
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// El periodo se expresa como aaaa-mm.
        /// </summary>
        public static bool EsPeriodoValido(string periodo)
        {
            if (periodo == null || periodo.Length != 7)
            {
                return false;
            }
            if (periodo[4] != '-')
            {
                return false;
            }
            try
            {
                int anio = int.Parse(periodo.Substring(0, 4), CultureInfo.InvariantCulture);
                int mes = int.Parse(periodo.Substring(5, 2), CultureInfo.InvariantCulture);
                return anio >= 2000 && anio <= 2100 && mes >= 1 && mes <= 12;
            }
            catch (FormatException)
            {
                return false;
            }
        }
    }
}
