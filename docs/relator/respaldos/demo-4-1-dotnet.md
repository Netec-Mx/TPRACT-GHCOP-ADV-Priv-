> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes. Se grabó en la CLI, no en Visual Studio Code: el modo Ask se reprodujo con una
> sesión sin permiso de edición, y el texto con `#file:` se envió tal cual. Es la versión .NET
> de la demostración: el pedido es el del guion con la ruta del archivo `.cs` y el nombre del
> método en .NET, y la ejecución del paso 2 usa `dotnet fsi` en lugar de `jshell`. Los comandos
> se ejecutaron en Git Bash de la misma máquina.

# Demo 4.1. La documentación contra la ejecución (escenario .NET)

Antes de empezar, compilar el escenario .NET:

```bash
dotnet build -c Release escenario/dotnet/LiquidacionComercios -v q --nologo
```

Termina con `0 Errores`.

## Paso 1

Escrito: `#file:escenario/dotnet/LiquidacionComercios/Calculo/UtilidadesFecha.cs Documenta en Markdown el método MesesEntre y da el resultado esperado para estos casos: del 2026-01-31 al 2026-02-28, del 2026-01-15 al 2026-02-15, del 2025-12-31 al 2026-06-01 y del 2026-03-10 al 2026-03-09.`

Copilot leyó `UtilidadesFecha.cs` y respondió:

> # `UtilidadesFecha.MesesEntre`
>
> **Firma:** `public int MesesEntre(DateTime desde, DateTime hasta)`
> **Archivo:** `escenario/dotnet/LiquidacionComercios/Calculo/UtilidadesFecha.cs`
>
> ## Qué hace
> Devuelve los meses completos transcurridos entre dos fechas.
>
> ## Algoritmo
> 1. Si `desde` o `hasta` es `DateTime.MinValue` (fecha no parseada), devuelve `0`.
> 2. Calcula `total = (hasta.Year - desde.Year) * 12 + (hasta.Month - desde.Month)`.
> 3. Si `hasta.Day < desde.Day`, resta 1, porque el último mes no se completó.
> 4. Devuelve `total`.
>
> ## Comportamiento a tener en cuenta
> - Solo compara el **día del mes**. Ignora la hora.
> - No ordena las fechas. Si `hasta` es anterior a `desde`, el resultado puede ser negativo.
> - No trata el fin de mes de forma especial. Un `desde` en día 31 nunca completa un mes frente a un mes más corto.
>
> ## Resultados esperados
>
> | # | Desde | Hasta | Cálculo | Resultado |
> |---|-------|-------|---------|-----------|
> | 1 | 2026-01-31 | 2026-02-28 | 0·12 + 1 = 1; día 28 < 31 → 1 − 1 | **0** |
> | 2 | 2026-01-15 | 2026-02-15 | 0·12 + 1 = 1; día 15 no es < 15 | **1** |
> | 3 | 2025-12-31 | 2026-06-01 | 1·12 + (6 − 12) = 6; día 1 < 31 → 6 − 1 | **5** |
> | 4 | 2026-03-10 | 2026-03-09 | 0·12 + 0 = 0; día 9 < 10 → 0 − 1 | **−1** |
>
> ## Observaciones
> - Caso 1: el 28 de febrero es el último día del mes, pero el método devuelve 0. Según el criterio de negocio, podría esperarse 1. No lo modifiqué porque no se pidió.
> - Caso 4: devuelve un valor negativo cuando las fechas están invertidas.
>
> Calculé los resultados a mano leyendo el código; no ejecuté nada. No creé ni modifiqué archivos.

## Paso 2

En Git Bash, con F# interactivo, que viene con el SDK de .NET:

```bash
printf '%s\n' '#r "escenario/dotnet/LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll";;' 'let u = Pe.PasarelaAndina.Calculo.UtilidadesFecha();;' 'for (a, b) in [ ("2026-01-31","2026-02-28"); ("2026-01-15","2026-02-15"); ("2025-12-31","2026-06-01"); ("2026-03-10","2026-03-09") ] do printfn "%s -> %s = %d" a b (u.MesesEntre(u.ParsearFecha a, u.ParsearFecha b));;' '#quit;;' | dotnet fsi --quiet
```

Salida, código de salida 0. A diferencia de `jshell`, no repite las líneas que recibe:

```
2026-01-31 -> 2026-02-28 = 0
2026-01-15 -> 2026-02-15 = 1
2025-12-31 -> 2026-06-01 = 5
2026-03-10 -> 2026-03-09 = -1
```

## Paso 3

Documento: 0, 1, 5 y -1. Ejecución: 0, 1, 5 y -1. Coinciden los cuatro.

## Esperado contra observado

- Paso 1: coincide. Una descripción del método y una tabla de cuatro resultados. Acertó los
  cuatro casos y dijo que no ejecutó nada, que es la pregunta que el guion propone hacer a la
  sala.
- Paso 2: 0, 1, 5 y -1, los mismos resultados que el escenario Java.
- Paso 3: no hay discrepancia.
