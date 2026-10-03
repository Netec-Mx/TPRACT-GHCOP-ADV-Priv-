---
name: pasarela-historia-de-usuario
description: 'Convierte una solicitud del negocio en una historia de usuario con preguntas abiertas y criterios de aceptación comprobables. Úsala cuando alguien pida escribir, refinar o revisar una historia de usuario a partir de una solicitud.'
---

# Historia de usuario a partir de una solicitud

La plantilla está en [historia-de-usuario.md](../../../docs/proyecto/plantillas/historia-de-usuario.md).
Las reglas de negocio vigentes están en [escenario/README.md](../../../escenario/README.md).

## Procedimiento

1. Lee la solicitud completa y las reglas de negocio.
2. **Antes de escribir criterios,** lista las preguntas abiertas: todo lo que la solicitud
   no dice y que cambia el resultado. Como mínimo revisa qué registros entran y cuáles no,
   qué pasa con los casos límite de cada regla que la solicitud toca, cómo se redondea, y
   contra qué se va a comprobar que los números son correctos. Muestra las preguntas y
   **detente**: pide a quien te invocó que las responda o que diga a quién preguntarlas.
3. Con las respuestas, escribe la historia con la plantilla. Cada criterio de aceptación es
   comprobable con un comando o una prueba y tiene un ejemplo con datos reales cuando las
   reglas lo permiten. Incluye criterios para los casos límite que aparecieron en las
   preguntas, con el valor esperado calculado a mano y la cuenta a la vista.
4. Lo que siga sin respuesta queda en la tabla de preguntas como «pendiente». No lo
   conviertas en un criterio por tu cuenta.
5. Al terminar, muestra en el chat el contenido completo de la historia, no un resumen.
   Quien te invocó tiene que revisar los criterios antes de seguir.

## Límites

- No inventes respuestas del negocio. Una suposición no es una respuesta.
- No escribas código. La historia describe qué y para qué, no cómo.
- Si las reglas de negocio no deciden un caso, dilo; no elijas una interpretación.
