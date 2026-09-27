---
name: lab-5-1-paso-3-inventario-de-riesgos
description: 'Lab 5.1 paso 3. Contrasta cada regla de negocio con el código y produce un inventario priorizado de riesgos, sin corregir nada.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Saber, regla por regla, si el sistema cumple lo que el negocio declara, y producir un
inventario priorizado de problemas.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

- Reglas: [escenario/README.md](../../../escenario/README.md)
- Java: [CalculadoraLiquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java), [CalculadoraComision.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraComision.java), [UtilidadesFecha.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/UtilidadesFecha.java)
- .NET: [CalculadoraLiquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs), [CalculadoraComision.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraComision.cs), [UtilidadesFecha.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/UtilidadesFecha.cs)

# Qué hacer

1. Para cada una de las nueve reglas de negocio, di dónde se implementa, si se cumple y
   bajo qué condiciones podría dejar de cumplirse. Considera también el entorno donde
   corre el programa y la aritmética con que se calculan los montos.
2. Para la regla 9, calcula con aritmética decimal exacta el total de comisiones de al
   menos un comercio del periodo 2026-06 y compáralo con lo que imprime el programa.
3. Con lo encontrado, arma un inventario de problemas priorizado por impacto en el
   dinero del comercio y por esfuerzo de corrección.

Crea `labs/cap5/lab-5-1-preparacion/entregables/inventario-de-riesgos.md`.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Crea un solo archivo. **No corrijas ninguno de los problemas que encuentres.**
- Cada hallazgo cita archivo y línea.

# Salida esperada

Una tabla de las nueve reglas y la tabla del inventario:

| Problema | Ubicación | Regla afectada | Impacto | Esfuerzo | Prioridad |
|---|---|---|---|---|---|
