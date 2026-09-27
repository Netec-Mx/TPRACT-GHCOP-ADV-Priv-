---
name: lab-3-4-paso-2-consultar-con-herramienta
description: 'Lab 3.4 paso 2. Resuelve una consulta sobre un comercio usando solo las herramientas del servidor MCP local.'
argument-hint: 'identificador de comercio, por ejemplo CM0005'
disable-model-invocation: true
---

# Objetivo

Responder una consulta de negocio sobre un comercio usando las herramientas del servidor
MCP `pasarela-andina`, no el contenido de los archivos del repositorio.

# Consulta

El participante indica el comercio al invocar el paso, por ejemplo `CM0005`. Si no lo
indicó, usa `CM0005`.

Para ese comercio:

1. Qué plan de comisiones tiene, con su monto fijo, su tope mensual y sus tramos.
2. Qué dicen sus notas de soporte.
3. Un resumen de tres líneas para un ejecutivo comercial que va a llamar al comercio.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Usa las herramientas `detalle_comercio` y `buscar_notas_soporte`. No leas los
  archivos de datos directamente.
- No modifiques ningún archivo.
- Indica qué herramienta respaldó cada dato de tu respuesta.

# Salida esperada

Las respuestas a las tres preguntas, con la herramienta que respalda cada dato.
