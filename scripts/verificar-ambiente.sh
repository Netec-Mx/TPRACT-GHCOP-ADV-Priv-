#!/usr/bin/env bash
#
# Verificacion del ambiente para el taller de GitHub Copilot.
#
# Diagnostica el puesto de trabajo: presencia y version de las herramientas requeridas y
# conectividad a los dominios que GitHub Copilot necesita. No instala ni modifica nada.
#
# Corre en macOS, Linux y Git Bash sobre Windows. Git Bash viene incluido en Git para
# Windows, que ya es un requisito del ambiente, de modo que no hace falta ningun
# interprete adicional.
#
# Codigo de salida: 0 si el ambiente esta apto, 1 si falta cualquier requisito
# obligatorio, 2 si se pasa una opcion no reconocida.
#
# Compatible con bash 3.2 en adelante, para que funcione en macOS sin instalar nada.

set -u

# ---------------------------------------------------------------------------
# Version del script y requisitos minimos
# ---------------------------------------------------------------------------

readonly VERSION_SCRIPT="2.0.0"

# Piso exigido por herramienta. Es el minimo con el que el taller es viable, no lo que se
# solicita para la imagen de la maquina virtual. La distincion entre ambos esta explicada
# en docs/00-setup-ambiente.md.
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

# Extensiones de Visual Studio Code sin las cuales el taller no se puede dictar.
readonly EXTENSIONES_COPILOT="github.copilot github.copilot-chat"

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

# Entorno de ejecucion, resuelto por detectar_entorno.
entorno_nombre="desconocido"
entorno_familia="otro"
entorno_detalle=""

# Ruta del ejecutable de Visual Studio Code, resuelta por ubicar_vscode.
vscode_ruta=""

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
Corre en macOS, Linux y Git Bash sobre Windows.

Opciones:
  --sin-red    Omite las comprobaciones de conectividad.
  --ayuda      Muestra esta ayuda y termina.
  --version    Muestra la version del script y termina.

Codigo de salida:
  0   El ambiente esta apto.
  1   Falta al menos un requisito obligatorio.
  2   Opcion no reconocida.
EOF
}

# Identifica el sistema donde corre el script y deja el resultado en las variables
# entorno_nombre, entorno_familia y entorno_detalle.
detectar_entorno() {
    sistema=$(uname -s 2>/dev/null || echo desconocido)
    entorno_detalle=$(uname -s -r 2>/dev/null || echo desconocido)

    case "$sistema" in
        Darwin)
            entorno_nombre="macOS"
            entorno_familia="unix"
            version_mac=$(sw_vers -productVersion 2>/dev/null || echo "")
            [ -n "$version_mac" ] && entorno_detalle="macOS $version_mac"
            ;;
        Linux)
            # WSL es Linux, pero conviene distinguirlo porque el participante lo usa
            # desde Windows y las rutas de sus herramientas pueden venir de ambos lados.
            if grep -qi "microsoft" /proc/version 2>/dev/null; then
                entorno_nombre="WSL sobre Windows"
            else
                entorno_nombre="Linux"
            fi
            entorno_familia="unix"
            ;;
        MINGW*|MSYS*)
            entorno_nombre="Git Bash sobre Windows"
            entorno_familia="windows"
            ;;
        CYGWIN*)
            entorno_nombre="Cygwin sobre Windows"
            entorno_familia="windows"
            ;;
        *)
            entorno_nombre="$sistema"
            entorno_familia="otro"
            ;;
    esac
}

# Convierte una ruta con formato de Windows al formato que entiende el shell.
ruta_a_unix() {
    origen="$1"
    [ -z "$origen" ] && return 0

    if command -v cygpath >/dev/null 2>&1; then
        cygpath -u "$origen" 2>/dev/null && return 0
    fi

    # Traduccion manual de "C:\ruta\archivo" a "/c/ruta/archivo" cuando no hay cygpath.
    # Se evita la conversion a minuscula de GNU sed, que no existe en la version de BSD.
    case "$origen" in
        [A-Za-z]:*)
            unidad=$(printf '%s' "$origen" | cut -c1 | tr '[:upper:]' '[:lower:]')
            resto=$(printf '%s' "$origen" | cut -c3- | tr '\\' '/')
            printf '/%s%s' "$unidad" "$resto"
            ;;
        *)
            printf '%s' "$origen" | tr '\\' '/'
            ;;
    esac
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

# Ejecuta un comando y devuelve su salida sin retornos de carro.
# En Git Bash los ejecutables nativos de Windows terminan sus lineas con CRLF, y ese \r
# sobrante rompe cualquier comparacion exacta posterior.
salida_limpia() {
    "$@" 2>&1 | tr -d '\r'
}

# verificar_herramienta <etiqueta> <binario> <minima> <obligatoria:si|no> <comando de version>
verificar_herramienta() {
    etiqueta="$1"
    binario="$2"
    minima="$3"
    obligatoria="$4"
    shift 4

    if [ -z "$binario" ] || ! command -v "$binario" >/dev/null 2>&1; then
        if [ "$obligatoria" = "si" ]; then
            falla "$etiqueta no esta instalado o no esta en el PATH (se requiere $minima o superior)"
        else
            aviso "$etiqueta no esta instalado o no esta en el PATH (recomendado $minima o superior)"
        fi
        return 1
    fi

    salida=$(salida_limpia "$@")
    encontrada=$(printf '%s\n' "$salida" | extraer_version)

    if [ -z "$encontrada" ]; then
        aviso "$etiqueta esta instalado pero no se pudo determinar su version"
        return 0
    fi

    if version_suficiente "$encontrada" "$minima"; then
        ok "$etiqueta $encontrada (minimo $minima)"
        return 0
    fi

    if [ "$obligatoria" = "si" ]; then
        falla "$etiqueta $encontrada es anterior al minimo exigido $minima"
    else
        aviso "$etiqueta $encontrada es anterior al minimo recomendado $minima"
    fi
    return 0
}

# Busca el ejecutable de Visual Studio Code y deja su ruta en vscode_ruta.
# En Windows la instalacion por usuario no siempre agrega el directorio al PATH, asi que
# se revisan tambien las ubicaciones habituales del instalador.
ubicar_vscode() {
    if command -v code >/dev/null 2>&1; then
        vscode_ruta="code"
        return 0
    fi

    [ "$entorno_familia" != "windows" ] && return 1

    base_local=""
    [ -n "${LOCALAPPDATA:-}" ] && base_local=$(ruta_a_unix "$LOCALAPPDATA")

    base_programas=""
    [ -n "${PROGRAMFILES:-}" ] && base_programas=$(ruta_a_unix "$PROGRAMFILES")

    for candidato in \
        "${base_local}/Programs/Microsoft VS Code/bin/code" \
        "${base_local}/Programs/Microsoft VS Code/bin/code.cmd" \
        "${base_programas}/Microsoft VS Code/bin/code" \
        "${base_programas}/Microsoft VS Code/bin/code.cmd" \
        "/c/Program Files/Microsoft VS Code/bin/code" \
        "/c/Program Files/Microsoft VS Code/bin/code.cmd" \
        "/c/Program Files (x86)/Microsoft VS Code/bin/code" \
        "/c/Program Files (x86)/Microsoft VS Code/bin/code.cmd"
    do
        case "$candidato" in
            /Programs/*|/Microsoft*) continue ;;
        esac

        if [ -x "$candidato" ] || [ -f "$candidato" ]; then
            vscode_ruta="$candidato"
            return 0
        fi
    done

    return 1
}

# Comprueba las extensiones de Copilot.
# Si Visual Studio Code esta presente, su ausencia reprueba el ambiente: un puesto con el
# editor instalado y sin la extension no sirve para el taller. Si el editor no esta, la
# comprobacion solo advierte, porque el participante puede estar usando IntelliJ IDEA o
# Visual Studio y en ese caso su extension de Copilot vive en otra parte.
verificar_extensiones() {
    if [ -z "$vscode_ruta" ]; then
        for extension in $EXTENSIONES_COPILOT; do
            aviso "Extension $extension no verificable: Visual Studio Code no esta instalado, confirmar Copilot en el IDE que se use"
        done
        return 0
    fi

    instaladas=$(salida_limpia "$vscode_ruta" --list-extensions | tr '[:upper:]' '[:lower:]')

    for extension in $EXTENSIONES_COPILOT; do
        if printf '%s\n' "$instaladas" | grep -qx "$extension"; then
            ok "Extension $extension instalada"
        else
            falla "Extension $extension no esta instalada en Visual Studio Code"
        fi
    done
}

# Comprueba que un dominio sea alcanzable por HTTPS.
# Cualquier respuesta del servidor cuenta como exito: lo que se valida es que la red deje
# pasar la conexion, no que el endpoint devuelva 200.
#
# Se usa curl y solo curl. Viene incluido en Git para Windows, en macOS y en practicamente
# toda distribucion de Linux. No se cae de vuelta a una consulta de DNS porque un nombre
# que resuelve no prueba que el puerto 443 este abierto, y ese falso positivo es
# exactamente lo que este script existe para evitar.
dominio_alcanzable() {
    destino="$1"

    curl --silent --show-error --output /dev/null \
         --max-time "$TIMEOUT_RED" "https://${destino}" >/dev/null 2>&1
}

verificar_dominios() {
    lista="$1"
    obligatorios="$2"

    for destino in $lista; do
        if dominio_alcanzable "$destino"; then
            ok "$destino alcanzable"
        elif [ "$obligatorios" = "si" ]; then
            falla "$destino no es alcanzable, revisar proxy, firewall o lista blanca"
        else
            aviso "$destino no es alcanzable, funcionalidad degradada pero el taller es viable"
        fi
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

detectar_entorno

printf '%sVerificacion de ambiente, taller de GitHub Copilot%s\n' "$C_TITULO" "$C_FIN"
printf 'Script version %s\n' "$VERSION_SCRIPT"
printf 'Entorno: %s\n' "$entorno_nombre"
printf 'Sistema: %s\n' "$entorno_detalle"
printf 'Shell: %s\n' "${BASH_VERSION:-desconocida}"
printf 'Fecha: %s\n' "$(date '+%Y-%m-%d %H:%M:%S')"

titulo "Herramientas obligatorias"
verificar_herramienta "Git" "git" "$MIN_GIT" "si" git --version
verificar_herramienta "JDK" "java" "$MIN_JDK" "si" java -version
verificar_herramienta "SDK de .NET" "dotnet" "$MIN_DOTNET" "si" dotnet --version
verificar_herramienta "Node.js" "node" "$MIN_NODE" "si" node --version

ubicar_vscode || true
if [ -n "$vscode_ruta" ] && [ "$vscode_ruta" != "code" ]; then
    ok "Visual Studio Code encontrado fuera del PATH en $vscode_ruta"
fi
verificar_herramienta "Visual Studio Code" "$vscode_ruta" "$MIN_CODE" "si" "$vscode_ruta" --version

titulo "Extensiones de GitHub Copilot"
verificar_extensiones

titulo "Herramientas recomendadas"
verificar_herramienta "Apache Maven" "mvn" "$MIN_MAVEN" "no" mvn --version

if [ "$comprobar_red" -eq 1 ]; then
    if ! command -v curl >/dev/null 2>&1; then
        titulo "Conectividad"
        falla "curl no esta disponible, sin el no se puede comprobar la conectividad a GitHub Copilot"
    else
        titulo "Conectividad obligatoria de GitHub Copilot"
        verificar_dominios "$DOMINIOS_OBLIGATORIOS" "si"

        titulo "Conectividad recomendada"
        verificar_dominios "$DOMINIOS_RECOMENDADOS" "no"
    fi
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
