# Soluciones de referencia

Una solución por cada laboratorio que la necesita. Las que modifican código se verificaron
aplicándolas sobre una copia limpia del repositorio de participantes; los gates las vuelven
a aplicar en cada corrida.

| Laboratorio | Dónde | Qué contiene |
|---|---|---|
| 1.5 | `lab-1-5/paso-5-extraer-retencion-{java,dotnet}.patch` | Retención de garantía extraída a un método |
| 5.1 | `lab-5-1/` | Historia de referencia con las respuestas del negocio, estimación y decisión |
| 5.2 | `funcionalidad-reporte/reporte-{java,dotnet}.patch`, con `lab-5-2/README.md` | El reporte por medio de pago, camino A, y los dos caminos |
| 5.3 | `lab-5-3/` y `funcionalidad-reporte/correccion-{java,dotnet}.patch` | Conciliación en el pipeline, mantención correctiva y hash de junio |
| 5.4 | `lab-5-4/README.md` | Versión y notas, incidente con su respuesta y evolutivas posibles |

`funcionalidad-reporte/` tiene además el oráculo, `conciliar.sh`, `aplicar.sh` y el
pipeline de referencia. La verdad funcional está en
[`../funcionalidad-reporte.md`](../funcionalidad-reporte.md).

## Cómo aplicar una solución

Los parches están en el repositorio de construcción. Desde la raíz del clon del
participante, con la ruta de su copia del repositorio de construcción:

```bash
SOL=<ruta del repositorio de construccion>/docs/relator/soluciones
bash "$SOL/funcionalidad-reporte/aplicar.sh" java .
```

El orden de los parches del capítulo 5 está en `lab-5-3/README.md`. Los comandos para poner
al día a un participante atrasado están en una página,
[`../capitulo-5-hoja-de-respuestas.md`](../capitulo-5-hoja-de-respuestas.md).
