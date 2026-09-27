---
name: lab-1-5-paso-4-proponer-mejora
description: 'Lab 1.5 paso 4. Propone una única mejora acotada al método de cálculo, con justificación y riesgo, sin aplicarla.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Proponer **una** mejora acotada al método que calcula la liquidación, que un revisor
pueda aprobar en diez minutos.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

- Java: [CalculadoraLiquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java)
- .NET: [CalculadoraLiquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs)

Las reglas de negocio están en [escenario/README.md](../../../escenario/README.md).

# Condiciones de la mejora

- Afecta un solo bloque del método, de no más de cuarenta líneas.
- No cambia la salida del programa.
- Se puede verificar con `bash scripts/comparar-escenarios.sh`.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No apliques la mejora ni modifiques ningún archivo. Responde en el chat.
- Una sola propuesta. Si ves otras, lístalas al final en una línea cada una.

# Salida esperada

1. Qué bloque, con su rango de líneas.
2. Qué cambio, en tres oraciones como máximo.
3. Por qué ese y no otro.
4. Qué podría salir mal y cómo se detectaría.
