---
name: lab-2-4-paso-1-elegir-tarea
description: 'Lab 2.4 paso 1. Ayuda a elegir una de las cuatro tareas del laboratorio y a decidir si conviene resolverla con un agente o con una instrucción.'
disable-model-invocation: true
---

# Objetivo

Elegir la tarea del equipo que el participante va a automatizar y decidir si conviene un
agente local o una instrucción reutilizable.

Las cuatro tareas posibles están en [tareas.md](../../../labs/cap2/lab-2-4-agente-o-instruccion/tareas.md). El participante elige una sola.

# Qué hacer

1. Presenta las cuatro tareas en una línea cada una.
2. Explica el criterio de decisión:
   - **Instrucción reutilizable** cuando la tarea es una regla que debe aplicarse sola
     cada vez que se trabaja sobre cierto tipo de archivo, sin que nadie la pida.
   - **Agente local** cuando la tarea es un rol que alguien invoca a propósito, con su
     propio foco, sus herramientas acotadas y su forma de responder.
3. Pregunta al participante qué tarea elige. Cuando responda, confirma si conviene agente
   o instrucción y por qué, en dos oraciones.
4. Revisa los artefactos que ya existen en `.github/agents/` y `.github/instructions/` y
   confirma que ninguno resuelve ya la tarea elegida.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No crees ni modifiques archivos en este paso.

# Salida esperada

La tarea elegida, el tipo de artefacto y el paso que corresponde a continuación:
`/lab-2-4-paso-2a-construir-instruccion` o `/lab-2-4-paso-2b-construir-agente`.
