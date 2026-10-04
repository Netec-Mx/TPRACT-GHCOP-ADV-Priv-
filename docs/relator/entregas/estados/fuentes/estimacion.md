# Estimación: reporte de comisiones por medio de pago

| Campo | Valor |
|---|---|
| Tipo | Funcionalidad nueva |
| Historia | `docs/proyecto/historia-reporte-medios-de-pago.md` |
| Estimó | Equipo |
| Fecha | 2026-10-03 |

## Por fase

| Fase | Sin IA, persona (min) | Con IA, persona (min) | Con IA, agente (min) | Créditos de IA | Minutos de integración continua | Supuesto principal |
|---|---|---|---|---|---|---|
| Requerimientos | 30 | 15 | 1 | Completar | 0 | Las preguntas al negocio toman lo mismo con o sin IA |
| Estimación | 20 | 10 | 1 | Completar | 0 | Estimar a mano exige recorrer el código |
| Análisis y diseño | 30 | 10 | 1 | Completar | 0 | La IA lee el código y el mapeo; la persona decide |
| Desarrollo | 180 | 25 | 3 | Completar | 0 | Un stack, con pruebas |
| Pruebas | 60 | 10 | 1 | Completar | 0 | Los criterios ya traen los valores esperados |
| Integración continua | 40 | 10 | 1 | Completar | Completar | Un paso nuevo en un pipeline que existe |
| Mantención | 90 | 15 | 2 | Completar | Completar | El diagnóstico es lo que pesa |
| Revisión de código | 20 | 8 | 1 | Completar | 0 | La revisión humana se lee igual |
| Seguridad | 10 | 4 | 0 | Completar | 0 | Lista de comprobación de la plantilla |
| Liberación | 20 | 8 | 1 | Completar | 0 | Registro de cambios y notas |
| Operación y soporte | 45 | 12 | 1 | Completar | 0 | Un incidente con runbook |
| Mantención evolutiva | 30 | 8 | 1 | Completar | 0 | Estimar el cambio siguiente con el registro real del ciclo |
| **Total** | **575** | **135** | **14** | | | |

## Riesgos que pueden mover la estimación

- Que el negocio tarde en responder las preguntas abiertas.
- Que el pipeline encuentre diferencias que haya que diagnosticar.

## Cómo se va a comparar con lo real

Con `docs/proyecto/registro-de-tiempos.md`, fase por fase.
