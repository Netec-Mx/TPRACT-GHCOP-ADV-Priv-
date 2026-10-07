---
name: lab-3-4-paso-4-documentar-caso-de-uso
description: 'Lab 3.4 paso 4. Documenta el caso de uso del servidor MCP local para presentarlo a un área de seguridad.'
disable-model-invocation: true
---

# Objetivo

Producir el documento del caso de uso del servidor MCP local, con lo que un área de
seguridad necesita para aprobarlo o rechazarlo.

Fuentes: [servidor.js](../../../mcp/servidor-local/servidor.js), [mcp/README.md](../../../mcp/README.md) y [notas-soporte.json](../../../mcp/datos/notas-soporte.json).

# Qué hacer

Crea `labs/cap3/lab-3-4-mcp-local/entregables/caso-de-uso-mcp.md` con estas cuatro
secciones obligatorias, en este orden:

1. **Datos que expone.** Qué archivos lee, qué campos devuelve y si alguno es sensible.
2. **Herramientas que registra.** Nombre, parámetros y qué hace cada una.
3. **Riesgos.** Al menos estos tres, cada uno con su mitigación o con la declaración de
   que no está mitigado:
   - Inyección indirecta de instrucciones a través del texto que devuelve una
     herramienta.
   - Ejecución de herramientas sin revisión de quien usa el chat.
   - Contenido del repositorio que no debería llegar al contexto de Copilot.
4. **Por qué es defendible.** Qué controles técnicos lo sostienen: proceso local, un
   código que no abre conexiones de red, permisos de Node que impiden escribir y lanzar
   procesos, y aprobación de cada llamada. Qué tendría que cambiar para que deje de serlo.

Los permisos de Node no restringen la red. Que el servidor no salga a internet depende de
su código, y se comprueba leyéndolo. Inclúyelo en la sección de riesgos, con la mitigación
para un uso real: una regla de firewall o un contenedor sin red.

Si en el paso 2 el participante observó algo inesperado en una respuesta del agente,
pregúntale qué fue e inclúyelo en la sección de riesgos como evidencia.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Crea un solo archivo. No modifiques el servidor ni sus datos.
- Cada afirmación técnica cita el archivo y la línea que la respalda.

# Salida esperada

El documento creado, de no más de dos páginas, mostrado completo en el chat, no un resumen.
El participante lo revisa ahí antes de abrir el archivo.

Escribe ese contenido en el texto de tu respuesta, como Markdown o en un bloque de código.
No basta con ejecutar `cat` o `git diff` en la terminal ni con decir que ya se ve en la
vista de una herramienta: el participante lo tiene que poder leer en tu respuesta.
Aunque la herramienta que creó o editó el archivo ya muestre su contenido, cópialo igual en
tu respuesta. No escribas «mostrado arriba», «contenido completo:» ni un encabezado sin el
contenido debajo.
