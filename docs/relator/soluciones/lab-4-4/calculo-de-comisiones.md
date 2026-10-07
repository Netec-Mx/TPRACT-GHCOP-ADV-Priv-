> Documento de referencia para el relator, escrito sin Copilot.

# Cálculo de comisiones según el código, escenario Java

Este documento describe lo que hace el código, no lo que dicen sus comentarios. Las rutas de
los archivos Java son relativas a `escenario/java/src/main/java/pe/pasarelaandina/`; las demás
son relativas a la raíz del repositorio. Cada afirmación cita archivo y línea.

## 1. Qué código calcula en el cierre

El cierre mensual lo ejecuta `AplicacionLiquidacion.java:47-59`: crea una
`CalculadoraLiquidacion`, carga los datos y llama a `procesarLiquidacionCompleta`. Ese método,
`calculo/CalculadoraLiquidacion.java:82-364`, calcula la comisión de cada transacción en
línea, sin llamar a `CalculadoraComision`.

`CalculadoraComision` solo se usa desde `SimuladorComision`, que la instancia en
`calculo/SimuladorComision.java:18` y la invoca en `calculo/SimuladorComision.java:42-43`. El
programa usa el simulador después del cierre, para imprimir una estimación del área
comercial (`AplicacionLiquidacion.java:69-76`). Ese resultado no entra en ninguna
liquidación.

Hay, por lo tanto, dos implementaciones del cálculo de una transacción, y no son iguales. Lo
que se cobra es lo que hace `CalculadoraLiquidacion`. Las diferencias con `CalculadoraComision`
se señalan en cada sección.

## 2. Qué transacciones entran

1. Se recorren todos los comercios que devuelve `buscarComerciosActivos`
   (`calculo/CalculadoraLiquidacion.java:106`). Ese método devuelve todos los comercios, sin
   filtrar por estado (`repositorio/RepositorioMemoria.java:56-62`). El único filtro de
   estado del cierre excluye a los `DE_BAJA` (`calculo/CalculadoraLiquidacion.java:110-112`),
   de modo que un comercio `SUSPENDIDO` se liquida. En los datos, `CM0031` está suspendido
   (`escenario/datos/comercios.txt:32`) y aparece en la salida del cierre de 2026-06.
2. El comercio tiene que tener un plan existente (`calculo/CalculadoraLiquidacion.java:114-116`).
3. La transacción se descarta, y se cuenta en `transaccionesDescartadas`, si es nula, no tiene
   fecha, su moneda no es `PEN` o su monto es menor o igual a cero
   (`calculo/CalculadoraLiquidacion.java:57-73`). La misma validación suma el monto de las
   válidas en `acumuladoGeneralTransado` (`calculo/CalculadoraLiquidacion.java:74`).
4. Su fecha tiene que caer en el periodo, ni antes del inicio ni después del fin
   (`calculo/CalculadoraLiquidacion.java:136`).
5. Su estado tiene que ser `APROBADA` (`calculo/CalculadoraLiquidacion.java:138`). Las
   `ANULADA`, `RECHAZADA` y `PENDIENTE` (`modelo/EstadoTransaccion.java:8-11`) no generan
   comisión.

## 3. Selección del tramo

Los tramos de cada plan vienen de `escenario/datos/planes.txt`. Por ejemplo, PL01 tiene
`0:500:3.5|500:2000:2.9|2000:10000:2.5|10000:999999:2.1` (`escenario/datos/planes.txt:2`):
el límite superior de un tramo es el inferior del siguiente.

**En el cierre** (`calculo/CalculadoraLiquidacion.java:144-162`):

- Se recorren los tramos en el orden del archivo y se toma el primero que cumple
  `monto >= montoDesde` y `monto < montoHasta` (`calculo/CalculadoraLiquidacion.java:148-149`).
  El límite inferior es inclusivo y el superior **exclusivo**.
- Una vez encontrado, la bandera `tramoEncontrado` impide que otro tramo lo reemplace
  (`calculo/CalculadoraLiquidacion.java:146`, `calculo/CalculadoraLiquidacion.java:152`).
- Si ningún tramo calza, se usa el porcentaje del último tramo de la lista
  (`calculo/CalculadoraLiquidacion.java:157-162`).

**En `CalculadoraComision.determinarTramo`**, la condición es `monto >= montoDesde` y
`monto <= montoHasta` (`calculo/CalculadoraComision.java:23`): el límite superior es
**inclusivo**. Si ningún tramo calza, también devuelve el último
(`calculo/CalculadoraComision.java:27`).

Consecuencia: un monto exactamente igual a un límite cae en tramos distintos según la clase.
Con PL01, ejecutado sobre los datos del repositorio:

| Transacción | Monto | Cierre (`<`) | Simulador (`<=`) | Comisión base en el cierre | Comisión del simulador |
|---|---|---|---|---|---|
| `TX002001` | 500.00 | 2,9 % | 3,5 % | 14.80 | 17.80 |
| `TX002002` | 2000.00 | 2,5 % | 2,9 % | 50.30 | 58.30 |

Las dos transacciones son de `CM0001`, que tiene el plan PL01
(`escenario/datos/transacciones.txt:2002-2003`, `escenario/datos/comercios.txt:2`). Las cifras
salen de ejecutar `procesarLiquidacionCompleta` y `simularComisionDeTransaccion` sobre esos
datos. Con 10000.00 pasa lo mismo: el simulador devuelve 2,5 % y el cierre aplicaría 2,1 %.

**Los tramos no son acumulativos.** Se elige un solo tramo y su porcentaje se aplica al monto
completo de la transacción (`calculo/CalculadoraLiquidacion.java:164`; en el simulador,
`calculo/CalculadoraComision.java:38-39`). El comentario de clase de
`modelo/PlanComisiones.java:9-10` dice que el monto se reparte entre los tramos que atraviesa.
Ningún código hace ese reparto: el comentario no describe el comportamiento.

## 4. Comisión de una transacción

1. **Porcentaje.** `comisionBase = monto * porcentaje / 100`
   (`calculo/CalculadoraLiquidacion.java:164`). Se aplica al monto completo, sin descontar
   impuesto alguno. El comentario de `calculo/CalculadoraComision.java:10-11`, que habla de
   aplicar la comisión sobre el valor de venta neto, tampoco describe lo que hace su propio
   cálculo (`calculo/CalculadoraComision.java:39`).
2. **Monto fijo.** Se suma el monto fijo del plan a la comisión base
   (`calculo/CalculadoraLiquidacion.java:165`). Para PL01 es 0.30
   (`escenario/datos/planes.txt:2`).
3. **Recargo por cuotas.** Solo si `cuotas > 1` (`calculo/CalculadoraLiquidacion.java:169`).
   El porcentaje es `(cuotas - 1) * 0.5` (`calculo/CalculadoraLiquidacion.java:171`), con tope
   de **3.0** (`calculo/CalculadoraLiquidacion.java:173-175`). El recargo es
   `comisionBase * porcentajeRecargo / 100` (`calculo/CalculadoraLiquidacion.java:177`): se
   calcula sobre la comisión base, que ya incluye el monto fijo, no sobre el monto de la venta.
4. **Total de la transacción.** `comisionTotal = comisionBase + recargo`
   (`calculo/CalculadoraLiquidacion.java:180`). Se guarda en la línea de detalle sin redondear
   (`calculo/CalculadoraLiquidacion.java:182-190`).

En `CalculadoraComision.calcularRecargoCuotas` la fórmula es la misma
(`calculo/CalculadoraComision.java:52`), pero el tope es **3.5**
(`calculo/CalculadoraComision.java:53-55`), aunque el comentario del método habla de «tope de
tres puntos» (`calculo/CalculadoraComision.java:45-46`). Con 24 cuotas, el simulador aplica
3,5 % y el cierre 3 %.

Todos los montos son `double`: el de la transacción (`modelo/Transaccion.java:12`), los de la
línea de detalle (`modelo/DetalleLiquidacion.java:10-13`) y los totales de la liquidación
(`modelo/Liquidacion.java:15-19`).

## 5. Total del comercio y tope mensual

- Por cada transacción liquidada se acumulan `totalTransado`, `totalComisiones` y
  `cantidadTransacciones` (`calculo/CalculadoraLiquidacion.java:192-194`).
- Terminado el recorrido, si `totalComisiones` supera el tope del plan, se reemplaza por el
  tope y se marca `topeAplicado` (`calculo/CalculadoraLiquidacion.java:202-205`). Para PL01 el
  tope es 8000.00 (`escenario/datos/planes.txt:2`).
- El acumulado general de comisiones se suma por transacción, antes de aplicar el tope
  (`calculo/CalculadoraLiquidacion.java:196`), de modo que no refleja el tope.

## 6. Contracargos

Se suman los contracargos del comercio que están en estado `APROBADO`
(`calculo/CalculadoraLiquidacion.java:213`), tienen fecha
(`calculo/CalculadoraLiquidacion.java:217`) y cuya fecha cae dentro del periodo
(`calculo/CalculadoraLiquidacion.java:219-222`). Ni el estado ni la fecha de la transacción
original intervienen. Según `escenario/README.md:126`, la fecha de cada contracargo es la de
su aprobación, así que el contracargo se descuenta en el periodo en que se aprueba.

## 7. Retención de garantía

- Solo si el comercio tiene fecha de afiliación (`calculo/CalculadoraLiquidacion.java:232`).
- Se calculan los meses completos entre la afiliación y el inicio del periodo
  (`calculo/CalculadoraLiquidacion.java:234`). `mesesEntre` resta años y meses y descuenta uno
  si el día del mes final es menor que el del inicial (`calculo/UtilidadesFecha.java:138-145`).
- Si son menos de 6 (`calculo/CalculadoraLiquidacion.java:236`), la base es
  `totalTransado - totalComisiones - totalContracargos`, con las comisiones ya topadas
  (`calculo/CalculadoraLiquidacion.java:238`), y si es positiva la retención es el 5 % de esa
  base (`calculo/CalculadoraLiquidacion.java:240-241`).

## 8. Redondeo y monto neto

- Los cuatro totales se redondean con `Math.round(x * 100.0) / 100.0`
  (`calculo/CalculadoraLiquidacion.java:246-249`). Es el único redondeo del cierre: ni la
  comisión de cada transacción ni las líneas de detalle se redondean.
- El neto lo calcula `obtenerMontoNeto` como transado menos comisiones menos contracargos menos
  retenciones, y además lo asigna al campo `montoNeto` (`modelo/Liquidacion.java:87-90`).
  Después se vuelve a redondear y se asigna otra vez
  (`calculo/CalculadoraLiquidacion.java:257-259`).
- Como el redondeo opera sobre `double`, un acumulado que en decimal exacto termina en 5 puede
  quedar apenas por debajo. Para `CM0011` el cierre de 2026-06 informa comisiones de
  S/ 137.82: `137.825 * 100.0` da `13782.499999999998` en `double` y `Math.round` baja.

## 9. Periodo

- El inicio es el día 1 a las 00:00:00.000 (`calculo/UtilidadesFecha.java:79-91`) y el fin, el
  último día del mes a las 23:59:59.000 (`calculo/UtilidadesFecha.java:97-111`). La
  comparación es inclusiva en los dos extremos (`calculo/CalculadoraLiquidacion.java:136`).
- El calendario se crea con `Calendar.getInstance(ConfiguracionRegional.REGION_DE_SALIDA)`
  (`calculo/UtilidadesFecha.java:37`), que fija la configuración regional y no la zona
  horaria. La propia clase lo advierte: la zona sigue siendo la del sistema
  (`util/ConfiguracionRegional.java:34-35`). Ninguna parte del cálculo fija America/Lima, aunque
  el comentario de `calculo/UtilidadesFecha.java:13-14` lo afirme.
- `finDePeriodo` parte de un calendario con la fecha actual del sistema, fija año y mes, fija
  el día 1 y recién entonces pide el máximo del mes con `getActualMaximum`
  (`calculo/UtilidadesFecha.java:101-105`). Así el fin del periodo no depende del día en que se
  ejecuta. La prueba `UtilidadesFechaTest` lo comprueba con el reloj fijado en un día 31.

## Contraste con las reglas declaradas

Reglas 1 a 9 de `escenario/README.md:39-53`. El criterio es el código que corre en el cierre,
`CalculadoraLiquidacion`, porque es el que factura. Cuando `CalculadoraComision` difiere, se
indica aparte.

| Regla | Qué dice | Qué hace el código del cierre | Resultado |
|---|---|---|---|
| 1 (`escenario/README.md:39-40`) | Porcentaje del tramo más monto fijo | Porcentaje del tramo sobre el monto más el monto fijo del plan (`calculo/CalculadoraLiquidacion.java:164-165`) | Coincide |
| 2 (`escenario/README.md:41-42`) | Tramos no acumulativos; el monto completo por el porcentaje de su tramo | Un solo tramo, aplicado al monto completo (`calculo/CalculadoraLiquidacion.java:144-164`). El comentario `modelo/PlanComisiones.java:9-10` dice lo contrario | Coincide el código. El comentario contradice la regla y el código |
| 3 (`escenario/README.md:43-44`) | 0,5 % por cuota sobre la primera, máximo 3 % | `(cuotas - 1) * 0.5` con tope 3.0 (`calculo/CalculadoraLiquidacion.java:171-175`), aplicado como porcentaje de la comisión base (`calculo/CalculadoraLiquidacion.java:177`) | Coincide en el cierre. `CalculadoraComision` topa en 3.5 (`calculo/CalculadoraComision.java:53-55`) y no coincide |
| 4 (`escenario/README.md:45`) | Anuladas no generan comisión | Solo `APROBADA` genera comisión (`calculo/CalculadoraLiquidacion.java:138`) | Coincide. También excluye rechazadas y pendientes |
| 5 (`escenario/README.md:46-47`) | Contracargos aprobados en el periodo en que se aprueban | `APROBADO` con fecha dentro del periodo (`calculo/CalculadoraLiquidacion.java:213-222`); esa fecha es la de aprobación (`escenario/README.md:126`) | Coincide |
| 6 (`escenario/README.md:48`) | Si el total supera el tope, se cobra el tope | `calculo/CalculadoraLiquidacion.java:202-205` | Coincide |
| 7 (`escenario/README.md:49-50`) | Menos de seis meses de afiliación, retención del 5 % sobre el neto | Menos de 6 meses completos al inicio del periodo; 5 % sobre transado menos comisiones menos contracargos, si es positivo (`calculo/CalculadoraLiquidacion.java:234-241`) | Coincide, entendiendo «monto neto» como el neto antes de la retención |
| 8 (`escenario/README.md:51-52`) | Del día 1 a las 00:00:00 al último día a las 23:59:59, en hora de Lima | Los límites horarios coinciden (`calculo/UtilidadesFecha.java:79-111`), pero se calculan en la zona del sistema (`calculo/UtilidadesFecha.java:37`, `util/ConfiguracionRegional.java:34-35`) | No coincide: el código no garantiza la hora de Lima |
| 9 (`escenario/README.md:53`) | Todo monto a dos decimales, medio hacia arriba | `Math.round(x * 100.0) / 100.0` solo sobre los totales (`calculo/CalculadoraLiquidacion.java:246-249`, `calculo/CalculadoraLiquidacion.java:258`), en `double`; la comisión por transacción no se redondea (`calculo/CalculadoraLiquidacion.java:180-187`). `CM0011` sale con 137.82 donde el medio hacia arriba de 137.825 da 137.83 | No coincide |

**Resumen.** Con el criterio del cierre, coinciden 7 reglas (1, 2, 3, 4, 5, 6 y 7) y no
coinciden 2 (8 y 9). Si se exige que coincidan las dos implementaciones del cálculo, la regla 3
pasa a no coincidir por el tope de 3.5 de `CalculadoraComision`, y quedan 6 y 3.

Diferencias entre las dos implementaciones que ninguna regla menciona de forma directa, pero
que afectan las reglas 1 y 2 en los bordes: el límite superior del tramo es exclusivo en el
cierre (`calculo/CalculadoraLiquidacion.java:149`) e inclusivo en el simulador
(`calculo/CalculadoraComision.java:23`).
