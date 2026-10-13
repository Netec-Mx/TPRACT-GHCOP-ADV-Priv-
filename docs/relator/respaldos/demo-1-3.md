> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes. Los comandos de los pasos 4 y 5 se ejecutaron en Git Bash de la misma máquina.
> Se grabó en la CLI, no en Visual Studio Code: el modo Ask se reprodujo con una sesión sin
> permiso de edición, y el texto con `#file:` se envió tal cual.

# Demo 1.3. Analizar, planear, implementar y validar (escenario Java)

Una sola conversación para los pasos 1 a 3.

## Paso 1. Ask

Escrito: `#file:escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java ¿Qué partes de formatearDetalle se podrían separar en métodos sin cambiar la salida?`

Copilot leyó `FormateadorReporte.java` y respondió:

> Se podrían separar cuatro partes de `formatearDetalle`, sin cambiar la salida:
>
> 1. **Encabezado** (líneas del separador, `DETALLE DE …`, `Periodo …`, separador): `agregarEncabezadoDetalle(StringBuilder, Liquidacion)`.
> 2. **Fila de títulos de columnas** (el `String.format` con `TRANSACCION`, `MONTO`, …): `agregarTitulosColumnas(StringBuilder)`.
> 3. **Una línea de detalle** (el `String.format` con los cinco campos): `formatearLineaDetalle(DetalleLiquidacion)` devuelve el `String`.
> 4. **Bucle con el tope de líneas** (incluida la línea `... y N lineas mas`): `agregarLineas(StringBuilder, Liquidacion, int)`.
>
> Para conservar la salida:
> - Mantén `REGION_DE_SALIDA` en cada `String.format`.
> - Mantén los formatos `%-12s %12s %10s %10s %8s%n` y `%8d%n` tal como están.
> - Mantén `monto(...)` y el cálculo `size() - impresas`.
> - El `break` pasa a ser un `return` dentro del método extraído, con el mismo efecto.
>
> Fuera de `formatearDetalle`, el separador y el `String.format` con la región se repiten en `formatearResumenGeneral`. No los he tocado, porque la unificación no está pedida.
>
> No modifiqué ningún archivo. Si quieres, aplico la extracción y verifico con `bash scripts/comparar-escenarios.sh`.

Archivos cambiados: ninguno.

## Paso 2. /plan

Escrito: `/plan extraer la cabecera de formatearDetalle a un método privado sin cambiar la salida`

La sesión pasó a modo Plan. Copilot guardó el plan en la carpeta de la sesión, fuera del
repositorio, y respondió:

> Guardé el plan en la carpeta de sesión (`plan.md`). Todavía no cambié nada en el repositorio.
>
> **Enfoque:** agregar `agregarCabeceraDetalle(StringBuilder, Liquidacion)` en `FormateadorReporte.java`. Incluye el separador, `DETALLE DE …`, `Periodo …`, el separador y la fila de títulos de columnas, con las mismas instrucciones y en el mismo orden. `formatearDetalle` lo llama al inicio.
>
> **Pasos:**
> 1. Guardar la salida de antes en la carpeta temporal del sistema.
> 2. Extraer el método, solo en ese archivo.
> 3. Ejecutar `bash scripts/comparar-escenarios.sh` y comparar con la salida guardada.
>
> **Pregunta:** ¿la fila de títulos de columnas (`TRANSACCION`, `MONTO`, …) forma parte de la cabecera? Asumí que sí. Si prefieres dejarla en `formatearDetalle`, lo ajusto.
>
> Dime "implementa" y empiezo.

El plan guardado:

```markdown
# Plan: extraer la cabecera de `formatearDetalle`

## Problema
En `escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java`, `formatearDetalle` arma la cabecera en línea. Se extrae a un método privado sin cambiar la salida.

## Enfoque
Nuevo método privado `agregarCabeceraDetalle(StringBuilder texto, Liquidacion liquidacion)` con exactamente estas instrucciones, en el mismo orden:
- separador
- `  DETALLE DE <idComercio> - <razonSocial>`
- `  Periodo <periodo>`
- separador
- fila de títulos (`String.format` con `REGION_DE_SALIDA` y `%-12s %12s %10s %10s %8s%n`)

`formatearDetalle` lo invoca tras crear el `StringBuilder`. Con "cabecera" se entiende hasta la fila de títulos de columnas (decisión por confirmar, ver notas).

## Todos
1. Guardar la salida de antes en la carpeta temporal del sistema (fuera del repositorio).
2. Extraer el método en `FormateadorReporte.java` (solo ese archivo).
3. Verificar con `bash scripts/comparar-escenarios.sh` (debe terminar en cero) y comparar con la salida de antes.

## Notas
- No se tocan `formatearResumenGeneral`, `monto`, constantes, pruebas ni el escenario .NET.
- No se usa git stash/reset/checkout/restore.
- No se hace commit; se propone el mensaje al final.
- Pregunta abierta: ¿la fila de títulos de columnas entra en la cabecera? Se asume que sí. Si no, queda en `formatearDetalle`.
```

Archivos cambiados: ninguno.

## Paso 3. Agent

Primero se respondió la pregunta sin salir del modo Plan: `Sí, la fila de títulos es parte de
la cabecera. Implementa el plan.` El modo Plan no dejó ejecutar el comparador, porque compila
y escribe en `target\`, y Copilot pidió salir de ese modo:

> El modo plan bloqueó la ejecución. El script compila y escribe en `target\`, y eso modifica archivos fuera de la carpeta de sesión. No hice ningún cambio en el repositorio.
>
> El plan ya está guardado y los todos están en SQL. Para que lo implemente, sal del modo plan con Shift+Tab y escribe "implementa".

Es el paso que en Visual Studio Code hace **Start Implementation**. Con la sesión en modo
Agent se escribió `Implementa el plan.` Copilot ejecutó el comparador antes del cambio, guardó
la salida de Java en la carpeta temporal, editó el archivo dos veces (quitar el bloque y
agregar el método) y volvió a comparar. Todos los comandos pidieron aprobación y se aprobaron.
Respuesta:

> Listo. La cabecera de `formatearDetalle` ahora está en un método privado y la salida no cambió.
>
> Verificación:
> - `bash scripts/comparar-escenarios.sh` terminó en 0.
> - La salida de antes y la de después son idénticas byte a byte (554 líneas).
> - Solo cambió `FormateadorReporte.java`.
>
> Diff:
>
> ```diff
>      public String formatearDetalle(Liquidacion liquidacion, int maximoLineas) {
>          StringBuilder texto = new StringBuilder();
>
> -        texto.append(SEPARADOR).append("\n");
> -        texto.append("  DETALLE DE ").append(liquidacion.getIdComercio());
> -        texto.append(" - ").append(liquidacion.getRazonSocial()).append("\n");
> -        texto.append("  Periodo ").append(liquidacion.getPeriodo()).append("\n");
> -        texto.append(SEPARADOR).append("\n");
> -        texto.append(String.format(ConfiguracionRegional.REGION_DE_SALIDA,
> -                "  %-12s %12s %10s %10s %8s%n",
> -                "TRANSACCION", "MONTO", "COMISION", "RECARGO", "CUOTAS"));
> +        agregarCabeceraDetalle(texto, liquidacion);
>
>          int impresas = 0;
> @@
> +    private void agregarCabeceraDetalle(StringBuilder texto, Liquidacion liquidacion) {
> +        texto.append(SEPARADOR).append("\n");
> +        texto.append("  DETALLE DE ").append(liquidacion.getIdComercio());
> +        texto.append(" - ").append(liquidacion.getRazonSocial()).append("\n");
> +        texto.append("  Periodo ").append(liquidacion.getPeriodo()).append("\n");
> +        texto.append(SEPARADOR).append("\n");
> +        texto.append(String.format(ConfiguracionRegional.REGION_DE_SALIDA,
> +                "  %-12s %12s %10s %10s %8s%n",
> +                "TRANSACCION", "MONTO", "COMISION", "RECARGO", "CUOTAS"));
> +    }
> +
>      private String monto(double valor) {
> ```
>
> Dejé `salida-antes.txt` y `salida-despues.txt` en `%TEMP%`, fuera del repositorio. El script de comparación recompiló Java y .NET, así que `target\` del escenario Java cambió. `git status` solo muestra `FormateadorReporte.java`.
>
> Commit propuesto (no lo ejecuté):
>
> ```
> Extrae la cabecera de formatearDetalle a un método privado
>
> Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
> ```

## Paso 4. Validar

`git status`:

```
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java

no changes added to commit (use "git add" and/or "git commit -a")
```

`bash scripts/comparar-escenarios.sh`, código de salida 0:

```
Comparacion de escenarios, taller de GitHub Copilot
Script version 1.1.0
Periodo: 2026-06
Repositorio: /c/Users/taller/taller/github-copilot-netec-taller

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

## Paso 5. Restaurar

`bash scripts/reiniciar-lab.sh lab-1-4 --confirmar`, código de salida 0:

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

`git status --short` posterior: vacío.

## Esperado contra observado

- Paso 1: esperado una lista de candidatos con la cabecera. Observado cuatro candidatos; la
  cabecera aparece dividida en encabezado y fila de títulos.
- Paso 2: esperado un plan corto con paso de validación. Observado igual, con el comparador
  como validación y una pregunta sobre la fila de títulos.
- Paso 3: esperado un único archivo con un método privado nuevo. Observado igual. Desde el
  modo Plan no implementa: hay que pasar a Agent, que es lo que hace **Start Implementation**.
- Paso 4: esperado un archivo modificado y «Las salidas son identicas». Observado igual.
- Paso 5: esperado la restauración. Observado igual.
