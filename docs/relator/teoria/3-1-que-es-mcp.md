# 3.1 Qué es MCP y cómo se relaciona con contexto, agentes y herramientas locales

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 3, sesión 3 |
| Duración | 45 minutos de exposición |
| Demostración | No tiene. La del servidor del taller está en el [3.2](../demos/demo-3-2-servidor-mcp.md) |
| Artefactos que se proyectan | `mcp/README.md`, `mcp/servidor-local/servidor.js` |

## La idea en una frase

MCP le permite al agente consultar una fuente en lugar de adivinar, y cada consulta es una
acción que alguien tiene que poder ver y aprobar.

## Contenido

### El problema: el agente adivina lo que no tiene

Los capítulos anteriores trabajaron con lo que el agente encuentra en el repositorio. El
código, las instrucciones, la documentación. Pero buena parte de lo que un desarrollador de
un banco necesita saber no está en el repositorio. Está en el catálogo de servicios, en el
esquema de una base de datos, en el sistema de tickets, en la documentación de una API
interna.

Cuando el agente no tiene ese dato, tiene dos caminos. Preguntar o suponer. Y suele suponer,
con la misma seguridad con que responde lo que sí sabe. El subtema 1.2 mostró que un
contexto pobre produce respuestas genéricas. Este subtema presenta la forma estándar de
ampliar el contexto más allá del repositorio sin pegar datos a mano en el chat.

### Qué es MCP, sin jerga

Model Context Protocol es, según su documentación, un estándar abierto para conectar
aplicaciones de inteligencia artificial con sistemas externos. La propia documentación usa
una comparación que funciona bien en la sala. MCP es al agente lo que un puerto USB-C es a
un equipo. Una forma única de conectar cosas distintas.

En términos concretos, un servidor MCP es un programa que ofrece consultas o acciones sobre
una fuente. El agente las ve como herramientas adicionales, al lado de las que ya tiene
para leer archivos, buscar o ejecutar comandos. Cuando la tarea lo necesita, el agente pide
usar una, Visual Studio Code le pasa el pedido al servidor y la respuesta entra al contexto
de la conversación.

Conviene insistir en lo que MCP no es. No es un modelo. No decide qué hace el agente con lo
que recibe. La documentación lo dice de forma explícita: el protocolo se ocupa del
intercambio de contexto y no dicta cómo la aplicación usa el modelo ni cómo maneja ese
contexto. Tampoco es, por sí mismo, un mecanismo de seguridad. Un servidor MCP hace lo que
su código hace, con los permisos del proceso que lo corre.

### Los tres participantes

La documentación de MCP describe tres piezas, y vale la pena nombrarlas una vez para que el
resto del capítulo se entienda.

- **El anfitrión.** La aplicación de inteligencia artificial que coordina todo. En el
  taller, Visual Studio Code.
- **El cliente.** Un componente dentro del anfitrión que mantiene la conexión con un
  servidor. El anfitrión crea un cliente por cada servidor configurado.
- **El servidor.** El programa que ofrece contexto. Puede correr en la misma máquina o en
  otra.

La documentación usa justamente a Visual Studio Code como ejemplo de anfitrión, y aclara que
«servidor MCP» se refiere al programa que sirve el contexto, sin importar dónde corre. Esa
distinción, local o remoto, es el tema del subtema 3.2.

### Lo que un servidor puede ofrecer

La especificación define tres tipos de cosas que un servidor expone.

- **Herramientas.** Funciones que el agente puede invocar para hacer algo. Consultar una
  base de datos, llamar a una API, leer un archivo.
- **Recursos.** Fuentes de datos que aportan contexto, como el contenido de un archivo o el
  registro de una base de datos.
- **Prompts.** Plantillas reutilizables para estructurar la interacción con el modelo.

En el taller importan las herramientas, porque son las que el agente invoca solo y las que
traen el riesgo. El servidor del laboratorio 3.4 registra tres, todas de consulta.

### Cómo decide el agente usar una herramienta

Este punto conecta con todo el capítulo 1. El agente no conoce las herramientas por
experiencia. Cuando se conecta a un servidor, el cliente le pide la lista de herramientas,
y cada una viene con un nombre, una descripción y el esquema de los parámetros que acepta.
Esa lista entra al contexto. El modelo decide si usar una herramienta según cómo encaja la
descripción con el pedido.

Tiene dos consecuencias prácticas.

**La descripción de una herramienta es parte del prompt.** Una descripción vaga produce un
agente que no usa la herramienta cuando debería, o que la usa cuando no debería. Es el mismo
criterio que el `description` de una skill o de un agente, visto en el capítulo 2.

**Cada servidor agrega contexto aunque no se use.** Las herramientas de todos los servidores
conectados se suman al registro que el modelo ve. Más servidores conectados, más contexto en
cada pedido. Por eso no conviene dejar conectado todo lo que existe por si acaso.

### Lo que devuelve una herramienta es contexto

La respuesta del servidor entra a la conversación como cualquier otro contexto, y el modelo
la lee y razona sobre ella. Esta frase, que parece obvia, es la base del subtema 3.3.

Si la respuesta tiene el dato correcto, el agente responde mejor que si hubiera adivinado.
Si la respuesta trae un dato equivocado, el agente lo repite con la misma seguridad. Y si la
respuesta trae texto que parece una instrucción, el modelo lo lee en el mismo canal que el
resto. El laboratorio 3.4 pide contrastar la respuesta final del agente con lo que devolvió
cada herramienta. Esa comparación es la verificación de este capítulo.

### La aprobación de cada llamada

Visual Studio Code pide confirmación antes de ejecutar una herramienta que no está aprobada
de antemano. La especificación de MCP lo pide también: debe haber siempre una persona en el
circuito, con la posibilidad de rechazar una invocación, y la aplicación debería mostrar qué
datos se envían al servidor antes de llamarlo, para evitar una fuga accidental o maliciosa.

El diálogo de aprobación muestra la herramienta y los parámetros. Esa es la parte que hay
que leer. No basta con saber qué herramienta es. Importa qué se le está mandando. Un
identificador de comercio está bien. Un párrafo entero de la conversación como parámetro de
búsqueda no.

Al aprobar, la documentación de Visual Studio Code ofrece varios alcances. Una sola vez,
durante la sesión, para el espacio de trabajo o para siempre.

**Qué significa «aprobar siempre».** La aprobación permanente se guarda en la configuración
del usuario y vale para todos los espacios de trabajo, no solo para el actual. Desde ese
momento, esa herramienta se ejecuta sin preguntar en cualquier proyecto que se abra. Es
cómodo y es exactamente lo que no conviene hacer con una herramienta que no se conoce. Las
aprobaciones guardadas se pueden borrar desde la paleta de comandos con **Chat: Reset Tool
Confirmations**.

La documentación describe además niveles de permiso para la sesión de chat. El nivel por
omisión pide confirmación según la configuración de aprobaciones. Hay otro, **Allow all**,
que ejecuta todas las llamadas sin confirmar, y Visual Studio Code advierte al elegirlo que
se saltan confirmaciones de acciones potencialmente destructivas, incluidas ediciones de
archivos, comandos de terminal y llamadas a herramientas externas. En el taller se trabaja
con el nivel por omisión, y en el laboratorio 3.4 se aprueba una llamada a la vez.

### Cómo se relaciona con lo que ya vimos

El temario pide relacionar MCP con contexto, agentes y herramientas locales. La relación es
directa.

- **Con el contexto.** MCP es una forma más de dar contexto, como `#file` o `#codebase`. La
  diferencia es que la fuente no es un archivo del repositorio y que el agente decide cuándo
  consultarla.
- **Con los agentes.** El modo agente es el que usa herramientas. Lo que el capítulo 2 dijo
  de los agentes personalizados vale aquí: las herramientas que un agente tiene disponibles
  son el límite de lo que puede hacer, y un servidor MCP agrega herramientas a ese conjunto.
- **Con las herramientas locales.** Leer archivos, buscar y ejecutar comandos son
  herramientas que trae el editor. Un servidor MCP local es un programa más que corre en la
  máquina y ofrece las suyas. El riesgo y el control son los de cualquier programa que se
  ejecuta en la máquina del desarrollador.

### El servidor del taller, como ejemplo concreto

Conviene proyectar `mcp/README.md`. Es un servidor pequeño, escrito para este taller, y sirve
de ejemplo porque se puede leer entero.

- Tres herramientas de consulta sobre los comercios de Pasarela Andina. Buscar comercios,
  ver el detalle de uno con su plan de comisiones y buscar notas de las áreas de soporte.
- Lee archivos del repositorio en cada consulta y no los modifica.
- Corre con el modelo de permisos de Node, que solo le permite leer archivos del
  repositorio. No puede escribir en disco ni lanzar otros procesos, y no abre conexiones de
  red.

Que un servidor diga en su README que es de solo lectura no es lo mismo que lo sea. En este
caso lo impone el proceso que lo corre, no la buena intención del código. El paso 3 del
laboratorio pide comprobar si lo que el servidor hace coincide con lo que su README dice.
Es la misma pregunta que haría un área de seguridad.

### Ejemplos en un banco

Para cerrar, vale proponer a la sala casos donde MCP tendría sentido en su trabajo, y para
cada uno preguntar qué expondría, con qué permisos y quién aprobaría las llamadas.

- **El catálogo de servicios internos.** El agente consulta qué endpoints existen y qué
  contrato tienen, en lugar de inventarlos.
- **El esquema de una base de datos de desarrollo.** El agente lee la estructura de las
  tablas para escribir una consulta, sin acceso a los datos.
- **La documentación técnica local.** El agente busca en las guías del equipo en lugar de
  responder con información genérica.

En los tres casos la pregunta de seguridad es la misma, y es la del capítulo. No se discute
MCP en general. Se discute este servidor, lo que expone, cómo corre y quién controla cada
llamada.

## Cómo se conecta

- **Demostración.** No tiene. La [demostración 3.2](../demos/demo-3-2-servidor-mcp.md)
  arranca el servidor del taller y muestra el diálogo de aprobación.
- **Laboratorio.** En el [3.4](../../../labs/cap3/lab-3-4-mcp-local/README.md) cada
  participante configura el servidor, aprueba cada llamada leyendo sus parámetros y compara
  la respuesta del agente con lo que devolvió cada herramienta.
- **Hilo del taller.** MCP amplía el contexto más allá del repositorio. La verificación del
  capítulo 1 se extiende: además de revisar qué archivos entraron, se revisa qué devolvió
  cada herramienta.

## Preguntas probables

**«¿MCP es de GitHub?»**
No. Es un estándar abierto, con su propia especificación y sus SDK. Visual Studio Code es uno
de los anfitriones que lo implementan.

**«¿El servidor MCP ve toda la conversación?»**
No por el protocolo. Recibe lo que el agente le envía como parámetros de cada llamada. Por
eso hay que leer los parámetros antes de aprobar.

**«¿Si apruebo una vez, queda aprobado?»**
Depende del alcance que se elija. Una sola vez, la sesión, el espacio de trabajo o siempre.
«Siempre» vale para todos los proyectos. Las aprobaciones guardadas se borran con **Chat:
Reset Tool Confirmations**.

**«¿Qué pasa si conecto diez servidores?»**
Las herramientas de todos se suman a la lista que ve el modelo, así que cada pedido lleva
más contexto, y el modelo tiene más opciones entre las cuales elegir mal. Conviene conectar
lo que la tarea necesita. En el taller, todo lo de MCP se hace en modo **Agent** y con un
solo servidor.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Estándar abierto para conectar aplicaciones de IA con sistemas externos, comparación con el puerto USB-C | https://modelcontextprotocol.io/docs/getting-started/intro | 2 de octubre de 2026 |
| Anfitrión, cliente y servidor, un cliente por servidor, Visual Studio Code como anfitrión, servidor local o remoto, herramientas, recursos y prompts, el protocolo no dicta cómo se usa el contexto | https://modelcontextprotocol.io/docs/learn/architecture | 2 de octubre de 2026 |
| Lista de herramientas con nombre, descripción y esquema, persona en el circuito con posibilidad de rechazar, mostrar los parámetros antes de llamar al servidor, anotaciones no confiables salvo de servidores confiables | https://modelcontextprotocol.io/specification/2026-07-28/server/tools | 2 de octubre de 2026 |
| Alcances de aprobación, «siempre» guardado para todos los espacios de trabajo, **Chat: Reset Tool Confirmations**, niveles de permiso y advertencia de **Allow all** | https://code.visualstudio.com/docs/agents/approvals | 2 de octubre de 2026 |
| Los servidores MCP locales pueden ejecutar código arbitrario | https://code.visualstudio.com/docs/agent-customization/mcp-servers | 2 de octubre de 2026 |
