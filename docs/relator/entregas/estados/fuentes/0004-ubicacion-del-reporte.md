# 0004. El reporte por medio de pago vive en clases propias

| Campo | Valor |
|---|---|
| Estado | Aceptada |
| Fecha | 2026-10-03 |
| Responsable | Equipo |

## Contexto

El reporte desglosa por medio de pago lo que liquida el cierre. En el mapeo BIAN pertenece a
Merchant Acquiring Facility, y lee comercios, planes y transacciones, de Merchant Relations y
Card Transaction Capture.

## Alternativas consideradas

- **Un método nuevo en la clase de cálculo de la liquidación.** Reutiliza el cálculo. Agrega
  más responsabilidad a una clase que ya concentra mucho.
- **Clases propias que reutilizan el cálculo de comisión de la liquidación.** Una sola regla
  de comisión. El reporte hereda cualquier diferencia de ese cálculo.
- **Clases propias que calculan por su cuenta con decimal exacto.** No tocan el cierre. La
  regla de comisión queda en dos lugares.

## Decisión

Clases propias en el paquete de reporte del stack, que leen los mismos datos y calculan la
comisión por su cuenta con decimal exacto y las reglas de `escenario/README.md`.

## Consecuencias

- El cierre no cambia.
- La regla de comisión queda en dos lugares, y la conciliación del pipeline comprueba que
  coincidan.

## Verificación

`bash scripts/verificar-reporte.sh <stack> <periodo>` y la conciliación del pipeline.
