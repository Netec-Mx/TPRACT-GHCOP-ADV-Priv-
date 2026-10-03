# Solución de referencia del laboratorio 5.3

Solo para el relator. Se aplica en este orden sobre el punto de partida, después del reporte
de `../funcionalidad-reporte/`:

| Orden | Parche | Qué hace |
|---|---|---|
| 1 | `../funcionalidad-reporte/reporte-<stack>.patch` | El reporte, con sus pruebas |
| 2 | `conciliacion-en-pipeline.patch` | El paso `conciliacion` en `integracion-local.sh` y en el workflow |
| 3 | `../funcionalidad-reporte/correccion-<stack>.patch` | La mantención correctiva: decimal exacto y borde inclusivo |
| 4 | `hash-junio.patch` | El hash esperado nuevo de la liquidación de 2026-06 |

Con 1 y 2 el pipeline local queda en rojo solo por la conciliación de junio, con 22,03. Con
los cuatro queda en verde con ambos stacks y con cada uno por separado. Los gates lo
verifican.

Desde la raíz del clon del participante, con su stack:

```bash
SOL=<ruta del repositorio de construccion>/docs/relator/soluciones
git apply "$SOL/lab-5-3/conciliacion-en-pipeline.patch"
git apply "$SOL/funcionalidad-reporte/correccion-java.patch" "$SOL/lab-5-3/hash-junio.patch"
```

## El diagnóstico de referencia

| Causa | Comercios | Transacciones | Monto |
|---|---|---|---|
| Borde de tramo: el cierre usa `<` en el límite superior y cobra el tramo siguiente | CM0001 y CM0007 | TX002001 y TX002003 por 500,00; TX002002 y TX002004 por 2000,00 | 22,00 |
| Punto flotante: la suma en `double` de tres comercios queda un pelo por debajo del medio centavo y redondea hacia abajo | CM0011, CM0016 y CM0025 | TX002037, TX002035 y TX002036 | 0,03 |
| **Total** | | | **22,03** |
