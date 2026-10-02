# 4.1 Uso de Copilot para documentación técnica y generación de Markdown

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 4, sesión 4 |
| Duración | 20 minutos. 12 de exposición y 8 de demostración |
| Demostración | [La documentación contra la ejecución](../demos/demo-4-1-documentacion-contra-ejecucion.md) |
| Artefactos que se proyectan | `.github/agents/documentador.agent.md`, `escenario/java/src/main/java/pe/pasarelaandina/calculo/UtilidadesFecha.java` |

## La idea en una frase

El agente escribe documentación rápido y con buena forma, y por eso mismo hay que
verificarla contra lo que el código hace, no contra lo que el texto dice.

## Contenido

### Para qué sirve el agente en documentación

La documentación es una de las tareas donde el agente rinde más, y conviene decirlo sin
reservas antes de hablar de sus límites.

- **Dar forma.** Convertir notas sueltas, un hilo de correos o la salida de una reunión en un
  documento con encabezados, tablas y secciones coherentes.
- **Describir estructura.** Listar las clases de un módulo, sus responsabilidades y cómo se
  llaman entre sí. Es lectura de código, y el agente lee rápido.
- **Explicar un método.** Qué recibe, qué devuelve, qué casos borde trata. Visual Studio Code
  trae el comando `/doc` en el chat en línea, que genera comentarios de documentación sobre
  el código seleccionado.
- **Mantener el formato del equipo.** Con una plantilla y un agente como el Documentador del
  repositorio, todos los documentos salen con la misma estructura.

### Para qué no sirve, o no sin ayuda

Hay tres cosas que el agente no puede saber leyendo el código, y que suelen ser lo más
valioso de un documento técnico.

- **Por qué se decidió algo.** El código muestra la decisión, no la razón ni las
  alternativas descartadas. Si nadie se lo dice, el agente inventa una razón plausible.
- **Lo que el código debería hacer.** El agente describe el comportamiento. Si ese
  comportamiento no es el correcto, la documentación lo consagra como si lo fuera.
- **El contexto de operación.** Quién usa el sistema, qué pasa cuando falla, a quién se
  llama. Eso vive en las personas.

### Lo que el código declara y lo que el código hace

Este es el punto central del subtema, y prepara el laboratorio 4.4.

Un documento generado se arma con todo lo que el agente tiene en el contexto: el código, los
nombres de los métodos, los comentarios, los mensajes de commit, la documentación anterior.
Todas esas fuentes declaran cosas. Solo el código, al ejecutarse, las hace. Y las
declaraciones envejecen. Un comentario que fue cierto cuando se escribió deja de serlo
después de un cambio que nadie actualizó. Un nombre de método promete lo que hacía en su
primera versión.

El agente no distingue entre una declaración vieja y una vigente. Si un comentario dice una
cosa y el código hace otra, el documento puede repetir el comentario con una redacción
impecable. Por eso el agente Documentador del repositorio tiene escrita una regla en su
definición. La fuente es el código, los comentarios pueden estar desactualizados, y si el
código y las reglas de negocio no coinciden, el documento lo dice sin elegir cuál tiene
razón.

En el laboratorio 4.4 la sala va a documentar código real del escenario y a verificar
afirmaciones contra las líneas que cita. No adelante dónde mirar. La consigna es abrir dos o
tres de las líneas que el documento cita y compararlas con lo que dice.

### Cómo se verifica un documento generado

La guía de buenas prácticas de GitHub lo dice sin rodeos: Copilot es una herramienta capaz
de equivocarse, y lo que sugiere se valida siempre. Un documento no es la excepción. Hay
tres niveles, de menor a mayor esfuerzo.

1. **Contra la línea citada.** Cada afirmación relevante enlaza al archivo que la respalda,
   y se abre. Es lo mínimo, y es lo que pide el criterio del laboratorio.
2. **Contra las reglas de negocio.** En el taller, `escenario/README.md`. Si el documento
   describe un comportamiento que contradice una regla, eso es un hallazgo, no un error del
   documento.
3. **Contra la ejecución.** Se corren casos concretos y se compara la salida con lo que el
   documento dice que pasa. Es el nivel que usa la demostración.

### Lo que muestra la demostración

La demostración usa un método pequeño, `mesesEntre`, que calcula meses entre dos fechas. Se
pide al chat que lo documente y que anticipe el resultado de cuatro casos. Después se
ejecuta el método con esos mismos casos y se comparan.

Lo que conviene subrayar no es si el documento acertó. Puede acertar los cuatro. Lo que
importa es que, sin ejecutar, no había forma de saberlo. El documento se escribió leyendo; la
salida es lo que el código hace. Cuando no coinciden, manda la ejecución.

### Markdown como formato de trabajo

El agente escribe Markdown con naturalidad, y Markdown tiene ventajas para documentación
técnica que vive cerca del código. Es texto plano, se versiona en el mismo repositorio, se
revisa en pull request con el mismo diff que el código y se lee bien sin herramientas.
Cómo trasladarlo a la wiki del equipo es tema del subtema 4.3.

## Cómo se conecta

- **Demostración.** La [demostración 4.1](../demos/demo-4-1-documentacion-contra-ejecucion.md)
  compara la documentación de un método con su ejecución.
- **Laboratorio.** En el [4.4](../../../labs/cap4/lab-4-4-documentacion/README.md) cada
  participante documenta las reglas de cálculo de su escenario y verifica al menos tres
  afirmaciones contra el código.
- **Hilo del taller.** La documentación es un entregable más del agente, y se verifica igual
  que el código que genera.

## Preguntas probables

**«¿Puedo pedirle que documente todo el repositorio de una vez?»**
Puede, y el resultado va a tener buena forma. Pero nadie va a poder verificarlo entero.
Conviene documentar por módulo, y verificar cada parte antes de pasar a la siguiente.

**«¿Le creo a los comentarios del código?»**
Como una pista, no como una fuente. El comentario dice lo que alguien quiso que el código
hiciera en algún momento.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Comando `/doc` para generar comentarios de documentación desde el chat en línea | https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet | 2 de octubre de 2026 |
| Copilot puede equivocarse y lo que sugiere se valida siempre, revisar con cuidado, usar pruebas automatizadas para comprobar su trabajo | https://docs.github.com/en/copilot/get-started/best-practices | 2 de octubre de 2026 |
