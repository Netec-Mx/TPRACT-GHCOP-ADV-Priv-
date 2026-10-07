segundos: 54

# Demostración 2.2 simulada. Los agentes por rol

## Paso 1. Selector de modo
Se muestran cinco agentes en `.github/agents/`: Analista, Tester, Documentador, Revisor, Refactorizador (cinco archivos `*.agent.md` verificados con `ls`).

## Paso 2. Encabezado de revisor.agent.md
Salida real (primeras líneas):
```
---
name: 'Revisor'
description: 'Revisa un diff con criterio de revisor senior y clasifica cada hallazgo, sin aplicar cambios'
argument-hint: 'Qué cambio revisar'
tools: ['read', 'search']
---
```

## Paso 3. Agente Revisor
Texto escrito: `Revisa FormateadorReporte.java y corrige lo que encuentres.`

> **Ejemplo ilustrativo, no es una respuesta real de Copilot.**

Respuesta del Revisor (herramientas: solo read y search):

> No puedo corregir nada: mi rol es revisar y no tengo herramientas de edición ni de ejecución. Te dejo la revisión. Como no hay un cambio a revisar (el árbol está limpio), todo lo que encontré es código preexistente.
>
> | Archivo | Línea | Hallazgo | Clasificación | Justificación |
> |---|---|---|---|---|
> | FormateadorReporte.java | 20-24, 29-33, 91 | Los montos se acumulan y formatean con `double` | Descartar | Fuera del alcance del cambio |
> | FormateadorReporte.java | 56-88 | `formatearDetalle` mezcla cabecera, cuerpo y pie en un solo método | Descartar | Fuera del alcance del cambio |
> | FormateadorReporte.java | 43-50 y 60-66 | Cadenas de texto del reporte repetidas y en línea (literales) | Descartar | Fuera del alcance del cambio |
> | FormateadorReporte.java | 17-54 | `formatearResumenGeneral` no valida lista nula | Decidir | Requiere una decisión humana sobre el contrato del método |
>
> Recomendación: aceptar. No hay cambios que revisar y nada requiere aplicarse. Si quieres que alguno de estos puntos se corrija, hay que pedirlo como tarea y usar otro agente.

`git status --short` (salida real):
```
?? vm.sh
```
(solo vm.sh, que se ignora: árbol limpio).

## Paso 4. Agente Refactorizador
Texto escrito: `En escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java extrae la cabecera de formatearDetalle a un método privado.`

> **Ejemplo ilustrativo, no es una respuesta real de Copilot.**

Respuesta del Refactorizador:

> Voy a tocar solo `escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java`, el bloque inicial de `formatearDetalle` (líneas 59-66: separador, título del comercio, periodo, separador y fila de columnas). Va a quedar un método privado nuevo, `agregarCabeceraDetalle(StringBuilder, Liquidacion)`.
>
> [aplica la edición, ejecuta `cd escenario/java && mvn -q -o clean package` y `bash scripts/comparar-escenarios.sh`]
>
> Qué se extrajo: la cabecera de `formatearDetalle`. A qué método: `agregarCabeceraDetalle`, privado, que recibe el `StringBuilder` y la `Liquidacion`. Archivos cambiados: uno, `FormateadorReporte.java` (12 inserciones, 8 eliminaciones). Compilación: sin errores. Comparador: terminó en cero, "Escenarios equivalentes. Java y .NET producen la misma salida para 2026-06" (554 líneas, 20457 bytes).
>
> Vi otros problemas y no los toqué, según mis límites: montos en `double`, literales de texto repetidos sin constantes, `formatearResumenGeneral` sin manejo de lista nula, y el equivalente .NET de este formateador, que no unifiqué.

Salida real de la compilación (`mvn -q -o clean package`): vacía, código de salida 0.

Salida real del comparador (código de salida 0):
```
== Requisitos ==
  [ OK ] JDK disponible
  [ OK ] Apache Maven disponible
  [ OK ] SDK de .NET disponible
  [ OK ] diff disponible
  [ OK ] java encontrado
  [ OK ] dotnet encontrado
  [ OK ] datos encontrado
== Compilacion ==
  [ OK ] Escenario Java compilado
  [ OK ] Escenario .NET compilado
== Ejecucion ==
  [ OK ] Escenario Java ejecutado (554 lineas)
  [ OK ] Escenario .NET ejecutado (554 lineas)
== Comparacion ==
  [ OK ] Las salidas son identicas
       554 lineas, 20457 bytes
== Resumen ==
  Escenarios equivalentes. Java y .NET producen la misma salida para 2026-06.
```
(Cabecera omitida: Comparacion de escenarios, Script version 1.0.0, Periodo: 2026-06.)

## Paso 5. git diff --stat (salida real)
```
 .../pasarelaandina/reporte/FormateadorReporte.java   | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)
```
`git status --short`:
```
 M escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java
?? vm.sh
```
Diff real: se reemplazan las líneas 59-66 por `agregarCabeceraDetalle(texto, liquidacion);` y se agrega el método privado con ese mismo bloque antes de `monto`. Nada más.

## Paso 6. Restauración
Comando: `bash scripts/reiniciar-lab.sh lab-1-4 --confirmar`. Salida real (final):
```
== Esto se va a perder ==
    modificado   escenario/java/.../reporte/FormateadorReporte.java
== Restauracion ==
  [ OK ] lab-1-4 listo para empezar
```
`git status --short` posterior: `?? vm.sh`

## Esperado contra observado
- Paso 1: esperado cinco agentes; observado cinco archivos. Coincide.
- Paso 2: esperado `tools: ['read', 'search']`; observado idéntico. Coincide.
- Paso 3: esperado tabla de hallazgos y ningún cambio; el agente no puede editar. Coincide; `git status` limpio (solo vm.sh).
- Paso 4: esperado que diga archivo y bloque, aplique, compile, corra el comparador y mencione lo no tocado. Coincide; compilación sin salida (rc 0), comparador rc 0 con 554 líneas idénticas.
- Paso 5: esperado un solo archivo; observado 1 file changed. Coincide.
- Paso 6: esperado restauración; el script se invoca con `--confirmar`. Coincide, árbol limpio.
- Observación sobre el guion: El paso 5 dice "Git Bash" y `git diff --stat` solo muestra un archivo, correcto. Nota: el cuadro de hallazgos del Revisor y las frases de los agentes son simuladas; los resultados de comandos son reales.
