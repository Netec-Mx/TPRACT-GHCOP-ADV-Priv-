# Decisión de referencia: dónde vive el reporte

Solo para el relator. Es la decisión que corresponde a la solución de
`../funcionalidad-reporte/`. El participante la registra como 0004 en
`docs/arquitectura/decisiones/`.

- **Contexto.** El reporte desglosa por medio de pago lo que liquida el cierre. Pertenece al
  dominio Merchant Acquiring Facility, que es el del cálculo y la liquidación en el mapeo.
- **Alternativas.** Un método nuevo dentro de `CalculadoraLiquidacion`, que ya concentra el
  cálculo; o clases propias en `reporte/`, que leen los mismos datos y calculan por su
  cuenta; o clases propias que reutilizan el cálculo de comisión de la liquidación.
- **Decisión de la solución de referencia.** Clases propias en `reporte/` que calculan por su
  cuenta con decimal exacto.
- **Consecuencias.** No toca la clase de cálculo del cierre. A cambio, la regla de comisión
  queda en dos lugares, y la conciliación del 5.3 es la que comprueba que coincidan.

Cualquiera de las tres alternativas es válida en clase. Las dos últimas llevan a los dos
caminos del 5.2.
