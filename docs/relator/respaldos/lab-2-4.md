> Los tiempos de este respaldo son estimados por el agente de verificación, salvo los que
> dicen «medido».

# Lab 2.4 - Salida grabada de respaldo (tarea C, instrucción reutilizable)

Todos los pasos en modo Agent. Antes del laboratorio: `bash scripts/reiniciar-lab.sh lab-2-4 --confirmar` (ya estaba en el punto de partida).

## Paso 1 - `/lab-2-4-paso-1-elegir-tarea`

Modo: Agent

Respuesta del chat (primera parte, antes de la pregunta):

Estas son las cuatro tareas, una línea cada una:

- **A. Agente de soporte comercial.** Explica en lenguaje de negocio cómo se compuso la liquidación de un comercio; no toca archivos.
- **B. Agente redactor de pull requests.** Redacta título y descripción del PR con la plantilla del equipo a partir de los cambios; no modifica código.
- **C. Instrucción para la documentación del equipo.** Se aplica sola a `labs/**/entregables/**/*.md` y fija estructura, tono, citas y prohibiciones.
- **D. Instrucción para los scripts de Git Bash.** Se aplica sola a `scripts/**/*.sh` y fija códigos de salida, compatibilidad y mensajes de error.

Criterio para decidir:

- **Instrucción reutilizable** cuando la tarea es una regla que debe aplicarse sola cada vez que se trabaja sobre cierto tipo de archivo, sin que nadie la pida.
- **Agente local** cuando la tarea es un rol que alguien invoca a propósito, con su propio foco, sus herramientas acotadas y su forma de responder.

¿Qué tarea eliges?

Respuesta del participante: **C**

Respuesta del chat (segunda parte):

Elegiste la tarea C. Conviene una **instrucción**: la regla de estilo debe aplicarse sola cada vez que alguien crea o edita un entregable, sin que tenga que acordarse de invocarla. Un agente exigiría pedirlo a propósito y los documentos seguirían saliendo distintos cuando se olvide.

Revisé `.github/agents/` (analista, tester, documentador, revisor, refactorizador) y `.github/instructions/` (java, dotnet). Ninguno resuelve la tarea: `documentador.agent.md` es un rol que se invoca a propósito y no se aplica solo a `labs/**/entregables/**/*.md`; `java` y `dotnet` aplican a código del escenario.

Tarea elegida: C. Tipo de artefacto: instrucción. Paso siguiente: `/lab-2-4-paso-2a-construir-instruccion C`.

Observación al margen, sin tocar: el directorio `labs/cap2/lab-2-4-agente-o-instruccion/entregables/` no existe en el repositorio, aunque `scripts/reiniciar-lab.sh` lo menciona entre las rutas que restaura.

Tiempo: 14 s (estimado)

## Paso 2a - `/lab-2-4-paso-2a-construir-instruccion C`

Modo: Agent

Pregunta del agente:

Para la plantilla me faltan tres decisiones que no puedo deducir del repositorio. Respóndelas juntas: (1) ¿qué secciones fijas debe tener todo entregable?, (2) ¿qué formato usan las citas de archivo y línea?, (3) ¿qué tono y qué prohibiciones quieres?

Respuesta del participante: "Secciones: Objetivo, Hallazgos, Verificación y Pendientes. Citas como enlace relativo con rango de líneas, por ejemplo `[Clase.java:120-135](ruta#L120-L135)`. Tuteo, español neutro, sin emojis ni relleno, y nada afirmado sobre el código sin cita."

Archivo creado: `.github/instructions/entregables-laboratorio.instructions.md` (contenido tal como quedó al final del paso 2a; el paso 4 cambia luego solo `description`, ver más abajo):

`````markdown
---
name: 'Entregables de laboratorio'
description: 'Fija estructura, tono, citas de archivo y línea y prohibiciones para los documentos Markdown que se entregan en los laboratorios (labs/**/entregables/**/*.md)'
applyTo: 'labs/**/entregables/**/*.md'
---

# Entregables Markdown de los laboratorios

## Reglas

- Estructura fija, con estos encabezados de segundo nivel y en este orden: `## Objetivo`,
  `## Hallazgos`, `## Verificación` y `## Pendientes`. El título del documento es un único
  encabezado de primer nivel arriba de todo.
- `## Objetivo` tiene como máximo tres líneas. `## Pendientes` se escribe aunque esté
  vacío, con la línea «Ninguno».
- Tono: español neutro, tuteo, oraciones de no más de 25 palabras y voz activa. Sin
  adjetivos de valoración como «excelente» o «robusto».
- Cada afirmación sobre el código lleva su cita con el formato `[Clase.java:120-135](ruta/relativa/Clase.java#L120-L135)`.
  Para una sola línea, `[Clase.java:120](ruta/relativa/Clase.java#L120)`. Las rutas son
  relativas al documento y nunca absolutas.
- Los números se escriben tal como los entrega el programa, con dos decimales y el
  símbolo `S/` delante en los montos en soles.
- Los comandos y los fragmentos de código van en bloques con el lenguaje indicado
  (` ```bash `, ` ```java `, ` ```csharp `).
- Cuando el código contradice un comentario o una regla de `escenario/README.md`, el
  documento lo dice en `## Hallazgos`, cita ambos y no elige cuál es el correcto.

## Qué no se hace nunca

- No se usan emojis, HTML incrustado ni imágenes sin texto alternativo.
- No se escriben frases de relleno como «en este documento se presenta» o «cabe destacar».
- No se afirma nada sobre el código sin la cita del archivo y las líneas.
- No se pegan fragmentos de código de más de diez líneas: se cita el rango.

## Ejemplo

````markdown
# Retención de garantía en la liquidación

## Objetivo

Documentar cómo se calcula la retención de garantía de un comercio nuevo.

## Hallazgos

- La retención se aplica si el comercio tiene menos de seis meses de afiliación
  ([CalculadoraLiquidacion.java:236](../../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java#L236)).
- La base es lo transado menos comisiones y contracargos, y la tasa es 5 %
  ([CalculadoraLiquidacion.java:238-241](../../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java#L238-L241)).

## Verificación

```bash
bash scripts/comparar-escenarios.sh
```

## Pendientes

Ninguno.
````
`````

Respuesta final del chat:

Creé `.github/instructions/entregables-laboratorio.instructions.md` con `applyTo: 'labs/**/entregables/**/*.md'`. Completé todos los huecos de la plantilla, borré sus comentarios y usé solo los metadatos `name`, `description` y `applyTo`. `bash scripts/validar-skills.sh` sigue en cero.

Archivos del repositorio que hoy coinciden con el patrón: **ninguno**. El directorio `entregables/` no existe todavía. La instrucción igual se aplica cuando el agente crea un archivo nuevo que coincide con el patrón, y el paso 3 lo prueba así.

Tiempo: 16 s (estimado)

## Paso 3 - `/lab-2-4-paso-3-probar-artefacto`

Modo: Agent

Respuesta del chat:

Artefacto nuevo encontrado: `.github/instructions/entregables-laboratorio.instructions.md`.

Revisión de formato:
- Metadatos `name`, `description` y `applyTo`: presentes.
- `applyTo` apunta a `labs/**/entregables/**/*.md`, hoy sin archivos.
- Sin huecos `COMPLETAR`.
- Errores de formato: ninguno.

Dos pruebas, en modo Agent:

1. Texto a escribir: `Crea labs/cap2/lab-2-4-agente-o-instruccion/entregables/retencion-garantia.md con cómo se calcula la retención de garantía.`
   Debe verse: `entregables-laboratorio.instructions.md` en la lista de referencias de la respuesta, y un documento con los encabezados `Objetivo`, `Hallazgos`, `Verificación` y `Pendientes`, citas con rango de líneas y sin emojis.
2. Texto a escribir: `Agrega a retencion-garantia.md lo que pasa con el tope mensual.`
   Debe verse: la instrucción de nuevo en las referencias, y el hallazgo nuevo con su cita en el formato fijado, dentro de `## Hallazgos`, sin crear secciones nuevas.

Tiempo: 13 s (estimado)

### Paso 3, prueba 1 ejecutada

Invocación: `Crea labs/cap2/lab-2-4-agente-o-instruccion/entregables/retencion-garantia.md con cómo se calcula la retención de garantía.`

Referencias de la respuesta: `entregables-laboratorio.instructions.md`, `CalculadoraLiquidacion.java`, `escenario/README.md`, `Liquidacion.java`.

Respuesta del chat:

Creé `labs/cap2/lab-2-4-agente-o-instruccion/entregables/retencion-garantia.md`. Sigue la instrucción `entregables-laboratorio`: encabezados Objetivo, Hallazgos, Verificación y Pendientes, citas con rango de líneas y rutas relativas, sin emojis. La retención sale de las líneas 230 a 241 de `CalculadoraLiquidacion.java` y coincide con la regla 7 del `README` del escenario.

Contenido completo del archivo creado:

`````markdown
# Retención de garantía en la liquidación

## Objetivo

Documentar cómo calcula `procesarLiquidacionCompleta` la retención de garantía de un comercio con poca antigüedad.

## Hallazgos

- La retención solo se evalúa si el comercio tiene fecha de afiliación ([CalculadoraLiquidacion.java:230-232](../../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java#L230-L232)).
- Se calculan los meses entre la afiliación y el inicio del periodo, y se retiene si son menos de seis ([CalculadoraLiquidacion.java:234-236](../../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java#L234-L236)). Coincide con la regla 7 de [escenario/README.md](../../../../escenario/README.md).
- La base es el total transado menos las comisiones y los contracargos. Solo se retiene si la base es positiva ([CalculadoraLiquidacion.java:238-240](../../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java#L238-L240)).
- La tasa es 5 %, escrita como `0.05` dentro del cálculo ([CalculadoraLiquidacion.java:241](../../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java#L241)).
- La retención se redondea a dos decimales y se resta en el monto neto ([CalculadoraLiquidacion.java:249](../../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java#L249), [Liquidacion.java:88](../../../../escenario/java/src/main/java/pe/pasarelaandina/modelo/Liquidacion.java#L88)).
- La regla 7 dice que la retención es sobre «el monto neto». El código calcula la base antes de restar la retención misma, de modo que ambas lecturas coinciden en el resultado.

## Verificación

```bash
bash scripts/comparar-escenarios.sh
```

## Pendientes

Ninguno.
`````

### Paso 3, prueba 2 ejecutada

Invocación: `Agrega a retencion-garantia.md lo que pasa con el tope mensual.`

Referencias de la respuesta: `entregables-laboratorio.instructions.md`, `CalculadoraLiquidacion.java`, `escenario/README.md`.

Respuesta del chat:

Agregué un hallazgo sobre el tope mensual dentro de `## Hallazgos`, con cita a las líneas 202 a 205 de `CalculadoraLiquidacion.java` y a la regla 6 del `README`, y no creé secciones nuevas.

Diff del archivo:

```diff
@@ -12,6 +12,7 @@
 - La tasa es 5 %, escrita como `0.05` dentro del cálculo ([CalculadoraLiquidacion.java:241](../../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java#L241)).
 - La retención se redondea a dos decimales y se resta en el monto neto ([CalculadoraLiquidacion.java:249](../../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java#L249), [Liquidacion.java:88](../../../../escenario/java/src/main/java/pe/pasarelaandina/modelo/Liquidacion.java#L88)).
 - La regla 7 dice que la retención es sobre «el monto neto». El código calcula la base antes de restar la retención misma, de modo que ambas lecturas coinciden en el resultado.
+- El tope mensual del plan se aplica antes de la retención: si el total de comisiones lo supera, se cobra el tope y se marca la liquidación ([CalculadoraLiquidacion.java:202-205](../../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java#L202-L205)). Coincide con la regla 6 de [escenario/README.md](../../../../escenario/README.md). Por eso la base de la retención usa las comisiones ya limitadas por el tope.
 
 ## Verificación
 
```

## Paso 4 - `/lab-2-4-paso-4-ajustar-y-documentar`

Modo: Agent

Pregunta del agente: ¿Qué falló en la prueba del paso 3?

Respuesta del participante: "Nada falló: la instrucción apareció en las referencias en las dos pruebas y el documento cumplió las reglas."

Respuesta final del chat:

Si no falló nada, no corrijo nada del comportamiento. Revisé `description`: decía qué fija la instrucción, pero no cuándo se aplica. La ajusté para que lo diga. Por ser una instrucción, no agrego sección «Cómo usarlo».

Diff del artefacto:

```diff
@@ -1,6 +1,6 @@
 ---
 name: 'Entregables de laboratorio'
-description: 'Fija estructura, tono, citas de archivo y línea y prohibiciones para los documentos Markdown que se entregan en los laboratorios (labs/**/entregables/**/*.md)'
+description: 'Se aplica sola al crear o editar un entregable Markdown de laboratorio (labs/**/entregables/**/*.md) y fija su estructura, tono, citas de archivo y línea y prohibiciones'
 applyTo: 'labs/**/entregables/**/*.md'
 ---
 
```

Cambio: `description` ahora dice que la instrucción se aplica sola al crear o editar un entregable Markdown de laboratorio, para que alguien que no estuvo en el taller entienda cuándo actúa.

Tiempo: 10 s (estimado)

## Estado final

`git status --short`:

```
?? .github/instructions/entregables-laboratorio.instructions.md
?? labs/cap2/lab-2-4-agente-o-instruccion/entregables/
```

`bash scripts/validar-skills.sh`: 37 skills revisadas, 0 con errores.
