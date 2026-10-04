---
name: lab-5-4-paso-3-estimar-evolutiva
description: 'Lab 5.4 paso 3, mantención evolutiva. Estima una evolutiva pedida por el negocio, sin implementarla.'
disable-model-invocation: true
---

# Objetivo

Estimar el siguiente cambio que pide el negocio, con lo aprendido en el ciclo. Es la
mantención evolutiva de [CICLO-DE-VIDA.md](../../../CICLO-DE-VIDA.md).

# Qué hacer

1. Anota en `docs/proyecto/registro-de-tiempos.md` la hora de inicio de Mantención
   evolutiva, con `date +%H:%M`, y `participante` en Origen.
2. Lee la solicitud [solicitud-evolutiva.md](../../../docs/proyecto/backlog/solicitud-evolutiva.md),
   la historia del reporte y el código del reporte en el stack de
   `scripts/integracion/stack.txt`.
3. Sigue la skill `pasarela-estimar` para una mantención evolutiva y crea
   `docs/proyecto/estimacion-evolutiva.md`. Usa como dato real el registro de tiempos del
   ciclo que acaba de terminar, y cítalo.
4. Lista las preguntas abiertas que habría que hacerle al negocio antes de implementarla.
5. Al terminar, anota en el registro de tiempos la hora de término de Mantención evolutiva.
   Su «Estimado con IA» es el de la fila «Mantención evolutiva» de
   `docs/proyecto/estimacion.md`, la estimación del 5.1, que mide este paso de estimar; si
   el registro no lo trae, cópialo de ahí. La estimación que acabas de hacer en
   `docs/proyecto/estimacion-evolutiva.md` es la de implementar la evolutiva y no va en el
   registro.
6. Propón el commit con la estimación evolutiva y el registro de tiempos, por ejemplo
   `git add docs/proyecto && git commit -m "Estimacion de la evolutiva"`, y espera la
   confirmación del participante. Tú no haces el commit.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No implementes la evolutiva. No modifiques código.

# Salida esperada

Muestra en el chat el contenido completo de `docs/proyecto/estimacion-evolutiva.md` y de
`docs/proyecto/registro-de-tiempos.md`, no un resumen. Después, las preguntas abiertas.

Escribe ese contenido en el texto de tu respuesta, como Markdown o en un bloque de código.
No basta con ejecutar `cat` o `git diff` en la terminal ni con decir que ya se ve en la
vista de una herramienta: el participante lo tiene que poder leer en tu respuesta.
