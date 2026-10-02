# 2.1 Conceptos: agentes locales, skills, prompt files e instrucciones personalizadas

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 2, sesión 2 |
| Duración | 45 minutos. 35 de exposición y 10 de demostración |
| Demostración | [La jerarquía de personalización y las skills](../demos/demo-2-1-jerarquia-y-skills.md) |
| Artefactos que se proyectan | `.github/copilot-instructions.md`, `.github/instructions/`, `.github/agents/`, `.github/skills/pasarela-reglas-de-negocio/SKILL.md`, `AGENTS.md`, `.github/hooks/` |

## La idea en una frase

El contexto que el equipo quiere que el agente tenga siempre se escribe una vez en el
repositorio, y cada mecanismo de personalización decide cuándo ese contexto entra.

## Contenido

### Del pedido al repositorio

El capítulo 1 terminó con una observación. Cuando un equipo escribe bien sus pedidos, los
pedidos empiezan a repetirse. Las mismas restricciones, el mismo formato de salida, las
mismas reglas sobre qué no tocar. Si cada persona las escribe cada vez, el criterio del
equipo depende de quién escribe el pedido y de cuánto se acuerda ese día.

La personalización resuelve eso. Son archivos del repositorio que el editor le entrega al
agente sin que nadie los copie en el chat. Como son archivos, se versionan, se revisan en un
pull request y se discuten como cualquier otro código. Ese es el cambio de fondo del
capítulo. El criterio del equipo deja de vivir en la cabeza de alguien y pasa a vivir en el
repositorio.

Hay cinco mecanismos que conviene distinguir, porque cada uno entra al contexto en un
momento distinto. La demostración los muestra en el explorador de archivos del repositorio
del taller, dentro de `.github/`.

### Instrucciones de repositorio

`.github/copilot-instructions.md` es el archivo de instrucciones para todo el proyecto. La
documentación de Visual Studio Code lo describe como guía para todo el repositorio, y su
guía de ingeniería de contexto dice que se incluye automáticamente en todas las
interacciones del chat. Nadie lo invoca. Siempre está.

Por eso es el lugar para lo que vale en cualquier pedido. En el repositorio del taller dice
en qué idioma se responde, que el alcance de la tarea es el alcance del cambio, que el
código del escenario no se corrige por iniciativa propia y cómo se verifica que los dos
escenarios siguen siendo equivalentes. La demostración lo muestra con una pregunta sobre
los mensajes de commit que nadie respondió en el chat y que el agente responde bien igual.

### Instrucciones por ruta

Los archivos `.instructions.md` dentro de `.github/instructions/` llevan en su encabezado un
patrón, `applyTo`, que dice a qué archivos aplican. Según la documentación, Visual Studio
Code los adjunta cuando el agente crea o modifica un archivo que coincide con el patrón.
También pueden cargarse cuando su descripción coincide con la tarea, o adjuntarse a mano.

Sirven para las reglas que no valen en todo el repositorio. En el taller hay dos, una para
el escenario Java y otra para el .NET, cada una con la versión, la forma de compilar y
probar y las convenciones de su stack. El subtema 2.3 las trabaja a fondo.

### AGENTS.md

`AGENTS.md` es un formato que leen varias herramientas, no solo Visual Studio Code. La
documentación lo describe como un formato de guía de proyecto compartido entre agentes. Es
el lugar para lo que cualquier agente tiene que saber del repositorio, también fuera del
editor. El repositorio del taller tiene uno en la raíz.

### Skills

Una skill es una carpeta con un archivo `SKILL.md` y, si hace falta, recursos como
plantillas o scripts. La documentación de Visual Studio Code las define como carpetas de
instrucciones, scripts y recursos que el agente puede cargar cuando son relevantes para una
tarea especializada. Viven en `.github/skills/`, y el nombre de la carpeta coincide con el
campo `name` del encabezado.

Lo que distingue a una skill es cómo se carga. El agente lee primero solo el nombre y la
descripción de cada skill. Si la descripción coincide con lo que se está pidiendo, carga el
cuerpo del `SKILL.md`. Y solo si el cuerpo los referencia, carga los recursos adicionales.
Es una carga progresiva. El contexto no se llena con todas las skills del repositorio en
cada pedido.

Además de cargarse sola, una skill se invoca por su nombre escribiendo la barra en el chat.
Dos campos del encabezado controlan eso.

| Configuración | Se invoca con la barra | Se carga sola |
|---|---|---|
| Por omisión | Sí | Sí |
| `user-invocable: false` | No | Sí |
| `disable-model-invocation: true` | Sí | No |

El repositorio del taller usa las dos variantes a propósito. Las skills del dominio, como
`pasarela-reglas-de-negocio`, se cargan solas cuando el pedido es sobre comisiones o
liquidaciones. Las skills de laboratorio declaran `disable-model-invocation: true`, porque
un paso del laboratorio 5.2 no debe aparecer mientras se trabaja en el 1.5. Muestre las dos
en la demostración.

### Agentes personalizados

Un agente personalizado es un archivo `.agent.md` en `.github/agents/`. La documentación lo
define como una combinación de instrucciones, herramientas y un modelo opcional en una
configuración reutilizable para un rol específico. Se elige en el selector del chat. El
subtema 2.2 está dedicado a ellos.

### Hooks

Un hook es un comando que el editor ejecuta en momentos fijos del trabajo del agente, por
ejemplo antes de usar una herramienta, y que puede bloquear la acción. Viven en
`.github/hooks/`. La documentación los marca en vista previa. No son contexto para el
modelo. Son control. Se mencionan aquí para completar el mapa y se desarrollan en el
capítulo 3, donde la demostración del 3.3 muestra el hook del repositorio.

### Prompt files, un artefacto en retiro

Los prompt files, archivos `.prompt.md` en `.github/prompts/`, eran pedidos reutilizables que
se invocaban con la barra. Hay mucho material publicado que los recomienda.

La documentación vigente de Visual Studio Code dice que están descontinuados para las
sesiones Agent Host, que no los cargan. Siguen funcionando con el agente local por ahora,
pero el agente local se va a eliminar en una versión futura. La misma página ofrece una
migración, experimental y habilitada por omisión, que convierte los prompt files en skills.

Este taller lo vivió. Los treinta y cinco pasos de laboratorio se habían diseñado como
prompt files y se rehicieron como skills semanas antes del dictado. Cuéntelo como lo que
es, un ejemplo de la velocidad de cambio y no una queja. La lección para el equipo es una
pregunta que conviene hacerse antes de construir sobre cualquier artefacto. ¿Está en
retiro? La respuesta está en la documentación, y la documentación cambia.

### Agentes locales

El temario habla de agentes locales. Conviene precisar qué significa hoy. Visual Studio Code
distingue dónde corre una sesión de agente. Una sesión local trabaja sobre el espacio de
trabajo en la máquina del desarrollador. Un agente en la nube recibe una tarea y devuelve un
pull request. El taller trabaja con agentes que corren en la máquina, sobre el repositorio
abierto en el editor, porque es lo que se puede controlar con los mecanismos de este
subtema y porque es lo que el banco puede evaluar con sus políticas.

Dentro de la máquina, la documentación distingue además el agente local del entorno que
llama Agent Host. Es un detalle de implementación que importa por una sola razón, la que ya
se vio. Hay artefactos que uno carga y el otro no. Los que el taller usa, instrucciones,
skills, agentes y hooks, son los que la documentación vigente no marca en retiro.

### Cómo se combinan

Las instrucciones que aplican se suman. La documentación advierte que no hay que depender
de un orden ni de una regla de precedencia, porque el comportamiento puede variar según el
entorno. En la práctica, eso pide que las instrucciones no se contradigan. Si una regla
general y una regla por ruta dicen cosas distintas, el resultado no está garantizado.

La forma de comprobar qué entró es la misma del capítulo 1, la lista de referencias de la
respuesta. Ahí aparecen las instrucciones y las skills que el agente usó.

### Cuándo usar cada mecanismo

Un resumen para dejar en la pizarra, con el mismo criterio que usa el repositorio del taller.

| Mecanismo | Cuándo entra al contexto | Para qué sirve | Ejemplo del repositorio |
|---|---|---|---|
| `copilot-instructions.md` | Siempre | Reglas que valen en cualquier pedido | Idioma, alcance del cambio, cómo se verifica |
| `.instructions.md` | Cuando el agente toca un archivo que coincide con `applyTo` | Reglas de un stack o de una zona del repositorio | Convenciones de Java y de .NET |
| `AGENTS.md` | Lo leen varias herramientas | Lo que cualquier agente tiene que saber | Qué es el repositorio y qué no se corrige |
| Skill | Cuando la descripción coincide, o al invocarla | Un procedimiento con pasos y recursos | Reglas de negocio, verificar equivalencia, pasos de laboratorio |
| Agente | Cuando alguien lo elige | Un rol con foco y herramientas acotadas | Analista, tester, documentador, revisor, refactorizador |
| Hook | Antes o después de ciertas acciones del agente | Bloquear o permitir, sin depender del modelo | Protección de los datos del escenario |

### Lo que no va en la personalización

Todo lo que se escribe en estos archivos llega al modelo. La documentación de seguridad de
Visual Studio Code advierte que el contenido de los archivos del espacio de trabajo se envía
como contexto a los modelos y a las herramientas, y que eso puede exponer información
sensible como claves de API, credenciales o código propietario. De ahí sale una regla
simple. En una instrucción, una skill o un agente no se escriben secretos, nombres de
servidores internos, datos de clientes ni nada que no se mostraría en un pull request.

La segunda regla es de mantenimiento. La guía de ingeniería de contexto advierte que el
contexto desactualizado produce sugerencias desactualizadas. Una instrucción que nombra una
versión, una ruta o un comando que ya no existe hace daño en silencio. Por eso estos
archivos se revisan con el mismo cuidado que el código, y conviene que tengan dueño.

### La personalización también se revisa

Como son archivos del repositorio, la personalización entra por pull request. Eso tiene una
consecuencia que la sala va a apreciar. Un cambio en `copilot-instructions.md` cambia el
comportamiento del agente para todo el equipo, en todos los pedidos, desde el día en que se
integra. Merece la misma revisión que un cambio en la configuración de compilación. La
pregunta del revisor no es si la regla está bien escrita. Es qué va a hacer distinto el
agente mañana, y si alguien lo comprobó.

## Cómo se conecta

- **Demostración.** La [demostración 2.1](../demos/demo-2-1-jerarquia-y-skills.md) recorre
  `.github/`, muestra las instrucciones de repositorio activas sin invocarlas, invoca una
  skill del dominio por su nombre y cuenta la migración desde prompt files.
- **Laboratorio.** En el [2.4](../../../labs/cap2/lab-2-4-agente-o-instruccion/README.md)
  cada participante construye un agente o una instrucción para una tarea del equipo.
- **Hilo del taller.** El capítulo 1 enseñó a construir contexto en el pedido. Este capítulo
  enseña a dejarlo escrito en el repositorio, versionado y revisable, para que el criterio
  del equipo no dependa de quién escribe el pedido.

## Preguntas probables

**«¿Instrucción, skill o agente? ¿Cómo elijo?»**
Instrucción cuando es una regla que tiene que estar siempre, o siempre sobre cierto tipo de
archivo. Skill cuando es un procedimiento que se usa a veces, con pasos y recursos propios.
Agente cuando es un rol con su foco y sus herramientas acotadas, que alguien elige a
propósito.

**«¿Por qué no seguir con prompt files si funcionan?»**
Porque la documentación vigente dice que no se cargan en las sesiones Agent Host y que el
agente local donde funcionan se va a eliminar. Construir sobre ellos es construir sobre un
plazo.

**«¿Cómo sé si una skill se cargó?»**
Mirando la lista de referencias de la respuesta. Si no aparece, se puede invocar por su
nombre con la barra.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Instrucciones de repositorio, por ruta, `AGENTS.md`, `CLAUDE.md`, `applyTo`, carga por descripción, instrucciones aditivas sin orden garantizado | https://code.visualstudio.com/docs/agent-customization/custom-instructions | 2 de octubre de 2026 |
| `copilot-instructions.md` se incluye en todas las interacciones del chat | https://code.visualstudio.com/docs/agents/guides/context-engineering-guide | 2 de octubre de 2026 |
| Skills, carpeta con `SKILL.md`, ubicaciones, carga progresiva, invocación con la barra, `user-invocable` y `disable-model-invocation` | https://code.visualstudio.com/docs/agent-customization/agent-skills | 2 de octubre de 2026 |
| Agentes personalizados como instrucciones, herramientas y modelo para un rol | https://code.visualstudio.com/docs/agent-customization/custom-agents | 2 de octubre de 2026 |
| Hooks, ubicación y estado en vista previa | https://code.visualstudio.com/docs/agent-customization/hooks | 2 de octubre de 2026 |
| Prompt files descontinuados para Agent Host, agente local a eliminar, migración a skills | https://code.visualstudio.com/docs/agent-customization/prompt-files | 2 de octubre de 2026 |
| El contenido del espacio de trabajo se envía como contexto y puede exponer información sensible | https://code.visualstudio.com/docs/agents/security | 2 de octubre de 2026 |
| El contexto desactualizado produce sugerencias desactualizadas | https://code.visualstudio.com/docs/agents/guides/context-engineering-guide | 2 de octubre de 2026 |
| Sesiones locales y agentes en la nube que devuelven un pull request | https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet | 2 de octubre de 2026 |
