# 0002. Servidor MCP local, de solo lectura y sin red

| Campo | Valor |
|---|---|
| Estado | Aceptada |
| Fecha | 2026-10-03 |
| Responsable | Equipo del taller |

## Contexto

El agente necesita consultar datos de comercios y de soporte que no están en el código. La
forma estándar de dárselos es un servidor MCP.

Las máquinas del taller no tienen salida a internet garantizada y no descargan nada en
clase. Un área de seguridad bancaria va a preguntar qué datos expone el servidor, con qué
permisos corre y quién aprueba cada llamada. Visual Studio Code advierte que un servidor
MCP local puede ejecutar código arbitrario en la máquina.

## Alternativas consideradas

- **Servidor remoto por HTTP.** Representa el caso de un servicio corporativo. Necesita red,
  credenciales y una aprobación de seguridad que el taller no puede obtener.
- **Servidor local que abre un puerto HTTP.** No necesita red externa. Obliga a validar el
  origen, a escuchar solo en la interfaz local y a autenticar las conexiones.
- **Sin MCP, el agente lee los archivos directamente.** Más simple. No enseña el protocolo
  ni su modelo de aprobación.
- **Servidor local por entrada y salida estándar, con permisos acotados por el proceso.** Sin
  red, sin puerto abierto y con una restricción que no depende del código del servidor.

## Decisión

Se usa un servidor MCP local en `mcp/servidor-local/`, por entrada y salida estándar,
configurado en `.vscode/mcp.json`. Se ejecuta con
`node --permission --allow-fs-read=.`, de modo que el proceso solo puede leer archivos del
repositorio: no puede escribir, lanzar procesos ni cargar complementos nativos. Registra tres
herramientas de consulta. Sus dependencias van con versión exacta y se precargan en la
imagen de la máquina virtual.

## Consecuencias

- El servidor funciona sin red, en cualquier sistema donde corra Node.
- Ningún otro programa de la máquina ni de la red puede hablarle al servidor.
- Cada llamada pide aprobación en Visual Studio Code, lo que permite leer los parámetros
  antes de enviarlos.
- No representa el flujo de autenticación de un servidor remoto. Eso se trata en la teoría.
- Si las dependencias no están en la imagen, el servidor no arranca.

## Verificación

`bash scripts/verificar-ambiente.sh` comprueba las dependencias con versión exacta y que el
servidor arranque y liste sus herramientas. El paso de inventario del laboratorio 3.4
compara lo que el servidor hace con lo que su README dice.
