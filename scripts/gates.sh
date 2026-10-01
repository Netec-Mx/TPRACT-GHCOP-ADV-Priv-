#!/usr/bin/env bash
#
# Corre todos los gates del repositorio de construccion dentro de la imagen de
# herramientas/Dockerfile, sin red.
#
# La maquina de construccion no tiene por que tener las versiones del taller. La imagen trae
# JDK 25, SDK de .NET 10, Node 24, Maven, Git y Bash, con las dependencias precargadas. Si la
# imagen no existe, el script la construye, y para eso si hace falta red.
#
# Secuencia, sobre una copia del repositorio dentro del contenedor:
#   1. verificar-ambiente.sh
#   2. validar-skills.sh
#   3. comparar-escenarios.sh en los tres periodos de los datos
#   4. Pruebas del escenario Java y del escenario .NET
#   5. Gate de fugas de publicar-taller.sh
#
# Codigo de salida: 0 si todos los gates pasan, 1 si alguno falla, 2 si no se pudo
# construir o ejecutar la imagen.
#
# Requiere Docker. Corre en macOS, Linux y Git Bash sobre Windows.

set -u

raiz="$(cd "$(dirname "$0")/.." && pwd)"
readonly DOCKERFILE="herramientas/Dockerfile"

# El nombre de la imagen incluye un resumen del Dockerfile y de los archivos de dependencias.
# Si cualquiera cambia, se construye una imagen nueva en lugar de usar una desactualizada.
resumen=$(cd "$raiz" && cat "$DOCKERFILE" herramientas/Dockerfile.dockerignore \
    escenario/java/pom.xml escenario/dotnet/*/*.csproj mcp/servidor-local/package-lock.json \
    | git hash-object --stdin | cut -c1-12)
readonly IMAGEN="taller-gates:$resumen"

if ! command -v docker >/dev/null 2>&1; then
    echo "[FALLA] Docker no esta instalado o no esta en el PATH" >&2
    exit 2
fi

if ! docker image inspect "$IMAGEN" >/dev/null 2>&1; then
    echo "== Construyendo la imagen $IMAGEN, requiere red =="
    if ! docker build -t "$IMAGEN" -f "$raiz/$DOCKERFILE" "$raiz"; then
        echo "[FALLA] No se pudo construir la imagen" >&2
        exit 2
    fi
fi

inicio=$(date +%s)
echo "== Gates en $IMAGEN, sin red =="

docker run --rm --network none -v "$raiz":/repo:ro "$IMAGEN" bash -c '
set -u
fallas=0
paso() { printf "\n== %s ==\n" "$1"; }
resultado() {
    if [ "$1" -eq 0 ]; then echo "  [ OK ] $2"; else echo "  [FALLA] $2"; fallas=$((fallas + 1)); fi
}

# Copia de trabajo, sin binarios de compilacion de la maquina anfitriona.
cp -R /repo /tmp/r && cd /tmp/r || exit 2
rm -rf escenario/java/target escenario/dotnet/*/bin escenario/dotnet/*/obj mcp/servidor-local/node_modules
cp -R /opt/mcp/node_modules mcp/servidor-local/node_modules
git config --global --add safe.directory "*"

paso "verificar-ambiente.sh"
# En el contenedor no hay Visual Studio Code. Esa es la unica falla aceptada: cualquier
# otra hace fallar el gate.
NO_COLOR=1 bash scripts/verificar-ambiente.sh --sin-red > /tmp/verificar.log 2>&1
otras=$(grep "\[FALLA\]" /tmp/verificar.log | grep -v "Visual Studio Code no esta instalado")
grep -E "\[ OK \]|\[FALLA\]|\[AVISO\]" /tmp/verificar.log | sed "s/^/  /"
[ -z "$otras" ]; resultado $? "verificar-ambiente.sh, sin fallas fuera del editor ausente"

paso "validar-skills.sh"
NO_COLOR=1 bash scripts/validar-skills.sh > /tmp/skills.log 2>&1; rc=$?
tail -1 /tmp/skills.log | sed "s/^/  /"; grep "\[FALLA\]" -A3 /tmp/skills.log | sed "s/^/  /"
resultado $rc "validar-skills.sh"

paso "comparar-escenarios.sh"
for periodo in 2026-04 2026-05 2026-06; do
    NO_COLOR=1 bash scripts/comparar-escenarios.sh --periodo "$periodo" > /tmp/comparar.log 2>&1
    resultado $? "Salidas identicas en $periodo"
done

paso "Pruebas de los escenarios"
(cd escenario/java && mvn -o -B -q test > /tmp/mvn.log 2>&1); resultado $? "Pruebas Java"
(cd escenario/dotnet && dotnet test LiquidacionComercios.Pruebas > /tmp/dotnet.log 2>&1); resultado $? "Pruebas .NET"

paso "Gate de fugas"
NO_COLOR=1 bash scripts/publicar-taller.sh --destino /tmp/publicacion > /tmp/fugas.log 2>&1; rc=$?
grep "\[FALLA\]" -A5 /tmp/fugas.log | sed "s/^/  /"
resultado $rc "Sin material del relator en el contenido publicable"

printf "\n== Resumen ==\n"
if [ "$fallas" -eq 0 ]; then echo "  Todos los gates pasan."; exit 0; fi
echo "  $fallas gate(s) fallaron."; exit 1
'
rc=$?
fin=$(date +%s)
echo "  Duracion: $((fin - inicio)) s"
exit "$rc"
