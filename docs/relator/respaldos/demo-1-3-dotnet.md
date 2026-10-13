> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes. Los comandos de los pasos 4 y 5 se ejecutaron en Git Bash de la misma máquina.
> Se grabó en la CLI, no en Visual Studio Code: el modo Ask se reprodujo con una sesión sin
> permiso de edición, y el texto con `#file:` se envió tal cual. Es la versión .NET de la
> demostración: los pedidos son los del guion con la ruta del archivo `.cs` y el nombre del
> método en .NET.

# Demo 1.3. Analizar, planear, implementar y validar (escenario .NET)

Una sola conversación para los pasos 1 a 3.

## Paso 1. Ask

Escrito: `#file:escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporte.cs ¿Qué partes de FormatearDetalle se podrían separar en métodos sin cambiar la salida?`

Copilot leyó el archivo y respondió:

> `FormatearDetalle` (líneas 60-96) tiene cuatro bloques que se pueden extraer a métodos privados sin cambiar la salida:
>
> 1. **Encabezado** (líneas 64-68): separador, `DETALLE DE <id> - <razón social>`, `Periodo` y separador. Método sugerido: `AgregarEncabezadoDetalle(texto, liquidacion)`.
> 2. **Fila de títulos** (líneas 69-70): el `string.Format` con `TRANSACCION`, `MONTO`, `COMISION`, `RECARGO` y `CUOTAS`. Método sugerido: `AgregarTitulosDetalle(texto)`.
> 3. **Una línea de detalle** (líneas 83-88): el `string.Format` con los montos formateados. Método sugerido: `FormatearLineaDetalle(linea)`. El formato `"  {0,-12} {1,12} {2,10} {3,10} {4,8}\n"` aparece dos veces, en los títulos y en la línea, así que las columnas se podrían compartir.
> 4. **Línea de truncado** (líneas 77-79): `... y N lineas mas`. Método sugerido: `AgregarResumenTruncado(texto, restantes)`.
>
> El cierre con separador (línea 94) es una sola línea y no justifica un método.
>
> Dos cuidados:
> - Hay que conservar `CultureInfo.InvariantCulture` y el `\n` explícito.
> - El cálculo `liquidacion.Detalle.Count - impresas` debe quedar igual.
>
> Esos cuatro bloques son un buen candidato para refactorizar. No cambié nada. Si lo pides, lo aplico y verifico con `bash scripts/comparar-escenarios.sh`.
>
> Fuera del alcance: `FormatearDetalle` no valida que `maximoLineas` sea negativo, y con un valor negativo imprime solo la línea de truncado. No lo toqué.

Archivos cambiados: ninguno.

## Paso 2. /plan

Escrito: `/plan extraer la cabecera de FormatearDetalle a un método privado sin cambiar la salida`

La sesión pasó a modo Plan. Copilot guardó el plan en la carpeta de la sesión, fuera del
repositorio, y respondió:

> Guardé el plan en `plan.md`, en la carpeta de sesión. No modifiqué nada del repositorio.
>
> **Plan:**
> 1. Guardar la salida de antes en una carpeta temporal fuera del repositorio.
> 2. Crear en `FormateadorReporte.cs` el método privado `AgregarCabeceraDetalle(StringBuilder, Liquidacion)`. Mueve tal cual el separador, `DETALLE DE …`, `Periodo`, el separador y la fila de títulos. Con `InvariantCulture` y `\n` intactos.
> 3. Verificar con `dotnet build`, `dotnet test` y `bash scripts/comparar-escenarios.sh`.
> 4. Mostrar el diff y proponer el commit, sin ejecutarlo.
>
> **Pregunta:** ¿la «cabecera» incluye la fila de títulos (`TRANSACCION`, `MONTO`, …)? Asumí que sí. Si solo quieres las cuatro líneas de identificación, la dejo en `FormatearDetalle`.
>
> El escenario Java no se toca.
>
> Dime si apruebas el plan o quieres cambios, y lo implemento.

El plan guardado:

```markdown
# Plan: extraer la cabecera de FormatearDetalle

## Problema
En `escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporte.cs`, `FormatearDetalle`
arma la cabecera en línea. Se extrae a un método privado sin cambiar la salida.

## Enfoque
- Nuevo método privado `AgregarCabeceraDetalle(StringBuilder texto, Liquidacion liquidacion)`,
  colocado después de `FormatearDetalle` y antes de `Monto`.
- Mueve tal cual, en el mismo orden: separador, `DETALLE DE <id> - <razón social>`,
  `Periodo <periodo>`, separador y la fila de títulos (`string.Format` con
  `CultureInfo.InvariantCulture`, `{0,-12} {1,12} {2,10} {3,10} {4,8}\n`).
- `FormatearDetalle` queda con: crear `StringBuilder`, llamar al método, bucle, separador final.
- Sin cambios en literales, tipos, nombres ni en el escenario Java.

## Todos
1. Guardar la salida de antes en un archivo temporal fuera del repositorio.
2. Extraer el método en el archivo .NET.
3. Verificar: `dotnet build LiquidacionComercios -c Release`, `dotnet test LiquidacionComercios.Pruebas`
   y `bash scripts/comparar-escenarios.sh` (debe terminar en cero).
4. Mostrar el diff y proponer el commit (no se ejecuta).

## Notas
- La fila de títulos se incluye en la cabecera; si prefieres solo las 4 líneas de identificación, avísame.
- Sin pruebas nuevas ni cambios en Java.
- Fuera del alcance: `maximoLineas` negativo no se valida.
```

Archivos cambiados: ninguno.

## Paso 3. Agent

Con la sesión en modo Agent, que es lo que hace **Start Implementation**, se escribió:
`Sí, la fila de títulos es parte de la cabecera. Implementa el plan.`

Copilot ejecutó el escenario .NET y guardó la salida de antes en la carpeta temporal, editó el
archivo dos veces, volvió a ejecutar, corrió `dotnet test` y el comparador. Todos los comandos
pidieron aprobación y se aprobaron. Respuesta:

> Extraje la cabecera de `FormatearDetalle` al método privado `AgregarCabeceraDetalle` y la salida no cambió.
>
> Lo comprobé así:
> - La salida del .NET antes y después del cambio es idéntica.
> - `dotnet test` pasó los 21 tests.
> - `bash scripts/comparar-escenarios.sh` terminó en cero: Java y .NET producen la misma salida, 554 líneas.
>
> Cambié solo `escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporte.cs`. El diff:
>
> ```diff
> @@ -61,13 +61,7 @@
>          {
>              StringBuilder texto = new StringBuilder();
>
> -            texto.Append(Separador).Append("\n");
> -            texto.Append("  DETALLE DE ").Append(liquidacion.IdComercio);
> -            texto.Append(" - ").Append(liquidacion.RazonSocial).Append("\n");
> -            texto.Append("  Periodo ").Append(liquidacion.Periodo).Append("\n");
> -            texto.Append(Separador).Append("\n");
> -            texto.Append(string.Format(CultureInfo.InvariantCulture, "  {0,-12} {1,12} {2,10} {3,10} {4,8}\n",
> -                    "TRANSACCION", "MONTO", "COMISION", "RECARGO", "CUOTAS"));
> +            AgregarCabeceraDetalle(texto, liquidacion);
>
>              int impresas = 0;
> @@ -92,6 +86,17 @@
> +        private void AgregarCabeceraDetalle(StringBuilder texto, Liquidacion liquidacion)
> +        {
> +            texto.Append(Separador).Append("\n");
> +            texto.Append("  DETALLE DE ").Append(liquidacion.IdComercio);
> +            texto.Append(" - ").Append(liquidacion.RazonSocial).Append("\n");
> +            texto.Append("  Periodo ").Append(liquidacion.Periodo).Append("\n");
> +            texto.Append(Separador).Append("\n");
> +            texto.Append(string.Format(CultureInfo.InvariantCulture, "  {0,-12} {1,12} {2,10} {3,10} {4,8}\n",
> +                    "TRANSACCION", "MONTO", "COMISION", "RECARGO", "CUOTAS"));
> +        }
> +
> ```
>
> La salida de antes (`antes-dotnet.txt`) y la de después (`despues-dotnet.txt`) quedaron en la carpeta temporal del sistema, fuera del repositorio.
>
> **Commit propuesto** (no lo ejecuté):
> `refactor(reporte): extraer la cabecera de FormatearDetalle a AgregarCabeceraDetalle`
>
> Fuera del alcance: `maximoLineas` negativo no se valida.

## Paso 4. Validar

`git status`:

```
On branch demos-dotnet
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporte.cs

no changes added to commit (use "git add" and/or "git commit -a")
```

La rama `demos-dotnet` es de la grabación. Tiene un commit con `scripts/integracion/stack.txt`
en `dotnet`. En clase la rama es `main`.

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
    modificado   escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporte.cs
  [AVISO] Hay commits posteriores al punto de partida. Siguen en el historial, pero estas rutas vuelven a la version original.

== Restauracion ==
  [ OK ] lab-1-4 listo para empezar
```

El `[AVISO]` sale por el commit de `stack.txt` de la grabación. En clase, sobre `main` sin
commits propios, no aparece.

`git status --short` posterior: vacío.

## Esperado contra observado

- Paso 1: esperado una lista de candidatos con la cabecera. Observado cuatro candidatos, con
  la cabecera dividida en encabezado y fila de títulos. Algunos números de línea están
  corridos en uno: la línea de detalle está en las 82 a 87, no en las 83 a 88.
- Paso 2: esperado un plan corto con paso de validación. Observado igual, con `dotnet build`,
  `dotnet test` y el comparador, y una pregunta sobre la fila de títulos.
- Paso 3: esperado un único archivo con un método privado nuevo. Observado igual.
- Paso 4: esperado un archivo modificado y «Las salidas son identicas». Observado igual.
- Paso 5: esperado la restauración. Observado igual.
