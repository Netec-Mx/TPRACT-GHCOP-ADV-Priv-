---
name: lab-1-5-paso-5-extraer-retencion
description: 'Lab 1.5 paso 5. Extrae a un método propio el cálculo de la retención de garantía, sin cambiar el comportamiento.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Extraer a un método privado el cálculo de la retención de garantía, que hoy está en
línea dentro del método que calcula la liquidación, **sin cambiar el comportamiento del
programa**.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

El archivo a modificar es el único que debes editar:

- Java: [CalculadoraLiquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java)
- .NET: [CalculadoraLiquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs)

La regla que el cálculo debe seguir cumpliendo es la 7 de [escenario/README.md](../../../escenario/README.md).

# Qué extraer, exactamente

El bloque que empieza en la declaración `double retenciones = 0.0;` y termina donde se
cierra la condición sobre la fecha de afiliación, justo antes de las líneas que
redondean los totales.

Extráelo a un método privado de la misma clase, con nombre en español, que reciba el
comercio, el inicio del periodo y los tres totales que usa el bloque (transado,
comisiones y contracargos), y **devuelva el monto de la retención**. En el método de
cálculo debe quedar la declaración de `retenciones` asignada con la llamada al método
nuevo.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- **No cambies el comportamiento.** La salida del programa debe ser idéntica, hasta el
  último centavo, antes y después.
- **Modifica un solo archivo**, el del escenario indicado.
- No cambies tipos de datos, no extraigas literales a constantes, no renombres métodos
  ni variables existentes y no agregues manejo de errores.
- No toques nada fuera del bloque indicado, salvo la llamada al método nuevo.

# Salida esperada

1. Un método privado nuevo que devuelve la retención.
2. El método de cálculo con la llamada en lugar del bloque.
3. El proyecto compila. Java, desde `escenario/java/`: `mvn -q clean package`. .NET,
   desde `escenario/dotnet/`: `dotnet build LiquidacionComercios -c Release`.
4. Desde la raíz del repositorio, `bash scripts/comparar-escenarios.sh` termina en cero.
5. En tu respuesta, los otros problemas que hayas visto y no hayas tocado.
6. Al terminar, muestra en el chat el diff completo de lo que cambió, con `git diff`, no un
   resumen. El participante revisa ahí que solo cambió el bloque indicado.
