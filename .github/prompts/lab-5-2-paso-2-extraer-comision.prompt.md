---
name: 'lab-5-2-paso-2-extraer-comision'
description: 'Lab 5.2 paso 2. Extrae a un metodo el calculo de comision de una transaccion, sin cambiar el comportamiento'
agent: 'agent'
---

# Objetivo

Extraer a un método privado el bloque que calcula la comisión de una transacción, que hoy
está en línea dentro del método de cierre, **sin cambiar el comportamiento del programa**.

# Contexto

El archivo a modificar es el único de esta lista que debes editar:

- #file:../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java

Estos archivos son solo de consulta. Léelos si los necesitas, pero no los modifiques:

- #file:../../escenario/java/src/main/java/pe/pasarelaandina/modelo/PlanComisiones.java
- #file:../../escenario/java/src/main/java/pe/pasarelaandina/modelo/TramoComision.java
- #file:../../escenario/java/src/main/java/pe/pasarelaandina/modelo/Transaccion.java

Las reglas de negocio que el cálculo debe seguir cumpliendo están en:

- #file:../../escenario/README.md

# Qué extraer, exactamente

Dentro del método `procesarLiquidacionCompleta`, el bloque que empieza en la declaración de
`double montoTransaccion` y termina en la línea `liquidacion.agregarDetalle(linea);`.

Ese bloque hace cuatro cosas: busca el tramo que corresponde al monto, aplica el porcentaje
más el monto fijo del plan, suma el recargo por cuotas, y arma con todo eso la línea de
detalle de la liquidación.

Extráelo a un método privado de la misma clase que reciba el plan y la transacción y
**devuelva el `DetalleLiquidacion` ya construido**. En el método de cierre debe quedar la
llamada al método nuevo seguida de `liquidacion.agregarDetalle(linea);`.

**Cuidado con las variables intermedias.** El código que viene después del bloque usa
`montoTransaccion` y `comisionTotal` para ir acumulando los totales del comercio. Al
extraer el bloque, esas variables dejan de existir en el método de cierre, así que esas
líneas tienen que pasar a leer los valores desde el detalle que devuelve el método nuevo
(`linea.getMontoTransaccion()` y `linea.getComisionTotal()`).

Si extraes solo hasta el cálculo de la comisión y dejas fuera la construcción del detalle,
**el código no compila**, porque `comisionBase` y `recargo` se siguen usando más abajo.

# Restricciones

Son la parte más importante de este paso. Un cambio que las viole no sirve aunque el
código quede más lindo.

- **No cambies el comportamiento.** Este paso es una refactorización. La salida del
  programa debe ser idéntica, hasta el último centavo, antes y después.
- **Modifica un solo archivo**, el que se indica arriba.
- **No corrijas ningún defecto que no forme parte de este paso.** Este código tiene
  problemas conocidos y son deliberados: forman parte del material del taller. En
  particular, y sin que esta lista sea exhaustiva:
  - **No** cambies `double` por `BigDecimal` ni por ningún otro tipo.
  - **No** extraigas los números literales a constantes.
  - **No** unifiques el tope del recargo con el que aparece en otras clases.
  - **No** renombres métodos ni variables existentes.
  - **No** agregues manejo de errores donde hoy no lo hay.
  - **No** toques nada fuera del bloque indicado.
- Si detectas otros problemas, **menciónalos en tu respuesta pero no los corrijas**.

# Salida esperada

1. Un método privado nuevo en `CalculadoraLiquidacion`, con nombre en español, que recibe
   el plan y la transacción y devuelve un `DetalleLiquidacion`.
2. El método `procesarLiquidacionCompleta` más corto, con la llamada al método nuevo donde
   antes estaba el bloque, y los acumuladores leyendo del detalle devuelto.
3. El código compila. Si no compila, revisa las variables intermedias: es el error más
   probable de este paso.
4. El proyecto compila: `mvn -q clean package` termina sin errores.
5. **La verificación que define el éxito de este paso.** Desde la raíz del repositorio:

   ```bash
   bash scripts/comparar-escenarios.sh
   ```

   Debe terminar con código de salida cero y decir que las salidas son idénticas. Si
   reporta una diferencia, la refactorización cambió el comportamiento y hay que revisarla.

6. En tu respuesta, una lista de los otros problemas que hayas visto y no hayas tocado.
