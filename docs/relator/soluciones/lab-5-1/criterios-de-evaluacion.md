<!-- Solución de referencia del laboratorio 5.1, paso 4. Salió de la ejecución de
verificación de SPEC-011 y se ajustó el criterio 9 para que no anticipe la decisión de negocio
sobre los bordes de tramo. El relator la entrega a quien llega al 5.3 sin haber hecho el 5.1.
Se guarda en labs/cap5/lab-5-1-preparacion/entregables/criterios-de-evaluacion.md. -->

# Criterios de evaluación para los laboratorios 5.2 y 5.3

Parten de `labs/cap5/lab-5-1-preparacion/entregables/inventario-de-riesgos.md`. Todos se
comprueban con un comando, una prueba o una revisión concreta. Los comandos se ejecutan desde la
raíz del repositorio, salvo que se indique otro directorio.

| N.º | Criterio | Cómo se comprueba | Se cumple si |
|---|---|---|---|
| 1 | Los dos escenarios compilan | Java: `cd escenario/java && mvn -q clean package`. .NET: `cd escenario/dotnet && dotnet build LiquidacionComercios -c Release` | Ambos comandos terminan con código 0 y sin errores |
| 2 | Las pruebas existentes siguen pasando | Java: `cd escenario/java && mvn test`. .NET: `cd escenario/dotnet && dotnet test LiquidacionComercios.Pruebas` | Ambos terminan con código 0 y 0 pruebas fallidas; Java ejecuta al menos las 20 pruebas de la línea base |
| 3 | Equivalencia entre escenarios | `bash scripts/comparar-escenarios.sh` | Termina con código 0 y dice «Las salidas son identicas» |
| 4 | La salida del periodo 2026-06 no cambia en un refactor sin cambio de comportamiento | Guardar `java -jar target/liquidacion-comercios.jar 2026-06` desde `escenario/java/` antes y después, y comparar con `diff` | `diff` no muestra diferencias, línea por línea, en las 554 líneas de la línea base |
| 5 | Alcance del cambio | `git diff --name-only` y `git status --short` | Solo aparecen los archivos que el laboratorio nombra y cada línea modificada de `git diff -U0 -- escenario` pertenece a la parte que el laboratorio pidió tocar; ningún archivo de `escenario/datos/` ni de `escenario/java/src/test/` ni de `escenario/dotnet/LiquidacionComercios.Pruebas/` cambia salvo que el laboratorio lo pida |
| 6 | Regla 3: el recargo por cuotas tiene el mismo tope en la liquidación y en la simulación | Prueba que compare `CalculadoraComision.calcularRecargoCuotas` y el recargo de la liquidación con 8 y 10 cuotas sobre un mismo plan | Ambas dan el mismo valor para 8 y 10 cuotas; hoy difieren (3.5 y 3.0) |
| 7 | Regla 2: los tramos siguen sin ser acumulativos | Prueba con un plan de tramos y un monto de 1500.00 en el plan PL01 (tramo 500 a 2000, 2.9 %) | La comisión base es `1500.00 * 2.9 / 100 + 0.30 = 43.80`, no una suma repartida entre tramos |
| 8 | Regla 9: totales con redondeo medio hacia arriba sobre decimales exactos, si el laboratorio toca la aritmética | Prueba o salida de 2026-06 para CM0011, CM0016 y CM0025 | Imprimen 137.83, 494.00 y 957.19 respectivamente; hoy imprimen 137.82, 493.99 y 957.18 |
| 9 | Un cambio de estructura no altera los límites de tramo | Prueba con montos exactamente iguales a un límite de tramo (por ejemplo 500.00 en PL01), antes y después del cambio | El porcentaje aplicado en cada límite es el mismo antes y después del cambio |
| 10 | Las pruebas nuevas prueban lógica de negocio y no solo formato | Revisión: cada prueba nueva llama a `CalculadoraComision` o `CalculadoraLiquidacion` y verifica un monto | Existe al menos una prueba por regla tocada y ninguna verifica solo getters |
