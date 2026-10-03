# Ciclo de vida del desarrollo de software con IA

El mapa del taller. El subtema 1.3 lo presenta y el capítulo 5 lo recorre completo con una
sola historia, el reporte de comisiones por medio de pago. En cada fase la IA propone, la
persona decide, algo se verifica y queda un artefacto. Dentro de cada fase se repite el
ciclo corto de analizar, planear, implementar y validar.

| Fase | Dónde se trabaja | Qué hace la IA | Qué decide la persona | Artefacto que queda |
|---|---|---|---|---|
| Requerimientos | 5.1, paso 1 | Lista las preguntas abiertas y redacta la historia con sus criterios | Qué se construye y qué respuestas da el negocio | `docs/proyecto/historia-reporte-medios-de-pago.md` |
| Estimación | 5.1, paso 2 | Desglosa la historia por fase, con y sin IA | El rango y sus supuestos | `docs/proyecto/estimacion.md` y `docs/proyecto/registro-de-tiempos.md` |
| Análisis y diseño | 5.1, paso 3 | Ubica la funcionalidad en el mapeo BIAN y propone alternativas | Dónde vive el reporte | Una decisión nueva en `docs/arquitectura/decisiones/` |
| Desarrollo | 5.2 | Planifica e implementa en pasos | Qué plan se aprueba y si se refactoriza antes | El reporte en el escenario del stack elegido |
| Pruebas | 5.3, paso 1 | Escribe las pruebas a partir de los criterios | Qué comportamiento es el correcto | Pruebas nuevas del reporte |
| Revisión de código | 5.3, paso 4 | Revisa el cambio contra la lista de comprobación | Si el cambio se acepta | `docs/proyecto/pull-request.md` |
| Seguridad | 5.3, paso 4 | Revisa que no entren secretos ni datos reales y que cada cambio de hash esté justificado | Si el cambio cumple la política de uso de IA | La lista de comprobación de `docs/proyecto/pull-request.md` |
| Integración continua | 5.3, paso 2 | Agrega la conciliación al pipeline | Qué bloquea una integración | `scripts/integracion-local.sh` y el workflow con el paso nuevo |
| Liberación | 5.4, paso 1 | Redacta el registro de cambios y las notas de versión | La versión y qué se le dice al negocio | `CHANGELOG.md` y `docs/proyecto/notas-de-version-1.1.0.md` |
| Operación y soporte | 5.4, paso 2 | Analiza el incidente con el runbook | Qué se responde al comercio | `docs/proyecto/incidentes/` |
| Mantención, correctiva y evolutiva | 5.3, paso 3, y 5.4, paso 3 | Diagnostica el rojo del pipeline; estima un cambio pedido por el negocio | Qué se corrige y qué hash esperado cambia; si la evolutiva se hace | La corrección con `scripts/integracion/liquidacion-esperada.sha256`, y `docs/proyecto/estimacion-evolutiva.md` |

Dentro del 5.3 el orden de los pasos no es el de la tabla, y es a propósito. El pipeline
tiene que tener la conciliación, integración continua, para ponerse en rojo, y la
mantención correctiva tiene que dejarlo en verde antes de la revisión, porque nadie revisa un
cambio con el pipeline en rojo. La mantención correctiva aparece así antes que la liberación,
como pasa en un proyecto real, y la evolutiva cierra el capítulo con la versión ya liberada.

Al terminar, el 5.4 compara la estimación con el registro de tiempos fase por fase.

## Dónde está cada cosa

- Plantillas: `docs/proyecto/plantillas/`.
- Skills reutilizables fuera del taller: `pasarela-historia-de-usuario`, `pasarela-estimar`,
  `pasarela-registrar-decision`, `pasarela-notas-de-version` y `pasarela-analizar-incidente`,
  en `.github/skills/`.
- Pipeline: `bash scripts/integracion-local.sh`, el mismo que corre en GitHub Actions.
- Política de uso de IA: `docs/gobierno/politica-uso-ia.md`.
