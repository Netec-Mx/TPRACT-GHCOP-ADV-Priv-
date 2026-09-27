---
name: lab-1-4-paso-3-agregar-restricciones
description: 'Lab 1.4 paso 3. El pedido del paso 2 con restricciones y una forma de salida fija, para obtener respuestas comparables.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Identificar las tres mejoras de mayor impacto en la legibilidad del método que calcula la
liquidación mensual, para decidir por dónde empezar una refactorización.

# Alcance

Solo el método `procesarLiquidacionCompleta` (Java) o `ProcesarLiquidacionCompleta`
(.NET), en el escenario que indique el participante.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

- Java: [CalculadoraLiquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java)
- .NET: [CalculadoraLiquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs)

Las reglas de negocio que el método debe seguir cumpliendo están en [escenario/README.md](../../../escenario/README.md).

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques ningún archivo. Responde en el chat.
- Cada mejora debe poder aplicarse sin cambiar la salida del programa.
- Nada de cambios de tipos de datos, de bibliotecas ni de arquitectura.
- Cita el rango de líneas exacto de cada mejora.

# Salida esperada

Una tabla de tres filas, ordenada por impacto, con estas columnas y nada más antes ni
después de ella:

| Mejora | Líneas | Por qué mejora la legibilidad | Riesgo de cambiar la salida |
|---|---|---|---|
