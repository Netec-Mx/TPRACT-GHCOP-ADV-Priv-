#!/usr/bin/env bash
#
# Pruebas del hook de proteccion de datos, .github/hooks/proteger-datos-escenario.js.
#
# Cada caso es una entrada JSON como la que recibe el hook y el codigo de salida esperado:
# 2 si debe bloquear, 0 si debe dejar pasar. Hay casos con el formato de Visual Studio Code,
# tool_name y tool_input, y con el de Copilot CLI, toolName y toolArgs como texto JSON.
#
# Uso: bash herramientas/probar-hook.sh [raiz del repositorio]
# Codigo de salida: 0 si todos los casos dan lo esperado, 1 si alguno falla.

set -u

raiz="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
hook="$raiz/.github/hooks/proteger-datos-escenario.js"
fallas=0
total=0

# caso <esperado> <descripcion> <json>
caso() {
    local esperado="$1" descripcion="$2" entrada="$3" obtenido
    total=$((total + 1))
    printf '%s' "$entrada" | (cd "$raiz" && node "$hook" > /dev/null 2>&1)
    obtenido=$?
    if [ "$obtenido" -eq "$esperado" ]; then
        echo "  [ OK ] $descripcion"
    else
        echo "  [FALLA] $descripcion: se esperaba $esperado y salio $obtenido"
        fallas=$((fallas + 1))
    fi
}

# Arma la entrada de Copilot CLI: toolArgs es un texto JSON.
cli() {
    node -e 'process.stdout.write(JSON.stringify({toolName: process.argv[1], toolArgs: process.argv[2]}))' "$1" "$2"
}

echo "== Deben bloquearse =="
caso 2 "VS Code: editFiles sobre un archivo de datos" \
    '{"tool_name":"editFiles","tool_input":{"files":["escenario/datos/planes.txt"]}}'
caso 2 "VS Code: createFile dentro de la carpeta de datos" \
    '{"tool_name":"createFile","tool_input":{"filePath":"escenario/datos/nuevo.txt","content":"x"}}'
caso 2 "VS Code: replace_string_in_file en transacciones.txt" \
    '{"tool_name":"replace_string_in_file","tool_input":{"filePath":"/repo/escenario/datos/transacciones.txt","oldString":"a","newString":"b"}}'
caso 2 "VS Code: apply_patch que actualiza un archivo de datos" \
    '{"tool_name":"apply_patch","tool_input":{"input":"*** Begin Patch\n*** Update File: escenario/datos/comercios.txt\n@@\n-a\n+b\n*** End Patch"}}'
caso 2 "CLI: create dentro de la carpeta de datos" \
    "$(cli create '{"path":"/repo/escenario/datos/x.txt","file_text":"hola"}')"
caso 2 "CLI: edit sobre un archivo de datos" \
    "$(cli edit '{"path":"escenario/datos/planes.txt","old_str":"a","new_str":"b"}')"
caso 2 "Terminal: redireccion a la carpeta de datos" \
    "$(cli bash '{"command":"echo PRUEBA >> escenario/datos/planes.txt"}')"
caso 2 "Terminal: sed -i sobre un archivo de datos" \
    '{"tool_name":"run_in_terminal","tool_input":{"command":"sed -i s/a/b/ escenario/datos/planes.txt"}}'
caso 2 "Terminal: copia hacia la carpeta de datos" \
    "$(cli bash '{"command":"cp /tmp/x.txt escenario/datos/transacciones.txt"}')"
caso 2 "Terminal: mover un archivo de datos" \
    "$(cli bash '{"command":"mv escenario/datos/planes.txt /tmp/planes.txt"}')"
caso 2 "Terminal: borrar un archivo de datos" \
    '{"tool_name":"run_in_terminal","tool_input":{"command":"rm escenario\\datos\\planes.txt"}}'
caso 2 "Terminal: tee hacia la carpeta de datos, en un comando de varios tramos" \
    "$(cli bash '{"command":"cd /repo && cat a.txt | tee escenario/datos/a.txt"}')"

echo "== Deben pasar =="
caso 0 "VS Code: editar un archivo del escenario Java" \
    '{"tool_name":"editFiles","tool_input":{"files":["escenario/java/pom.xml"]}}'
caso 0 "VS Code: documento fuera de datos que cita la ruta en su contenido" \
    '{"tool_name":"createFile","tool_input":{"filePath":"labs/cap3/lab-3-4-mcp-local/entregables/caso-de-uso-mcp.md","content":"El servidor lee escenario/datos/comercios.txt y escenario/datos/planes.txt."}}'
caso 0 "CLI: documento fuera de datos que cita la ruta en su contenido" \
    "$(cli create '{"path":"/repo/docs/proyecto/pull-request.md","file_text":"No se modifico escenario/datos/."}')"
caso 0 "CLI: prueba Java que lee la carpeta de datos" \
    "$(cli create '{"path":"/repo/escenario/java/src/test/java/X.java","file_text":"Paths.get(\"../datos\"); // escenario/datos/transacciones.txt"}')"
caso 0 "Terminal: leer un archivo de datos" \
    "$(cli bash '{"command":"head -2 escenario/datos/comercios.txt && grep -n NS-0004 mcp/datos/notas-soporte.json 2>/dev/null"}')"
caso 0 "Terminal: leer datos y redirigir la salida fuera de la carpeta" \
    "$(cli bash '{"command":"grep CM0001 escenario/datos/transacciones.txt > /tmp/cm0001.txt"}')"
caso 0 "Terminal: copiar un archivo de datos hacia afuera" \
    "$(cli bash '{"command":"cp escenario/datos/planes.txt /tmp/planes.txt"}')"
caso 0 "Terminal: leer datos y borrar un temporal en otro tramo" \
    "$(cli bash '{"command":"cat escenario/datos/planes.txt; rm -f /tmp/x"}')"
caso 0 "Terminal: ejecutar la liquidacion con la ruta de datos" \
    '{"tool_name":"run_in_terminal","tool_input":{"command":"java -jar target/liquidacion-comercios.jar 2026-06 ../datos"}}'
caso 0 "Lectura de un archivo de datos con view" \
    "$(cli view '{"path":"/repo/escenario/datos/planes.txt"}')"

echo "== Resumen =="
echo "  $((total - fallas)) de $total casos dan lo esperado"
[ "$fallas" -eq 0 ]
