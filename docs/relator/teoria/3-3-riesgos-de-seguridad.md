# 3.3 Riesgos de seguridad: exposición de información, conectores no autorizados y fuga de contexto

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 3, sesión 3 |
| Duración | 45 minutos. 40 de exposición y 5 de demostración |
| Demostración | [El hook que protege los datos](../demos/demo-3-3-hook.md) |
| Artefactos que se proyectan | `docs/gobierno/politica-uso-ia.md`, `.github/copilot-instructions.md`, `.github/hooks/proteger-datos-escenario.json`, `.github/hooks/proteger-datos-escenario.js` |

## La idea en una frase

Todo lo que entra al contexto puede salir y todo lo que el agente lee puede influirlo, así
que los controles que valen son los que actúan antes de la acción, no los que se la piden.

## Contenido

### Por qué este subtema va después de MCP

Los subtemas anteriores mostraron que el agente consulta fuentes fuera del repositorio y que
esas consultas son acciones. Este reúne los riesgos y los controles. A los tres riesgos
del temario se suman dos que el laboratorio 3.4 pide incluir: la inyección indirecta y la
ejecución sin revisión. Cada riesgo va con un escenario concreto, porque un riesgo sin
escenario se olvida.

### Exposición de información

**Qué es.** Datos que no deberían estar en el contexto del agente, y que por estarlo
terminan en una respuesta, en un archivo generado o en un parámetro enviado a otro sistema.

**Escenario.** Se le pide al agente que genere datos de prueba para una clase que procesa
comercios. Para que se parezcan a los reales, el agente lee el archivo de comercios del
escenario y copia registros completos, con razón social y registro tributario, a un archivo
de pruebas nuevo. El archivo se versiona. En un banco, lo mismo con un extracto de
producción que alguien dejó en una carpeta del repositorio.

**Qué lo reduce.** No tener datos reales en el repositorio y revisar el diff de lo que el
agente crea. Visual Studio Code recuerda que el contenido de los archivos, la salida de la
terminal y los diagnósticos se envían como contexto a los modelos y a las herramientas, y
propone exigir aprobación manual para editar archivos sensibles con el ajuste
`chat.tools.edits.autoApprove`.

### Conectores no autorizados

**Qué es.** Un servidor MCP, una extensión o cualquier integración que alguien conecta al
agente sin que la organización lo haya evaluado.

**Escenario.** Un desarrollador encuentra en internet un servidor MCP que consulta la base
de datos con lenguaje natural, lo agrega al `.vscode/mcp.json` del equipo y nadie revisa el
pull request con atención, porque es configuración. Cada compañero que confía en la carpeta
lo ejecuta en su máquina. Visual Studio Code advierte que un servidor local puede ejecutar
código arbitrario, y que los del espacio de trabajo heredan la confianza de la carpeta.

**Qué lo reduce.** La política de la organización sobre servidores MCP en Copilot. La revisión
de `.vscode/mcp.json` con el mismo cuidado que un script de despliegue. Y la regla de equipo
de no confiar en una carpeta sin mirar antes su configuración.

### Fuga de contexto

**Qué es.** Información del contexto que sale hacia un sistema que no debería recibirla,
casi siempre como parámetro de una herramienta.

**Escenario.** El agente tiene en el contexto la clase que calcula las comisiones y una
herramienta de búsqueda externa conectada. Para buscar cómo mejorar el reporte, manda como
parámetro un fragmento de la clase. La lógica de negocio salió de la red sin que nadie lo
pidiera. Visual Studio Code nombra una variante, el encadenamiento de salidas: lo que
devuelve una herramienta es la entrada de otra.

**Qué lo reduce.** Leer los parámetros en cada diálogo de aprobación. La especificación de MCP
pide justamente que la aplicación muestre los datos que se enviarán antes de llamar al
servidor, para evitar la exfiltración accidental o maliciosa. Y no conectar herramientas
externas que la tarea no necesita.

### Inyección indirecta

**Qué es.** El modelo lee todo el contexto por el mismo canal. El pedido de la persona, las
instrucciones del repositorio, el contenido de un archivo y la respuesta de una herramienta
llegan como texto. Si una fuente que el agente consulta contiene texto escrito como una
orden, el modelo puede tratarlo como una orden. Nadie le habló al agente directamente. La
instrucción llegó escondida en un dato, y por eso se llama indirecta.

Visual Studio Code da un ejemplo: una instrucción oculta en lo que devuelve un servidor MCP o
una página consultada con `#fetch`.

**Escenario.** Un equipo usa una herramienta que lee los comentarios de los tickets de
incidentes para ayudar a diagnosticar. Un comentario, escrito por alguien externo en un
formulario de soporte, incluye un párrafo dirigido al asistente que pide incluir en la
respuesta el contenido de un archivo de configuración. El desarrollador que pidió un
diagnóstico recibe una respuesta que hace algo más, y si no la compara con los datos, no lo
nota.

**Qué lo reduce.** Tres hábitos, ninguno técnico. Comparar la respuesta final del agente con
lo que devolvió cada herramienta, que es lo que pide el laboratorio. Desconfiar de una
respuesta que propone algo que no se pidió. Y no aprobar de forma permanente herramientas
que traen texto escrito por terceros.

No adelante en este punto qué va a encontrar la sala en el laboratorio. La idea es que el
participante reconozca el patrón por su cuenta.

### Ejecución sin revisión

**Qué es.** Acciones que el agente ejecuta sin que nadie las mire, porque se aprobaron de
forma permanente o porque la sesión corre con todos los permisos.

**Escenario.** Para no responder diálogos, un desarrollador aprueba «siempre» la herramienta
de terminal en su primer día. Esa aprobación vale para todos sus proyectos. Tres semanas
después, en otro repositorio, el agente ejecuta un comando de limpieza sobre una carpeta
equivocada.

**Qué lo reduce.** No aprobar siempre lo que no se conoce. Borrar las aprobaciones guardadas
con **Chat: Reset Tool Confirmations**. Y, del lado de la organización, los controles de
empresa que Visual Studio Code documenta: deshabilitar la aprobación automática global,
limitar los servidores MCP a registros curados, bloquear herramientas aportadas por
extensiones y exigir aprobación manual para herramientas de alto riesgo.

### La exclusión de contenido y su límite

GitHub permite excluir archivos y rutas para que Copilot no los use. La configuran los
administradores del repositorio y los dueños de la organización o de la empresa. Es la primera respuesta que
un área de seguridad espera, y por eso hay que mostrar su límite con las palabras exactas de
la documentación de GitHub.

> Content exclusion is currently not supported in Edit and Agent modes of Copilot Chat in
> Visual Studio Code and other editors.

Es decir, no se aplica hoy en los modos Edit y Agent, los que usa este taller. La
documentación agrega dos límites.

> Currently, content exclusions do not apply to symbolic links (symlinks) and repositories
> located on remote filesystems.

> It's possible that Copilot may use semantic information from an excluded file if the
> information is provided by the IDE indirectly.

La conclusión para la sala no es que la exclusión no sirva. Es que no alcanza como control
único cuando se trabaja con agentes, y que lo sensible no debería estar en el repositorio
de trabajo.

### Hooks: controlar antes de la acción

Las instrucciones le piden al agente que no haga algo. Un hook se lo impide.

Según Visual Studio Code, los hooks ejecutan acciones en puntos del ciclo de vida del
agente, para validar operaciones, dejar registro o aplicar políticas, con independencia del
modelo. Uno de esos puntos es antes de cada herramienta.

Conviene proyectar el hook del repositorio. Son dos archivos en `.github/hooks/`.

- **El JSON** declara que, antes de cada herramienta, se ejecuta un script de Node.
- **El script** recibe la llamada, mira si la herramienta escribe o si es un comando de
  terminal, y si apunta a `escenario/datos/` responde con una decisión de rechazo y un
  mensaje. Todo lo demás pasa.

La demostración pide al agente que agregue una línea a ese archivo de datos y muestra el
bloqueo. Después pide leerlo y muestra que leer sí está permitido.

Hay tres cosas que decir con honestidad sobre este control.

**Es una función en vista previa.** La documentación lo indica. Por eso la demostración
tiene un plan alternativo y el verificador del ambiente lo comprueba.

**Es un filtro por patrón.** El script reconoce los nombres de herramientas y los comandos
que conoce. Una forma de escribir que no esté en su lista pasaría. Un hook es un control
razonable, no un perímetro.

**Es código que se ejecuta.** La documentación advierte que los hooks corren con los permisos
del proceso que los ejecuta y pide revisarlos antes de usarlos, en especial en un repositorio
compartido. Un hook también se revisa en pull request.

### El aislamiento como control más fuerte

Visual Studio Code documenta el aislamiento del agente como la protección más fuerte contra
comandos de terminal maliciosos. Restringe el sistema de archivos y la red de los comandos
que el agente ejecuta, en macOS y Linux, y en Windows es experimental.

Tiene límites que también están documentados. No cubre las herramientas de archivos
integradas del editor. Y detener una sesión o restaurar un punto anterior no revierte los
comandos de terminal ya ejecutados ni los pedidos de red ya enviados.

A esto se suma la confianza del espacio de trabajo. Una carpeta abierta en modo restringido
deshabilita los agentes.

### De la política a los controles

Una organización no empieza por los controles. Empieza por una política, y la convierte en
reglas que el agente sigue y en controles que lo bloquean. El repositorio trae un ejemplo:
la política de uso de IA de Pasarela Andina, en `docs/gobierno/politica-uso-ia.md`. Es de la
empresa ficticia del escenario y está hecha para adaptarla.

Tiene ocho reglas, y cada una dice qué mecanismo la aplica. Conviene proyectarla y recorrer
tres columnas mentales.

- **Lo que se pide con instrucciones.** No escribir secretos ni datos personales, no
  proponer servidores MCP nuevos, no hacer commits. Están en la sección «Gobierno» de
  `.github/copilot-instructions.md`, que entra en todos los pedidos. El agente las sigue casi
  siempre, y casi siempre no alcanza para lo que no puede pasar.
- **Lo que se impone en el repositorio.** Los datos del escenario no se modifican. Lo impone el
  hook que se ve en la demostración.
- **Lo que depende de la organización.** La cuenta y el plan, la exclusión de contenido, la
  política de servidores MCP, la protección de la rama principal, las métricas y los
  presupuestos. El repositorio no puede imponerlas, y la política lo dice en lugar de
  aparentarlo.

La pregunta para la sala es cuál de sus reglas reales está hoy solo en un documento, y qué
haría falta para que alguna se impusiera.

### Lo que va a preguntar un área de seguridad

Vale cerrar el subtema ensayando la conversación. Estas son las preguntas probables y lo que
el material permite responder.

| Pregunta | Qué se puede responder |
|---|---|
| ¿Podemos impedir que Copilot lea ciertos archivos? | Existe la exclusión de contenido, configurada por administradores. Hoy no se aplica en los modos Edit y Agent. Lo sensible no debería estar en el repositorio |
| ¿Podemos controlar qué servidores MCP se usan? | Hay una política de organización para servidores MCP en Copilot y gestión centralizada documentada por Visual Studio Code |
| ¿Podemos impedir que el agente ejecute sin aprobación? | Hay controles de empresa para deshabilitar la aprobación automática global y exigir aprobación manual en herramientas de alto riesgo |
| ¿Podemos bloquear una acción concreta? | Con un hook, versionado en el repositorio, como el del taller. Está en vista previa |
| ¿Qué puede hacer el servidor MCP del taller? | Leer archivos del repositorio. El proceso no puede escribir, lanzar procesos ni abrir conexiones |

Hay preguntas que el relator no debe responder: qué se hace con los datos enviados, cuánto
tiempo se conservan, qué cumplimiento normativo se aplica. Esas respuestas están en la
documentación de GitHub sobre el manejo de datos y en el contrato del banco, y las da el
equipo de cuenta, no el taller.

## Cómo se conecta

- **Demostración.** La [demostración 3.3](../demos/demo-3-3-hook.md) muestra el bloqueo de una
  escritura y la lectura permitida sobre el mismo archivo. Es la regla 3 de la política,
  impuesta por un hook.
- **Laboratorio.** En el [3.4](../../../labs/cap3/lab-3-4-mcp-local/README.md) la sección de
  riesgos del caso de uso debe incluir la inyección indirecta, la ejecución sin revisión y el
  contenido que no debería llegar al contexto.
- **Hilo del taller.** La verificación no es solo revisar el código que entrega el agente.
  También es revisar qué leyó, qué envió y qué se le permitió hacer.

## Preguntas probables

**«¿Copilot entrena con nuestro código?»**
No es una pregunta que se responda en el taller. Está en la documentación de GitHub sobre el
manejo de datos y en el contrato. Derive al equipo de cuenta.

**«¿Un hook puede registrar todo lo que hace el agente?»**
La documentación nombra la creación de registros de auditoría como uno de sus usos. El del
taller no registra. Solo decide si deja pasar una acción.

**«Si la exclusión no funciona en modo agente, ¿cómo protejo un archivo?»**
No teniéndolo en el repositorio de trabajo, y con controles que actúan antes de la acción,
como un hook o el aislamiento.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Contexto enviado a modelos y herramientas, `chat.tools.edits.autoApprove`, inyección por salidas de herramientas con instrucción oculta de MCP o `#fetch`, encadenamiento de salidas, aislamiento como protección más fuerte contra comandos maliciosos, modo restringido deshabilita agentes, controles de empresa | https://code.visualstudio.com/docs/agents/security | 2 de octubre de 2026 |
| Aislamiento de sistema de archivos y red, plataformas, no cubre herramientas de archivos integradas, detener o restaurar no revierte comandos ni pedidos de red | https://code.visualstudio.com/docs/agents/concepts/trust-and-safety | 2 de octubre de 2026 |
| Exclusión de contenido, configuración por administradores del repositorio y dueños de organización o empresa, citas textuales sobre Edit y Agent, enlaces simbólicos e información semántica | https://docs.github.com/en/copilot/concepts/context/content-exclusion | 2 de octubre de 2026 |
| Hooks: definición, uso para auditoría y políticas, `.github/hooks/`, decisión de rechazo, vista previa, `chat.useHooks` habilitado por omisión, advertencia de permisos | https://code.visualstudio.com/docs/agent-customization/hooks | 2 de octubre de 2026 |
| Planes con gestión centralizada y políticas, base de la regla de cuentas de la política | https://docs.github.com/en/copilot/get-started/plans | 3 de octubre de 2026 |
| Código arbitrario en servidores locales, confianza heredada del espacio de trabajo | https://code.visualstudio.com/docs/agent-customization/mcp-servers | 2 de octubre de 2026 |
| Mostrar los datos antes de llamar al servidor para evitar la exfiltración | https://modelcontextprotocol.io/specification/2026-07-28/server/tools | 2 de octubre de 2026 |
| **Chat: Reset Tool Confirmations**, aprobación permanente | https://code.visualstudio.com/docs/agents/approvals | 2 de octubre de 2026 |
| Política de servidores MCP en Copilot | https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-organization/manage-policies | 2 de octubre de 2026 |
