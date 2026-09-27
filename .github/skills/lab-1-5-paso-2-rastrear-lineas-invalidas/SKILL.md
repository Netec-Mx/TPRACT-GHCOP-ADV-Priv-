---
name: lab-1-5-paso-2-rastrear-lineas-invalidas
description: 'Lab 1.5 paso 2. Rastrea qué le pasa a una línea mal formada de los archivos de datos desde que se lee hasta la liquidación.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Saber qué le pasa a una línea mal formada de `escenario/datos/transacciones.txt`, por
ejemplo con un monto que no es número, desde que se lee hasta que se imprime la
liquidación.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

- Java: [CargadorDatos.java](../../../escenario/java/src/main/java/pe/pasarelaandina/repositorio/CargadorDatos.java) y [CalculadoraLiquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java)
- .NET: [CargadorDatos.cs](../../../escenario/dotnet/LiquidacionComercios/Repositorio/CargadorDatos.cs) y [CalculadoraLiquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs)

# Qué hacer

1. Sigue el camino de la lectura de cada archivo de datos.
2. Para cada punto donde la lectura o la conversión de un valor puede fallar, di qué
   hace el código cuando falla.
3. Di si el participante tiene alguna forma de enterarse, en la salida del programa, de
   que una línea no se procesó.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques ningún archivo, tampoco los de datos. Responde en el chat.
- No propongas correcciones. Este paso solo rastrea.

# Salida esperada

Una tabla con estas columnas:

| Archivo y línea | Qué puede fallar | Qué hace el código | Queda rastro en la salida |
|---|---|---|---|

Debajo, una respuesta de una línea a la pregunta: si mañana llega un archivo con diez
líneas corruptas, ¿cómo se entera el equipo?
