---
name: pasarela-analizar-incidente
description: 'Analiza un incidente de producción de Pasarela Andina con la plantilla de runbook, hasta su causa y su alcance, y redacta la respuesta al afectado. Úsala cuando llegue un reclamo, un incidente o un comportamiento inesperado en producción.'
---

# Análisis de incidentes

La plantilla de runbook está en [runbook-plantilla.md](../../../docs/operacion/runbook-plantilla.md).

## Procedimiento

1. Lee el incidente completo y separa los hechos de lo que el afectado supone.
2. Reproduce lo que reporta con los datos y el código del repositorio. Cada hecho que
   confirmes cita el comando o el archivo.
3. Busca qué cambió: el registro de cambios, las notas de versión, las decisiones de
   arquitectura y el historial de git. Si el comportamiento cambió a propósito, encuentra la
   decisión que lo respalda.
4. Determina el alcance: a quién más afecta, con nombres y montos, verificados con una
   ejecución.
5. Escribe el análisis con la estructura del runbook: síntoma, diagnóstico, acciones y
   escalamiento. Marca como no verificada cualquier acción que no ejecutaste.
6. Redacta la respuesta al afectado en lenguaje de negocio, con la causa, el monto, qué
   decisión lo explica y qué puede hacer si no está de acuerdo. Si hay algo que solo puede
   decidir el negocio, como una compensación, dilo y no lo prometas.
7. Al terminar, muestra en el chat el contenido completo del análisis y de la respuesta,
   no un resumen. Si el análisis supera las 150 líneas, muestra completos el diagnóstico y
   el alcance, y nombra el archivo para abrir el resto.

## Límites

- No modifiques código ni datos al analizar.
- No prometas devoluciones, compensaciones ni cambios de plan.
