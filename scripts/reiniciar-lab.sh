#!/usr/bin/env bash
#
# Deja el repositorio en el punto de partida de un laboratorio.
#
# Los laboratorios de los capitulos 1 a 4 empiezan con el escenario tal como se publico, sin
# depender de lo que se haya hecho en los anteriores. El capitulo 5 es una sola historia: el
# 5.1 deja el proyecto entero en el punto de partida, el 5.2 solo el escenario, el 5.3 solo
# el pipeline y su descripcion de pull request, y el 5.4 no tiene punto de partida propio.
# Este script restaura las rutas que el laboratorio usa y borra lo que el participante haya
# creado en ellas. Antes de tocar nada muestra que se va a perder y pide confirmacion.
#
# El estado de referencia es la etiqueta punto-de-partida, que crea la publicacion del
# repositorio de participantes. Si no existe, se usa el ultimo commit (HEAD).
#
# No usa red. Corre en macOS, Linux y Git Bash sobre Windows.
#
# Codigo de salida: 0 si el repositorio quedo en el punto de partida o ya lo estaba,
# 1 si el participante no confirmo, 2 si algo impidio reiniciar.

set -u

readonly VERSION_SCRIPT="1.1.0"
readonly ETIQUETA_PARTIDA="punto-de-partida"

if [ -t 1 ] && [ "${NO_COLOR:-}" = "" ]; then
    C_OK=$'\033[0;32m'
    C_FALLA=$'\033[0;31m'
    C_AVISO=$'\033[0;33m'
    C_TITULO=$'\033[1;36m'
    C_FIN=$'\033[0m'
else
    C_OK=""; C_FALLA=""; C_AVISO=""; C_TITULO=""; C_FIN=""
fi

titulo() { printf '\n%s== %s ==%s\n' "$C_TITULO" "$1" "$C_FIN"; }
ok()     { printf '  %s[ OK ]%s %s\n' "$C_OK" "$C_FIN" "$1"; }
falla()  { printf '  %s[FALLA]%s %s\n' "$C_FALLA" "$C_FIN" "$1"; }
aviso()  { printf '  %s[AVISO]%s %s\n' "$C_AVISO" "$C_FIN" "$1"; }

uso() {
    cat <<EOF
Uso: bash scripts/reiniciar-lab.sh <laboratorio> [--si]

Deja el repositorio en el punto de partida del laboratorio indicado.

Laboratorios: lab-1-4 lab-1-5 lab-2-4 lab-3-4 lab-4-4 lab-5-1 lab-5-2 lab-5-3 lab-5-4
Tambien se aceptan las formas 5.2 y 5-2.

Opciones:
  --si        Confirma de antemano. Sin esta opcion, el script pregunta antes de
              descartar cambios. No vale para lab-5-4.
  --confirmo-descartar-5-2-y-5-3
              Solo para lab-5-4. Confirma de antemano que se descarta el trabajo
              de todo el capitulo 5.
  --ayuda     Muestra esta ayuda y termina.
  --version   Muestra la version del script y termina.

Codigo de salida:
  0   El repositorio quedo en el punto de partida, o ya lo estaba.
  1   No se confirmo el descarte. No se modifico nada.
  2   Laboratorio desconocido o error de git.
EOF
}

# Rutas que cada laboratorio restaura. El escenario siempre, porque todos los laboratorios
# empiezan sobre el escenario publicado. Ademas, el directorio de entregables del propio
# laboratorio y, en 2.4 y 3.4, los artefactos que el laboratorio pide crear. Los activos
# del 2.4 no se tocan al reiniciar otro laboratorio: son del participante.
rutas_del_laboratorio() {
    case "$1" in
        lab-1-4) echo "escenario labs/cap1/lab-1-4-practica-guiada/entregables" ;;
        lab-1-5) echo "escenario labs/cap1/lab-1-5-analisis-componente/entregables" ;;
        lab-2-4) echo "escenario labs/cap2/lab-2-4-agente-o-instruccion/entregables .github/agents .github/instructions" ;;
        lab-3-4) echo "escenario labs/cap3/lab-3-4-mcp-local/entregables .vscode/mcp.json mcp" ;;
        lab-4-4) echo "escenario labs/cap4/lab-4-4-documentacion/entregables" ;;
        lab-5-1) echo "escenario docs/proyecto docs/arquitectura/decisiones scripts/integracion scripts/integracion-local.sh .github/workflows CHANGELOG.md" ;;
        lab-5-2) echo "escenario" ;;
        lab-5-3) echo "scripts/integracion scripts/integracion-local.sh .github/workflows docs/proyecto/pull-request.md" ;;
        lab-5-4) echo "escenario docs/proyecto docs/arquitectura/decisiones scripts/integracion scripts/integracion-local.sh .github/workflows CHANGELOG.md" ;;
        *) return 1 ;;
    esac
}

normalizar_laboratorio() {
    local id="$1"
    id="${id#lab-}"
    id="${id/./-}"
    echo "lab-$id"
}

# ---------------------------------------------------------------------------
# Argumentos
# ---------------------------------------------------------------------------

laboratorio=""
confirmado=0
confirmado_5_4=0

while [ $# -gt 0 ]; do
    case "$1" in
        --si)        confirmado=1 ;;
        --confirmo-descartar-5-2-y-5-3) confirmado_5_4=1 ;;
        --ayuda|-h)  uso; exit 0 ;;
        --version)   echo "reiniciar-lab.sh $VERSION_SCRIPT"; exit 0 ;;
        -*)          echo "Opcion desconocida: $1" >&2; uso >&2; exit 2 ;;
        *)           laboratorio="$(normalizar_laboratorio "$1")" ;;
    esac
    shift
done

if [ -z "$laboratorio" ]; then
    uso >&2
    exit 2
fi

if ! rutas="$(rutas_del_laboratorio "$laboratorio")"; then
    falla "Laboratorio desconocido: $laboratorio"
    uso >&2
    exit 2
fi

raiz="$(cd "$(dirname "$0")/.." && pwd)"
cd "$raiz" || exit 2

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    falla "$raiz no es un repositorio de git"
    exit 2
fi

if git rev-parse -q --verify "refs/tags/$ETIQUETA_PARTIDA" >/dev/null; then
    referencia="$ETIQUETA_PARTIDA"
else
    referencia="HEAD"
fi

# El laboratorio 5.4 no tiene punto de partida propio. Se trabaja sobre lo que dejaron el
# 5.1 al 5.3, asi que reiniciarlo descarta todo el capitulo. Se advierte siempre y se pide una
# confirmacion distinta de la habitual, que --si no reemplaza.
if [ "$laboratorio" = "lab-5-4" ]; then
    titulo "Advertencia"
    aviso "El laboratorio 5.4 no tiene punto de partida propio. Se trabaja sobre lo que dejaron los laboratorios 5.1 a 5.3."
    aviso "Reiniciarlo devuelve el proyecto a su version original y descarta la historia, el reporte, las pruebas y la correccion de todo el capitulo 5."
fi
if [ "$laboratorio" = "lab-5-3" ]; then
    titulo "Advertencia"
    aviso "Reiniciar el 5.3 deshace solo el pipeline, los hashes esperados y la descripcion del pull request."
    aviso "No deshace el reporte, las pruebas ni la correccion en el escenario. Para eso, reinicia el 5.2."
fi

titulo "Punto de partida de $laboratorio"
printf '  Referencia: %s\n' "$referencia"
printf '  Rutas: %s\n' "$rutas"

# ---------------------------------------------------------------------------
# Que se pierde
# ---------------------------------------------------------------------------
# Archivos versionados que difieren de la referencia, incluidos los cambios confirmados
# despues de ella, y archivos nuevos sin versionar. Los ignorados, como los binarios de
# compilacion, no se tocan.

# shellcheck disable=SC2086
modificados="$(git diff --name-status "$referencia" -- $rutas 2>/dev/null)"
# shellcheck disable=SC2086
nuevos="$(git ls-files --others --exclude-standard -- $rutas 2>/dev/null)"

if [ -z "$modificados" ] && [ -z "$nuevos" ]; then
    ok "Ya esta en el punto de partida. No hay nada que descartar."
    exit 0
fi

titulo "Esto se va a perder"
if [ -n "$modificados" ]; then
    printf '  Cambios en archivos del repositorio, que vuelven a su version original:\n'
    printf '%s\n' "$modificados" | while IFS=$'\t' read -r estado archivo resto; do
        case "$estado" in
            M*) printf '    modificado   %s\n' "$archivo" ;;
            A*) printf '    agregado     %s\n' "$archivo" ;;
            D*) printf '    borrado      %s\n' "$archivo" ;;
            *)  printf '    %-12s %s %s\n' "$estado" "$archivo" "$resto" ;;
        esac
    done
fi
if [ -n "$nuevos" ]; then
    printf '  Archivos nuevos, que se borran:\n'
    printf '%s\n' "$nuevos" | sed 's/^/    /'
fi

if [ "$referencia" != "HEAD" ] && [ -n "$(git rev-list "$referencia..HEAD" 2>/dev/null)" ]; then
    aviso "Hay commits posteriores al punto de partida. Siguen en el historial, pero estas rutas vuelven a la version original."
fi

if [ "$laboratorio" = "lab-5-4" ] && [ "$confirmado_5_4" -eq 0 ]; then
    if [ ! -t 0 ]; then
        falla "Hace falta confirmar y no hay una terminal interactiva. Repetir con --confirmo-descartar-5-2-y-5-3."
        exit 1
    fi
    printf '\n  Escribe descartar para perder el trabajo de todo el capitulo 5, cualquier otra cosa para cancelar: '
    read -r respuesta
    respuesta="$(printf '%s' "$respuesta" | tr -d '\r ' | tr '[:upper:]' '[:lower:]')"
    if [ "$respuesta" != "descartar" ]; then
        aviso "Cancelado. No se modifico nada."
        exit 1
    fi
elif [ "$laboratorio" != "lab-5-4" ] && [ "$confirmado" -eq 0 ]; then
    if [ ! -t 0 ]; then
        falla "Hace falta confirmar y no hay una terminal interactiva. Repetir con --si para descartar."
        exit 1
    fi
    printf '\n  Escribe si para descartar estos cambios, cualquier otra cosa para cancelar: '
    read -r respuesta
    # En Git Bash la respuesta puede traer un retorno de carro. Se aceptan si, SI y sí.
    respuesta="$(printf '%s' "$respuesta" | tr -d '\r ' | tr '[:upper:]' '[:lower:]')"
    if [ "$respuesta" != "si" ] && [ "$respuesta" != "sí" ]; then
        aviso "Cancelado. No se modifico nada."
        exit 1
    fi
fi

# ---------------------------------------------------------------------------
# Restauracion
# ---------------------------------------------------------------------------

titulo "Restauracion"
errores=0
for ruta in $rutas; do
    if [ -n "$(git ls-tree -r --name-only "$referencia" -- "$ruta" 2>/dev/null)" ]; then
        if ! git restore --source="$referencia" --staged --worktree -- "$ruta" 2>/dev/null; then
            falla "No se pudo restaurar $ruta"
            errores=$((errores + 1))
            continue
        fi
    else
        # La ruta no existe en la referencia. Lo que haya ahi es del participante: se saca
        # del indice si lo agrego y se borra del disco.
        git rm -r -q --cached --ignore-unmatch -- "$ruta" >/dev/null 2>&1
    fi
    git clean -f -d -q -- "$ruta" >/dev/null 2>&1
done

# shellcheck disable=SC2086
if [ "$errores" -gt 0 ] \
    || [ -n "$(git diff --name-only "$referencia" -- $rutas 2>/dev/null)" ] \
    || [ -n "$(git ls-files --others --exclude-standard -- $rutas 2>/dev/null)" ]; then
    falla "El repositorio no quedo en el punto de partida. Revisar con: git status"
    exit 2
fi

ok "$laboratorio listo para empezar"
exit 0
