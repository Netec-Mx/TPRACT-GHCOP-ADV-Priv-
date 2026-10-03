# 0005. El límite superior de cada tramo es inclusivo

| Campo | Valor |
|---|---|
| Estado | Aceptada |
| Fecha | 2026-10-03 |
| Responsable | Negocio y equipo |

## Contexto

`escenario/README.md` no decide a qué tramo pertenece un monto que cae exactamente en el
límite. El cierre cobraba el tramo siguiente, y la conciliación del reporte de junio no
cuadraba por 22,00 en CM0001 y CM0007, más 0,03 de redondeo en punto flotante en CM0011,
CM0016 y CM0025.

## Alternativas consideradas

- **Límite superior exclusivo,** como hacía el cierre. 500,00 paga el porcentaje del tramo
  siguiente.
- **Límite superior inclusivo.** 500,00 paga el porcentaje del tramo de 0 a 500.

## Decisión

El negocio decide que el límite superior es inclusivo: el monto en el límite pertenece al
tramo inferior. Se corrige el cálculo de la liquidación con el límite inclusivo y con decimal
exacto, y se actualiza el hash esperado de junio.

## Consecuencias

- CM0001 y CM0007 pagan 11,00 más en junio, y CM0011, CM0016 y CM0025 un centavo más.
- La liquidación de abril y mayo no cambia.

## Verificación

El pipeline local en verde, con la conciliación en cero en los tres periodos.
