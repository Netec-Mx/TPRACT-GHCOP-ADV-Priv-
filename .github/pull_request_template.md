## Qué cambia y por qué

<!-- Una o dos oraciones. Regla 5 de la política de uso de IA: quien revisa necesita saber qué se pidió. -->

## Qué parte generó el agente

<!-- Archivos o partes que escribió el agente y con qué pedido o skill. Regla 5. -->

## Comprobaciones

- [ ] Una persona revisó cada línea del cambio, también las que generó el agente. (regla 5 de `docs/gobierno/politica-uso-ia.md`)
- [ ] No entran secretos, credenciales, datos personales ni datos reales de clientes. (regla 2 de `docs/gobierno/politica-uso-ia.md`)
- [ ] No se modificó `escenario/datos/`. (regla 3 de `docs/gobierno/politica-uso-ia.md`)
- [ ] El pipeline termina en verde para el stack declarado en `scripts/integracion/stack.txt`, en GitHub o con `bash scripts/integracion-local.sh`. (regla 5 de `docs/gobierno/politica-uso-ia.md`)
- [ ] Cada hash esperado que cambió está en la sección de abajo, con su causa. (regla 5 de `docs/gobierno/politica-uso-ia.md`)
- [ ] Si el cambio toca `.github/` o `.vscode/`, alguien más revisó esa parte como si fuera un script de despliegue. (regla 6 de `docs/gobierno/politica-uso-ia.md`)

## Hashes esperados que cambiaron

<!-- Si cambió scripts/integracion/liquidacion-esperada.sha256: qué periodo, qué comercios cambian de cuánto a cuánto, y la causa con su decisión. Si no cambió, escribe «Ninguno». Regla 5. -->

## Revisión de Copilot

<!-- Los comentarios de la revisión de Copilot y qué se decidió con cada uno: aplicar, descartar o decidir con el equipo. Si no se pudo pedir, dilo. Regla 5. -->

## Decisión de arquitectura

<!-- Si el cambio implica una decisión de arquitectura, el enlace a su registro en docs/arquitectura/decisiones/. Si no, escribe «No aplica». Regla 5: la revisión necesita el porqué. -->
