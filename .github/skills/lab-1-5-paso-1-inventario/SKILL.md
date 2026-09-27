---
name: lab-1-5-paso-1-inventario
description: 'Lab 1.5 paso 1. Inventario de las responsabilidades del método de cálculo de la liquidación, en una tabla.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Inventariar todo lo que hace el método que calcula la liquidación mensual.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

- Java: [CalculadoraLiquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java), método `procesarLiquidacionCompleta`
- .NET: [CalculadoraLiquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs), método `ProcesarLiquidacionCompleta`

# Qué hacer

Recorre el método de principio a fin y separa cada responsabilidad distinta que cumple.
Una responsabilidad es una razón de cambio: leer datos, decidir, calcular, formatear,
imprimir, acumular estadísticas y cualquier otra que encuentres.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques ningún archivo. Responde en el chat.
- No propongas soluciones todavía. Este paso solo inventaría.

# Salida esperada

Una tabla con estas columnas:

| Responsabilidad | Líneas | Qué datos usa | Qué efecto tiene fuera del método |
|---|---|---|---|

Debajo, la cantidad total de responsabilidades y la cantidad de niveles de anidamiento en
el punto más profundo del método.
