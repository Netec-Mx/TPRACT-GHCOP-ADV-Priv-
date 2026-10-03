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
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
ASEryem8DgAA
DATOS
        ;;
    incidente)
        entregar incidente "$raiz/docs/proyecto/incidentes/INC-2026-0042.md" <<'DATOS'
H4sIAAAAAAACA3VUTU8bMRC9768YiWuyXQIqVQ9IkHLgAGqL1PvEHsIgrx38sSoof6ZHDpy49bp/
rDNeIG3VHqI4tt+bN2+eswfn3rAlnwnOL5fzRbd4P++6w0XTbGGJ/SbAFr6hCxG2zXY+n9ePnH0l
wyu2ATZ6BBeUECwB3heLYEJP0TA6BQmN1xUsQ4wU5JZ7vRBmEIn8wPhClArQLZmSeQgT9uWiwi+6
rtufyZZPoe6dYozoTYCr9qRdthXwOXKIbNFWUZaxVakOey0MffBZiib2YHB8slVzojhwrSH4k8Rr
r3JQCM7uCm8q0Ep/MQbnFE3r4uWG54G0w2ZvT0r5hLf0R3NNcwynhXxIYMcnTKpk4ISKdQiOhd2i
4fHZa4nb4kXDXSFQhHO0Hp+17qaMj6nqLDD+dJl7FGI0uaDjhwk/g4F6QSnaVf85Vd5UVvIN5OHq
Hezvt10njqcNmVzbkrsKucGVCBQCITZBAuHqRGSpRROnTD0CSkjU3Y91lYDEfKU9Why1B4dwD3gT
Itadgw+y08JlEF3e8sRshYfFfzFO3O9XrBVVxcah18sJWEtolDSQ3lIUeePjdFvamOoqAtcYZxoZ
lZ9Y2OWgeNEUgxyEHIXtdRAKWYkFlDJG4LUY1zbHgjmRIhl7LTbTn7ZnLyLjq6n/jVqd+WXIWAe+
i+xb8JvmbBcEyEyeIOKDjkSEVNElqTkZk8z7xY8Y1AcylFhsKh7rsIrqnkYrnRey2NQ3E6cgZzJe
4pvEzJkMIeFKbEssQ72vINTMRcnz36a8uVmpnfowNfZFPU9Si/VFS3/1GTTNfquOXHPshU/zkwxG
tVQJNPjahIy8djula6A4BdEXGrBtFi2cfd84FmANKpaENWdOp4S5zmrnXNsctPBJ/mpqR3gtucV/
dCLRA1PGH45S2xzqO5N3lacSOwfxd95fs+MF6/kEAAA=
DATOS
        ;;
    *)
        echo "Uso: bash scripts/proyecto/entregar.sh <formato-del-reporte|incidente>" >&2
        exit 2
        ;;
esac
