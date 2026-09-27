---
name: lab-5-2-paso-2-extraer-comision
description: 'Lab 5.2 paso 2. Extrae a un método el cálculo de comisión de una transacción, sin cambiar el comportamiento.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Extraer a un método privado el bloque que calcula la comisión de una transacción, que
hoy está en línea dentro del método de cierre, **sin cambiar el comportamiento del
programa**.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

# Contexto

El archivo a modificar es el único de esta lista que debes editar:

- Java: [CalculadoraLiquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java)
- .NET: [CalculadoraLiquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs)

Estos archivos son solo de consulta. Léelos si los necesitas, pero no los modifiques:

- Java: [PlanComisiones.java](../../../escenario/java/src/main/java/pe/pasarelaandina/modelo/PlanComisiones.java), [TramoComision.java](../../../escenario/java/src/main/java/pe/pasarelaandina/modelo/TramoComision.java), [Transaccion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/modelo/Transaccion.java), [DetalleLiquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/modelo/DetalleLiquidacion.java)
- .NET: [PlanComisiones.cs](../../../escenario/dotnet/LiquidacionComercios/Modelo/PlanComisiones.cs), [TramoComision.cs](../../../escenario/dotnet/LiquidacionComercios/Modelo/TramoComision.cs), [Transaccion.cs](../../../escenario/dotnet/LiquidacionComercios/Modelo/Transaccion.cs), [DetalleLiquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Modelo/DetalleLiquidacion.cs)

Las reglas de negocio que el cálculo debe seguir cumpliendo están en [escenario/README.md](../../../escenario/README.md).

# Qué extraer, exactamente

Dentro del método de cierre (`procesarLiquidacionCompleta` en Java,
`ProcesarLiquidacionCompleta` en .NET), el bloque que empieza en la declaración de
`double montoTransaccion` y termina en la línea que agrega el detalle a la liquidación
(`liquidacion.agregarDetalle(linea);` en Java, `liquidacion.AgregarDetalle(linea);` en
.NET).

Ese bloque hace cuatro cosas: busca el tramo que corresponde al monto, aplica el
porcentaje más el monto fijo del plan, suma el recargo por cuotas, y arma con todo eso
la línea de detalle de la liquidación.

Extráelo a un método privado de la misma clase que reciba el plan y la transacción y
**devuelva el detalle de liquidación ya construido**. En el método de cierre debe
quedar la llamada al método nuevo seguida de la línea que agrega el detalle.

**Cuidado con las variables intermedias.** El código que viene después del bloque usa
`montoTransaccion` y `comisionTotal` para ir acumulando los totales del comercio. Al
extraer el bloque, esas variables dejan de existir en el método de cierre, así que esas
líneas tienen que pasar a leer los valores desde el detalle que devuelve el método nuevo
(`linea.getMontoTransaccion()` y `linea.getComisionTotal()` en Java,
`linea.MontoTransaccion` y `linea.ComisionTotal` en .NET).

Si extraes solo hasta el cálculo de la comisión y dejas fuera la construcción del
detalle, **el código no compila**, porque `comisionBase` y `recargo` se siguen usando
más abajo.

# Restricciones

Son la parte más importante de este paso. Un cambio que las viole no sirve aunque el
código quede más ordenado.

- **No cambies el comportamiento.** Este paso es una refactorización. La salida del
  programa debe ser idéntica, hasta el último centavo, antes y después.
- **Modifica un solo archivo**, el que se indica arriba.
- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
  En particular, y sin que esta lista sea exhaustiva:
  - **No** cambies `double` por otro tipo.
  - **No** extraigas los números literales a constantes.
  - **No** unifiques valores ni lógica con otras clases.
  - **No** renombres métodos ni variables existentes.
  - **No** agregues manejo de errores donde hoy no lo hay.
  - **No** toques nada fuera del bloque indicado.

# Salida esperada

1. Un método privado nuevo en la clase de cálculo de la liquidación, con nombre en
   español, que recibe el plan y la transacción y devuelve el detalle.
2. El método de cierre más corto, con la llamada al método nuevo donde antes estaba el
   bloque, y los acumuladores leyendo del detalle devuelto.
3. El proyecto compila. Java, desde `escenario/java/`: `mvn -q clean package`. .NET,
   desde `escenario/dotnet/`: `dotnet build LiquidacionComercios -c Release`. Si no
   compila, revisa las variables intermedias: es el error más probable de este paso.
4. **La verificación que define el éxito de este paso.** Desde la raíz del repositorio:

   ```bash
   bash scripts/comparar-escenarios.sh
   ```

   Debe terminar con código de salida cero y decir que las salidas son idénticas. Si
   reporta una diferencia, la refactorización cambió el comportamiento y hay que
   revisarla.

5. En tu respuesta, una lista de los otros problemas que hayas visto y no hayas tocado.
