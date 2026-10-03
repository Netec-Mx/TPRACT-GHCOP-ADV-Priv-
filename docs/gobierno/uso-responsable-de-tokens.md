# Uso responsable de tokens

Guía de una página para el equipo de Pasarela Andina. Acompaña la regla 7 de la
[política de uso de IA](politica-uso-ia.md). No trae precios ni cantidades: esos valores
dependen del plan vigente de la organización.

## Qué consume y qué no

El uso de Copilot se cobra en créditos de IA, que se consumen por tokens de entrada, de
salida y en caché. El costo por token depende del modelo elegido. En los planes pagos, las
sugerencias en línea y las sugerencias de la próxima edición no consumen créditos. El chat,
el modo agente, la línea de comandos y el agente en la nube sí.

Todo lo que entra al pedido son tokens: el texto escrito, los archivos referenciados, las
instrucciones del repositorio, el historial de la conversación, la lista de herramientas y
lo que devuelve cada herramienta.

## Qué modo conviene según la tarea

| Tarea | Modo que conviene |
|---|---|
| Completar la línea o el bloque que se está escribiendo | Sugerencias en línea |
| Entender un método o una clase concreta | Chat con el archivo referenciado |
| Cambio acotado en uno o dos archivos conocidos | Chat en línea sobre la selección |
| Tarea de varios pasos o varios archivos | Agente, después de un plan |
| Consultar una fuente fuera del repositorio | Agente con la herramienta MCP necesaria y solo esa |

## Prácticas que bajan el consumo sin bajar la calidad

- **Acotar el contexto.** Referenciar el archivo que importa con `#file` en lugar de pedir el
  repositorio completo cuando se sabe dónde está la respuesta.
- **Planificar antes de ejecutar.** Pedir primero un plan con el agente Plan y revisarlo. Un
  plan corregido a tiempo evita una implementación que hay que rehacer.
- **No repetir pedidos pobres.** Si la respuesta no sirve, mejorar el pedido con objetivo,
  contexto, restricciones y salida esperada, en lugar de pedir lo mismo otra vez.
- **Una conversación por tarea.** Al cambiar de tema, abrir una sesión nueva. El historial
  anterior también se envía.
- **Solo las herramientas necesarias.** Desactivar desde **Configure Tools** las que la tarea
  no usa.
- **Compactar conversaciones largas** con `/compact`.
- **Elegir el modelo por la tarea**, no solo por el costo. Uno más liviano que obliga a
  rehacer el trabajo termina consumiendo más.
- **Instrucciones generales cortas.** Entran en todos los pedidos. Lo que es de un stack va en
  una instrucción por ruta.

## Cómo ver el consumo en Visual Studio Code

- El panel de estado de Copilot, desde la barra de estado, muestra el porcentaje usado de la
  asignación mensual.
- Al pasar el cursor sobre una respuesta del chat se ve lo que costó ese pedido.
- El control de la ventana de contexto, en la entrada del chat, muestra el total de la
  sesión.

## Fuentes

| Qué | Fuente | Consultada |
|---|---|---|
| Créditos por tokens, costo según el modelo, qué consume y qué no | https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing | 2 de octubre de 2026 |
| Prácticas para optimizar el uso y cómo ver el consumo | https://code.visualstudio.com/docs/agents/guides/optimize-usage | 3 de octubre de 2026 |
| Instrucciones de repositorio en todas las interacciones, sobrecarga de contexto | https://code.visualstudio.com/docs/agents/guides/context-engineering-guide | 2 de octubre de 2026 |
