# Notas del relator, laboratorio 5.2

Planeación de mejora, refactorización y validación incremental. 45 minutos. Fase de
Desarrollo.

## Qué va a pasar en la sala

**Paso 1.** El agente entrega la especificación técnica del reporte con
`scripts/proyecto/entregar.sh` y arma un plan. No tiene que hacer nada usted: el formato lo
entrega el repositorio. Lo que vale la pena mirar es si el plan reutiliza el cálculo de la
liquidación o calcula por su cuenta. Eso decide el camino.

**La trampa del refactor.** Un plan que reutiliza el cálculo suele proponer unificar la
lógica de tramos, que está duplicada entre `CalculadoraComision` y `CalculadoraLiquidacion`
con una diferencia de un carácter en el borde. Si el agente unifica eligiendo el borde
inclusivo, la liquidación de junio cambia y `integracion-local.sh --paso equivalencia` lo
marca en rojo. Es exactamente lo que el paso tiene que mostrar. Diga: «El refactor cambió
lo que se le cobra a dos comercios. Un refactor no cambia comportamiento; si lo cambia, es
una corrección, y una corrección se decide, se prueba y se libera aparte». Pida deshacer el
cambio y unificar después, en el 5.3, si corresponde.

**Los dos caminos.**

| Camino | Qué pasa en el paso 3 | Qué va a pasar en el 5.3 |
|---|---|---|
| A, cálculo propio exacto | El reporte coincide en los tres periodos | La conciliación de junio falla por 22,03 |
| B, reutiliza la liquidación | El reporte no coincide en junio | Las pruebas de borde y de tercer decimal fallan |

No diga cuál es el bueno. Los dos llegan al mismo rojo en el 5.3 y a la misma corrección.
Si alguien en el camino B pregunta por qué junio no coincide, diga que lo anote: se
diagnostica en el 5.3.

## Errores típicos

- Implementar sin plan aprobado.
- Cambiar los hashes esperados para que el pipeline pase. Está prohibido en este
  laboratorio; cambiar un hash es una decisión de la mantención correctiva del 5.3.
- Tocar el otro escenario.

## Tiempos

| Paso | Estimado | Observado en la verificación |
|---|---|---|
| 1 | 10 min | Se completa en la verificación de SPEC-016 |
| 2 | 20 min | Se completa en la verificación de SPEC-016 |
| 3 | 8 min | Se completa en la verificación de SPEC-016 |

Suma 38. Quedan 7 para la puesta en común.

## Si alguien se atrasa

Aplique el reporte de referencia con `aplicar.sh`, según
[`../soluciones/lab-5-2/README.md`](../soluciones/lab-5-2/README.md). El comando exacto está
en la hoja de respuestas.

## Solución de referencia

`../soluciones/funcionalidad-reporte/`, el camino A.
