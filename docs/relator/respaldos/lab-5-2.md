> Salida real grabada en la verificación de SPEC-016, el 3 de octubre de 2026, sin Visual Studio Code. Los segundos son del agente de verificación; no incluyen la lectura del participante.

# Lab 5-2 salida grabada de respaldo

Hay dos grabaciones, una por cada camino del 5.2. Muestre la que corresponda a lo que eligió el participante.

## Camino B: el reporte reutiliza el cálculo de la liquidación (corrida s16, Java)

---

# 5.2 paso 1: `/lab-5-2-paso-1-planificar java`

Inicio 1791047083, fin 1791047110 (27 s). Comandos de terminal del agente: 2 (`date +%H:%M`,
`bash scripts/proyecto/entregar.sh formato-del-reporte`).

## Respuesta del agente

Anoté Desarrollo a las **14:04** en el registro de tiempos y entregué la especificación
técnica: `docs/proyecto/backlog/formato-del-reporte.md`. La leí junto con la historia, la
decisión 0004 y el código Java que menciona.

**Lo que fija la especificación:** invocación con `--reporte-medios` como primer argumento y
periodo y ruta después; encabezado de seis líneas con el mismo marco y fechas que la
liquidación; tabla de anchos 15/16/18/16/16; filas por código de medio en orden alfabético;
81 guiones; pie con `Ajuste por tope` (negativo), `Ajuste por redondeo` (total − filas −
ajuste por tope, siempre visible) y `Total` (como en la liquidación, por comercio). Montos
`S/ ` con punto y dos decimales; porcentaje con dos decimales y ` %`. Esto resuelve las
preguntas de formato, orden y decimales que la historia dejó «pendiente».

**El punto delicado de la decisión 0004:** `procesarLiquidacionCompleta`
(`CalculadoraLiquidacion.java:82`) calcula y además imprime toda la liquidación. Para
reutilizar su resultado sin esa salida hay dos caminos: refactorizar la clase para separar
el cálculo de la impresión, o no tocarla y descartar su salida de consola mientras el
reporte la llama. Propongo el segundo: evita refactorizar un método de casi trescientas
líneas y la liquidación no puede cambiar en un byte porque su código no se modifica.

### Plan

| Paso | Archivo | Qué hace | Cómo se valida |
|---|---|---|---|
| 1 | `AplicacionLiquidacion.java` | Si el primer argumento es `--reporte-medios`, lo consume; periodo y ruta siguen con sus valores por omisión. Sin ese argumento, el flujo de la liquidación queda idéntico | `mvn -q clean package` y `bash scripts/integracion-local.sh --paso equivalencia` en verde |
| 2 | `reporte/ReporteMediosPago.java` (nuevo) | Recibe las liquidaciones del periodo; agrupa el detalle por medio de pago (cantidad, monto, comisión antes del tope); calcula participación, ajuste por tope (lo que exceden los comercios con tope aplicado), total como suma de `getTotalComisiones()` y ajuste por redondeo; arma el texto con el formato exacto | Compila; equivalencia en verde |
| 3 | `AplicacionLiquidacion.java` | En el camino del reporte: carga datos, llama a `procesarLiquidacionCompleta` con `System.out` apuntando a un flujo que descarta, lo restaura e imprime el encabezado con las mismas fechas y formato que la liquidación, y el reporte | Equivalencia en verde; ejecución de `--reporte-medios 2026-06` comparada a ojo con el ejemplo de forma; el paso 3 del laboratorio corre `verificar-reporte.sh` |

No hay paso de refactor: no se modifica `CalculadoraLiquidacion`. Las pruebas del reporte
quedan para el 5.3.

**Riesgo conocido:** con la alternativa A el reporte hereda la selección de tramo de la
liquidación, que excluye el límite superior (`CalculadoraLiquidacion.java:149`), mientras el
negocio respondió que es inclusivo. El total cuadrará con la liquidación, pero los criterios
4 y 5 de la historia pueden no cumplirse. No lo corrijo en este laboratorio.

**¿Apruebas el plan o qué cambias?**

## Respuesta del participante

«Aprobado.»

## Medición

- Archivos: `docs/proyecto/backlog/formato-del-reporte.md` (entregado),
  `docs/proyecto/registro-de-tiempos.md` (M).
- Salida esperada: sí. Plan con validación por paso y pregunta de aprobación.
- Restricciones: respetadas. Solo se modificó el registro de tiempos y el documento entregado.


---

# 5.2 paso 2: `/lab-5-2-paso-2-implementar-reporte java`

Inicio 1791047132, fin 1791047224 (92 s). Comandos de terminal del agente: 4 (tres de
compilación más `integracion-local.sh --paso equivalencia`, uno por paso del plan, y un `sed`
para agregar dos `import`).

## Respuesta del agente

Seguí el plan aprobado en orden. Después de cada paso compilé y corrí
`bash scripts/integracion-local.sh --paso equivalencia`.

| Paso | Archivo | Cambio | Equivalencia |
|---|---|---|---|
| 1 | `AplicacionLiquidacion.java` | Constante `--reporte-medios`; si es el primer argumento se consume y el periodo y la ruta se leen de los siguientes, con los mismos valores por omisión | 2026-04, 05 y 06 OK |
| 2 | `reporte/ReporteMediosPago.java` (nuevo, 128 líneas) | Agrupa el detalle de las liquidaciones por medio (`TreeMap`, orden alfabético); comisión de fila antes del tope, redondeada al final; participación sobre la suma de filas; ajuste por tope = −(comisiones del comercio − total con tope) de los comercios con tope; total = suma de `getTotalComisiones()`; ajuste por redondeo = total − filas − ajuste por tope; formato con anchos 15/16/18/16/16 y pie 49/16 | 2026-04, 05 y 06 OK |
| 3 | `AplicacionLiquidacion.java` | `emitirReporteMedios`: llama a `procesarLiquidacionCompleta` con `System.out` apuntando a `OutputStream.nullOutputStream()`, restaura la consola en `finally` e imprime el reporte. El camino sin `--reporte-medios` no cambia | 2026-04, 05 y 06 OK |

`CalculadoraLiquidacion` no se modificó.

Salida de `java -jar target/liquidacion-comercios.jar --reporte-medios 2026-06`:

```
==========================================================
  PASARELA ANDINA - COMISIONES POR MEDIO DE PAGO
  Periodo: 2026-06
  Desde: 01/06/2026 00:00
  Hasta: 30/06/2026 23:59
==========================================================

Medio de pago     Transacciones    Monto transado        Comision   Participacion
BILLETERA_MOVIL             181      S/ 552504.92     S/ 14326.75         23.75 %
TARJETA_CREDITO             159      S/ 557033.77     S/ 14395.78         23.87 %
TARJETA_DEBITO              203      S/ 760564.01     S/ 19147.92         31.75 %
TRANSFERENCIA               170      S/ 492042.49     S/ 12443.22         20.63 %
---------------------------------------------------------------------------------
Ajuste por tope                                      S/ -23698.32
Ajuste por redondeo                                      S/ -0.04
Total                                                 S/ 36615.31
```

**Última validación:** `integracion-local.sh --paso equivalencia`, los tres periodos coinciden
con el hash esperado.

**Lo que vi y no toqué:**

- El total de junio es 36 615,31. La historia (criterio 7) calculó 36 637,34 con las reglas
  del negocio y decimal exacto: hay 22,03 de diferencia. Es lo esperable con la alternativa A,
  porque la liquidación manda los montos en el límite al tramo superior. Queda para el
  paso 3 y el 5.3.
- Ajuste por redondeo de −0,04 en junio: el total por comercio en `double` y la suma de filas
  no coinciden al centavo.

No escribí pruebas del reporte (son el 5.3) ni toqué el escenario .NET, los datos ni los
hashes esperados.

## Medición

- Archivos: `AplicacionLiquidacion.java` (M), `reporte/ReporteMediosPago.java` (nuevo).
- Salida esperada: sí. Diff por archivo y resultado de la última validación.
- Restricciones: respetadas. Solo Java; sin cambios en hashes, datos ni en la liquidación.


---

# 5.2 paso 3: `/lab-5-2-paso-3-verificar-reporte java`

Inicio 1791047243, fin 1791047272 (29 s). Comandos de terminal del agente: 4
(`verificar-reporte.sh` tres veces e `integracion-local.sh`).

## Respuesta del agente

| Comprobación | Resultado |
|---|---|
| `bash scripts/verificar-reporte.sh java 2026-04` | Coincide con la salida esperada (código 0) |
| `bash scripts/verificar-reporte.sh java 2026-05` | Coincide con la salida esperada (código 0) |
| `bash scripts/verificar-reporte.sh java 2026-06` | **No coincide** (código 1). Esperado `f1667ce7…86d7`, obtenido `ae7f4a6d…e1b8` |
| `bash scripts/integracion-local.sh` | **Verde**. Java compila, 20 pruebas pasan; equivalencia de la liquidación OK en los tres periodos; .NET omitido por stack `java` |

### Pendiente para el 5.3

El script solo guarda el hash, no la salida esperada, así que no puedo mostrar en qué
líneas difiere. Lo que sí sé:

- Abril y mayo coinciden byte a byte, de modo que el formato (encabezado, anchos, orden,
  pie) está bien. La diferencia de junio es de valores, no de forma.
- Junio es el único periodo con transacciones en el límite de un tramo (TX002001 y TX002003
  por 500,00; TX002002 y TX002004 por 2 000,00, todas de plan PL01). La liquidación las
  asigna al tramo superior (`CalculadoraLiquidacion.java:149`, `<`), y el negocio dijo que el
  límite superior es inclusivo. Eso explicaría 22,00 de diferencia: (17,80 − 14,80) × 2 +
  (58,30 − 50,30) × 2.
- Nuestro total de junio es 36 615,31; la historia calculó 36 637,34. La diferencia es 22,03,
  así que hay 0,03 que el límite de tramo no explica. Las líneas candidatas de nuestra
  salida son las filas `BILLETERA_MOVIL`, `TARJETA_CREDITO`, `TARJETA_DEBITO`,
  `TRANSFERENCIA`, `Ajuste por redondeo` y `Total`.

No corregí nada.

El pipeline local está en verde. Te propongo confirmar el reporte:

```bash
git add escenario && git commit -m "Reporte de comisiones por medio de pago"
```

¿Lo confirmas? Yo no hago el commit.

## Respuesta del participante

«Sí, lo confirmo.» Ejecutó el commit (`5e06f23`).

## Medición

- Archivos: ninguno modificado por el agente. El commit del participante incluyó
  `AplicacionLiquidacion.java` y `reporte/ReporteMediosPago.java`.
- Salida esperada: sí. Tabla de comprobaciones y pendiente para el 5.3.
- Restricciones: respetadas. No modificó archivos ni hizo el commit.


## Camino A: el reporte calcula por su cuenta con decimal exacto (corrida s16-a, .NET)

---

# 5.2 paso 1. `/lab-5-2-paso-1-planificar dotnet`

**Participante:** `/lab-5-2-paso-1-planificar dotnet`. Quiero que el reporte calcule la comisión
con `decimal` exacto y las reglas de `escenario/README.md`, sin reutilizar ni tocar el
cálculo de la liquidación.

**Copilot (agente):**

Anoté 14:27 en Desarrollo en `docs/proyecto/registro-de-tiempos.md` y entregué la
especificación técnica:

```
$ bash scripts/proyecto/entregar.sh formato-del-reporte
Documento entregado: docs/proyecto/backlog/formato-del-reporte.md
```

Leí la especificación, la historia, la decisión 0004 y el código .NET que menciona
(`Calculo/CalculadoraLiquidacion.cs`, `Calculo/CalculadoraComision.cs`,
`Repositorio/RepositorioMemoria.cs`, `Calculo/UtilidadesFecha.cs`,
`AplicacionLiquidacion.cs`, `Util/CompatibilidadJava.cs`).

Lo que condiciona el plan:

- La decisión 0004 y tu pedido: el reporte calcula por su cuenta, con `decimal`, sin
  reutilizar `CalculadoraLiquidacion` ni `CalculadoraComision` y sin modificarlas.
- La historia: límite superior del tramo inclusivo (500,00 va al tramo 0–500), redondeo al
  final, tope por comercio con fila de ajuste, y el total igual a la suma de las
  liquidaciones al centavo.
- La especificación: `--reporte-medios` como primer argumento de la misma clase
  ejecutable; sin él la liquidación no cambia un byte.
- No hay refactor: no reutilizo código de cálculo, así que no hay nada que refactorizar
  antes. Solo reutilizo, en modo lectura, el repositorio en memoria y
  `UtilidadesFecha.InicioDePeriodo` y `FinDePeriodo` para las fechas del encabezado y el
  filtro de periodo, que deben ser las mismas de la liquidación.

## Plan

1. **Crear `escenario/dotnet/LiquidacionComercios/Reporte/CalculadoraReporteMediosPago.cs`.**
   Clase nueva que recibe el `RepositorioMemoria` y el periodo, y devuelve las filas y el
   pie. Reglas, todas en `decimal`:
   - Comercios: todos menos `DE_BAJA`, con plan existente.
   - Transacciones: `APROBADA`, moneda `PEN`, monto mayor que cero, fecha dentro del
     periodo (mismos límites que la liquidación).
   - Comisión: porcentaje del tramo donde `desde <= monto <= hasta` (primero que coincide,
     límite superior inclusivo; si ninguno coincide, el último tramo) × monto / 100 + fijo;
     recargo de 0,5 % por cuota sobre la primera, máximo 3 %, sobre la comisión base.
   - El `double` del modelo se convierte a `decimal` con su representación de ida y vuelta
     (`"R"`), que para montos leídos con dos decimales da el valor exacto.
   - Filas: suma exacta por medio de pago, redondeada al final.
   - Por comercio: suma exacta; si supera el tope se cobra el tope; el total del comercio se
     redondea. Total = suma de los totales por comercio.
   - Ajuste por tope = −(suma exacta de lo descontado), redondeado.
   - Ajuste por redondeo = Total − suma de filas − ajuste por tope.
   - Redondeo medio hacia arriba con `Math.Round(valor, 2, MidpointRounding.AwayFromZero)`
     sobre `decimal`. Ver la nota al final sobre `CompatibilidadJava`.

   *Valida:* `dotnet build LiquidacionComercios -c Release` compila y
   `bash scripts/integracion-local.sh --paso equivalencia` sigue en verde (la clase no se
   usa todavía).

2. **Crear `escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporteMediosPago.cs`.**
   Arma el texto exacto de la especificación: encabezado de seis líneas con 58 `=`, línea en
   blanco, títulos y filas con anchos 15/16/18/16/16 en orden alfabético del código, 81
   guiones, pie con etiqueta en 49 y monto en 16. Montos `S/ ` + dos decimales sin
   separador de miles; porcentaje con dos decimales y ` %`. Fin de línea `\n`.

   *Valida:* compila y `--paso equivalencia` en verde.

3. **Modificar `escenario/dotnet/LiquidacionComercios/AplicacionLiquidacion.cs`.** Si el
   primer argumento es `--reporte-medios`, se desplazan los argumentos, se cargan los datos
   y se imprime solo el reporte; si no, el flujo actual sigue idéntico.

   *Valida:* `bash scripts/integracion-local.sh --paso equivalencia` en verde (la
   liquidación sin cambio de un byte) y una ejecución manual de
   `dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll --reporte-medios 2026-06`
   para revisar la forma.

4. **Verificación final** en el paso 3: `bash scripts/verificar-reporte.sh dotnet` para
   2026-04, 2026-05 y 2026-06, y `bash scripts/integracion-local.sh` completo.

No toco el escenario Java, los datos, `liquidacion-esperada.sha256`, la liquidación ni
`CalculadoraComision`. Las pruebas del reporte quedan para el 5.3 paso 1.

## Lo que vi y no voy a tocar

- La liquidación (`CalculadoraLiquidacion.cs`, línea 145) usa `monto < tramo.MontoHasta`,
  de modo que un monto exactamente en el límite cae en el tramo superior. La regla del
  negocio, confirmada en la historia, es que pertenece al inferior. Además todo el cálculo
  usa `double`. Como el reporte aplica la regla con `decimal`, **es probable que la
  conciliación del criterio 6 no cuadre al centavo** en los periodos con montos en el
  límite (en junio hay al menos cuatro: TX002001 a TX002004). No lo corrijo: queda para el
  5.3.
- `CalculadoraComision.cs` usa `<=` (línea 25) y tope de recargo 3,5 (línea 60), distinto de
  la liquidación (3,0) y del README (3 %).
- `PlanComisiones.cs` dice en su comentario que los tramos son acumulativos; el README
  (regla 2) dice que no. Sigo el README.
- `.github/instructions/dotnet.instructions.md` pide que todo redondeo pase por
  `CompatibilidadJava`. Esa clase trabaja con `double`; pasar el `decimal` exacto por ella
  reintroduce el error que el pedido quiere evitar (por ejemplo, 137,825 de CM0011).
  Propongo redondear el `decimal` con `MidpointRounding.AwayFromZero`, que es el medio
  hacia arriba de la regla 9 y equivale a `BigDecimal` `HALF_UP` de Java, y formatear el
  valor ya redondeado con `CompatibilidadJava.FormatearDosDecimales`. Es una desviación de
  la instrucción que necesito que apruebes.

¿Apruebas el plan, incluida la desviación del redondeo, o qué cambias?

**Participante:** Apruebo el plan tal como está, con el redondeo de `decimal` que propones.


---

# 5.2 paso 2. `/lab-5-2-paso-2-implementar-reporte dotnet`

**Participante:** `/lab-5-2-paso-2-implementar-reporte dotnet`

**Copilot (agente):**

Seguí el plan aprobado en orden. Después de cada paso compilé y corrí la equivalencia.

## Paso 1 del plan: `Reporte/CalculadoraReporteMediosPago.cs` (nuevo, 200 líneas)

Clase que recibe el `RepositorioMemoria` y calcula en `decimal`, sin usar
`CalculadoraLiquidacion` ni `CalculadoraComision`:

- Comercios distintos de `DE_BAJA` con plan; transacciones `APROBADA`, `PEN`, monto > 0,
  dentro del periodo (`UtilidadesFecha.InicioDePeriodo` y `FinDePeriodo`, en lectura).
- Tramo con `desde <= monto <= hasta` (límite superior inclusivo, primer tramo que
  coincide), más fijo, más recargo de 0,5 % por cuota sobre la primera con máximo 3 %.
- Filas: suma exacta por medio, redondeo al final. Total: por comercio, con tope, redondeado
  por comercio y sumado. Ajuste por tope = −(descontado exacto) redondeado. Ajuste por
  redondeo = total − filas − ajuste por tope.
- Redondeo `Math.Round(decimal, 2, MidpointRounding.AwayFromZero)`, desviación aprobada en
  el paso 1.

```
$ dotnet build LiquidacionComercios -c Release        -> 0 Error(s)
$ bash scripts/integracion-local.sh --paso equivalencia
  [ OK ] dotnet 2026-04 coincide con el hash esperado
  [ OK ] dotnet 2026-05 coincide con el hash esperado
  [ OK ] dotnet 2026-06 coincide con el hash esperado
```

## Paso 2 del plan: `Reporte/FormateadorReporteMediosPago.cs` (nuevo, 70 líneas)

Texto exacto de la especificación: marco de 58 `=`, títulos y filas con anchos
15/16/18/16/16, 81 guiones, pie con 49 + 16, fin de línea `\n`. Los montos ya redondeados se
formatean con `CompatibilidadJava.FormatearDosDecimales`.

Validación: compila, equivalencia `[ OK ]` en los tres periodos.

## Paso 3 del plan: `AplicacionLiquidacion.cs` (+17 líneas)

Si `args[0]` es `--reporte-medios`, se toma el periodo y la ruta de los argumentos
siguientes (con los mismos valores por omisión), se cargan los datos con
`CalculadoraLiquidacion.PrepararDatos` y se imprime solo el reporte. Sin el argumento, el
flujo es el mismo de antes.

```
$ bash scripts/integracion-local.sh --paso equivalencia
  [ OK ] dotnet 2026-04 coincide con el hash esperado
  [ OK ] dotnet 2026-05 coincide con el hash esperado
  [ OK ] dotnet 2026-06 coincide con el hash esperado

$ dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll --reporte-medios 2026-06
==========================================================
  PASARELA ANDINA - COMISIONES POR MEDIO DE PAGO
  Periodo: 2026-06
  Desde: 01/06/2026 00:00
  Hasta: 30/06/2026 23:59
==========================================================

Medio de pago     Transacciones    Monto transado        Comision   Participacion
BILLETERA_MOVIL             181      S/ 552504.92     S/ 14326.75         23.75 %
TARJETA_CREDITO             159      S/ 557033.77     S/ 14395.78         23.86 %
TARJETA_DEBITO              203      S/ 760564.01     S/ 19169.92         31.77 %
TRANSFERENCIA               170      S/ 492042.49     S/ 12443.22         20.62 %
---------------------------------------------------------------------------------
Ajuste por tope                                      S/ -23698.32
Ajuste por redondeo                                      S/ -0.01
Total                                                 S/ 36637.34
```

## Diff resumido

| Archivo | Cambio |
|---|---|
| `escenario/dotnet/LiquidacionComercios/Reporte/CalculadoraReporteMediosPago.cs` | Nuevo |
| `escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporteMediosPago.cs` | Nuevo |
| `escenario/dotnet/LiquidacionComercios/AplicacionLiquidacion.cs` | +17, rama `--reporte-medios` |

Última validación: equivalencia en verde en los tres periodos. No toqué Java, los datos, los
hashes, la liquidación ni `CalculadoraComision`. No escribí pruebas (5.3 paso 1).

Observaciones, sin tocar: el total del reporte se calcula con la regla del límite inclusivo y
`decimal`; la liquidación usa `<` en el límite (`CalculadoraLiquidacion.cs`, línea 145) y
`double`. Es esperable que el total no coincida con la suma de las liquidaciones de junio;
eso lo mide la conciliación del 5.3.


---

# 5.2 paso 3. `/lab-5-2-paso-3-verificar-reporte dotnet`

**Participante:** `/lab-5-2-paso-3-verificar-reporte dotnet`

**Copilot (agente):**

```
$ bash scripts/verificar-reporte.sh dotnet 2026-04
El reporte de dotnet para 2026-04 coincide con la salida esperada.
$ bash scripts/verificar-reporte.sh dotnet 2026-05
El reporte de dotnet para 2026-05 coincide con la salida esperada.
$ bash scripts/verificar-reporte.sh dotnet 2026-06
El reporte de dotnet para 2026-06 coincide con la salida esperada.
$ bash scripts/integracion-local.sh
== Java: compilar y ejecutar las pruebas ==        [AVISO] Stack dotnet: se omite Java.
== Java: dependencias ==                           [AVISO] Stack dotnet: se omite Java.
== .NET: compilar y ejecutar las pruebas ==        Passed! Failed: 0, Passed: 20
== .NET: dependencias ==                           [AVISO] Sin acceso a nuget.org, ...
== Equivalencia ==                                 [ OK ] dotnet 2026-04, 2026-05, 2026-06
== Resumen (stack: dotnet) ==                      Todos los pasos pasan.
```

| Comprobación | Resultado |
|---|---|
| `verificar-reporte.sh dotnet 2026-04` | Coincide (código 0) |
| `verificar-reporte.sh dotnet 2026-05` | Coincide (código 0) |
| `verificar-reporte.sh dotnet 2026-06` | Coincide (código 0) |
| `integracion-local.sh`: compilar y probar .NET | 20 pruebas, 0 fallas |
| `integracion-local.sh`: dependencias .NET | Informativo, sin red |
| `integracion-local.sh`: equivalencia de la liquidación | Tres periodos `[ OK ]` |
| Pipeline local | Verde |

Los tres periodos coinciden con la salida esperada, así que no hay diferencias de formato ni
de valores del reporte que anotar.

## Pendiente para el 5.3

- El reporte coincide con la salida esperada, que está calculada con las reglas del
  negocio. Eso no dice nada de la liquidación: el criterio 6 de la historia (total del
  reporte igual a la suma de las liquidaciones al centavo) todavía no se comprobó. Por el
  límite de tramo de `CalculadoraLiquidacion.cs` (línea 145, `<`) esperamos que junio no
  cuadre. Lo mide la conciliación del 5.3.

El pipeline local está en verde. Te propongo el commit:

```bash
git add escenario && git commit -m "Reporte de comisiones por medio de pago"
```

**Participante:** Confirmo. *(Ejecutó el commit: `3f32ad1 Reporte de comisiones por medio de pago`.)*

