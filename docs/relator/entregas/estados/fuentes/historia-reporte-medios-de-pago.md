# Historia de usuario: reporte de comisiones por medio de pago

| Campo | Valor |
|---|---|
| Solicitante | Gerencia Comercial |
| Origen | `docs/proyecto/backlog/solicitud-area-comercial.md` |
| Estado | Aceptada |

## Historia

Como Gerencia Comercial, quiero un reporte mensual de comisiones por medio de pago, para
negociar con emisores y billeteras con datos que cuadran con lo que se liquida a los
comercios.

## Preguntas abiertas

| Pregunta | Respuesta | Quién respondió |
|---|---|---|
| ¿Qué transacciones entran? | Las mismas que la liquidación: aprobadas, en soles, con monto mayor que cero, dentro del periodo. Ni anuladas, ni pendientes, ni rechazadas | Negocio |
| ¿Qué comercios entran? | Los que se liquidan: activos y suspendidos con plan. No los dados de baja | Negocio |
| ¿Contra qué se comprueba el total? | Contra la suma del total de comisiones de las liquidaciones del periodo, al centavo | Negocio |
| ¿El tope mensual se reparte entre medios? | No. Es por comercio. Las filas van antes del tope y una fila de ajuste muestra lo descontado | Negocio |
| ¿Cuándo se redondea? | Al final. Cada fila suma exacto y redondea; el total se calcula por comercio, como la liquidación | Negocio |
| ¿A qué tramo pertenece un monto en el límite? | Al tramo inferior. El límite superior es inclusivo | Negocio |

## Criterios de aceptación

1. **Alcance.** Dado el periodo 2026-06, cuando se genera el reporte, entonces cuenta las
   mismas transacciones que liquida el cierre, por medio de pago.
2. **Conciliación.** Dado cualquier periodo, cuando se genera el reporte, entonces su total
   es igual a la suma del total de comisiones de las liquidaciones del mismo periodo.
3. **Borde de tramo.** Dada TX002001, de CM0001 con plan PL01, por 500,00 en una cuota,
   cuando se calcula su comisión, entonces es 500,00 × 3,5 % + 0,30 = 17,80.
4. **Tercer decimal.** Dado CM0025 en 2026-06, cuando se suman exactas las comisiones de sus
   transacciones, entonces el total es 957,185 y redondea a 957,19.
5. **Tope.** Dado CM0004 en 2026-06, cuando se genera el reporte, entonces su exceso sobre el
   tope aparece en la fila de ajuste por tope y no en las filas de medios.
6. **Formato.** Dado un monto en soles, cuando el reporte lo muestra, entonces lleva dos
   decimales, redondeado medio hacia arriba, según la regla 9 de `escenario/README.md`:
   957,185 se muestra con 957,19. Se comprueba con una prueba de la función que da formato
   a la salida. El reporte se obtiene con `--reporte-medios` y su salida completa coincide con
   la esperada según `bash scripts/verificar-reporte.sh <stack> <periodo>`.

## Fuera de alcance

Contracargos y retenciones. Filtros por comercio o por categoría.
