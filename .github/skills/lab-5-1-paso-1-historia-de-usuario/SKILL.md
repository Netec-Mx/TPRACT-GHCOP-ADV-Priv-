---
name: lab-5-1-paso-1-historia-de-usuario
description: 'Lab 5.1 paso 1, fase de Requerimientos. Convierte la solicitud del área comercial en una historia de usuario con preguntas abiertas y criterios de aceptación.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Convertir la solicitud del área comercial en la historia de usuario que el equipo va a
construir en el capítulo 5. Es la fase de Requerimientos de
[CICLO-DE-VIDA.md](../../../CICLO-DE-VIDA.md).

El participante indica su stack al invocar el paso, con `java` o `dotnet`. Si no lo indicó,
pregúntale cuál usa y no hagas nada más hasta que responda.

Material de partida:

- [La solicitud](../../../docs/proyecto/backlog/solicitud-area-comercial.md)
- [Las reglas de negocio](../../../escenario/README.md)
- [La plantilla de registro de tiempos](../../../docs/proyecto/plantillas/registro-de-tiempos.md)

# Qué hacer

1. Si no existe `docs/proyecto/registro-de-tiempos.md`, créalo a partir de la plantilla y
   anota en Requerimientos la hora actual, que obtienes con `date +%H:%M`.
2. Escribe en la última línea de `scripts/integracion/stack.txt` el stack del participante.
3. Sigue la skill `pasarela-historia-de-usuario` con la solicitud. Al listar las preguntas
   abiertas, incluye siempre qué transacciones y qué comercios entran al reporte, a qué
   tramo pertenece un monto que cae exactamente en el límite, en qué momento se redondea y
   contra qué se va a comprobar el total.
4. Muestra las preguntas y **detente**. Dile al participante que el negocio en esta sala es
   el relator y que le lleve las preguntas.
5. Con las respuestas que el participante te dé, crea
   `docs/proyecto/historia-reporte-medios-de-pago.md` con la plantilla. Entre los criterios,
   incluye uno con una transacción real cuyo monto esté exactamente en el límite de un tramo
   y uno con un comercio real cuya suma exacta de comisiones de junio tenga más de dos
   decimales, cada uno con el valor esperado y la cuenta. Si una respuesta del negocio
   falta para calcularlo, deja el criterio con el valor «pendiente».

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques código.
- No respondas tú las preguntas del negocio.

# Salida esperada

Primero, la lista de preguntas abiertas. Después de las respuestas, la historia creada, y en
tu respuesta qué preguntas siguen pendientes.
