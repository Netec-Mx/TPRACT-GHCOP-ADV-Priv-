---
name: lab-5-4-paso-2-atender-incidente
description: 'Lab 5.4 paso 2, fase de Operación y soporte. Recibe un incidente de producción, lo analiza con el runbook y redacta la respuesta.'
disable-model-invocation: true
---

# Objetivo

Atender el primer incidente después de la versión nueva. Es la fase de Operación y soporte
de [CICLO-DE-VIDA.md](../../../CICLO-DE-VIDA.md).

# Qué hacer

1. Anota en `docs/proyecto/registro-de-tiempos.md` la hora de inicio de Operación y soporte, con `date +%H:%M`, y
   `participante` en Origen.
2. Recibe el incidente ejecutando `bash scripts/proyecto/entregar.sh incidente`, y léelo.
3. Sigue la skill `pasarela-analizar-incidente`. Escribe el análisis en
   `docs/proyecto/incidentes/<identificador>-analisis.md`, con la estructura de
   [la plantilla de runbook](../../../docs/operacion/runbook-plantilla.md), y la respuesta al
   comercio en `docs/proyecto/incidentes/<identificador>-respuesta.md`.
4. Pregunta al participante si la respuesta se puede enviar así o qué cambia.
5. Al terminar, anota en el registro de tiempos la hora de término de Operación y soporte.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques código ni datos.

# Salida esperada

La causa, el alcance con los comercios afectados y la respuesta al comercio. Muestra en el
chat el contenido completo del análisis, de la respuesta y de
`docs/proyecto/registro-de-tiempos.md`, no un resumen. Si el análisis supera las 150 líneas,
muestra completos el diagnóstico y el alcance, y nombra el archivo para abrir el resto.
