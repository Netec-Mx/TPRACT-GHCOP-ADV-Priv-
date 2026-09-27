# Notas del relator, laboratorio 1.4

Práctica guiada de mejora incremental de prompts y uso de comandos del chat. 30 minutos.

## Qué va a pasar en la sala

El paso 1 produce respuestas largas y distintas entre participantes. Es lo buscado. No
corrija a quien obtuvo una respuesta «mala» en el paso 1, porque esa respuesta es la
línea base.

En el paso 3 las tablas empiezan a parecerse. Pida a dos participantes que comparen la
primera fila de su tabla en voz alta. Casi siempre coinciden en el bloque de selección de
tramo o en el de impresión.

En el paso 4, `/explain` entrega una explicación, no una propuesta. `/plan` entrega un
plan numerado sin tocar código. La comparación final suele concluir que el prompt
estructurado del paso 3 es el más útil para un pull request y `/plan` el más útil para
empezar un cambio grande.

El objeto de observación es el método de 282 líneas de la clase de cálculo (DEF-02). Los
participantes también suelen notar los nombres que no describen lo que hacen (DEF-09) y
los comentarios que contradicen el código (DEF-10). No se corrige nada.

## Errores típicos

- Ejecutar los pasos en conversaciones distintas. El paso 4 compara lo que hay en la misma
  conversación. Si alguien abrió conversaciones nuevas, que repita el paso 3 en la
  conversación donde hizo `/explain` y `/plan`.
- Quedar en modo **Agent** en lugar de **Ask**. No rompe nada, porque ningún paso pide
  editar, pero el agente puede leer más archivos de los necesarios y tardar más.
- Olvidar seleccionar el método antes de `/explain`. Sin selección, explica el archivo
  completo.
- Esperar que `/plan` escriba código. No lo hace. Para implementar el plan hay que elegir
  **Start Implementation** o volver al modo **Agent**, y en este laboratorio no se hace.

## Comandos del chat

Los comandos que usa el laboratorio existen en la versión vigente de Visual Studio Code,
verificados en la documentación del 16 de septiembre de 2026:
`/explain`, `/plan` y la invocación de skills con `/nombre`.

Si alguien pregunta por `/workspace` o `/analyze`, que aparecen en materiales antiguos de
Copilot, no existen como comandos. El contexto del repositorio completo se pide con
`#codebase` y el análisis se pide con un prompt o con `/plan`.

Fuente: https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet

## Tiempos

| Paso | Estimado | Observado en la verificación | Comentario |
|---|---|---|---|
| 1 | 5 min | Respuesta en segundos | Lo que toma tiempo es leerla |
| 2 | 6 min | Respuesta en segundos | |
| 3 | 6 min | Respuesta en segundos | |
| 4 | 8 min | Tres invocaciones | Es el paso más largo por las tres acciones |

La verificación se hizo con un agente fuera de Copilot, así que sus tiempos no son los de
la sala. En la sala, lo que domina es el tiempo de lectura y conversación.

## Si alguien se atrasa

Que salte directo al paso 3. Los pasos son independientes y el paso 3 contiene todo lo que
aportan el 1 y el 2.

## Solución de referencia

No hay. El laboratorio no modifica código y el resultado es una conversación.
