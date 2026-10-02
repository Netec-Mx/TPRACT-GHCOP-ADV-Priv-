---
name: lab-3-4-paso-1-configurar-servidor
description: 'Lab 3.4 paso 1. Crea la configuración de Visual Studio Code para el servidor MCP local del repositorio.'
disable-model-invocation: true
---

# Objetivo

Crear el archivo de configuración de Visual Studio Code que registra el servidor MCP
local del repositorio, para que sus herramientas aparezcan en el chat.

La descripción del servidor, su comando de arranque y sus permisos están en
[mcp/README.md](../../../mcp/README.md).

# Qué hacer

1. Si la carpeta `.vscode` no existe en la raíz del repositorio, créala. Después crea
   `.vscode/mcp.json` con un único servidor llamado `pasarela-andina`, de tipo
   `stdio`, que ejecute el comando de arranque de [mcp/README.md](../../../mcp/README.md) desde la raíz del
   repositorio. Usa `${workspaceFolder}` como directorio de trabajo.
2. Conserva el modelo de permisos de Node tal como lo indica el README. No amplíes los
   permisos.
3. Explica en tres líneas cómo arrancar el servidor desde Visual Studio Code con el
   comando **MCP: List Servers**, y dónde se ven sus herramientas.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Crea solo la carpeta `.vscode`, si falta, y el archivo `.vscode/mcp.json`. No modifiques el
  servidor ni sus datos.
- Ninguna variable de entorno ni secreto. El servidor no los necesita.

# Salida esperada

El contenido de `.vscode/mcp.json` y los pasos para arrancarlo y ver sus tres
herramientas.
