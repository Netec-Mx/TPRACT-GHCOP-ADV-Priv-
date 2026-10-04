# Capítulo 5: hoja de respuestas del relator

## 5.1, paso 1: usted es el negocio

Responda solo lo que pregunten.

| Si preguntan | Responda |
|---|---|
| Qué transacciones entran | Aprobadas, en soles, monto mayor que cero, en el periodo |
| Qué comercios entran | Activos y suspendidos con plan; no los dados de baja |
| El periodo | Del primer día, 00:00:00, al último, 23:59:59, con la hora del cierre |
| El monto transado | Suma exacta de los montos del medio |
| Las cuotas | La comisión incluye su recargo: 0,5 % por cuota sobre la primera, máximo 3 %, sobre la comisión base |
| Contracargos y retenciones | No forman parte del reporte |
| Contra qué se comprueba | Suma del total de comisiones de las liquidaciones, al centavo |
| El tope | Por comercio; filas antes del tope y una fila de ajuste |
| El redondeo | Al final: cada fila suma exacto y redondea; el total, por comercio, como la liquidación |
| Un monto en el límite de un tramo | Al tramo inferior: límite superior inclusivo |
| Orden, formato o decimales | Los fija la especificación que se entrega en el 5.2 |

Criterio de decimales: un comercio cuya suma exacta termina en 5 en el tercer decimal; si
no, que lo rehaga. Criterio de formato: montos con dos decimales, medio hacia arriba, regla
9; se prueba en el 5.3. La decisión 0004 de referencia es del camino A.

## 5.2, paso 3

Si el reporte reutiliza el cálculo, junio no coincide: es esperado, queda como hallazgo
abierto y se resuelve en el 5.3.

## 5.3, paso 2: qué detectó cada cosa

Camino A: la conciliación y su prueba, junio, 22,03. Camino B: la conciliación, nada; las
pruebas, el borde y el medio centavo. Conciliar dos cosas que comparten un cálculo no detecta
sus errores.

## 5.3, paso 3: la decisión del borde

Si no la pidieron en el 5.1: límite superior inclusivo.

Las causas del cálculo se corrigen en la liquidación, y un reporte que lo reutiliza queda
corregido con ella; un error propio del reporte, como un formato que redondea antes, en el
reporte. La mínima: cada comisión exacta, suma exacta por comercio y un solo redondeo al
final, medio hacia arriba. Si cambia solo el redondeo: que pruebe junio; le quedan centavos.
Solo en su stack: el otro conserva la diferencia y queda fuera del alcance.

**Si encuentra solo el borde** o **solo explica lo que fallan las pruebas**: pregunte cuánto
suma cada causa y a quién afecta; sugiera recalcular con decimal exacto. Total 22,03: 22,00
de borde, CM0001 y CM0007; 0,03 de punto flotante, CM0011, CM0016 y CM0025.

## Si alguien se atrasa

Clave de ponerse al día: `quinua-condor-47`. Con su stack y laboratorio:

```bash
bash scripts/proyecto/ponerse-al-dia.sh lab-5-3 java quinua-condor-47
```

Pide `descartar` y deja el camino A. El 5.1 de cero:
`bash scripts/reiniciar-lab.sh lab-5-1`.
