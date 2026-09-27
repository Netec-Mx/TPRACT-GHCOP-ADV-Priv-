---
name: lab-5-2-paso-1-plan-incremental
description: 'Lab 5.2 paso 1. Plan de refactorización del método de cálculo en incrementos validables, sin tocar código.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Planear la refactorización del método que calcula la liquidación en incrementos
pequeños, cada uno con su forma de validación.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

- Java: [CalculadoraLiquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java) y [CalculadoraComision.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraComision.java)
- .NET: [CalculadoraLiquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs) y [CalculadoraComision.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraComision.cs)

# Qué hacer

1. Antes de planear, lista cada valor de negocio que aparece como literal numérico en
   las dos clases de cálculo: recargo por cuota, máximo del recargo, retención,
   antigüedad para la retención y cualquier otro. Para cada uno, en qué archivo y línea
   aparece y qué regla de [escenario/README.md](../../../escenario/README.md) lo define.
2. Propón entre tres y cinco incrementos, en orden. Cada uno:
   - Qué bloque se extrae o se mueve.
   - Qué debe seguir igual.
   - Cómo se valida, con el comando concreto.
3. Señala qué incremento conviene no hacer todavía y por qué.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques ningún archivo. Responde en el chat.
- Nada de cambios de tipos de datos. Cambiarían la salida y rompería la comparación
  entre escenarios.

# Salida esperada

La tabla de valores de negocio, la tabla de incrementos y la advertencia del punto 3.
