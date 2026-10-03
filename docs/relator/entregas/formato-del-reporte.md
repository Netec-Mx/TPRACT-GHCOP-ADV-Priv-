# Especificación técnica del reporte de comisiones por medio de pago

**De:** Área de Sistemas, Pasarela Andina
**Para:** Equipo de desarrollo
**Complementa:** la historia de usuario del reporte, con las respuestas del negocio

El área comercial va a cargar el reporte en su planilla de forma automática. Por eso el
formato tiene que ser exactamente este. `scripts/verificar-reporte.sh` lo comprueba.

## Invocación

Con la misma clase ejecutable de la liquidación, con `--reporte-medios` como primer
argumento. El periodo y la ruta de datos van después y conservan su significado y sus
valores por omisión. Sin `--reporte-medios`, la liquidación no puede cambiar en un solo byte.

```bash
java -jar target/liquidacion-comercios.jar --reporte-medios 2026-06
dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll --reporte-medios 2026-06
```

## Salida

Texto UTF-8 con fin de línea `\n`, en este orden.

1. Encabezado de seis líneas, con el mismo marco que la liquidación: una línea de 58 signos
   `=`, `  PASARELA ANDINA - COMISIONES POR MEDIO DE PAGO`, `  Periodo: AAAA-MM`,
   `  Desde: dd/MM/yyyy HH:mm`, `  Hasta: dd/MM/yyyy HH:mm` y otra línea de 58 signos `=`.
   Las fechas son las mismas que imprime la liquidación del periodo.
2. Una línea en blanco.
3. La tabla, en columnas de ancho fijo sin separadores:

   | Columna | Ancho | Alineación |
   |---|---|---|
   | `Medio de pago` | 15 | Izquierda |
   | `Transacciones` | 16 | Derecha |
   | `Monto transado` | 18 | Derecha |
   | `Comision` | 16 | Derecha |
   | `Participacion` | 16 | Derecha |

   La primera fila es la de títulos, con esos textos. Después, una fila por medio de pago,
   con el código del medio (`BILLETERA_MOVIL`, `TARJETA_CREDITO`...), en orden alfabético
   del código.
4. Una línea de 81 guiones.
5. Tres filas de pie, con la etiqueta en 49 caracteres alineada a la izquierda y el monto en
   16 alineado a la derecha: `Ajuste por tope`, `Ajuste por redondeo` y `Total`.

## Formato de los valores

- Montos: `S/ ` seguido del valor con punto decimal, dos decimales y sin separador de miles.
  Los negativos llevan el signo después del prefijo: `S/ -1234.56`.
- Porcentajes: el valor con punto decimal y dos decimales, y el sufijo ` %`.
- Cantidades: el número entero, sin separadores.

## Qué es cada valor

- **Comisión de una fila:** la suma de las comisiones de las transacciones de ese medio,
  antes de aplicar el tope, redondeada a dos decimales al final.
- **Participación:** la comisión de la fila sobre la suma de las comisiones de todas las
  filas, por cien.
- **Ajuste por tope:** en negativo, lo que se descuenta a los comercios que superan su tope
  mensual.
- **Total:** el total de comisiones calculado como en la liquidación, por comercio.
- **Ajuste por redondeo:** el total menos la suma de las filas menos el ajuste por tope.
  Se muestra siempre, aunque sea cero.

## Ejemplo de forma

Los valores son inventados. Solo muestran la forma.

```
==========================================================
  PASARELA ANDINA - COMISIONES POR MEDIO DE PAGO
  Periodo: 2026-01
  Desde: 01/01/2026 00:00
  Hasta: 31/01/2026 23:59
==========================================================

Medio de pago     Transacciones    Monto transado        Comision   Participacion
BILLETERA_MOVIL              10        S/ 1000.00        S/ 30.00         50.00 %
TRANSFERENCIA                10        S/ 1000.00        S/ 30.00         50.00 %
---------------------------------------------------------------------------------
Ajuste por tope                                           S/ 0.00
Ajuste por redondeo                                       S/ 0.00
Total                                                    S/ 60.00
```
