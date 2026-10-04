---
name: lab-2-4-paso-2b-construir-agente
description: 'Lab 2.4 paso 2, variante agente. Construye un agente local a partir de la plantilla del laboratorio.'
argument-hint: 'tarea A, B o E'
disable-model-invocation: true
---

# Objetivo

Construir un agente local para la tarea A, B o E de [tareas.md](../../../labs/cap2/lab-2-4-agente-o-instruccion/tareas.md), completando la plantilla
[plantilla.agent.md](../../../labs/cap2/lab-2-4-agente-o-instruccion/plantillas/plantilla.agent.md).

El participante indica la tarea al invocar el paso, con `A`, `B` o `E`. Si no la indicó,
pregúntale cuál y no hagas nada más hasta que responda. Si indica una tarea de
instrucción, dile que el paso que corresponde es `/lab-2-4-paso-2a-construir-instruccion`.

# Qué hacer

1. Lee la plantilla y la descripción de la tarea.
2. Pregunta al participante, en una sola pregunta, las dos o tres decisiones que la
   plantilla deja abiertas y que no puedes deducir del repositorio.
3. Crea el archivo en `.github/agents/`, con un nombre en español terminado en
   `.agent.md`. Completa cada hueco marcado con `COMPLETAR` y borra los comentarios de
   la plantilla.
4. Revisa que las herramientas declaradas sean las mínimas para la tarea. Un agente que
   solo responde no necesita `edit` ni `execute`.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Crea un solo archivo. No modifiques la plantilla ni otros artefactos de `.github/`.
- En los metadatos usa solo `name`, `description`, `argument-hint` y `tools`.
- Límites concretos: qué no hace el agente, dicho en frases verificables.
- Si incluyes ejemplos que citan archivos, cita archivos reales del repositorio, con líneas
  que existan. No inventes rutas.

# Salida esperada

La ruta del archivo creado, su contenido y una línea que justifique cada herramienta
declarada.

Escribe ese contenido en el texto de tu respuesta, como Markdown o en un bloque de código.
No basta con ejecutar `cat` o `git diff` en la terminal ni con decir que ya se ve en la
vista de una herramienta: el participante lo tiene que poder leer en tu respuesta.
