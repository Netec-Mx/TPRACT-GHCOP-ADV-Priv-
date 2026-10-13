> Salida real grabada en una verificación el 3 de octubre de 2026, stack Java, sin Visual Studio Code. Los segundos son del agente de verificación; no incluyen la lectura del participante.

> Se grabó cuando el registro de cambios partía en 1.0.0. Las versiones se corrigieron al
> registro de cambios del punto de partida: la vigente es 1.4.0, la de `pom.xml`, y la
> propuesta de referencia es 1.5.0.

# Lab 5-4 salida grabada de respaldo

Los cuatro pasos del 5.4, sobre la rama que dejaron el 5.1 al 5.3.


---

# 5.4 paso 1: `/lab-5-4-paso-1-liberar`

Inicio 1791047853, fin 1791047903 (50 s). Comandos de terminal del agente: 3 (`date +%H:%M`,
`git log`, una ejecución de la liquidación de junio para tomar los montos).

## Primera respuesta del agente

Anoté Liberación a las **14:17**. Leí `CHANGELOG.md` (vigente 1.4.0), los tres commits de la
rama, las decisiones 0004 y 0005 y `docs/proyecto/pull-request.md`. Ejecuté la liquidación de
junio; coincide con la de la corrección del 5.3, cuyos montos de antes quedaron en la
descripción del pull request.

**Propongo la versión 1.5.0.**

- **Menor**, porque se agrega una funcionalidad compatible: el reporte por medio de pago y la
  conciliación. Sin `--reporte-medios` el programa se invoca igual que antes.
- No es parche: hay funcionalidad nueva.
- No es mayor: nada deja de funcionar para quien lo usa. Pero la corrección cambia montos de
  junio ya liquidados, y eso se declara en «Cambiado» y en la sección de montos de las notas.

¿Confirmas 1.5.0?

## Respuesta del participante

«Sí, 1.5.0.»

## Segunda respuesta del agente

**Entrada en `CHANGELOG.md`** (arriba de 1.4.0):

- **Agregado:** el reporte con `--reporte-medios`, el paso `conciliacion` del pipeline y las
  pruebas del reporte.
- **Cambiado:** la liquidación de junio de 2026 cambia para cinco comercios; hash de junio
  actualizado; abril y mayo sin cambios.
- **Corregido:** el límite superior de tramo (decisión 0005) y el redondeo de la suma mensual
  (regla 9).

**Notas de versión:** `docs/proyecto/notas-de-version-1.5.0.md`. La sección de montos, en
lenguaje de negocio:

| Comercio | Motivo | Comisión de junio | Neto a pagar |
|---|---|---|---|
| CM0001 Consorcio Barranco S.A.C. | Ventas de S/ 500,00 y S/ 2 000,00 | 727,34 → 738,34 | 25 346,74 → 25 335,74 |
| CM0007 Inversiones Andina S.R.L. | Ídem; además la retención de garantía baja 0,55 | 907,11 → 918,11 | 33 143,33 → 33 132,88 |
| CM0011 Importaciones Jesus Maria S.A.C. | Redondeo de centavos | 137,82 → 137,83 | 3 566,91 → 3 566,90 |
| CM0016 Corporacion Callao S.A.C. | Redondeo de centavos | 493,99 → 494,00 | 14 736,54 → 14 736,53 |
| CM0025 Servicios Miraflores S.A. | Redondeo de centavos | 957,18 → 957,19 | 39 320,08 → 39 320,07 |

Cómo se explica a un comercio: «Su liquidación de junio cambió porque sus ventas de
exactamente S/ 500,00 y S/ 2 000,00 se cobran ahora con el porcentaje que su plan fija para ese
monto», o «porque su comisión del mes se redondeó al centavo hacia arriba, como establecen las
reglas de liquidación». Los nombres de comercio son datos ficticios del escenario.

Te propongo el commit:

```bash
git add -A && git commit -m "Version 1.5.0: registro de cambios y notas de version"
```

No creo etiquetas ni empujo. ¿Lo confirmas?

## Respuesta del participante

«Confirmo.» Ejecutó el commit (`f404627`).

## Medición

- Archivos: `CHANGELOG.md` (M), `docs/proyecto/notas-de-version-1.5.0.md` (nuevo),
  `docs/proyecto/registro-de-tiempos.md` (M).
- Salida esperada: sí. Versión justificada, entrada del registro y notas con montos antes y
  después de una ejecución.
- Restricciones: respetadas. Sin etiquetas ni push; sin nombres de clases en la sección de montos.


---

# 5.4 paso 2: `/lab-5-4-paso-2-atender-incidente`

Inicio 1791047925, fin 1791047979 (54 s). Comandos de terminal del agente: 4 (`date +%H:%M`,
`entregar.sh incidente`, liquidación de junio con el código de la versión 1.4.0 extraído con
`git archive` del commit `5e06f23`, `grep` de las ventas de CM0001 en el límite).

## Respuesta del agente

Anoté Operación y soporte a las **14:18** y recibí el incidente:
`docs/proyecto/incidentes/INC-2026-0042.md`. CM0001 reclama que su comisión de junio subió de
S/ 727,34 a S/ 738,34 sin vender distinto ni cambiar de plan.

**Hechos y suposiciones.** Los montos, las ventas y el plan sin cambios son hechos que
confirmé. Que «si es un error, otros comercios deben estar igual» es una suposición: no es un
error, pero sí hay otros comercios afectados.

**Causa.** Comparé la liquidación de junio de la versión 1.4.0 con la de 1.5.0. CM0001 tiene dos
ventas exactamente en un límite de tramo de su plan Básico: TX002001 por S/ 500,00 (antes 2,9 %
→ 14,80; ahora 3,5 % → 17,80; +3,00) y TX002002 por S/ 2 000,00 (antes 2,5 % → 50,30; ahora
2,9 % → 58,30; +8,00). Suman exactamente **S/ 11,00**. El cambio es intencional: `CHANGELOG.md`
1.5.0, sección «Corregido», y la **decisión 0005**, que registra la respuesta del negocio: «el
límite superior es inclusivo; 500 va al primer tramo, 2000 al segundo». Las notas de versión
1.5.0 ya listan a CM0001 con esos montos.

**Alcance**, verificado con las dos ejecuciones de junio (abril y mayo no cambian):

| Comercio | Causa | Comisión | Neto |
|---|---|---|---|
| CM0001 Consorcio Barranco S.A.C. | Límite de tramo | 727,34 → 738,34 | 25 346,74 → 25 335,74 |
| CM0007 Inversiones Andina S.R.L. | Límite de tramo; retención −0,55 | 907,11 → 918,11 | 33 143,33 → 33 132,88 |
| CM0011 Importaciones Jesus Maria S.A.C. | Redondeo | 137,82 → 137,83 | 3 566,91 → 3 566,90 |
| CM0016 Corporacion Callao S.A.C. | Redondeo | 493,99 → 494,00 | 14 736,54 → 14 736,53 |
| CM0025 Servicios Miraflores S.A. | Redondeo | 957,18 → 957,19 | 39 320,08 → 39 320,07 |

CM0007 está en la misma situación que CM0001.

**Documentos:**

- `docs/proyecto/incidentes/INC-2026-0042-analisis.md`, con la estructura del runbook: síntoma,
  diagnóstico con comandos y resultados observados, acciones (avisar a los otros comercios
  marcada como «no verificada», porque es del área comercial) y escalamiento a la Gerencia
  Comercial si el comercio pide devolución, compensación o cambio de plan.
- `docs/proyecto/incidentes/INC-2026-0042-respuesta.md`: en lenguaje de negocio, explica las dos
  ventas, los montos antes y después, que el límite pertenece al tramo que termina en él por
  definición de Pasarela Andina, y que si no está de acuerdo el caso se eleva a la Gerencia
  Comercial. No promete devolución, compensación ni cambio de plan.

No recomiendo revertir la versión: el monto nuevo está respaldado por la decisión 0005.

¿La respuesta se puede enviar así o qué cambias?

## Respuesta del participante

«Se puede enviar así.»

## Medición

- Archivos: `docs/proyecto/incidentes/INC-2026-0042.md` (entregado),
  `INC-2026-0042-analisis.md` y `INC-2026-0042-respuesta.md` (nuevos),
  `docs/proyecto/registro-de-tiempos.md` (M).
- Salida esperada: sí. Causa citando la decisión, alcance con los otros cuatro comercios,
  respuesta sin promesas.
- Restricciones: respetadas. Sin cambios de código ni datos. La versión 1.4.0 se compiló en una
  carpeta de trabajo aparte, fuera del repositorio.


---

# 5.4 paso 3: `/lab-5-4-paso-3-estimar-evolutiva`

Inicio 1791047998, fin 1791048032 (34 s). Comandos de terminal del agente: 2 (`date +%H:%M`
con el registro de la fila evolutiva, e inspección de la categoría en el código y los datos).

## Respuesta del agente

Anoté una segunda fila de Mantención a las **14:20**, marcada «(evolutiva)». Leí la solicitud
(filtrar el reporte por categoría de comercio), la historia y el código Java del reporte. La
categoría está en `Comercio` (`modelo/Comercio.java:16`), no en `Liquidacion`, así que el
reporte tendría que buscarla en el repositorio para cada liquidación.

Creé `docs/proyecto/estimacion-evolutiva.md` con `pasarela-estimar`, como mantención evolutiva:

- **Dato real citado:** el registro de tiempos del ciclo. Total real **20 minutos** contra **205**
  estimados con IA. Lo uso para las proporciones (Mantención correctiva 30 % del ciclo,
  Desarrollo 20 %) y no para los minutos absolutos, porque el registro viene de una sesión sin
  las esperas de una sala.
- **Estimación:** 205 minutos sin IA, **80 con IA** para la persona (rango 60 a 110), 26 del
  agente, 24 créditos y 9 minutos de integración continua, sin precios. Cada fase con su supuesto.

**Preguntas abiertas para el negocio:**

1. ¿Una categoría por ejecución, varias, o todas en secciones?
2. ¿Categoría actual del comercio o la que tenía en el periodo? Los datos solo guardan la actual.
3. ¿El total filtrado debe cuadrar al centavo con las liquidaciones de esa categoría?
4. ¿Qué se muestra si la categoría no tiene ventas en el periodo?
5. ¿Mismo formato con una línea de categoría en el encabezado? ¿Se carga automáticamente?
6. ¿Java y .NET, o solo el stack en producción?

**Lo que vi y no toqué:** el registro de tiempos tiene Revisión de código y Seguridad con la
misma hora de inicio (14:16), y las filas no están en orden cronológico (Integración continua
y Mantención correctiva ocurrieron antes que Revisión de código). Lo calculé en orden de
ejecución.

No implementé la evolutiva ni modifiqué código.

## Medición

- Archivos: `docs/proyecto/estimacion-evolutiva.md` (nuevo), `docs/proyecto/registro-de-tiempos.md` (M).
- Salida esperada: sí. Estimación con el registro real citado y preguntas abiertas.
- Restricciones: respetadas. Sin código, sin precios.


---

# 5.4 paso 4: `/lab-5-4-paso-4-cierre`

Inicio 1791048046, fin 1791048108 (62 s). Comandos de terminal del agente: 2 (`date +%H:%M`
dos veces, para el fin de la última fase).

## Respuesta del agente

**1. Estimado contra real.** Completé `docs/proyecto/registro-de-tiempos.md`: fin, minutos reales
y diferencia de cada fase, con el fin tomado del inicio de la fase siguiente **en el orden en que
se ejecutaron** (Integración continua y Mantención correctiva ocurrieron antes que Revisión de
código). Total real 20 minutos contra 205 estimados con IA.

| Fase | Real | Estimado con IA | Diferencia |
|---|---|---|---|
| Desarrollo | 4 | 45 | **-41** |
| Pruebas | 1 | 20 | -19 |
| Integración continua | 1 | 20 | -19 |
| Mantención (correctiva) | 6 | 25 | -19 |
| Operación y soporte | 2 | 20 | -18 |
| Revisión de código | 0 | 15 | -15 |
| Análisis y diseño | 1 | 15 | -14 |
| Requerimientos | 2 | 15 | -13 |
| Liberación | 1 | 12 | -11 |
| Estimación | 1 | 10 | -9 |
| Seguridad | 1 | 8 | -7 |

**La fase donde la estimación más se equivocó es Desarrollo (−41 minutos).** Supuse iterar el
formato contra `verificar-reporte.sh`; la especificación técnica fijó todo el formato y abril y
mayo coincidieron al primer intento, y reutilizar la liquidación evitó escribir el cálculo. Le
siguen, empatadas en −19, Pruebas, Integración continua y Mantención, con sus causas en el
registro. Causa común: los tiempos son de una sesión sin esperas de sala; subestiman a una
persona en clase.

**2. Activos reutilizables.** `docs/proyecto/activos-del-equipo.md`: las siete skills
`pasarela-*`, seis plantillas más la de pull request, tres instrucciones (repositorio, Java y
BIAN) y el pipeline (script, paso `conciliacion`, workflow y hashes esperados), cada uno con para
qué sirve, dónde está y qué cambiar en otro repositorio. Anoté una advertencia sobre la
conciliación: si el reporte se construye sobre la fuente que concilia, el paso no detecta sus
errores, como pasó en este ciclo.

**3. Medición y presupuesto.** `docs/proyecto/medicion-y-presupuesto.md`: línea base con siete
indicadores (personas por semana, uso por modo, créditos por persona, tiempo de revisión de pull
requests, defectos después de integrar, estimado contra real, cambios de hash sin causa), con
fuente, frecuencia y responsable; y tres perfiles de presupuesto (básico, desarrollo con agente,
intensivo) con sus modos y qué hacer al acercarse al límite. Créditos, costos, porcentaje de aviso
y comportamiento al límite quedan como COMPLETAR.

Te propongo el commit final de la rama:

```bash
git add -A && git commit -m "Incidente, evolutiva y cierre del ciclo"
```

¿Lo confirmas?

## Respuesta del participante

«Confirmo.» Ejecutó el commit (`4962474`).

## Medición

- Archivos: `docs/proyecto/registro-de-tiempos.md` (M), `docs/proyecto/activos-del-equipo.md` y
  `docs/proyecto/medicion-y-presupuesto.md` (nuevos). El commit incluyó además el incidente y la
  estimación evolutiva de los pasos 2 y 3.
- Salida esperada: sí. Tres documentos y la fase más equivocada.
- Restricciones: respetadas. Sin precios ni cuotas; minutos reales del registro.

