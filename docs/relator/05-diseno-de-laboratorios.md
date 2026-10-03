# Diseño de los laboratorios

Descomposición de los nueve laboratorios en pasos invocables. Cada paso es una skill de
`.github/skills/`, con nombre `lab-` más el laboratorio y el paso, restringida a invocación
explícita. Hasta SPEC-008 los pasos se diseñaron como prompt files. SPEC-009 los migró a
skills, ver HALLAZGO-06 en [`03-hallazgos.md`](03-hallazgos.md).

> **Documento del relator.** Los participantes ven el enunciado de su laboratorio, no este
> documento.

## Criterios de descomposición

**Un paso, una invocación, un resultado observable.** Entre tres y cinco pasos por
laboratorio. La excepción es `lab-5-4`, cuyo paso principal es un prompt único y largo a
propósito, seguido de un paso corto para el entregable de medición.

**Cada paso se ejecuta sin depender del anterior.** Es un requisito duro. Si un
participante quedó atrás o su paso 2 produjo algo distinto, tiene que poder ejecutar el 3 y
volver a la sala. Los pasos que modifican código operan siempre sobre el escenario tal como
está publicado, y cuando dos pasos tocan el mismo archivo lo hacen en zonas distintas.

**El tiempo del agente no es tiempo muerto.** El relator habla mientras corre. Aun así,
cada laboratorio deja holgura sobre su duración asignada.

**Los pasos de análisis no modifican código.** Es lo que los hace repetibles sin restaurar
nada, y por eso la mayoría de los pasos son de análisis.

## Resumen

| Laboratorio | Duración | Pasos | Suma estimada | Holgura | Modifican código |
|---|---|---|---|---|---|
| lab-1-4 | 30 min | 4 | 25 min | 5 min | ninguno |
| lab-1-5 | 60 min | 5 | 54 min | 6 min | 1 |
| lab-2-4 | 45 min | 4 | 37 min | 8 min | ninguno |
| lab-3-4 | 45 min | 4 | 36 min | 9 min | ninguno |
| lab-4-4 | 30 min | 3 | 28 min | 2 min | ninguno |
| lab-5-1 | 45 min | 3 | 35 min | 10 min | ninguno |
| lab-5-2 | 45 min | 3 | 38 min | 7 min | 1 |
| lab-5-3 | 45 min | 4 | 39 min | 6 min | 3 |
| lab-5-4 | 45 min | 4 | 38 min | 7 min | ninguno |
| **Total** | **390 min** | **34** | **330 min** | **60 min** | **5** |

Aritmética de la tabla, para que se pueda revisar sin recalcular:

- Duraciones: 30 + 60 + 45 + 45 + 30 + 45 + 45 + 45 + 45 = 390.
- Pasos obligatorios: 4 + 5 + 4 + 4 + 3 + 3 + 3 + 4 + 4 = 34. Los opcionales, el paso 4 del
  4.4 y el paso 5 del 5.3, no se cuentan.
- Suma estimada: 25 + 54 + 37 + 36 + 28 + 35 + 38 + 39 + 38 = 330.
- Holgura: 5 + 6 + 8 + 9 + 2 + 10 + 7 + 6 + 7 = 60, que es 390 − 330. Las estimaciones del
  capítulo 5 son de diseño; la medición de SPEC-016 está en `08-verificacion-de-skills.md`.

Una skill de laboratorio por paso, más la variante del paso 2 del `lab-2-4`, que tiene una
skill para agente y otra para instrucción. La lista vigente sale de
`ls -d .github/skills/lab-*`. Cinco pasos modifican
código. El resto produce análisis, documentos o artefactos en `.github/` y se puede repetir
sin restaurar nada. `scripts/reiniciar-lab.sh` deja cualquier laboratorio en su punto de
partida.

---

## lab-1-4. Práctica guiada de mejora incremental de prompts

**Duración** 30 minutos. **Capítulo 1.**

**Objetivo.** Ver qué aporta cada elemento de un prompt, ejecutando el mismo pedido varias
veces sobre el mismo archivo y comparando los resultados, y usar los comandos del chat que
existen en la versión vigente de Visual Studio Code.

**Defectos que ejercita.** Ninguno se corrige. DEF-02 es el objeto de observación: el
método de 282 líneas es lo bastante grande como para que un prompt vago produzca respuestas
dispersas y la diferencia se note.

**Ningún paso modifica código.** Los cuatro son invocaciones de análisis sobre el mismo
archivo, así que el laboratorio es repetible sin restaurar nada y los cuatro pasos son
independientes por construcción.

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-prompt-vago` | Pedir «mejora este código» sobre la clase de cálculo, sin más. Produce una respuesta larga, dispersa y no comparable entre participantes. Es la línea base | 5 min |
| 2 | `paso-2-agregar-objetivo` | El mismo pedido con objetivo, alcance y el archivo referenciado de forma explícita. La respuesta se acota | 6 min |
| 3 | `paso-3-agregar-restricciones` | Agregar restricciones y forma de la salida. Aquí las respuestas de los doce participantes empiezan a parecerse | 6 min |
| 4 | `paso-4-comparar-resultados` | Con el método de cálculo seleccionado, el participante escribe `/explain`; después escribe `/plan` seguido de una frase corta que da el enunciado. Al final invoca la skill, que compara esas dos respuestas con la del paso 3 en la misma conversación | 8 min |

Suma: 5 + 6 + 6 + 8 = 25 minutos. Holgura: 30 − 25 = 5 minutos.

**Comandos que ejercita.** Los tres tipos de comando del chat que existen hoy:

- Los pasos se invocan escribiendo `/` seguido del nombre de la skill. Es la forma en que
  Visual Studio Code expone las skills como comandos.
- `/explain`, comando integrado que explica el código seleccionado.
- `/plan`, comando integrado que cambia la sesión al agente Plan y le envía el pedido. Produce
  un plan sin tocar código.

En el paso 4 el participante escribe los comandos integrados. La skill del paso 4 solo
compara. Las frases que acompañan a los comandos son cortas y vienen en el enunciado.

**Puesta en común.** Cuál de los resultados usarían en un pull request, cuánto del prompt
hizo falta para llegar ahí, y qué resolvió un comando de una palabra que un prompt largo
no resolvió mejor.

---

## lab-1-5. Análisis y mejora de un componente

**Duración** 60 minutos. **Capítulo 1.**

**Objetivo.** Analizar un componente real con control de contexto explícito, y aplicar una
única mejora acotada.

**Defectos que ejercita.** DEF-02 (método monstruo), DEF-07 (errores en silencio), DEF-09
(nombres que mienten), DEF-06 (responsabilidades mezcladas).

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-inventario` | Inventariar las responsabilidades del método de cálculo, con el archivo referenciado de forma explícita. Salida en tabla | 10 min |
| 2 | `paso-2-rastrear-lineas-invalidas` | Rastrear qué le pasa a una línea mal formada de los datos desde que se lee hasta la liquidación, referenciando el cargador de datos. Sin corregir nada. El nombre no anticipa el hallazgo | 10 min |
| 3 | `paso-3-contrastar-nombres` | Contrastar el nombre de tres métodos contra lo que hacen de verdad. Sin renombrar nada | 10 min |
| 4 | `paso-4-proponer-mejora` | Proponer **una** mejora acotada, con su justificación y su riesgo. Sin aplicarla | 12 min |
| 5 | `paso-5-aplicar-extraccion` | **Modifica código.** Extraer el cálculo de la retención de garantía a un método propio. La zona está fijada en el prompt, de modo que no depende de lo que el paso 4 haya propuesto | 12 min |

**Nota de independencia.** El paso 5 no toma su objetivo del paso 4. Se le indica la zona
exacta. Si se dejara abierto, doce participantes modificarían doce lugares distintos y la
puesta en común sería imposible.

**Puesta en común.** Qué encontró el agente que el participante no había visto, y qué
encontró el participante que el agente no.

---

## lab-2-4. Creación de un agente local o una instrucción reutilizable

**Duración** 45 minutos. **Capítulo 2.**

**Objetivo.** Construir un artefacto de personalización para una tarea concreta del equipo,
probar que Copilot lo aplica y dejarlo listo para que lo use otro integrante.

**Elección.** Cada participante construye **un** artefacto, un agente local o una
instrucción reutilizable, no ambos, para una de las cuatro tareas de
`labs/cap2/lab-2-4-agente-o-instruccion/tareas.md`. Las tareas se eligieron para no
coincidir con ninguno de los artefactos de referencia de `.github/`, de modo que el
laboratorio no se resuelve copiando un archivo. Así el laboratorio cabe en 45 minutos y la puesta en
común compara dos enfoques distintos para tareas parecidas.

**Defectos que ejercita.** Ninguno. Este laboratorio no toca el escenario: produce un
archivo en `.github/`. Los defectos aparecen como *contenido* del artefacto, porque una de
las reglas del equipo es justamente no corregirlos.

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-elegir-tarea` | A partir del escenario, listar tareas repetibles del equipo y, para la que elija el participante, decidir si conviene un agente o una instrucción, con el criterio explícito | 7 min |
| 2 | `paso-2a-construir-instruccion` o `paso-2b-construir-agente` | Generar el artefacto elegido. La instrucción con su patrón `applyTo`; el agente con su rol y sus herramientas acotadas | 12 min |
| 3 | `paso-3-probar-artefacto` | Comprobar que Copilot lo aplica: la instrucción aparece entre las referencias de la respuesta al trabajar sobre un archivo que coincide con el patrón; el agente aparece en el selector y responde dentro de su rol | 10 min |
| 4 | `paso-4-ajustar-y-documentar` | Corregir lo que falló en la prueba y agregar la descripción que otro integrante necesita para usarlo sin preguntar | 8 min |

Suma: 7 + 12 + 10 + 8 = 37 minutos. Holgura: 45 − 37 = 8 minutos, que son los de la
conversación de sala.

**Independencia.** Los pasos 3 y 4 necesitan un artefacto sobre el cual operar. Si el
participante no alcanzó a producir el suyo en el paso 2, trabaja sobre el agente o la
instrucción de respaldo que el relator entrega. Están en `docs/relator/respaldo-lab-2-4/`,
del lado del relator. El
paso 1 no depende de nada.

**Puesta en común.** Quién eligió agente y quién instrucción para tareas parecidas, qué
hizo que la elección fuera correcta, y cuál de los artefactos usarían mañana en su
repositorio real.

---

## lab-3-4. Caso de uso de MCP local seguro con documentación técnica

**Duración** 45 minutos. **Capítulo 3.**

**Objetivo.** Configurar un servidor MCP local, usar sus herramientas desde el chat y
documentar el caso de uso de forma que se pueda presentar a un área de seguridad.

**Defectos que ejercita.** Ninguno. El material es el servidor MCP local que construye
SPEC-009.

**Dependencia externa.** Este laboratorio necesita el servidor MCP local. Los pasos
quedan definidos aquí, pero sus skills no se pueden probar de extremo a extremo hasta
que el servidor exista.

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-configurar-servidor` | Generar el archivo de configuración del cliente para el servidor local, con transporte por proceso, y confirmar que sus herramientas quedan registradas | 8 min |
| 2 | `paso-2-consultar-con-herramienta` | Resolver una consulta sobre el escenario usando una herramienta del servidor en lugar del contexto del editor | 8 min |
| 3 | `paso-3-inventariar-superficie` | Leer el código del servidor y listar qué datos expone y qué herramientas registra, con los parámetros de cada una. Sin modificar nada | 8 min |
| 4 | `paso-4-documentar-caso-de-uso` | Producir el documento Markdown del caso de uso con cuatro secciones obligatorias: datos que expone el servidor, herramientas que registra, riesgos, y por qué el caso es defendible ante un área de seguridad | 12 min |

Suma: 8 + 8 + 8 + 12 = 36 minutos. Holgura: 45 − 36 = 9 minutos.

**Contenido mínimo del documento del paso 4.** En riesgos, al menos la inyección indirecta
a través de datos que devuelve una herramienta, la ejecución de herramientas sin
aprobación, y la exclusión de contenido que se trata en el subtema 3.3. En la defensa ante
seguridad, que el servidor corre como proceso local, que no tiene salida a internet y qué
controla el participante antes de aprobar cada llamada.

**Independencia.** Los pasos 3 y 4 leen el código del servidor, que está en el
repositorio, así que funcionan aunque la configuración del paso 1 haya fallado.

**Puesta en común.** Qué servidor MCP pedirían para su trabajo, y qué tendrían que
garantizarle al área de seguridad para que lo aprueben.

---

## lab-4-4. Generación de documentación Markdown

**Duración** 30 minutos. **Capítulo 4.**

**Objetivo.** Producir documentación técnica derivada del código, revisable y trasladable a
Confluence.

**Defectos que ejercita.** DEF-10 de forma indirecta y a propósito: el escenario tiene
comentarios que contradicen al código, así que un agente que documente leyendo comentarios
va a producir documentación falsa. Descubrirlo es parte del ejercicio.

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-documentar-reglas` | Derivar las reglas de negocio **del código**, no de los comentarios, y contrastarlas contra las reglas declaradas del escenario | 10 min |
| 2 | `paso-2-documentar-decisiones` | Producir un registro de decisiones técnicas con su contexto y sus consecuencias | 10 min |
| 3 | `paso-3-preparar-para-confluence` | Ajustar el Markdown a lo que Confluence respeta, y señalar qué se pierde al trasladarlo | 8 min |

**Momento clave.** En el paso 1, si el agente documenta que los tramos son acumulativos
—porque lo dice un comentario— acaba de producir documentación que contradice al sistema. Es
el mejor ejemplo del taller sobre por qué la documentación generada se revisa.

**Puesta en común.** Cuántos detectaron la contradicción y cómo.

---

## Capítulo 5. El ciclo de vida completo

Desde SPEC-016 el capítulo 5 recorre las once fases de `CICLO-DE-VIDA.md` con una sola
historia, el reporte de comisiones por medio de pago. Cada participante elige un stack y
trabaja en una rama local; GitHub es un paso opcional. La verdad funcional está en
`funcionalidad-reporte.md` y lo que dice el relator, en `capitulo-5-hoja-de-respuestas.md`.

| Laboratorio | Pasos | Fases | Modifica código |
|---|---|---|---|
| lab-5-1 | Historia de usuario, 15 min; estimación, 10; ubicación en la arquitectura, 10 | Requerimientos, Estimación, Análisis y diseño | No |
| lab-5-2 | Plan, 10; implementación, 20; verificación, 8 | Desarrollo | Paso 2 |
| lab-5-3 | Pruebas, 8; conciliación en el pipeline, 8; diagnóstico y corrección, 15; revisión y pull request, 8; GitHub, opcional | Pruebas, Integración continua, Mantención correctiva, Revisión, Seguridad | Pasos 1 a 3 |
| lab-5-4 | Liberación, 8; incidente, 12; evolutiva, 8; cierre, 10 | Liberación, Operación y soporte, Mantención evolutiva | No |

**Decisiones de diseño.**

- La solicitud del negocio es ambigua sobre el alcance y no contiene decisiones del relator.
  Las preguntas abiertas son la fase de Requerimientos.
- El formato exacto del reporte y el incidente del 5.4 los entrega
  `scripts/proyecto/entregar.sh`, codificados, cuando la skill del paso los pide. El relator no
  reparte nada.
- El 5.2 admite dos caminos, cálculo propio o reutilización de la liquidación, y los dos
  llevan a un pipeline en rojo en el 5.3: por la conciliación o por las pruebas de borde y de
  tercer decimal.
- La mantención correctiva cambia la liquidación de junio a propósito, y el participante
  actualiza ese hash esperado y lo justifica en la descripción del pull request.
- La revisión de código usa la revisión de Copilot sobre los cambios sin confirmar, por eso
  el 5.3 no confirma nada hasta el paso 4.
- El 5.3 depende del 5.1 y del 5.2, y el 5.4 no se reinicia.

## Restricción común a todas las skills de laboratorio

Todas llevan de forma explícita la instrucción de no corregir lo que no forme parte del
paso pedido, y todas declaran `disable-model-invocation: true` para que el agente no las
cargue por su cuenta. `scripts/validar-skills.sh` reprueba la que no cumpla cualquiera de
las dos.

No es una formalidad. Durante la construcción del repositorio, una revisión automática se
ejecutó sola sobre el escenario y propuso corregir dos defectos plantados. Un agente sin esa
restricción arregla el escenario en el primer paso del primer laboratorio y deja sin
ejercicio a los ocho restantes. El episodio está en
[`03-hallazgos.md`](03-hallazgos.md), HALLAZGO-02.

## Cobertura de los diez defectos

Cada defecto queda ejercitado por el camino obligatorio de al menos un laboratorio.

| Defecto | Laboratorio y paso | Cómo aparece |
|---|---|---|
| DEF-01 | 5.3 paso 3 | Una de las dos causas de la conciliación de junio: tres centavos de punto flotante |
| DEF-02 | 1.4 pasos 1 a 4, 1.5 paso 1 | Objeto de observación, inventario y extracción |
| DEF-03 | 4.4 paso 1 | La documentación del cálculo muestra el tope del recargo en 3.0 en una calculadora y 3.5 en la otra |
| DEF-04 | 4.4 paso 1 | El contraste con la regla 8 depende del entorno donde corre el programa |
| DEF-05 | 5.3 paso 1 | No hay pruebas de la lógica de negocio hasta que el participante escribe las del reporte |
| DEF-06 | 1.5 paso 1 | Inventario de responsabilidades |
| DEF-07 | 1.5 paso 2 | Rastreo de una línea mal formada |
| DEF-08 | 5.3 paso 3 | La causa grande de la conciliación de junio, 22,00, en los bordes de tramo |
| DEF-09 | 1.5 paso 3 | Contraste de nombres, con CM0031 suspendido y liquidado |
| DEF-10 | 4.4 paso 1 | La documentación derivada del código contradice el comentario de los tramos |

DEF-03 y DEF-04 pasaron al 4.4 en SPEC-016, cuando el capítulo 5 dejó de inventariar riesgos.
Las dos verificaciones del 4.4 documentaron la diferencia del tope del recargo y el contraste
de la regla 8. DEF-02, DEF-03 y DEF-08 vuelven a aparecer en el 5.2 si el plan del
participante refactoriza o reutiliza la calculadora de comisión.

## Variantes por stack

Ningún paso se duplica por lenguaje.

Los pasos que tocan código se redactan referenciando el escenario por su ubicación
relativa, de modo que el participante trabaje sobre el suyo según el contexto que tenga
abierto. Los dos escenarios tienen mapeo uno a uno y nombres equivalentes, así que un prompt
que nombra el concepto —el método de cálculo de la liquidación— sirve para ambos.

La verificación de esta decisión es parte de la ejecución: si algún paso resulta ambiguo
para uno de los dos stacks, se duplica y se justifica.

## Latencia medida en la máquina virtual

La validación sobre la máquina virtual real, registrada en SPEC-001-C, mostró una latencia
aceptable:

- Las sugerencias cortas en línea responden con rapidez suficiente para trabajar.
- Solo las generaciones largas tardan algunos segundos.

Los laboratorios de sugerencias en línea **sí se pueden ejecutar** en la máquina virtual.

Que los prompts vivan en archivos no se debe a la latencia. Se mantiene porque en el escritorio
remoto las combinaciones de teclas y el copiar y pegar entre ventanas no son confiables, y
porque doce participantes ejecutando el mismo prompt obtienen resultados comparables en
la puesta en común.

## Lo que este diseño deja pendiente

**lab-3-4 depende del servidor MCP local.** Sus cuatro pasos están definidos, pero no se
pueden probar de extremo a extremo hasta que el servidor exista (SPEC-009).

**lab-2-4 se cruza con los activos de referencia.** SPEC-009 construye los artefactos de
personalización del repositorio del taller, y el laboratorio hace que el participante
produzca el suyo. No es un conflicto, pero las skills de este laboratorio no deben
entregar la respuesta ya escrita, y el agente y la instrucción de referencia que usa quien
quedó atrás no deben coincidir con lo que el paso 2 pide construir.
