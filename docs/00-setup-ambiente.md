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
Copilot sobre disco mecánico agrega minutos a cada operación, y la latencia del escritorio
remoto ya consume parte del presupuesto de tiempo de cada laboratorio.

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
| Node.js | 22 (LTS) | Servidor MCP local del capítulo 3 |
| Visual Studio Code | 1.95 | IDE principal del taller |
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

### Extensiones de Visual Studio Code

Deben venir instaladas en la imagen, no instalarse en clase. Las dos primeras no son
opcionales: si la imagen trae Visual Studio Code sin ellas, el script de verificación
reprueba el ambiente, porque un puesto así no sirve para este taller.

| Extensión | Identificador |
|---|---|
| GitHub Copilot | `GitHub.copilot` |
| GitHub Copilot Chat | `GitHub.copilot-chat` |
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
  que se trata en el capítulo 6, pero si está mal configurada afecta desde el capítulo 1.
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
| `--ayuda` | Muestra el uso y termina. |
| `--version` | Muestra la versión del script y termina. |

Si al ejecutarlo en Windows aparece un error que menciona `\r` o `$'\r': command not
found`, el problema son los finales de línea y está resuelto en
[02-troubleshooting.md](02-troubleshooting.md).
