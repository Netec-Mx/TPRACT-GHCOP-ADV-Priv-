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

readonly VERSION_SCRIPT="2.3.0"

# Piso exigido por herramienta. Es el minimo con el que el taller es viable, no lo que se
# solicita para la imagen de la maquina virtual. La distincion entre ambos esta explicada
# en docs/00-setup-ambiente.md.
readonly MIN_GIT="2.40"
readonly MIN_JDK="21"
readonly MIN_DOTNET="8.0"
readonly MIN_NODE="22"
readonly MIN_MAVEN="3.9"

# Visual Studio Code 1.116 (abril de 2026) es la primera version que trae GitHub Copilot
# Chat como extension integrada. La comprobacion de funciones de IA de este script solo
# tiene sentido desde esa version: en una anterior, Copilot no viene con el editor y el
# script aprobaria un puesto sin Copilot.
readonly MIN_CODE="1.116"

# Dominios obligatorios para que GitHub Copilot funcione.
readonly DOMINIOS_OBLIGATORIOS="github.com api.github.com api.githubcopilot.com proxy.individual.githubcopilot.com copilot-proxy.githubusercontent.com default.exp-tas.com"

# Dominios recomendados. Su ausencia advierte pero no reprueba el ambiente.
readonly DOMINIOS_RECOMENDADOS="copilot-telemetry.githubusercontent.com marketplace.visualstudio.com"

# Copilot en Visual Studio Code. Desde la version 1.116 es una extension integrada al
# editor, no un paquete instalable, y puede estar deshabilitada por dos vias que el editor
# mantiene sincronizadas: el ajuste chat.disableAIFeatures y la lista de extensiones
# deshabilitadas del perfil. Los sintomas y la solucion estan en docs/02-troubleshooting.md.
readonly EXTENSION_COPILOT_INTEGRADA="github.copilot-chat"
readonly AJUSTE_FUNCIONES_IA="chat.disableAIFeatures"

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

# Directorio de datos de usuario de Visual Studio Code. Vacio significa la ubicacion por
# omision del sistema; --perfil-vscode lo reemplaza.
perfil_vscode=""

# Raiz del repositorio, para leer la configuracion de espacio de trabajo en .vscode/.
dir_repositorio=$(cd "$(dirname "$0")/.." 2>/dev/null && pwd)

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
  --sin-red              Omite las comprobaciones de conectividad.
  --perfil-vscode <dir>  Directorio de datos de usuario de Visual Studio Code, si no es
                         el de la instalacion por omision (modo portable o
                         --user-data-dir).
  --ayuda                Muestra esta ayuda y termina.
  --version              Muestra la version del script y termina.

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

# Directorio de datos de usuario de Visual Studio Code: el indicado con --perfil-vscode o
# la ubicacion por omision del sistema. En Windows se entrega en formato nativo, porque
# quien lo lee es Node, que es un ejecutable de Windows.
directorio_datos_vscode() {
    if [ -n "$perfil_vscode" ]; then
        printf '%s' "$perfil_vscode"
        return 0
    fi

    case "$entorno_familia" in
        windows)
            [ -n "${APPDATA:-}" ] && printf '%s\\Code' "$APPDATA"
            ;;
        *)
            if [ "$entorno_nombre" = "macOS" ]; then
                printf '%s/Library/Application Support/Code' "$HOME"
            else
                printf '%s/Code' "${XDG_CONFIG_HOME:-$HOME/.config}"
            fi
            ;;
    esac
}

# Programa en Node que lee el estado de las funciones de IA desde el perfil del editor.
#
# Visual Studio Code no ofrece una opcion de linea de comandos para consultarlo. El estado
# vive en dos lugares, y el editor los mantiene sincronizados:
#
#   - El ajuste chat.disableAIFeatures, en settings.json del usuario o del espacio de
#     trabajo. Es JSON con comentarios y comas finales, no JSON estricto.
#   - La lista de extensiones deshabilitadas del perfil, clave
#     extensionsIdentifiers/disabled de User/globalStorage/state.vscdb, que es SQLite.
#     El editor deshabilita ahi la extension integrada en el primer arranque de un perfil
#     cuando Copilot todavia no fue configurado.
#
# Se lee con node:sqlite, incluido en Node desde la version 22.5, para no depender de un
# cliente de SQLite que Git para Windows no trae.
#
# Imprime una linea clave=valor por dato. Nunca decide si el ambiente esta apto: eso lo
# decide el script, que es donde estan los mensajes.
programa_estado_funciones_ia() {
    cat <<'PROGRAMA'
'use strict';
const fs = require('fs');
const path = require('path');

const [dirDatos, ajustesEspacio, idExtension, claveAjuste] = process.argv.slice(2);
const informar = (clave, valor) => process.stdout.write(`${clave}=${valor}\n`);

// Quita los comentarios de un texto JSON. Recorre caracter a caracter porque las dos
// confusiones posibles van en sentidos opuestos: una URL dentro de una cadena parece un
// comentario, y un ajuste comentado, como // "editor.fontSize": 14, trae comillas que
// parecen una cadena.
function quitarComentarios(texto) {
    let resultado = '';
    for (let i = 0; i < texto.length; i++) {
        const actual = texto[i];
        const siguiente = texto[i + 1];
        if (actual === '"') {
            let fin = i + 1;
            while (fin < texto.length && texto[fin] !== '"') fin += texto[fin] === '\\' ? 2 : 1;
            resultado += texto.slice(i, fin + 1);
            i = fin;
        } else if (actual === '/' && siguiente === '/') {
            while (i + 1 < texto.length && texto[i + 1] !== '\n') i++;
        } else if (actual === '/' && siguiente === '*') {
            const cierre = texto.indexOf('*/', i + 2);
            i = cierre === -1 ? texto.length : cierre + 1;
        } else {
            resultado += actual;
        }
    }
    return resultado;
}

// Quita las comas finales antes de } o ]. Sin comentarios de por medio las comillas ya
// estan balanceadas, asi que alcanza con separar el texto por cadenas y tocar solo lo que
// queda fuera de ellas.
function quitarComasFinales(texto) {
    return texto
        .split(/("(?:[^"\\]|\\.)*")/)
        .map((fragmento, indice) => (indice % 2 === 1 ? fragmento : fragmento.replace(/,(\s*[}\]])/g, '$1')))
        .join('');
}

// settings.json admite comentarios y comas finales; JSON.parse no.
function aJsonEstricto(texto) {
    return quitarComasFinales(quitarComentarios(texto));
}

// Devuelve true, false, ausente o ilegible.
function leerAjuste(archivo) {
    if (!archivo || !fs.existsSync(archivo)) return 'ausente';
    let objeto;
    try {
        const texto = fs.readFileSync(archivo, 'utf8').replace(/^﻿/, '');
        objeto = texto.trim() === '' ? {} : JSON.parse(aJsonEstricto(texto));
    } catch {
        return 'ilegible';
    }
    if (objeto === null || typeof objeto !== 'object' || Array.isArray(objeto)) return 'ilegible';
    if (!Object.prototype.hasOwnProperty.call(objeto, claveAjuste)) return 'ausente';
    const valor = objeto[claveAjuste];
    if (valor === true) return 'true';
    if (valor === false) return 'false';
    return 'ilegible';
}

// Marca que el editor escribe en todo perfil donde ya decidio el estado inicial de la
// extension integrada. Sirve de testigo del formato: la ausencia de la lista de
// deshabilitadas significa "ninguna deshabilitada" solo si el perfil tiene esta marca. Sin
// ella, una clave renombrada en una version futura del editor haria aprobar en silencio.
const MARCA_FORMATO = 'builtinChatExtensionEnablementMigration';

// Devuelve habilitada, deshabilitada, sin-estado, formato-desconocido,
// sqlite-no-disponible o ilegible.
function leerEstadoExtension(archivoEstado) {
    if (!fs.existsSync(archivoEstado)) return 'sin-estado';
    let sqlite;
    try {
        sqlite = require('node:sqlite');
    } catch {
        return 'sqlite-no-disponible';
    }
    let conexion;
    try {
        conexion = new sqlite.DatabaseSync(archivoEstado, { readOnly: true });
        const consulta = conexion.prepare('SELECT value FROM ItemTable WHERE key = ?');
        if (!consulta.get(MARCA_FORMATO)) return 'formato-desconocido';
        const fila = consulta.get('extensionsIdentifiers/disabled');
        if (!fila) return 'habilitada';
        const crudo = typeof fila.value === 'string' ? fila.value : Buffer.from(fila.value).toString('utf8');
        const deshabilitadas = JSON.parse(crudo);
        if (!Array.isArray(deshabilitadas)) return 'ilegible';
        const estaDeshabilitada = deshabilitadas.some(
            (entrada) => entrada && typeof entrada.id === 'string' && entrada.id.toLowerCase() === idExtension);
        return estaDeshabilitada ? 'deshabilitada' : 'habilitada';
    } catch (error) {
        informar('error', String(error && error.message ? error.message : error).replace(/\s+/g, ' '));
        return 'ilegible';
    } finally {
        try { if (conexion) conexion.close(); } catch { /* el resultado ya esta decidido */ }
    }
}

function contarPerfilesAdicionales(archivoAlmacen) {
    try {
        const almacen = JSON.parse(fs.readFileSync(archivoAlmacen, 'utf8'));
        return Array.isArray(almacen.userDataProfiles) ? almacen.userDataProfiles.length : 0;
    } catch {
        return 0;
    }
}

const dirUsuario = path.join(dirDatos, 'User');
if (!fs.existsSync(dirUsuario)) {
    informar('perfil', 'ausente');
} else {
    informar('perfil', 'presente');
    informar('ajuste_usuario', leerAjuste(path.join(dirUsuario, 'settings.json')));
    informar('extension', leerEstadoExtension(path.join(dirUsuario, 'globalStorage', 'state.vscdb')));
    informar('perfiles_adicionales', contarPerfilesAdicionales(path.join(dirUsuario, 'globalStorage', 'storage.json')));
}
informar('ajuste_espacio', leerAjuste(ajustesEspacio));
PROGRAMA
}

# Ejecuta el programa anterior. Si node:sqlite no carga, reintenta con la marca que lo
# habilitaba en Node 22.5 a 22.12, donde todavia era opcional.
leer_estado_funciones_ia() {
    estado=$(programa_estado_funciones_ia | node --no-warnings - "$@" 2>&1 | tr -d '\r')
    case "$estado" in
        *extension=sqlite-no-disponible*)
            estado=$(programa_estado_funciones_ia \
                | node --no-warnings --experimental-sqlite - "$@" 2>&1 | tr -d '\r')
            ;;
    esac
    printf '%s\n' "$estado"
}

# Valor de una clave en la salida de leer_estado_funciones_ia.
valor_estado() {
    printf '%s\n' "$1" | sed -n "s/^$2=//p" | head -n 1
}

# Acumula en la variable causas los motivos de una misma falla, separados por punto y coma.
agregar_causa() {
    if [ -z "$causas" ]; then causas="$1"; else causas="$causas; $1"; fi
}

# Indicaciones que se imprimen en el resumen cuando las funciones de IA estan deshabilitadas.
# Van al final porque es donde mira quien esta frente a la pantalla intentando resolverlo.
indicaciones_funciones_ia=""

registrar_indicaciones_funciones_ia() {
    indicaciones_funciones_ia="Como habilitar las funciones de IA en Visual Studio Code:
  1. Abrir la vista de Extensiones (Ctrl+Shift+X).
  2. Escribir @builtin copilot en el buscador.
  3. Seleccionar GitHub Copilot Chat.
  4. Pulsar \"Enable AI Features\" (\"Habilitar características de IA\" con la interfaz
     en espanol). Si el boton que aparece es \"Enable\" (\"Habilitar\"), pulsar ese.
  5. Iniciar sesion en GitHub desde el icono de Copilot de la barra de estado.
  6. Cerrar Visual Studio Code por completo y volver a ejecutar este script. El editor
     no guarda este estado en disco en el momento, pero si al cerrarse.
Alternativa para el paso 4: Configuracion (Ctrl+,), buscar chat.disableAIFeatures y
dejar la casilla desmarcada."
}

# Comprueba que las funciones de IA de Visual Studio Code esten habilitadas, que es lo que
# determina si Copilot va a funcionar. Desde la version 1.116 Copilot viene integrado en el
# editor, asi que ya no se busca como extension instalada: code --list-extensions ni
# siquiera lista las integradas.
#
# Si el editor no esta, solo advierte, porque el participante puede estar usando IntelliJ
# IDEA o Visual Studio y en ese caso Copilot se configura en otra parte.
verificar_funciones_ia() {
    if [ -z "$vscode_ruta" ]; then
        aviso "Funciones de IA no verificables: Visual Studio Code no esta instalado, confirmar Copilot en el IDE que se use"
        return 0
    fi

    if ! command -v node >/dev/null 2>&1; then
        falla "No se puede comprobar si las funciones de IA de Visual Studio Code estan habilitadas: hace falta Node.js para leer el perfil del editor"
        return 0
    fi

    if [ "$entorno_nombre" = "WSL sobre Windows" ] && [ -z "$perfil_vscode" ]; then
        falla "Desde WSL no se puede ubicar el perfil de Visual Studio Code: ejecutar desde Git Bash o indicar --perfil-vscode /mnt/c/Users/<usuario>/AppData/Roaming/Code"
        return 0
    fi

    datos=$(directorio_datos_vscode)
    if [ -z "$datos" ]; then
        falla "No se pudo ubicar el perfil de Visual Studio Code: la variable APPDATA no esta definida. Indicarlo con --perfil-vscode"
        return 0
    fi

    estado=$(leer_estado_funciones_ia "$datos" "$dir_repositorio/.vscode/settings.json" \
        "$EXTENSION_COPILOT_INTEGRADA" "$AJUSTE_FUNCIONES_IA")

    perfil=$(valor_estado "$estado" perfil)
    ajuste_usuario=$(valor_estado "$estado" ajuste_usuario)
    ajuste_espacio=$(valor_estado "$estado" ajuste_espacio)
    extension=$(valor_estado "$estado" extension)
    perfiles_adicionales=$(valor_estado "$estado" perfiles_adicionales)
    error_lectura=$(valor_estado "$estado" error)

    if [ -z "$perfil" ]; then
        falla "No se pudo leer el perfil de Visual Studio Code en $datos: $(printf '%s' "$estado" | head -n 1)"
        return 0
    fi

    if [ "$perfil" = "ausente" ]; then
        falla "No existe el perfil de Visual Studio Code en $datos. Abrir Visual Studio Code una vez, habilitar las funciones de IA y volver a ejecutar"
        registrar_indicaciones_funciones_ia
        return 0
    fi

    # Cada causa se reporta, pero cuentan como una sola falla: el requisito es uno. Se
    # distingue si hay algo deshabilitado o solo algo que no se pudo leer, porque las
    # instrucciones de habilitacion no sirven en el segundo caso.
    causas=""
    hay_deshabilitacion=0

    case "$ajuste_espacio" in
        true)
            agregar_causa "el archivo .vscode/settings.json del repositorio fija $AJUSTE_FUNCIONES_IA en true, hay que quitar esa linea"
            hay_deshabilitacion=1
            ;;
        ilegible)
            agregar_causa "no se pudo interpretar .vscode/settings.json del repositorio"
            ;;
    esac

    # El ajuste del espacio de trabajo, si existe, prevalece sobre el de usuario.
    if [ "$ajuste_espacio" != "false" ]; then
        case "$ajuste_usuario" in
            true)
                agregar_causa "$AJUSTE_FUNCIONES_IA esta en true en la configuracion de usuario"
                hay_deshabilitacion=1
                ;;
            ilegible)
                agregar_causa "no se pudo interpretar settings.json del usuario en $datos/User"
                ;;
        esac
    fi

    case "$extension" in
        habilitada)
            ;;
        deshabilitada)
            agregar_causa "GitHub Copilot Chat esta deshabilitada en el perfil del editor"
            hay_deshabilitacion=1
            ;;
        sin-estado)
            # Un perfil que nunca se cerro va a quedar deshabilitado: el editor apaga la
            # extension integrada en el primer arranque si Copilot no esta configurado.
            agregar_causa "el perfil todavia no registra el estado de las extensiones, Visual Studio Code nunca se cerro con este perfil"
            hay_deshabilitacion=1
            ;;
        formato-desconocido)
            agregar_causa "el perfil no tiene el formato que este script conoce. Abrir y cerrar Visual Studio Code en su version actual y volver a ejecutar; si persiste, el editor cambio su forma de guardar el estado y este script debe revisarse"
            ;;
        sqlite-no-disponible)
            agregar_causa "Node.js $(node --version 2>/dev/null | tr -d '\r') no puede cargar node:sqlite, que hace falta para leer el perfil del editor y existe desde Node.js 22.5"
            ;;
        *)
            agregar_causa "no se pudo leer el estado de las extensiones del perfil${error_lectura:+ ($error_lectura)}. Si Visual Studio Code esta abierto, cerrarlo y volver a ejecutar"
            ;;
    esac

    if [ "$hay_deshabilitacion" -eq 1 ]; then
        falla "Funciones de IA de Visual Studio Code deshabilitadas, Copilot no va a sugerir ni responder: $causas"
        registrar_indicaciones_funciones_ia
    elif [ -n "$causas" ]; then
        falla "No se pudo comprobar si las funciones de IA de Visual Studio Code estan habilitadas: $causas"
    else
        ok "Funciones de IA de Visual Studio Code habilitadas (GitHub Copilot Chat integrada y activa)"
    fi

    case "$perfiles_adicionales" in
        ''|0) ;;
        *) aviso "Visual Studio Code tiene $perfiles_adicionales perfil(es) adicional(es); se verifico solo el perfil por omision" ;;
    esac
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
# Hook de proteccion de datos
# ---------------------------------------------------------------------------

# Hook PreToolUse del repositorio. Se comprueba que exista, que bloquee una edicion de
# prueba y deje pasar otra, y que los hooks no esten deshabilitados en Visual Studio Code
# con chat.useHooks, que por omision esta activo.
readonly HOOK_CONFIG=".github/hooks/proteger-datos-escenario.json"
readonly HOOK_SCRIPT=".github/hooks/proteger-datos-escenario.js"
readonly AJUSTE_HOOKS="chat.useHooks"

verificar_hook_datos() {
    if [ ! -f "$dir_repositorio/$HOOK_CONFIG" ] || [ ! -f "$dir_repositorio/$HOOK_SCRIPT" ]; then
        falla "No se encontro el hook de proteccion de datos en $HOOK_CONFIG. El repositorio esta incompleto"
        return 1
    fi
    if ! command -v node >/dev/null 2>&1; then
        falla "Sin Node.js el hook de proteccion de datos no puede ejecutarse"
        return 1
    fi

    printf '%s' '{"tool_name":"editFiles","tool_input":{"files":["escenario/datos/planes.txt"]}}' \
        | (cd "$dir_repositorio" && node "$HOOK_SCRIPT" >/dev/null 2>&1)
    rc_bloqueo=$?
    printf '%s' '{"tool_name":"editFiles","tool_input":{"files":["escenario/java/pom.xml"]}}' \
        | (cd "$dir_repositorio" && node "$HOOK_SCRIPT" >/dev/null 2>&1)
    rc_paso=$?
    if [ "$rc_bloqueo" -ne 2 ] || [ "$rc_paso" -ne 0 ]; then
        falla "El hook de proteccion de datos no responde como se espera (bloqueo $rc_bloqueo, se esperaba 2; paso $rc_paso, se esperaba 0)"
        return 1
    fi
    ok "El hook de proteccion de datos bloquea una edicion de prueba y deja pasar otra"

    if [ -z "$vscode_ruta" ]; then
        aviso "No se pudo comprobar $AJUSTE_HOOKS: Visual Studio Code no esta instalado"
        return 0
    fi
    datos=$(directorio_datos_vscode)
    [ -n "$datos" ] || { aviso "No se pudo comprobar $AJUSTE_HOOKS: no se ubico el perfil de Visual Studio Code"; return 0; }
    estado=$(leer_estado_funciones_ia "$datos" "$dir_repositorio/.vscode/settings.json" \
        "$EXTENSION_COPILOT_INTEGRADA" "$AJUSTE_HOOKS")
    usuario=$(valor_estado "$estado" ajuste_usuario)
    espacio=$(valor_estado "$estado" ajuste_espacio)
    if [ "$espacio" = "false" ] || { [ "$usuario" = "false" ] && [ "$espacio" != "true" ]; }; then
        falla "Los hooks estan deshabilitados con $AJUSTE_HOOKS en false. Quitar ese ajuste de settings.json para que el hook de proteccion de datos funcione"
        return 1
    fi
    ok "Hooks habilitados en Visual Studio Code ($AJUSTE_HOOKS no esta deshabilitado)"
    return 0
}

# ---------------------------------------------------------------------------
# Servidor MCP local
# ---------------------------------------------------------------------------

# Dependencias del servidor MCP del laboratorio 3.4. Se instalan al construir la imagen
# de la maquina virtual, nunca en clase. Se comprueba que esten instaladas con la version
# exacta que fija package.json, y que el servidor arranque y liste sus tres herramientas
# con el mismo modelo de permisos con que lo lanza Visual Studio Code.
readonly DIR_SERVIDOR_MCP="mcp/servidor-local"
readonly HERRAMIENTAS_MCP="buscar_comercios detalle_comercio buscar_notas_soporte"
readonly PREPARACION_MCP="npm ci --prefix mcp/servidor-local"

verificar_servidor_mcp() {
    dir="$dir_repositorio/$DIR_SERVIDOR_MCP"

    if [ ! -f "$dir/package.json" ] || [ ! -f "$dir/package-lock.json" ]; then
        falla "No se encontro $DIR_SERVIDOR_MCP/package.json o su package-lock.json. El repositorio esta incompleto"
        return 1
    fi

    if ! command -v node >/dev/null 2>&1; then
        falla "Sin Node.js no se pueden comprobar las dependencias del servidor MCP"
        return 1
    fi

    # Cada linea es "paquete version-exigida version-instalada". La version instalada es
    # "ausente" si el paquete no esta en node_modules.
    comparacion=$(cd "$dir" && node --no-warnings -e '
        const fs = require("fs");
        const deps = JSON.parse(fs.readFileSync("package.json", "utf8")).dependencies || {};
        for (const [nombre, exigida] of Object.entries(deps)) {
            let instalada = "ausente";
            try {
                instalada = JSON.parse(fs.readFileSync("node_modules/" + nombre + "/package.json", "utf8")).version;
            } catch (e) {}
            console.log(nombre + " " + exigida + " " + instalada);
        }' 2>&1 | tr -d '\r')

    if [ -z "$comparacion" ]; then
        falla "No se pudieron leer las dependencias del servidor MCP"
        return 1
    fi

    faltantes=0
    while IFS=' ' read -r paquete exigida instalada; do
        [ -z "$paquete" ] && continue
        if [ "$instalada" = "ausente" ]; then
            falla "Dependencia del servidor MCP no instalada: $paquete $exigida. Se instala al preparar la imagen con: $PREPARACION_MCP"
            faltantes=$((faltantes + 1))
        elif [ "$instalada" != "$exigida" ]; then
            falla "Dependencia del servidor MCP con otra version: $paquete $instalada, se exige $exigida. Reinstalar con: $PREPARACION_MCP"
            faltantes=$((faltantes + 1))
        else
            ok "Dependencia del servidor MCP $paquete $instalada"
        fi
    done <<EOF_DEPS
$comparacion
EOF_DEPS

    [ "$faltantes" -gt 0 ] && return 1

    # Prueba de arranque. Se envia la secuencia minima del protocolo y se espera la lista
    # de herramientas. El proceso termina solo al cerrarse su entrada.
    solicitudes='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"verificar-ambiente","version":"1"}}}
{"jsonrpc":"2.0","method":"notifications/initialized"}
{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
    respuesta=$(cd "$dir_repositorio" && printf '%s\n' "$solicitudes" \
        | node --permission --allow-fs-read=. "$DIR_SERVIDOR_MCP/servidor.js" 2>&1 | tr -d '\r')

    ausentes=""
    for herramienta in $HERRAMIENTAS_MCP; do
        case "$respuesta" in
            *"\"name\":\"$herramienta\""*) ;;
            *) ausentes="$ausentes $herramienta" ;;
        esac
    done

    if [ -n "$ausentes" ]; then
        falla "El servidor MCP no arranco o no listo sus herramientas (faltan:$ausentes). Salida: $(printf '%s' "$respuesta" | head -c 300)"
        return 1
    fi

    ok "El servidor MCP arranca y lista sus tres herramientas"
    return 0
}

# ---------------------------------------------------------------------------
# Argumentos
# ---------------------------------------------------------------------------

while [ $# -gt 0 ]; do
    case "$1" in
        --sin-red)
            comprobar_red=0
            ;;
        --perfil-vscode)
            if [ $# -lt 2 ] || [ -z "$2" ]; then
                printf 'La opcion --perfil-vscode requiere un directorio\n\n' >&2
                uso >&2
                exit 2
            fi
            perfil_vscode="$2"
            shift
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

titulo "GitHub Copilot en Visual Studio Code"
verificar_funciones_ia

titulo "Hook de proteccion de datos"
verificar_hook_datos || true

titulo "Servidor MCP local"
verificar_servidor_mcp || true

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

if [ -n "$indicaciones_funciones_ia" ]; then
    printf '\n'
    printf '%s\n' "$indicaciones_funciones_ia" | while IFS= read -r linea; do
        printf '  %s\n' "$linea"
    done
fi

printf '\n  Revisa docs/00-setup-ambiente.md para los pasos de instalacion.\n'
exit 1
