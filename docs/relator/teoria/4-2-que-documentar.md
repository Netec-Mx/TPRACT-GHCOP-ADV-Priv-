# 4.2 Documentación de proyectos, endpoints, pruebas, decisiones técnicas y troubleshooting

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 4, sesión 4 |
| Duración | 20 minutos de exposición |
| Demostración | No tiene |
| Artefactos que se proyectan | `escenario/README.md`, `mcp/README.md`, `.github/instructions/dotnet.instructions.md`, `docs/arquitectura/decisiones/` |

## La idea en una frase

Cada tipo de documento responde una pregunta distinta, y el agente puede escribir la parte
que está en el código, pero la parte que está en las personas hay que dársela.

## Contenido

### Cinco documentos, cinco preguntas

El temario nombra cinco tipos de documentación. Conviene presentarlos como cinco preguntas
que alguien del equipo se hace, porque así se ve qué parte puede escribir el agente y qué
parte no.

| Documento | Pregunta que responde | Qué puede aportar el agente | Qué hay que darle |
|---|---|---|---|
| Proyecto | ¿Qué es esto y cómo lo pongo a andar? | Estructura, comandos, dependencias | Para qué existe, quién lo usa |
| Endpoints | ¿Cómo lo llamo y qué me devuelve? | Parámetros, tipos, respuestas | Reglas de uso, límites acordados |
| Pruebas | ¿Cómo sé que sigue funcionando? | Qué clases hay y cómo se corren | Qué se considera suficiente |
| Decisiones | ¿Por qué está hecho así? | La decisión, leída del código | El contexto y las alternativas |
| Troubleshooting | ¿Qué hago cuando falla? | Mensajes de error y su origen | Lo que pasó antes en producción |

Para cada uno hay un ejemplo en el repositorio del taller.

### Proyecto

**Qué contiene.** Qué hace el sistema, cómo se compila, cómo se ejecuta y dónde están los
datos. Lo justo para que alguien nuevo lo haga andar sin preguntar.

**Ejemplo.** `escenario/README.md`. Describe el dominio de Pasarela Andina, sus entidades,
sus reglas de negocio, cómo se ejecuta cada implementación y cómo se comprueba que las dos
coinciden. Es también la única fuente de verdad funcional del taller.

**Lo que el agente hace bien aquí.** Leer el archivo de construcción y listar los comandos.
**Lo que no.** Escribir las reglas de negocio. Si las deduce del código, va a escribir lo que
el código hace, que no siempre es lo que debería hacer.

### Endpoints

**Qué contiene.** Para cada punto de entrada, qué recibe, qué devuelve, qué errores puede dar
y un ejemplo de uso.

**Ejemplo.** El escenario no expone una API HTTP. Es un proceso que lee archivos y produce un
reporte. Pero el servidor MCP del taller sí tiene una interfaz, y `mcp/README.md` la
documenta como se documentaría un conjunto de endpoints. Una tabla con cada herramienta, qué
devuelve y qué parámetros acepta, y una sección de qué datos lee.

**Lo que el agente hace bien aquí.** Leer las firmas y los esquemas de validación y armar la
tabla. **Lo que no.** Saber qué uso es aceptable, qué límites se acordaron con quien
consume la interfaz o qué parámetros se van a retirar.

### Pruebas

**Qué contiene.** Dónde están, cómo se corren, qué framework usan y qué cubren. Y, tan
importante como eso, qué no cubren.

**Ejemplo.** Las instrucciones por ruta de Java y de .NET dicen dónde viven las pruebas, cómo
se nombran y con qué comando se ejecutan. Es documentación de pruebas que además el agente
aplica cuando escribe una.

**Lo que el agente hace bien aquí.** Inventariar las clases de prueba y describir qué
verifica cada una. **Lo que no.** Decidir si esa cobertura alcanza. Un documento de pruebas
generado tiende a describir lo que existe con un tono que suena a suficiente. La pregunta de
si alcanza la responde el equipo, y el capítulo 5 la trabaja.

### Decisiones técnicas

**Qué contiene.** Una decisión de arquitectura por archivo: contexto, alternativas
consideradas, decisión, consecuencias buenas y malas, y cómo se verifica. El estándar TOGAF
describe un registro de decisiones dentro del repositorio de arquitectura, pero no fija un
formato por decisión. El de `docs/arquitectura/decisiones/` es el registro de decisiones de
arquitectura de Michael Nygard, con agregados del formato MADR. Conviene decirlo así: es un
complemento de TOGAF, no parte de TOGAF.

**Ejemplo.** El repositorio trae tres, sobre decisiones reales del taller. Implementar el
escenario en Java y en .NET con salida idéntica. Usar un servidor MCP local, de solo lectura
y sin red. Proteger los datos con un hook. Proyecte la del hook: sus alternativas incluyen
confiar solo en las instrucciones, y sus consecuencias admiten que el hook es un filtro por
patrón. Una decisión que solo lista ventajas no es un registro, es una justificación.

La skill `pasarela-registrar-decision` redacta una nueva con la plantilla.

**Lo que el agente hace bien aquí.** Describir la decisión, que está en el código, y
proponer alternativas. **Lo que no.** El contexto, si nadie lo escribió. El agente propone
uno plausible, y plausible no es lo mismo que cierto.

### Troubleshooting

**Qué contiene.** Síntoma, causa probable, cómo confirmarla y qué hacer. Ordenado por
síntoma, porque quien lo lee tiene el síntoma y no la causa.

**Ejemplo.** «La salida de Java y la de .NET no coinciden.» Cómo confirmarlo: ejecutar
`bash scripts/comparar-escenarios.sh`, que termina en cero si son idénticas y muestra las
diferencias si no. Causas posibles: un cambio en una sola de las dos implementaciones, o un
formateo que no pasa por la configuración regional fija y depende del idioma de la máquina.

**Lo que el agente hace bien aquí.** Rastrear un mensaje de error hasta la línea que lo
produce. **Lo que no.** Saber qué falló la última vez y cómo se resolvió. Esa memoria es del
equipo, y un buen documento de troubleshooting es, sobre todo, esa memoria escrita.

### Cómo se pide cada uno

Un patrón para los cinco, en la línea del capítulo 1. En el pedido va el tipo de documento,
la audiencia, las fuentes a leer y la regla de citar el archivo que respalda cada
afirmación. Lo que el agente no puede saber se le da, o se le pide dejar el hueco marcado.

Esa última instrucción es la más útil del subtema. Un documento con un hueco marcado como
«contexto pendiente» es honesto. Uno con un contexto inventado parece terminado.

## Cómo se conecta

- **Demostración.** No tiene. La del 4.1 ya mostró cómo se verifica un documento.
- **Laboratorio.** En el [4.4](../../../labs/cap4/lab-4-4-documentacion/README.md), el paso 1
  documenta reglas de cálculo y el paso 2 documenta decisiones con contexto, decisión y
  consecuencias verificables.
- **Hilo del taller.** Cada documento tiene una parte que se verifica contra el código y otra
  que se verifica con el equipo. El agente acelera la primera.

## Preguntas probables

**«¿Dónde guardo los registros de decisión?»**
En el repositorio, como `docs/arquitectura/decisiones/`, para revisarlos en el mismo pull
request que el código. El 4.3 trata el traslado a una wiki.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Copilot puede equivocarse y lo que sugiere se valida siempre | https://docs.github.com/en/copilot/get-started/best-practices | 2 de octubre de 2026 |
| Registro de decisiones en el repositorio de arquitectura de TOGAF | https://pubs.opengroup.org/architecture/togaf9-doc/arch/chap37.html | 3 de octubre de 2026 |
| Formato de registro de decisiones de Nygard | https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions | 3 de octubre de 2026 |
| Alternativas consideradas y verificación, MADR 4.0.0 | https://adr.github.io/madr/ | 3 de octubre de 2026 |
| Dar en el pedido el contexto y los detalles que el modelo no tiene | https://docs.github.com/en/copilot/concepts/prompting/prompt-engineering | 2 de octubre de 2026 |
