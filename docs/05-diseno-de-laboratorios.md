# Diseño de los laboratorios

Descomposición de los nueve laboratorios en pasos invocables. Es el insumo de los prompt
files de `.github/prompts/` y de los enunciados de cada laboratorio, que se construyen en
SPEC-009.

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
| lab-5-1 | 45 min | 4 | 40 min | 5 min | ninguno |
| lab-5-2 | 45 min | 4 | 42 min | 3 min | 2 |
| lab-5-3 | 45 min | 4 | 38 min | 7 min | 1 |
| lab-5-4 | 45 min | 2 | 40 min | 5 min | 1 |
| **Total** | **390 min** | **34** | **340 min** | **50 min** | **5** |

Aritmética de la tabla, para que se pueda revisar sin recalcular:

- Duraciones: 30 + 60 + 45 + 45 + 30 + 45 + 45 + 45 + 45 = 390.
- Pasos: 4 + 5 + 4 + 4 + 3 + 4 + 4 + 4 + 2 = 34.
- Suma estimada: 25 + 54 + 37 + 36 + 28 + 40 + 42 + 38 + 40 = 340.
- Holgura: 5 + 6 + 8 + 9 + 2 + 5 + 3 + 7 + 5 = 50, que es 390 − 340.

Treinta y cuatro prompt files. De los treinta y cuatro pasos, uno no lleva prompt file
(`lab-1-4` paso 4, que ejercita comandos del chat escritos por el participante) y uno lleva
dos (`lab-2-4` paso 2, con una variante para agente y otra para instrucción). Cinco pasos
modifican código; el resto produce análisis, documentos o artefactos en `.github/` y se
puede repetir sin restaurar nada.

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
| 4 | `paso-4-comandos-del-chat` | Sin prompt file. Con el método de cálculo seleccionado, el participante escribe `/explain`; después escribe `/plan` seguido de una frase corta que da el enunciado. Compara ambos resultados con el del paso 3 | 8 min |

Suma: 5 + 6 + 6 + 8 = 25 minutos. Holgura: 30 − 25 = 5 minutos.

**Comandos que ejercita.** Los tres tipos de comando del chat que existen hoy:

- Los pasos 1 a 3 se invocan escribiendo `/` seguido del nombre del prompt file. Es la
  forma en que Visual Studio Code expone los prompt files como comandos.
- `/explain`, comando integrado que explica el código seleccionado.
- `/plan`, comando integrado que cambia la sesión al agente Plan y le envía el pedido. Produce
  un plan sin tocar código.

El paso 4 no usa prompt file a propósito: el ejercicio es escribir el comando. Las frases que
acompañan a los comandos son cortas y vienen en el enunciado.

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
| 2 | `paso-2-detectar-errores-tragados` | Localizar los puntos donde una transacción malformada desaparece sin dejar rastro, referenciando el cargador de datos. Sin corregir nada | 10 min |
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

**Elección.** Cada participante construye **un** artefacto: un agente local o una
instrucción reutilizable, no ambos. Así el laboratorio cabe en 45 minutos y la puesta en
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
instrucción de referencia que SPEC-009 deja dentro del directorio del laboratorio. El
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
quedan definidos aquí, pero sus prompt files no se pueden probar de extremo a extremo hasta
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

## lab-5-1. Preparación del escenario integrador

**Duración** 45 minutos. **Capítulo 5.**

**Objetivo.** Levantar el escenario, entenderlo con los activos del capítulo 2 y fijar los
criterios con que se evaluarán los dos laboratorios siguientes.

**Defectos que ejercita.** Los diez, como objeto de inventario. Ninguno se corrige.

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-levantar-y-verificar` | Compilar, ejecutar y correr el comparador de escenarios, para tener una línea base verificada antes de tocar nada | 8 min |
| 2 | `paso-2-mapa-del-sistema` | Producir el mapa de componentes y dependencias con las rutas reales del proyecto | 10 min |
| 3 | `paso-3-inventario-de-riesgos` | Inventario priorizado de problemas, con impacto y esfuerzo, sin corregir ninguno | 12 min |
| 4 | `paso-4-criterios-de-evaluacion` | Convertir el inventario en criterios verificables, no en opiniones | 10 min |

**Punto de partida.** El paso 1 establece la línea base ejecutando `comparar-escenarios.sh`.
Que el laboratorio empiece con un gate en verde es deliberado: sin línea base, los dos
laboratorios siguientes no tienen contra qué comparar.

**Puesta en común.** Los criterios del paso 4 se acuerdan en sala y se usan en 5.2 y 5.3.

---

## lab-5-2. Refactorización y validación incremental

**Duración** 45 minutos. **Capítulo 5.**

**Objetivo.** Ejecutar una mejora con el modo agente en incrementos, validando cada uno.

**Defectos que ejercita.** DEF-02 y DEF-06. **No DEF-01:** migrar el dinero a tipo decimal
cambiaría la salida y rompería la equivalencia entre escenarios, que es lo que el paso 4
verifica. Ese ejercicio se plantea en 5.4, donde ya no hay laboratorios posteriores que
dependan del escenario.

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-plan-incremental` | Plan de refactorización en incrementos validables, con el orden y el criterio de validación de cada uno. Sin tocar código | 10 min |
| 2 | `paso-2-extraer-calculo-comision` | **Modifica código.** Extraer a un método el bloque que calcula la comisión de una transacción | 12 min |
| 3 | `paso-3-extraer-desglose-medios` | **Modifica código.** Extraer a un método el bloque que agrega los montos por medio de pago. Es una zona distinta del mismo archivo, de modo que no depende del paso 2 | 12 min |
| 4 | `paso-4-validar-equivalencia` | Ejecutar el comparador y comprobar que la refactorización no cambió la salida. Funciona igual si el participante no alcanzó a hacer los pasos 2 y 3 | 8 min |

**El paso 4 es el que enseña.** Una refactorización correcta no cambia la salida. El
comparador lo dice en un segundo, y si alguien rompió algo, lo dice con la línea exacta.

**Independencia.** Los pasos 2 y 3 tocan bloques distintos de `CalculadoraLiquidacion`.
Quien hizo solo uno de los dos puede ejecutar el otro sin conflicto.

**Puesta en común.** Quién rompió la equivalencia y en qué, y cuánto habría tardado en
notarlo sin el comparador.

---

## lab-5-3. Estrategia de pruebas, documentación y checklist de revisión

**Duración** 45 minutos. **Capítulo 5.**

**Objetivo.** Cubrir con pruebas una parte de la lógica que hoy no tiene ninguna,
documentar en Markdown la estrategia de pruebas, y revisar el resultado con criterio
humano.

**Cobertura del enunciado contratado.** Pruebas en el paso 1, documentación Markdown en el
paso 2, revisión y checklist en los pasos 3 y 4.

**Defectos que ejercita.** DEF-05 de forma directa: las veinte pruebas existentes no cubren
nada de la lógica de negocio. DEF-08 aparece solo en cuanto se escriben pruebas del borde
de tramos.

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-pruebas-de-tramos` | **Modifica código.** Generar pruebas de la selección de tramo, incluidos los bordes exactos. Archivo nuevo, no toca los existentes | 12 min |
| 2 | `paso-2-documentar-estrategia` | Producir un documento Markdown con la estrategia de pruebas: qué se prueba, qué queda fuera y por qué, qué bordes importan según las reglas de negocio, y qué inconsistencias reveló el paso 1 | 9 min |
| 3 | `paso-3-revision-asistida` | Revisar el diff acumulado con criterio de revisor, y clasificar cada hallazgo en aplicar o descartar | 9 min |
| 4 | `paso-4-checklist-humano` | Producir el checklist de revisión humana que el equipo se lleva, con lo que un agente no puede decidir | 8 min |

Suma: 12 + 9 + 9 + 8 = 38 minutos. Holgura: 45 − 38 = 7 minutos.

**Momento clave.** Al probar el borde de tramo en 500.00, las pruebas del paso 1 van a
exponer DEF-08: las dos implementaciones no coinciden. El participante tendrá que decidir
cuál es la correcta, y la respuesta está en las reglas de negocio, no en el código.

**Extensión para quien termina antes.** Pruebas del tope mensual y de la retención de
garantía, en un archivo nuevo distinto del paso 1. Ahí aparece DEF-03. No tiene tiempo
asignado y no forma parte de la puesta en común.

**Cruce con el caso 01.** El paso 3 es el momento de proyectar
`docs/casos-de-clase/caso-01-escaner-vs-defectos-plantados.md`.

**Independencia.** El paso 2 funciona sin el paso 1: si no hay pruebas nuevas, documenta la
estrategia a partir de las reglas de negocio y de las pruebas existentes. El paso 3
funciona con cualquier diff, incluido uno vacío, en cuyo caso revisa el escenario tal como
está.

---

## lab-5-4. Laboratorio final de activos reutilizables

**Duración** 45 minutos. **Capítulo 5.**

**Objetivo.** Soltar el agente sobre una tarea completa y observar cómo se comporta sin
guía paso a paso, y dejar el entregable de medición y presupuesto que el equipo se lleva.

**Defectos que ejercita.** Los que el participante elija. Es el único laboratorio donde
tocar DEF-01 es aceptable, porque no hay laboratorios posteriores que dependan del
escenario.

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-consolidar-activos` | Un único prompt que pide consolidar lo aprendido en un conjunto de activos aplicables al repositorio real del equipo, con el agente decidiendo el orden y el alcance | 32 min |
| 2 | `paso-2-medicion-y-presupuesto` | Producir un documento corto con la línea base de medición de adopción y la propuesta de presupuesto de créditos para el equipo | 8 min |

Suma: 32 + 8 = 40 minutos. Holgura: 45 − 40 = 5 minutos.

**Por qué el paso 1 rompe la regla de granularidad.** A esta altura los participantes ya
saben descomponer. Lo que no han visto es qué hace un agente cuando nadie lo acota, y eso
solo se observa dándole una tarea grande. El contraste con `lab-1-4`, donde el prompt vago
producía una respuesta inútil, es el arco del taller completo.

**Contenido del entregable del paso 2.** La línea base: qué se mide antes de adoptar, con
qué fuente y cada cuánto. El presupuesto: créditos por usuario al mes, qué modos de trabajo
consumen más, que se trataron en el subtema 1.3, y qué se hace cuando un usuario se acerca
al límite. Es un activo reutilizable: el equipo lo completa con sus propios números.

**Independencia.** El paso 2 no lee el resultado del paso 1. Si el paso 1 se extiende, el
relator lo corta a los 32 minutos para que todos lleguen al paso 2.

**Conducción.** Se lanza el paso 1, se deja correr y el relator recorre la sala mirando
pantallas. La puesta en común ocupa los últimos minutos: quién obtuvo algo aplicable, quién
obtuvo una pila de archivos sin uso, y qué diferenció a unos de otros.

---

## Restricción común a los treinta y cuatro prompt files

Todos llevan de forma explícita la instrucción de no corregir defectos que no formen parte
del paso pedido.

No es una formalidad. Durante la construcción del repositorio, una revisión automática se
ejecutó sola sobre el escenario y propuso corregir dos defectos plantados. Un agente sin esa
restricción arregla el escenario en el primer paso del primer laboratorio y deja sin
ejercicio a los ocho restantes. El episodio está en
[`03-hallazgos.md`](03-hallazgos.md), HALLAZGO-02.

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
produzca el suyo. No es un conflicto, pero los prompt files de este laboratorio no deben
entregar la respuesta ya escrita, y el agente y la instrucción de referencia que usa quien
quedó atrás no deben coincidir con lo que el paso 2 pide construir.
