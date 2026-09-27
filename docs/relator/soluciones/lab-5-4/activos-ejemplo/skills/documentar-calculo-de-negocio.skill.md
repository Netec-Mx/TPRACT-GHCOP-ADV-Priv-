---
name: documentar-calculo-de-negocio
description: 'Documenta cómo un componente de cálculo hace su trabajo según el código, y lo contrasta con las reglas de negocio declaradas. Úsala antes de refactorizar un cálculo de negocio, o cuando el equipo necesite un documento de referencia sobre cómo funciona hoy.'
disable-model-invocation: true
---

# Documentar un cálculo de negocio

Produce un documento Markdown que describa cómo el código calcula algo hoy, contrastado
contra la especificación de negocio, sin corregir ninguna discrepancia que encuentre.

# Cómo invocarla

Indica qué cálculo documentar y dónde vive el código
(COMPLETAR: por ejemplo, "el cálculo de comisiones, en `src/calculo/`").

# Qué hacer

1. Lee el código del cálculo de punta a punta: entradas, ramas, redondeos y salida.
2. Documenta el cálculo **tal como lo ejecuta el código**, paso a paso, en el orden en que
   ocurre: selección de regla o tramo aplicable, componentes del monto, ajustes, topes,
   descuentos y redondeo final.
3. Crea el documento en la ruta que indique quien invoca esta skill
   (COMPLETAR: ruta de destino sugerida, por ejemplo
   `docs/calculo/<nombre-del-calculo>.md`).
4. Al final del documento, agrega una sección **«Contraste con la especificación»** que
   compare lo documentado con el documento de reglas de negocio del equipo
   (COMPLETAR: ruta), regla por regla, marcando cada una como coincide, no coincide o no
   está especificada.

# Restricciones

- **No corrijas ninguna discrepancia que encuentres.** El objetivo es un mapa fiel de lo
  que existe, no una corrección. Una discrepancia entre código y especificación se reporta
  y se deja abierta para que el equipo decida cuál de las dos tiene razón.
- Crea un solo documento. No modifiques código ni comentarios del código.
- Cada afirmación sobre el cálculo cita el archivo y la línea que la respalda.

# Salida esperada

El documento creado y, en la respuesta del agente, cuántas reglas coinciden con el código
y cuántas no.

<!--
Origen: generalización de .github/skills/lab-4-4-paso-1-documentar-reglas/SKILL.md del
taller de GitHub Copilot, que documentaba el cálculo de comisiones de Pasarela Andina
contra escenario/README.md. El patrón (documentar el código como es, contrastarlo con la
especificación, no elegir ganador) es independiente del dominio: sirve para cualquier
componente de cálculo con una especificación de negocio separada del código. Completa las
rutas antes de usarla en tu repositorio.
-->
