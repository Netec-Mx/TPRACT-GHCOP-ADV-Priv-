# Funcionalidad nueva: reporte de comisiones por medio de pago

Documento del relator. Es la verdad funcional de la historia que el capítulo 5 recorre de
punta a punta, y la fuente de la solución de referencia, del oráculo y de la conciliación.
Nada de lo que está aquí llega al repositorio de participantes.

Definido en SPEC-015 con la enmienda SPEC-015-A.

## Qué es

Un reporte por periodo que muestra cuánto aporta cada medio de pago a las comisiones que
cobra Pasarela Andina. Lo pide el área comercial para decidir con qué medios negociar.

## Contenido

Una fila por cada medio de pago presente en las transacciones que entran al reporte,
ordenadas por el código del medio de pago en orden alfabético. Cada fila lleva el código del
medio de pago, la cantidad de transacciones, el monto transado, la comisión y la
participación de ese medio en la comisión, en porcentaje con dos decimales.

Después de las filas de medios, tres filas: ajuste por tope, ajuste por redondeo y total.

## Reglas

**Alcance.** El reporte desglosa exactamente lo que se liquida. Entran las mismas
transacciones y los mismos comercios que toma hoy el cierre en
`CalculadoraLiquidacion.procesarLiquidacionCompleta`, en los dos stacks:

| Qué | Entra | No entra |
|---|---|---|
| Comercios | `ACTIVO` y `SUSPENDIDO`, con plan de comisiones existente | `DE_BAJA` y los que no tienen plan |
| Transacciones, por estado | `APROBADA` | `ANULADA`, `PENDIENTE` y `RECHAZADA` |
| Transacciones, por validez | Moneda `PEN`, monto mayor que cero y fecha legible | Las demás, que el cierre descarta |
| Transacciones, por fecha | Desde el primer día del periodo a las 00:00:00 hasta el último a las 23:59:59, ambos incluidos, con la misma hora de reloj que usa el cierre | Las de fuera del periodo |

**Comisión de cada transacción.** Con decimal exacto y las reglas de `escenario/README.md`:
porcentaje del tramo sobre el monto completo, más el monto fijo, más el recargo por cuotas
de 0,5 % por cada cuota sobre la primera, con máximo de 3 %, aplicado sobre la comisión
base. El borde superior de cada tramo es inclusivo: un monto igual al límite pertenece al
tramo inferior. La comisión de la transacción no se redondea.

**Filas de medios.** La suma exacta de las comisiones de sus transacciones, redondeada a dos
decimales, medio hacia arriba, al final. El monto transado es la suma exacta de los montos.

**Total.** Se calcula como lo calcula la liquidación: por comercio, se suma exacto, se
aplica el tope del plan si la suma lo supera, se redondea a dos decimales y se suman los
comercios.

**Ajuste por tope.** En negativo, la suma, sobre los comercios que superan su tope, de su
comisión redondeada menos su tope.

**Ajuste por redondeo.** El total menos la suma de las filas de medios menos el ajuste por
tope. Es la diferencia entre redondear por comercio y redondear por medio de pago. Se
muestra siempre, aunque sea cero, para que el formato sea estable.

**Participación.** La comisión de la fila sobre la suma de las filas de medios, por cien,
redondeada a dos decimales, medio hacia arriba. Las participaciones pueden no sumar
exactamente 100,00.

Los contracargos y las retenciones no forman parte del reporte.

## Decisiones de negocio del relator

No van en ningún archivo del participante. Son las respuestas del relator cuando un
participante las descubre en el 5.1, igual que la decisión de bordes de tramo.

**Alcance.** El reporte muestra lo que se liquida. Es la ambigüedad central del 5.1. Una
historia tomada al pie de la letra, que solo excluye las transacciones anuladas, produce un
reporte que difiere de las liquidaciones en 3 415,01 soles en 2026-04, 4 065,43 en 2026-05 y
2 521,97 en 2026-06, por las transacciones pendientes y rechazadas y por el comercio dado de
baja. Es el ejemplo de lo que cuesta un requerimiento mal tomado.

**Tope.** El tope es por comercio y no se reparte entre medios. Las filas de medios muestran
la comisión antes del tope. La fila de ajuste por tope muestra lo que se descuenta.

**Redondeo.** Las filas se redondean por medio de pago y el total por comercio, así que
pueden no coincidir por centavos. La fila de ajuste por redondeo lleva esa diferencia.

**Criterio de aceptación central.** El total del reporte es igual a la suma del total de
comisiones de las liquidaciones del periodo, al centavo.

## Formato e invocación

El reporte se obtiene con la misma clase ejecutable, con el argumento `--reporte-medios`
antes del periodo y la ruta de datos, que conservan su significado y sus valores por
omisión. Invocada sin ese argumento, la liquidación no cambia en un solo byte.

```bash
# Java, desde escenario/java/
java -jar target/liquidacion-comercios.jar --reporte-medios 2026-06

# .NET, desde escenario/dotnet/
dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll --reporte-medios 2026-06
```

Formato, decidido por el ejecutor con los mismos criterios que la liquidación y aplicado
igual en los dos stacks:

- Codificación UTF-8 y fin de línea `\n`.
- Encabezado con el mismo marco de signos `=` y el mismo formato de fecha `dd/MM/yyyy HH:mm`
  que la liquidación.
- Montos con prefijo `S/ `, punto decimal, dos decimales y sin separador de miles. Los
  negativos llevan el signo después del prefijo, `S/ -23698.36`.
- Porcentajes con punto decimal, dos decimales y el sufijo ` %`.
- Columnas de ancho fijo, alineadas a la derecha salvo el código del medio de pago.

```
==========================================================
  PASARELA ANDINA - COMISIONES POR MEDIO DE PAGO
  Periodo: 2026-06
  Desde: 01/06/2026 00:00
  Hasta: 30/06/2026 23:59
==========================================================

Medio de pago      Transacciones    Monto transado        Comision   Participacion
BILLETERA_MOVIL              123   S/ 123456.78      S/ 1234.56         12.34 %
...
----------------------------------------------------------------------------------
Ajuste por tope                                       S/ -23698.32
Ajuste por redondeo                                   S/ 0.00
Total                                                 S/ 36637.34
```

El ejemplo muestra la forma, no los valores. La salida exacta de cada periodo es el oráculo
de `soluciones/funcionalidad-reporte/oraculo/`.

## Conciliación

`soluciones/funcionalidad-reporte/conciliar.sh` compara, para un periodo, el total del
reporte con la suma del total de comisiones de las liquidaciones, y termina con código
distinto de cero si no coinciden.

Con la liquidación tal como está:

| Periodo | Resultado | Diferencia | Causa |
|---|---|---|---|
| 2026-04 | Concilia | 0,00 | |
| 2026-05 | Concilia | 0,00 | |
| 2026-06 | No concilia | 22,03 | 22,00 por el borde de tramo, CM0001 y CM0007, transacciones TX002001 a TX002004. 0,03 por punto flotante, CM0011, CM0016 y CM0025 |

Las dos causas están en el catálogo. El borde es DEF-08: el cierre usa `<` en el límite
superior y cobra el tramo siguiente a 500,00 y 2000,00. Los tres centavos son DEF-01:
calculadas con decimal exacto, las comisiones de CM0011, CM0016 y CM0025 suman 137,825,
493,995 y 957,185, que redondean hacia arriba, pero en punto flotante suman 137,8249…,
493,9949… y 957,1849…, que redondean hacia abajo. Las transacciones que lo hacen visible
son TX002037, TX002035 y TX002036.

El análisis completo, con las cinco variantes acumulativas que separan cada causa, se hizo
antes de SPEC-015-A. Partiendo de la liquidación actual: decimal exacto suma 0,03 en junio;
el borde inclusivo suma 22,00 en junio; ninguno cambia abril ni mayo. No queda diferencia
sin explicar.

## Resultados verificados

Con la solución de referencia de `soluciones/funcionalidad-reporte/`, el 3 de octubre de
2026.

**Ajuste por redondeo.** S/ -0.02 en 2026-04, S/ -0.02 en 2026-05 y S/ -0.01 en 2026-06. No
cambia la conciliación, porque el total se calcula por comercio y no a partir de las filas.

**Ajuste por tope.** S/ 0.00 en abril y mayo. En junio, S/ -23698.32, de CM0004.

**Conciliación con la liquidación actual.** Exactamente la tabla de la sección anterior:
abril y mayo concilian, junio difiere en 22,03.

**Con la mantención correctiva.** Los parches `correccion-java.patch` y
`correccion-dotnet.patch` se aplican después del reporte y cambian solo el cálculo de la
comisión en `CalculadoraLiquidacion`: decimal exacto y borde superior inclusivo. Con ellos:

- La conciliación da cero en los tres periodos y en los dos stacks.
- Los dos stacks siguen produciendo la misma liquidación.
- Las liquidaciones de 2026-04 y 2026-05 no cambian de checksum.
- La de 2026-06 cambia de `61f2c13fed35a2ea2f0189dcc30e78227325bee57765baa9b1c31cff94e432eb`
  a `cd1466305e636d89e4f5af11421a98f97fc75f9dc677083caee8aed83a8c498a`.

Comercios cuyo total de comisiones cambia en 2026-06:

| Comercio | Antes | Después | Causa |
|---|---|---|---|
| CM0001 | 727.34 | 738.34 | Borde de tramo, TX002001 y TX002002 |
| CM0007 | 907.11 | 918.11 | Borde de tramo, TX002003 y TX002004 |
| CM0011 | 137.82 | 137.83 | Punto flotante, TX002037 |
| CM0016 | 493.99 | 494.00 | Punto flotante, TX002035 |
| CM0025 | 957.18 | 957.19 | Punto flotante, TX002036 |

El total de comisiones de junio pasa de 36 615,31 a 36 637,34. Con el monto de comisiones
también cambian el neto y, en los comercios con menos de seis meses, la retención.
