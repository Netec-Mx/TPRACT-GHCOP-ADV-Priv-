#!/usr/bin/env bash
#
# Pasos del pipeline de integracion continua del repositorio.
#
# Este script es la unica fuente de los pasos. El workflow
# .github/workflows/integracion-continua.yml ejecuta cada uno con --paso, y un gate del
# repositorio de construccion verifica que el workflow llame a los mismos pasos en el mismo
# orden. Sin argumentos, el script corre todos los pasos en orden en la maquina local, sin
# Docker. Es la alternativa cuando no se puede abrir un pull request en GitHub.
#
# Los pasos de dependencias son informativos: listan y revisan, pero nunca hacen fallar el
# pipeline. Sin red, avisan que la revision no esta disponible y siguen.
#
# Codigo de salida: 0 si todos los pasos pasan, 1 si alguno falla, 2 si un argumento no es
# valido.
#
# Corre en macOS, Linux y Git Bash sobre Windows. Se ejecuta desde la raiz del repositorio.

set -u

readonly VERSION_SCRIPT="1.0.0"

# Orden de los pasos. El workflow tiene que llamarlos en este mismo orden.
readonly PASOS=(java dependencias-java dotnet dependencias-dotnet equivalencia)

readonly PERIODOS=(2026-04 2026-05 2026-06)

raiz="$(cd "$(dirname "$0")/.." && pwd)"

titulo() { printf '\n== %s ==\n' "$1"; }
aviso()  { printf '  [AVISO] %s\n' "$1"; }

uso() {
    cat <<EOF
Uso: bash scripts/integracion-local.sh [opciones]

Corre los pasos del pipeline de integracion continua.

Opciones:
  --paso NOMBRE   Corre solo ese paso. Pasos: ${PASOS[*]}
  --listar        Muestra los pasos en orden y termina.
  --ayuda         Muestra esta ayuda y termina.
  --version       Muestra la version del script y termina.

Codigo de salida: 0 si todo pasa, 1 si algun paso falla, 2 si un argumento no es valido.
EOF
}

paso_java() {
    titulo "Java: compilar y ejecutar las pruebas"
    (cd "$raiz/escenario/java" && mvn -B clean package)
}

paso_dependencias_java() {
    titulo "Java: dependencias"
    if ! (cd "$raiz/escenario/java" && mvn -B -q dependency:tree -DoutputType=text); then
        aviso "No se pudo listar las dependencias. Sin red, Maven necesita el complemento en la cache local."
    fi
    aviso "Maven no trae una revision de vulnerabilidades que funcione sin clave ni servicio externo. Esta revision no se incluye."
    return 0
}

paso_dotnet() {
    titulo ".NET: compilar y ejecutar las pruebas"
    (cd "$raiz/escenario/dotnet" \
        && dotnet build LiquidacionComercios -c Release \
        && dotnet test LiquidacionComercios.Pruebas)
}

paso_dependencias_dotnet() {
    titulo ".NET: dependencias"
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

paso_equivalencia() {
    titulo "Equivalencia: liquidacion de los tres periodos en los dos stacks"
    local periodo fallas=0
    for periodo in "${PERIODOS[@]}"; do
        bash "$raiz/scripts/comparar-escenarios.sh" --periodo "$periodo" || fallas=$((fallas + 1))
    done
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

case "${1:-}" in
    --ayuda|-h)  uso; exit 0 ;;
    --version)   echo "integracion-local.sh $VERSION_SCRIPT"; exit 0 ;;
    --listar)    printf '%s\n' "${PASOS[@]}"; exit 0 ;;
    --paso)
        if [ -z "${2:-}" ]; then uso >&2; exit 2; fi
        correr "$2"; rc=$?
        [ "$rc" -eq 2 ] && exit 2
        [ "$rc" -eq 0 ] && exit 0 || exit 1
        ;;
    "")
        fallas=0
        for nombre in "${PASOS[@]}"; do
            if ! correr "$nombre"; then
                printf '  [FALLA] %s\n' "$nombre"
                fallas=$((fallas + 1))
            fi
        done
        printf '\n== Resumen ==\n'
        if [ "$fallas" -eq 0 ]; then echo "  Todos los pasos pasan."; exit 0; fi
        echo "  $fallas paso(s) fallaron."; exit 1
        ;;
    *) uso >&2; exit 2 ;;
esac
