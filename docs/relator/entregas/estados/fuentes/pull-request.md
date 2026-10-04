## Qué cambia y por qué

El reporte de comisiones por medio de pago que pidió Gerencia Comercial, la conciliación del
reporte con las liquidaciones en el pipeline y la corrección del cálculo de la liquidación que
la conciliación encontró.

## Qué parte generó el agente

El código del reporte, sus pruebas, el paso de conciliación del pipeline y la corrección,
cada uno con la skill de su laboratorio. La persona aprobó cada plan y cada corrección.

## Comprobaciones

- [x] Una persona revisó cada línea del cambio, también las que generó el agente. (regla 5 de `docs/gobierno/politica-uso-ia.md`)
- [x] No entran secretos, credenciales, datos personales ni datos reales de clientes. (regla 2 de `docs/gobierno/politica-uso-ia.md`)
- [x] No se modificó `escenario/datos/`. (regla 3 de `docs/gobierno/politica-uso-ia.md`)
- [x] El pipeline termina en verde para el stack declarado en `scripts/integracion/stack.txt`, en GitHub o con `bash scripts/integracion-local.sh`. (regla 5 de `docs/gobierno/politica-uso-ia.md`)
- [x] Cada hash esperado que cambió está en la sección de abajo, con su causa. (regla 5 de `docs/gobierno/politica-uso-ia.md`)
- [x] Si el cambio toca `.github/` o `.vscode/`, alguien más revisó esa parte como si fuera un script de despliegue. (regla 6 de `docs/gobierno/politica-uso-ia.md`)

## Hashes esperados que cambiaron

2026-06. CM0001 y CM0007 pagan 11,00 más cada uno por el límite inclusivo del tramo, y CM0011,
CM0016 y CM0025 un centavo más por el cálculo exacto. Decisión 0005.

## Alcance por stack

La corrección es del stack declarado en `scripts/integracion/stack.txt`. El otro stack conserva
la diferencia de junio y queda fuera del alcance de este cambio.

## Revisión de Copilot

Estado de referencia para ponerse al día: la revisión se pide sobre los cambios propios.

## Decisión de arquitectura

`docs/arquitectura/decisiones/0004-ubicacion-del-reporte.md` y
`docs/arquitectura/decisiones/0005-limite-superior-inclusivo.md`.
