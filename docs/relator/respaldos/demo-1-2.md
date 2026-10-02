segundos: 52

(Nota: la medición incluye el tiempo de exploración del repositorio para redactar las respuestas.)

## Paso 1 (Ask, conversación nueva, sin archivos abiertos, sin referencias)

Texto escrito:

```
¿Cómo se calcula la retención de garantía de un comercio en este sistema?
```

Referencias usadas: ninguna (solo las instrucciones del repositorio, `AGENTS.md` y `.github/copilot-instructions.md`, que no tratan este tema).

Respuesta de Copilot (Ask):

No tengo ningún archivo del repositorio en el contexto, así que no puedo decirte cómo lo calcula este sistema en concreto. Lo que sí puedo decirte es cómo suele funcionar una retención de garantía en una procesadora de pagos:

- Es un porcentaje del monto que se retiene al comercio durante un tiempo como respaldo frente a contracargos o devoluciones.
- Suele aplicarse sobre el monto liquidado (ventas menos comisiones y contracargos) y se libera pasado un plazo.
- Muchas veces depende de la antigüedad o del riesgo del comercio: los comercios nuevos tienen un porcentaje mayor o una retención que los demás no tienen.

Las reglas de negocio del repositorio están, según el `AGENTS.md`, en `escenario/README.md`, pero no las tengo cargadas. Si adjuntas ese archivo o la clase que calcula la liquidación con `#file`, o me pides que busque con `#codebase`, te respondo con la regla exacta y las líneas.

## Paso 2 (Ask, conversación nueva)

Texto escrito:

```
#file:escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java ¿Cómo se calcula la retención de garantía de un comercio en este sistema?
```

Referencias usadas: FormateadorReporte.java

Respuesta de Copilot (Ask):

En `FormateadorReporte.java` la retención no se calcula. Esta clase solo arma texto para el reporte:

- En `formatearResumenGeneral` (líneas 17 a 54) suma `liquidacion.getRetenciones()` de cada liquidación en `sumaRetenciones` (línea 32) y la imprime como "Total retenciones" (línea 49).
- `obtenerMontoNeto()` también se suma en ese resumen (línea 33), pero cómo se obtiene ese neto no está en este archivo.

El valor de `getRetenciones()` llega ya calculado dentro de cada objeto `Liquidacion`. La regla (porcentaje, a quién se aplica, sobre qué base) debe estar en la clase que arma las liquidaciones, probablemente en el paquete `calculo`, que no tengo en el contexto. Si adjuntas esa clase con `#file` te digo cómo se calcula.

## Paso 3 (Ask, conversación nueva)

Texto escrito:

```
#file:escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java ¿Cómo se calcula la retención de garantía de un comercio en este sistema?
```

Referencias usadas: CalculadoraLiquidacion.java

Respuesta de Copilot (Ask):

La retención se calcula en `CalculadoraLiquidacion.java`, dentro del bloque que va de la línea 228 a la 250:

1. **Condición de antigüedad (líneas 230 a 236).** Se toma la fecha de afiliación del comercio. Si no es nula, se calculan los meses entre la afiliación y el inicio del periodo con `utilidadesFecha.mesesEntre(fechaAfiliacion, inicioPeriodo)` (línea 234). Solo si `meses < 6` (línea 236) se aplica retención. Si la fecha de afiliación es nula o el comercio tiene seis meses o más, la retención queda en 0.0.
2. **Base de cálculo (línea 238).** `baseRetencion = totalTransado - totalComisiones - totalContracargos`. Los `totalComisiones` ya incluyen el tope mensual del plan, aplicado antes (línea 202).
3. **Porcentaje (línea 241).** Si la base es mayor que cero (línea 240), `retenciones = baseRetencion * 0.05`, es decir 5 %. Con base cero o negativa la retención es 0.
4. **Redondeo (línea 249).** `Math.round(retenciones * 100.0) / 100.0`, a dos decimales.
5. **Efecto.** Se guarda con `liquidacion.setRetenciones(retenciones)` (línea 254) y se muestra en el reporte de consola como "Retenciones" (línea 327). `Liquidacion.obtenerMontoNeto()` la resta del neto, junto con comisiones y contracargos.

Esto coincide con la regla 7 de `escenario/README.md`: menos de seis meses de afiliación, 5 % sobre el monto neto.

## Paso 4 (Ask, conversación nueva)

Texto escrito:

```
#codebase ¿Cómo se calcula la retención de garantía de un comercio en este sistema?
```

Referencias usadas (resultado de la búsqueda en el espacio de trabajo): escenario/README.md, escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java, escenario/java/src/main/java/pe/pasarelaandina/calculo/UtilidadesFecha.java, escenario/java/src/main/java/pe/pasarelaandina/modelo/Liquidacion.java, escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs

Respuesta de Copilot (Ask):

Busqué en el espacio de trabajo. La regla está en dos lugares, el README del escenario y el código de cálculo, y existe en las dos versiones, Java y .NET.

**Regla de negocio** (`escenario/README.md`, regla 7): un comercio con menos de seis meses de afiliación tiene una retención de garantía del 5 % sobre el monto neto.

**Implementación en Java** (`escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java`, líneas 228 a 250):
- Calcula los meses completos entre la fecha de afiliación y el inicio del periodo con `UtilidadesFecha.mesesEntre` (resta años y meses, y descuenta uno si el día del mes del periodo es menor que el de afiliación).
- Si `meses < 6`, la base es `totalTransado - totalComisiones - totalContracargos`; si es positiva, la retención es `base * 0.05`.
- Se redondea a dos decimales y se guarda con `setRetenciones`.
- `Liquidacion.obtenerMontoNeto()` la descuenta: transado menos comisiones, contracargos y retenciones.

**Implementación en .NET** (`escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs`, líneas 233 a 241): la misma lógica con `MesesEntre` y `baseRetencion * 0.05`.

Observación: la regla dice "sobre el monto neto", y la base que usa el código no resta la propia retención; es el neto antes de retenciones. Si necesitas que sea otra cosa, avísame.

## Esperado contra observado

- Paso 1: coincide. Respuesta genérica, sin referencias del repositorio. No hubo búsqueda propia porque el pedido no incluye `#codebase` (el script prevé "genérica o búsqueda propia").
- Paso 2: coincide. El modelo dice que en ese archivo solo se suma la retención ya calculada (líneas 32 y 49).
- Paso 3: coincide. Condición de antigüedad (meses < 6), base (transado menos comisiones menos contracargos), 5 % y líneas citadas.
- Paso 4: coincide parcialmente. Encuentra la clase correcta, pero ve ambos escenarios (Java y .NET) y el README, más de lo que el script describe; la "más demora" no es medible en esta simulación.
