# Solución de referencia del laboratorio 5.4

Solo para el relator.

## Versión y notas

**Versión 1.5.0.** La vigente es 1.4.0, la de `pom.xml` y del registro de cambios. Se agrega
una funcionalidad compatible, el reporte, y se corrige el cálculo de la liquidación. Un
participante puede defender 2.0.0 porque cambian montos que ya se cobraban; vale la
conversación. Lo que no es defendible es un parche, 1.4.1, porque agrega una funcionalidad.

La sección de montos de las notas tiene que decir, sin tecnicismos:

- En la liquidación de junio de 2026 cambia el total de comisiones de cinco comercios.
- CM0001 y CM0007 pagan S/ 11.00 más cada uno: dos ventas de cada uno por exactamente
  S/ 500.00 y S/ 2000.00 se cobraban con el porcentaje del tramo siguiente. La regla
  confirmada por el negocio es que un monto en el límite pertenece al tramo inferior.
- CM0011, CM0016 y CM0025 pagan un centavo más cada uno: el cálculo anterior redondeaba hacia
  abajo un medio centavo.
- Abril y mayo no cambian.

## Incidente INC-2026-0042

**Causa.** El cambio viene de la versión nueva. La comisión de CM0001 en junio pasa de
727,34 a 738,34 por TX002001, de 500,00, que paga 17,80 en lugar de 14,80, y TX002002, de
2000,00, que paga 58,30 en lugar de 50,30. Total, 11,00.

**Alcance.** CM0007 tiene el mismo caso, por 11,00. CM0011, CM0016 y CM0025 suben un centavo.
Nadie más cambia.

**Respuesta de referencia al comercio**, en lo esencial: sus ventas no cambiaron; dos de ellas
tenían montos exactamente en el límite entre dos tramos de su plan y el sistema anterior les
aplicaba el porcentaje menor; la regla de su plan, confirmada, es que el límite pertenece al
tramo inferior; la diferencia es de S/ 11.00; si quiere revisar su contrato, su ejecutivo
coordina con el área comercial. No promete devolución ni compensación.

Si un participante concluye que la versión nueva es un error y propone revertirla, pregunte
qué decisión de negocio respalda el monto nuevo y dónde está registrada.

## Evolutivas posibles

La publicada es el filtro por categoría. Las otras dos sirven si alguien termina antes.

| Evolutiva | Qué cambia | Con IA, persona (min) | Sin IA, persona (min) | Riesgo principal |
|---|---|---|---|---|
| Filtro por categoría de comercio, la publicada | Un argumento nuevo y un filtro antes de agrupar | 60 | 240 | Qué pasa con el tope de un comercio de varias categorías: hoy una sola, preguntar |
| Reporte por plan de comisiones | Agrupar por plan en lugar de por medio | 75 | 300 | El tope sigue siendo por comercio: el ajuste no se reparte |
| Exportar el reporte en CSV | Un formato de salida nuevo | 45 | 180 | Separador decimal y codificación en la planilla del área comercial |

Las cifras son de referencia, en la misma escala que la estimación del 5.1.
