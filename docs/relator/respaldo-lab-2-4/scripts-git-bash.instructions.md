---
name: 'Scripts de Git Bash'
description: 'Convenciones para los scripts de scripts/: códigos de salida, compatibilidad con Git Bash, macOS y Linux, mensajes de error y qué no usar'
applyTo: 'scripts/**/*.sh'
---

# Scripts de Git Bash

## Reglas

- La primera línea es `#!/usr/bin/env bash`, como en `scripts/comparar-escenarios.sh:1`.
- Después va un comentario de cabecera que dice qué hace el script, sus códigos de salida
  y la frase «Corre en macOS, Linux y Git Bash sobre Windows.», como en
  `scripts/comparar-escenarios.sh:10` y `scripts/comparar-escenarios.sh:13`.
- El script declara `set -u` antes de la primera instrucción, como en
  `scripts/comparar-escenarios.sh:15`. Cada error se maneja con su propio `exit`.
- Códigos de salida: `0` si el script cumplió su objetivo, `1` si se ejecutó y la
  comprobación no pasa, `2` si algo impidió ejecutarlo (argumento no válido, herramienta
  faltante, error de compilación). Un código adicional se documenta en la cabecera y en la
  ayuda, como el `3` de `scripts/verificar-reporte.sh:13`.
- El script acepta `--ayuda`, `-h` y `--version`, y la versión vive en una constante
  `readonly VERSION_SCRIPT`, como en `scripts/comparar-escenarios.sh:17` y
  `scripts/comparar-escenarios.sh:82`.
- Los errores que impiden empezar (argumento no válido, herramienta faltante, compilación
  fallida) van a la salida de error con `>&2`, en español, y dicen qué falta o qué valor
  se esperaba. Ante una opción desconocida se imprime el error, luego la ayuda en la
  salida de error, y se sale con `2`, como en `scripts/comparar-escenarios.sh:91` a
  `scripts/comparar-escenarios.sh:93`.
- El informe de lo que el script comprobó va a la salida estándar, una línea por
  comprobación con la marca `[ OK ]`, `[FALLA]` o `[AVISO]`, como las funciones de
  `scripts/comparar-escenarios.sh:42` a `scripts/comparar-escenarios.sh:44`.
- La raíz del repositorio se calcula desde la ubicación del script, con
  `raiz="$(cd "$(dirname "$0")/.." && pwd)"`, como en `scripts/verificar-reporte.sh:21`.
  Así el script funciona sin importar desde dónde se invoque.
- Antes de usar una herramienta se comprueba con `command -v nombre >/dev/null 2>&1`.
  Si la herramienta cambia de nombre entre sistemas, se prueba la alternativa:
  `sha256sum` en Linux y Git Bash, `shasum -a 256` en macOS, como en
  `scripts/verificar-reporte.sh:49` a `scripts/verificar-reporte.sh:53`.
- Los directorios temporales se crean con `mktemp -d 2>/dev/null || mktemp -d -t nombre`,
  que funciona con el `mktemp` de GNU y con el de macOS, y se borran con `trap` al salir,
  como en `scripts/verificar-reporte.sh:75` y `scripts/verificar-reporte.sh:76`.
- Toda salida de un ejecutable nativo de Windows, todo archivo que se compare o se pase a
  un hash y toda respuesta leída con `read` pasa por `tr -d '\r'` antes de compararse. En
  Git Bash esos textos traen CRLF, como explican `scripts/verificar-ambiente.sh:244` y
  `scripts/reiniciar-lab.sh:216`.
- Si el script compara la salida de .NET con la de Java, en Git Bash cambia la consola a
  UTF-8 con `chcp.com 65001` y restaura la página original al salir, como en
  `scripts/comparar-escenarios.sh:160` a `scripts/comparar-escenarios.sh:173`.
- Los colores solo se usan si la salida es una terminal y `NO_COLOR` está vacía, como en
  `scripts/comparar-escenarios.sh:31`.
- Toda expansión de variable va entre comillas dobles: `"$ruta"`, no `$ruta`. Las rutas de
  Windows traen espacios.
- Las condiciones usan `[ ]`, igual que el resto de los scripts de `scripts/`.

## Qué no se hace nunca

- No se usa `sed -i`. Su sintaxis difiere entre GNU y macOS; la salida de `sed` se
  escribe en otro archivo.
- No se usan `readlink -f` ni `realpath`. La ruta absoluta se obtiene con `cd` y `pwd`.
- No se usan `declare -A`, `mapfile`, `readarray` ni `shopt -s globstar`. macOS trae bash
  3.2, que no los tiene.
- No se usan `grep -P`, `echo -e`, `date -d`, `stat -c` ni `seq`. No existen o se
  comportan distinto en macOS. Para texto con formato se usa `printf`.
- No se termina con un código distinto de los documentados en la cabecera.
- No se modifica `escenario/datos/`.

## Ejemplo

Un script nuevo que cumple las reglas:

```bash
#!/usr/bin/env bash
#
# Cuenta las lineas de la liquidacion de un periodo.
#
# Codigo de salida: 0 si pudo contarlas, 2 si el argumento no es valido o falta Java.
#
# Corre en macOS, Linux y Git Bash sobre Windows.

set -u

readonly VERSION_SCRIPT="1.0.0"

uso() {
    printf 'Uso: bash scripts/contar-lineas.sh AAAA-MM\n'
}

case "${1:-}" in
    --ayuda|-h) uso; exit 0 ;;
    --version)  echo "contar-lineas.sh $VERSION_SCRIPT"; exit 0 ;;
    "")         uso >&2; exit 2 ;;
esac

raiz="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v java >/dev/null 2>&1; then
    printf 'No encuentro java en el PATH.\n' >&2
    exit 2
fi

temporal=$(mktemp -d 2>/dev/null || mktemp -d -t contar-lineas)
trap 'rm -rf "$temporal"' EXIT

cd "$raiz/escenario/java" || exit 2
java -jar target/liquidacion-comercios.jar "$1" > "$temporal/salida.txt" 2>&1 || exit 2
printf '%s lineas\n' "$(tr -d '\r' < "$temporal/salida.txt" | wc -l | tr -d ' ')"
exit 0
```

En el repositorio, `scripts/verificar-reporte.sh` sigue el mismo patrón completo: cabecera
con códigos de salida en `scripts/verificar-reporte.sh:9`, `set -u` en
`scripts/verificar-reporte.sh:17`, ayuda y versión en `scripts/verificar-reporte.sh:57` y
`scripts/verificar-reporte.sh:58`, y errores a la salida de error con `exit 2` en
`scripts/verificar-reporte.sh:82` y `scripts/verificar-reporte.sh:83`.
