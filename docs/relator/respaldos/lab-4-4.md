> Los tiempos de este respaldo son aproximados. Miden los comandos de cada paso, no la
> generación del texto.

# Lab 4.4 salida grabada de respaldo

Nota sobre los segundos: son los medidos entre el inicio y el fin de los comandos de cada paso (lectura, escritura). No incluyen el tiempo de generación del texto. Sin llamadas MCP en este lab. Reinicio previo con `bash scripts/reiniciar-lab.sh lab-4-4 --si`: ya estaba en el punto de partida.

## Paso 1: `/lab-4-4-paso-1-documentar-reglas java`

Segundos: 45. Archivos leídos: `CalculadoraComision.java`, `PlanComisiones.java`, `CalculadoraLiquidacion.java`, `UtilidadesFecha.java`, `Liquidacion.java`, `EstadoTransaccion.java`, `escenario/README.md`. Se aplicó `.github/instructions/java.instructions.md` (solo lectura; no se editó código Java).

### Respuesta final del chat

He creado `labs/cap4/lab-4-4-documentacion/entregables/calculo-de-comisiones.md`, con cada afirmación citando archivo y línea, y la sección final «Contraste con las reglas declaradas».

Resultado del contraste con las 9 reglas de `escenario/README.md`:
- **Coinciden 7**: reglas 1, 2, 4, 5, 6, 7 y 9.
- **No coinciden, o coinciden solo en parte, 2**: la regla 3 (el tope del recargo por cuotas es 3.0 en `CalculadoraLiquidacion.java:173-175`, pero 3.5 en `CalculadoraComision.java:53-55`) y la regla 8 (el periodo usa la zona horaria del sistema, `UtilidadesFecha.java:35`, y no fija Lima).

Observaciones fuera del alcance del paso, que no toqué:
- El comentario de `PlanComisiones.java:9-10` dice que los tramos son acumulativos; el código aplica el porcentaje al monto completo y la regla 2 también. El código y el README mandan sobre el comentario.
- El cálculo real está en línea en `CalculadoraLiquidacion.java`; `CalculadoraComision` solo la usa `SimuladorComision`. Los límites de tramo difieren (`<` en `CalculadoraLiquidacion.java:149`, `<=` en `CalculadoraComision.java:23`).
- El bloque `catch` vacío en `CalculadoraLiquidacion.java:281-282` y el uso de `double` para montos.
- El acumulado general de comisiones se suma antes de aplicar el tope (`CalculadoraLiquidacion.java:196`).

Recomiendo abrir dos o tres de las líneas citadas (por ejemplo `CalculadoraLiquidacion.java:164`, `:173` y `:202`) y compararlas con lo que dice el documento.

Salida esperada (documento creado y número de reglas que coinciden y no coinciden): cumplida.

### Archivo creado: `calculo-de-comisiones.md`

# Cálculo de comisiones según el código (escenario Java)

Este documento describe lo que hace el código, no lo que dicen sus comentarios. Las rutas
son relativas a `escenario/java/src/main/java/pe/pasarelaandina/`. Abreviaturas:
`Liq` = `calculo/CalculadoraLiquidacion.java`, `Com` = `calculo/CalculadoraComision.java`,
`Plan` = `modelo/PlanComisiones.java`, `Fecha` = `calculo/UtilidadesFecha.java`.

## 1. Qué clase calcula de verdad

El cálculo que produce la liquidación está escrito en línea dentro de
`procesarLiquidacionCompleta` (`Liq:82-364`). No llama a `CalculadoraComision`: esa clase
solo la usa `calculo/SimuladorComision.java` (búsqueda de referencias en `escenario/java/src`).
Por eso hay dos versiones del cálculo de una transacción y no son idénticas (ver secciones 3 y 4).

## 2. Qué transacciones entran

1. Una transacción se descarta, y se cuenta en `transaccionesDescartadas`, si es nula, no tiene
   fecha, su moneda no es `PEN` o su monto es menor o igual a cero (`Liq:57-73`). Solo las
   válidas suman a `acumuladoGeneralTransado` (`Liq:74`).
2. Debe caer en el periodo: no anterior al inicio y no posterior al fin (`Liq:136`).
3. Debe estar en estado `APROBADA` (`Liq:138`). Las `ANULADA`, `RECHAZADA` y `PENDIENTE` no
   generan comisión (estados en `modelo/EstadoTransaccion.java:6-9`).
4. Se liquidan los comercios que no están `DE_BAJA` (`Liq:110-112`) y cuyo plan existe (`Liq:114-116`).
   Un comercio sin transacciones liquidadas no se imprime ni se agrega al resultado (`Liq:317-319`).

## 3. Selección del tramo y porcentaje

- Flujo de liquidación: recorre los tramos en orden y toma el primero con
  `monto >= desde` y `monto < hasta` (`Liq:144-155`). Si ninguno calza, toma el porcentaje del
  último tramo (`Liq:157-162`).
- `CalculadoraComision.determinarTramo` usa `monto >= desde` y `monto <= hasta` (`Com:23`), es
  decir, el límite superior es inclusivo. Un monto exactamente igual a un límite cae en tramos
  distintos según qué versión se use.
- Los tramos **no son acumulativos** en el código: el porcentaje del tramo encontrado se
  aplica al monto completo (`Liq:164`, `Com:38-39`). El comentario de `Plan:9-10` afirma lo
  contrario (que son acumulativos); el código no lo hace así.

## 4. Comisión base, monto fijo y recargo por cuotas

- Comisión base = `monto * porcentaje / 100` y luego se suma el monto fijo del plan
  (`Liq:164-165`, `Com:39-40`).
- Recargo por cuotas: si `cuotas > 1`, el porcentaje de recargo es `(cuotas - 1) * 0.5`
  (`Liq:169-171`), con tope de `3.0` en el flujo de liquidación (`Liq:173-175`). El recargo se
  calcula sobre la comisión base, ya con el monto fijo incluido: `comisionBase * porcentajeRecargo / 100`
  (`Liq:177`).
- En `CalculadoraComision` el mismo tope es `3.5` (`Com:53-55`), no `3.0`.
- Comisión total de la transacción = base + recargo (`Liq:180`, `Com:65`).
- El monto de cada línea de detalle no se redondea (`Liq:182-190`).

## 5. Total del comercio y tope mensual

- `totalTransado`, `totalComisiones` y `cantidadTransacciones` se acumulan con `double`
  (`Liq:192-194`).
- Si `totalComisiones` supera el tope del plan, se reemplaza por el tope y se marca
  `topeAplicado` (`Liq:202-205`). El acumulado general de comisiones se suma antes del tope
  (`Liq:196`), por lo que no refleja el tope.

## 6. Contracargos

Se suman los contracargos del comercio con estado `APROBADO`, fecha no nula y fecha dentro
del periodo (`Liq:211-226`). La fecha es la de aprobación según `escenario/README.md`, de modo que
se descuentan en el periodo en que se aprueban. No se descuentan en el periodo de la transacción
original.

## 7. Retención de garantía

Si el comercio tiene fecha de afiliación, se calculan los meses completos entre esa fecha y el
inicio del periodo (`Liq:230-234`, `Fecha:125-143`). Si son menos de 6, la base es
`totalTransado - totalComisiones - totalContracargos` y, si es positiva, la retención es el 5 %
de esa base (`Liq:236-243`). Ese 5 % es un literal en la línea 241.

## 8. Redondeo y neto

- `totalTransado`, `totalComisiones`, `totalContracargos` y `retenciones` se redondean con
  `Math.round(x * 100.0) / 100.0` (`Liq:246-249`). Se redondea solo en los totales.
- El neto es `totalTransado - totalComisiones - totalContracargos - retenciones`
  (`modelo/Liquidacion.java:99-101`) y se vuelve a redondear (`Liq:257-259`).

## 9. Periodo

El inicio es el día 1 a las 00:00:00 y el fin el último día a las 23:59:59 (`Fecha:77-108`). Se
usa `Calendar.getInstance(ConfiguracionRegional.REGION_DE_SALIDA)` (`Fecha:35`), que fija la
configuración regional pero no la zona horaria: se toma la del sistema (`util/ConfiguracionRegional.java:34-35`).

## Contraste con las reglas declaradas

Reglas de `escenario/README.md`, secciones «Reglas de negocio» 1 a 9.

| Regla | Qué dice | Qué hace el código | Resultado |
|---|---|---|---|
| 1 | Porcentaje del tramo más monto fijo | `Liq:164-165` | Coincide |
| 2 | Tramos no acumulativos | `Liq:164` aplica el porcentaje al monto completo. El comentario `Plan:9-10` dice lo contrario | Coincide el código. El comentario contradice la regla |
| 3 | Recargo 0,5 % por cuota sobre la primera, máximo 3 % | Flujo de liquidación: tope 3.0 (`Liq:173-175`). `CalculadoraComision`: tope 3.5 (`Com:53-55`) | No coincide en `CalculadoraComision`; coincide en la liquidación |
| 4 | Anuladas no generan comisión | Solo `APROBADA` genera comisión (`Liq:138`) | Coincide (y también excluye rechazadas y pendientes) |
| 5 | Contracargos aprobados en el periodo en que se aprueban | `Liq:213-222` | Coincide |
| 6 | Si el total supera el tope, se cobra el tope | `Liq:202-205` | Coincide |
| 7 | Retención del 5 % si hay menos de seis meses | `Liq:236-243`; la base es transado menos comisiones menos contracargos | Coincide (la base «monto neto» se interpreta así, sin restar la retención) |
| 8 | Periodo en hora de Lima | `Fecha:35` y `Fecha:77-108` usan la zona horaria del sistema, no fijan Lima | No coincide, o depende de la máquina |
| 9 | Dos decimales, medio hacia arriba | `Math.round(x * 100.0) / 100.0` en totales (`Liq:246-249`). Las líneas de detalle no se redondean | Coincide en los totales |

Resumen: coinciden 7 reglas (1, 2, 4, 5, 6, 7, 9). No coinciden o coinciden solo en parte 2
(3, en `CalculadoraComision`; y 8, la zona horaria).

## Paso 2: `/lab-4-4-paso-2-documentar-decisiones`

Segundos: 22. Archivos leídos: `escenario/README.md`, `ConfiguracionRegional.java`, `CompatibilidadJava.cs`, `scripts/comparar-escenarios.sh`, `AplicacionLiquidacion.java` y `.cs`.

### Pregunta del skill al participante y respuesta
Pregunta: «Dos decisiones salen del material de partida (configuración regional fija en Java y aritmética decimal compatible con Java en .NET). ¿Cuál quieres como tercera?»
Respuesta: «Que los datos de ejemplo vivan en escenario/datos, compartidos por los dos escenarios»

### Respuesta final del chat

He creado `labs/cap4/lab-4-4-documentacion/entregables/decisiones.md` con tres decisiones, cada una con Contexto, Decisión y Consecuencias, respaldadas con archivo y línea:
1. Fijar la configuración regional de la salida del escenario Java (`ConfiguracionRegional`).
2. Reproducir en .NET la aritmética decimal de Java (`CompatibilidadJava`).
3. Datos de ejemplo en `escenario/datos`, compartidos por los dos escenarios (tu elección).

Dos matices que dejé escritos como consecuencia verificable: la zona horaria no está fijada por la decisión 1, y la clase de la decisión 2 hoy no cambia ningún resultado observable, según su propio comentario. No modifiqué código. Verificación disponible: `bash scripts/comparar-escenarios.sh` (no la ejecuté porque este paso no la pide).

Salida esperada (documento creado): cumplida.

### Archivo creado: `decisiones.md`

# Registro de decisiones técnicas del escenario

Cada decisión cita el archivo y la línea que la respalda. Las rutas son relativas a la raíz
del repositorio.

## Decisión 1. Fijar la configuración regional de la salida del escenario Java

### Contexto

El formateo de números y fechas en Java depende de la configuración regional de la máquina. El
mismo programa sobre los mismos datos imprime `26074.08` o `26074,08` según el idioma
(`escenario/java/src/main/java/pe/pasarelaandina/util/ConfiguracionRegional.java:12-20`). Las
máquinas virtuales del taller están en Perú y es probable que estén en español
(`ConfiguracionRegional.java:22-23`). Los dos escenarios deben dar la misma salida hasta el último
centavo (`escenario/README.md`, sección «Datos de ejemplo»).

### Decisión

Se creó la clase `ConfiguracionRegional` con una única constante, `REGION_DE_SALIDA = Locale.ROOT`
(`ConfiguracionRegional.java:42`), y todo formateo de salida la usa, por ejemplo
`String.format(ConfiguracionRegional.REGION_DE_SALIDA, "%.2f", monto)`
(`calculo/CalculadoraLiquidacion.java:367`), los formatos de fecha
(`calculo/UtilidadesFecha.java:40`) y el calendario (`UtilidadesFecha.java:35`). Archivos que la
referencian: `AplicacionLiquidacion.java`, `FormateadorReporte.java`, `UtilidadesFecha.java` y
`CalculadoraLiquidacion.java`. El equivalente en .NET fija `CultureInfo.InvariantCulture` al
arrancar (`escenario/dotnet/LiquidacionComercios/AplicacionLiquidacion.cs:36-39`).

### Consecuencias

- Se gana una salida que no depende del idioma de la máquina.
- No cubre la zona horaria: el propio comentario dice que sigue siendo la del sistema
  (`ConfiguracionRegional.java:34-35`, `UtilidadesFecha.java:30-32`).
- Obliga a usar `REGION_DE_SALIDA` en cada nuevo `String.format` o formato de fecha de salida; si
  alguien la quita, la comparación entre escenarios falla en una máquina en español
  (`ConfiguracionRegional.java:30-32`; `.github/instructions/java.instructions.md`).
- Verificable con `bash scripts/comparar-escenarios.sh`, que termina en cero si las salidas coinciden.

## Decisión 2. Reproducir en .NET la aritmética decimal de Java

### Contexto

Java y .NET redondean y formatean distinto. `Math.round(x * 100.0) / 100.0` de Java suma 0,5 y
trunca, mientras que `Math.Round` de .NET usa redondeo bancario; el comentario cita 957.185, que da
957.19 en Java y 957.18 en .NET. Además `ToString("F2")` produjo 497 diferencias sobre 6016
valores (`escenario/dotnet/LiquidacionComercios/Util/CompatibilidadJava.cs:16-28`).

### Decisión

Se creó la clase `CompatibilidadJava` en .NET, que no es idiomática a propósito
(`CompatibilidadJava.cs:9`). Tiene `RedondearADosDecimales`, que usa
`Math.Floor(valor * 100.0 + 0.5) / 100.0` (`CompatibilidadJava.cs:57-60`), y `FormatearDosDecimales`,
que parte de la representación corta `"R"` y redondea con `MidpointRounding.AwayFromZero`
(`CompatibilidadJava.cs:70-77`). También concentra la lectura de decimales y enteros sin depender de
la cultura (`CompatibilidadJava.cs:83-94`).

### Consecuencias

- Se gana equivalencia exacta con Java, verificada según el comentario sobre 6016 valores.
- Con los datos actuales no cambia ningún resultado observable: sobre los 382 valores que se
  formatean, las variantes coinciden (`CompatibilidadJava.cs:30-35`). Es protección defensiva.
- Se pierde el código idiomático de .NET en esa clase, y obliga a pasar por ella todo redondeo y
  formateo de montos, y a no sustituirla por `Math.Round` ni `ToString("F2")`.
- Un cambio hecho para limpiar la clase no rompería la comparación hoy (`CompatibilidadJava.cs:45-47`),
  así que esa comparación no basta como red de seguridad.

## Decisión 3. Los datos de ejemplo viven en `escenario/datos`, compartidos por los dos escenarios

La eligió el participante.

### Contexto

El mismo dominio se implementa en Java y en .NET, y ambos deben dar resultados idénticos. Si cada
proyecto tuviera su copia de los archivos, podrían divergir y la comparación perdería sentido.

### Decisión

Los datos están en `escenario/datos/` como archivos de texto plano separados por punto y coma, con
encabezado, fuera de `java/` y de `dotnet/` (`escenario/README.md`, sección «Datos de ejemplo»).
Ambos ejecutables apuntan por omisión a `../datos`
(`escenario/java/src/main/java/pe/pasarelaandina/AplicacionLiquidacion.java:27-29`;
`escenario/dotnet/LiquidacionComercios/AplicacionLiquidacion.cs:25-27`), y el comentario de cada uno
dice que es para que ninguno de los dos proyectos sea su dueño. El servidor MCP local también los lee
(`mcp/servidor-local/servidor.js:21-22`).

### Consecuencias

- Se gana una sola fuente de datos y una comparación entre escenarios que depende solo del código.
- Obliga a ejecutar cada escenario desde su propio directorio, porque la ruta relativa `../datos` solo
  resuelve desde `escenario/java/` o `escenario/dotnet/` (`escenario/README.md`, sección «Cómo se ejecuta»).
- Un cambio en los datos altera los resultados de ambos escenarios a la vez; por eso las notas del
  servidor MCP viven aparte, en `mcp/datos` (`mcp/servidor-local/servidor.js:6-8`).
- Los dos cargadores deben interpretar el formato igual (punto decimal, separador `;`); .NET lo logra
  con `CompatibilidadJava.LeerDecimal` (`escenario/dotnet/LiquidacionComercios/Repositorio/CargadorDatos.cs:47-48`).

## Paso 3: `/lab-4-4-paso-3-preparar-para-confluence` (sin argumento)

Segundos: 5. Sin argumento: se usó por omisión `calculo-de-comisiones.md`, que existe.

### Respuesta final del chat

He creado `labs/cap4/lab-4-4-documentacion/entregables/calculo-de-comisiones-confluence.md`, copia de `calculo-de-comisiones.md`, que no se modificó.

Lo que se perdió o cambió, tras revisar las cuatro categorías:
- Enlaces relativos al repositorio: no había ninguno (las rutas ya estaban como texto en código); no se cambió nada.
- Tablas con celdas de varias líneas: ninguna.
- Bloques de código sin lenguaje: ninguno (no hay bloques delimitados).
- HTML incrustado: ninguno.

En consecuencia la copia solo agrega la sección «Qué se perdió en el traslado», que lo registra. Lo que Confluence no puede conservar es la navegabilidad de las rutas y la vigencia de las citas de línea.

Salida esperada (copia creada y lista de lo que se perdió): cumplida, con la salvedad de que el documento no contenía nada que reemplazar.

### Archivo creado: `calculo-de-comisiones-confluence.md`

# Cálculo de comisiones según el código (escenario Java)

Este documento describe lo que hace el código, no lo que dicen sus comentarios. Las rutas
son relativas a `escenario/java/src/main/java/pe/pasarelaandina/`. Abreviaturas:
`Liq` = `calculo/CalculadoraLiquidacion.java`, `Com` = `calculo/CalculadoraComision.java`,
`Plan` = `modelo/PlanComisiones.java`, `Fecha` = `calculo/UtilidadesFecha.java`.

## 1. Qué clase calcula de verdad

El cálculo que produce la liquidación está escrito en línea dentro de
`procesarLiquidacionCompleta` (`Liq:82-364`). No llama a `CalculadoraComision`: esa clase
solo la usa `calculo/SimuladorComision.java` (búsqueda de referencias en `escenario/java/src`).
Por eso hay dos versiones del cálculo de una transacción y no son idénticas (ver secciones 3 y 4).

## 2. Qué transacciones entran

1. Una transacción se descarta, y se cuenta en `transaccionesDescartadas`, si es nula, no tiene
   fecha, su moneda no es `PEN` o su monto es menor o igual a cero (`Liq:57-73`). Solo las
   válidas suman a `acumuladoGeneralTransado` (`Liq:74`).
2. Debe caer en el periodo: no anterior al inicio y no posterior al fin (`Liq:136`).
3. Debe estar en estado `APROBADA` (`Liq:138`). Las `ANULADA`, `RECHAZADA` y `PENDIENTE` no
   generan comisión (estados en `modelo/EstadoTransaccion.java:6-9`).
4. Se liquidan los comercios que no están `DE_BAJA` (`Liq:110-112`) y cuyo plan existe (`Liq:114-116`).
   Un comercio sin transacciones liquidadas no se imprime ni se agrega al resultado (`Liq:317-319`).

## 3. Selección del tramo y porcentaje

- Flujo de liquidación: recorre los tramos en orden y toma el primero con
  `monto >= desde` y `monto < hasta` (`Liq:144-155`). Si ninguno calza, toma el porcentaje del
  último tramo (`Liq:157-162`).
- `CalculadoraComision.determinarTramo` usa `monto >= desde` y `monto <= hasta` (`Com:23`), es
  decir, el límite superior es inclusivo. Un monto exactamente igual a un límite cae en tramos
  distintos según qué versión se use.
- Los tramos **no son acumulativos** en el código: el porcentaje del tramo encontrado se
  aplica al monto completo (`Liq:164`, `Com:38-39`). El comentario de `Plan:9-10` afirma lo
  contrario (que son acumulativos); el código no lo hace así.

## 4. Comisión base, monto fijo y recargo por cuotas

- Comisión base = `monto * porcentaje / 100` y luego se suma el monto fijo del plan
  (`Liq:164-165`, `Com:39-40`).
- Recargo por cuotas: si `cuotas > 1`, el porcentaje de recargo es `(cuotas - 1) * 0.5`
  (`Liq:169-171`), con tope de `3.0` en el flujo de liquidación (`Liq:173-175`). El recargo se
  calcula sobre la comisión base, ya con el monto fijo incluido: `comisionBase * porcentajeRecargo / 100`
  (`Liq:177`).
- En `CalculadoraComision` el mismo tope es `3.5` (`Com:53-55`), no `3.0`.
- Comisión total de la transacción = base + recargo (`Liq:180`, `Com:65`).
- El monto de cada línea de detalle no se redondea (`Liq:182-190`).

## 5. Total del comercio y tope mensual

- `totalTransado`, `totalComisiones` y `cantidadTransacciones` se acumulan con `double`
  (`Liq:192-194`).
- Si `totalComisiones` supera el tope del plan, se reemplaza por el tope y se marca
  `topeAplicado` (`Liq:202-205`). El acumulado general de comisiones se suma antes del tope
  (`Liq:196`), por lo que no refleja el tope.

## 6. Contracargos

Se suman los contracargos del comercio con estado `APROBADO`, fecha no nula y fecha dentro
del periodo (`Liq:211-226`). La fecha es la de aprobación según `escenario/README.md`, de modo que
se descuentan en el periodo en que se aprueban. No se descuentan en el periodo de la transacción
original.

## 7. Retención de garantía

Si el comercio tiene fecha de afiliación, se calculan los meses completos entre esa fecha y el
inicio del periodo (`Liq:230-234`, `Fecha:125-143`). Si son menos de 6, la base es
`totalTransado - totalComisiones - totalContracargos` y, si es positiva, la retención es el 5 %
de esa base (`Liq:236-243`). Ese 5 % es un literal en la línea 241.

## 8. Redondeo y neto

- `totalTransado`, `totalComisiones`, `totalContracargos` y `retenciones` se redondean con
  `Math.round(x * 100.0) / 100.0` (`Liq:246-249`). Se redondea solo en los totales.
- El neto es `totalTransado - totalComisiones - totalContracargos - retenciones`
  (`modelo/Liquidacion.java:99-101`) y se vuelve a redondear (`Liq:257-259`).

## 9. Periodo

El inicio es el día 1 a las 00:00:00 y el fin el último día a las 23:59:59 (`Fecha:77-108`). Se
usa `Calendar.getInstance(ConfiguracionRegional.REGION_DE_SALIDA)` (`Fecha:35`), que fija la
configuración regional pero no la zona horaria: se toma la del sistema (`util/ConfiguracionRegional.java:34-35`).

## Contraste con las reglas declaradas

Reglas de `escenario/README.md`, secciones «Reglas de negocio» 1 a 9.

| Regla | Qué dice | Qué hace el código | Resultado |
|---|---|---|---|
| 1 | Porcentaje del tramo más monto fijo | `Liq:164-165` | Coincide |
| 2 | Tramos no acumulativos | `Liq:164` aplica el porcentaje al monto completo. El comentario `Plan:9-10` dice lo contrario | Coincide el código. El comentario contradice la regla |
| 3 | Recargo 0,5 % por cuota sobre la primera, máximo 3 % | Flujo de liquidación: tope 3.0 (`Liq:173-175`). `CalculadoraComision`: tope 3.5 (`Com:53-55`) | No coincide en `CalculadoraComision`; coincide en la liquidación |
| 4 | Anuladas no generan comisión | Solo `APROBADA` genera comisión (`Liq:138`) | Coincide (y también excluye rechazadas y pendientes) |
| 5 | Contracargos aprobados en el periodo en que se aprueban | `Liq:213-222` | Coincide |
| 6 | Si el total supera el tope, se cobra el tope | `Liq:202-205` | Coincide |
| 7 | Retención del 5 % si hay menos de seis meses | `Liq:236-243`; la base es transado menos comisiones menos contracargos | Coincide (la base «monto neto» se interpreta así, sin restar la retención) |
| 8 | Periodo en hora de Lima | `Fecha:35` y `Fecha:77-108` usan la zona horaria del sistema, no fijan Lima | No coincide, o depende de la máquina |
| 9 | Dos decimales, medio hacia arriba | `Math.round(x * 100.0) / 100.0` en totales (`Liq:246-249`). Las líneas de detalle no se redondean | Coincide en los totales |

Resumen: coinciden 7 reglas (1, 2, 4, 5, 6, 7, 9). No coinciden o coinciden solo en parte 2
(3, en `CalculadoraComision`; y 8, la zona horaria).

## Qué se perdió en el traslado

Se revisó el documento contra las cuatro cosas que Confluence no conserva al importar Markdown:

- Enlaces relativos a archivos del repositorio: no había ninguno. Todas las rutas del documento están
  escritas como texto en formato de código, sin enlace, así que no se cambió nada. Al pegarlo en
  Confluence esas rutas no serán navegables, y no hay forma de volverlas enlaces sin una URL del repositorio.
- Tablas con celdas de varias líneas: no había ninguna. La tabla de contraste tiene una línea por celda.
  Las celdas son largas y en Confluence quedan como columnas anchas.
- Bloques de código sin lenguaje declarado: no había bloques de código delimitados. Solo hay fragmentos en
  línea, que Confluence conserva.
- HTML incrustado: no había ninguno.

Cambios hechos en la copia: ninguno en el contenido, solo se agregó esta sección. El original no se
modificó.

Lo que sí cambia al pegar en Confluence, aunque no se pueda corregir en el archivo:

- Las abreviaturas `Liq`, `Com`, `Plan` y `Fecha` de la introducción son una convención del documento y no se
  vinculan con los archivos.
- Las citas de línea (`Liq:164`) quedan como texto y pierden vigencia si el código cambia.
