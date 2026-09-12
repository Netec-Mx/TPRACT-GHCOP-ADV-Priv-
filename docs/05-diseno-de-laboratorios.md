# Diseño de los laboratorios

Descomposición de los nueve laboratorios en pasos invocables. Es el insumo de los prompt
files de `.github/prompts/` y de los enunciados que llegan en SPEC-010 a SPEC-018.

> **Documento del relator.** Los participantes ven el enunciado de su laboratorio, no este
> documento.

## Criterios de descomposición

**Un paso, una invocación, un resultado observable.** Entre tres y cinco pasos por
laboratorio. La excepción es `lab-5-4`, que usa un prompt único y largo a propósito.

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
| lab-1-4 | 30 min | 4 | 26 min | 4 min | ninguno |
| lab-1-5 | 60 min | 5 | 54 min | 6 min | 1 |
| lab-2-5 | 60 min | 5 | 56 min | 4 min | ninguno |
| lab-3-4 | 30 min | 3 | 26 min | 4 min | ninguno |
| lab-4-4 | 30 min | 3 | 28 min | 2 min | ninguno |
| lab-5-1 | 45 min | 4 | 40 min | 5 min | ninguno |
| lab-5-2 | 45 min | 4 | 42 min | 3 min | 2 |
| lab-5-3 | 45 min | 4 | 42 min | 3 min | 2 |
| lab-5-4 | 45 min | 1 | 42 min | 3 min | 1 |
| **Total** | **390 min** | **33** | **356 min** | **34 min** | **6** |

Treinta y tres prompt files. Seis pasos modifican código; los otros veintisiete producen
análisis o documentos y se pueden repetir sin restaurar nada.

---

## lab-1-4. Práctica guiada de mejora incremental de prompts

**Duración** 30 minutos. **Capítulo 1.**

**Objetivo.** Ver qué aporta cada elemento de un prompt, ejecutando el mismo pedido cuatro
veces sobre el mismo archivo y comparando los resultados.

**Defectos que ejercita.** Ninguno se corrige. DEF-02 es el objeto de observación: el
método de 282 líneas es lo bastante grande como para que un prompt vago produzca respuestas
dispersas y la diferencia se note.

**Ningún paso modifica código.** Los cuatro son invocaciones de análisis sobre el mismo
archivo, así que el laboratorio es repetible sin restaurar nada y los cuatro pasos son
independientes por construcción.

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-prompt-vago` | Pedir «mejora este código» sobre la clase de cálculo, sin más. Produce una respuesta larga, dispersa y no comparable entre participantes. Es la línea base | 6 min |
| 2 | `paso-2-agregar-objetivo` | El mismo pedido con objetivo y alcance explícitos. La respuesta se acota | 6 min |
| 3 | `paso-3-agregar-restricciones` | Agregar restricciones y forma de la salida. Aquí las respuestas de los doce participantes empiezan a parecerse | 7 min |
| 4 | `paso-4-comparar-modos` | El prompt del paso 3 ejecutado en modo pregunta y en modo edición, para ver qué cambia y qué cuesta cada uno | 7 min |

**Puesta en común.** Cuál de los cuatro resultados usarían en un pull request, y cuánto del
prompt hizo falta para llegar ahí.

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

## lab-2-5. Construcción de los activos del equipo

**Duración** 60 minutos. **Capítulo 2.**

**Objetivo.** Construir los cinco artefactos de personalización y entender la jerarquía
entre ellos.

**Defectos que ejercita.** Ninguno. Este laboratorio no toca el escenario: produce archivos
en `.github/`. Los defectos aparecen como *contenido* de las instrucciones que se escriben,
porque una de las reglas del equipo es justamente no corregirlos.

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-instrucciones-de-repositorio` | Generar las instrucciones de repositorio a partir de las convenciones observadas en el código | 10 min |
| 2 | `paso-2-instrucciones-por-ruta` | Generar instrucciones con alcance por patrón de ruta, distintas para cada escenario, y verificar que el patrón coincide | 12 min |
| 3 | `paso-3-prompt-file-propio` | Construir un prompt file para una tarea repetible del equipo, con parámetros y referencias | 12 min |
| 4 | `paso-4-agente-revisor` | Definir un agente personalizado con rol, herramientas acotadas y modelo asignado | 12 min |
| 5 | `paso-5-skill-reutilizable` | Definir una skill que el agente cargue bajo demanda, y probar que la carga | 10 min |

**Independencia.** Los cinco pasos producen archivos distintos y ninguno lee el resultado
del anterior.

**Puesta en común.** Cuál de los cinco artefactos usarían mañana en su repositorio real, y
cuál les parece que se va a quedar sin mantener.

---

## lab-3-4. Servidor MCP local sin salida a internet

**Duración** 30 minutos. **Capítulo 3.**

**Objetivo.** Configurar un servidor MCP local, usar sus herramientas desde el chat y
documentar el caso con sus riesgos.

**Defectos que ejercita.** Ninguno. El material es el servidor de SPEC-006.

**Dependencia externa.** Este laboratorio necesita el servidor MCP de SPEC-006. Los pasos
quedan definidos aquí, pero sus prompt files no se pueden probar de extremo a extremo hasta
que ese spec esté cerrado.

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-configurar-servidor` | Generar el archivo de configuración del cliente para el servidor local, con transporte por proceso | 8 min |
| 2 | `paso-2-consultar-con-herramienta` | Resolver una consulta sobre el escenario usando una herramienta del servidor en lugar del contexto del editor | 8 min |
| 3 | `paso-3-documentar-riesgos` | Documentar el caso de uso, qué datos atraviesan la herramienta y qué riesgos aplican, incluida la inyección indirecta | 10 min |

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

## lab-5-3. Pruebas y revisión asistida

**Duración** 45 minutos. **Capítulo 5.**

**Objetivo.** Cubrir con pruebas la lógica que hoy no tiene ninguna, y revisar el resultado
con criterio humano.

**Defectos que ejercita.** DEF-05 de forma directa: las veinte pruebas existentes no cubren
nada de la lógica de negocio. DEF-08 y DEF-03 aparecen solos en cuanto se escriben pruebas
del borde de tramos y del tope de recargo.

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-pruebas-de-tramos` | **Modifica código.** Generar pruebas de la selección de tramo, incluidos los bordes exactos. Archivo nuevo, no toca los existentes | 12 min |
| 2 | `paso-2-pruebas-de-tope-y-retencion` | **Modifica código.** Generar pruebas del tope mensual y de la retención de garantía. Archivo nuevo distinto del paso 1 | 12 min |
| 3 | `paso-3-revision-asistida` | Revisar el diff acumulado con criterio de revisor, y clasificar cada hallazgo en aplicar o descartar | 10 min |
| 4 | `paso-4-checklist-humano` | Producir el checklist de revisión humana que el equipo se lleva, con lo que un agente no puede decidir | 8 min |

**Momento clave.** Al probar el borde de tramo en 500.00, las pruebas del paso 1 van a
exponer DEF-08: las dos implementaciones no coinciden. El participante tendrá que decidir
cuál es la correcta, y la respuesta está en las reglas de negocio, no en el código.

**Cruce con el caso 01.** El paso 3 es el momento de proyectar
`docs/casos-de-clase/caso-01-escaner-vs-defectos-plantados.md`.

**Independencia.** Los pasos 1 y 2 crean archivos de prueba distintos. El paso 3 funciona
con cualquier diff, incluido uno vacío, en cuyo caso revisa el escenario tal como está.

---

## lab-5-4. Laboratorio final de activos reutilizables

**Duración** 45 minutos. **Capítulo 5.**

**Objetivo.** Soltar el agente sobre una tarea completa y observar cómo se comporta sin
guía paso a paso.

**Defectos que ejercita.** Los que el participante elija. Es el único laboratorio donde
tocar DEF-01 es aceptable, porque no hay laboratorios posteriores que dependan del
escenario.

**Un solo prompt file, largo y deliberadamente abierto.**

| Paso | Nombre | Propósito | Tiempo |
|---|---|---|---|
| 1 | `paso-1-consolidar-activos` | Un único prompt que pide consolidar lo aprendido en un conjunto de activos aplicables al repositorio real del equipo, con el agente decidiendo el orden y el alcance | 42 min |

**Por qué rompe la regla de granularidad.** A esta altura los participantes ya saben
descomponer. Lo que no han visto es qué hace un agente cuando nadie lo acota, y eso solo se
observa dándole una tarea grande. El contraste con `lab-1-4`, donde el prompt vago producía
una respuesta inútil, es el arco del taller completo.

**Conducción.** Se lanza, se deja correr y el relator recorre la sala mirando pantallas. La
puesta en común es lo que ocupa los últimos minutos: quién obtuvo algo aplicable, quién
obtuvo una pila de archivos sin uso, y qué diferenció a unos de otros.

---

## Restricción común a los treinta y tres prompt files

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

## Lo que este diseño deja pendiente

**lab-3-4 depende de SPEC-006.** Sus tres pasos están definidos, pero no se pueden probar
de extremo a extremo hasta que exista el servidor MCP.

**lab-2-5 se cruza con SPEC-005.** El laboratorio pide que el participante construya los
artefactos que SPEC-005 también construye. No es un conflicto: SPEC-005 produce los del
repositorio del taller y el laboratorio hace que el participante produzca los suyos. Pero
los prompt files de este laboratorio no deben entregar la respuesta ya escrita, y eso
conviene revisarlo cuando SPEC-005 esté cerrado.
