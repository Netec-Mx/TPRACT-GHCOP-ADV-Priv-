> Salida real grabada en una verificación el 3 de octubre de 2026, stack Java, sin Visual Studio Code. Los segundos son del agente de verificación; no incluyen la lectura del participante.

# Lab 5-1 salida grabada de respaldo

Los tres pasos del 5.1 en una misma rama. En el paso 1 el participante llevó al relator las preguntas que listó el agente y volvió con las respuestas de la hoja.


---

# 5.1 paso 1: `/lab-5-1-paso-1-historia-de-usuario java`

Inicio 1791046837, fin 1791046941 (104 s). Comandos de terminal del agente: 3 (`date +%H:%M`,
un perfil de los datos con `awk`, un cálculo decimal de comprobación con `python3`).

## Primera respuesta del agente

Preparé el material de partida:

- Creé `docs/proyecto/registro-de-tiempos.md` desde la plantilla, con Requerimientos a las
  **14:00** (`date +%H:%M`).
- Dejé `java` en la última línea de `scripts/integracion/stack.txt`.

Leí la solicitud del área comercial, las reglas de `escenario/README.md` y los datos. Antes
de escribir criterios, estas son las preguntas abiertas: lo que la solicitud no dice y que
cambia el resultado.

**Qué entra al reporte**

1. **¿Qué transacciones entran?** La solicitud solo excluye las anuladas, pero los datos
   tienen además 21 pendientes y 53 rechazadas. ¿Cuentan?
2. **¿Qué comercios entran?** Hay un comercio dado de baja (CM0036) y uno suspendido
   (CM0031). ¿Entran sus transacciones?

**Casos límite de las reglas que toca**

3. **¿A qué tramo pertenece un monto que cae exactamente en el límite?** Por ejemplo, 500,00
   en el plan Básico: ¿tramo 0–500 al 3,5 % o tramo 500–2 000 al 2,9 %? Las reglas 1 y 2 no
   lo deciden, y hay transacciones reales en 500,00 y 2 000,00 en junio.
4. **¿Cómo se trata el tope mensual (regla 6)?** El tope es por comercio; el reporte es por
   medio de pago. ¿Se reparte el tope entre medios, se muestra antes o después del tope?
5. **¿La comisión incluye el monto fijo y el recargo por cuotas?**
6. **¿Se descuentan los contracargos del periodo?**

**Redondeo y presentación**

7. **¿En qué momento se redondea?** Por transacción, por fila de medio de pago o solo el
   total. Con montos en `double` el resultado cambia según el momento.
8. **¿Con cuántos decimales va el porcentaje y sobre qué base?**
9. **¿Cómo se ordenan las filas, qué pasa con un medio sin transacciones, y es un periodo por
   ejecución?** La solicitud pide «comparar mes a mes».
10. **¿El monto transado es el monto bruto de la transacción?**

**Comprobación**

11. **¿Contra qué se va a comprobar que el total es correcto?** ¿Debe cuadrar con el total
    de comisiones de la liquidación del mismo periodo?

Me detengo aquí. En esta sala el negocio es el relator: llévale estas preguntas y vuelve
con las respuestas. No voy a responderlas yo.

## Participante con el relator

El participante llevó las 11 preguntas, tal como las listó el agente.

| Pregunta llevada | Respuesta del relator (texto de la hoja) |
|---|---|
| 1. Qué transacciones entran | «Las mismas que la liquidación: aprobadas, en soles, monto mayor que cero, dentro del periodo. Ni anuladas, ni pendientes, ni rechazadas» |
| 2. Qué comercios entran | «Los que se liquidan: activos y suspendidos con plan. No los dados de baja» |
| 3. Monto en el límite de un tramo | «Pertenece al tramo inferior. El límite superior es inclusivo» |
| 4. El tope | «Es por comercio, no se reparte. Las filas van antes del tope y una fila de ajuste muestra lo descontado» |
| 5. Monto fijo y recargo | Sin respuesta en la hoja |
| 6. Contracargos | Sin respuesta en la hoja |
| 7. El redondeo | «Al final: cada fila suma exacto y redondea; el total se calcula por comercio, como la liquidación» |
| 8. Decimales del porcentaje | Sin respuesta en la hoja |
| 9. Orden y formato | Sin respuesta en la hoja |
| 10. Monto bruto | Sin respuesta en la hoja |
| 11. Contra qué se comprueba | «El total del reporte es igual a la suma del total de comisiones de las liquidaciones, al centavo» |

El participante pegó en el chat las seis respuestas y dijo que las otras cinco no tuvieron
respuesta.

## Segunda respuesta del agente

Creé `docs/proyecto/historia-reporte-medios-de-pago.md` con la plantilla. Resumen:

- **Historia:** como Gerencia Comercial, quiero un reporte mensual por medio de pago con
  cantidad, monto transado, comisión y porcentaje, para negociar con números que cuadren
  con la liquidación.
- **Preguntas abiertas:** las once, seis respondidas por el relator y cinco «pendiente».
- **Ocho criterios de aceptación**, entre ellos:
  - **Límite de tramo (criterio 4).** TX002001 de CM0001, plan PL01, 500,00 en una cuota →
    tramo 0–500 al 3,5 %: 500,00 × 3,5 % = 17,50 + 0,30 = **17,80**. TX002002, 2 000,00 →
    tramo 500–2 000 al 2,9 %: 58,00 + 0,30 = **58,30**.
  - **Más de dos decimales (criterio 5).** CM0011, plan PL02, junio: la suma exacta de sus
    ocho comisiones es **137,825**, que redondeada medio hacia arriba da **137,83**. La cuenta
    transacción por transacción está en la historia.
  - **Tope (criterio 6).** CM0004 suma 28 698,32 en junio contra un tope de 5 000,00: filas
    antes del tope y una fila de ajuste.
  - **Cuadratura (criterio 7).** El total del reporte es igual a la suma de las
    liquidaciones al centavo. Calculado con estas reglas y decimal exacto, junio da
    **36 637,34**.

**Siguen pendientes:** si la comisión incluye monto fijo y recargo (lo deduzco de la
cuadratura con la liquidación, pero no está confirmado), contracargos, decimales y base del
porcentaje, orden y formato de las filas, y si el monto transado es bruto. El criterio 8
deja el formato como «pendiente».

**Lo que vi y no toqué** (no forma parte de este paso):

- `CalculadoraLiquidacion` asigna el tramo con `monto < montoHasta`, de modo que 500,00 cae
  en el tramo superior. Eso contradice la respuesta del negocio (límite superior inclusivo).
  `CalculadoraComision.determinarTramo` usa `<=` y sí la cumple. Con la respuesta del
  negocio, el criterio 7 (cuadrar con la liquidación) y el criterio 4 no pueden cumplirse a
  la vez mientras la liquidación siga así.
- `CalculadoraComision.calcularRecargoCuotas` topa el recargo en 3,5 %; la regla 3 dice
  «con un máximo de 3 %». La liquidación usa 3,0.
- El comentario de `PlanComisiones` dice que los tramos son acumulativos; la regla 2 dice
  que «no son acumulativos». El código de la liquidación no los acumula.
- `RepositorioMemoria.buscarComerciosActivos` devuelve todos los comercios sin filtrar.

No modifiqué código.

## Medición

- Archivos: `scripts/integracion/stack.txt` (M), `docs/proyecto/historia-reporte-medios-de-pago.md`
  (nuevo), `docs/proyecto/registro-de-tiempos.md` (nuevo).
- Salida esperada: sí. Preguntas antes de criterios, historia creada, pendientes informados.
- Restricciones: respetadas. Sin cambios de código, no respondió preguntas del negocio.


---

# 5.1 paso 2: `/lab-5-1-paso-2-estimar`

Inicio 1791046972, fin 1791046997 (25 s). Comandos de terminal del agente: 2 (`date +%H:%M`,
`date +%F`). La actualización del registro se hizo con edición de archivo.

## Primera respuesta del agente

Anoté Estimación a las **14:02** en `docs/proyecto/registro-de-tiempos.md`.

Antes de estimar, una sola pregunta, porque cambia tanto el «sin IA» como el «con IA»:
**¿cuánta experiencia tienes con Java y cuánta con Copilot en modo agente?**

## Respuesta del participante

«Unos seis años con Java. Uso Copilot en el chat desde hace unos meses, el modo agente muy
poco.»

## Segunda respuesta del agente

Creé `docs/proyecto/estimacion.md` como funcionalidad nueva y copié el total de la persona
con IA de cada fase en la columna «Estimado con IA» del registro de tiempos.

| Fase | Sin IA | Con IA, persona | Con IA, agente |
|---|---|---|---|
| Requerimientos | 40 | 15 | 3 |
| Estimación | 25 | 10 | 2 |
| Análisis y diseño | 40 | 15 | 3 |
| Desarrollo | 120 | 45 | 15 |
| Pruebas | 60 | 20 | 6 |
| Revisión de código | 30 | 15 | 3 |
| Seguridad | 15 | 8 | 2 |
| Integración continua | 45 | 20 | 5 |
| Liberación | 30 | 12 | 3 |
| Operación y soporte | 45 | 20 | 4 |
| Mantención | 60 | 25 | 8 |
| **Total** | **510** | **205** | **54** |

Créditos de IA (45) y minutos de integración continua (16) quedan como cantidades, sin
precios. Cada fase tiene su supuesto principal en el documento. No hay datos reales de
trabajos parecidos en el repositorio: el registro de tiempos recién empieza, así que todo
es supuesto y lo digo en la fila de Estimación.

**Las dos fases con más incertidumbre:**

1. **Integración continua.** El negocio dijo que un monto en el límite de un tramo va al
   tramo inferior, y la liquidación actual lo manda al superior. Si el pipeline compara el
   reporte con la liquidación, va a quedar en rojo y no sé cuánto cuesta aclararlo.
2. **Desarrollo.** Quedan cinco preguntas pendientes, entre ellas el formato y los decimales
   del porcentaje. La salida se compara por hash con `verificar-reporte.sh`, que no muestra
   la salida esperada: cualquier diferencia de formato obliga a iterar.

Donde la IA más cambia la estimación: Desarrollo (120 → 45) y Pruebas (60 → 20), porque el
agente escribe el código y las pruebas desde los criterios, y la persona revisa.

No modifiqué código.

## Medición

- Archivos: `docs/proyecto/estimacion.md` (nuevo), `docs/proyecto/registro-de-tiempos.md`
  (actualizado).
- Salida esperada: sí. Estimación creada, dos fases inciertas con su razón.
- Restricciones: respetadas. Sin precios, sin código, una sola pregunta al participante.


---

# 5.1 paso 3: `/lab-5-1-paso-3-ubicar-en-arquitectura java`

Inicio 1791047016, fin 1791047057 (41 s). Comandos de terminal del agente: 1 (`date +%H:%M`).

## Primera respuesta del agente

Anoté Análisis y diseño a las **14:03** en el registro de tiempos.

**Dónde cae en el mapeo BIAN** ([bian-mapeo.md](../v16j/docs/arquitectura/bian-mapeo.md)):

- El reporte resume las comisiones cobradas a los comercios. El cálculo de comisiones y la
  liquidación pertenecen a **Merchant Acquiring Facility**.
- El medio de pago es un atributo de la transacción, que pertenece a **Card Transaction
  Capture** (`modelo/Transaccion.java`, `modelo/MedioPago.java`).
- Un reporte de análisis como responsabilidad propia no figura en el mapeo. Lo ubico dentro
  de Merchant Acquiring Facility porque resume el cobro de comisiones; si crece hasta ser un
  servicio aparte, conviene revisar el panorama de servicios de BIAN antes de asignarle otro
  dominio.

**Qué necesita leer** (rutas bajo `escenario/java/src/main/java/pe/pasarelaandina/`):

- `calculo/CalculadoraLiquidacion.java:82`, `procesarLiquidacionCompleta`: calcula la comisión
  de cada transacción, guarda el medio de pago en el detalle (línea 189) y aplica el tope por
  comercio (202 a 205). Además imprime toda la liquidación en la consola (98 a 103, 321 a 361).
- `modelo/DetalleLiquidacion.java:13` y `:15`: comisión total y medio de pago por transacción.
- `modelo/Liquidacion.java:16` y `:22`: total de comisiones y si se aplicó el tope.
- `AplicacionLiquidacion.java:46`: lectura de argumentos, donde entraría `--reporte-medios`.

**Alternativas:**

| | Dónde vive | Reutiliza | Duplica |
|---|---|---|---|
| A | Clase propia en `reporte/` que agrupa el detalle de las liquidaciones | Todo el cálculo de la liquidación; el total cuadra por construcción | Nada del cálculo. Pero tiene que obtener las liquidaciones sin la impresión de consola, y hereda el límite de tramo de la liquidación |
| B | Clase propia con cálculo propio vía `CalculadoraComision` | La selección de tramo con límite inclusivo | El filtrado de transacciones y comercios, el tope; además `CalculadoraComision` topa el recargo en 3,5 % y no en 3 %, así que no cuadraría con la liquidación |
| C | Método nuevo en `CalculadoraLiquidacion` o `FormateadorReporte` | Los datos ya calculados | Nada, pero agranda una clase que ya mezcla varias responsabilidades |

**¿Qué alternativa eliges?**

## Respuesta del participante

«La A. El negocio quiere que cuadre con la liquidación al centavo, así que prefiero que salga
del mismo cálculo. Clase propia en `reporte/`.»

## Segunda respuesta del agente

Registré la decisión con la skill `pasarela-registrar-decision`:

- `docs/arquitectura/decisiones/0004-reporte-de-medios-de-pago-sobre-la-liquidacion.md`, estado
  «Propuesta», con las tres alternativas (B y C marcadas como propuesta del agente),
  consecuencias buenas y malas, y verificación con `verificar-reporte.sh`,
  `integracion-local.sh --paso equivalencia` y una prueba de cuadratura.
- Fila nueva en el índice `docs/arquitectura/decisiones/README.md`.

No se mueve ninguna responsabilidad entre dominios: el reporte queda en Merchant Acquiring
Facility, junto a la liquidación.

**Qué va a tocar el 5.2:**

- Nuevo: `reporte/` una clase del reporte por medio de pago.
- Modificado: `AplicacionLiquidacion.java`, para reconocer `--reporte-medios <periodo>`.
- Probablemente: `calculo/CalculadoraLiquidacion.java`, para obtener las liquidaciones sin la
  impresión de consola, sin cambiar un byte de la salida de la liquidación.
- Solo lectura: `modelo/Liquidacion.java`, `modelo/DetalleLiquidacion.java`.

**Lo que vi y no toqué:** la liquidación excluye el límite superior del tramo
(`CalculadoraLiquidacion.java:149`, `montoTransaccion < tramo.getMontoHasta()`), y el negocio
dijo que es inclusivo. Con la alternativa A, el reporte hereda esa diferencia. Lo dejo
anotado en las consecuencias de la decisión; no modifiqué código.

## Participante: commit del laboratorio

```bash
git add docs scripts/integracion/stack.txt && git commit -m "Historia, estimacion y decision del reporte"
```

## Medición

- Archivos: `docs/arquitectura/decisiones/0004-...md` (nuevo), `docs/arquitectura/decisiones/README.md`
  (M), `docs/proyecto/registro-de-tiempos.md` (M).
- Salida esperada: sí. Decisión registrada con alternativas y consecuencias; componentes del
  5.2 listados.
- Restricciones: respetadas. Sin cambios de código; nombres BIAN del mapeo, en inglés.

