# Capítulo 5: hoja de respuestas del relator

Todo lo que usted dice en el capítulo, en orden. Lo demás lo entrega el repositorio.

## 5.1, paso 1: usted es el negocio

Responda solo lo que pregunten.

| Si preguntan | Responda |
|---|---|
| Qué transacciones entran | Las mismas que la liquidación: aprobadas, en soles, monto mayor que cero, dentro del periodo. Ni anuladas, ni pendientes, ni rechazadas |
| Qué comercios entran | Los que se liquidan: activos y suspendidos con plan. No los dados de baja |
| Contra qué se comprueba | El total del reporte es igual a la suma del total de comisiones de las liquidaciones, al centavo |
| El tope | Es por comercio, no se reparte. Las filas van antes del tope y una fila de ajuste muestra lo descontado |
| El redondeo | Al final: cada fila suma exacto y redondea; el total se calcula por comercio, como la liquidación |
| Un monto en el límite de un tramo | Pertenece al tramo inferior. El límite superior es inclusivo |
| Orden, formato o decimales | Los fija la especificación técnica que el repositorio entrega en el 5.2 |

En la puesta en común: una historia que solo excluye las anuladas difiere de las
liquidaciones en 3 415,01, 4 065,43 y 2 521,97 soles en abril, mayo y junio.

## 5.3, paso 3: la decisión del borde

Si no la pidieron en el 5.1, la piden aquí. Misma respuesta: el límite superior es
inclusivo; 500 va al primer tramo, 2000 al segundo, 10000 al tercero.

**Si alguien encuentra solo la causa grande** (22,00 del borde) y le quedan 0,03: pregunte
cuánto suma lo que encontró contra la diferencia. Sugiera recalcular con decimal exacto los
comercios que todavía difieren. Si se acaba el tiempo: CM0011, CM0016 y CM0025, punto
flotante.

## Si alguien se atrasa

Clave de ponerse al día: `quinua-condor-47`. Dígala en voz alta y que el participante
ejecute, desde la raíz de su repositorio, con su stack y el laboratorio al que tiene que
llegar:

```bash
bash scripts/proyecto/ponerse-al-dia.sh lab-5-3 java quinua-condor-47
```

Descarta su trabajo del capítulo y pide escribir `descartar`. Para empezar el 5.1 de cero:
`bash scripts/reiniciar-lab.sh lab-5-1`.

## 5.4

Nada. El incidente lo entrega el repositorio y la evolutiva está en el backlog. Si alguien
propone revertir la versión: pregunte qué decisión respalda el monto nuevo y dónde está
registrada.
