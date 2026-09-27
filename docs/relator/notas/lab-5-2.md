# Notas del relator, laboratorio 5.2

Planeación de mejora, refactorización y validación incremental. 45 minutos.

## Qué va a pasar en la sala

El paso 1 lista los valores de negocio escritos como literales en las dos clases de
cálculo. Ahí aparece la inconsistencia del tope del recargo por cuotas, 3.0 en la
liquidación y 3.5 en la calculadora de comisión (DEF-03). La regla 3 dice 3 %, así que la
liquidación cobra bien y el simulador comercial cotiza de más. Deje que la sala lo
descubra en la tabla. La pregunta para la conversación es qué incremento del plan
unificaría ese valor y por qué conviene no hacerlo en este laboratorio. Cambiaría la
salida del simulador sin que nadie lo haya decidido.

Los pasos 2 y 3 extraen dos bloques del método de cálculo (DEF-02, DEF-06). El paso 4
corre el comparador. Una refactorización correcta no cambia la salida, y el comparador lo
dice en segundos.

Este laboratorio no toca el dinero en punto flotante (DEF-01). Migrar a un tipo decimal
cambiaría la salida y rompería la comparación entre escenarios, que es justo lo que el
paso 4 verifica. Ese ejercicio queda disponible en el 5.4.

## Errores típicos

- Extraer solo el cálculo de la comisión y dejar fuera la construcción del detalle. No
  compila, porque `comisionBase` y `recargo` se usan más abajo. La skill lo advierte.
- Olvidar que los acumuladores leían `montoTransaccion` y `comisionTotal`. Deben pasar a
  leer del detalle devuelto.
- Aceptar que el agente «aproveche» para unificar el tope del recargo o para extraer
  constantes. El diff lo muestra, pero el comparador no lo detecta. La salida
  del programa incluye una simulación de 1500.00 en 3 cuotas, cuyo recargo es 1 % y nunca
  llega al tope, así que unificar el tope no cambia ni una línea. Es el mejor momento para
  mostrar que un gate verde no alcanza.

## Tiempos

| Paso | Estimado | Observado en la verificación |
|---|---|---|
| 1 | 10 min | 33 s de agente |
| 2 | 12 min | 36 a 44 s de agente por escenario, con compilación, pruebas y comparador |
| 3 | 12 min | 41 a 46 s de agente por escenario |
| 4 | 8 min | 38 s de agente |

El comparador compila los dos escenarios y tarda cerca de un minuto en la máquina de
construcción. En la máquina virtual puede tardar más.

## Variabilidad observada

Las dos ejecuciones de verificación del paso 2 dieron el mismo resultado estructural con
nombres distintos para el método nuevo, `calcularDetalleLiquidacion` y
`calcularDetalleTransaccion`. Las dos del paso 3 coincidieron en el nombre,
`imprimirDesglosePorMedioPago`, y en la ubicación. Todas terminaron con el comparador en
cero.

## Si alguien se atrasa

Los pasos 2 y 3 son independientes. Si alguien no hizo el 2, hace el 3, y viceversa. El
paso 4 funciona sin cambios previos. Si un paso deja el código sin compilar, que reinicie
con `bash scripts/reiniciar-lab.sh lab-5-2` y lo repita.

## Solución de referencia

En `docs/relator/soluciones/lab-5-2/`, para Java y .NET:

- `paso-2-extraer-comision-*.patch`
- `paso-3-extraer-desglose-medios-*.patch`
- `pasos-2-y-3-combinados-*.patch`, los dos cambios aplicados uno sobre otro

Todas verificadas sobre una copia limpia del repositorio de participantes. Compilan, las
20 pruebas pasan y el comparador termina en cero. Los parches individuales de los pasos 2 y
3 no se aplican uno sobre otro con `git apply`, porque los dos insertan su método en el
mismo lugar. Para mostrar los dos cambios juntos use el combinado.
