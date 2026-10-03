# Notas del relator, laboratorio 5.1

Preparación del escenario integrador y criterios de evaluación. 45 minutos. Fases de
Requerimientos, Estimación y Análisis y diseño.

Lo que usted tiene que decir o entregar en todo el capítulo está resumido en una página en
[`../capitulo-5-hoja-de-respuestas.md`](../capitulo-5-hoja-de-respuestas.md).

## Qué va a pasar en la sala

**Abra proyectando [`CICLO-DE-VIDA.md`](../../../CICLO-DE-VIDA.md).** El capítulo recorre las
once fases con una sola historia. Pida a cada participante que elija un stack y lo mantenga
hasta el final.

**Paso 1, el momento clave.** La solicitud del área comercial es ambigua a propósito. Dice que
las anuladas no cuentan y nada más sobre el alcance. El agente lista preguntas abiertas y se
detiene. En esta sala el negocio es usted. Responda con la hoja de respuestas, y solo lo que
le pregunten. Quien no pregunta por el alcance escribe un criterio que después no concilia,
y eso es parte de la clase: una historia tomada al pie de la letra, que solo excluye las
anuladas, difiere de las liquidaciones en 3 415,01 soles en abril, 4 065,43 en mayo y
2 521,97 en junio. Use esas cifras en la puesta en común.

Si alguien pregunta a qué tramo pertenece un monto en el límite, responda con la decisión del
borde. Si nadie lo pregunta aquí, aparece en el 5.3.

**Paso 2.** La estimación con y sin IA. Lo que vale la pena observar es dónde la IA cambia la
estimación y dónde no. El registro de tiempos empieza aquí y se compara en el 5.4.

**Paso 3.** Las tres alternativas de dónde vive el reporte llevan a los dos caminos del 5.2.
No sugiera ninguna. Cualquiera sirve.

## Errores típicos

- Responder por el participante las preguntas que el agente lista. El valor del paso está
  en que las lleve al negocio.
- Criterios sin valor esperado. La skill pide la cuenta a la vista.
- Estimaciones con precios. La plantilla los excluye.

## Tiempos

| Paso | Estimado | Observado en la verificación |
|---|---|---|
| 1 | 15 min | 104 a 116 s de agente y 3 a 8 comandos, en 4 corridas |
| 2 | 10 min | 20 a 25 s de agente y 1 a 2 comandos, en 4 corridas |
| 3 | 10 min | 26 a 41 s de agente y 1 a 4 comandos, en 4 corridas |

Suma 35. Quedan 10 para la puesta en común.

## Si alguien se atrasa

Entréguele la historia de referencia. Está en
[`../soluciones/lab-5-1/historia-de-referencia.md`](../soluciones/lab-5-1/historia-de-referencia.md),
con las respuestas a las preguntas abiertas. Sin la historia no puede seguir, porque sus
criterios son los que evalúan el 5.2 y el 5.3.

## Solución de referencia

En `../soluciones/lab-5-1/`: la historia, la estimación construida con las mediciones de
SPEC-015 y la decisión de dónde vive el reporte.
