# Capítulo 5: hoja de respuestas del relator

## 5.1, paso 1: usted es el negocio

Responda solo lo que pregunten.

| Si preguntan | Responda |
|---|---|
| Qué transacciones entran | Las de la liquidación: aprobadas, en soles, monto mayor que cero, en el periodo |
| Qué comercios entran | Activos y suspendidos con plan; no los dados de baja |
| El periodo | Del primer día a las 00:00:00 al último a las 23:59:59, con la hora del cierre |
| El monto transado | Suma exacta de los montos del medio |
| Las cuotas | La comisión incluye su recargo: 0,5 % por cuota sobre la primera, máximo 3 %, sobre la comisión base |
| Contracargos y retenciones | No forman parte del reporte |
| Contra qué se comprueba | Suma del total de comisiones de las liquidaciones, al centavo |
| El tope | Por comercio, no se reparte. Filas antes del tope; una fila de ajuste muestra lo descontado |
| El redondeo | Al final: cada fila suma exacto y redondea; el total se calcula por comercio, como la liquidación |
| Un monto en el límite de un tramo | Pertenece al tramo inferior. El límite superior es inclusivo |
| Orden, formato o decimales | Los fija la especificación que se entrega en el 5.2 |

El criterio de decimales usa un comercio cuya suma exacta termina en 5 en el tercer
decimal. Si queda otro, que lo rehaga. Si el agente avisa un defecto del código, como el
borde o el recargo de 3,5 %: bien visto, no se corrige ahora, el 5.3 lo confirma.

En la puesta en común: una historia que solo excluye las anuladas difiere de las
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

Clave de ponerse al día: `quinua-condor-47`. Dígala y que el participante ejecute, desde la
raíz de su repositorio, con su stack y laboratorio:

```bash
bash scripts/proyecto/ponerse-al-dia.sh lab-5-3 java quinua-condor-47
```

Descarta su trabajo del capítulo y pide escribir `descartar`. El 5.1 de cero:
`bash scripts/reiniciar-lab.sh lab-5-1`.

## 5.4

Nada. Si alguien propone revertir la versión: pregunte qué decisión respalda el monto nuevo
y dónde está registrada.
