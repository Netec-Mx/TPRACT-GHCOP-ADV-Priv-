#!/usr/bin/env bash
#
# Aplica la solucion de referencia del reporte de comisiones por medio de pago sobre un clon
# del repositorio de participantes en su punto de partida. Sirve para poner al dia a un
# grupo atrasado.
#
# Uso: bash aplicar.sh <java|dotnet|ambos> <ruta del clon> [--con-correccion]
#
# --con-correccion aplica ademas la mantencion correctiva de la liquidacion, despues del
# reporte. Es la solucion del paso de mantencion, no la del reporte.
#
# Codigo de salida: 0 si se aplico todo, 1 si algun parche no se aplica limpio, 2 si los
# argumentos no son validos.

set -u

aqui="$(cd "$(dirname "$0")" && pwd)"
stacks="${1:-}"
clon="${2:-}"
correccion=0
[ "${3:-}" = "--con-correccion" ] && correccion=1

case "$stacks" in
    java) lista="java" ;;
    dotnet) lista="dotnet" ;;
    ambos) lista="java dotnet" ;;
    *) echo "Uso: bash aplicar.sh <java|dotnet|ambos> <ruta del clon> [--con-correccion]" >&2; exit 2 ;;
esac
if [ -z "$clon" ] || [ ! -d "$clon/escenario" ]; then
    echo "No encuentro escenario/ en «$clon». Indica la raiz de un clon del repositorio de participantes." >&2
    exit 2
fi

fallas=0
for s in $lista; do
    parches="reporte-$s.patch"
    [ "$correccion" -eq 1 ] && parches="$parches correccion-$s.patch"
    for p in $parches; do
        if git -C "$clon" apply --check "$aqui/$p" 2>/dev/null && git -C "$clon" apply "$aqui/$p"; then
            echo "  [ OK ] $p"
        else
            echo "  [FALLA] $p no se aplica limpio sobre el clon. ¿Esta en el punto de partida?"
            fallas=$((fallas + 1))
        fi
    done
done
[ "$fallas" -eq 0 ]
