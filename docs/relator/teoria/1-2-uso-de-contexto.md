# 1.2 Uso de contexto: archivos abiertos, selección de código, workspace y referencias específicas

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 1, sesión 1 |
| Duración | 30 minutos. 12 de exposición, 8 de demostración y 10 del caso de clase |
| Demostración | [Las referencias de contexto](../demos/demo-1-2-referencias-de-contexto.md) |
| Caso de clase | [`casos-de-clase/caso-02-configuracion-regional.md`](../casos-de-clase/caso-02-configuracion-regional.md) |
| Artefactos que se proyectan | La lista de referencias de una respuesta del chat, `escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java` |

## La idea en una frase

El modelo responde sobre lo que tiene en el contexto, y elegir qué entra es trabajo de
quien pide.

## Contenido

### El modelo no recuerda el proyecto

El modelo no guarda memoria del repositorio entre un pedido y otro. Cada vez que se le pide
algo, recibe un paquete de información, el contexto, y responde a partir de eso. Si el
archivo que importa no entró, el modelo no lo tiene en cuenta. Si entró el archivo
equivocado, responde sobre el equivocado con la misma seguridad.

Esto se ve en la demostración de este subtema con una pregunta sencilla sobre el
escenario, cómo se calcula la retención de garantía, hecha cuatro veces con contextos
distintos.

### Contexto implícito y contexto explícito

Visual Studio Code agrega contexto por su cuenta. Según su documentación, por omisión usa
el índice del espacio de trabajo para incluir automáticamente los archivos que considera
relevantes para la conversación. Es cómodo y suele funcionar. Pero no es controlable ni
igual para todos. Depende de qué archivos hay en el espacio de trabajo y de cómo se escribió
la pregunta.

El contexto explícito es el que pone quien pide. Hay varias formas, todas documentadas.

- **Referencias con numeral.** Se escribe `#` seguido del nombre de un archivo, de una
  carpeta o de un símbolo. `#file:` con la ruta adjunta ese archivo. Es la forma más precisa.
- **El repositorio completo.** `#codebase` le indica al modelo que use todo el código del
  espacio de trabajo como contexto. No significa que se envíen todos los archivos. El editor
  busca los relevantes en el índice.
- **Arrastrar y soltar.** Archivos o carpetas desde el explorador, desde la búsqueda o desde
  las pestañas del editor hacia la vista de chat.
- **El botón Add Context.** En la vista de chat, con opciones para archivos, carpetas y
  símbolos.
- **La selección.** Lo que está seleccionado en el editor entra como contexto, y es la base
  de comandos como `/explain` o del chat en línea sobre el código.
- **Contenido de la web.** `#fetch` trae una página, útil para documentación externa.

### Elegir la referencia según lo que se sabe

En un repositorio chico como el del taller, casi cualquier forma de dar contexto funciona.
En los repositorios del banco, con cientos de clases y varios módulos, la elección importa,
y conviene ordenarla según cuánto sabe quien pide.

Si se sabe qué archivo contiene la respuesta, se lo nombra con `#file:` y la ruta. Es lo
más preciso y lo más barato. Si se conoce el nombre de una clase o de un método pero no
dónde está, se lo referencia como símbolo, y el editor resuelve dónde vive. Si se sabe en
qué módulo está el tema pero no en qué archivo, se referencia la carpeta. Y si no se sabe
nada, recién ahí se pide el repositorio completo con `#codebase` o se deja que el agente
busque, sabiendo que la respuesta va a tardar más y que conviene revisar en la lista de
referencias qué encontró.

Esta escalera tiene un efecto secundario útil. Obliga a quien pide a pensar dónde está lo
que busca antes de preguntar, y muchas veces esa pregunta previa ya acota el problema.

### Los participantes del chat

Con `@` se invoca un participante, un asistente con conocimiento de un dominio. Los que
nombra la documentación vigente son `@vscode`, para el editor y su configuración,
`@terminal`, para preguntas de línea de comandos, y `@github`, para repositorios, issues y
pull requests.

### Lo que el temario menciona y ya cambió

Algunos materiales sobre Copilot, incluido el objetivo del capítulo en el documento del
temario, hablan de `/workspace`. Hoy no existe como comando. Lo que cumple esa función es
`#codebase`, o directamente el modo agente, que busca en el repositorio con sus propias
herramientas. Conviene decirlo con naturalidad, como ejemplo de lo rápido que cambia la
herramienta, sin presentarlo como un error del temario.

### Cómo se comprueba qué entró

Cada respuesta del chat tiene una lista de referencias que se puede desplegar. Ahí está lo
que el modelo tuvo en cuenta. Es la herramienta de verificación de este subtema. Ante una
respuesta rara, lo primero es mirar esa lista. Muchas veces la respuesta no está mal
razonada. Está razonada sobre otra cosa.

### Más contexto no es mejor contexto

La guía de ingeniería de contexto de Visual Studio Code advierte contra la sobrecarga. Un
contexto lleno de información que no ayuda a decidir diluye el foco del modelo, y además
aumenta el consumo de créditos. La recomendación es empezar chico, con lo más importante,
y mantenerlo al día, porque un contexto desactualizado produce sugerencias desactualizadas.

En la práctica eso tiene dos consecuencias simples. Referenciar el archivo que importa en
lugar de todo el repositorio cuando se sabe cuál es. Y abrir una conversación nueva cuando
cambia la tarea, porque el historial de la anterior también es contexto.

### El contexto que no se ve

Hay contexto que no está en ningún archivo y que igual cambia el resultado. El caso de clase
de este subtema, la configuración regional, lo muestra con cuatro niveles. Cuéntelo
después de la demostración, por niveles, como indica la
[guía del relator](../01-guia-del-relator.md), sección 7. La idea que deja es que el
entorno de ejecución también es una entrada del programa, y que saber qué preguntar se
aprende verificando.

## Cómo se conecta

- **Demostración.** La [demostración 1.2](../demos/demo-1-2-referencias-de-contexto.md) hace
  la misma pregunta sin referencia, con la referencia equivocada, con la correcta y con
  `#codebase`.
- **Caso de clase.** El caso 02 va a continuación de la demostración.
- **Laboratorio.** En el [1.5](../../../labs/cap1/lab-1-5-analisis-componente/README.md) las
  skills referencian el archivo exacto en cada paso. Es control de contexto explícito
  aplicado.
- **Hilo del taller.** Si el contexto es pobre, el resultado es genérico. El capítulo 2
  enseña a dejar el contexto escrito en el repositorio para que no dependa de quién pide.

## Preguntas probables

**«¿`#codebase` manda todo el repositorio al modelo?»**
No. Usa el índice del espacio de trabajo para elegir los archivos relevantes. Por eso
puede traer de más, como la versión .NET de una clase cuando la pregunta era por la de
Java, o de menos. Cuando se sabe qué archivo importa, conviene nombrarlo.

**«¿Los archivos abiertos en pestañas cuentan como contexto?»**
La guía de GitHub recomienda abrir los archivos relevantes o seleccionar el código como
forma de indicarle al modelo qué mirar. La forma de comprobar qué entró de verdad es la
lista de referencias de la respuesta.

**«¿Por qué a veces responde bien sin que le diga nada?»**
Porque el índice del espacio de trabajo encontró lo que hacía falta. En un repositorio
chico eso pasa seguido. En uno de mil clases, no tanto, y no se puede saber de antemano.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Índice del espacio de trabajo, referencias con `#`, `#codebase`, arrastrar y soltar, Add Context, `#fetch`, participantes con `@` | https://code.visualstudio.com/docs/chat/copilot-chat-context | 2 de octubre de 2026 |
| Participantes `@vscode`, `@terminal` y `@github` | https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet | 27 de septiembre de 2026 |
| Chat sobre el código seleccionado y comando `/explain` | https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet | 2 de octubre de 2026 |
| `/workspace` no figura entre los comandos vigentes | https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet | 27 de septiembre de 2026 |
| Evitar la sobrecarga de contexto, empezar chico, mantenerlo al día, más contexto aumenta el consumo de créditos | https://code.visualstudio.com/docs/agents/guides/context-engineering-guide | 2 de octubre de 2026 |
| Abrir los archivos relevantes o seleccionar el código, conversación nueva por tarea | https://docs.github.com/en/copilot/concepts/prompting/prompt-engineering | 2 de octubre de 2026 |
