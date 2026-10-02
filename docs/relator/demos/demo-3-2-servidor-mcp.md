# Demostración 3.2. El servidor MCP local

**Objetivo.** Arrancar un servidor MCP local sin red, aprobar sus herramientas y consultarlo
desde el chat.

**Subtema y sesión.** 3.2, sesión 3. **Duración.** 10 minutos.

**Antes de empezar.** Repositorio de participantes en su punto de partida, sin
`.vscode/mcp.json`. Si existe, `bash scripts/reiniciar-lab.sh lab-3-4` y responda `si`. Las dependencias
del servidor instaladas, verificadas con `bash scripts/verificar-ambiente.sh`.

**No toque la nota con inyección.** No consulte las notas de soporte de CM0005. Es material
del laboratorio 3.4.

## Pasos

1. Abra `mcp/README.md`. Muestre las tres herramientas y el comando de arranque con
   `--permission --allow-fs-read=.`.

   Diga: «Proceso local, entrada y salida estándar, sin red, solo lectura. El modelo de
   permisos de Node lo impone, no es una promesa del código.»

2. Cree la carpeta `.vscode` si no existe y, dentro, el archivo `mcp.json` con este
   contenido, desde el explorador de archivos.

   ```json
   {
     "servers": {
       "pasarela-andina": {
         "type": "stdio",
         "command": "node",
         "args": ["--permission", "--allow-fs-read=.", "mcp/servidor-local/servidor.js"],
         "cwd": "${workspaceFolder}"
       }
     }
   }
   ```

3. Menú **View**, **Command Palette**. Escriba `MCP: List Servers` y elija el comando.
   Elija `pasarela-andina` y **Start Server**.

   **Debería pasar.** El servidor queda iniciado. En el chat, el ícono de herramientas
   muestra las tres.

4. Chat en modo **Agent**. Escriba:

   ```
   Usa el servidor pasarela-andina para listar los comercios de categoría TURISMO y dame el plan de comisiones del primero de la lista.
   ```

   **Debería pasar.** Un diálogo de aprobación por cada llamada. Lea los parámetros en voz
   alta antes de aprobar con **Allow**.

   Diga: «Estas herramientas no declaran ser de solo lectura, a propósito. Si lo
   declararan, Visual Studio Code no pediría aprobación. Y esa declaración la hace el propio
   servidor.»

5. Muestre la respuesta y qué herramienta respaldó cada dato.

6. Al terminar, `bash scripts/reiniciar-lab.sh lab-3-4` y responda `si` para que el laboratorio empiece sin
   la configuración.

## Qué puede salir distinto

- Si el servidor no arranca, revise que la carpeta esté como espacio de trabajo de confianza
  y que el verificador esté en verde.
- Si el agente no usa las herramientas y lee los archivos, pídale explícitamente que use el
  servidor.
- Si algo demora, use [`../respaldos/demo-3-2.md`](../respaldos/demo-3-2.md).

## La idea que se cierra

MCP local es acceso a una fuente interna por un proceso controlado. Lo que se discute ante
seguridad no es MCP en general. Es qué expone este servidor, con qué permisos corre y quién
aprueba cada llamada.
