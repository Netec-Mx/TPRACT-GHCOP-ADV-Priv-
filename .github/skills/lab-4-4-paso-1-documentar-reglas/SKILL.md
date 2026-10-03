---
name: lab-4-4-paso-1-documentar-reglas
description: 'Lab 4.4 paso 1. Documenta cómo calcula la comisión el código, leyendo el código, y lo contrasta con las reglas de negocio declaradas.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Documentar en Markdown cómo calcula el sistema la comisión de una transacción y el
total de un comercio, **según lo que hace el código**.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

- Java: [CalculadoraComision.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraComision.java), [PlanComisiones.java](../../../escenario/java/src/main/java/pe/pasarelaandina/modelo/PlanComisiones.java), [CalculadoraLiquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java)
- .NET: [CalculadoraComision.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraComision.cs), [PlanComisiones.cs](../../../escenario/dotnet/LiquidacionComercios/Modelo/PlanComisiones.cs), [CalculadoraLiquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs)

# Qué hacer

1. Documenta el cálculo tal como lo ejecuta el código: selección del tramo, porcentaje,
   monto fijo, recargo por cuotas, tope mensual, contracargos y retención.
2. Crea `labs/cap4/lab-4-4-documentacion/entregables/calculo-de-comisiones.md`.
3. Al final del documento, agrega una sección «Contraste con las reglas declaradas» que
   compare lo documentado con [escenario/README.md](../../../escenario/README.md), regla por regla.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Crea un solo archivo. No modifiques código ni comentarios del código.
- Cada afirmación sobre el cálculo cita el archivo y la línea que la respalda.

# Salida esperada

El documento creado, mostrado completo en el chat, no un resumen. Si supera las 150 líneas,
muestra completa la sección «Contraste con las reglas declaradas» y la parte de selección
del tramo, y nombra el archivo para abrir el resto. Después, en tu respuesta, cuántas reglas
coinciden con el código y cuántas no.
