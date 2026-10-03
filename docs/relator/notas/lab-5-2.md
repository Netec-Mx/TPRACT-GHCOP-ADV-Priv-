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
| 1 | 10 min | 26 a 66 s de agente y 2 comandos, en 4 corridas |
| 2 | 20 min | 61 a 92 s de agente y 4 a 7 comandos, en 4 corridas |
| 3 | 8 min | 25 a 41 s de agente y 4 a 5 comandos, en 4 corridas |

Suma 38. Quedan 7 para la puesta en común.

## Si alguien se atrasa

Diga la clave de la hoja de respuestas y que ejecute, con su stack:

```bash
bash scripts/proyecto/ponerse-al-dia.sh lab-5-2 java <clave>
```

Deja el repositorio en el inicio del 5.2 con el trabajo de referencia de los laboratorios anteriores.
Descarta lo que tenía del capítulo y pide escribir `descartar`. No hay que llevarle ningún
archivo.


## Solución de referencia

`../soluciones/funcionalidad-reporte/`, el camino A.
