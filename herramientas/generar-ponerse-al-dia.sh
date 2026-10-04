#!/usr/bin/env bash
#
# Genera scripts/proyecto/ponerse-al-dia.sh a partir de los estados de referencia del
# capitulo 5.
#
# Cada estado es el inicio de un laboratorio, 5.2, 5.3 o 5.4, para un stack, como parche
# contra el punto de partida. Los parches se guardan en claro del lado del relator, en
# docs/relator/entregas/estados/, y se cifran dentro del script publicado con OpenSSL,
# AES-256-CBC y derivacion de clave PBKDF2. La clave es la de la hoja de respuestas del
# capitulo 5.
#
# Uso: bash herramientas/generar-ponerse-al-dia.sh [--verificar]
#   --verificar  no escribe. Reconstruye los estados, los compara con los guardados y
#                descifra cada bloque del script publicado con la clave de la hoja.
#                Termina en 1 si algo no corresponde.

set -eu

raiz="$(cd "$(dirname "$0")/.." && pwd)"
entregas="$raiz/docs/relator/entregas/estados"
fuentes="$entregas/fuentes"
sol="$raiz/docs/relator/soluciones"
destino="$raiz/scripts/proyecto/ponerse-al-dia.sh"
readonly ITERACIONES=200000
readonly LABS="lab-5-2 lab-5-3 lab-5-4"
readonly STACKS="java dotnet"

clave="$(grep -o 'Clave de ponerse al día: `[^`]*`' "$raiz/docs/relator/capitulo-5-hoja-de-respuestas.md" | sed 's/.*`\(.*\)`/\1/')"
[ -n "$clave" ] || { echo "No encuentro la clave en la hoja de respuestas" >&2; exit 2; }

# Tiempos de referencia del registro de tiempos para las fases que el participante no hizo:
# fase, inicio, termino, minutos, estimado con IA de la estimacion de referencia y diferencia.
# Los minutos salen de la duracion de cada paso en los README de los laboratorios.
readonly REGISTRO_REFERENCIA="Requerimientos|09:00|09:15|15|15|0
Estimación|09:15|09:25|10|10|0
Análisis y diseño|09:25|09:35|10|10|0
Desarrollo|10:00|10:38|38|25|+13
Pruebas|11:00|11:08|8|10|-2
Integración continua|11:08|11:16|8|10|-2
Mantención|11:16|11:31|15|15|0
Revisión de código|11:31|11:35|4|8|-4
Seguridad|11:35|11:39|4|4|0"

# Estimado con IA de la estimacion de referencia para las fases que el participante va a
# hacer, para que el cierre del 5.4 pueda comparar aunque no haya hecho el 5.1.
readonly ESTIMADO_REFERENCIA="Desarrollo|25
Pruebas|10
Integración continua|10
Mantención|15
Revisión de código|8
Seguridad|4
Liberación|8
Operación y soporte|12"

# Completa en el registro de tiempos del directorio actual las primeras $1 fases con los
# tiempos de referencia, marcados como tales en Origen.
registro_referencia() {
    printf '%s\n' "$REGISTRO_REFERENCIA" | head -n "$1" > referencia.tmp
    printf '%s\n' "$ESTIMADO_REFERENCIA" > estimado.tmp
    awk -F'|' 'FILENAME == "estimado.tmp" { estimado[$1] = $2; next }
        FILENAME == "referencia.tmp" { ini[$1] = $2; fin[$1] = $3; min[$1] = $4; est[$1] = $5; dif[$1] = $6; next }
        /^\| / {
            fase = $2; gsub(/^ +| +$/, "", fase)
            lab = $3; gsub(/^ +| +$/, "", lab)
            if (fase in ini) {
                printf "| %s | %s | %s | %s | %s | %s | %s | referencia |\n", fase, lab, ini[fase], fin[fase], min[fase], est[fase], dif[fase]
                next
            }
            actual = $7; gsub(/^ +| +$/, "", actual)
            if ((fase in estimado) && actual == "") {
                printf "|%s|%s|%s|%s|%s| %s |%s|%s|\n", $2, $3, $4, $5, $6, estimado[fase], $8, $9
                next
            }
        }
        { print }' estimado.tmp referencia.tmp docs/proyecto/registro-de-tiempos.md > registro.tmp
    mv registro.tmp docs/proyecto/registro-de-tiempos.md && rm referencia.tmp estimado.tmp
}

trabajo="$(mktemp -d)"
trap 'rm -rf "$trabajo"' EXIT

# Arma los seis estados en $1.
construir_estados() {
    local salida="$1" stack base arbol
    base="$trabajo/base"
    rm -rf "$base"
    NO_COLOR=1 bash "$raiz/scripts/publicar-taller.sh" --destino "$base" > /dev/null 2>&1
    (cd "$base" && git init -q && git add -A && git -c user.name=g -c user.email=g@g commit -qm base)
    mkdir -p "$salida"
    for stack in $STACKS; do
        arbol="$trabajo/arbol-$stack"
        rm -rf "$arbol" && cp -R "$base" "$arbol"
        (
            cd "$arbol"
            # Inicio del 5.2: lo que deja un 5.1 terminado.
            cp "$fuentes/historia-reporte-medios-de-pago.md" "$fuentes/estimacion.md" docs/proyecto/
            cp docs/proyecto/plantillas/registro-de-tiempos.md docs/proyecto/registro-de-tiempos.md
            registro_referencia 3
            cp "$fuentes/0004-ubicacion-del-reporte.md" docs/arquitectura/decisiones/
            sed -i.bak "\$s/.*/$stack/" scripts/integracion/stack.txt && rm scripts/integracion/stack.txt.bak
            awk '/^\| \[0003\]/ { print; print "| [0004](0004-ubicacion-del-reporte.md) | El reporte por medio de pago vive en clases propias | Aceptada |"; next } { print }' \
                docs/arquitectura/decisiones/README.md > README.tmp && mv README.tmp docs/arquitectura/decisiones/README.md
            git add -A && git diff --cached --binary > "$salida/lab-5-2-$stack.patch"
            # Inicio del 5.3: el reporte del 5.2.
            git apply "$sol/funcionalidad-reporte/reporte-$stack.patch"
            registro_referencia 4
            git add -A && git diff --cached --binary > "$salida/lab-5-3-$stack.patch"
            # Inicio del 5.4: pipeline con conciliacion, correccion, hash y descripcion.
            git apply "$sol/lab-5-3/conciliacion-en-pipeline.patch"
            git apply "$sol/funcionalidad-reporte/correccion-$stack.patch" "$sol/lab-5-3/hash-junio.patch"
            cp "$fuentes/0005-limite-superior-inclusivo.md" docs/arquitectura/decisiones/
            cp "$fuentes/pull-request.md" docs/proyecto/pull-request.md
            registro_referencia 9
            awk '/^\| \[0004\]/ { print; print "| [0005](0005-limite-superior-inclusivo.md) | El límite superior de cada tramo es inclusivo | Aceptada |"; next } { print }' \
                docs/arquitectura/decisiones/README.md > README.tmp && mv README.tmp docs/arquitectura/decisiones/README.md
            git add -A && git diff --cached --binary > "$salida/lab-5-4-$stack.patch"
        )
    done
}

cifrar() {
    openssl enc -aes-256-cbc -pbkdf2 -iter "$ITERACIONES" -md sha256 -salt -a -pass "pass:$clave" < "$1"
}

generar_script() {
    cat <<'CABECERA'
#!/usr/bin/env bash
#
# Pone al dia el repositorio en el inicio de un laboratorio del capitulo 5, para un stack.
#
# Es para quien se atraso. Descarta el trabajo del capitulo 5 que haya en el repositorio y
# deja el estado de referencia del inicio del laboratorio indicado. Los estados van cifrados
# con OpenSSL, AES-256-CBC y PBKDF2. La clave la dice el relator en la sala.
#
# Uso: bash scripts/proyecto/ponerse-al-dia.sh <lab-5-2|lab-5-3|lab-5-4> <java|dotnet> [clave]
#        [--confirmo-descartar]
#
# Para empezar el 5.1 desde cero no hace falta clave: bash scripts/reiniciar-lab.sh lab-5-1
#
# Codigo de salida: 0 si dejo el repositorio en el estado pedido, 1 si la clave no es
# correcta o no se confirmo, 2 si algo impidio hacerlo.
#
# Generado por herramientas/generar-ponerse-al-dia.sh del repositorio de construccion. No editar.

set -u

raiz="$(cd "$(dirname "$0")/../.." && pwd)"
readonly ETIQUETA_PARTIDA="punto-de-partida"
readonly RUTAS="escenario docs/proyecto docs/arquitectura/decisiones scripts/integracion scripts/integracion-local.sh .github/workflows CHANGELOG.md"

uso() {
    echo "Uso: bash scripts/proyecto/ponerse-al-dia.sh <lab-5-2|lab-5-3|lab-5-4> <java|dotnet> [clave] [--confirmo-descartar]" >&2
}

laboratorio=""; stack=""; clave=""; confirmado=0
for argumento in "$@"; do
    case "$argumento" in
        --confirmo-descartar) confirmado=1 ;;
        5.2|5-2|lab-5-2) laboratorio="lab-5-2" ;;
        5.3|5-3|lab-5-3) laboratorio="lab-5-3" ;;
        5.4|5-4|lab-5-4) laboratorio="lab-5-4" ;;
        java|dotnet) stack="$argumento" ;;
        *) clave="$argumento" ;;
    esac
done
if [ -z "$laboratorio" ] || [ -z "$stack" ]; then uso; exit 2; fi

cd "$raiz" || exit 2
if ! command -v openssl > /dev/null 2>&1; then
    echo "No encuentro openssl. En Windows viene con Git para Windows y se usa desde Git Bash." >&2
    exit 2
fi
if ! git rev-parse -q --verify "refs/tags/$ETIQUETA_PARTIDA" > /dev/null; then
    echo "No encuentro la etiqueta $ETIQUETA_PARTIDA en este repositorio." >&2
    exit 2
fi
if [ -z "$clave" ]; then
    if [ ! -t 0 ]; then echo "Falta la clave. La dice el relator." >&2; exit 1; fi
    printf 'Clave que dijo el relator: '
    read -r clave
    clave="$(printf '%s' "$clave" | tr -d '\r ')"
fi

temporal="$(mktemp -d 2>/dev/null || mktemp -d -t ponerse)"
trap 'rm -rf "$temporal"' EXIT

bloque() {
    case "$1" in
CABECERA
    local lab stack
    for lab in $LABS; do
        for stack in $STACKS; do
            echo "        $lab-$stack) cat <<'DATOS'"
            cifrar "$trabajo/estados/$lab-$stack.patch"
            echo "DATOS"
            echo "        ;;"
        done
    done
    cat <<'PIE'
        *) return 1 ;;
    esac
}

if ! bloque "$laboratorio-$stack" | openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 -md sha256 -a \
        -pass "pass:$clave" > "$temporal/estado.patch" 2>/dev/null || [ ! -s "$temporal/estado.patch" ]; then
    echo "La clave no es correcta. No se modifico nada."
    exit 1
fi

echo "== Ponerse al dia: inicio de $laboratorio, stack $stack =="
echo "  [AVISO] Se descarta todo el trabajo del capitulo 5 que haya en este repositorio:"
echo "          $RUTAS"
echo "  [AVISO] Los commits siguen en el historial; los archivos vuelven al estado de referencia."
if [ "$confirmado" -eq 0 ]; then
    if [ ! -t 0 ]; then echo "  Hace falta confirmar. Repite con --confirmo-descartar."; exit 1; fi
    printf '\n  Escribe descartar para continuar, cualquier otra cosa para cancelar: '
    read -r respuesta
    respuesta="$(printf '%s' "$respuesta" | tr -d '\r ' | tr '[:upper:]' '[:lower:]')"
    if [ "$respuesta" != "descartar" ]; then echo "  Cancelado. No se modifico nada."; exit 1; fi
fi

for ruta in $RUTAS; do
    if [ -n "$(git ls-tree -r --name-only "$ETIQUETA_PARTIDA" -- "$ruta" 2>/dev/null)" ]; then
        git restore --source="$ETIQUETA_PARTIDA" --staged --worktree -- "$ruta" 2>/dev/null || { echo "No se pudo restaurar $ruta" >&2; exit 2; }
    else
        git rm -r -q --cached --ignore-unmatch -- "$ruta" > /dev/null 2>&1
    fi
    git clean -f -d -q -- "$ruta" > /dev/null 2>&1
done

if ! git apply --whitespace=nowarn "$temporal/estado.patch"; then
    echo "  [FALLA] El estado no se aplico limpio. Revisa con git status." >&2
    exit 2
fi

echo "  [ OK ] Listo para empezar el $laboratorio con $stack."
echo "  Revisa los cambios con git status y confirmalos en tu rama antes de seguir."
exit 0
PIE
}

construir_estados "$trabajo/estados"

if [ "${1:-}" = "--verificar" ]; then
    fallas=0
    for lab in $LABS; do
        for stack in $STACKS; do
            if ! cmp -s "$trabajo/estados/$lab-$stack.patch" "$entregas/$lab-$stack.patch"; then
                echo "  [FALLA] $lab-$stack.patch no corresponde a las fuentes. Ejecuta bash herramientas/generar-ponerse-al-dia.sh"
                fallas=$((fallas + 1)); continue
            fi
            if ! awk -v b="        $lab-$stack) cat <<'DATOS'" '$0 == b { en = 1; next } en && $0 == "DATOS" { exit } en { print }' "$destino" \
                    | openssl enc -d -aes-256-cbc -pbkdf2 -iter "$ITERACIONES" -md sha256 -a -pass "pass:$clave" 2>/dev/null \
                    | cmp -s - "$entregas/$lab-$stack.patch"; then
                echo "  [FALLA] El bloque $lab-$stack del script publicado no descifra al estado guardado"
                fallas=$((fallas + 1))
            fi
        done
    done
    [ "$fallas" -eq 0 ] && echo "  [ OK ] ponerse-al-dia.sh corresponde a sus fuentes"
    exit $(( fallas > 0 ))
fi

mkdir -p "$entregas"
cp "$trabajo"/estados/*.patch "$entregas/"
generar_script > "$destino"
chmod +x "$destino"
echo "Generado ${destino#"$raiz"/} y los estados en ${entregas#"$raiz"/}"
