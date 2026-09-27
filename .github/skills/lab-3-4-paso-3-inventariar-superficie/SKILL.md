---
name: lab-3-4-paso-3-inventariar-superficie
description: 'Lab 3.4 paso 3. Inventaría qué datos expone y qué herramientas registra el servidor MCP local, leyendo su código.'
disable-model-invocation: true
---

# Objetivo

Saber exactamente qué expone el servidor MCP local, leyendo su código y no su
documentación.

- [servidor.js](../../../mcp/servidor-local/servidor.js)
- [mcp/README.md](../../../mcp/README.md)

# Qué hacer

1. Lista cada herramienta que el servidor registra, con sus parámetros, sus
   validaciones y lo que devuelve.
2. Lista cada archivo que el servidor lee, y si lee el archivo completo o una parte.
3. Busca en el código cualquier escritura en disco, conexión de red, ejecución de
   procesos o lectura de variables de entorno. Si no hay, dilo.
4. Compara lo que encontraste con lo que declara [mcp/README.md](../../../mcp/README.md). Señala cualquier
   diferencia.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques ningún archivo.
- No invoques las herramientas del servidor en este paso. Solo lee el código.

# Salida esperada

Dos tablas, herramientas y archivos leídos, y una lista de las diferencias con el
README, o la afirmación de que no hay ninguna.
