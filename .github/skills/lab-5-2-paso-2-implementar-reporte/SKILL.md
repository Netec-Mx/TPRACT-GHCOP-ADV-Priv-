---
name: lab-5-2-paso-2-implementar-reporte
description: 'Lab 5.2 paso 2, fase de Desarrollo. Implementa el reporte siguiendo el plan aprobado, validando cada paso.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Implementar el reporte de comisiones por medio de pago en el escenario del stack indicado,
siguiendo el plan aprobado en el paso 1.

El participante indica su stack, `java` o `dotnet`. Si no lo indicó, pregúntale y no hagas
nada más hasta que responda.

Material de partida:

- El plan aprobado en el paso 1, en esta conversación. Si no lo tienes, pídele al
  participante que lo pegue o que repita el paso 1.
- `docs/proyecto/backlog/formato-del-reporte.md`. Si no existe, ejecuta
  `bash scripts/proyecto/entregar.sh formato-del-reporte`.
- `docs/proyecto/historia-reporte-medios-de-pago.md`

# Qué hacer

1. Sigue el plan en orden. Después de cada paso que modifica código, compila y ejecuta
   `bash scripts/integracion-local.sh --paso equivalencia`. Si la liquidación dejó de
   coincidir con los hashes esperados, detente, muestra la diferencia y pregunta al
   participante antes de seguir. No cambies los hashes esperados.
2. Implementa el argumento `--reporte-medios` en la clase ejecutable del stack, con el
   formato exacto de la especificación técnica.
3. No escribas todavía las pruebas del reporte. Son el paso 1 del 5.3.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Solo el stack indicado. No toques el otro escenario.
- No modifiques `scripts/integracion/liquidacion-esperada.sha256` ni los datos.

# Salida esperada

Al terminar, muestra en el chat el diff completo de lo que cambió, con `git diff` y el
contenido completo de cada archivo nuevo, no un resumen por archivo. Después, el resultado
de la última validación.
