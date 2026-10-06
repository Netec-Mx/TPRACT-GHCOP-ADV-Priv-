#!/usr/bin/env bash
#
# Compara las salidas de los dos escenarios del taller.
#
# Ejecuta la implementacion Java y la implementacion .NET sobre los mismos datos y
# verifica que produzcan exactamente la misma salida. En clase hay participantes de ambos
# stacks comparando resultados, y cualquier diferencia numerica desvia la sesion hacia
# depurar la diferencia en vez de discutir como usaron Copilot.
#
# Codigo de salida: 0 si las salidas son identicas, 1 si difieren, 2 si algo impide
# ejecutar la comparacion.
#
# Corre en macOS, Linux y Git Bash sobre Windows.

set -u

readonly VERSION_SCRIPT="1.1.0"

# Lo unico que se permite normalizar es una marca de tiempo de generacion, si alguna vez
# la salida llega a incluirla. Hoy no la incluye y la comparacion es literal. Cualquier
# otra normalizacion estaria escondiendo una diferencia real.
readonly PATRON_MARCA_TIEMPO='[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}'

periodo="2026-06"
compilar=1

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
Uso: bash comparar-escenarios.sh [opciones]

Ejecuta los escenarios Java y .NET sobre los mismos datos y compara sus salidas.

Opciones:
  --periodo AAAA-MM   Periodo a liquidar. Por omision 2026-06.
  --sin-compilar      Usa los binarios ya construidos, sin volver a compilar.
  --ayuda             Muestra esta ayuda y termina.
  --version           Muestra la version del script y termina.

Codigo de salida:
  0   Las salidas son identicas.
  1   Las salidas difieren.
  2   No se pudo ejecutar la comparacion.
EOF
}

# ---------------------------------------------------------------------------
# Argumentos
# ---------------------------------------------------------------------------

while [ $# -gt 0 ]; do
    case "$1" in
        --periodo)
            if [ $# -lt 2 ]; then
                printf 'La opcion --periodo necesita un valor AAAA-MM\n' >&2
                exit 2
            fi
            periodo="$2"
            shift
            ;;
        --sin-compilar)
            compilar=0
            ;;
        --ayuda|-h|--help)
            uso
            exit 0
            ;;
        --version)
            printf 'comparar-escenarios.sh %s\n' "$VERSION_SCRIPT"
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
# Ubicacion
# ---------------------------------------------------------------------------

directorio_script=$(cd "$(dirname "$0")" && pwd)
raiz_repositorio=$(cd "$directorio_script/.." && pwd)

ruta_java="$raiz_repositorio/escenario/java"
ruta_dotnet="$raiz_repositorio/escenario/dotnet"
ruta_datos="$raiz_repositorio/escenario/datos"

printf '%sComparacion de escenarios, taller de GitHub Copilot%s\n' "$C_TITULO" "$C_FIN"
printf 'Script version %s\n' "$VERSION_SCRIPT"
printf 'Periodo: %s\n' "$periodo"
printf 'Repositorio: %s\n' "$raiz_repositorio"

titulo "Requisitos"

problemas=0

for par in "java:JDK" "mvn:Apache Maven" "dotnet:SDK de .NET" "diff:diff"; do
    binario="${par%%:*}"
    etiqueta="${par#*:}"
    if command -v "$binario" >/dev/null 2>&1; then
        ok "$etiqueta disponible"
    else
        falla "$etiqueta no esta instalado o no esta en el PATH"
        problemas=$((problemas + 1))
    fi
done

for directorio in "$ruta_java" "$ruta_dotnet" "$ruta_datos"; do
    if [ -d "$directorio" ]; then
        ok "$(basename "$directorio") encontrado"
    else
        falla "No existe el directorio $directorio"
        problemas=$((problemas + 1))
    fi
done

if [ "$problemas" -gt 0 ]; then
    titulo "Resumen"
    printf '  %sNo se puede comparar.%s Faltan %d requisito(s).\n' "$C_FALLA" "$C_FIN" "$problemas"
    exit 2
fi

# ---------------------------------------------------------------------------
# Directorio temporal
# ---------------------------------------------------------------------------

temporal=$(mktemp -d 2>/dev/null || mktemp -d -t comparar-escenarios)
if [ -z "$temporal" ] || [ ! -d "$temporal" ]; then
    falla "No se pudo crear el directorio temporal"
    exit 2
fi

# En Git Bash sobre Windows, .NET escribe en la pagina de codigos de la consola, que en una
# maquina en espanol es 850 o 437, mientras Java escribe en UTF-8. Una razon social con «ñ»
# sale distinta en los dos y la comparacion falla sin que haya una diferencia de calculo.
# Mientras corre el script, la consola usa UTF-8; al terminar vuelve a la pagina original.
pagina_original=""
case "$(uname -s 2>/dev/null)" in
    MINGW*|MSYS*|CYGWIN*)
        if command -v chcp.com >/dev/null 2>&1; then
            pagina_original=$(chcp.com 2>/dev/null | tr -dc '0-9')
            chcp.com 65001 > /dev/null 2>&1
        fi
        ;;
esac

limpiar() {
    [ -n "${temporal:-}" ] && [ -d "$temporal" ] && rm -rf "$temporal"
    [ -n "$pagina_original" ] && chcp.com "$pagina_original" > /dev/null 2>&1
}
trap limpiar EXIT INT TERM

salida_java="$temporal/salida-java.txt"
salida_dotnet="$temporal/salida-dotnet.txt"
normal_java="$temporal/normalizada-java.txt"
normal_dotnet="$temporal/normalizada-dotnet.txt"

# ---------------------------------------------------------------------------
# Compilacion
# ---------------------------------------------------------------------------

if [ "$compilar" -eq 1 ]; then
    titulo "Compilacion"

    if (cd "$ruta_java" && mvn -q clean package -DskipTests > "$temporal/build-java.log" 2>&1); then
        ok "Escenario Java compilado"
    else
        falla "El escenario Java no compila"
        printf '\n  Ultimas lineas del log:\n'
        tail -20 "$temporal/build-java.log" | sed 's/^/    /'
        exit 2
    fi

    if (cd "$ruta_dotnet" && dotnet build LiquidacionComercios -c Release > "$temporal/build-dotnet.log" 2>&1); then
        ok "Escenario .NET compilado"
    else
        falla "El escenario .NET no compila"
        printf '\n  Ultimas lineas del log:\n'
        tail -20 "$temporal/build-dotnet.log" | sed 's/^/    /'
        exit 2
    fi
else
    titulo "Compilacion"
    printf '  Omitida por --sin-compilar\n'
fi

# ---------------------------------------------------------------------------
# Ejecucion
# ---------------------------------------------------------------------------

titulo "Ejecucion"

jar_java="$ruta_java/target/liquidacion-comercios.jar"
dll_dotnet="$ruta_dotnet/LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll"

if [ ! -f "$jar_java" ]; then
    falla "No existe $jar_java, compila primero sin --sin-compilar"
    exit 2
fi
if [ ! -f "$dll_dotnet" ]; then
    falla "No existe $dll_dotnet, compila primero sin --sin-compilar"
    exit 2
fi

# Cada escenario se ejecuta desde su propio directorio, de modo que la ruta relativa a
# los datos compartidos sea la misma en ambos.
if (cd "$ruta_java" && java -jar target/liquidacion-comercios.jar "$periodo" > "$salida_java" 2>&1); then
    ok "Escenario Java ejecutado ($(wc -l < "$salida_java" | tr -d ' ') lineas)"
else
    falla "El escenario Java termino con error"
    tail -20 "$salida_java" | sed 's/^/    /'
    exit 2
fi

if (cd "$ruta_dotnet" && dotnet "$dll_dotnet" "$periodo" > "$salida_dotnet" 2>&1); then
    ok "Escenario .NET ejecutado ($(wc -l < "$salida_dotnet" | tr -d ' ') lineas)"
else
    falla "El escenario .NET termino con error"
    tail -20 "$salida_dotnet" | sed 's/^/    /'
    exit 2
fi

# ---------------------------------------------------------------------------
# Normalizacion
# ---------------------------------------------------------------------------

# Se normalizan tres cosas y nada mas:
#
#   1. Los retornos de carro, porque en Git Bash sobre Windows una de las dos plataformas
#      puede emitirlos y eso no es una diferencia de calculo.
#
#   2. Una eventual marca de tiempo de generacion, que por definicion difiere entre dos
#      ejecuciones y no dice nada sobre la equivalencia.
#
#   3. Los avisos que la maquina virtual de Java escribe en la salida de error estandar
#      cuando estan definidas JAVA_TOOL_OPTIONS, _JAVA_OPTIONS o JDK_JAVA_OPTIONS. Esas
#      variables son habituales en entornos corporativos, donde se usan para agentes de
#      monitoreo o para la configuracion de proxy, y la JVM anuncia que las tomo antes de
#      que el programa escriba una sola linea. Sin este filtro el comparador reporta una
#      diferencia aunque los dos escenarios sean correctos.
#
# El tercer filtro es deliberadamente estrecho. Solo descarta lineas que empiezan con el
# texto exacto que emite la JVM, anclado al inicio de linea. Se comprobo que ninguna de las
# 554 lineas de la salida del programa empieza asi. No se filtra por palabras sueltas ni
# por patrones amplios, porque un filtro generoso puede tragarse una diferencia real y eso
# seria peor que el problema que resuelve.
readonly PATRON_AVISOS_JVM='^(Picked up (JAVA_TOOL_OPTIONS|_JAVA_OPTIONS|JAVA_OPTIONS):|NOTE: Picked up JDK_JAVA_OPTIONS:)'

normalizar() {
    tr -d '\r' < "$1" \
        | grep -vE "$PATRON_AVISOS_JVM" \
        | sed "s/$PATRON_MARCA_TIEMPO/MARCA-DE-TIEMPO/g" > "$2"
}

normalizar "$salida_java" "$normal_java"
normalizar "$salida_dotnet" "$normal_dotnet"

# ---------------------------------------------------------------------------
# Comparacion
# ---------------------------------------------------------------------------

titulo "Comparacion"

if diff -u "$normal_java" "$normal_dotnet" > "$temporal/diferencias.txt" 2>&1; then
    lineas=$(wc -l < "$normal_java" | tr -d ' ')
    bytes=$(wc -c < "$normal_java" | tr -d ' ')
    ok "Las salidas son identicas"
    printf '       %s lineas, %s bytes\n' "$lineas" "$bytes"

    titulo "Resumen"
    printf '  %sEscenarios equivalentes.%s Java y .NET producen la misma salida para %s.\n' \
        "$C_OK" "$C_FIN" "$periodo"
    exit 0
fi

distintas=$(grep -c '^[+-][^+-]' "$temporal/diferencias.txt" 2>/dev/null || echo "0")
falla "Las salidas difieren en $distintas linea(s)"

printf '\n  Primeras diferencias:\n\n'
head -40 "$temporal/diferencias.txt" | sed 's/^/    /'

if [ "$(wc -l < "$temporal/diferencias.txt" | tr -d ' ')" -gt 40 ]; then
    printf '    ...\n'
fi

titulo "Resumen"
printf '  %sEscenarios NO equivalentes.%s\n' "$C_FALLA" "$C_FIN"
printf '\n  Una diferencia aqui casi siempre viene de uno de estos puntos:\n'
printf '    - Redondeo. .NET usa redondeo bancario por omision y Java no.\n'
printf '    - Formateo. ToString("F2") y String.format("%%.2f") no coinciden en los\n'
printf '      puntos medios.\n'
printf '    - Cultura. Una maquina en español imprime coma decimal y lee mal los datos.\n'
printf '    - Orden de iteracion de las colecciones.\n'
printf '\n  Los tres primeros estan resueltos en Util/CompatibilidadJava.cs del escenario\n'
printf '  .NET. Revisa esa clase antes de buscar en otro lado.\n'
exit 1
