#!/usr/bin/env bash
#
# Genera y publica el repositorio de participantes a partir del repositorio de
# construccion.
#
# El contenido se arma desde la lista de inclusion scripts/publicacion/incluir.txt, nunca
# desde una lista de exclusion: un archivo nuevo queda fuera hasta que alguien lo agregue.
# Se toma el contenido del indice de git, asi que un archivo sin agregar con git add no se
# publica, y los binarios de compilacion y node_modules nunca entran.
#
# Antes de publicar, el gate de fugas revisa el contenido generado y se detiene si
# encuentra material del relator. El repositorio de participantes es una instantanea de un
# solo commit, sin el historial del repositorio de construccion.
#
# Uso habitual:
#   bash scripts/publicar-taller.sh                     genera en un directorio temporal y verifica
#   bash scripts/publicar-taller.sh --destino DIR       genera en DIR y verifica
#   bash scripts/publicar-taller.sh --verificar DIR     solo corre el gate sobre DIR
#   bash scripts/publicar-taller.sh --publicar URL      genera, verifica y publica en URL
#
# Codigo de salida: 0 si todo salio bien, 1 si el gate encontro fugas, 2 si algo impidio
# generar o publicar.
#
# Corre en macOS, Linux y Git Bash sobre Windows.

set -u

readonly VERSION_SCRIPT="1.0.0"

raiz="$(cd "$(dirname "$0")/.." && pwd)"
readonly LISTA_INCLUSION="$raiz/scripts/publicacion/incluir.txt"

# ---------------------------------------------------------------------------
# Patrones del gate de fugas
# ---------------------------------------------------------------------------
# Cada patron es una expresion regular extendida, sin distinguir mayusculas. Una linea del
# contenido generado que coincida con cualquiera de ellos es una fuga.
readonly PATRONES_FUGA=(
    'DEF-[0-9]'
    'HALLAZGO-[0-9]'
    'SPEC-[0-9]'
    'docs/relator'
    'guia-del-relator'
    '03-hallazgos'
    '04-defectos-plantados'
    '05-diseno-de-laboratorios'
    '06-calibracion'
    '07-protocolo'
    'casos-de-clase'
    'traspaso-spec'
    'notas del relator'
    '(^|[^[:alpha:]])plantad[oa]s?'
    'soluci[oó]n(es)? de referencia'
)

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

titulo() { printf '\n%s== %s ==%s\n' "$C_TITULO" "$1" "$C_FIN"; }
ok()     { printf '  %s[ OK ]%s %s\n' "$C_OK" "$C_FIN" "$1"; }
falla()  { printf '  %s[FALLA]%s %s\n' "$C_FALLA" "$C_FIN" "$1"; }
aviso()  { printf '  %s[AVISO]%s %s\n' "$C_AVISO" "$C_FIN" "$1"; }

uso() {
    cat <<EOF
Uso: bash scripts/publicar-taller.sh [opciones]

Genera el repositorio de participantes desde la lista de inclusion y verifica que no
contenga material del relator.

Opciones:
  --destino DIR     Genera el contenido en DIR, que no debe existir o debe estar vacio.
                    Por omision, un directorio temporal nuevo.
  --verificar DIR   No genera nada. Solo corre el gate de fugas sobre DIR.
  --publicar URL    Genera, verifica y publica en el repositorio remoto URL como un
                    commit unico en la rama main.
  --reemplazar      Con --publicar, autoriza reemplazar el contenido que ya tenga el
                    remoto. Sin esta opcion, un remoto con commits detiene la publicacion.
  --ayuda           Muestra esta ayuda y termina.
  --version         Muestra la version del script y termina.

Codigo de salida:
  0   Contenido generado sin fugas y, si se pidio, publicado.
  1   El gate encontro fugas. No se publico nada.
  2   Algo impidio generar o publicar.
EOF
}

# ---------------------------------------------------------------------------
# Gate de fugas
# ---------------------------------------------------------------------------

# Revisa todos los archivos de texto bajo el directorio y lista cada coincidencia con su
# archivo y su linea. Retorna 0 si no hay fugas y 1 si hay al menos una.
verificar_fugas() {
    local dir="$1"
    local patron_unico
    local IFS='|'
    patron_unico="${PATRONES_FUGA[*]}"
    unset IFS

    titulo "Gate de fugas"
    local hallazgos
    hallazgos="$(cd "$dir" && grep -rnIiE --exclude-dir=.git "$patron_unico" . 2>/dev/null)"

    if [ -z "$hallazgos" ]; then
        ok "Sin material del relator en el contenido generado"
        return 0
    fi

    local cantidad
    cantidad="$(printf '%s\n' "$hallazgos" | wc -l | tr -d ' ')"
    falla "$cantidad lineas con material del relator:"
    printf '%s\n' "$hallazgos" | sed 's#^\./#      #'
    return 1
}

# ---------------------------------------------------------------------------
# Generacion
# ---------------------------------------------------------------------------

generar() {
    local destino="$1"

    titulo "Generacion desde la lista de inclusion"

    if [ ! -f "$LISTA_INCLUSION" ]; then
        falla "No existe la lista de inclusion $LISTA_INCLUSION"
        return 2
    fi

    local linea origen dest archivos cantidad total=0 errores=0
    while IFS= read -r linea || [ -n "$linea" ]; do
        linea="${linea%$'\r'}"
        case "$linea" in ''|'#'*) continue ;; esac

        if [[ "$linea" == *" => "* ]]; then
            origen="${linea%% => *}"
            dest="${linea##* => }"
        else
            origen="$linea"
            dest=""
        fi

        archivos="$(cd "$raiz" && git ls-files -- "$origen")"
        if [ -z "$archivos" ]; then
            falla "La entrada '$origen' no corresponde a ningun archivo versionado"
            errores=$((errores + 1))
            continue
        fi

        # checkout-index copia el contenido del indice con los finales de linea y los
        # permisos que registra git, sin depender de lo que haya en el disco.
        if ! (cd "$raiz" && printf '%s\n' "$archivos" | git checkout-index --stdin --prefix="$destino/"); then
            falla "No se pudo copiar '$origen'"
            errores=$((errores + 1))
            continue
        fi

        if [ -n "$dest" ]; then
            mkdir -p "$(dirname "$destino/$dest")"
            mv "$destino/$origen" "$destino/$dest"
            # Si el origen quedo como unico archivo de su directorio, el directorio vacio se
            # elimina para que no aparezca en el repositorio de participantes.
            rmdir -p "$(dirname "$destino/$origen")" 2>/dev/null || true
        fi

        cantidad="$(printf '%s\n' "$archivos" | wc -l | tr -d ' ')"
        total=$((total + cantidad))
    done < "$LISTA_INCLUSION"

    if [ "$errores" -gt 0 ]; then
        falla "$errores entradas de la lista de inclusion con error"
        return 2
    fi

    ok "$total archivos generados en $destino"
    return 0
}

# ---------------------------------------------------------------------------
# Publicacion
# ---------------------------------------------------------------------------

publicar() {
    local destino="$1" url="$2" reemplazar="$3"

    titulo "Publicacion en $url"

    local remoto
    if ! remoto="$(git ls-remote --heads "$url" 2>&1)"; then
        falla "No se pudo consultar el remoto: $remoto"
        return 2
    fi

    if [ -n "$remoto" ] && [ "$reemplazar" -eq 0 ]; then
        falla "El remoto ya tiene commits. Publicar reemplaza su contenido y su historial."
        printf '      %s\n' \
            "Los clones que ya existan conservan la version anterior y tendran que volver" \
            "a clonar. Si eso es lo que se quiere, repetir con --reemplazar."
        return 2
    fi

    local autor correo fecha
    autor="$(cd "$raiz" && git config user.name)"
    correo="$(cd "$raiz" && git config user.email)"
    fecha="$(date +%Y-%m-%d)"

    (
        cd "$destino" &&
        git init -q -b main &&
        git add -A &&
        git -c user.name="$autor" -c user.email="$correo" \
            commit -q -m "Taller GitHub Copilot, material de participantes ($fecha)" &&
        if [ -n "$remoto" ]; then
            aviso "Reemplazando el contenido del remoto, autorizado con --reemplazar"
            git push -q --force "$url" main
        else
            git push -q "$url" main
        fi
    ) || { falla "La publicacion no se completo"; return 2; }

    ok "Publicado como un commit unico en la rama main"
    return 0
}

# ---------------------------------------------------------------------------
# Principal
# ---------------------------------------------------------------------------

destino=""
solo_verificar=""
url=""
reemplazar=0

while [ $# -gt 0 ]; do
    case "$1" in
        --destino)    destino="${2:-}"; shift 2 ;;
        --verificar)  solo_verificar="${2:-}"; shift 2 ;;
        --publicar)   url="${2:-}"; shift 2 ;;
        --reemplazar) reemplazar=1; shift ;;
        --ayuda|-h)   uso; exit 0 ;;
        --version)    echo "publicar-taller.sh $VERSION_SCRIPT"; exit 0 ;;
        *)            echo "Opcion desconocida: $1" >&2; uso >&2; exit 2 ;;
    esac
done

if [ -n "$solo_verificar" ]; then
    if [ ! -d "$solo_verificar" ]; then
        falla "No existe el directorio $solo_verificar"
        exit 2
    fi
    verificar_fugas "$solo_verificar" || exit 1
    exit 0
fi

if [ -z "$destino" ]; then
    destino="$(mktemp -d "${TMPDIR:-/tmp}/taller-XXXXXX")" || { falla "No se pudo crear el directorio temporal"; exit 2; }
elif [ -e "$destino" ] && [ -n "$(ls -A "$destino" 2>/dev/null)" ]; then
    falla "El destino $destino existe y no esta vacio"
    exit 2
fi
mkdir -p "$destino"
destino="$(cd "$destino" && pwd)"

generar "$destino" || exit 2
verificar_fugas "$destino" || { falla "No se publica. Corregir las fugas y volver a generar."; exit 1; }

if [ -n "$url" ]; then
    publicar "$destino" "$url" "$reemplazar" || exit 2
fi

titulo "Resumen"
echo "  Contenido en $destino"
exit 0
