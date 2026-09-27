# Soluciones de referencia

Una solución por cada laboratorio que modifica código. Todas salen de ejecutar la skill
del paso sobre una copia limpia del repositorio de participantes, y todas se verificaron
aplicándolas otra vez sobre una copia limpia. Compilan, las pruebas pasan y
`bash scripts/comparar-escenarios.sh` termina en cero.

| Laboratorio | Archivo | Qué contiene |
|---|---|---|
| 1.5 | `lab-1-5/paso-5-extraer-retencion-{java,dotnet}.patch` | Retención de garantía extraída a un método |
| 5.2 | `lab-5-2/paso-2-extraer-comision-{java,dotnet}.patch` | Cálculo de comisión extraído a un método |
| 5.2 | `lab-5-2/paso-3-extraer-desglose-medios-{java,dotnet}.patch` | Desglose por medio de pago extraído a un método |
| 5.2 | `lab-5-2/pasos-2-y-3-combinados-{java,dotnet}.patch` | Los dos cambios anteriores juntos |
| 5.3 | `lab-5-3/paso-1-probar-tramos-{java,dotnet}.patch` | Archivo nuevo de pruebas de la selección de tramo |
| 5.4 | `lab-5-4/activos-ejemplo/` | Ejemplo de lo que produce el paso 1. No es una respuesta correcta |

## Cómo mostrar una solución

Desde la raíz de un repositorio en el punto de partida del laboratorio:

```bash
bash scripts/reiniciar-lab.sh lab-5-2
git apply ruta/a/paso-2-extraer-comision-java.patch
bash scripts/comparar-escenarios.sh
```

Los parches están en el repositorio de construcción. Para aplicarlos en la máquina de un
participante hay que llevarle el archivo.

Los parches de los pasos 2 y 3 del 5.2 no se aplican uno después del otro, porque los dos
insertan su método en el mismo lugar de la clase. Para mostrar los dos cambios juntos se
usa el combinado.

La solución del 5.4 no modifica el escenario. Uno de sus archivos,
`skills/documentar-calculo-de-negocio.skill.md`, tiene un formato que Visual Studio Code no
reconoce como skill. Se dejó tal cual, porque es un ejemplo útil de lo que hay que revisar.
