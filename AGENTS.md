# Contexto del proyecto para agentes de IA

Este archivo describe qué es este repositorio y cómo debe comportarse cualquier agente de
IA que trabaje en él, sea GitHub Copilot en cualquiera de sus modos u otra herramienta.

## Qué es este repositorio

Material de un taller de capacitación en GitHub Copilot dictado a un equipo de
desarrolladores senior. No es un producto en producción ni una base de código que deba
evolucionar hacia un estado correcto.

El repositorio contiene dos escenarios equivalentes, uno en Java y otro en .NET, bajo
`escenario/`. Equivalentes significa que resuelven el mismo dominio y presentan los mismos
problemas de diseño, de modo que un participante Java y uno .NET hagan el mismo ejercicio
en su propio lenguaje.

Los participantes trabajan sobre esos escenarios durante los laboratorios descritos en
`labs/` y construyen los artefactos de personalización que quedan en `.github/`.

## Regla crítica: los defectos del escenario no se corrigen

El código bajo `escenario/` contiene defectos introducidos deliberadamente con fines
didácticos. Entre ellos hay deuda técnica, malas prácticas, acoplamiento excesivo,
ausencia de pruebas, duplicación y decisiones de diseño discutibles.

**Esos defectos son el ejercicio. No se corrigen por iniciativa propia.**

Esto significa, de forma inequívoca:

- No corrijas un defecto porque te parezca obvio o trivial.
- No lo corrijas de paso mientras haces otra tarea en el mismo archivo.
- No lo corrijas al reformatear, renombrar o reorganizar código.
- No propongas un plan que empiece por limpiar el escenario.
- No agregues pruebas al escenario salvo que la tarea lo pida explícitamente.

Si recibes una tarea que toca el escenario, haz exactamente lo que la tarea pide y deja
todo lo demás como está.

Si un laboratorio pide refactorizar una parte específica del escenario, esa parte se
refactoriza y el resto no se toca. El alcance de la tarea es el alcance del cambio.

**Por qué importa.** Si el escenario aparece corregido antes de la clase, el laboratorio
deja de existir y la sesión se cae. El costo de un arreglo bienintencionado aquí es una
actividad completa perdida frente a los participantes.

Si detectas un defecto que crees que no fue plantado a propósito, no lo toques: repórtalo
en tu respuesta y sigue con la tarea.

## Convenciones del repositorio

Idioma. Todo el contenido va en español neutro. Los nombres de archivo y directorio van en
español, sin tildes ni espacios, separados por guiones. Los identificadores del código
siguen la convención de su lenguaje, en inglés cuando corresponda, pero los comentarios y
la documentación van en español.

Documentación. Markdown, en prosa clara. Sin frases de relleno ni fórmulas que delaten
texto generado sin revisar.

Estructura. Los directorios tienen un propósito fijo descrito en el README de la raíz. No
crees directorios nuevos en el primer nivel sin que la tarea lo pida.

## Restricciones del ambiente de clase

Los laboratorios se ejecutan en máquinas virtuales accedidas por escritorio remoto, con
latencia alta. Eso condiciona lo que se puede proponer durante la clase:

- Los participantes no tipean textos largos. Los prompts de laboratorio viven en archivos
  del repositorio y se invocan desde el editor.
- No se copia ni se pega entre ventanas. Todo se ejecuta dentro del editor.
- Nada depende de descargas en tiempo de clase. Las dependencias van precargadas en la
  imagen de la máquina virtual.

Si vas a proponer un paso que exija descargar algo o escribir un prompt largo a mano,
no sirve en este contexto.
