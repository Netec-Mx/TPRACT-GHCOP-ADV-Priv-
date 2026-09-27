# Laboratorio 3.4. Caso de uso de MCP local seguro con documentación técnica

## Objetivo del laboratorio

Configurar un servidor MCP local que corre sin salida a internet, aprobar y usar sus
herramientas desde el chat, y documentar el caso de uso con lo que haría falta para
presentarlo a un área de seguridad.

## Duración

45 minutos.

## Prerrequisitos

- `bash scripts/verificar-ambiente.sh` muestra en verde la sección «Servidor MCP local».
- Haber leído [`mcp/README.md`](../../../mcp/README.md).
- Punto de partida limpio. Desde la raíz del repositorio, en Git Bash:

  ```bash
  bash scripts/reiniciar-lab.sh lab-3-4
  ```

- Todos los pasos se hacen en modo **Agent**.

## Pasos

| Paso | Qué hacer | Qué observar | Tiempo |
|---|---|---|---|
| 1 | Escribe `/lab-3-4-paso-1-configurar-servidor`. Después, en la paleta de comandos (menú **View**, **Command Palette**), ejecuta **MCP: List Servers**, elige `pasarela-andina` y arráncalo | Que el servidor aparezca como iniciado y que el chat muestre sus tres herramientas | 8 min |
| 2 | `/lab-3-4-paso-2-consultar-con-herramienta CM0005` | Cada llamada a una herramienta pide tu aprobación. Lee qué parámetros envía antes de aprobar. Compara la respuesta final del agente con los datos que devolvió cada herramienta | 8 min |
| 3 | `/lab-3-4-paso-3-inventariar-superficie` | Si lo que el servidor hace coincide con lo que dice su README | 8 min |
| 4 | `/lab-3-4-paso-4-documentar-caso-de-uso` | Si el documento resistiría las preguntas de un área de seguridad | 12 min |

En el paso 2, si la respuesta del agente dice algo que no está en los datos que devolvieron
las herramientas, anótalo. El paso 4 te lo va a preguntar.

Los pasos 3 y 4 leen el código del servidor, así que funcionan aunque el paso 1 no haya
resultado.

## Resultado esperado

- `.vscode/mcp.json` con el servidor `pasarela-andina`.
- Una consulta resuelta con las herramientas del servidor, aprobadas una por una.
- `labs/cap3/lab-3-4-mcp-local/entregables/caso-de-uso-mcp.md` con sus cuatro secciones:
  datos que expone, herramientas que registra, riesgos y por qué es defendible.

## Criterios de revisión

- [ ] El servidor arranca desde Visual Studio Code y sus tres herramientas aparecen en el
      chat.
- [ ] Aprobaste cada llamada después de leer sus parámetros.
- [ ] Contrastaste la respuesta del agente con los datos que devolvieron las herramientas.
- [ ] El documento tiene las cuatro secciones y cada afirmación técnica cita archivo y
      línea.
- [ ] La sección de riesgos incluye la inyección indirecta, la ejecución sin revisión y el
      contenido que no debería llegar al contexto de Copilot.
