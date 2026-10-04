---
name: lab-2-4-paso-2a-construir-instruccion
description: 'Lab 2.4 paso 2, variante instrucción. Construye una instrucción reutilizable a partir de la plantilla del laboratorio.'
argument-hint: 'tarea C o D'
disable-model-invocation: true
---

# Objetivo

Construir una instrucción reutilizable para la tarea C o D de [tareas.md](../../../labs/cap2/lab-2-4-agente-o-instruccion/tareas.md), completando la
plantilla [plantilla.instructions.md](../../../labs/cap2/lab-2-4-agente-o-instruccion/plantillas/plantilla.instructions.md).

El participante indica la tarea al invocar el paso, con `C` o `D`. Si no la indicó,
pregúntale cuál y no hagas nada más hasta que responda. Si indica una tarea de agente,
dile que el paso que corresponde es `/lab-2-4-paso-2b-construir-agente`.

# Qué hacer

1. Lee la plantilla y la descripción de la tarea.
2. Pregunta al participante, en una sola pregunta, las dos o tres decisiones que la
   plantilla deja abiertas y que no puedes deducir del repositorio.
3. Crea el archivo en `.github/instructions/`, con un nombre en español terminado en
   `.instructions.md`. Completa cada hueco marcado con `COMPLETAR` y borra los
   comentarios de la plantilla.
4. Lista los archivos del repositorio que hoy coinciden con el patrón de `applyTo`. Si
   no coincide ninguno, dilo y aclara que la instrucción igual se aplica cuando el agente
   crea un archivo nuevo que coincide con el patrón. El paso 3 lo prueba así.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Crea un solo archivo. No modifiques la plantilla ni otros artefactos de `.github/`.
- En los metadatos usa solo `name`, `description` y `applyTo`.
- Reglas concretas y verificables. Nada de «escribe código limpio» ni frases que no se
  puedan comprobar.

# Salida esperada

La ruta del archivo creado, su contenido, y la lista de archivos que coinciden con el
patrón.

Escribe ese contenido en el texto de tu respuesta, como Markdown o en un bloque de código.
No basta con ejecutar `cat` o `git diff` en la terminal ni con decir que ya se ve en la
vista de una herramienta: el participante lo tiene que poder leer en tu respuesta.
