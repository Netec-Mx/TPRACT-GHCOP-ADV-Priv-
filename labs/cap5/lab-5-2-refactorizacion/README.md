# Laboratorio 5.2. Planeación de mejora, refactorización y validación incremental

## Objetivo del laboratorio

Construir el reporte de comisiones por medio de pago en tu stack: planificar con el agente
antes de tocar código, refactorizar primero si el plan lo pide, validar cada paso contra la
liquidación y verificar el resultado. Es la fase de Desarrollo de
[`CICLO-DE-VIDA.md`](../../../CICLO-DE-VIDA.md).

## Duración

45 minutos.

## Prerrequisitos

- El laboratorio 5.1 terminado y confirmado en tu rama `reporte-medios-de-pago`. Este
  laboratorio parte de tu historia y de tu decisión de arquitectura.
- Todos los pasos se hacen en modo **Agent**.

## Pasos

| Paso | Qué escribir en el chat | Qué observar | Tiempo |
|---|---|---|---|
| 1 | `/lab-5-2-paso-1-planificar java` | Si el plan reutiliza código existente, si refactoriza antes y cómo valida cada paso. Aprueba el plan o pídele cambios | 10 min |
| 2 | `/lab-5-2-paso-2-implementar-reporte java` | En el diff que muestra el agente, qué archivos toca y que no toque el otro stack. Qué pasa con la liquidación después de cada paso | 20 min |
| 3 | `/lab-5-2-paso-3-verificar-reporte java` | Qué periodos coinciden con la salida esperada y si el pipeline local está en verde | 8 min |

Reemplaza `java` por `dotnet` si trabajas con .NET.

Después de cada paso que modifica código, revisa el diff en el panel de control de código
fuente (menú **View**, **Source Control**) antes de seguir.

Un refactor que cambia un solo byte de la liquidación está mal, aunque parezca una mejora.
`bash scripts/integracion-local.sh --paso equivalencia` lo detecta.

## Resultado esperado

- El reporte en tu stack, invocable con `--reporte-medios`.
- La liquidación sin cambios: `bash scripts/integracion-local.sh` en verde.
- Un commit en tu rama con el reporte, el registro de tiempos y la especificación técnica.

## Criterios de revisión

- [ ] El plan se aprobó antes de implementar y cada paso dice cómo se valida.
- [ ] Si hubo refactor, se hizo primero y la liquidación no cambió en ningún paso.
- [ ] `verificar-reporte.sh` se corrió para los tres periodos y su resultado quedó a la vista.
- [ ] Lo que no coincidió quedó anotado para el 5.3, sin corregirlo a ciegas.
