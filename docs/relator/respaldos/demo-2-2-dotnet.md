> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes. Cada agente se eligió con `copilot --agent <nombre>`, que es lo que hace el
> selector de modo de Visual Studio Code. Los comandos de los pasos 5 y 6 se ejecutaron en Git
> Bash de la misma máquina. Es la versión .NET de la demostración: los pedidos son los del
> guion con el archivo `.cs` y el nombre del método en .NET.

# Demostración 2.2. Los agentes por rol (escenario .NET)

Los pasos 1 y 2 son iguales en los dos stacks: cinco agentes en `.github/agents/` y
`tools: ['read', 'search']` en el encabezado de `revisor.agent.md`. Ver
[demo-2-2.md](demo-2-2.md).

## Paso 3. Agente Revisor

Escrito: `Revisa FormateadorReporte.cs y corrige lo que encuentres.`

El Revisor buscó el archivo, primero en una ruta que no existe y después en
`escenario/dotnet/LiquidacionComercios/Reporte/`, y leyó `escenario/README.md`. No intentó
editar ni ejecutar nada. Respuesta:

> ## Revisión de `FormateadorReporte.cs`
>
> Hice solo la revisión y no apliqué cambios. Mi rol es de revisor y no edita archivos. Además, `escenario/` no se corrige salvo que la tarea nombre el defecto, y «corrige lo que encuentres» no nombra ninguno.
>
> | Archivo | Línea | Hallazgo | Clasificación | Justificación |
> |---|---|---|---|---|
> | FormateadorReporte.cs | 20-27 | Los acumuladores de montos son `double`, y las sumas pueden arrastrar error binario. | Decidir | Cambiar a `decimal` toca tipos de datos y redondeo (regla 9). Requiere aprobación explícita y debe mantener la equivalencia con Java. |
> | FormateadorReporte.cs | 37-50, 62-84 | Los literales de texto, los anchos de columna y `"\n"` están repetidos. | Descartar | Fuera del alcance del cambio. No se extraen literales por iniciativa. |
> | FormateadorReporte.cs | 53 | `FormatearDetalle` no valida `liquidacion` nulo ni `maximoLineas` negativo. | Descartar | Fuera del alcance del cambio. No se agrega manejo de errores por iniciativa. |
> | FormateadorReporte.cs | 100-103 | `Monto` delega en `CompatibilidadJava.FormatearDosDecimales`. | Descartar | Es una característica existente que mantiene la salida idéntica a Java. |
> | FormateadorReporte.cs | — | No vi errores de lógica ni contradicciones con las reglas de negocio en este archivo. | Descartar | El archivo solo formatea y no calcula comisiones. |
>
> **Recomendación:** aceptar, sin cambios. Si quieres corregir algo concreto, por ejemplo el tipo `double`, indícalo. Muestro qué regla toca y espero tu aprobación.

`git status --short`: vacío.

## Paso 4. Agente Refactorizador

Escrito: `En escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporte.cs extrae la cabecera de FormatearDetalle a un método privado.`

El Refactorizador leyó el archivo, hizo dos ediciones, buscó el `.csproj`, compiló con
`dotnet build` y corrió `scripts/comparar-escenarios.sh`. La sesión completa tardó algo más de
seis minutos. Respuesta:

> Extraje la cabecera de `FormatearDetalle` a un método privado nuevo, `AgregarCabeceraDetalle(StringBuilder texto, Liquidacion liquidacion)`. El proyecto compila sin advertencias ni errores, y `comparar-escenarios.sh` terminó en cero: las salidas de Java y .NET son idénticas (554 líneas).
>
> Solo cambió `escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporte.cs`. El método nuevo contiene el separador, el título `DETALLE DE …`, el periodo, otro separador y la fila de columnas. `FormatearDetalle` ahora lo llama antes del ciclo de líneas.
>
> ```diff
>          public string FormatearDetalle(Liquidacion liquidacion, int maximoLineas)
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
> ...
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
>          private string Monto(double valor)
> ```
>
> No hice commit. Si lo quieres, el mensaje propuesto es: `Extrae la cabecera de FormatearDetalle a AgregarCabeceraDetalle`.

No anunció el archivo y el bloque antes de tocarlos, y no listó otros problemas que vio y no
tocó.

## Paso 5. git diff --stat

```
 .../Reporte/FormateadorReporte.cs                     | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)
```

## Paso 6. Restauración

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

El `[AVISO]` sale por un commit de la grabación, con `scripts/integracion/stack.txt` en
`dotnet`. En clase no aparece.

`git status --short` posterior: vacío.

## Esperado contra observado

- Paso 3: esperado una tabla de hallazgos y ningún cambio. Observado igual, y además dice que
  su rol no edita. Algunos números de línea no coinciden con el archivo: `FormatearDetalle`
  está en la línea 60, no en la 53.
- Paso 4: esperado que diga archivo y bloque, aplique, compile, corra el comparador y mencione
  lo que no tocó. Observado: aplicó, compiló y corrió el comparador, pero no anunció el bloque
  antes ni listó lo que vio y no tocó. Tardó más de seis minutos: si pasa en clase, siga con
  la explicación y vuelva al resultado, o muestre este respaldo.
- Paso 5: esperado un solo archivo. Observado 1 file changed.
- Paso 6: esperado la restauración. Observado igual.
