# 3.2 Diferencia entre MCP local y MCP externo en ambientes restringidos

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 3, sesión 3 |
| Duración | 45 minutos. 35 de exposición y 10 de demostración |
| Demostración | [El servidor MCP local](../demos/demo-3-2-servidor-mcp.md) |
| Artefactos que se proyectan | `mcp/README.md`, el contenido de `.vscode/mcp.json` que crea la demostración |

## La idea en una frase

Un servidor local corre en la máquina y conversa solo con el editor. Uno externo vive en
la red y recibe datos por ella. En un banco, esa diferencia decide qué hay que aprobar y
ante quién.

## Contenido

### Local y externo no es un detalle de instalación

La documentación de MCP llama servidor a cualquier programa que ofrece contexto, sin
importar dónde corre. Lo que distingue a un servidor local de uno externo, o remoto, es el
transporte, la forma en que el editor y el servidor intercambian los mensajes. La
especificación vigente define dos.

- **Entrada y salida estándar.** El cliente lanza el servidor como un subproceso y se
  comunican por la entrada y la salida estándar de ese proceso, un mensaje por línea. No hay
  red de por medio.
- **HTTP transmitible.** Cada mensaje del cliente es un pedido HTTP POST a un punto de acceso
  del servidor, que puede responder por un flujo de eventos. Es lo que permite que el
  servidor esté en otra máquina.

La documentación de arquitectura agrega una observación que ayuda a entender el resto. Un
servidor local por entrada y salida estándar suele atender a un solo cliente. Uno remoto por
HTTP suele atender a muchos.

En Visual Studio Code, el archivo de configuración refleja esa diferencia. Un servidor de
tipo `stdio` se describe con el comando que lo arranca. Uno de tipo `http` se describe con
una URL.

### Qué cambia en la práctica

Conviene ordenar la diferencia en cuatro preguntas que cualquier equipo de seguridad va a
hacer.

**¿A dónde van los datos?** Con un servidor local, los parámetros de cada llamada pasan de un
proceso a otro dentro de la misma máquina. Con uno externo, salen por la red hacia donde esté
el servidor. Si el agente manda como parámetro un fragmento de código o un dato de un
cliente, ese dato cruza el perímetro.

**¿Quién se autentica y cómo?** Un servidor local no necesita autenticación de red, porque
nadie más puede hablarle. Un servidor remoto sí. La documentación de MCP indica que el
transporte HTTP admite tokens, claves de API y encabezados propios, y recomienda OAuth para
obtener los tokens. Eso significa credenciales que hay que emitir, guardar y revocar.

**¿Qué código corre y dónde?** Un servidor local es un programa que corre en la máquina del
desarrollador, con sus permisos. Visual Studio Code lo advierte de forma explícita: los
servidores MCP locales pueden ejecutar código arbitrario, y solo deben agregarse desde
fuentes confiables. Un servidor remoto corre en la infraestructura de otro. No ejecuta
código en la máquina, pero no se puede inspeccionar.

**¿Qué necesita la red?** Un servidor local no necesita salida a internet. Uno remoto
necesita que el proxy y el firewall permitan llegar a su dominio. En un banco, eso es una
solicitud de apertura con su propio proceso de aprobación.

### Por qué el taller usa un servidor local

La decisión tiene tres razones, y conviene decirlas en este orden.

**Porque el ambiente de clase no tiene salida a internet garantizada.** Las máquinas
virtuales tienen las dependencias precargadas y nada se descarga en clase. Un servidor
remoto dependería de la red del cliente, de su proxy y de credenciales que nadie va a
emitir para un taller.

**Porque reduce la superficie a una sola conversación.** La guía de buenas prácticas de
seguridad de MCP, entre las mitigaciones para servidores locales, recomienda usar el
transporte por entrada y salida estándar para limitar el acceso al cliente MCP. Ningún otro
programa de la máquina, ni de la red, puede hablarle al servidor.

**Porque se puede leer entero y se puede acotar.** El servidor del taller es pequeño y su
código está en el repositorio. Y se arranca con el modelo de permisos de Node, que solo le
permite leer archivos del repositorio. No puede escribir, no puede lanzar otros procesos y
no abre conexiones. La restricción no depende de que el código se porte bien. La impone el
proceso.

Esta última razón es la que más importa en un banco. Lo que se puede defender ante un área
de seguridad no es «el servidor promete no escribir». Es «el proceso no tiene permiso para
escribir».

### Local tampoco es automáticamente seguro

Hay que evitar que la sala salga con la idea de que local es seguro y remoto es peligroso.
La guía de seguridad de MCP dedica una sección completa al compromiso de servidores locales.
Los riesgos que nombra son la ejecución de código arbitrario, la falta de visibilidad sobre
lo que el servidor hace y la exfiltración de datos.

Las mitigaciones que propone son concretas y vale leerlas en voz alta.

- Pedir consentimiento explícito antes de conectar un servidor local, mostrando el comando
  exacto que se va a ejecutar.
- Ejecutar el servidor en un entorno aislado, con los privilegios mínimos.
- Usar el transporte por entrada y salida estándar.

El servidor del taller sigue esas tres. Visual Studio Code pide confianza en el espacio de
trabajo antes de arrancarlo, el comando está a la vista en `.vscode/mcp.json`, y corre con
permisos acotados.

Un caso que conviene mencionar porque se ve en la práctica. Un servidor local que, en lugar
de entrada y salida estándar, abre un puerto HTTP en la máquina. La especificación de MCP
advierte que en ese caso el servidor tiene que validar el origen de cada conexión, para
evitar que una página web le hable, escuchar solo en la interfaz local y autenticar las
conexiones. Un servidor local por HTTP mal configurado deja de ser local en la práctica.

### La configuración del espacio de trabajo es código

`.vscode/mcp.json` vive en el repositorio. Eso tiene un lado bueno, porque la configuración
se versiona y se revisa en pull request como cualquier otro archivo. Y tiene un lado que hay
que tener presente. Clonar un repositorio con un `mcp.json` es recibir la instrucción de
ejecutar un programa.

Visual Studio Code lo resuelve con la confianza del espacio de trabajo. Según su
documentación, los servidores del espacio de trabajo heredan esa confianza. Al confiar en
una carpeta, sus servidores pueden arrancar sin una confirmación adicional, incluso después
de que su configuración cambie. Por eso la documentación pide revisar la configuración MCP
del espacio de trabajo antes de confiar en un repositorio.

En la práctica de un equipo, eso significa que un cambio en `.vscode/mcp.json` merece la
misma revisión que un cambio en un script de despliegue.

### Lo que agrega el ambiente restringido

Un banco no es un ambiente de desarrollo abierto, y hay tres controles disponibles que
conviene conocer antes de que seguridad pregunte.

**La política de la organización.** GitHub permite a los administradores de una organización
habilitar o deshabilitar el uso de servidores MCP en Copilot con una política. Visual Studio
Code documenta además la gestión centralizada del acceso a servidores MCP mediante las
políticas de GitHub. No hay que prometer a la sala qué tiene configurado el banco. Hay que
decirles que la decisión existe y que es de la organización, no del desarrollador.

**El aislamiento del proceso.** Visual Studio Code puede ejecutar un servidor local por
entrada y salida estándar dentro de un entorno aislado que restringe su acceso al sistema de
archivos y a la red, en macOS y Linux. La documentación aclara que hoy no está disponible en
Windows, y que con el aislamiento activo las llamadas del servidor se aprueban
automáticamente porque corren en un entorno controlado. El taller no lo usa, por dos
razones. La imagen de las máquinas puede ser Windows, donde no está disponible, y la
aprobación automática quitaría de la demostración justamente el diálogo que se quiere
mostrar. El control que se muestra es el del propio proceso, con el modelo de permisos de
Node, que funciona igual en cualquier sistema.

**La salida a la red.** Un servidor externo solo funciona si la red lo permite. En un
ambiente restringido, esa es una barrera que obliga a que alguien decida. Es preferible a
que cada desarrollador conecte lo que encuentre.

### Cómo se presenta un caso de uso

El laboratorio 3.4 cierra con un documento para un área de seguridad, y esta parte de la
teoría lo prepara. Un caso de uso de MCP defendible responde cuatro cosas.

1. **Qué datos expone.** No «información de comercios», sino qué archivos o tablas lee y qué
   campos devuelve.
2. **Qué herramientas registra.** Cuáles son y qué hace cada una, verificado contra el
   código, no contra el README.
3. **Qué riesgos tiene.** Los del subtema 3.3, aplicados a este servidor.
4. **Por qué es defendible.** Con qué permisos corre, qué transporte usa, quién aprueba cada
   llamada y qué no puede hacer aunque quiera.

### Lo que muestra la demostración

La demostración arranca el servidor del taller en vivo. Primero el README y el comando de
arranque, después la configuración, después el servidor iniciado con sus tres herramientas y
por último una consulta que pide aprobación por cada llamada. Antes de aprobar, se leen los
parámetros en voz alta. Es el gesto que el laboratorio pide repetir, y el que conviene que
la sala se lleve.

## Cómo se conecta

- **Demostración.** La [demostración 3.2](../demos/demo-3-2-servidor-mcp.md) crea
  `.vscode/mcp.json`, arranca el servidor y consulta dos herramientas aprobando cada llamada.
- **Laboratorio.** En el [3.4](../../../labs/cap3/lab-3-4-mcp-local/README.md) cada
  participante repite la configuración y redacta el caso de uso con las cuatro secciones.
- **Hilo del taller.** La pregunta deja de ser si se puede usar MCP y pasa a ser qué servidor,
  con qué permisos y con qué control. Es una pregunta que el equipo puede responder con
  evidencia.

## Preguntas probables

**«¿Puedo conectar el servidor MCP de GitHub o de otro servicio desde el banco?»**
Depende de la política de la organización y de la red. La decisión es de la organización. Lo
que sí se puede hacer es preparar el caso de uso con las cuatro preguntas del laboratorio.

**«¿Un servidor local puede salir a internet?»**
Si su código lo hace y el proceso lo permite, sí. Local describe cómo habla con el editor,
no qué hace el programa. Por eso el del taller corre con un modelo de permisos que no le
permite abrir conexiones.

**«¿Por qué no se usa el aislamiento de Visual Studio Code en el taller?»**
Según su documentación, todavía no está disponible en Windows, y la imagen de las máquinas
puede ser Windows. Además, con el aislamiento activo las llamadas se aprueban solas, y el
laboratorio necesita que cada participante lea y apruebe cada llamada. En un equipo que
trabaja en macOS o Linux, es una opción que vale evaluar.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Transporte por entrada y salida estándar con subproceso lanzado por el cliente, mensajes por línea, HTTP transmitible con POST a un punto de acceso | https://modelcontextprotocol.io/specification/2026-07-28/basic/transports | 2 de octubre de 2026 |
| Servidor local o remoto según el transporte, uno o muchos clientes, autenticación por tokens, claves y encabezados, OAuth recomendado | https://modelcontextprotocol.io/docs/learn/architecture | 2 de octubre de 2026 |
| Servidor local por HTTP: validar el origen, escuchar solo en la interfaz local, autenticar | https://modelcontextprotocol.io/specification/2025-06-18/basic/transports | 2 de octubre de 2026 |
| Compromiso de servidores locales, consentimiento con el comando exacto, aislamiento con privilegios mínimos, transporte por entrada y salida estándar para limitar el acceso al cliente | https://modelcontextprotocol.io/docs/2026-07-28/tutorials/security/security_best_practices | 2 de octubre de 2026 |
| Código arbitrario, confianza del espacio de trabajo heredada, revisar la configuración antes de confiar, aislamiento en macOS y Linux y no en Windows, aprobación automática con aislamiento, gestión centralizada por políticas de GitHub | https://code.visualstudio.com/docs/agent-customization/mcp-servers | 2 de octubre de 2026 |
| Tipos `stdio`, `http` y `sse`, campos `command` y `url` | https://code.visualstudio.com/docs/agents/reference/mcp-configuration | 2 de octubre de 2026 |
| Política de servidores MCP en Copilot para organizaciones | https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-organization/manage-policies | 2 de octubre de 2026 |
