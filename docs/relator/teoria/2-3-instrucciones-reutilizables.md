# 2.3 Instrucciones reutilizables para proyectos Java, .NET y repositorios corporativos

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 2, sesión 2 |
| Duración | 45 minutos. 37 de exposición y 8 de demostración |
| Demostración | [Las instrucciones por ruta](../demos/demo-2-3-instrucciones-por-ruta.md) |
| Artefactos que se proyectan | `.github/copilot-instructions.md`, `.github/instructions/java.instructions.md`, `.github/instructions/dotnet.instructions.md`, `.github/instructions/arquitectura-bian.instructions.md`, `docs/arquitectura/bian-mapeo.md`, `AGENTS.md` |

## La idea en una frase

Cada regla va en el lugar donde aplica, corta y comprobable, porque lo que se pone en las
instrucciones generales se paga en cada pedido.

## Contenido

### Una regla del equipo no es un pedido

Hay reglas que no cambian de una tarea a otra. Con qué versión del lenguaje se compila, cómo
se corren las pruebas, qué framework de pruebas se usa, qué clase no se toca porque sostiene
algo que no se ve. Escribirlas en cada pedido es caro y frágil. Dejarlas escritas una vez,
donde el editor las encuentre solo, es el uso más simple y más rentable de la
personalización.

El subtema 2.1 presentó los dos lugares para eso. `.github/copilot-instructions.md`, que
entra en todos los pedidos, y los archivos `.instructions.md` de `.github/instructions/`,
que entran según la ruta del archivo. Este subtema trata cómo repartir las reglas entre los
dos y cómo escribirlas.

### Lectura guiada de la instrucción general del taller

Antes de las instrucciones por ruta conviene proyectar `.github/copilot-instructions.md`,
porque muestra qué merece estar en el nivel que se paga en cada pedido. Tiene cinco
secciones cortas, y cada una pasa la misma prueba: vale para cualquier archivo del
repositorio.

- **Idioma.** Responder en español neutro y escribir en español comentarios, mensajes de
  commit y documentación. No depende del lenguaje del archivo.
- **Alcance de los cambios.** Hacer exactamente lo que se pide, preguntar antes de tocar un
  archivo que la tarea no nombra y mencionar al final lo que no forma parte de la tarea. Es
  la regla que más se agradece en un equipo, y vale igual en Java, en .NET o en un script.
- **El código del escenario.** Que hay características elegidas a propósito y que no se
  corrigen por iniciativa propia. Que las reglas de negocio están en `escenario/README.md`, y
  que si el código y esas reglas no coinciden, se dice y se cita la regla.
- **Verificación.** El comando que comprueba que los dos escenarios siguen produciendo la
  misma salida. Es un ejemplo de algo que el agente no podría adivinar y que conviene que
  ejecute en lugar de suponer.
- **Ambiente.** Git Bash como terminal, nada que descargue dependencias, un solo editor. Son
  restricciones del ambiente de clase que cambian las propuestas del agente.

Lo interesante es lo que no está. No dice con qué framework se prueba, ni qué versión del
lenguaje se usa, ni qué clase de utilidades no se reemplaza. Todo eso es de un stack, y está
en su instrucción por ruta. Vale preguntar a la sala qué pondrían ellos en la general de sus
propios repositorios, y qué de eso es en realidad de un solo módulo.

### Anatomía de una instrucción por ruta

Conviene proyectar `java.instructions.md` del repositorio del taller. Tiene un encabezado con
tres campos y un cuerpo.

- **`name`.** El nombre visible en la interfaz. Si se omite, se usa el del archivo.
- **`description`.** Para qué tareas es relevante. La documentación recomienda incluirla para
  que la instrucción también se pueda descubrir por su descripción.
- **`applyTo`.** Un patrón de rutas, relativo a la raíz del espacio de trabajo, que dice a qué
  archivos aplica. En el taller, `escenario/java/**/*.java,escenario/java/pom.xml`.

El cuerpo tiene reglas cortas agrupadas por tema. Versión y compilación, estilo del código
existente, pruebas y alcance. La de .NET tiene la misma forma, con su propio patrón y sus
propias reglas.

### Cuándo se aplica

Este punto evita la frustración más común de la sala. Según la documentación, Visual Studio
Code adjunta una instrucción por ruta cuando su patrón coincide con un archivo que el agente
crea o modifica. También puede cargarla cuando la descripción coincide con la tarea, y
siempre se puede adjuntar a mano.

En la práctica, eso significa que una pregunta sobre un archivo Java no garantiza que la
instrucción de Java entre. Una edición sobre ese archivo, sí. La demostración muestra la
misma pregunta sobre un archivo Java y sobre uno .NET, y la lista de referencias dice qué
instrucción entró en cada caso. Si en una pregunta no aparece, se pide un cambio mínimo en el
archivo y ahí se ve. Es la forma correcta de probar una instrucción por ruta, y es la que
usa el laboratorio 2.4.

### Qué va en una instrucción de stack

Las instrucciones de Java y de .NET del taller ilustran el criterio. No repiten lo que
cualquier desarrollador sabe del lenguaje. Dicen lo que es propio de este repositorio.

- **La versión de destino.** El escenario Java compila con nivel de lenguaje 21, aunque el JDK
  instalado sea más nuevo. El .NET apunta a `net10.0`. Sin esa regla, un agente puede usar
  una característica que el proyecto no admite.
- **Cómo se compila y se prueba.** Los comandos exactos, para que el agente los ejecute en
  lugar de adivinarlos.
- **Lo que no se reemplaza y por qué.** En .NET, todo redondeo y formateo de montos pasa por
  una clase que reproduce el comportamiento de Java, porque los dos escenarios tienen que
  dar la misma salida. Esa regla no es obvia leyendo el código, y un agente bien
  intencionado la rompería reemplazándola por la función estándar del lenguaje. Por eso va
  escrita, con su razón. En Java, la regla equivalente es que todo formateo de salida usa
  una configuración regional fija, porque si se quita, la salida cambia según el idioma de
  la máquina.
- **El estilo de las pruebas existentes.** Dónde viven, cómo se nombran, qué framework usan.
- **El alcance.** Una referencia a las reglas generales y la aclaración de que un cambio en un
  escenario no toca el otro.

La documentación de Visual Studio Code da el criterio general. Instrucciones cortas y
autocontenidas, cada una una afirmación simple. Concentrarse en las reglas que no son obvias
y no repetir convenciones que ya imponen los linters o los formateadores.

### El error de meter todo en las instrucciones generales

Es el error más frecuente en los repositorios reales, y tiene tres costos.

**Se paga en cada pedido.** La guía de ingeniería de contexto dice que las instrucciones de
repositorio se incluyen en todas las interacciones del chat, y advierte que más archivos de
contexto y conjuntos de instrucciones más grandes aumentan el uso de tokens y el consumo de
créditos. Una regla de .NET en las instrucciones generales se envía también en cada pedido
sobre Java, sobre documentación o sobre scripts.

**Diluye el foco.** La misma guía advierte contra la sobrecarga de contexto, que impide al
modelo concentrarse en lo importante. Una instrucción general de tres páginas compite con el
pedido.

**Abre contradicciones.** La documentación dice que las instrucciones que aplican se suman, y
que no hay que depender de un orden ni de una regla de precedencia. Si la general dice una
cosa y la de una ruta otra, el resultado no está garantizado.

La regla práctica es repartir. En la general, solo lo que vale para cualquier pedido en
cualquier parte del repositorio. En las de ruta, lo que es de un stack o de una zona. En
`AGENTS.md`, lo que cualquier herramienta tiene que saber, también fuera del editor.

### Repositorios corporativos

En un banco, un repositorio rara vez es un solo proyecto con un solo lenguaje. Hay módulos en
Java y en .NET, scripts de despliegue, documentación, configuración. Y hay estándares
corporativos que existen en algún documento de arquitectura.

El reparto anterior escala bien a ese escenario.

- **Una instrucción por stack o por zona,** con un patrón que apunte solo a esa zona. La de
  los servicios Java no se mezcla con la de los scripts.
- **Las reglas corporativas, resumidas.** No se copia el manual de arquitectura entero en una
  instrucción. Se extraen las cinco o seis reglas que un agente rompería sin saberlo, y se
  escriben como afirmaciones verificables. El manual sigue siendo la fuente para las
  personas.
- **`AGENTS.md` para lo transversal,** lo que también deben saber otras herramientas que el
  equipo use, por ejemplo la línea de comandos.
- **Una instrucción por estándar de arquitectura,** que remita al documento del estándar en
  lugar de copiarlo. Es el caso de la próxima sección.
- **Dueños.** Cada archivo de instrucciones tiene alguien que lo mantiene. La guía de
  ingeniería de contexto pide revisar y actualizar el contexto a medida que el código
  cambia, porque el contexto desactualizado produce sugerencias desactualizadas.

### El ejemplo corporativo: la arquitectura de referencia

Conviene proyectar `.github/instructions/arquitectura-bian.instructions.md` junto a
`docs/arquitectura/bian-mapeo.md`. Es el ejemplo del taller de una instrucción que no es de
un lenguaje sino de la organización.

BIAN es un marco de arquitectura para la banca, publicado por una asociación sin fines de
lucro, que divide lo que hace un banco en dominios de servicio. El mapeo asigna cada
componente de Pasarela Andina a su dominio: los comercios a Merchant Relations, las
transacciones a Card Transaction Capture, los contracargos a Card Case, y el cálculo, las
retenciones y la liquidación a Merchant Acquiring Facility.

La instrucción tiene tres decisiones que vale la pena señalar.

- **Su patrón apunta a los documentos, no al código.** `applyTo: 'docs/arquitectura/**,docs/proyecto/**'`.
  Se aplica cuando el agente escribe un documento de arquitectura. Sobre el código del
  escenario no cambia nada, y eso es deliberado: el vocabulario de arquitectura se pide
  donde se diseña, no en cada edición.
- **Remite, no copia.** No reproduce el estándar. Pide usar los nombres de los dominios tal
  como están en el mapeo y enlazar al mapeo. El documento lo mantiene el equipo de
  arquitectura; la instrucción solo lo vuelve visible para el agente.
- **Dice qué hacer cuando falta algo.** Si una responsabilidad no está en el mapeo, el agente
  lo dice y no inventa un dominio. Es la regla que más evita errores, porque un nombre de
  dominio inventado suena tan plausible como uno real.

En el banco de cada participante, el estándar puede ser otro. El patrón es el mismo: el
estándar vive en un documento, y una instrucción corta lo conecta con el agente.

### Cómo se escribe una regla que sirve

Tres preguntas antes de agregar una línea.

1. **¿Se puede comprobar?** «Las pruebas nuevas van en un archivo nuevo» se comprueba en el
   diff. «Escribe código limpio» no.
2. **¿Es una sola cosa?** Una regla que mezcla tres decisiones se aplica a medias.
3. **¿Sin ella el agente se equivocaría?** Si la respuesta es no, porque el linter ya la
   impone o porque es la práctica habitual del lenguaje, la regla sobra.

Cuando la razón no es obvia, se escribe la razón. «No reemplazar esta clase por la función
estándar, porque la salida tiene que coincidir con la otra implementación» se respeta más
que «no tocar esta clase».

### Instrucción o agente

El laboratorio 2.4 obliga a elegir uno de los dos, y la elección tiene un criterio simple.
Una instrucción agrega reglas a lo que el agente ya hace, según dónde trabaja. Un agente
cambia quién trabaja, con qué herramientas y con qué foco.

Si la necesidad es «cuando alguien toque estos archivos, que respete estas reglas», es una
instrucción. Se aplica sola, sin que nadie la elija, y no limita lo que el agente puede
hacer. Si la necesidad es «para esta tarea quiero alguien que solo lea, o que solo escriba
pruebas, o que entregue un formato fijo», es un agente. Hay que elegirlo, y sus herramientas
ponen un límite que una instrucción no puede poner.

Una señal de que se eligió mal es una instrucción que empieza con «cuando te pidan revisar» o
«si la tarea es documentar». Eso describe una tarea, no una zona del repositorio, y suele
ser un agente o una skill disfrazados. La señal contraria es un agente que nadie selecciona
porque sus reglas deberían valer siempre en una carpeta.

### El criterio del equipo, versionado

Lo que cambia con todo esto no es técnico. Hasta ahora, las reglas del equipo vivían en la
cabeza de los más antiguos, en un documento que nadie abre o en los comentarios de las
revisiones. Escritas como instrucciones, viven en el repositorio, se revisan en pull
request, tienen historial y se aplican igual para todos. Cuando alguien pregunta por qué el
agente hace algo de cierta manera, la respuesta está en un archivo, con su autor y su fecha.

## Cómo se conecta

- **Demostración.** La [demostración 2.3](../demos/demo-2-3-instrucciones-por-ruta.md) hace la
  misma pregunta sobre un archivo Java y sobre uno .NET, muestra qué instrucción entra en cada
  caso, muestra la instrucción BIAN y abre `AGENTS.md`.
- **Laboratorio.** En el [2.4](../../../labs/cap2/lab-2-4-agente-o-instruccion/README.md),
  quien elige construir una instrucción escribe su patrón `applyTo` y la prueba pidiendo al
  agente que cree un archivo que coincida. La tarea E usa el mapeo BIAN para construir un
  agente que revisa si un cambio cruza límites de responsabilidad.
- **Hilo del taller.** El criterio del equipo deja de depender de quién escribe el pedido.
  Queda en el repositorio, versionado y revisable, y se verifica como cualquier otro cambio.

## Preguntas probables

**«¿Puedo tener una instrucción para las pruebas y otra para el código de producción?»**
Sí. El patrón `applyTo` puede apuntar solo a los archivos de prueba. Como las instrucciones
se suman, conviene que no se contradigan con la del stack.

**«¿Por qué mi instrucción no aparece en las referencias?»**
Lo más probable es que el agente no haya creado ni modificado un archivo que coincida con el
patrón, o que el patrón no coincida con la ruta real. El patrón es relativo a la raíz del
espacio de trabajo.

**«¿Cuánto cuesta tener muchas instrucciones?»**
Las de repositorio entran en todos los pedidos y las de ruta solo cuando aplican. Todas
suman tokens, y los tokens se convierten en créditos. Por eso conviene que las generales
sean cortas.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Campos `name`, `description` y `applyTo`, patrón relativo a la raíz, adjunto al crear o modificar un archivo que coincide, carga por descripción, instrucciones aditivas sin precedencia garantizada, instrucciones cortas y no obvias, no repetir lo que imponen los linters | https://code.visualstudio.com/docs/agent-customization/custom-instructions | 2 de octubre de 2026 |
| Instrucciones de repositorio incluidas en todas las interacciones, más instrucciones aumentan tokens y créditos, sobrecarga de contexto, contexto desactualizado | https://code.visualstudio.com/docs/agents/guides/context-engineering-guide | 2 de octubre de 2026 |
| BIAN como marco común para la interoperabilidad bancaria | https://bian.org/about-bian/ | 3 de octubre de 2026 |
| Nombres de los dominios de servicio, versión 14.0.0 | https://github.com/bian-official/public | 3 de octubre de 2026 |
| Consumo de créditos según tokens | https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing | 2 de octubre de 2026 |
