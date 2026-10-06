#!/usr/bin/env bash
#
# Pasos del pipeline de integracion continua del repositorio.
#
# Este script es la unica fuente de los pasos. El workflow
# .github/workflows/integracion-continua.yml ejecuta cada uno con --paso, y un gate del
# repositorio de construccion verifica que el workflow llame a los mismos pasos en el mismo
# orden. Sin argumentos, el script corre todos los pasos en orden en la maquina local, sin
# Docker. Es el camino normal para trabajar sin GitHub.
#
# El stack se declara en scripts/integracion/stack.txt: ambos, java o dotnet. Con un solo
# stack, los pasos del otro se omiten y la equivalencia se comprueba contra los hashes
# esperados de scripts/integracion/liquidacion-esperada.sha256.
#
# Los pasos de dependencias son informativos: listan y revisan, pero nunca hacen fallar el
# pipeline. Sin red, avisan que la revision no esta disponible y siguen.
#
# Codigo de salida: 0 si todos los pasos pasan, 1 si alguno falla, 2 si un argumento no es
# valido.
#
# Corre en macOS, Linux y Git Bash sobre Windows. Se ejecuta desde la raiz del repositorio.

set -u

readonly VERSION_SCRIPT="1.1.0"

# Orden de los pasos. El workflow tiene que llamarlos en este mismo orden.
readonly PASOS=(java dependencias-java dotnet dependencias-dotnet equivalencia)

readonly PERIODOS=(2026-04 2026-05 2026-06)

raiz="$(cd "$(dirname "$0")/.." && pwd)"
readonly ARCHIVO_STACK="$raiz/scripts/integracion/stack.txt"
readonly ARCHIVO_HASHES="$raiz/scripts/integracion/liquidacion-esperada.sha256"

titulo() { printf '\n== %s ==\n' "$1"; }
aviso()  { printf '  [AVISO] %s\n' "$1"; }

uso() {
    cat <<EOF
Uso: bash scripts/integracion-local.sh [opciones]

Corre los pasos del pipeline de integracion continua.

Opciones:
  --paso NOMBRE   Corre solo ese paso. Pasos: ${PASOS[*]}
  --stack STACK   ambos, java o dotnet. Reemplaza lo declarado en scripts/integracion/stack.txt.
  --listar        Muestra los pasos en orden y termina.
  --ayuda         Muestra esta ayuda y termina.
  --version       Muestra la version del script y termina.

Codigo de salida: 0 si todo pasa, 1 si algun paso falla, 2 si un argumento no es valido.
EOF
}

# Lineas activas de stack.txt: sin comentarios, sin \r, sin espacios y sin lineas vacias.
lineas_stack() {
    grep -v '^[[:space:]]*#' "$ARCHIVO_STACK" 2>/dev/null \
        | tr -d '\r' | sed 's/[[:space:]]//g' | grep -v '^$'
}

# Escribe el stack declarado. Si hay mas de una linea activa, explica cual dejar y falla.
stack_declarado() {
    local lineas cantidad
    lineas=$(lineas_stack)
    cantidad=$(printf '%s' "$lineas" | grep -c .)
    if [ "$cantidad" -gt 1 ]; then
        printf 'scripts/integracion/stack.txt tiene %s lineas activas: %s.
' \
            "$cantidad" "$(printf '%s' "$lineas" | paste -sd ',' - | sed 's/,/, /g')" >&2
        printf 'Deja una sola, la del stack que elegiste (ambos, java o dotnet), y confirma el cambio.\n' >&2
        return 1
    fi
    printf '%s' "$lineas"
}

usa() {
    [ "$stack" = "ambos" ] || [ "$stack" = "$1" ]
}

hash_de() {
    # Sin \r, para que la salida de Windows y la de Linux den el mismo hash.
    if command -v sha256sum >/dev/null 2>&1; then
        tr -d '\r' < "$1" | sha256sum | cut -d' ' -f1
    else
        tr -d '\r' < "$1" | shasum -a 256 | cut -d' ' -f1
    fi
}

hash_esperado() {
    grep -v '^#' "$ARCHIVO_HASHES" | awk -v p="$1" '$2 == p { print $1 }'
}

paso_java() {
    titulo "Java: compilar y ejecutar las pruebas"
    if ! usa java; then aviso "Stack $stack: se omite Java."; return 0; fi
    (cd "$raiz/escenario/java" && mvn -B clean package)
}

paso_dependencias_java() {
    titulo "Java: dependencias"
    if ! usa java; then aviso "Stack $stack: se omite Java."; return 0; fi
    if ! (cd "$raiz/escenario/java" && mvn -B -q dependency:tree -DoutputType=text); then
        aviso "No se pudo listar las dependencias. Sin red, Maven necesita el complemento en la cache local."
    fi
    aviso "Maven no trae una revision de vulnerabilidades que funcione sin clave ni servicio externo. Esta revision no se incluye."
    return 0
}

paso_dotnet() {
    titulo ".NET: compilar y ejecutar las pruebas"
    if ! usa dotnet; then aviso "Stack $stack: se omite .NET."; return 0; fi
    (cd "$raiz/escenario/dotnet" \
        && dotnet build LiquidacionComercios -c Release \
        && dotnet test LiquidacionComercios.Pruebas)
}

paso_dependencias_dotnet() {
    titulo ".NET: dependencias"
    if ! usa dotnet; then aviso "Stack $stack: se omite .NET."; return 0; fi
    local proyecto salida
    for proyecto in LiquidacionComercios LiquidacionComercios.Pruebas; do
        (cd "$raiz/escenario/dotnet" && dotnet list "$proyecto" package --include-transitive) \
            || aviso "No se pudo listar las dependencias de $proyecto."
        salida=$(cd "$raiz/escenario/dotnet" \
            && dotnet list "$proyecto" package --vulnerable --include-transitive 2>&1)
        printf '%s\n' "$salida"
        case "$salida" in
            *"Unable to load the service index"*)
                aviso "Sin acceso a nuget.org, la revision de vulnerabilidades de $proyecto no esta disponible." ;;
        esac
    done
    return 0
}

# Ejecuta el escenario del stack indicado con el resto de los argumentos.
liquidar() {
    local s="$1"; shift
    if [ "$s" = "java" ]; then
        (cd "$raiz/escenario/java" && java -jar target/liquidacion-comercios.jar "$@")
    else
        (cd "$raiz/escenario/dotnet" && dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll "$@")
    fi
}

paso_equivalencia() {
    titulo "Equivalencia: liquidacion de los tres periodos (stack: $stack)"
    local periodo s fallas=0 temporal esperado obtenido
    temporal=$(mktemp -d 2>/dev/null || mktemp -d -t integracion)
    if usa java; then
        (cd "$raiz/escenario/java" && mvn -q clean package -DskipTests) || { rm -rf "$temporal"; return 1; }
    fi
    if usa dotnet; then
        (cd "$raiz/escenario/dotnet" && dotnet build LiquidacionComercios -c Release > "$temporal/build.log") \
            || { cat "$temporal/build.log"; rm -rf "$temporal"; return 1; }
    fi
    for periodo in "${PERIODOS[@]}"; do
        esperado=$(hash_esperado "$periodo")
        for s in java dotnet; do
            usa "$s" || continue
            liquidar "$s" "$periodo" > "$temporal/$s-$periodo.txt" 2>/dev/null
            obtenido=$(hash_de "$temporal/$s-$periodo.txt")
            if [ "$obtenido" = "$esperado" ]; then
                printf '  [ OK ] %s %s coincide con el hash esperado\n' "$s" "$periodo"
            else
                printf '  [FALLA] %s %s no coincide con el hash esperado\n' "$s" "$periodo"
                printf '          esperado %s\n          obtenido %s\n' "$esperado" "$obtenido"
                fallas=$((fallas + 1))
            fi
        done
        if [ "$stack" = "ambos" ]; then
            bash "$raiz/scripts/comparar-escenarios.sh" --periodo "$periodo" --sin-compilar \
                || fallas=$((fallas + 1))
        fi
    done
    rm -rf "$temporal"
    [ "$fallas" -eq 0 ]
}

correr() {
    case "$1" in
        java)                paso_java ;;
        dependencias-java)   paso_dependencias_java ;;
        dotnet)              paso_dotnet ;;
        dependencias-dotnet) paso_dependencias_dotnet ;;
        equivalencia)        paso_equivalencia ;;
        *) printf 'Paso desconocido: %s\n' "$1" >&2; return 2 ;;
    esac
}

stack=""
accion="todos"
paso=""
while [ $# -gt 0 ]; do
    case "$1" in
        --ayuda|-h)  uso; exit 0 ;;
        --version)   echo "integracion-local.sh $VERSION_SCRIPT"; exit 0 ;;
        --listar)    printf '%s\n' "${PASOS[@]}"; exit 0 ;;
        --paso)      [ -n "${2:-}" ] || { uso >&2; exit 2; }; accion="paso"; paso="$2"; shift 2 ;;
        --stack)     [ -n "${2:-}" ] || { uso >&2; exit 2; }; stack="$2"; shift 2 ;;
        *)           uso >&2; exit 2 ;;
    esac
done

if [ -z "$stack" ]; then
    stack="$(stack_declarado)" || exit 2
fi
[ -n "$stack" ] || stack="ambos"
case "$stack" in
    ambos|java|dotnet) ;;
    *) printf 'Stack no valido: «%s». Usa ambos, java o dotnet.\n' "$stack" >&2; exit 2 ;;
esac

# En Git Bash sobre Windows, .NET escribe en la pagina de codigos de la consola y Java en
# UTF-8; una razon social con «ñ» cambia el hash de la liquidacion .NET. Mientras corre el
# pipeline, la consola usa UTF-8; al terminar vuelve a la pagina original.
pagina_original=""
case "$(uname -s 2>/dev/null)" in
    MINGW*|MSYS*|CYGWIN*)
        if command -v chcp.com >/dev/null 2>&1; then
            pagina_original=$(chcp.com 2>/dev/null | tr -dc '0-9')
            chcp.com 65001 > /dev/null 2>&1
        fi
        ;;
esac
restaurar_pagina() {
    [ -n "$pagina_original" ] && chcp.com "$pagina_original" > /dev/null 2>&1
    return 0
}
trap restaurar_pagina EXIT

if [ "$accion" = "paso" ]; then
    correr "$paso"; rc=$?
    [ "$rc" -eq 2 ] && exit 2
    [ "$rc" -eq 0 ] && exit 0 || exit 1
fi

fallas=0
for nombre in "${PASOS[@]}"; do
    if ! correr "$nombre"; then
        printf '  [FALLA] %s\n' "$nombre"
        fallas=$((fallas + 1))
    fi
done
printf '\n== Resumen (stack: %s) ==\n' "$stack"
if [ "$fallas" -eq 0 ]; then echo "  Todos los pasos pasan."; exit 0; fi
echo "  $fallas paso(s) fallaron."; exit 1
