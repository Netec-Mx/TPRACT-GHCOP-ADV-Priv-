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

El dominio es **Pasarela Andina**, una procesadora de pagos ficticia que liquida comisiones
a sus comercios afiliados. Las reglas de negocio están en `escenario/README.md` y son la
única fuente de verdad funcional.

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

### Lo que vas a encontrar y no debes arreglar

Esta lista no es exhaustiva, pero cubre lo que más tienta a un agente:

- **Montos en `double`.** Todo el dinero usa punto flotante y acumula errores de redondeo.
  Es el defecto principal del escenario. No lo migres a `BigDecimal` ni a `decimal`.
- **Un método de cálculo de casi trescientas líneas** con nueve niveles de anidamiento.
  No lo extraigas en métodos.
- **Números mágicos repetidos**, incluido un valor que difiere entre dos archivos. No los
  extraigas a constantes ni unifiques los que no coinciden.
- **`Date` y `Calendar`** en lugar de la API moderna de fecha y hora. No los migres.
- **Bloques `catch` vacíos.** No agregues registro ni relanzado.
- **Lógica duplicada** con una diferencia sutil entre las dos copias. No la unifiques.
- **Métodos cuyo nombre no describe lo que hacen**, incluido uno que consulta y además
  muta. No los renombres.
- **Pruebas que solo cubren getters y validaciones de formato.** No agregues pruebas de la
  lógica de negocio salvo que la tarea lo pida explícitamente.

### Cuidado con los comentarios del escenario

Hay comentarios que describen un comportamiento que el código no tiene. Son parte del
ejercicio.

Si un comentario contradice al código, **el código manda y las reglas de negocio de
`escenario/README.md` mandan sobre ambos**. No modifiques el código para que coincida con
un comentario, y no modifiques el comentario para que coincida con el código.

El caso más peligroso está en el plan de comisiones: un comentario afirma que los tramos
son acumulativos cuando la regla de negocio dice exactamente lo contrario. Un agente que
tome ese comentario como especificación va a reescribir el cálculo al revés.

**Por qué importa.** Si el escenario aparece corregido antes de la clase, el laboratorio
deja de existir y la sesión se cae. El costo de un arreglo bienintencionado aquí es una
actividad completa perdida frente a los participantes.

Si detectas un defecto que crees que no fue plantado a propósito, no lo toques: repórtalo
en tu respuesta y sigue con la tarea.

### Este repositorio va a producir hallazgos, y son esperados

Cualquier herramienta de análisis estático, linter, escáner de seguridad o revisión
automática que se ejecute sobre `escenario/` **va a reportar problemas**. Es inevitable y no
es un error de la herramienta: los problemas están ahí a propósito.

Ya ocurrió. Una revisión de seguridad automática se ejecutó sobre el escenario sin que
nadie la pidiera y reportó tres hallazgos, dos de los cuales eran defectos plantados y
documentados de antemano.

**Esos hallazgos no se corrigen.** Tampoco se silencian con anotaciones, supresiones ni
archivos de configuración que los oculten: el laboratorio necesita que el problema siga
siendo visible para quien abra el archivo.

Si una herramienta te reporta algo sobre `escenario/`, antes de tocar nada consulta
[`docs/04-defectos-plantados.md`](docs/04-defectos-plantados.md), que lista los diez
defectos intencionales con su archivo y su número de línea. Si el hallazgo corresponde a
uno de ellos, se deja como está y se informa que es intencional.

Si encuentras algo que **no** está en ese catálogo, tampoco lo corrijas por tu cuenta:
repórtalo y sigue con la tarea. Puede ser un defecto no intencional que haya que revisar.

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

Los laboratorios se ejecutan en máquinas virtuales accedidas por escritorio remoto. La
latencia medida es aceptable: las sugerencias cortas responden rápido y solo las
generaciones largas tardan algunos segundos. Lo que condiciona la clase es el escritorio
remoto y la necesidad de que todos los participantes obtengan resultados comparables:

- Los participantes no tipean textos largos. Los prompts de laboratorio viven en archivos
  del repositorio y se invocan desde el editor.
- No se copia ni se pega entre ventanas. Todo se ejecuta dentro del editor.
- Nada depende de descargas en tiempo de clase. Las dependencias van precargadas en la
  imagen de la máquina virtual.

Si vas a proponer un paso que exija descargar algo o escribir un prompt largo a mano,
no sirve en este contexto.
