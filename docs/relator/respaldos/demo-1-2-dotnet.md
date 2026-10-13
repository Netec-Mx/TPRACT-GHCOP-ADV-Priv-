> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes. Se grabó en la CLI, no en Visual Studio Code. En la CLI el agente siempre
> tiene herramientas de búsqueda, así que en los cuatro pasos buscó por su cuenta. No hay una
> lista de referencias como la del chat: se indica qué archivos leyó. Es la versión .NET de la
> demostración, con las rutas de los archivos `.cs`.

# Demostración 1.2. Las referencias de contexto (escenario .NET)

Cuatro conversaciones nuevas, ningún archivo abierto.

## Paso 1 (conversación nueva, sin referencias)

Texto escrito:

```
¿Cómo se calcula la retención de garantía de un comercio en este sistema?
```

Archivos que leyó: búsqueda de `retenci|garant` en `escenario/`,
`escenario/java/.../calculo/CalculadoraLiquidacion.java` (líneas 222 a 252) y
`escenario/README.md` (líneas 44 a 56).

> La retención de garantía se calcula así, en `CalculadoraLiquidacion` (Java líneas 228-251; .NET líneas 227-249, equivalente):
>
> 1. Si el comercio no tiene fecha de afiliación, la retención es 0.
> 2. Se calculan los meses entre la fecha de afiliación y el inicio del periodo (`mesesEntre`).
> 3. Si son menos de 6 meses, la base es `totalTransado - totalComisiones - totalContracargos`.
> 4. Si esa base es mayor que 0, la retención es `base * 0.05`. Si no, es 0.
> 5. La retención se redondea a 2 decimales y se resta del monto neto: `neto = transado - comisiones - contracargos - retenciones`.
>
> **Regla de negocio (README, regla 7):** «menos de seis meses de afiliación → 5 % sobre el monto neto». El código coincide: la base es el transado menos comisiones y contracargos. Es el neto antes de la retención.
>
> No toqué nada.

## Paso 2 (conversación nueva, archivo equivocado)

Texto escrito:

```
#file:escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporte.cs ¿Cómo se calcula la retención de garantía de un comercio en este sistema?
```

Archivos que leyó: búsqueda de `retenci|garant` en `escenario/`,
`escenario/dotnet/.../Calculo/CalculadoraLiquidacion.cs` (líneas 220 a 256) y
`escenario/README.md` (líneas 40 a 60).

> `FormateadorReporte.cs` no calcula la retención. Solo suma `liquidacion.Retenciones` y muestra el total. El cálculo está en `Calculo\CalculadoraLiquidacion.cs`, líneas 227-249. El código Java hace lo mismo.
>
> **Cálculo:**
> 1. Si el comercio no tiene fecha de afiliación (`DateTime.MinValue`), la retención es 0.
> 2. Se calculan los meses entre la fecha de afiliación y el inicio del periodo con `MesesEntre`. Si son 6 o más, la retención es 0.
> 3. Si son menos de 6, la base es `totalTransado - totalComisiones - totalContracargos`.
> 4. Si la base es mayor que 0, la retención es `base * 0.05`. Si no, es 0.
> 5. La retención se redondea a dos decimales con `RedondearADosDecimales`.
> 6. En `Liquidacion.cs`, el monto neto resta la retención: `TotalTransado - TotalComisiones - TotalContracargos - Retenciones`.
>
> **Coincide con la regla 7 de `escenario/README.md`:** 5 % sobre el monto neto para comercios con menos de seis meses de afiliación. Un detalle: la base se calcula con los totales antes de redondear. Por eso el redondeo final puede diferir en un centavo si se calcula a mano con los totales ya redondeados.

## Paso 3 (conversación nueva, archivo correcto)

Texto escrito:

```
#file:escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs ¿Cómo se calcula la retención de garantía de un comercio en este sistema?
```

Archivos que leyó: `CalculadoraLiquidacion.cs` completo y `escenario/README.md`.

> La retención se calcula en `CalculadoraLiquidacion.cs`, dentro de `ProcesarLiquidacionCompleta`, una vez por comercio:
>
> 1. Si `FechaAfiliacion` es `DateTime.MinValue`, la retención es 0.
> 2. Se calcula `meses = MesesEntre(fechaAfiliacion, inicioPeriodo)`. Es la antigüedad al inicio del periodo.
> 3. Si `meses < 6`, se calcula la base: `baseRetencion = totalTransado - totalComisiones - totalContracargos`.
>    - `totalComisiones` ya incluye el tope mensual, si se aplicó.
> 4. Si la base es mayor que 0, `retenciones = baseRetencion * 0.05`. Si es 0 o negativa, la retención es 0.
> 5. Se redondea con `CompatibilidadJava.RedondearADosDecimales` y se guarda en `liquidacion.Retenciones`. Luego entra al cálculo del monto neto.
>
> **Coincidencia con las reglas:** la regla 7 de `escenario/README.md` dice «5 % sobre el monto neto». El código usa transado menos comisiones menos contracargos, que es esa misma base antes de restar la retención. No veo discrepancia. No toqué nada.

## Paso 4 (conversación nueva, repositorio completo)

Texto escrito:

```
#codebase ¿Cómo se calcula la retención de garantía de un comercio en este sistema?
```

Archivos que leyó: búsqueda de `garant|retenci` en `escenario/`,
`escenario/java/.../calculo/CalculadoraLiquidacion.java` (líneas 222 a 256) y
`escenario/README.md`.

> La retención de garantía se calcula en `CalculadoraLiquidacion` (Java, líneas ~227-247; .NET, líneas ~227-249, con la misma lógica):
>
> 1. Se parte de `retenciones = 0`.
> 2. Si el comercio tiene `fechaAfiliacion`, se calculan los meses entre esa fecha y el **inicio del periodo** (`mesesEntre(fechaAfiliacion, inicioPeriodo)`).
> 3. Si `meses < 6`, la base es `totalTransado - totalComisiones - totalContracargos`.
> 4. Si la base es positiva, `retenciones = base * 0.05`.
> 5. Se redondea a 2 decimales (`Math.round(x*100.0)/100.0`).
> 6. `Liquidacion.montoNeto = totalTransado - totalComisiones - totalContracargos - retenciones`.
>
> Regla 7 de `escenario/README.md`: «5 % sobre el monto neto». Coincide en esencia: la base es el neto antes de retención, calculada con los totales ya acumulados pero sin redondear.
>
> Observaciones, sin cambiar nada:
> - Sin `fechaAfiliacion`, no hay retención.
> - La base usa montos sin redondear; solo se redondea el resultado final.

## Esperado contra observado

- Paso 1: el guion espera una respuesta genérica o una búsqueda propia. Observado la búsqueda
  propia, que encontró la regla en el código Java aunque la pregunta era para un participante
  .NET. Es el caso que el guion prevé: pregunte si pasaría igual en un repositorio de mil
  clases.
- Paso 2: coincide. Dice que ese archivo solo suma la retención ya calculada. Después buscó
  la clase correcta por su cuenta.
- Paso 3: coincide. Condición de antigüedad, base, 5 % y redondeo. No cita números de línea,
  cita el método.
- Paso 4: coincide. Encuentra la clase y el README, y responde con el código Java.
- En la CLI los cuatro pasos tardaron lo mismo, entre 12 y 14 segundos, porque el agente
  busca siempre. La diferencia que muestra la demostración se ve en qué archivos leyó cada
  conversación, no en la demora.
