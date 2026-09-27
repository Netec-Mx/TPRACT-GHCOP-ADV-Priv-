# Preparación del ambiente

Documento de referencia para quien prepara la imagen de las máquinas virtuales del taller
y para el participante que valida su puesto antes de la primera sesión.

Los laboratorios se ejecutan sobre máquinas virtuales provistas por el cliente y accedidas
por escritorio remoto. Todo lo que aquí se lista debe quedar instalado y verificado en la
imagen **antes** de la clase. No hay tiempo de sesión disponible para instalar ni
descargar nada.

## 1. Especificación de la máquina virtual

| Recurso | Mínimo exigido |
|---|---|
| vCPU | 4 |
| Memoria RAM | 16 GB |
| Disco | Estado sólido (SSD o NVMe) |
| Espacio libre en disco | 20 GB |
| Sistema operativo | Windows 10/11, o distribución Linux con soporte vigente |
| Sesión | Escritorio remoto con resolución mínima 1920x1080 |

Los 16 GB de RAM no son holgura. Un IDE con Copilot activo, el escenario Java o .NET
compilando y el servidor MCP del capítulo 3 conviviendo en la misma máquina consumen
bastante más de 8 GB. Con menos memoria los laboratorios del capítulo 5 se vuelven
inviables.

El disco de estado sólido tampoco es opcional: la indexación del workspace que hace
Copilot sobre disco mecánico agrega minutos a cada operación, un costo que el presupuesto de tiempo de los
laboratorios no absorbe.

## 2. Herramientas requeridas

Hay dos listas y no conviene confundirlas. La primera es el piso con el que el taller es
viable y es lo que valida el script de verificación. La segunda es lo que se le pide al
proveedor de la máquina virtual, que es más exigente porque la imagen la construimos
nosotros y no hay razón para partir con versiones cercanas al fin de soporte.

### 2.1 Mínimos que exige el script de verificación

Es el piso, no la meta. Un participante que valide su propia máquina con estas versiones
puede seguir el taller sin quedar fuera.

| Herramienta | Versión mínima | Para qué se usa |
|---|---|---|
| Git | 2.40 | Clonar el repositorio y los laboratorios de revisión. Aporta además Git Bash, el intérprete de los scripts en Windows |
| JDK | 21 (LTS) | Escenario Java |
| SDK de .NET | 8.0 (LTS) | Escenario .NET |
| Node.js | 22 (LTS) | Servidor MCP local del capítulo 3, y lectura del perfil del editor en el script de verificación |
| Visual Studio Code | 1.116 | IDE principal del taller. Es la primera versión que trae GitHub Copilot integrado |
| curl | Cualquiera | Comprobación de conectividad. Viene con Git para Windows, macOS y Linux |

Apache Maven 3.9 se comprueba como recomendado en este punto del proyecto. Pasará a
obligatorio cuando el escenario Java lo necesite de verdad.

### 2.2 Versiones solicitadas para la imagen de la máquina virtual

Es lo que se pide al proveedor. JDK 21 recibe actualizaciones hasta septiembre de 2026 y
.NET 8 hasta noviembre de 2026, así que construir la imagen sobre ellos significa nacer a
meses del fin de soporte.

| Herramienta | Versión solicitada |
|---|---|
| Git para Windows | Última estable |
| JDK | 25 (LTS), última estable |
| Apache Maven | 3.9.11 o superior |
| SDK de .NET | 10.0 (LTS), última estable |
| Node.js | 24 (LTS), última estable |
| Visual Studio Code | Última estable |

Solo se necesita el stack del lenguaje que usará cada participante, pero si la imagen es
única para todo el grupo debe traer ambos.

### 2.3 Preparación al construir la imagen

El servidor MCP del laboratorio 3.4 depende de dos paquetes de npm, fijados con versión
exacta en `mcp/servidor-local/package.json` y `package-lock.json`. En clase no se descarga
nada, así que se instalan una sola vez al construir la imagen, con el repositorio ya
clonado y con acceso a internet, desde la raíz del repositorio:

```bash
npm ci --prefix mcp/servidor-local
```

`npm ci` instala exactamente lo que dice el archivo de bloqueo y falla si no coincide con
`package.json`. Las dependencias quedan en `mcp/servidor-local/node_modules/`, que no se
versiona.

El script de verificación comprueba que estén instaladas con la versión exigida y que el
servidor arranque. Si falta alguna, reporta la falla con este mismo comando.

### GitHub Copilot en Visual Studio Code

Copilot no se instala. Desde la versión 1.116, publicada en abril de 2026, GitHub Copilot
Chat viene integrada en Visual Studio Code como extensión del propio editor, y entrega
todas las funciones de Copilot: chat, sugerencias en línea y agentes.

Lo que sí hay que hacer es **habilitarla**, porque puede llegar deshabilitada. La primera
vez que se abre Visual Studio Code con un perfil de usuario nuevo, si Copilot todavía no
está configurado, el editor deshabilita la extensión integrada por su cuenta. En una
máquina virtual eso le pasa a cada participante que entra con su usuario por primera vez.

Mientras está deshabilitada no hay sugerencias en línea, no aparece el canal de salida de
Copilot y el editor no da ninguna señal clara de por qué. La sesión de GitHub puede estar
iniciada y el ambiente parece correcto.

Para habilitarla:

1. Abrir la vista de Extensiones (`Ctrl+Shift+X`).
2. Escribir `@builtin copilot` en el buscador. El filtro `@builtin` muestra las extensiones
   integradas, que no aparecen en la lista normal.
3. Seleccionar **GitHub Copilot Chat**.
4. Pulsar **Enable AI Features**. Con la interfaz en español el botón dice **Habilitar
   características de IA**. Si el botón que aparece es **Enable** (**Habilitar**), pulsar
   ese: el efecto es el mismo.
5. Iniciar sesión en GitHub desde el icono de Copilot de la barra de estado.

El botón del paso 4 no hace más que cambiar el ajuste `chat.disableAIFeatures` a `false`.
Se puede hacer también desde la configuración (`Ctrl+,`), buscando ese ajuste y dejando la
casilla desmarcada.

Después, **cerrar Visual Studio Code por completo** antes de ejecutar el script de
verificación. El editor no escribe el estado de las extensiones en disco en el momento en
que cambia, y el script lo lee desde disco.

### La extensión GitHub.copilot no se instala

`GitHub.copilot` era la extensión de las sugerencias en línea cuando Copilot estaba
repartido en dos extensiones. Está descontinuada: esa función la entrega hoy Copilot Chat,
y si el editor encuentra la extensión antigua instalada, la deshabilita con el mensaje
*All GitHub Copilot functionality is now being served from the GitHub Copilot Chat
extension*. En el marketplace sigue publicada, pero su última versión, la 1.388.0, es del
24 de octubre de 2025.

Intentar instalarla falla, y el error no dice por qué:

```
Installing extension 'github.copilot'...
Error while installing extension github.copilot-chat: Extension 'github.copilot-chat' is a
built-in extension with version '0.66.0' and cannot be downgraded to version '0.48.1'.
Failed Installing Extensions: github.copilot-chat
```

La razón es que `GitHub.copilot` es un paquete que arrastra a `GitHub.copilot-chat`, y la
versión publicada en el marketplace es anterior a la que viene integrada en el editor. Los
números de versión cambian con cada actualización de Visual Studio Code, pero el error es
el mismo. No hay nada que resolver: la extensión no hace falta.

### Otras extensiones

Deben venir instaladas en la imagen, no instalarse en clase.

| Extensión | Identificador |
|---|---|
| Extension Pack for Java | `vscjava.vscode-java-pack` |
| C# Dev Kit | `ms-dotnettools.csdevkit` |

Quien trabaje en Visual Studio 2022 o IntelliJ IDEA necesita el plugin de Copilot
equivalente ya instalado y con sesión iniciada.

## 3. Conectividad a internet

GitHub Copilot no funciona sin salida a estos dominios. Si la red corporativa filtra por
lista blanca, deben autorizarse antes de la clase.

### Dominios obligatorios

| Dominio | Función |
|---|---|
| `github.com` | Autenticación y flujo de inicio de sesión |
| `api.github.com` | API de GitHub, validación de la licencia de Copilot |
| `api.githubcopilot.com` | Endpoint principal de Copilot Chat |
| `*.githubcopilot.com` | Proxies por tipo de plan: `proxy.individual.githubcopilot.com`, `proxy.business.githubcopilot.com`, `proxy.enterprise.githubcopilot.com` |
| `copilot-proxy.githubusercontent.com` | Sugerencias de código en el editor |
| `default.exp-tas.com` | Servicio de configuración y experimentación del cliente de Copilot |

### Dominios recomendados

| Dominio | Función |
|---|---|
| `copilot-telemetry.githubusercontent.com` | Telemetría del cliente |
| `objects.githubusercontent.com` | Descarga de contenidos de repositorio |
| `marketplace.visualstudio.com` | Instalación y actualización de extensiones |
| `*.gallerycdn.vsassets.io` | CDN de paquetes de extensiones |

Notas sobre el filtrado. La inspección TLS con certificado corporativo rompe la conexión
del cliente de Copilot salvo que el certificado raíz esté en el almacén de confianza del
sistema y, en el caso de Node.js, declarado en `NODE_EXTRA_CA_CERTS`. Si hay proxy
autenticado, debe configurarse en VS Code en `http.proxy` y estar disponible como variable
de entorno para los procesos hijos.

El laboratorio del capítulo 3 usa un servidor MCP **local**, que se comunica por proceso
sobre entrada y salida estándar. Ese laboratorio no requiere salida a internet.

## 4. Licenciamiento

Cada participante necesita una licencia activa de GitHub Copilot asignada a su cuenta de
GitHub **antes** de la primera sesión. Sirve Copilot Business, Copilot Enterprise o una
licencia individual; lo que no sirve es llegar a clase con la asignación pendiente de
aprobación.

Puntos que conviene confirmar con el administrador de la organización:

- La cuenta de cada participante tiene la licencia asignada y ya aceptada.
- Las políticas de la organización habilitan Copilot Chat y el modo agente. Si están
  deshabilitados a nivel de organización, los capítulos 1, 2 y 5 no se pueden dictar.
- La política de exclusión de contenido no bloquea los directorios del taller. Es un tema
  que se trata en el subtema 3.3, pero si está mal configurada afecta desde el capítulo 1.
- La sesión de GitHub en el IDE está iniciada y persiste entre reinicios de la máquina
  virtual.

Verificación rápida por parte del participante: abrir Copilot Chat en VS Code y pedir
cualquier respuesta. Si responde, la licencia y la conectividad están bien.

## 5. Verificación automatizada

El repositorio incluye un script que comprueba todo lo anterior y reporta qué falta. No
instala ni modifica nada.

Es un único script para los tres sistemas. En Windows se ejecuta desde **Git Bash**, que
viene incluido en Git para Windows. Como Git ya es un requisito obligatorio del ambiente,
no se necesita instalar ningún intérprete adicional.

En macOS y Linux, desde la terminal:

```bash
bash scripts/verificar-ambiente.sh
```

En Windows, desde Git Bash (clic derecho en la carpeta del repositorio, «Open Git Bash
here»):

```bash
bash scripts/verificar-ambiente.sh
```

El script informa en su encabezado qué entorno detectó, de modo que quede registrado si
corrió sobre macOS, Linux o Git Bash.

Termina con código de salida cero cuando el ambiente está apto y distinto de cero cuando
falta cualquier requisito obligatorio, de modo que puede usarse como paso de validación
automática al construir la imagen.

Opciones disponibles:

| Opción | Efecto |
|---|---|
| `--sin-red` | Omite las comprobaciones de conectividad. Útil para validar la imagen antes de conectarla a la red del cliente. |
| `--perfil-vscode <dir>` | Directorio de datos de usuario de Visual Studio Code, cuando no es el de la instalación por omisión: modo portable o `--user-data-dir`. |
| `--ayuda` | Muestra el uso y termina. |
| `--version` | Muestra la versión del script y termina. |

### Cómo comprueba que Copilot está habilitado

Visual Studio Code no tiene una opción de línea de comandos que diga si las funciones de
IA están activas, y `code --list-extensions` no lista las extensiones integradas. El
script lee el perfil del usuario directamente, en los dos lugares donde el editor guarda
ese estado:

- El ajuste `chat.disableAIFeatures`, en la configuración de usuario y en
  `.vscode/settings.json` del repositorio, si existe.
- La lista de extensiones deshabilitadas del perfil, que vive en una base SQLite dentro de
  `User/globalStorage/state.vscdb`. La lee con el módulo `node:sqlite` de Node.js, de modo
  que no hace falta instalar un cliente de SQLite.

Reprueba si cualquiera de los dos indica que Copilot está deshabilitado, y también si no
puede leerlos. No aprueba nunca a ciegas.

El perfil se busca en `%APPDATA%\Code` en Windows, en
`~/Library/Application Support/Code` en macOS y en `~/.config/Code` en Linux.

Tiene tres límites conocidos:

- **Hay que cerrar Visual Studio Code antes de ejecutarlo** si se acaba de cambiar el
  estado. El editor guarda en disco con retraso, y el script lee lo que hay en disco.
- **Solo revisa el perfil por omisión.** Si el editor tiene perfiles adicionales, el
  script lo advierte.
- **No comprueba la sesión de GitHub ni la licencia.** Eso se confirma abriendo el chat y
  pidiendo cualquier respuesta, como indica la sección 4.

Si al ejecutarlo en Windows aparece un error que menciona `\r` o `$'\r': command not
found`, el problema son los finales de línea y está resuelto en
[02-troubleshooting.md](02-troubleshooting.md).
