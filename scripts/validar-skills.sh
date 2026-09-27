#!/usr/bin/env bash
#
# Valida las skills de .github/skills contra el formato vigente de Visual Studio Code.
#
# Para cada skill comprueba:
#   - Que SKILL.md tenga bloque de metadatos y que todos sus campos esten admitidos.
#   - Que name exista, cumpla el formato y coincida con el nombre del directorio.
#   - Que description exista y no supere 1024 caracteres.
#   - Que todo archivo referenciado con un enlace Markdown o con #file: exista.
# Y ademas, para las skills de laboratorio, cuyo nombre empieza con lab-:
#   - Que declaren disable-model-invocation: true, para que el agente no las cargue solo.
#   - Que incluyan la restriccion de no corregir lo que no forma parte del paso.
#
# Fuentes del formato, consultadas el 27 de septiembre de 2026:
#   https://code.visualstudio.com/docs/agent-customization/agent-skills
#   https://agentskills.io/specification
#
# Codigo de salida: 0 si todas las skills son validas, 1 si alguna tiene errores, 2 si no
# se encontro ninguna skill.
#
# Corre en macOS, Linux y Git Bash sobre Windows.

set -u

readonly VERSION_SCRIPT="1.0.0"

# Campos que admite Visual Studio Code, mas los opcionales de la especificacion abierta.
readonly CAMPOS_ADMITIDOS="name description argument-hint user-invocable disable-model-invocation context license compatibility metadata allowed-tools"
readonly PREFIJO_LABORATORIO="lab-"
readonly FRASE_NO_CORREGIR="No corrijas nada que no forme parte de este paso"
readonly MAXIMO_NOMBRE=64
readonly MAXIMO_DESCRIPCION=1024

if [ -t 1 ] && [ "${NO_COLOR:-}" = "" ]; then
    C_OK=$'\033[0;32m'
    C_FALLA=$'\033[0;31m'
    C_TITULO=$'\033[1;36m'
    C_FIN=$'\033[0m'
else
    C_OK=""; C_FALLA=""; C_TITULO=""; C_FIN=""
fi

uso() {
    cat <<EOF
Uso: bash scripts/validar-skills.sh [directorio]

Valida las skills del directorio indicado, por omision .github/skills.

Codigo de salida:
  0   Todas las skills son validas.
  1   Al menos una skill tiene errores.
  2   No se encontro ninguna skill.
EOF
}

case "${1:-}" in
    --ayuda|-h) uso; exit 0 ;;
    --version)  echo "validar-skills.sh $VERSION_SCRIPT"; exit 0 ;;
esac

raiz="$(cd "$(dirname "$0")/.." && pwd)"
directorio="${1:-$raiz/.github/skills}"

if [ ! -d "$directorio" ]; then
    printf '%s[FALLA]%s No existe el directorio %s\n' "$C_FALLA" "$C_FIN" "$directorio"
    exit 2
fi

total=0
con_errores=0
errores_totales=0

# Imprime un error de la skill en curso y lo cuenta.
error() {
    printf '    %s- %s%s\n' "$C_FALLA" "$1" "$C_FIN"
    errores=$((errores + 1))
}

# Devuelve el bloque de metadatos, sin los delimitadores, o nada si no lo hay.
metadatos() {
    awk 'NR == 1 { if ($0 != "---") exit; next } $0 == "---" { exit } { print }' "$1" | tr -d '\r'
}

# Devuelve el valor de un campo de primer nivel, sin comillas.
valor_campo() {
    printf '%s\n' "$1" | awk -v campo="$2" '
        index($0, campo ":") == 1 {
            valor = substr($0, length(campo) + 2)
            sub(/^[ \t]+/, "", valor); sub(/[ \t]+$/, "", valor)
            if (valor ~ /^'"'"'.*'"'"'$/ || valor ~ /^".*"$/) valor = substr(valor, 2, length(valor) - 2)
            print valor; exit
        }'
}

# Valida una skill. Imprime un error por linea y retorna la cantidad de errores.
validar_skill() {
    local archivo="$1" dir_skill nombre_dir bloque campos campo nombre descripcion largo
    local referencias ref ruta
    errores=0
    dir_skill="$(dirname "$archivo")"
    nombre_dir="$(basename "$dir_skill")"
    bloque="$(metadatos "$archivo")"
    if [ -z "$bloque" ]; then
        error "SKILL.md no empieza con un bloque de metadatos delimitado por ---"
        return "$errores"
    fi


    # Campos de primer nivel: las lineas que no empiezan con espacio.
    campos="$(printf '%s\n' "$bloque" | awk '/^[^ \t#][^:]*:/ { split($0, p, ":"); print p[1] }')"
    for campo in $campos; do
        case " $CAMPOS_ADMITIDOS " in
            *" $campo "*) ;;
            *) error "Campo de metadatos no admitido: $campo" ;;
        esac
    done

    nombre="$(valor_campo "$bloque" name)"
    if [ -z "$nombre" ]; then
        error "Falta el campo name"
    else
        if ! printf '%s' "$nombre" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
            error "name '$nombre' no cumple el formato: minusculas, digitos y guiones simples, sin guion al inicio ni al final"
        fi
        if [ "${#nombre}" -gt "$MAXIMO_NOMBRE" ]; then
            error "name tiene ${#nombre} caracteres, el maximo es $MAXIMO_NOMBRE"
        fi
        if [ "$nombre" != "$nombre_dir" ]; then
            error "name '$nombre' no coincide con el directorio '$nombre_dir'"
        fi
    fi

    descripcion="$(valor_campo "$bloque" description)"
    if [ -z "$descripcion" ]; then
        error "Falta el campo description"
    else
        largo="$(printf '%s' "$descripcion" | wc -m | tr -d ' ')"
        if [ "$largo" -gt "$MAXIMO_DESCRIPCION" ]; then
            error "description tiene $largo caracteres, el maximo es $MAXIMO_DESCRIPCION"
        fi
    fi

    # Referencias a archivos: enlaces Markdown relativos y #file:, fuera de los bloques
    # de codigo.
    referencias="$(awk '
        /^[ \t]*```/ { en_codigo = !en_codigo; next }
        en_codigo { next }
        {
            linea = $0
            while (match(linea, /\]\([^)]+\)/)) {
                print substr(linea, RSTART + 2, RLENGTH - 3)
                linea = substr(linea, RSTART + RLENGTH)
            }
            linea = $0
            while (match(linea, /#file:[^ \t)`]+/)) {
                print substr(linea, RSTART + 6, RLENGTH - 6)
                linea = substr(linea, RSTART + RLENGTH)
            }
        }' "$archivo" | tr -d '\r')"
    while IFS= read -r ref; do
        [ -z "$ref" ] && continue
        case "$ref" in
            http://*|https://*|mailto:*|\#*) continue ;;
        esac
        ruta="${ref%%#*}"
        if [ ! -e "$dir_skill/$ruta" ]; then
            error "Archivo referenciado que no existe: $ref"
        fi
    done <<EOF_REFS
$referencias
EOF_REFS

    case "$nombre_dir" in
        "$PREFIJO_LABORATORIO"*)
            if [ "$(valor_campo "$bloque" disable-model-invocation)" != "true" ]; then
                error "Skill de laboratorio sin disable-model-invocation: true. El agente podria cargarla sola en otro laboratorio"
            fi
            if ! grep -q "$FRASE_NO_CORREGIR" "$archivo"; then
                error "Skill de laboratorio sin la restriccion \"$FRASE_NO_CORREGIR\""
            fi
            ;;
    esac

    return "$errores"
}

printf '%sValidacion de skills%s en %s\n' "$C_TITULO" "$C_FIN" "$directorio"

for archivo in "$directorio"/*/SKILL.md; do
    [ -f "$archivo" ] || continue
    total=$((total + 1))
    errores=0
    dir_skill="$(dirname "$archivo")"
    nombre_dir="$(basename "$dir_skill")"
    informe="$(validar_skill "$archivo")"
    errores=$?

    if [ "$errores" -eq 0 ]; then
        printf '  %s[ OK ]%s %s\n' "$C_OK" "$C_FIN" "$nombre_dir"
    else
        printf '  %s[FALLA]%s %s\n' "$C_FALLA" "$C_FIN" "$nombre_dir"
        printf '%s\n' "$informe"
        con_errores=$((con_errores + 1))
        errores_totales=$((errores_totales + errores))
    fi
done

if [ "$total" -eq 0 ]; then
    printf '%s[FALLA]%s No se encontro ninguna skill en %s\n' "$C_FALLA" "$C_FIN" "$directorio"
    exit 2
fi

printf '\n%d skills revisadas, %d con errores, %d errores en total.\n' "$total" "$con_errores" "$errores_totales"
[ "$con_errores" -eq 0 ] || exit 1
exit 0
