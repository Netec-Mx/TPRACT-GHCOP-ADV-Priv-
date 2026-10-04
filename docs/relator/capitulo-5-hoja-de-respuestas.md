# Capítulo 5: hoja de respuestas del relator

## 5.1, paso 1: usted es el negocio

Responda solo lo que pregunten.

| Si preguntan | Responda |
|---|---|
| Qué transacciones entran | Aprobadas, en soles, monto mayor que cero, en el periodo |
| Qué comercios entran | Activos y suspendidos con plan; no los dados de baja |
| El periodo | Del primer día a las 00:00:00 al último a las 23:59:59, con la hora del cierre |
| El monto transado | Suma exacta de los montos del medio |
| Las cuotas | La comisión incluye su recargo: 0,5 % por cuota sobre la primera, máximo 3 %, sobre la comisión base |
| Contracargos y retenciones | No forman parte del reporte |
| Contra qué se comprueba | Suma del total de comisiones de las liquidaciones, al centavo |
| El tope | Por comercio; filas antes del tope y una fila de ajuste |
| El redondeo | Al final: cada fila suma exacto y redondea; el total, por comercio, como la liquidación |
| Un monto en el límite de un tramo | Al tramo inferior: límite superior inclusivo |
| Orden, formato o decimales | Los fija la especificación que se entrega en el 5.2 |

Criterio de decimales: un comercio cuya suma exacta termina en 5 en el tercer decimal; si
no, que lo rehaga. Si el agente avisa un defecto del código, como el
borde o el recargo de 3,5 %: bien visto; se confirma en el 5.3.

**Paso 3.** La 0004 de referencia es del camino A: el reporte calcula por su cuenta. Quien
reutiliza el cálculo de la liquidación registra eso y su consecuencia: el reporte hereda
las diferencias del cálculo.

Puesta en común: una historia que solo excluye las anuladas difiere de las
liquidaciones en 3 415,01, 4 065,43 y 2 521,97 soles en abril, mayo y junio.

## 5.3, paso 3: la decisión del borde

Si no la pidieron en el 5.1: límite superior inclusivo; 500 va al primer tramo, 2000 al
segundo, 10000 al tercero.

La corrección va en la liquidación. El reporte no se reescribe: si reutiliza el cálculo,
queda corregido con ella.

**Si encuentra solo el borde** o **solo explica lo que fallan las pruebas**: pregunte cuánto
suma cada causa y a quién afecta; sugiera recalcular con decimal exacto. Total 22,03: 22,00
de borde, CM0001 y CM0007; 0,03 de punto flotante, CM0011, CM0016 y CM0025.

**Si alguien nota que el periodo 2026-13 liquida enero de 2027:** bien visto; no es del
catálogo, no se corrige.

## Si alguien se atrasa

Clave de ponerse al día: `quinua-condor-47`. Dígala; el participante ejecuta, con su stack
y laboratorio:

```bash
bash scripts/proyecto/ponerse-al-dia.sh lab-5-3 java quinua-condor-47
```

Pide escribir `descartar` y deja el camino A. El 5.1 de cero:
`bash scripts/reiniciar-lab.sh lab-5-1`.

## 5.4

Si alguien propone revertir la versión: pregunte qué decisión respalda el monto nuevo y
dónde está.
