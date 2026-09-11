#!/usr/bin/env bash
#
# Verificacion del ambiente para el taller de GitHub Copilot.
#
# Diagnostica el puesto de trabajo: presencia y version de las herramientas requeridas y
# conectividad a los dominios que GitHub Copilot necesita. No instala ni modifica nada.
#
# Codigo de salida: 0 si el ambiente esta apto, 1 si falta cualquier requisito obligatorio.
#
# Compatible con bash 3.2 en adelante, para que funcione en macOS sin instalar nada.

set -u

# ---------------------------------------------------------------------------
# Version del script y requisitos minimos
# ---------------------------------------------------------------------------

readonly VERSION_SCRIPT="1.0.0"

# Version minima exigida por herramienta. Debe coincidir con docs/00-setup-ambiente.md.
readonly MIN_GIT="2.40"
readonly MIN_JDK="21"
readonly MIN_DOTNET="8.0"
readonly MIN_NODE="22"
readonly MIN_CODE="1.95"
readonly MIN_MAVEN="3.9"

# Dominios obligatorios para que GitHub Copilot funcione.
readonly DOMINIOS_OBLIGATORIOS="github.com api.github.com api.githubcopilot.com proxy.individual.githubcopilot.com copilot-proxy.githubusercontent.com default.exp-tas.com"

# Dominios recomendados. Su ausencia advierte pero no reprueba el ambiente.
readonly DOMINIOS_RECOMENDADOS="copilot-telemetry.githubusercontent.com marketplace.visualstudio.com"

readonly TIMEOUT_RED=8

# ---------------------------------------------------------------------------
# Estado acumulado
# ---------------------------------------------------------------------------

fallas=0
avisos=0
comprobar_red=1

# Listas de texto plano, una entrada por linea, para el resumen final.
detalle_fallas=""
detalle_avisos=""

# ---------------------------------------------------------------------------
# Salida en pantalla
# ---------------------------------------------------------------------------

if [ -t 1 ] && [ "${NO_COLOR:-}" = "" ]; then
    C_OK=$'\033[0;32m'
    C_FALLA=$'\033[0;31m'
    C_AVISO=$'\033[0;33m'
    C_TITULO=$'\033[1;36m'
    C_FIN=$'\033[0m'
else
    C_OK=""; C_FALLA=""; C_AVISO=""; C_TITULO=""; C_FIN=""
fi

titulo() {
    printf '\n%s== %s ==%s\n' "$C_TITULO" "$1" "$C_FIN"
}

ok() {
    printf '  %s[ OK ]%s %s\n' "$C_OK" "$C_FIN" "$1"
}

falla() {
    printf '  %s[FALLA]%s %s\n' "$C_FALLA" "$C_FIN" "$1"
    fallas=$((fallas + 1))
    detalle_fallas="${detalle_fallas}${1}
"
}

aviso() {
    printf '  %s[AVISO]%s %s\n' "$C_AVISO" "$C_FIN" "$1"
    avisos=$((avisos + 1))
    detalle_avisos="${detalle_avisos}${1}
"
}

# ---------------------------------------------------------------------------
# Utilidades
# ---------------------------------------------------------------------------

uso() {
    cat <<EOF
Uso: bash verificar-ambiente.sh [opciones]

Diagnostica el ambiente del taller de GitHub Copilot. No instala ni modifica nada.

Opciones:
  --sin-red    Omite las comprobaciones de conectividad.
  --ayuda      Muestra esta ayuda y termina.
  --version    Muestra la version del script y termina.

Codigo de salida:
  0   El ambiente esta apto.
  1   Falta al menos un requisito obligatorio.
EOF
}

# Extrae de la entrada estandar el primer numero con formato X, X.Y o X.Y.Z.
# Se toma el primero y no el ultimo porque las herramientas suelen imprimir su version al
# inicio y un identificador de compilacion despues: "git version 2.54.0 (Apple Git-157)".
extraer_version() {
    grep -oE '[0-9]+(\.[0-9]+){0,2}' | head -n 1
}

# Devuelve el componente numerico en la posicion indicada, o 0 si la version no lo trae.
componente_version() {
    valor=$(printf '%s' "$1" | cut -d. -f"$2")
    case "$valor" in
        ''|*[!0-9]*) printf '0' ;;
        *) printf '%d' "$((10#$valor))" ;;
    esac
}

# Compara dos versiones. Devuelve 0 si $1 >= $2, 1 en caso contrario.
# Solo se comparan los componentes presentes en el minimo, de modo que "21.0.1" cumpla "21".
version_suficiente() {
    encontrada="$1"
    minima="$2"

    total=$(printf '%s' "$minima" | tr '.' ' ' | wc -w | tr -d ' ')
    indice=1

    while [ "$indice" -le "$total" ]; do
        parte_enc=$(componente_version "$encontrada" "$indice")
        parte_min=$(componente_version "$minima" "$indice")

        if [ "$parte_enc" -gt "$parte_min" ]; then return 0; fi
        if [ "$parte_enc" -lt "$parte_min" ]; then return 1; fi

        indice=$((indice + 1))
    done

    return 0
}

# verificar_herramienta <etiqueta> <binario> <minima> <obligatoria:si|no> <comando de version>
verificar_herramienta() {
    etiqueta="$1"
    binario="$2"
    minima="$3"
    obligatoria="$4"
    shift 4

    if ! command -v "$binario" >/dev/null 2>&1; then
        if [ "$obligatoria" = "si" ]; then
            falla "$etiqueta no esta instalado o no esta en el PATH (se requiere $minima o superior)"
        else
            aviso "$etiqueta no esta instalado o no esta en el PATH (recomendado $minima o superior)"
        fi
        return
    fi

    salida=$("$@" 2>&1)
    encontrada=$(printf '%s\n' "$salida" | extraer_version)

    if [ -z "$encontrada" ]; then
        aviso "$etiqueta esta instalado pero no se pudo determinar su version"
        return
    fi

    if version_suficiente "$encontrada" "$minima"; then
        ok "$etiqueta $encontrada (minimo $minima)"
    else
        if [ "$obligatoria" = "si" ]; then
            falla "$etiqueta $encontrada es anterior al minimo exigido $minima"
        else
            aviso "$etiqueta $encontrada es anterior al minimo recomendado $minima"
        fi
    fi
}

# Comprueba que un dominio sea alcanzable por HTTPS.
# Cualquier respuesta del servidor cuenta como exito: lo que se valida es que la red deje
# pasar la conexion, no que el endpoint devuelva 200.
dominio_alcanzable() {
    destino="$1"

    if command -v curl >/dev/null 2>&1; then
        curl --silent --show-error --output /dev/null \
             --max-time "$TIMEOUT_RED" "https://${destino}" >/dev/null 2>&1
        return $?
    fi

    if command -v wget >/dev/null 2>&1; then
        wget --quiet --spider --timeout="$TIMEOUT_RED" --tries=1 \
             "https://${destino}" >/dev/null 2>&1
        return $?
    fi

    # Sin cliente HTTP disponible, al menos se comprueba la resolucion de nombres.
    if command -v getent >/dev/null 2>&1; then
        getent hosts "$destino" >/dev/null 2>&1
        return $?
    fi
    if command -v host >/dev/null 2>&1; then
        host "$destino" >/dev/null 2>&1
        return $?
    fi
    if command -v nslookup >/dev/null 2>&1; then
        nslookup "$destino" >/dev/null 2>&1
        return $?
    fi

    return 2
}

verificar_dominios() {
    lista="$1"
    obligatorios="$2"

    for destino in $lista; do
        dominio_alcanzable "$destino"
        resultado=$?

        case "$resultado" in
            0)
                ok "$destino alcanzable"
                ;;
            2)
                aviso "$destino no se pudo comprobar: no hay curl, wget ni utilidades de DNS"
                ;;
            *)
                if [ "$obligatorios" = "si" ]; then
                    falla "$destino no es alcanzable, revisar proxy, firewall o lista blanca"
                else
                    aviso "$destino no es alcanzable, funcionalidad degradada pero el taller es viable"
                fi
                ;;
        esac
    done
}

# ---------------------------------------------------------------------------
# Argumentos
# ---------------------------------------------------------------------------

while [ $# -gt 0 ]; do
    case "$1" in
        --sin-red)
            comprobar_red=0
            ;;
        --ayuda|-h|--help)
            uso
            exit 0
            ;;
        --version)
            printf 'verificar-ambiente.sh %s\n' "$VERSION_SCRIPT"
            exit 0
            ;;
        *)
            printf 'Opcion no reconocida: %s\n\n' "$1" >&2
            uso >&2
            exit 2
            ;;
    esac
    shift
done

# ---------------------------------------------------------------------------
# Ejecucion
# ---------------------------------------------------------------------------

printf '%sVerificacion de ambiente, taller de GitHub Copilot%s\n' "$C_TITULO" "$C_FIN"
printf 'Script version %s\n' "$VERSION_SCRIPT"
printf 'Sistema: %s\n' "$(uname -s -r 2>/dev/null || echo desconocido)"
printf 'Fecha: %s\n' "$(date '+%Y-%m-%d %H:%M:%S')"

titulo "Herramientas obligatorias"
verificar_herramienta "Git" "git" "$MIN_GIT" "si" git --version
verificar_herramienta "JDK" "java" "$MIN_JDK" "si" java -version
verificar_herramienta "SDK de .NET" "dotnet" "$MIN_DOTNET" "si" dotnet --version
verificar_herramienta "Node.js" "node" "$MIN_NODE" "si" node --version
verificar_herramienta "Visual Studio Code" "code" "$MIN_CODE" "si" code --version

titulo "Herramientas recomendadas"
verificar_herramienta "Apache Maven" "mvn" "$MIN_MAVEN" "no" mvn --version

if command -v code >/dev/null 2>&1; then
    extensiones=$(code --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]')
    for extension in github.copilot github.copilot-chat; do
        if printf '%s\n' "$extensiones" | grep -qx "$extension"; then
            ok "Extension $extension instalada"
        else
            aviso "Extension $extension no encontrada en Visual Studio Code"
        fi
    done
fi

if [ "$comprobar_red" -eq 1 ]; then
    titulo "Conectividad obligatoria de GitHub Copilot"
    verificar_dominios "$DOMINIOS_OBLIGATORIOS" "si"

    titulo "Conectividad recomendada"
    verificar_dominios "$DOMINIOS_RECOMENDADOS" "no"
else
    titulo "Conectividad"
    printf '  Omitida por --sin-red\n'
fi

# ---------------------------------------------------------------------------
# Resumen
# ---------------------------------------------------------------------------

titulo "Resumen"

if [ "$fallas" -eq 0 ] && [ "$avisos" -eq 0 ]; then
    printf '  %sAmbiente apto.%s Todos los requisitos obligatorios y recomendados estan cubiertos.\n' \
        "$C_OK" "$C_FIN"
    exit 0
fi

if [ "$fallas" -eq 0 ]; then
    printf '  %sAmbiente apto con %d advertencia(s).%s Los requisitos obligatorios estan cubiertos.\n' \
        "$C_OK" "$avisos" "$C_FIN"
    printf '\n  Advertencias:\n'
    printf '%s' "$detalle_avisos" | while IFS= read -r linea; do
        [ -n "$linea" ] && printf '    - %s\n' "$linea"
    done
    exit 0
fi

printf '  %sAmbiente NO apto.%s Faltan %d requisito(s) obligatorio(s).\n' \
    "$C_FALLA" "$C_FIN" "$fallas"
printf '\n  Requisitos faltantes:\n'
printf '%s' "$detalle_fallas" | while IFS= read -r linea; do
    [ -n "$linea" ] && printf '    - %s\n' "$linea"
done

if [ "$avisos" -gt 0 ]; then
    printf '\n  Advertencias adicionales:\n'
    printf '%s' "$detalle_avisos" | while IFS= read -r linea; do
        [ -n "$linea" ] && printf '    - %s\n' "$linea"
    done
fi

printf '\n  Revisa docs/00-setup-ambiente.md para los pasos de instalacion.\n'
exit 1
