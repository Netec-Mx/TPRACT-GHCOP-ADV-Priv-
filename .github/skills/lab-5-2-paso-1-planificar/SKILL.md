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

1. Anota en `docs/proyecto/registro-de-tiempos.md` la hora actual en Desarrollo.
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

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques ningún archivo salvo el registro de tiempos y el documento entregado.

# Salida esperada

El plan, con la validación de cada paso, y la pregunta de aprobación.
