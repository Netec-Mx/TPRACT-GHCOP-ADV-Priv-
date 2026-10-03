#!/usr/bin/env bash
#
# Genera scripts/proyecto/entregar.sh a partir de los documentos de docs/relator/entregas/.
#
# El script publicado contiene los documentos comprimidos y codificados en base64, para que
# no se lean por adelantado sin un esfuerzo deliberado. Las skills de laboratorio lo ejecutan
# en el momento en que el documento hace falta. Asi el relator no tiene que repartir nada.
#
# Uso: bash herramientas/generar-entregas.sh [--verificar]
#   --verificar  no escribe; termina en 1 si el script publicado no corresponde a las fuentes.

set -eu

raiz="$(cd "$(dirname "$0")/.." && pwd)"
fuentes="$raiz/docs/relator/entregas"
destino="$raiz/scripts/proyecto/entregar.sh"

codificar() { gzip -9 -n -c "$1" | base64 | tr -d '\n' | fold -w 76; echo; }

generar() {
    cat <<'CABECERA'
#!/usr/bin/env bash
#
# Entrega los documentos del capitulo 5 en el momento en que hacen falta. Lo ejecutan las
# skills de laboratorio. Los documentos van codificados para que no se lean por adelantado.
#
# Uso: bash scripts/proyecto/entregar.sh <formato-del-reporte|incidente>
#
# Codigo de salida: 0 si entrego el documento, 2 si el nombre no es valido.
#
# Generado por herramientas/generar-entregas.sh del repositorio de construccion. No editar.

set -eu

raiz="$(cd "$(dirname "$0")/../.." && pwd)"

decodificar() { tr -d '\n' | base64 -d | gunzip -c; }

entregar() {
    mkdir -p "$(dirname "$2")"
    decodificar > "$2"
    echo "Documento entregado: ${2#"$raiz"/}"
}

case "${1:-}" in
    formato-del-reporte)
        entregar formato-del-reporte "$raiz/docs/proyecto/backlog/formato-del-reporte.md" <<'DATOS'
CABECERA
    codificar "$fuentes/formato-del-reporte.md"
    cat <<'MEDIO'
DATOS
        ;;
    incidente)
        entregar incidente "$raiz/docs/proyecto/incidentes/INC-2026-0042.md" <<'DATOS'
MEDIO
    codificar "$fuentes/incidente.md"
    cat <<'PIE'
DATOS
        ;;
    *)
        echo "Uso: bash scripts/proyecto/entregar.sh <formato-del-reporte|incidente>" >&2
        exit 2
        ;;
esac
PIE
}

if [ "${1:-}" = "--verificar" ]; then
    if generar | cmp -s - "$destino"; then
        echo "  [ OK ] scripts/proyecto/entregar.sh corresponde a docs/relator/entregas/"
        exit 0
    fi
    echo "  [FALLA] scripts/proyecto/entregar.sh no corresponde a docs/relator/entregas/. Ejecuta bash herramientas/generar-entregas.sh"
    exit 1
fi

mkdir -p "$(dirname "$destino")"
generar > "$destino"
echo "Generado ${destino#"$raiz"/}"
