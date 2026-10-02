segundos: 45

# Demo 1.3 simulada

Nota: los pasos 1 a 3 son respuestas simuladas del chat (redactadas a partir del contenido de FormateadorReporte.java). Los pasos 4 y 5 son salidas reales de comandos ejecutados con `bash vm.sh`.

## Paso 1. Ask
Escrito: `#file:escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java ¿Qué partes de formatearDetalle se podrían separar en métodos sin cambiar la salida?`

Respuesta del chat (simulada):
En `formatearDetalle` se pueden separar, sin cambiar la salida:
1. La cabecera del detalle (líneas 59-66): separador, título con comercio y razón social, periodo, separador y fila de títulos de columnas.
2. El formateo de una línea de detalle (líneas 76-82): el `String.format` con los cinco campos.
3. El mensaje de truncamiento "... y N lineas mas" (líneas 71-73).
4. El separador final (línea 86), que es menor.
La cabecera es el candidato más claro porque no depende del bucle. Son cambios que no alteran el orden de los `append`.

Archivos cambiados: ninguno.

## Paso 2. /plan
Escrito: `/plan extraer la cabecera de formatearDetalle a un método privado sin cambiar la salida`

Respuesta (simulada; selector en Plan):
Plan:
1. Crear `private void agregarCabeceraDetalle(StringBuilder texto, Liquidacion liquidacion)` en `FormateadorReporte`, con las líneas 59-66 sin modificar su contenido ni orden.
2. En `formatearDetalle`, reemplazar ese bloque por la llamada `agregarCabeceraDetalle(texto, liquidacion);`.
3. No tocar `formatearResumenGeneral`, `monto` ni el bucle de líneas.
4. Validar: `git status` debe mostrar un solo archivo modificado y `bash scripts/comparar-escenarios.sh` debe informar que las salidas son idénticas.

Archivos cambiados: ninguno.

## Paso 3. Agent (Start Implementation)
Respuesta (simulada): "Apliqué el plan: extraje la cabecera a `agregarCabeceraDetalle` y `formatearDetalle` ahora la invoca. No toqué nada más."
Archivo modificado: escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java (editado de verdad).

Diff real (`bash vm.sh 'git diff'`):
```
@@ -56,14 +56,7 @@ public class FormateadorReporte {
     public String formatearDetalle(Liquidacion liquidacion, int maximoLineas) {
         StringBuilder texto = new StringBuilder();
 
-        texto.append(SEPARADOR).append("\n");
-        ... (8 lineas de cabecera)
+        agregarCabeceraDetalle(texto, liquidacion);
 
@@ -87,6 +80,17 @@
+    private void agregarCabeceraDetalle(StringBuilder texto, Liquidacion liquidacion) {
+        (las mismas 8 lineas)
+    }
+
```

## Paso 4. Validar (salida real)
`bash vm.sh 'git status'`:
```
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
	modified:   escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java

Untracked files:
	vm.sh
```
`bash vm.sh 'bash scripts/comparar-escenarios.sh'` (exit 0):
```
Comparacion de escenarios, taller de GitHub Copilot
Script version 1.0.0
Periodo: 2026-06
Repositorio: /repo

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

## Paso 5. Restaurar (salida real)
`bash vm.sh 'bash scripts/reiniciar-lab.sh lab-1-4 --si'` (exit 0):
```
== Punto de partida de lab-1-4 ==
  Referencia: punto-de-partida
  Rutas: escenario labs/cap1/lab-1-4-practica-guiada/entregables

== Esto se va a perder ==
  Cambios en archivos del repositorio, que vuelven a su version original:
    modificado   escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java

== Restauracion ==
  [ OK ] lab-1-4 listo para empezar
```
`bash vm.sh 'git status --short'`: `?? vm.sh` (solo el wrapper).

## Esperado contra observado
- Paso 1: esperado lista de candidatos con la cabecera; observado igual (simulado).
- Paso 2: esperado plan corto con paso de validación; observado igual (simulado).
- Paso 3: esperado un único archivo con un método privado nuevo; observado igual.
- Paso 4: esperado un archivo modificado y "Las salidas son identicas"; observado igual.
- Paso 5: esperado restauración; observado igual. El script pide `si` y se usó `--si`; el guion no menciona esa bandera.
