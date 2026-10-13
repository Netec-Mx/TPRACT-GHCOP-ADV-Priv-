# Solución de referencia del laboratorio 5.2

Solo para el relator. El reporte de referencia está en
`../funcionalidad-reporte/`. Para
poner al día a un participante atrasado, desde la raíz de su clon:

```bash
bash <ruta del repositorio de construccion>/docs/relator/soluciones/funcionalidad-reporte/aplicar.sh java .
```

con `dotnet` en lugar de `java` según su stack. Aplica el reporte sobre el punto de
partida. Si el participante ya tocó el escenario, el parche no se aplica limpio: primero
`bash scripts/reiniciar-lab.sh lab-5-2`.

## Los dos caminos

| Camino | Cómo se implementa | Qué pasa en el 5.2 | Qué pasa en el 5.3 |
|---|---|---|---|
| A | El reporte calcula la comisión por su cuenta, con decimal exacto y las reglas | `verificar-reporte.sh` coincide en los tres periodos | La conciliación de junio falla por 22,03 |
| B | El reporte reutiliza el cálculo de comisión de la liquidación | `verificar-reporte.sh` no coincide en junio | Las pruebas de los criterios de borde y de tercer decimal fallan |

La solución de referencia es el camino A. Los dos llegan al mismo lugar: la mantención
correctiva del 5.3 corrige la liquidación, y con eso el camino B también queda en verde.
