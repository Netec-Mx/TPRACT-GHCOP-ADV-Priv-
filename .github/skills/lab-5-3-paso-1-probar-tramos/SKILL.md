---
name: lab-5-3-paso-1-probar-tramos
description: 'Lab 5.3 paso 1. Crea pruebas de la selección de tramo de comisión, incluidos los bordes exactos.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Crear un archivo de pruebas nuevo que cubra la selección del tramo de comisión,
incluidos los montos que caen exactamente en el borde entre dos tramos.

Hoy esa lógica no tiene ninguna prueba.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

# Contexto

El código bajo prueba:

- Java: [CalculadoraComision.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraComision.java), [PlanComisiones.java](../../../escenario/java/src/main/java/pe/pasarelaandina/modelo/PlanComisiones.java), [TramoComision.java](../../../escenario/java/src/main/java/pe/pasarelaandina/modelo/TramoComision.java)
- .NET: [CalculadoraComision.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraComision.cs), [PlanComisiones.cs](../../../escenario/dotnet/LiquidacionComercios/Modelo/PlanComisiones.cs), [TramoComision.cs](../../../escenario/dotnet/LiquidacionComercios/Modelo/TramoComision.cs)

El estilo de pruebas que ya usa el proyecto, para que el archivo nuevo se parezca a los
que existen:

- Java: [ValidadorFormatoTest.java](../../../escenario/java/src/test/java/pe/pasarelaandina/util/ValidadorFormatoTest.java)
- .NET: [ValidadorFormatoPruebas.cs](../../../escenario/dotnet/LiquidacionComercios.Pruebas/Util/ValidadorFormatoPruebas.cs)

Los tramos reales con los que trabaja el sistema están en la primera línea de datos de
[planes.txt](../../../escenario/datos/planes.txt).

El plan `PL01` tiene estos tramos: de 0 a 500 al 3,5 %, de 500 a 2000 al 2,9 %, de 2000
a 10000 al 2,5 % y de 10000 en adelante al 2,1 %.

Las reglas de negocio que definen cuál es el comportamiento correcto están en [escenario/README.md](../../../escenario/README.md).

# Qué probar

Crea el archivo de pruebas de la calculadora de comisión:

- Java: `escenario/java/src/test/java/pe/pasarelaandina/calculo/CalculadoraComisionTest.java`,
  con pruebas de `determinarTramo`.
- .NET: `escenario/dotnet/LiquidacionComercios.Pruebas/Calculo/CalculadoraComisionPruebas.cs`,
  con pruebas de `DeterminarTramo`.

Como mínimo:

- Un monto en el interior de cada uno de los cuatro tramos.
- **Los montos que caen exactamente en el borde**: 500.00, 2000.00 y 10000.00.
- Un monto por debajo del primer tramo y uno por encima del último.
- Un plan sin tramos.

Cada prueba debe declarar en su nombre qué espera, en español, siguiendo el estilo de
las pruebas que ya existen.

# Contraste con el cierre de la liquidación

La selección de tramo no se usa solo en la calculadora de comisión. Antes de terminar,
busca en el método que calcula la liquidación mensual cómo elige el tramo para una
transacción:

- Java: [CalculadoraLiquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java)
- .NET: [CalculadoraLiquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs)

Para cada uno de los tres bordes, di en tu respuesta qué porcentaje aplica la calculadora
de comisión y qué porcentaje aplicaría el cierre de la liquidación al mismo monto. No
escribas pruebas de la liquidación en este paso.

# Restricciones

- **Crea un archivo nuevo. No modifiques ningún archivo existente**, ni de pruebas ni
  de producción.
- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Si al probar encuentras un comportamiento que no coincide con las reglas de negocio,
  o dos partes del sistema que no coinciden entre sí, **no lo arregles**. Documéntalo
  en tu respuesta y, si quieres, como comentario dentro del archivo de pruebas,
  indicando qué dicen las reglas de negocio.
- Las pruebas deben reflejar **lo que el código hace hoy**, no lo que debería hacer. Si
  algo te parece incorrecto, escribe la prueba que documenta el comportamiento actual y
  explica la discrepancia en tu respuesta.
- No agregues dependencias nuevas al proyecto de pruebas.

# Salida esperada

1. Un archivo nuevo en la ruta indicada, con el paquete o el espacio de nombres que
   corresponde al directorio.
2. Ningún archivo existente modificado.
3. Las pruebas corren y pasan. Java, desde `escenario/java/`: `mvn test`. .NET, desde
   `escenario/dotnet/`: `dotnet test LiquidacionComercios.Pruebas`. Deben ejecutarse
   las 20 pruebas que ya existían más las nuevas, todas en verde.
4. En tu respuesta, una tabla con los tres bordes, el porcentaje de la calculadora de
   comisión y el del cierre de la liquidación.
5. La explicación de cualquier discrepancia que hayas encontrado, con lo que dicen las
   reglas de negocio, o la aclaración de que las reglas no alcanzan para decidir, y **sin
   haberla corregido**.
