#!/usr/bin/env bash
#
# Verifica el reporte de comisiones por medio de pago contra la salida esperada.
#
# Compila el escenario indicado, ejecuta el reporte con --reporte-medios para el periodo y
# compara el SHA-256 de su salida con el esperado. El script solo contiene los hashes, no la
# salida esperada.
#
# Codigo de salida:
#   0  La salida coincide con la esperada.
#   1  El reporte existe, pero su salida no coincide.
#   2  Argumentos no validos, herramienta faltante o error de compilacion.
#   3  El reporte todavia no existe en este escenario.
#
# Corre en macOS, Linux y Git Bash sobre Windows. Se ejecuta desde la raiz del repositorio.

set -u

readonly VERSION_SCRIPT="1.1.0"

raiz="$(cd "$(dirname "$0")/.." && pwd)"

hash_esperado() {
    case "$1" in
        2026-04) echo "27534969cec3c43949643b0d0629db10fdcb970ed12d85d88fc4bcffe250c824" ;;
        2026-05) echo "fe15488d1e9f9a1cb4df5de9fd12ba58d19afc0cfc4da88c1ca69cadbf10021d" ;;
        2026-06) echo "f1667ce7116857fe1a990a31189e9d94a9d71f917818217a0acf9298b47186d7" ;;
        *) echo "" ;;
    esac
}

uso() {
    cat <<EOF
Uso: bash scripts/verificar-reporte.sh <java|dotnet> <periodo> [--sin-compilar]

Ejecuta el reporte de comisiones por medio de pago del escenario indicado y compara su
salida con la esperada. Periodos con salida esperada: 2026-04, 2026-05 y 2026-06.

Opciones:
  --sin-compilar   Usa los binarios ya construidos.
  --ayuda          Muestra esta ayuda y termina.
  --version        Muestra la version del script y termina.
EOF
}

calcular_hash() {
    # Sin \r, igual que integracion-local.sh: en Windows, un fin de linea CRLF no es una
    # diferencia del reporte.
    if command -v sha256sum >/dev/null 2>&1; then
        tr -d '\r' < "$1" | sha256sum | cut -d' ' -f1
    else
        tr -d '\r' < "$1" | shasum -a 256 | cut -d' ' -f1
    fi
}

case "${1:-}" in
    --ayuda|-h) uso; exit 0 ;;
    --version)  echo "verificar-reporte.sh $VERSION_SCRIPT"; exit 0 ;;
esac

stack="${1:-}"
periodo="${2:-}"
compilar=1
[ "${3:-}" = "--sin-compilar" ] && compilar=0

if [ "$stack" != "java" ] && [ "$stack" != "dotnet" ]; then
    uso >&2; exit 2
fi
esperado=$(hash_esperado "$periodo")
if [ -z "$esperado" ]; then
    printf 'No hay salida esperada para el periodo "%s". Usa 2026-04, 2026-05 o 2026-06.\n' "$periodo" >&2
    exit 2
fi

temporal=$(mktemp -d 2>/dev/null || mktemp -d -t verificar-reporte)
trap 'rm -rf "$temporal"' EXIT
salida="$temporal/reporte.txt"

if [ "$stack" = "java" ]; then
    cd "$raiz/escenario/java" || exit 2
    if [ "$compilar" -eq 1 ] && ! mvn -q clean package -DskipTests > "$temporal/compilar.log" 2>&1; then
        echo "El escenario Java no compila. Revisa la salida de: mvn clean package" >&2
        exit 2
    fi
    java -jar target/liquidacion-comercios.jar --reporte-medios "$periodo" > "$salida" 2> "$temporal/error.log"
else
    cd "$raiz/escenario/dotnet" || exit 2
    if [ "$compilar" -eq 1 ] && ! dotnet build LiquidacionComercios -c Release > "$temporal/compilar.log" 2>&1; then
        echo "El escenario .NET no compila. Revisa la salida de: dotnet build LiquidacionComercios -c Release" >&2
        exit 2
    fi
    dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll --reporte-medios "$periodo" \
        > "$salida" 2> "$temporal/error.log"
fi

if ! grep -q "COMISIONES POR MEDIO DE PAGO" "$salida"; then
    echo "El reporte de comisiones por medio de pago todavía no existe en el escenario $stack."
    echo "El programa no reconoce el argumento --reporte-medios. No hay nada que comparar."
    exit 3
fi

obtenido=$(calcular_hash "$salida")
if [ "$obtenido" = "$esperado" ]; then
    echo "El reporte de $stack para $periodo coincide con la salida esperada."
    exit 0
fi
echo "El reporte de $stack para $periodo NO coincide con la salida esperada."
echo "  Esperado: $esperado"
echo "  Obtenido: $obtenido"
echo "Revisa los valores y el formato contra la historia de usuario."
exit 1
