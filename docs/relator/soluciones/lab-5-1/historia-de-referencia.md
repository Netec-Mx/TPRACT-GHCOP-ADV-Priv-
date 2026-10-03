# Historia de referencia: reporte de comisiones por medio de pago

Solo para el relator. Es la historia que debería salir del paso 1 del 5.1 si el participante
hace las preguntas correctas. Las respuestas salen de
[`../../funcionalidad-reporte.md`](../../funcionalidad-reporte.md).

## Historia

Como Gerencia Comercial, quiero un reporte mensual de comisiones por medio de pago, para
negociar con emisores y billeteras con datos que cuadran con lo que se liquida a los
comercios.

## Preguntas abiertas y respuestas del negocio

| Pregunta | Respuesta |
|---|---|
| ¿Qué transacciones entran? | Las mismas que entran hoy a la liquidación: aprobadas, en soles, con monto mayor que cero, dentro del periodo. No entran anuladas, pendientes ni rechazadas |
| ¿Qué comercios entran? | Los mismos que se liquidan: activos y suspendidos con plan. No entran los dados de baja |
| ¿Contra qué se comprueba el total? | Contra la suma del total de comisiones de las liquidaciones del periodo, al centavo |
| ¿El tope mensual se reparte entre medios? | No. Es por comercio. Las filas muestran la comisión antes del tope y una fila de ajuste muestra lo que se descuenta |
| ¿Cuándo se redondea? | Al final. Cada fila de medio suma exacto y redondea; el total se calcula por comercio, como la liquidación. Una fila de ajuste por redondeo muestra la diferencia |
| ¿A qué tramo pertenece un monto en el límite? | Al tramo inferior. El límite superior es inclusivo. Se responde solo si lo preguntan, en el 5.1 o en el 5.3 |

## Criterios de aceptación

1. **Alcance.** Dado el periodo 2026-06, cuando se genera el reporte, entonces cuenta las
   mismas transacciones que liquida el cierre, por medio de pago.
2. **Conciliación.** Dado cualquier periodo, cuando se genera el reporte, entonces su total
   es igual a la suma del total de comisiones de las liquidaciones del mismo periodo, al
   centavo.
3. **Borde de tramo.** Dada TX002001, de CM0001 con plan PL01, por 500,00 en una cuota,
   cuando se calcula su comisión, entonces aplica el tramo de 0 a 500 al 3,5 %:
   500,00 × 3,5 % + 0,30 = **17,80**. La liquidación actual cobra 14,80, con el 2,9 %.
4. **Tercer decimal.** Dado CM0025 en 2026-06, cuando se suman exactas las comisiones de sus
   transacciones, entonces el total es 957,185 y redondea a **957,19**. Una de ellas,
   TX002036, por 509,84 al 2,9 % más 0,30, tiene comisión exacta 15,08536. La liquidación
   actual da 957,18.
5. **Tope.** Dado CM0004 en 2026-06, cuando se genera el reporte, entonces su exceso sobre el
   tope aparece en la fila de ajuste por tope y no en las filas de medios.
6. **Formato.** El reporte se obtiene con `--reporte-medios` y su salida coincide con la
   esperada según `bash scripts/verificar-reporte.sh <stack> <periodo>`.

Los criterios 2, 3 y 4 son los que en el 5.3 ponen el pipeline en rojo, por la conciliación
o por las pruebas, según cómo se implementó el 5.2.
