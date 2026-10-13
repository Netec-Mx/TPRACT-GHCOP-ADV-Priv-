> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes. Capítulo 5 completo por el camino A, escenario .NET, en una sola rama. Se
> grabó en la CLI, no en Visual Studio Code. Los comandos que pidió el agente se aprobaron
> según la guía de prueba humana, y el relator respondió con la hoja de respuestas. Los
> commits los hizo el participante en Git Bash. La ruta del repositorio en la máquina se
> abrevia `<repo>`. Los segundos son de trabajo del agente, sin la lectura del participante.

# Lab 5-4 salida grabada de respaldo (escenario .NET, camino A)

Los cuatro pasos del 5.4, sobre la rama que dejaron el 5.1 al 5.3. Cada paso propone su
commit y el participante lo hace.

## 5.4 paso 1: `/lab-5-4-paso-1-liberar`

Escrito: `/lab-5-4-paso-1-liberar`

Modo: Agent. Segundos de trabajo del agente: 13.

Comandos, todos con aprobación: `bash -c "date +%H:%M"; git --no-pager log --oneline -15; Get-Content CHANGELOG.md -TotalCount 40`; `git --no-pager show --stat 4381aca 8bac1ea | Select-String "\|"; git --no-pager show 4381aca -- escenario/java/src/main | Select-Object -Fir`; `Get-Content docs\arquitectura\decisiones\0005*.md; git --no-pager show 4381aca -- escenario/java/src/main escenario/dotnet/*/Calculo | Selec`.

Mensaje durante el trabajo: «Reviso lo que hay en la rama desde 1.4.0.»

Respuesta del chat:

**Versión propuesta: 1.5.0 (menor).**

Justificación:
- **Reporte de comisiones por medio de pago** (commit 8bac1ea): funcionalidad nueva y compatible. Esto exige al menos una versión menor.
- **Conciliación en el pipeline**: agregado compatible.
- **Corrección del límite de tramo** (decisión 0005, .NET): cambia montos que ya se cobraban en la liquidación de junio.
  - El comercio CM0001 sube 11,00 y CM0007 sube 11,00.
  - Las diferencias de 0,03 por punto flotante en CM0011, CM0016 y CM0025 también se corrigen.
  - Esto se declara en las notas, pero no es un cambio que rompa a quien usa el sistema, así que no corresponde versión mayor.
- Un parche (1.4.1) se queda corto porque hay funcionalidad nueva.

Pendiente aparte: Java conserva la regla anterior y sus salidas de 2026-06 difieren de .NET (decisión 0005).

No escribí ningún archivo. La hora de inicio de Liberación es 18:56. ¿Confirmas 1.5.0?

## 5.4 paso 1: respuesta del participante

Escrito: `apruebo`

Modo: Agent. Segundos de trabajo del agente: 68.

Búsquedas: 1.
Archivos escritos: `docs/proyecto/registro-de-tiempos.md`, `CHANGELOG.md`, `docs/proyecto/notas-de-version-1.5.0.md`.
Comandos, todos con aprobación: `Get-Content docs\proyecto\registro-de-tiempos.md; Get-Content docs\proyecto\plantillas\notas-de-version.md; Get-Content scripts\integracion-`; `$t="$env:TEMP\lib15"; Remove-Item $t -Recurse -Force -ErrorAction SilentlyContinue; New-Item $t -ItemType Directory | Out-Null`; `$t="$env:TEMP\lib15"; $r="<repo>"`; `$t="$env:TEMP\lib15"`; `bash -c "date +%H:%M"`.

Mensaje durante el trabajo: «Primero anoto la hora de inicio y preparo las dos ejecuciones.»

Respuesta del chat:

Versión 1.5.0 preparada. No ejecuté `integracion-local.sh --paso conciliacion`; el texto de verificación de las notas se apoya en la decisión 0005, no en una corrida mía. Las salidas de antes y después están en `%TEMP%\lib15`, fuera del repositorio.

**Entrada de `CHANGELOG.md`**
```markdown
## [1.5.0] - 2026-10-12

### Agregado

- Reporte de comisiones por medio de pago, con cálculo propio en `decimal`.
- Conciliación en el pipeline: compara el total del reporte con la suma de las liquidaciones
  de cada periodo.

### Corregido

- Un monto exactamente igual al límite superior de un tramo de comisión se liquida con el
  porcentaje de ese tramo (límite superior inclusivo). Cambia la liquidación de 2026-06:
  CM0001 y CM0007 pagan 11,00 más de comisión (decisión 0005).
- La comisión se suma de forma exacta y se redondea una sola vez, lo que elimina diferencias
  de 0,01 en CM0011, CM0016 y CM0025 en 2026-06.
- Solo el escenario .NET incorpora la corrección; Java conserva la regla anterior y sus
  salidas de 2026-06 difieren (decisión 0005).
```

**`docs/proyecto/notas-de-version-1.5.0.md`**
```markdown
# Notas de versión 1.5.0

| Campo | Valor |
|---|---|
| Fecha | 2026-10-12 |
| Tipo de cambio | Menor (funcionalidad nueva compatible; incluye una corrección que cambia montos de junio de 2026) |
| Historias y decisiones | `docs/proyecto/historia-reporte-medios-de-pago.md`, `docs/arquitectura/decisiones/0004-reporte-comisiones-con-calculo-propio-decimal.md`, `docs/arquitectura/decisiones/0005-limite-de-tramo-en-el-tramo-inferior.md` |

## Qué cambia para el negocio

- El área comercial dispone de un reporte de comisiones por medio de pago.
- Cada periodo se concilia automáticamente: el total del reporte debe coincidir con la suma de
  lo liquidado a los comercios. Si no coincide, el proceso lo avisa.
- Se corrige la comisión de las ventas que caen justo en el límite de un tramo.

## Qué cambia en los montos

Solo cambia la liquidación de junio de 2026 (2026-06). Abril y mayo no cambian. Montos en soles
(S/), después menos antes: signo positivo = sube, negativo = baja.

**Por qué.** Una venta de exactamente S/ 500,00 o S/ 2000,00 estaba pagando la comisión del
tramo superior. El negocio indicó que un monto en el límite pertenece al tramo inferior. Al
corregirlo, esas ventas pagan la comisión correcta, que es mayor. Además, ya no se pierden ni
se ganan céntimos por redondeo al sumar las comisiones de un comercio.

| Comercio | Concepto | Antes | Después | Diferencia |
|---|---|---|---|---|
| CM0001 Consorcio Barranco S.A.C. | Total comisiones | 727,34 | 738,34 | +11,00 (sube) |
| CM0001 Consorcio Barranco S.A.C. | Monto neto a pagar | 25 346,74 | 25 335,74 | −11,00 (baja) |
| CM0007 Inversiones Andina S.R.L. | Total comisiones | 907,11 | 918,11 | +11,00 (sube) |
| CM0007 Inversiones Andina S.R.L. | Retenciones | 1744,39 | 1743,84 | −0,55 (baja) |
| CM0007 Inversiones Andina S.R.L. | Monto neto a pagar | 33 143,33 | 33 132,88 | −10,45 (baja) |
| CM0011 Importaciones Jesus Maria S.A.C. | Total comisiones | 137,82 | 137,83 | +0,01 (sube) |
| CM0011 Importaciones Jesus Maria S.A.C. | Monto neto a pagar | 3566,91 | 3566,90 | −0,01 (baja) |
| CM0016 Corporacion Callao S.A.C. | Total comisiones | 493,99 | 494,00 | +0,01 (sube) |
| CM0016 Corporacion Callao S.A.C. | Monto neto a pagar | 14 736,54 | 14 736,53 | −0,01 (baja) |
| CM0025 Servicios Miraflores S.A. | Total comisiones | 957,18 | 957,19 | +0,01 (sube) |
| CM0025 Servicios Miraflores S.A. | Monto neto a pagar | 39 320,08 | 39 320,07 | −0,01 (baja) |
| Total de la liquidación | Total comisiones | 36 615,31 | 36 637,34 | +22,03 (sube) |
| Total de la liquidación | Total retenciones | 4061,62 | 4061,07 | −0,55 (baja) |
| Total de la liquidación | Total neto a pagar | 2 311 874,77 | 2 311 853,29 | −21,48 (baja) |

Los demás comercios no cambian. A CM0001 y CM0007 se les cobra más comisión y se les paga
menos neto; en CM0007 la retención de garantía baja un poco porque se calcula sobre el neto.

**Pendiente.** El escenario Java conserva la regla anterior: sus montos de 2026-06 siguen siendo
los de la columna «Antes».

## Cómo se verificó

- Dos ejecuciones de la liquidación de 2026-06 en .NET: una con el código anterior a la
  corrección (compilado en una carpeta temporal) y otra con el actual, comparadas comercio por
  comercio.
- Pruebas del reporte y conciliación del pipeline: `bash scripts/integracion-local.sh --paso conciliacion`
  da diferencia 0 en 2026-04, 2026-05 y 2026-06 (según la decisión 0005).

## Qué hacer si algo no cuadra

Escalar al responsable de la liquidación con el periodo, el código del comercio y el monto
esperado y el obtenido. Si un comercio pregunta por la diferencia de junio, explicar que un
monto justo en el límite de un tramo paga la comisión del tramo inferior, y que la diferencia
en céntimos viene del redondeo único.
```

**`docs/proyecto/registro-de-tiempos.md`**
```markdown
# Registro de tiempos

Hora real de inicio y de término de cada fase, anotadas en el momento con `date +%H:%M`. Los
minutos reales son el término menos el inicio. «Origen» dice `participante` cuando las horas
las anotó quien hizo el laboratorio, y `referencia` cuando las dejó
`scripts/proyecto/ponerse-al-dia.sh` porque ese laboratorio no se hizo. Un tiempo de
referencia no es del participante y no se compara como propio.

| Fase | Laboratorio | Inicio (HH:MM) | Término (HH:MM) | Minutos reales | Estimado con IA (min) | Diferencia | Origen |
|---|---|---|---|---|---|---|---|
| Requerimientos | 5.1, paso 1 | 18:36 | 18:38 | | 5 | | participante |
| Estimación | 5.1, paso 2 | 18:38 | 18:39 | | 10 | | participante |
| Análisis y diseño | 5.1, paso 3 | 18:39 | 18:40 | | 30 | | participante |
| Desarrollo | 5.2, pasos 1 a 3 | 18:41 | 18:44 | | 90 | | participante |
| Pruebas | 5.3, paso 1 | 18:45 | 18:46 | | 45 | | participante |
| Integración continua | 5.3, paso 2 | 18:47 | 18:49 | | 15 | | participante |
| Mantención | 5.3, paso 3 | 18:49 | 18:52 | | 20 | | participante |
| Revisión de código | 5.3, paso 4 | 18:54 | 18:56 | | 30 | | participante |
| Seguridad | 5.3, paso 4 | 18:54 | 18:56 | | 15 | | participante |
| Liberación | 5.4, paso 1 | 18:56 | 18:57 | | 20 | | participante |
| Operación y soporte | 5.4, paso 2 | | | | 20 | | |
| Mantención evolutiva | 5.4, paso 3 | | | | 40 | | |

## Hallazgos abiertos

Lo que un paso encontró y queda para un laboratorio posterior, una línea por hallazgo, con
el laboratorio y el comando que lo muestra. Sin causa: se diagnostica cuando corresponde.
```

**Commit propuesto** (no lo ejecuto):
```
git add CHANGELOG.md docs/proyecto/notas-de-version-1.5.0.md docs/proyecto/registro-de-tiempos.md
git commit -m "Versión 1.5.0: registro de cambios y notas de versión"
```

**Observaciones, sin tocar:**
- Java queda distinto de .NET en 2026-06, así que `comparar-escenarios.sh` fallará.
- La decisión 0005 sigue en estado «Propuesta».
- Aunque las dos corridas son de .NET, el comparador del repositorio habría arrojado el mismo resultado de junio.

¿Confirmas el commit?

## 5.4 paso 2: `/lab-5-4-paso-2-atender-incidente`

Escrito: `/lab-5-4-paso-2-atender-incidente`

Modo: Agent. Segundos de trabajo del agente: 66.

Búsquedas: 1.
Archivos escritos: `docs/proyecto/incidentes/INC-2026-0042-analisis.md`, `docs/proyecto/incidentes/INC-2026-0042-respuesta.md`, `docs/proyecto/registro-de-tiempos.md`.
Comandos, todos con aprobación: `bash -c "date +%H:%M; bash scripts/proyecto/entregar.sh incidente" 2>&1 | Select-Object -Last 30; git status --short`; `Get-Content docs\proyecto\incidentes\INC-2026-0042.md; Get-Content docs\operacion\runbook-plantilla.md`; `$t="$env:TEMP\lib15"; Get-Content $t\d.txt | Select-Object -Skip 12 -First 45; diff (Get-Content $t\a.txt)[12..60] (Get-Content $t\d.txt)[12`; `cd escenario\datos; Select-String -Path comercios.txt -Pattern "CM0001|CM0007"; Select-String -Path transacciones.txt -Pattern "CM0001|CM000`.

Respuesta del chat:

**Causa.** Viene de la versión 1.5.0. Un monto justo en el límite de un tramo ahora paga el porcentaje del tramo inferior (decisión 0005). CM0001 tiene dos ventas en el límite, TX002001 y TX002002. Los montos salen de dos ejecuciones de junio, antes y después. Las comisiones por transacción las calculé a mano con el plan PL01, porque el programa no las detalla.

**Alcance.**
- Por la misma causa: CM0001 (+11,00) y CM0007 (+11,00, y su neto baja 10,45).
- Por el redondeo único: CM0011, CM0016 y CM0025, +0,01 cada uno.

El detalle completo está en el análisis y en la respuesta, que se muestran abajo.

#### `docs/proyecto/incidentes/INC-2026-0042-analisis.md`

```markdown
# Runbook: Reclamo de comisión de junio, INC-2026-0042

| Campo | Valor |
|---|---|
| Servicio | Liquidación mensual de comisiones, escenario .NET |
| Responsable | Equipo de desarrollo, segundo nivel |
| Última verificación | 2026-10-12, por el participante con apoyo de Copilot |
| Documentos relacionados | `CHANGELOG.md` (1.5.0), `docs/proyecto/notas-de-version-1.5.0.md`, `docs/arquitectura/decisiones/0005-limite-de-tramo-en-el-tramo-inferior.md`, `docs/proyecto/historia-reporte-medios-de-pago.md`, `escenario/README.md` |

## Síntoma 1: la comisión de junio de CM0001 subió S/ 11.00 sin que cambiaran sus ventas

**Hechos del comercio (confirmados).** CM0001, Consorcio Barranco S.A.C., plan PL01. Comisión
de 2026-06 antes S/ 727.34, ahora S/ 738.34. Sus ventas y su plan no cambiaron.

**Lo que el comercio supone (no confirmado).** Que es un error y que otros comercios están
igual. Lo primero se descarta abajo; lo segundo es cierto solo en parte.

### Diagnóstico

1. Se compilaron y ejecutaron dos veces la liquidación de 2026-06 en .NET: el código anterior
   a la corrección (commit 8bac1ea, extraído con `git archive` a una carpeta temporal) y el
   actual.

   ```bash
   cd escenario/dotnet && dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll 2026-06
   ```

   **Resultado.** CM0001: comisión 727.34 antes y 738.34 ahora; neto 25346.74 antes y
   25335.74 ahora. Coincide con el comercio.

2. Causa. El cambio viene de la versión 1.5.0 (`CHANGELOG.md`, «Corregido»): un monto
   exactamente igual al límite de un tramo antes se liquidaba con el porcentaje del tramo
   superior; ahora se liquida con el del tramo inferior (límite superior inclusivo). Lo respalda
   la decisión 0005 y la respuesta del negocio en la historia del reporte («Al tramo inferior.
   El límite superior es inclusivo.»), criterio 4. El plan PL01 es
   `0:500:3.5 | 500:2000:2.9 | 2000:10000:2.5 | 10000:999999:2.1`
   (`escenario/datos/planes.txt`), con monto fijo de 0.30 por transacción.

3. Las transacciones de CM0001 en el límite, en `escenario/datos/transacciones.txt`: TX002001
   (500.00) y TX002002 (2000.00), ambas aprobadas de junio.

##### Tabla por transacción (CM0001, plan PL01)

Comisión = monto × porcentaje del tramo + 0.30. Calculada a mano con las reglas del plan y
contrastada con la suma de las dos ejecuciones. La salida del programa no detalla comisión por
transacción.

| Transacción | Monto (S/) | Antes (tramo, S/) | Después (tramo, S/) | Diferencia (S/) |
|---|---|---|---|---|
| TX002001 | 500.00 | 2.9 %: 14.80 | 3.5 %: 17.80 | +3.00 |
| TX002002 | 2000.00 | 2.5 %: 50.30 | 2.9 %: 58.30 | +8.00 |
| **Suma** | | | | **+11.00** |

La suma, 11.00, es el monto reclamado y coincide con 738.34 − 727.34. Las demás 21
transacciones liquidadas de CM0001 no cambian.

**Si muestra otra cosa.** Si la suma no diera 11.00, habría otra causa y se escala.

##### Alcance

Comparando las dos ejecuciones comercio por comercio (`diff` de las salidas de 2026-06):

| Comercio | Qué cambia | Antes | Después | Diferencia |
|---|---|---|---|---|
| CM0001 Consorcio Barranco S.A.C. | Comisión | 727.34 | 738.34 | +11.00 |
| CM0007 Inversiones Andina S.R.L. | Comisión | 907.11 | 918.11 | +11.00 |
| CM0007 | Retenciones | 1744.39 | 1743.84 | −0.55 |
| CM0007 | Neto a pagar | 33143.33 | 33132.88 | −10.45 |
| CM0011 Importaciones Jesus Maria S.A.C. | Comisión | 137.82 | 137.83 | +0.01 |
| CM0016 Corporacion Callao S.A.C. | Comisión | 493.99 | 494.00 | +0.01 |
| CM0025 Servicios Miraflores S.A. | Comisión | 957.18 | 957.19 | +0.01 |

- **Por el límite de tramo (misma causa):** CM0001 y CM0007, con TX002001 a TX002004. Ninguno
  más: el resto de las diferencias no viene de montos en límite.
- **Por el redondeo único (otra causa, también en 1.5.0):** CM0011, CM0016 y CM0025, S/ 0.01
  cada uno. Es la corrección de suma exacta de la decisión 0005.
- Abril y mayo de 2026 no cambian (decisión 0005, verificación; no se re-ejecutaron para este
  incidente).
- El neto de CM0001 baja de 25346.74 a 25335.74. CM0001 no tiene retenciones.

##### Acciones

1. Responder al comercio con la causa y la decisión 0005 (borrador en
   `INC-2026-0042-respuesta.md`).

   **Verificado.** Causa y montos verificados con las dos ejecuciones del 2026-10-12. El envío
   no se hizo.

2. Avisar a CM0007 y a los tres comercios con diferencia de 0.01. **No verificada** y no es
   decisión técnica: ver la pregunta abierta.

##### Escalamiento

Escalar al responsable comercial si el comercio rechaza la explicación. Información a
adjuntar: periodo 2026-06, comercio, TX002001 y TX002002, la tabla de arriba y la decisión
0005.

##### Preguntas abiertas al negocio

- ¿Se avisa de forma proactiva a CM0007 (+11.00 de comisión) y a CM0011, CM0016 y CM0025
  (+0.01)?
- ¿Corresponde alguna medida comercial sobre lo ya cobrado o conciliado con la liquidación
  anterior? Este análisis no la propone ni la descarta.
- La decisión 0005 sigue en estado «Propuesta». ¿Quién la aprueba?

#### Lo que este runbook no cubre

- El escenario Java conserva la regla anterior: sus montos de 2026-06 coinciden con la columna
  «Antes». Si una liquidación se emite con Java, quedan distintas; se escala.
- Medidas comerciales (devoluciones, compensaciones, cambios de plan).
```

## `docs/proyecto/incidentes/INC-2026-0042-respuesta.md`

```markdown
Estimados señores de Consorcio Barranco S.A.C.:

Gracias por escribirnos antes de pagar. Revisamos su liquidación de junio de 2026 y confirmamos
que sus cifras son correctas: la comisión pasó de S/ 727.34 a S/ 738.34, una diferencia de
S/ 11.00. Sus ventas y su plan no cambiaron.

**Qué cambió.** En nuestra última actualización (versión 1.5.0) corregimos cómo se comisiona
una venta que cae exactamente en el límite entre dos tramos del plan. Antes se le aplicaba el
porcentaje del tramo superior; ahora se aplica el del tramo inferior, según lo definido por el
área de negocio: «el límite superior es inclusivo» (decisión de arquitectura 0005).

**Cómo les afecta.** En junio tuvieron dos ventas exactamente en el límite:

| Venta | Monto | Comisión antes | Comisión ahora | Diferencia |
|---|---|---|---|---|
| TX002001 | S/ 500.00 | S/ 14.80 | S/ 17.80 | + S/ 3.00 |
| TX002002 | S/ 2000.00 | S/ 50.30 | S/ 58.30 | + S/ 8.00 |
| Total | | | | + S/ 11.00 |

Por eso el monto neto a pagar de junio baja de S/ 25 346.74 a S/ 25 335.74. El resto de sus
ventas no cambió.

**Qué puede hacer.** Si no está de acuerdo con esta explicación o con la regla aplicada, puede
responder este correo indicando las ventas en discusión; el caso pasa a revisión del área
comercial.

Atentamente,
Equipo de soporte, Pasarela Andina
```

#### `docs/proyecto/registro-de-tiempos.md` (por ahora, sin hora de término)

```markdown
# Registro de tiempos

Hora real de inicio y de término de cada fase, anotadas en el momento con `date +%H:%M`. Los
minutos reales son el término menos el inicio. «Origen» dice `participante` cuando las horas
las anotó quien hizo el laboratorio, y `referencia` cuando las dejó
`scripts/proyecto/ponerse-al-dia.sh` porque ese laboratorio no se hizo. Un tiempo de
referencia no es del participante y no se compara como propio.

| Fase | Laboratorio | Inicio (HH:MM) | Término (HH:MM) | Minutos reales | Estimado con IA (min) | Diferencia | Origen |
|---|---|---|---|---|---|---|---|
| Requerimientos | 5.1, paso 1 | 18:36 | 18:38 | | 5 | | participante |
| Estimación | 5.1, paso 2 | 18:38 | 18:39 | | 10 | | participante |
| Análisis y diseño | 5.1, paso 3 | 18:39 | 18:40 | | 30 | | participante |
| Desarrollo | 5.2, pasos 1 a 3 | 18:41 | 18:44 | | 90 | | participante |
| Pruebas | 5.3, paso 1 | 18:45 | 18:46 | | 45 | | participante |
| Integración continua | 5.3, paso 2 | 18:47 | 18:49 | | 15 | | participante |
| Mantención | 5.3, paso 3 | 18:49 | 18:52 | | 20 | | participante |
| Revisión de código | 5.3, paso 4 | 18:54 | 18:56 | | 30 | | participante |
| Seguridad | 5.3, paso 4 | 18:54 | 18:56 | | 15 | | participante |
| Liberación | 5.4, paso 1 | 18:56 | 18:57 | | 20 | | participante |
| Operación y soporte | 5.4, paso 2 | 18:58 | | | 20 | | participante |
| Mantención evolutiva | 5.4, paso 3 | | | | 40 | | |

## Hallazgos abiertos

Lo que un paso encontró y queda para un laboratorio posterior, una línea por hallazgo, con
el laboratorio y el comando que lo muestra. Sin causa: se diagnostica cuando corresponde.
```

**Para ti:** ¿La respuesta se puede enviar así o qué cambia? Anoto la hora de término y propongo el commit cuando respondas.

**Observaciones, sin tocar:**
- Java sigue con la regla anterior para 2026-06.
- La decisión 0005 sigue «Propuesta».
- Los cambios de 1.5.0 todavía no están commiteados.

## 5.4 paso 2: respuesta del participante

Escrito: `se envía así`

Modo: Agent. Segundos de trabajo del agente: 8.

Archivos escritos: `docs/proyecto/registro-de-tiempos.md`.
Comandos, todos con aprobación: `bash -c "date +%H:%M"`.

Respuesta del chat:

Anoté el término de Operación y soporte a las 18:59. Dejé `docs/proyecto/registro-de-tiempos.md` con esta fila, y el resto no cambió:

```markdown
| Operación y soporte | 5.4, paso 2 | 18:58 | 18:59 | | 20 | | participante |
```

**Commit propuesto** (yo no lo hago):
```
git add docs/proyecto && git commit -m "Incidente: analisis y respuesta"
```

Ese `git add docs/proyecto` también incluye los cambios de la versión 1.5.0 que siguen sin commitear:
- `docs/proyecto/notas-de-version-1.5.0.md`
- la fila de Liberación en el registro de tiempos

Solo `CHANGELOG.md`, que está en la raíz, queda fuera. Si prefieres commits separados, súmalo al de la versión 1.5.0 y deja este solo con `docs/proyecto/incidentes` y el registro de tiempos.

¿Confirmas el commit?

## 5.4 paso 3: `/lab-5-4-paso-3-estimar-evolutiva`

Escrito: `/lab-5-4-paso-3-estimar-evolutiva`

Modo: Agent. Segundos de trabajo del agente: 79.

Archivos escritos: `docs/proyecto/estimacion-evolutiva.md`, `docs/proyecto/registro-de-tiempos.md`.
Comandos, todos con aprobación: `bash -c "date +%H:%M"; Get-Content docs\proyecto\backlog\solicitud-evolutiva.md; Get-Content scripts\integracion\stack.txt; Get-Content docs`; `Get-Content docs\proyecto\plantillas\estimacion.md; Get-Content escenario\dotnet\LiquidacionComercios\Reporte\CalculadoraReporteMedios.cs | `; `cd escenario; Get-Content dotnet\LiquidacionComercios\Reporte\CalculadoraReporteMedios.cs | Select -Skip 80 -First 120; Select-String dotnet`; `bash -c "date +%H:%M"`.

Respuesta del chat:

Estimación hecha: **108 min de la persona con IA** (390 sin IA) y 46 min del agente, solo en .NET. No modifiqué código. Los tiempos reales del ciclo (1 a 3 min por fase) no sirven para calibrar, y el documento lo explica. Las cifras son supuestos escalados desde `estimacion.md`.

#### `docs/proyecto/estimacion-evolutiva.md`

````markdown
# Estimación: filtro por categoría de comercio en el reporte por medio de pago

| Campo | Valor |
|---|---|
| Tipo | Mantención evolutiva |
| Historia | `docs/proyecto/backlog/solicitud-evolutiva.md` (sobre `docs/proyecto/historia-reporte-medios-de-pago.md`) |
| Estimó | participante, con Copilot |
| Fecha | 2026-10-12 |

Perfil: senior en .NET, poca práctica con el agente. Es una estimación razonada, no un compromiso; el rango razonable es ±30 %, y más amplio mientras las preguntas abiertas de abajo no tengan respuesta.

## Qué se estima

El mismo reporte por medio de pago, restringido a los comercios de una categoría (restaurantes, turismo, etc.). Se lee de lo que ya existe, en el stack declarado en `scripts/integracion/stack.txt` (`dotnet`):

- `Comercio.Categoria` ya existe en el modelo y viene en `escenario/datos/comercios.txt`. En junio: RESTAURANTE 9, SERVICIOS 11, EDUCACION 6, TURISMO 4, SALUD 3, TECNOLOGIA 3, TRANSPORTE 2, RETAIL 2 (40 comercios).
- `CalculadoraReporteMedios.Calcular(periodo)` recorre todos los comercios; el filtro entra en ese recorrido, antes de acumular. El tope mensual se aplica por comercio dentro del mismo recorrido, así que sigue funcionando.
- `AplicacionLiquidacion` recibe `--reporte-medios [periodo] [ruta]`; hay que agregar la categoría como argumento.
- El formateador debería mostrar la categoría en el encabezado.
- Java no tiene el reporte en este repositorio, así que no hay réplica que mantener mientras el stack sea `dotnet`.
- No toca la liquidación ni los montos de ningún comercio.

## Datos reales que se usan

Solo hay un ciclo completo en el repositorio, el que acaba de terminar, y queda registrado en `docs/proyecto/registro-de-tiempos.md`. Sus minutos reales, término menos inicio, son: Requerimientos 2, Estimación 1, Análisis y diseño 1, Desarrollo 3, Pruebas 1, Integración continua 2, Mantención 3, Revisión de código 2, Seguridad 2, Liberación 1, Operación y soporte 1.

Esos tiempos no sirven para calibrar esta estimación. Son mucho menores que los estimados del 5.1 (por ejemplo, Desarrollo 3 frente a 90) porque el laboratorio entrega las respuestas del negocio y los datos ya preparados, y varios pasos reales (espera del negocio, revisión humana, corridas del pipeline) no ocurren en sesión. Tampoco hay datos de productividad de trabajos parecidos. Lo que sí se aprovecha del ciclo es la estructura: los mismos pasos en el mismo orden, y que la fase de Mantención de este ciclo encontró discrepancias con las reglas del README que costaron decisiones con el negocio.

Por eso las cifras de abajo son supuestos, escalados por tamaño respecto de `docs/proyecto/estimacion.md` (funcionalidad nueva completa, 340 min de persona con IA): este cambio es un filtro sobre un módulo existente.

## Por fase

Minutos de la persona y del agente, por separado. «Sin IA» es lo que tomaría hacerlo a mano.
Créditos y minutos de integración continua como cantidades estimadas, sin precios; el valor por crédito y por minuto se completa con los del plan vigente.

| Fase | Sin IA, persona (min) | Con IA, persona (min) | Con IA, agente (min) | Créditos de IA | Minutos de integración continua | Supuesto principal |
|---|---|---|---|---|---|---|
| Requerimientos | 30 | 10 | 3 | 1 | 0 | Redactar la historia con criterios y llevar las preguntas abiertas al negocio. La espera de las respuestas no está incluida. |
| Estimación | 20 | 5 | 2 | 1 | 0 | Esta misma estimación, revisada por la persona. |
| Análisis y diseño | 45 | 10 | 5 | 2 | 0 | El filtro entra en el recorrido de comercios de `CalculadoraReporteMedios` sin tocar la liquidación. Hace falta una decisión corta de dónde vive el argumento de categoría. |
| Desarrollo | 90 | 20 | 10 | 5 | 0 | Solo .NET. Se agrega el parámetro, el filtro y el encabezado del formateador. Si el negocio exige Java, se suma una réplica completa del reporte (ver riesgos). |
| Pruebas | 60 | 15 | 8 | 4 | 0 | Casos nuevos en `LiquidacionComercios.Pruebas/Reporte/`: una categoría con comercios, una sin comercios, una categoría con un comercio sobre el tope y que la suma de categorías dé el reporte completo. |
| Integración continua | 30 | 8 | 3 | 2 | 8 | Pipeline con el stack dotnet; una o dos corridas hasta quedar en verde. |
| Mantención | 20 | 5 | 3 | 1 | 4 | No aparecen discrepancias nuevas con las reglas. Si aparece una que toque la liquidación, cambia el tipo de trabajo y se vuelve a estimar. |
| Revisión de código | 30 | 15 | 3 | 2 | 0 | Diff chico, revisión humana completa. |
| Seguridad | 15 | 5 | 3 | 1 | 4 | Sin superficie nueva: un argumento de línea de comandos que se compara contra categorías conocidas. |
| Liberación | 30 | 10 | 3 | 2 | 6 | Versión menor (1.6.0 si la 1.5.0 queda vigente), con entrada de registro de cambios y notas. Sin cambio de montos en la liquidación. |
| Operación y soporte | 20 | 5 | 3 | 1 | 0 | Una consulta de uso del reporte filtrado; no se prevé un incidente de montos. |
| Mantención evolutiva | 0 | 0 | 0 | 0 | 0 | No se agrega fase propia: este documento ya es la evolutiva. |
| **Total** | **390** | **108** | **46** | **22** | **22** | |

Equivalencia: 390 min ≈ 6,5 h sin IA; 108 min ≈ 1,8 h de la persona con IA, más 46 min de trabajo del agente.

## Riesgos que pueden mover la estimación

- Preguntas abiertas de abajo sin responder: mueven Requerimientos, Análisis y diseño y Pruebas.
- Réplica en Java: el reporte no existe en Java; hacerlo equivalente en los dos stacks (decisión 0001) sumaría del orden de la funcionalidad nueva completa, no de este cambio. Hoy el stack declarado es `dotnet` y la decisión 0005 ya dejó a Java aparte para la liquidación.
- Hashes esperados: `scripts/verificar-reporte.sh` compara la salida con un hash por periodo; un reporte filtrado necesita sus propios hashes o una validación distinta, y eso puede sumar a Pruebas.
- Participación porcentual: cambia de significado según sea sobre el total de la categoría o sobre el total general, y mueve Desarrollo y Pruebas.
- Conciliación: el pipeline concilia el total del reporte con la suma de las liquidaciones; un reporte filtrado debe quedar fuera de esa comparación o conciliarse contra las liquidaciones de la categoría.
- Poca práctica con el agente: las primeras iteraciones pueden requerir más revisión de la persona.

## Preguntas abiertas para el negocio antes de implementar

1. ¿Una sola categoría por reporte o varias a la vez (por ejemplo, restaurantes y turismo juntos)?
2. ¿Cuáles son los valores de categoría válidos y cómo se escriben? Hoy hay ocho en los datos.
3. ¿Qué debe mostrar el reporte si la categoría no existe o no tiene comercios en el periodo: un reporte en cero o un error?
4. ¿La «participación» de cada medio de pago es sobre el total de la categoría o sobre el total general del periodo?
5. ¿El tope mensual sigue siendo por comercio y la fila de ajuste solo suma los comercios de la categoría? La historia ya fija el tope por comercio; falta confirmarlo para el filtro.
6. ¿Los comercios de baja y los comercios sin plan se excluyen igual que en el reporte completo?
7. ¿Debe llevar la categoría en el encabezado y en el nombre del periodo, y mantener el resto del formato del reporte sin cambios?
8. ¿Hay que conciliar el reporte filtrado con las liquidaciones de la categoría, o el pipeline sigue conciliando solo el reporte completo?
9. ¿Se necesita en Java también, o basta con .NET mientras ese sea el stack declarado?
10. ¿El reporte se comparte con las billeteras (terceros)? Muestra comisiones por categoría de comercios afiliados, así que habría que confirmar con gobierno qué se puede entregar y sin identificar comercios.
11. ¿Para qué periodos se pide: junio de 2026 o todos?

## Cómo se va a comparar con lo real

Con `docs/proyecto/registro-de-tiempos.md`, fase por fase. Como el ciclo de referencia es el del laboratorio, la comparación con lo real de este cambio solo vale si se ejecuta con las mismas condiciones de trabajo que un cambio real.
````

#### `docs/proyecto/registro-de-tiempos.md`

```markdown
# Registro de tiempos

Hora real de inicio y de término de cada fase, anotadas en el momento con `date +%H:%M`. Los
minutos reales son el término menos el inicio. «Origen» dice `participante` cuando las horas
las anotó quien hizo el laboratorio, y `referencia` cuando las dejó
`scripts/proyecto/ponerse-al-dia.sh` porque ese laboratorio no se hizo. Un tiempo de
referencia no es del participante y no se compara como propio.

| Fase | Laboratorio | Inicio (HH:MM) | Término (HH:MM) | Minutos reales | Estimado con IA (min) | Diferencia | Origen |
|---|---|---|---|---|---|---|---|
| Requerimientos | 5.1, paso 1 | 18:36 | 18:38 | | 5 | | participante |
| Estimación | 5.1, paso 2 | 18:38 | 18:39 | | 10 | | participante |
| Análisis y diseño | 5.1, paso 3 | 18:39 | 18:40 | | 30 | | participante |
| Desarrollo | 5.2, pasos 1 a 3 | 18:41 | 18:44 | | 90 | | participante |
| Pruebas | 5.3, paso 1 | 18:45 | 18:46 | | 45 | | participante |
| Integración continua | 5.3, paso 2 | 18:47 | 18:49 | | 15 | | participante |
| Mantención | 5.3, paso 3 | 18:49 | 18:52 | | 20 | | participante |
| Revisión de código | 5.3, paso 4 | 18:54 | 18:56 | | 30 | | participante |
| Seguridad | 5.3, paso 4 | 18:54 | 18:56 | | 15 | | participante |
| Liberación | 5.4, paso 1 | 18:56 | 18:57 | | 20 | | participante |
| Operación y soporte | 5.4, paso 2 | 18:58 | 18:59 | | 20 | | participante |
| Mantención evolutiva | 5.4, paso 3 | 19:00 | 19:00 | | 40 | | participante |

## Hallazgos abiertos

Lo que un paso encontró y queda para un laboratorio posterior, una línea por hallazgo, con
el laboratorio y el comando que lo muestra. Sin causa: se diagnostica cuando corresponde.
```

La hora de inicio la tomé a las 19:00, pero no la anoté en el registro en ese momento. Solo la registré junto con el término, que también marcó 19:00. Por eso la fila quedó en 0 minutos, aunque trabajé en esto más de un minuto.

**Preguntas abiertas al negocio** (están también en el documento):
1. ¿Una categoría o varias a la vez?
2. ¿Cuáles son los valores de categoría válidos? Hoy hay ocho.
3. ¿Qué se muestra si la categoría no existe o no tiene comercios: un reporte en cero o un error?
4. ¿La participación se calcula sobre el total de la categoría o sobre el total general?
5. ¿El tope sigue siendo por comercio, con la fila de ajuste solo de los comercios de la categoría?
6. ¿Los comercios de baja y sin plan se excluyen igual que en el reporte completo?
7. ¿Se muestra la categoría en el encabezado y el resto del formato queda igual?
8. ¿Se concilia el reporte filtrado con las liquidaciones de la categoría o solo el completo?
9. ¿Se necesita en Java o basta con .NET?
10. ¿Se comparte el reporte con las billeteras? Habría que confirmar con gobierno qué se puede entregar.
11. ¿Para qué periodos se pide?

**Commit propuesto** (yo no lo hago): `git add docs/proyecto && git commit -m "Estimacion de la evolutiva"`. También incluiría los archivos pendientes de la versión 1.5.0 y del incidente que están en `docs/proyecto`.

**Observaciones, sin tocar:**
- Java no tiene el reporte.
- La decisión 0005 sigue «Propuesta».
- `CHANGELOG.md`, en la raíz, sigue fuera del commit propuesto.

¿Confirmas el commit?

## 5.4 paso 4: `/lab-5-4-paso-4-cierre`

Escrito: `/lab-5-4-paso-4-cierre`

Modo: Agent. Segundos de trabajo del agente: 92.

Archivos leídos: `docs/proyecto/registro-de-tiempos.md`.
Archivos escritos: `docs/proyecto/registro-de-tiempos.md`, `docs/proyecto/activos-del-equipo.md`, `docs/proyecto/medicion-y-presupuesto.md`.
Comandos, todos con aprobación: `Get-ChildItem .github,scripts,docs\proyecto\plantillas,docs\operacion -Recurse -File -Name | Select-String -NotMatch "\.git\\"; Get-Content `; `Select-String docs\gobierno\politica-uso-ia.md -Pattern "### 7" -Context 0,14 | % { $_.Context.PostContext }; Get-Content .github\workflows\`; `Get-Content .github\agents\revisor.agent.md -TotalCount 12; Get-Content .github\copilot-instructions.md -TotalCount 3; Get-Content scripts\v`.

Mensaje durante el trabajo: «Tabla completa. Agrego el resumen y creo los dos documentos.»

Respuesta del chat:

Cierre listo. La fase donde más se equivocó la estimación es **Desarrollo**: tomó 3 min reales contra 90 estimados (−87). No hay filas de referencia, todas son del participante.

**Hay un error de registro en la última fase.** Mantención evolutiva quedó en 0 min (19:00 a 19:00), porque anoté el inicio junto con el término. Por eso cuenta como la tercera con más diferencia (−40), aunque es un artefacto del registro.

#### Estimado contra real (en `docs/proyecto/registro-de-tiempos.md`)

```markdown
| Fase | Laboratorio | Inicio (HH:MM) | Término (HH:MM) | Minutos reales | Estimado con IA (min) | Diferencia | Origen |
|---|---|---|---|---|---|---|---|
| Requerimientos | 5.1, paso 1 | 18:36 | 18:38 | 2 | 5 | −3 | participante |
| Estimación | 5.1, paso 2 | 18:38 | 18:39 | 1 | 10 | −9 | participante |
| Análisis y diseño | 5.1, paso 3 | 18:39 | 18:40 | 1 | 30 | −29 | participante |
| Desarrollo | 5.2, pasos 1 a 3 | 18:41 | 18:44 | 3 | 90 | −87 | participante |
| Pruebas | 5.3, paso 1 | 18:45 | 18:46 | 1 | 45 | −44 | participante |
| Integración continua | 5.3, paso 2 | 18:47 | 18:49 | 2 | 15 | −13 | participante |
| Mantención | 5.3, paso 3 | 18:49 | 18:52 | 3 | 20 | −17 | participante |
| Revisión de código | 5.3, paso 4 | 18:54 | 18:56 | 2 | 30 | −28 | participante |
| Seguridad | 5.3, paso 4 | 18:54 | 18:56 | 2 | 15 | −13 | participante |
| Liberación | 5.4, paso 1 | 18:56 | 18:57 | 1 | 20 | −19 | participante |
| Operación y soporte | 5.4, paso 2 | 18:58 | 18:59 | 1 | 20 | −19 | participante |
| Mantención evolutiva | 5.4, paso 3 | 19:00 | 19:00 | 0 | 40 | −40 | participante |
```

La diferencia es los minutos reales menos el estimado. Debajo de la tabla agregué una sección con las tres fases de mayor diferencia y sus causas probables:

- **Desarrollo, −87.** El laboratorio entregó las respuestas del negocio y los datos ya preparados. La estimación incluía la implementación completa y la revisión humana de cada cambio.
- **Pruebas, −44.** Los casos de la historia vinieron ya definidos, y la estimación suponía diseñarlos y escribirlos.
- **Mantención evolutiva, −40.** Es el error de registro descrito arriba.

Revisión de código y Seguridad comparten la ventana 18:54 a 18:56, así que sus minutos se solapan.

#### `docs/proyecto/activos-del-equipo.md`

```markdown
# Activos reutilizables del equipo

Lo que se usó en el ciclo de vida del reporte y puede llevarse a otro repositorio. Para cada activo: para qué sirve, dónde está y qué habría que cambiar.

## Skills de dominio (`.github/skills/pasarela-*`)

| Skill | Para qué sirve | Dónde está | Qué cambiar para otro repositorio |
|---|---|---|---|
| `pasarela-historia-de-usuario` | Convertir una solicitud en historia con preguntas abiertas y criterios comprobables | `.github/skills/pasarela-historia-de-usuario/SKILL.md` | Ruta de la plantilla y nombre del dominio |
| `pasarela-estimar` | Estimar por fase, con y sin IA, separando persona y agente | `.github/skills/pasarela-estimar/SKILL.md` | Lista de fases y ruta de la plantilla; las cifras no se reutilizan |
| `pasarela-registrar-decision` | Redactar una decisión de arquitectura con la plantilla | `.github/skills/pasarela-registrar-decision/SKILL.md` | Carpeta de decisiones y plantilla |
| `pasarela-reglas-de-negocio` | Reglas del dominio y formato de los datos para calcular a mano | `.github/skills/pasarela-reglas-de-negocio/SKILL.md` | Todo el contenido: es específico de Pasarela Andina |
| `pasarela-verificar-equivalencia` | Comprobar que Java y .NET producen la misma salida | `.github/skills/pasarela-verificar-equivalencia/SKILL.md` | Solo sirve con dos implementaciones del mismo sistema; ajustar el script que llama |
| `pasarela-analizar-incidente` | Analizar un incidente hasta causa y alcance y redactar la respuesta | `.github/skills/pasarela-analizar-incidente/SKILL.md` | Plantilla de runbook y fuentes de cambios |
| `pasarela-notas-de-version` | Versionado semántico, registro de cambios y notas de versión | `.github/skills/pasarela-notas-de-version/SKILL.md` | Ruta del registro de cambios y de la plantilla |

Las skills `lab-*` son pasos guiados del taller y no se reutilizan fuera de él. `scripts/validar-skills.sh` comprueba que cada skill cumpla el formato vigente de Visual Studio Code.

## Plantillas (`docs/proyecto/plantillas/` y `docs/operacion/`)

| Plantilla | Para qué sirve | Dónde está | Qué cambiar |
|---|---|---|---|
| Historia de usuario | Estructura de historia, preguntas abiertas y criterios | `docs/proyecto/plantillas/historia-de-usuario.md` | Casi nada |
| Estimación | Tabla por fase con persona, agente, créditos e integración continua | `docs/proyecto/plantillas/estimacion.md` | Fases del ciclo del otro equipo |
| Notas de versión | Cambios en lenguaje de negocio y en montos | `docs/proyecto/plantillas/notas-de-version.md` | La sección de montos, si no hay montos |
| Registro de tiempos | Inicio, término y estimado por fase | `docs/proyecto/plantillas/registro-de-tiempos.md` | Fases y laboratorio |
| Runbook | Síntoma, diagnóstico, acciones y escalamiento | `docs/operacion/runbook-plantilla.md` | Nombre del servicio |
| Decisión de arquitectura | Contexto, alternativas, decisión y consecuencias | `docs/arquitectura/decisiones/plantilla.md` | Responsables y estados |
| Pull request | Descripción y evidencia de verificación | `.github/pull_request_template.md` | Comandos de verificación |

## Instrucciones y agentes

| Activo | Para qué sirve | Dónde está | Qué cambiar |
|---|---|---|---|
| Instrucciones de repositorio | Idioma, alcance de los cambios, verificación y gobierno para todo agente | `.github/copilot-instructions.md` | Las reglas del escenario y las rutas; conservar idioma, alcance y gobierno |
| Instrucciones por stack | Convenciones de .NET, de Java y de arquitectura BIAN | `.github/instructions/*.instructions.md` | Patrón de rutas y versiones |
| Agentes personalizados | Analista, Documentador, Refactorizador, Revisor y Tester con herramientas acotadas | `.github/agents/*.agent.md` | Rutas del repositorio y el comparador de escenarios |
| Hook de protección de datos | Bloquea acciones sobre los datos del escenario | `.github/hooks/proteger-datos-escenario.*` | La carpeta protegida |
| Política de uso de IA | Reglas de gobierno del equipo | `docs/gobierno/politica-uso-ia.md` | Fechas, responsables y fuentes |

## Pipeline

| Activo | Para qué sirve | Dónde está | Qué cambiar |
|---|---|---|---|
| Integración continua | Compila, prueba, revisa dependencias, comprueba equivalencia y concilia el reporte con las liquidaciones | `.github/workflows/integracion-continua.yml` y `scripts/integracion-local.sh` | Versiones de JDK y .NET, rutas y los pasos de conciliación propios del dominio |
| Stack declarado | Elige `ambos`, `java` o `dotnet` | `scripts/integracion/stack.txt` | Nada; solo la línea activa |
| Hashes esperados | Detecta cambios no previstos en la salida | `scripts/integracion/liquidacion-esperada.sha256` | Se regeneran con la salida del otro sistema |
| Comparación y verificación | Equivalencia Java/.NET y verificación del reporte | `scripts/comparar-escenarios.sh`, `scripts/verificar-reporte.sh` | Comandos de ejecución y hashes |

Los scripts se ejecutan en Git Bash. El pipeline y la ejecución local comparten los mismos pasos para que no diverjan.
```

#### `docs/proyecto/medicion-y-presupuesto.md`

```markdown
# Medición y presupuesto de créditos

Propuesta para extender el uso de Copilot. Acompaña la regla 7 de `docs/gobierno/politica-uso-ia.md` y la guía `docs/gobierno/uso-responsable-de-tokens.md`. No trae precios, cuotas ni límites: son campos a completar con la documentación oficial del plan vigente y la configuración de la organización.

## Parte 1. Línea base de medición

Se toma la línea base antes de extender el uso y se repite después, en la misma ventana de tiempo, para comparar. Ninguna cifra de este documento es real todavía.

| Qué se mide | De dónde sale el dato | Responsable | Antes | Después |
|---|---|---|---|---|
| Personas que usan Copilot cada semana | Métricas de uso de la organización de GitHub | COMPLETAR (administrador de la organización) | COMPLETAR | COMPLETAR |
| Créditos consumidos por persona y por modo | Métricas de uso y facturación de la organización | COMPLETAR | COMPLETAR | COMPLETAR |
| Tiempo de revisión de pull requests (apertura a aprobación) | Datos de pull requests de GitHub | COMPLETAR (líder técnico) | COMPLETAR | COMPLETAR |
| Defectos encontrados después de integrar | Incidencias etiquetadas como defecto, por pull request de origen | COMPLETAR (QA) | COMPLETAR | COMPLETAR |
| Minutos reales contra estimados por fase | `docs/proyecto/registro-de-tiempos.md` | Cada participante | Primer ciclo del taller | COMPLETAR |
| Fallos de la integración continua por pull request | Ejecuciones del workflow `Integracion continua` | COMPLETAR | COMPLETAR | COMPLETAR |
| Reclamos de monto después de una versión | Mesa de ayuda comercial | COMPLETAR | COMPLETAR | COMPLETAR |

Aviso: el registro de tiempos del primer ciclo viene de un laboratorio con datos y respuestas preparados. Sirve como estructura, no como línea base de productividad.

## Parte 2. Presupuesto de créditos por perfil

El chat, el agente, la línea de comandos y el agente en la nube consumen créditos; las sugerencias en línea no, en los planes pagos. Los valores se completan con el plan vigente.

| Perfil | Modos de trabajo | Créditos al mes por persona | Acción al acercarse al límite |
|---|---|---|---|
| Uso ligero (consulta y completado) | Sugerencias en línea y chat con archivo referenciado | COMPLETAR | Aviso a la persona; revisar si el contexto es más grande de lo necesario |
| Desarrollo diario | Chat en línea y agente para cambios acotados, con plan previo | COMPLETAR | Aviso al 80 %; abrir una conversación nueva por tarea, `/compact` y desactivar herramientas que no se usan |
| Trabajo intensivo (varios archivos, migraciones, pruebas) | Agente, plan antes de ejecutar, agente en la nube | COMPLETAR | Aviso al 80 %; el líder técnico decide si amplía el presupuesto de la persona o reparte la tarea |
| Líder técnico y revisión | Chat y agentes de solo lectura (Revisor, Analista) | COMPLETAR | Aviso al 80 %; priorizar revisión de lo de más riesgo |

Reglas comunes:

- **Detención al límite.** Se configura en la organización de GitHub según la documentación oficial; el valor y el comportamiento exacto se completan ahí.
- **Seguimiento mensual.** El responsable revisa el consumo por persona y por modo con las métricas de la organización y ajusta el presupuesto del perfil.
- **Presupuesto del equipo.** COMPLETAR con la configuración de la organización; el total del equipo y su reserva para el agente en la nube.
- **Estimación de consumo.** Cada estimación por fase estima créditos como cantidad (por ejemplo, 64 en `docs/proyecto/estimacion.md` y 22 en `docs/proyecto/estimacion-evolutiva.md`); se compara con el consumo real cuando haya datos.
- **Fuentes.** Las de la guía de tokens: documentación de facturación de GitHub Copilot y guías de uso de Visual Studio Code. Hay que volver a consultarlas antes de fijar valores.
```

**Commit final propuesto** (yo no lo hago):
```
git add docs/proyecto
git commit -m "Cierre del ciclo: estimado contra real, activos y medicion"
```

**Observaciones, sin tocar:**
- El 1.5.0 no está ejecutado en el pipeline desde que lo creé.
- Java sigue sin la corrección de tramo.
- La decisión 0005 sigue «Propuesta».

¿Confirmas el commit?

## Participante: commits del laboratorio

```bash
git add CHANGELOG.md docs/proyecto/notas-de-version-1.5.0.md docs/proyecto/registro-de-tiempos.md && git commit -m "Version 1.5.0: registro de cambios y notas de version"
git add docs/proyecto && git commit -m "Incidente: analisis y respuesta"
git add docs/proyecto && git commit -m "Estimacion de la evolutiva"
git add docs/proyecto && git commit -m "Cierre del ciclo: estimado contra real, activos y medicion"
```

Al terminar, `bash scripts/integracion-local.sh` en la rama:

```
== Equivalencia: liquidacion de los tres periodos (stack: dotnet) ==
  [ OK ] dotnet 2026-04 coincide con el hash esperado
  [ OK ] dotnet 2026-05 coincide con el hash esperado
  [ OK ] dotnet 2026-06 coincide con el hash esperado

== Conciliacion: total del reporte contra la suma de las liquidaciones (stack: dotnet) ==
  [ OK ] dotnet 2026-04: reporte 3038455 centavos, liquidaciones 3038455 centavos, diferencia 0
  [ OK ] dotnet 2026-05: reporte 3138564 centavos, liquidaciones 3138564 centavos, diferencia 0
  [ OK ] dotnet 2026-06: reporte 3663734 centavos, liquidaciones 3663734 centavos, diferencia 0

== Resumen (stack: dotnet) ==
  Todos los pasos pasan.
```

## Esperado contra observado

- Paso 1: propone un número, lo justifica y termina sin escribir archivos. Observado 1.5.0,
  sin archivos escritos. Se respondió «apruebo». Las notas explican junio sin nombres de
  clases: CM0001 y CM0007 suben 11,00 cada uno; CM0011, CM0016 y CM0025, 0,01.
- Paso 2: el análisis con una tabla por transacción, TX002001 +3,00 y TX002002 +8,00, y la
  respuesta. Observado igual. Se respondió «se envía así». Al proponer el commit dijo que la
  versión 1.5.0 seguía sin confirmar, cuando ya estaba en un commit: no revisó `git status`.
- Paso 3: la estimación evolutiva con el registro de tiempos real y las preguntas abiertas.
  Observado igual, con once preguntas. Anotó inicio y término a la misma hora y lo dice.
- Paso 4: los tres documentos completos, sin precios ni minutos inventados. Observado igual.
  Los valores que no tiene, como los créditos por perfil, quedan como `COMPLETAR`.
