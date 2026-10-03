#!/usr/bin/env bash
#
# Conciliacion del reporte de comisiones por medio de pago con las liquidaciones.
#
# Para un periodo, compara el total del reporte con la suma del «Total comisiones» de todas
# las liquidaciones del mismo periodo. Las cuentas se hacen en centavos enteros, sin punto
# flotante.
#
# Se ejecuta desde la raiz de un clon del repositorio de participantes con la solucion del
# reporte aplicada.
#
# Uso: bash conciliar.sh <periodo> [--stack java|dotnet] [--sin-compilar]
#
# Codigo de salida: 0 si concilia, 1 si no concilia, 2 si algo impide conciliar.

set -u

periodo="${1:-}"
stack="java"
compilar=1
shift || true
while [ $# -gt 0 ]; do
    case "$1" in
        --stack) stack="${2:-}"; shift 2 ;;
        --sin-compilar) compilar=0; shift ;;
        *) echo "Argumento no valido: $1" >&2; exit 2 ;;
    esac
done
case "$periodo" in [0-9][0-9][0-9][0-9]-[0-9][0-9]) ;; *) echo "Uso: bash conciliar.sh <AAAA-MM> [--stack java|dotnet] [--sin-compilar]" >&2; exit 2 ;; esac

raiz="$(pwd)"
temporal=$(mktemp -d 2>/dev/null || mktemp -d -t conciliar)
trap 'rm -rf "$temporal"' EXIT

ejecutar() {
    if [ "$stack" = "java" ]; then
        (cd "$raiz/escenario/java" && java -jar target/liquidacion-comercios.jar "$@")
    else
        (cd "$raiz/escenario/dotnet" && dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll "$@")
    fi
}

if [ "$compilar" -eq 1 ]; then
    if [ "$stack" = "java" ]; then
        (cd "$raiz/escenario/java" && mvn -q clean package -DskipTests) > "$temporal/c.log" 2>&1 || { echo "No compila Java" >&2; exit 2; }
    elif [ "$stack" = "dotnet" ]; then
        (cd "$raiz/escenario/dotnet" && dotnet build LiquidacionComercios -c Release) > "$temporal/c.log" 2>&1 || { echo "No compila .NET" >&2; exit 2; }
    else
        echo "Stack no valido: $stack" >&2; exit 2
    fi
fi

ejecutar "$periodo" > "$temporal/liquidacion.txt" 2>/dev/null
ejecutar --reporte-medios "$periodo" > "$temporal/reporte.txt" 2>/dev/null
grep -q "COMISIONES POR MEDIO DE PAGO" "$temporal/reporte.txt" || { echo "El reporte no existe en este clon" >&2; exit 2; }

# Montos a centavos enteros: "S/ 1234.56" -> 123456.
# Toma el monto que sigue a «S/», aunque la linea siga con texto, como «(tope aplicado)».
centavos() { awk '{ sub(/.*S\/ /, ""); split($0, c, " "); v=c[1]; s=1; if (substr(v,1,1)=="-") { s=-1; v=substr(v,2) } split(v,p,"."); print s*(p[1]*100+p[2]) }'; }

# Solo las lineas de cada comercio. El resumen general tambien dice «Total comisiones», con
# un espacio mas antes de los dos puntos, y no se suma.
readonly LINEA_COMERCIO='^  Total comisiones         : S/ '
liquidaciones=$(grep "$LINEA_COMERCIO" "$temporal/liquidacion.txt" | centavos | awk '{ t+=$1 } END { print t+0 }')
cantidad=$(grep -c "$LINEA_COMERCIO" "$temporal/liquidacion.txt")
reporte=$(grep "^Total " "$temporal/reporte.txt" | centavos)
diferencia=$((reporte - liquidaciones))

formato() { awk -v c="$1" 'BEGIN { s=""; if (c<0) { s="-"; c=-c } printf "%s%d.%02d", s, int(c/100), c%100 }'; }

echo "Periodo $periodo, escenario $stack"
echo "  Liquidaciones        : $cantidad"
echo "  Suma de comisiones   : S/ $(formato "$liquidaciones")"
echo "  Total del reporte    : S/ $(formato "$reporte")"
echo "  Diferencia           : S/ $(formato "$diferencia")"
if [ "$diferencia" -eq 0 ]; then
    echo "  Concilia."
    exit 0
fi
echo "  NO concilia."
exit 1
