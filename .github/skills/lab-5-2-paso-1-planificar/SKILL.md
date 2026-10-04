---
name: lab-5-2-paso-1-planificar
description: 'Lab 5.2 paso 1, fase de Desarrollo. Planifica la implementación del reporte antes de tocar código, con la validación de cada paso.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Acordar un plan para implementar el reporte antes de tocar código. Empieza la fase de
Desarrollo de [CICLO-DE-VIDA.md](../../../CICLO-DE-VIDA.md).

El participante indica su stack, `java` o `dotnet`. Si no lo indicó, pregúntale y no hagas
nada más hasta que responda.

# Qué hacer

1. Anota en `docs/proyecto/registro-de-tiempos.md` la hora de inicio de Desarrollo, con `date +%H:%M`, y
   `participante` en Origen. El término lo anota el paso 3.
2. Entrega la especificación técnica del reporte ejecutando
   `bash scripts/proyecto/entregar.sh formato-del-reporte`, y léela.
3. Lee la historia `docs/proyecto/historia-reporte-medios-de-pago.md`, la decisión de
   arquitectura del 5.1 y el código del escenario del stack indicado que esa decisión
   menciona.
4. Arma un plan en pasos numerados, sin editar ningún archivo. Para cada paso: qué archivo
   toca, qué hace y cómo se valida. Si el plan reutiliza código existente y para eso hay que
   refactorizarlo, el refactor va primero y cada paso de refactor se valida con
   `bash scripts/integracion-local.sh --paso equivalencia`, que compara la liquidación con
   los hashes esperados. Un refactor que cambia un solo byte de la liquidación está mal.
5. Muestra el plan y pregunta al participante si lo aprueba o qué cambia. No implementes.
6. Si el plan aprobado no sigue la alternativa que registra la decisión del 5.1, dilo y
   reescribe esa decisión para que diga lo que de verdad se va a construir, con sus
   consecuencias. No supongas su estado: mantén el que tenga el archivo. Agrega una línea
   que diga qué cambió y por qué, y dilo en tu respuesta. No crees otra decisión.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques ningún archivo salvo el registro de tiempos, el documento entregado y, si
  corresponde, la decisión del 5.1.

# Salida esperada

El plan, con la validación de cada paso, y la pregunta de aprobación. Muestra también
`docs/proyecto/registro-de-tiempos.md` completo, con la hora que anotaste. La especificación
técnica que entregó el script no la escribiste tú: nombra su archivo,
`docs/proyecto/backlog/formato-del-reporte.md`. Si actualizaste la decisión, muéstrala
completa.

Escribe ese contenido en el texto de tu respuesta, como Markdown o en un bloque de código.
No basta con ejecutar `cat` o `git diff` en la terminal ni con decir que ya se ve en la
vista de una herramienta: el participante lo tiene que poder leer en tu respuesta.
