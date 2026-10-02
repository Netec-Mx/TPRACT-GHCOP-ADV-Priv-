> Los tiempos de este respaldo son estimados por el agente de verificación, salvo los que
> dicen «medido».

# Lab 1.4 - Salida grabada de respaldo (modo Ask, escenario Java)

Una sola conversación. Ningún paso modifica archivos.

## Paso 1 - `/lab-1-4-paso-1-prompt-vago`

Modo: Ask

Respuesta del chat:

Revisé `CalculadoraLiquidacion.java`. Estas son mis sugerencias de mejora, sin modificar ningún archivo:

1. **Método demasiado largo.** `procesarLiquidacionCompleta` hace casi todo: carga datos, calcula comisiones, aplica tope, descuenta contracargos, calcula retenciones, arma el desglose por medio de pago e imprime por consola. Conviene dividirlo en métodos pequeños con una sola responsabilidad.
2. **Anidamiento profundo.** Hay muchos `if` anidados (hasta nueve niveles). Se podría reducir con condiciones de guarda (`continue` o retorno temprano) y con la extracción de la búsqueda del tramo.
3. **Búsqueda del tramo.** El bucle con la bandera `tramoEncontrado` recorre todos los tramos aunque ya haya encontrado uno. Se puede cortar con `break` o extraer a un método `buscarPorcentajeDelTramo`.
4. **Mezcla de cálculo e impresión.** El método calcula y a la vez escribe en `System.out`. Separar el cálculo de la presentación facilitaría probarlo.
5. **Desglose por medio de pago.** Los `if/else` anidados por medio de pago se leen mejor con un `switch` o un mapa por medio de pago.
6. **Números repetidos.** Valores como `100.0`, `0.05`, `0.5`, `3.0` y `6` aparecen sueltos. Darles nombre ayudaría a entender la regla que representan.
7. **Dinero en `double`.** Para montos en soles convendría `BigDecimal`, que evita errores de redondeo.
8. **`Date` y `Calendar`.** La API `java.time` es más clara y menos propensa a errores.
9. **Bloque `catch` vacío.** El `catch (Exception e) {}` de la validación del registro tributario oculta cualquier error.
10. **Estado mutable en la clase.** `validarTransaccion` modifica contadores de instancia como efecto secundario de una validación.
11. **Pruebas.** No hay pruebas de esta clase.

Todo lo anterior es un conjunto amplio de ideas; no modifiqué nada. Si quieres, dime por cuál empezar.

Observaciones al margen, sin tocar: el comentario de Javadoc de `procesarLiquidacionCompleta` dice que "imprime por consola y devuelve la lista", que sí coincide con lo que hace el código; no vi contradicciones con las reglas de `escenario/README.md` en lo que revisé.

Tiempo: 14 s (estimado)

## Paso 2 - `/lab-1-4-paso-2-agregar-objetivo java`

Modo: Ask

Respuesta del chat:

Tomo el escenario Java. Las tres mejoras de mayor impacto para la legibilidad de `procesarLiquidacionCompleta`, en el orden en que las atacaría:

1. **Extraer el cálculo de la comisión de cada transacción** (líneas 138 a 197): la búsqueda del tramo, la comisión base, el recargo por cuotas y la creación de la línea de detalle. Es el bloque con más anidamiento y hoy se mezcla con el bucle de comercios y transacciones. Un método como `calcularComisionDeTransaccion(plan, transaccion)` dejaría el bucle principal en pocas líneas.
2. **Separar el cálculo de la impresión** (líneas 317 a 354): la salida por consola está dentro del mismo método que acumula los totales. Moverla a un método de presentación permitiría leer el cálculo sin ruido y probarlo sin capturar `System.out`.
3. **Aplanar el anidamiento del desglose por medio de pago** (líneas 284 a 315) y de los filtros por periodo y estado: los `if/else` en cascada se leen mejor con un `switch` sobre el medio de pago y con condiciones de guarda.

Para decidir por dónde empezar, la primera es la que más reduce la complejidad del método.

Nota al margen, sin tocar: hay números sueltos (`100.0`, `0.05`, `0.5`, `3.0`, `6`), `double` para dinero, `Date`/`Calendar` y un `catch` vacío en las líneas 263 a 282.

Tiempo: 8 s (estimado)

## Paso 3 - `/lab-1-4-paso-3-agregar-restricciones java`

Modo: Ask

Respuesta del chat:

| Mejora | Líneas | Por qué mejora la legibilidad | Riesgo de cambiar la salida |
|---|---|---|---|
| Extraer el cálculo de la comisión de una transacción (tramo, comisión base, recargo por cuotas y línea de detalle) a un método privado | 138-197 | Es el bloque más anidado del método y mezcla la regla de negocio con el recorrido de comercios y transacciones. Con un nombre propio, la regla 1 a 3 del `README` se lee en un solo lugar. | Bajo: la lógica se mueve sin cambiar el orden de las operaciones con `double`. Hay que conservar el orden de suma para no alterar los redondeos. |
| Separar la impresión por consola del cálculo de la liquidación | 317-354 | Hoy el método calcula y escribe a la vez. Aislar la presentación permite leer los totales sin ruido y probarlos sin capturar `System.out`. | Bajo: solo cambia dónde está el código. Hay que mantener el mismo orden de líneas y el formateo por `ConfiguracionRegional`. |
| Aplanar el desglose por medio de pago con un `switch` o un método que acumule por medio | 284-315 | Cuatro `if/else` anidados se reducen a una estructura plana en la que se ve de un vistazo qué hace cada medio de pago. | Medio: el `else` final suma en transferencia todo lo que no sea crédito, débito o billetera; el `switch` debe conservar ese caso por omisión para no cambiar los montos. |

Otros problemas vistos y no tocados: `double` para dinero, números sueltos, `Date`/`Calendar` y un `catch` vacío (líneas 263-282).

Tiempo: 9 s (estimado)

## Paso 4 - acción 1: `/explain` (método `procesarLiquidacionCompleta` seleccionado, líneas 82-364)

Modo: Ask (comando integrado de VS Code, sin skill del repositorio)

Respuesta del chat:

**Qué hace.** `procesarLiquidacionCompleta(periodo, rutaDirectorioDatos)` genera la liquidación mensual de todos los comercios activos, la imprime por consola y devuelve la lista de `Liquidacion`.

**Cómo lo hace, en orden:**

1. **Preparación.** Si el repositorio no está cargado, lo crea y carga los datos desde el directorio indicado. Calcula el inicio y el fin del periodo con `UtilidadesFecha` e imprime el encabezado.
2. **Recorrido de comercios.** Para cada comercio activo que no esté de baja y que tenga plan de comisiones, crea una `Liquidacion` con sus datos básicos.
3. **Comisiones.** Recorre las transacciones del comercio. Cada una pasa por `validarTransaccion` (descarta nulas, sin fecha, en moneda distinta de `PEN` o con monto no positivo y cuenta las descartadas). Si cae dentro del periodo y está aprobada, busca el tramo del plan que contiene el monto, aplica ese porcentaje al monto completo y suma el monto fijo por transacción. Si la transacción es en cuotas, agrega un recargo de 0,5 % por cada cuota sobre la primera, con máximo de 3 %. Guarda una línea de detalle y acumula totales.
4. **Tope.** Si el total de comisiones supera el tope mensual del plan, cobra el tope y marca la liquidación.
5. **Contracargos.** Suma los contracargos aprobados cuya fecha cae dentro del periodo.
6. **Retención.** Si el comercio tiene menos de seis meses de afiliación, retiene 5 % de lo transado menos comisiones menos contracargos, siempre que esa base sea positiva.
7. **Redondeo y neto.** Redondea los totales a dos decimales y calcula el monto neto con `obtenerMontoNeto`.
8. **Observación del registro tributario.** Revisa largo y prefijo del registro y deja una observación si no es habitual.
9. **Desglose por medio de pago.** Reparte los montos entre crédito, débito, billetera y transferencia.
10. **Salida.** Solo si el comercio tuvo al menos una transacción liquidada, lo agrega al resultado e imprime sus totales, el desglose y la observación. Al final imprime el total de comercios liquidados y de transacciones descartadas.

**Detalles que conviene saber.** El método hace cálculo e impresión a la vez. Los contadores `acumuladoGeneralTransado`, `acumuladoGeneralComisiones` y `transaccionesDescartadas` son del objeto y se acumulan entre llamadas. El `catch` de la línea 281 está vacío. Los tramos se tratan como no acumulativos, lo que coincide con la regla 2 de `escenario/README.md`.

Tiempo: 12 s (estimado)

## Paso 4 - acción 2: `/plan dividir este método en partes que se puedan probar por separado`

Modo: agente Plan (solo propone, no toca código)

Respuesta del chat:

**Plan: dividir `procesarLiquidacionCompleta` en partes que se puedan probar por separado**

Objetivo: que cada parte de la liquidación se pueda probar sin leer archivos ni capturar la consola, sin cambiar la salida del programa.

Antes de empezar, la referencia de comportamiento: ejecutar `bash scripts/comparar-escenarios.sh` y guardar la salida del periodo 2026-06 como línea base.

Pasos, de menor a mayor riesgo:

1. **Calcular el porcentaje del tramo.** Extraer la búsqueda del tramo (líneas 140-162) a un método que reciba el plan y el monto y devuelva el porcentaje. Probar con montos dentro de cada tramo, en el límite entre dos tramos y por encima del último.
2. **Calcular la comisión de una transacción.** Extraer la comisión base y el recargo por cuotas (líneas 164-180) a un método que devuelva los tres valores. Probar sin cuotas, con una cuota, con cuotas intermedias y con el recargo en su máximo.
3. **Aplicar el tope.** Extraer la comparación con el tope mensual (líneas 202-205).
4. **Sumar contracargos del periodo.** Extraer las líneas 207-226. Probar con estados distintos y fechas fuera del periodo.
5. **Calcular la retención.** Extraer las líneas 228-244. Probar con menos y más de seis meses y con base no positiva.
6. **Acumular el desglose por medio de pago.** Extraer las líneas 284-315 a un método que devuelva los cuatro montos y el conteo de cuotas.
7. **Separar la impresión.** Mover las líneas 317-354 a un método de presentación que reciba la liquidación ya calculada.
8. **Dejar `procesarLiquidacionCompleta` como coordinador** que llama a los métodos anteriores en el mismo orden.

Después de cada paso: compilar, correr `mvn test` y `bash scripts/comparar-escenarios.sh`. Si la comparación falla, revertir ese paso.

Riesgos: el orden de las operaciones con `double` puede cambiar redondeos; los contadores de la instancia se modifican dentro de `validarTransaccion` y hay que decidir dónde queda esa mutación; los métodos nuevos deben ser visibles para las pruebas sin cambiar la API pública.

Preguntas abiertas: ¿los métodos extraídos quedan privados con acceso de paquete para pruebas, o van a una clase nueva?

Tiempo: 15 s (estimado)

## Paso 4 - acción 3: `/lab-1-4-paso-4-comparar-resultados`

Modo: Ask

Respuesta del chat:

| Criterio | Paso 3 | /explain | /plan |
|---|---|---|---|
| Qué tipo de resultado entrega | Tabla de tres mejoras con líneas, motivo y riesgo | Explicación en prosa de lo que hace el método, por etapas | Plan de trabajo por pasos, con verificación y riesgos |
| Cuánto hubo que escribir para obtenerlo | Una invocación con el argumento `java`; el pedido está en el archivo de la skill | Una palabra, con el método seleccionado | Una frase corta tras el comando |
| Si se puede comparar con el de otro participante | Sí: formato y columnas fijos | Poco: la estructura y el largo varían de una ejecución a otra | Poco: los pasos y su granularidad varían |
| Si sirve tal cual para un pull request | Casi: sirve como justificación de qué cambiar y por qué, no como descripción del cambio ya hecho | No: es material para entender el código, no para revisar un cambio | No: es un plan previo al cambio, no describe un cambio hecho |
| Qué no respondió y habría hecho falta | No dice en qué orden aplicar las mejoras ni cómo verificar la equivalencia | No dice qué mejorar ni qué riesgos hay | No cita criterios de aceptación medibles ni decide en qué orden empezar con base en el impacto |

Conviene el paso 3 cuando se necesita un resultado comparable y revisable entre varias personas, `/explain` cuando solo hay que entender un método antes de tocarlo, y `/plan` cuando ya se decidió cambiar y falta ordenar el trabajo.

Tiempo: 9 s (estimado)

## Verificación

`git status --short` en el repositorio: ver informe final (sin cambios esperados).
