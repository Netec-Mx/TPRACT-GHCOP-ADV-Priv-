---
name: lab-5-2-paso-3-extraer-desglose-medios
description: 'Lab 5.2 paso 3. Extrae a un método el cálculo y la impresión del desglose por medio de pago, sin cambiar el comportamiento.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Extraer a un método privado el desglose de montos por medio de pago, **sin cambiar el
comportamiento del programa**. Es otra zona del mismo método que el paso 2, así que
funciona igual si ese paso no se hizo.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

El archivo a modificar es el único que debes editar:

- Java: [CalculadoraLiquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java)
- .NET: [CalculadoraLiquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs)

# Qué extraer, exactamente

Hoy el desglose está repartido en dos lugares del método de cierre:

1. **El cálculo.** El bloque que empieza en `double montoCredito = 0.0;` y termina donde
   se cierra el recorrido del detalle de la liquidación que suma los montos por medio
   de pago.
2. **La impresión.** Dentro de la condición `cantidadTransacciones > 0`, el bloque que
   imprime «Desglose por medio de pago» y las líneas de cada medio.

Crea un método privado que reciba la liquidación, calcule los montos por medio de pago
a partir de su detalle e imprima el desglose exactamente como hoy. Borra el bloque de
cálculo y reemplaza el bloque de impresión por la llamada al método nuevo.

Mover el cálculo al lugar de la impresión no cambia el resultado, porque el detalle de
la liquidación no se modifica entre los dos puntos. Compruébalo antes de hacerlo.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- **No cambies el comportamiento.** La salida del programa debe ser idéntica, carácter
  por carácter.
- **Modifica un solo archivo.**
- No cambies tipos de datos, no extraigas literales a constantes, no renombres métodos
  ni variables existentes y no agregues manejo de errores.
- No toques nada fuera de los dos bloques indicados, salvo la llamada al método nuevo.

# Salida esperada

1. Un método privado nuevo que calcula e imprime el desglose.
2. El método de cierre sin el bloque de cálculo y con la llamada donde estaba la
   impresión.
3. El proyecto compila. Java, desde `escenario/java/`: `mvn -q clean package`. .NET,
   desde `escenario/dotnet/`: `dotnet build LiquidacionComercios -c Release`.
4. Desde la raíz del repositorio, `bash scripts/comparar-escenarios.sh` termina en cero.
5. En tu respuesta, los otros problemas que hayas visto y no hayas tocado.
