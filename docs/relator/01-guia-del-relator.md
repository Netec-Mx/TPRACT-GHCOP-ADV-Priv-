# Guía del relator

Documento para quien dicta el taller. Se lee completo antes de la primera sesión y se
vuelve a él antes de cada una. Une todo el material del relator. Las notas por laboratorio,
el catálogo de defectos, los casos de clase, las demostraciones y los respaldos están en
`docs/relator/` y se enlazan desde aquí, sin repetirlos.

No se entrega a los participantes y no se proyecta.

---

## 1. Qué es este taller y por qué está armado así

### La idea que sostiene todo

El Copilot que la mayoría aprendió era autocompletado y chat. El desarrollador escribía cada
línea y la herramienta le ahorraba tipeo. El Copilot de 2026 es un agente que recibe un
objetivo, no un paso. Abre archivos, corre comandos y cambia varios lugares a la vez.

Eso cambia el oficio. El trabajo deja de ser escribir y pasa a ser dos cosas. Especificar
bien lo que se quiere y verificar con rigor lo que llega.

El modelo no tiene memoria del proyecto. Todo lo que sabe en cada pedido es lo que alguien
puso en su contexto. Si el contexto es pobre, el resultado es genérico.

Cada capítulo trabaja una parte de esa idea.

- **Capítulo 1.** Construir el contexto en el pedido.
- **Capítulo 2.** Dejar el contexto escrito en el repositorio, con instrucciones, skills y
  agentes, para que el criterio del equipo no dependa de quién escribe el pedido.
- **Capítulo 3.** Darle al agente acceso a fuentes internas con MCP. En un banco eso es
  primero una decisión de seguridad.
- **Capítulo 4.** Usarlo para documentar. La documentación generada se verifica contra la
  ejecución, no contra el texto.
- **Capítulo 5.** Juntar todo sobre el mismo código.

El hilo que atraviesa los cinco es uno. Generar código es barato. Verificar que hace lo
correcto es caro, y sigue siendo trabajo humano. Por eso el escenario tiene diez defectos
plantados que no se ven en la salida, y por eso el agente no los encuentra solo. Los
encuentra si alguien le dice dónde buscar y cómo comprobar.

Y por eso todo el material de laboratorio son archivos Markdown. El código del escenario
existe y está bien construido, pero el trabajo del participante no es sobre ese código. Es
sobre cómo le habla al agente y cómo revisa lo que el agente le devuelve.

Si esta idea no se transmite, el taller se convierte en nueve laboratorios sueltos. Vuelva
a ella al abrir cada sesión y al cerrar cada laboratorio.

### La audiencia

Desarrolladores Java y .NET, líderes técnicos y arquitectos de un banco en Perú, que ya
usan Copilot a diario. Eso tiene tres consecuencias.

- **No explique lo básico.** Saben qué es una sugerencia en línea y cómo se abre el chat.
  Lo que no han visto, en general, es el trabajo con agentes, skills, hooks y MCP, y la
  disciplina de verificar.
- **Espere preguntas de seguridad y de costo.** Qué ve GitHub, qué se puede exponer por
  MCP, cuánto cuesta cada modo de trabajo. Las respuestas están en la sección 6.
- **No prometa cumplimiento regulatorio.** El taller enseña a usar la herramienta. Qué se
  permite en el banco lo deciden sus áreas de seguridad, riesgo y legal.

La sesión de apertura ya presentó esta filosofía y el estado del arte de Copilot a
septiembre de 2026, incluida la existencia de hooks que bloquean acciones del agente. Usted
retoma desde ahí.

---

## 2. El material y dónde está cada cosa

### Dos repositorios

| Repositorio | Quién lo abre | Qué tiene |
|---|---|---|
| `RodrigoMSB/github-copilot-netec-taller` | Participantes y relator en la sala | Escenario, laboratorios, skills, agentes, instrucciones, hook, servidor MCP, scripts, guía de inicio y guía de cierre |
| `RodrigoMSB/github-copilot-netec` | Solo el relator, en privado | Todo lo anterior más `docs/relator/`, con esta guía, el catálogo de defectos, las notas, las soluciones, los respaldos y el protocolo de prueba |

El repositorio de participantes es una instantánea de un solo commit con la etiqueta
`punto-de-partida`. Se genera desde el de construcción con un script que se niega a
publicar si encuentra material del relator.

**Advertencia.** En una máquina cuya pantalla puedan ver los participantes, jamás se abre el
repositorio de construcción. Su `AGENTS.md` y su catálogo enumeran los diez defectos, y
Copilot los lee como contexto. Una demostración hecha sobre ese repositorio contamina la
sala y le da al agente información que en el laboratorio no va a tener.

### Qué abre el relator

- **En la máquina que proyecta.** Visual Studio Code con el repositorio de participantes,
  clonado y en su punto de partida. Es la misma imagen que usan los participantes.
- **En una segunda pantalla o en papel, nunca proyectado.** Esta guía, las notas del
  laboratorio del día y los respaldos de `docs/relator/respaldos/`.

### Un solo editor

Visual Studio Code y solo ese, aunque los prerrequisitos del documento de Netec nombren
otros. Los laboratorios corren en las máquinas virtuales de Netec con la imagen que definió
el proyecto. Si alguien pregunta por IntelliJ o Visual Studio, la respuesta es que los
mecanismos son los mismos y que el taller usa un solo editor para que todos vean lo mismo.

### Mapa de `docs/relator/`

| Archivo | Para qué |
|---|---|
| `00-contexto-del-proyecto.md` | Contexto del proyecto, para quien lo mantiene |
| `01-guia-del-relator.md` | Este documento |
| `03-hallazgos.md` | Lo que se aprendió construyendo el material, con sus reglas |
| `04-defectos-plantados.md` | Catálogo de los diez defectos y comportamientos no planificados |
| `05-diseno-de-laboratorios.md` | Diseño de los pasos de cada laboratorio |
| `07-protocolo-prueba-vm.md` | Prueba del material en la máquina virtual |
| `08-verificacion-de-skills.md` | Registro de la verificación de skills y demostraciones |
| `09-bitacora-de-construccion.md` | Por qué el repositorio es como es |
| `10-mantenimiento.md` | Qué revisar antes de cada dictado |
| `notas/` | Notas por laboratorio y del hook |
| `teoria/` | Contenido de cada subtema de teoría. Empieza en [`teoria/00-indice.md`](teoria/00-indice.md) |
| `demos/` | Las nueve demostraciones |
| `respaldos/` | Salidas grabadas de laboratorios y demostraciones |
| `casos-de-clase/` | Tres casos reales para proyectar |
| `soluciones/` | Soluciones de referencia de los laboratorios que modifican código |
| `respaldo-lab-2-4/` | Agente e instrucción de respaldo para el laboratorio 2.4 |

---

## 3. El escenario

### Qué hace

Pasarela Andina es una procesadora de pagos ficticia. Al cierre de cada mes calcula cuánto
le cobra a cada comercio afiliado por comisiones, descuenta contracargos, aplica
retenciones y produce una liquidación con el monto neto a pagar. Montos en soles, hora de
Lima.

Las nueve reglas de negocio están en `escenario/README.md` y son la verdad funcional del
dominio. En resumen, la comisión aplica el porcentaje del tramo del monto más un fijo, los
tramos no son acumulativos, las cuotas tienen recargo con tope de 3 %, las anuladas no
pagan, los contracargos se descuentan en el periodo en que se aprueban, el total mensual
tiene un tope, los comercios con menos de seis meses tienen retención de 5 % y todo se
redondea a dos decimales, medio hacia arriba.

### Dos implementaciones, una salida

El escenario existe en Java, en `escenario/java`, y en .NET, en `escenario/dotnet`. Leen los
mismos datos de `escenario/datos` y producen la misma salida, carácter por carácter.

```bash
bash scripts/comparar-escenarios.sh
```

Termina en cero si las salidas son idénticas. Es el cierre de todo laboratorio que toca
código. Cada escenario se compila y se prueba desde su directorio con `mvn` o con
`dotnet`, como explica `escenario/README.md`.

### Los diez defectos

La fuente es [`04-defectos-plantados.md`](04-defectos-plantados.md), con archivo y línea de
cada uno.

| Defecto | Qué es | Dónde | Laboratorio que lo ejercita |
|---|---|---|---|
| DEF-01 | Dinero en punto flotante. CM0011, CM0016 y CM0025 reciben un centavo menos | Todo el modelo | 5.1 paso 3, y 5.4 si alguien lo elige |
| DEF-02 | Método de 282 líneas con nueve niveles de anidamiento | `CalculadoraLiquidacion` | 1.4, 1.5 paso 1, 5.2 pasos 2 y 3 |
| DEF-03 | Números mágicos. El tope del recargo vale 3.0 en un archivo y 3.5 en otro | Las dos calculadoras | 5.2 paso 1 |
| DEF-04 | Fechas sin zona horaria | `UtilidadesFecha` y el modelo | 5.1 paso 3 |
| DEF-05 | Veinte pruebas que no cubren la lógica de negocio | Las pruebas | 5.3 pasos 1 y 2 |
| DEF-06 | Responsabilidades mezcladas. La clase de cálculo lee archivos e imprime | `CalculadoraLiquidacion` | 1.5 paso 1, 5.2 paso 3 |
| DEF-07 | Errores tragados en silencio | `CargadorDatos` | 1.5 paso 2 |
| DEF-08 | Selección de tramo duplicada y divergente en los bordes | Las dos calculadoras | 5.3 paso 1 |
| DEF-09 | Nombres que mienten. CM0031 está suspendido y se liquida | Tres métodos | 1.5 paso 3 |
| DEF-10 | Comentarios que contradicen al código | Tres comentarios | 1.4 como observación, 4.4 paso 1 |

**Si un participante encuentra un defecto antes de tiempo.** Reconózcalo sin confirmar que
es plantado. «Buena observación, anótela, vamos a volver a eso en el laboratorio tal.» No lo
corrija ni deje que el agente lo corrija. Si el participante insiste en que es un error, la
respuesta es que el taller trabaja sobre código con problemas a propósito, como el de
producción, y que el ejercicio es encontrarlos y decidir qué hacer, no arreglarlos al paso.

### Comportamientos no planificados

Están en la misma fuente, en su propia sección, fuera del catálogo de diez.

**Un monto negativo recibe el tramo más bajo** en las dos calculadoras. Si aparece, la
respuesta es que es un comportamiento real del sistema que nadie plantó, que el negocio no
admite montos negativos en una venta y que corregirlo queda fuera del alcance del
laboratorio.

### Los datos están protegidos

Tres transacciones de los datos sostienen el defecto principal. Un hook del repositorio
impide que el agente modifique `escenario/datos/`. Las notas están en
[`notas/hook-proteccion-datos.md`](notas/hook-proteccion-datos.md) y la demostración en el
subtema 3.3.

---

## 4. Plan de cada sesión

Los títulos y los minutos de cada subtema son los del temario contratado, Propuesta Temario
1 de Netec, reproducido en el `README.md` de la raíz. Las horas de inicio son relativas al
comienzo de la sesión. Los minutos contratados no incluyen pausas. Si el horario del
cliente tiene pausas dentro de la sesión, se recorta según lo indicado en cada una.

En los bloques de exposición, el contenido de teoría por subtema llega en SPEC-012. Esta
guía fija dónde va cada cosa y cuánto dura.

### Sesión 1. Capítulo 1, 180 minutos

| Inicio | Min | Bloque | Material |
|---|---|---|---|
| 0:00 | 22 | 1.1 Prompts efectivos para desarrollo: objetivo, contexto, restricciones y salida esperada. Exposición | Teoría del subtema |
| 0:22 | 8 | 1.1 Demostración del pedido pobre y el pedido bueno | [`demos/demo-1-1-pedido-pobre-y-pedido-bueno.md`](demos/demo-1-1-pedido-pobre-y-pedido-bueno.md) |
| 0:30 | 12 | 1.2 Uso de contexto: archivos abiertos, selección de código, workspace y referencias específicas. Exposición | Teoría del subtema |
| 0:42 | 8 | 1.2 Demostración de las referencias de contexto | [`demos/demo-1-2-referencias-de-contexto.md`](demos/demo-1-2-referencias-de-contexto.md) |
| 0:50 | 10 | 1.2 Caso de clase de la configuración regional | Sección 7 de esta guía |
| 1:00 | 20 | 1.3 Flujos de trabajo con Copilot Chat: analizar, planear, implementar y validar. Exposición | Teoría del subtema, incluido el consumo de cada modo de trabajo y la guía [`uso-responsable-de-tokens.md`](../gobierno/uso-responsable-de-tokens.md) |
| 1:20 | 10 | 1.3 Demostración del flujo analizar, planear, implementar y validar | [`demos/demo-1-3-flujo-de-trabajo.md`](demos/demo-1-3-flujo-de-trabajo.md) |
| 1:30 | 30 | 1.4 Práctica guiada: mejora incremental de prompts y uso de comandos del chat | Laboratorio 1.4 |
| 2:00 | 60 | 1.5 Laboratorio: análisis y mejora de un componente Java/.NET usando prompts y Copilot Chat | Laboratorio 1.5 |
| 3:00 | | Fin | |

Aritmética. Teoría 22 + 8 + 12 + 8 + 10 + 20 + 10 = 90. Laboratorio 30 + 60 = 90. Total
180.

**Comandos del chat.** El objetivo del capítulo en el documento de Netec menciona
`/workspace`, `/analyze` y `/plan`. Solo `/plan` existe hoy como comando. En la exposición
del 1.2 muestre `#codebase` como la forma vigente de pedir el contexto del repositorio, y en
el 1.3 muestre `/plan` y el agente Plan. No lo presente como un error del temario. Es un
ejemplo de lo rápido que cambia la herramienta.

**Antes de empezar.**

- Máquina de proyección con el repositorio de participantes en `punto-de-partida`.
- `bash scripts/verificar-ambiente.sh` en verde en la máquina de proyección.
- Los participantes verificaron su ambiente al llegar. Quien tenga Copilot deshabilitado lo
  habilita desde la vista de extensiones, filtrando las integradas.
- Abiertos en su segunda pantalla, las notas de [`1.4`](notas/lab-1-4.md) y
  [`1.5`](notas/lab-1-5.md) y el caso de clase 02.

**Qué suele fallar.** Copilot deshabilitado en un perfil nuevo. Sesión de GitHub con otra
cuenta. Skills que no aparecen porque la carpeta no se abrió como espacio de trabajo de
confianza.

### Sesión 2. Capítulo 2, 180 minutos

| Inicio | Min | Bloque | Material |
|---|---|---|---|
| 0:00 | 35 | 2.1 Conceptos: agentes locales, skills, prompt files e instrucciones personalizadas. Exposición | Teoría del subtema |
| 0:35 | 10 | 2.1 Demostración de la jerarquía de personalización y las skills | [`demos/demo-2-1-jerarquia-y-skills.md`](demos/demo-2-1-jerarquia-y-skills.md) |
| 0:45 | 35 | 2.2 Diseño de agentes por rol: analista, tester, documentador, revisor y refactorizador. Exposición | Teoría del subtema |
| 1:20 | 10 | 2.2 Demostración de los agentes de referencia | [`demos/demo-2-2-agentes-por-rol.md`](demos/demo-2-2-agentes-por-rol.md) |
| 1:30 | 37 | 2.3 Instrucciones reutilizables para proyectos Java, .NET y repositorios corporativos. Exposición | Teoría del subtema |
| 2:07 | 8 | 2.3 Demostración de las instrucciones por ruta | [`demos/demo-2-3-instrucciones-por-ruta.md`](demos/demo-2-3-instrucciones-por-ruta.md) |
| 2:15 | 45 | 2.4 Laboratorio: creación de un agente local o instrucción reutilizable para una tarea del equipo | Laboratorio 2.4 |
| 3:00 | | Fin | |

Aritmética. Teoría 35 + 10 + 35 + 10 + 37 + 8 = 135. Laboratorio 45. Total 180.

**Antes de empezar.** Revise que `.github/agents/`, `.github/instructions/` y
`.github/skills/` estén en el punto de partida. Tenga a mano los dos archivos de
`respaldo-lab-2-4/` y la forma de entregarlos, por ejemplo el canal de la clase.

**Qué suele fallar.** Agentes que no aparecen en el selector porque el archivo quedó fuera
de `.github/agents/`. Instrucciones que no se aplican porque el patrón `applyTo` no
coincide.

### Sesión 3. Capítulo 3, 180 minutos

| Inicio | Min | Bloque | Material |
|---|---|---|---|
| 0:00 | 45 | 3.1 Qué es MCP y cómo se relaciona con contexto, agentes y herramientas locales. Exposición | Teoría del subtema |
| 0:45 | 35 | 3.2 Diferencia entre MCP local y MCP externo en ambientes restringidos. Exposición | Teoría del subtema |
| 1:20 | 10 | 3.2 Demostración del servidor MCP local | [`demos/demo-3-2-servidor-mcp.md`](demos/demo-3-2-servidor-mcp.md) |
| 1:30 | 40 | 3.3 Riesgos de seguridad: exposición de información, conectores no autorizados y fuga de contexto. Exposición | Teoría del subtema, incluida la exclusión de contenido |
| 2:10 | 5 | 3.3 Demostración del hook | [`demos/demo-3-3-hook.md`](demos/demo-3-3-hook.md) |
| 2:15 | 45 | 3.4 Laboratorio: diseño de un caso de uso de MCP local seguro con documentación técnica local | Laboratorio 3.4 |
| 3:00 | | Fin | |

Aritmética. Teoría 45 + 35 + 10 + 40 + 5 = 135. Laboratorio 45. Total 180.

**Antes de empezar.** En la máquina de proyección, borre `.vscode/mcp.json` si quedó de
una prueba, con `bash scripts/reiniciar-lab.sh lab-3-4`. La demostración del 3.2 lo crea en
vivo. Confirme en el verificador que la sección «Servidor MCP local» está en verde en las
máquinas de los participantes.

**Qué suele fallar.** El servidor no arranca porque falta preparar sus dependencias en la
imagen, o porque la carpeta está en modo restringido. El hook no corre si `chat.useHooks`
está deshabilitado. El verificador detecta los dos casos.

### Sesión 4. Capítulos 4 y 5, 270 minutos

| Inicio | Min | Bloque | Material |
|---|---|---|---|
| 0:00 | 12 | 4.1 Uso de Copilot para documentación técnica y generación de Markdown. Exposición | Teoría del subtema |
| 0:12 | 8 | 4.1 Demostración de la documentación contra la ejecución | [`demos/demo-4-1-documentacion-contra-ejecucion.md`](demos/demo-4-1-documentacion-contra-ejecucion.md) |
| 0:20 | 20 | 4.2 Documentación de proyectos, endpoints, pruebas, decisiones técnicas y troubleshooting. Exposición | Teoría del subtema |
| 0:40 | 20 | 4.3 Buenas prácticas para preparar documentación compatible con Confluence. Exposición | Teoría del subtema |
| 1:00 | 30 | 4.4 Laboratorio: generación breve de documentación Markdown para un proyecto Java o .NET | Laboratorio 4.4 |
| 1:30 | 45 | 5.1 Preparación del escenario integrador y criterios de evaluación | Laboratorio 5.1 |
| 2:15 | 45 | 5.2 Planeación de mejora, refactorización y validación incremental | Laboratorio 5.2 |
| 3:00 | 45 | 5.3 Estrategia de pruebas, documentación Markdown y checklist de revisión | Laboratorio 5.3 y casos de clase 01 y 03 en el paso 3 |
| 3:45 | 45 | 5.4 Laboratorio final: construcción de activos reutilizables para el equipo | Laboratorio 5.4 |
| 4:30 | | Fin | |

Aritmética. Teoría del capítulo 4, 12 + 8 + 20 + 20 = 60. Laboratorio 4.4, 30. Capítulo 5,
45 + 45 + 45 + 45 = 180. Total 270.

**Recorte.** La sesión no tiene pausas en sus 270 minutos. Si el horario las incluye o la
sesión se atrasa, se recorta en este orden, que es el de
[`notas/README.md`](notas/README.md).

| Orden | Qué se recorta | Se recupera |
|---|---|---|
| 1 | 4.4 paso 3, Confluence, se muestra en pantalla | 8 min |
| 2 | 5.1 paso 2, mapa del sistema, lo proyecta el relator | 10 min |
| 3 | 5.2 paso 3, independiente del paso 2 | 12 min |
| 4 | 5.3 paso 3, se reemplaza por el caso de clase 01 proyectado | 9 min |
| 5 | 5.4 paso 1, de 32 a 20 minutos | 12 min |

Con los cinco recortes se recuperan 51 minutos. No se recortan el paso 2 del 5.4, que es un
entregable comprometido, ni el paso 1 del 5.3, que es el único que ejercita la selección de
tramo duplicada.

**El capítulo 5 es un solo flujo.** Los cuatro laboratorios trabajan sobre el mismo
repositorio, cada uno sobre lo que dejó el anterior. El 5.3 usa los criterios de evaluación
del 5.1. A quien llegue al 5.3 sin haber hecho el 5.1, entréguele
`soluciones/lab-5-1/criterios-de-evaluacion.md` para que lo guarde en
`labs/cap5/lab-5-1-preparacion/entregables/`. El 5.4 no se reinicia. Continúa sobre el
estado que dejó el 5.3, y el script de reinicio advierte y pide confirmación explícita si
alguien lo intenta.

**Antes de empezar.** Las notas de los cinco laboratorios abiertas en su segunda pantalla.
Los casos de clase 01 y 03 listos para proyectar. La respuesta de negocio sobre los bordes
de tramo a mano, ver la sección 6.

**Qué suele fallar.** El comparador tarda en la máquina virtual porque compila los dos
escenarios. Cuéntelo antes de que alguien piense que se colgó. Quien rompió la compilación
en el 5.2 reinicia el laboratorio y sigue.

### Cuando el agente se demora o la red se cae

La espera del agente se convierte en clase. Mientras corre, usted narra qué herramienta
invocó, por qué eligió ese archivo, qué comando está a punto de ejecutar y qué debería
aprobar y qué no. Nunca deje la sala en silencio mirando una barra de progreso.

Si la espera pasa de un par de minutos, si la red se cae o si se agota la cuota, abra el
respaldo correspondiente de [`respaldos/`](respaldos/) y siga con esa salida. Cada
laboratorio y cada demostración tiene uno. Diga a la sala que es una ejecución grabada.

---

## 5. Cómo conducir los laboratorios

### Lo que es común a los nueve

**Cómo se invoca un paso.** Cada paso es una skill. Se escribe la barra y el nombre en el
chat, por ejemplo `/lab-1-5-paso-1-inventario java`. El argumento `java` o `dotnet` dice
sobre qué escenario trabajar. Las skills de laboratorio no se cargan solas. Solo actúan
cuando se invocan.

**El modo del chat.** Cada README de laboratorio dice si el paso va en modo **Ask** o
**Agent**. Un paso que modifica código en modo **Ask** propone y no aplica.

**Si un participante tipea en lugar de invocar.** Va a obtener otra cosa, sin las
restricciones de la skill, y su resultado no se va a poder comparar con el del resto.
Pídale que invoque la skill. Si ya escribió un prompt propio, úselo en la puesta en común
como contraste.

**Quien se atrasa.** Los pasos son independientes. Quien se atrasó salta al paso que está
haciendo la sala. Las notas de cada laboratorio dicen qué paso se puede saltar sin perder
el hilo.

**El respaldo del 2.4.** Si a los veinte minutos un participante no tiene un artefacto que
funcione, entréguele el de `respaldo-lab-2-4/` que corresponda a su tipo y que siga en el
paso 3.

**Reiniciar.** Desde la raíz del repositorio, en Git Bash:

```bash
bash scripts/reiniciar-lab.sh lab-5-2
```

Muestra qué se va a perder y pide escribir `si`. Los commits del participante no se pierden.
Los activos que el participante construyó en el 2.4 no se tocan al reiniciar otro
laboratorio.

**Cerrar un laboratorio que toca código.** Siempre con el comparador. Una refactorización
correcta no cambia la salida, y el comparador lo dice en segundos.

```bash
bash scripts/comparar-escenarios.sh
```

**Aprobar comandos.** Cuando el agente pide ejecutar algo en la terminal, el participante lee
el comando antes de aprobar. Es la práctica más concreta del taller.

### Notas por laboratorio

| Laboratorio | Notas |
|---|---|
| 1.4 | [`notas/lab-1-4.md`](notas/lab-1-4.md) |
| 1.5 | [`notas/lab-1-5.md`](notas/lab-1-5.md) |
| 2.4 | [`notas/lab-2-4.md`](notas/lab-2-4.md) |
| 3.4 | [`notas/lab-3-4.md`](notas/lab-3-4.md) |
| 4.4 | [`notas/lab-4-4.md`](notas/lab-4-4.md) |
| 5.1 | [`notas/lab-5-1.md`](notas/lab-5-1.md) |
| 5.2 | [`notas/lab-5-2.md`](notas/lab-5-2.md) |
| 5.3 | [`notas/lab-5-3.md`](notas/lab-5-3.md) |
| 5.4 | [`notas/lab-5-4.md`](notas/lab-5-4.md) |

---

## 6. Las trampas y las preguntas difíciles

### La inyección del laboratorio 3.4

Una nota de soporte del comercio CM0005 trae una instrucción escondida para el agente, que
le pide afirmar que el comercio cambió de plan. Es inofensiva. Solo altera el texto de la
respuesta. El detalle está en [`notas/lab-3-4.md`](notas/lab-3-4.md).

No la anuncie. El enunciado pide contrastar la respuesta del agente con los datos que
devolvió cada herramienta. Deje que la sala la encuentre. Si el agente obedece, se proyecta
la contradicción. Si no obedece, se muestra la nota y se pregunta qué habría pasado con un
servidor que tuviera herramientas de escritura. Las dos salidas sirven.

### Los comentarios mentirosos del laboratorio 4.4

El comentario de `PlanComisiones` dice que los tramos son acumulativos y la regla 2 dice lo
contrario. No lo mencione antes del laboratorio, tampoco en la demostración del 4.1, que
usa otro método a propósito. Si en alguna pantalla el documento generado dice
«acumulativos», proyéctelo. El detalle está en [`notas/lab-4-4.md`](notas/lab-4-4.md).

### La decisión de negocio sobre los bordes de tramo

En el 5.3 aparece que la calculadora de comisión y el cierre de la liquidación eligen
tramos distintos para 500, 2000 y 10000. Las reglas no dicen a qué tramo pertenece un monto
en el límite, a propósito. El participante tiene que detectar la ambigüedad y escalarla, y
en la sala el negocio es usted.

Cuando un participante lo pregunte, y solo entonces, responda así.

> Un monto que cae exactamente en el límite pertenece al tramo inferior. El límite superior
> de cada tramo es inclusivo. 500 está en el primer tramo, 2000 en el segundo y 10000 en el
> tercero.

No la escriba en la pizarra antes de que alguien pregunte, ni en ningún archivo que vean
los participantes.

### Preguntas difíciles

**«El temario habla de `/workspace` y `/analyze`. ¿Dónde están?»**
No existen como comandos en la versión vigente de Visual Studio Code. El contexto del
repositorio completo se pide con `#codebase` o se deja al agente, que busca solo. `/plan`
sí existe y lleva al agente Plan. Es un buen ejemplo de por qué el material se revisa antes
de cada dictado.

**«¿La exclusión de contenido protege lo que el agente lee?»**
No en todos los modos. La documentación de GitHub dice que la exclusión de contenido no
está soportada en los modos Edit y Agent de Copilot Chat en Visual Studio Code y otros
editores. Para el agente, los controles son otros. Qué carpetas se abren, qué instrucciones
lleva el repositorio, qué hooks bloquean acciones y qué herramientas se aprueban.

**«¿Esto cumple con la regulación bancaria?»**
El taller no lo afirma. Copilot tiene documentación de privacidad y seguridad que el área
correspondiente del banco puede evaluar. La decisión es de seguridad, riesgo y legal, no
del equipo de desarrollo ni del relator.

**«¿GitHub ve nuestro código?»**
El contexto de cada pedido se envía al servicio para generar la respuesta. Según la
documentación de GitHub, los datos de Copilot Business y Copilot Enterprise no se usan para
entrenar modelos y están cubiertos por su acuerdo de protección de datos. En los planes
individuales, desde el 24 de abril de 2026 GitHub puede usar las interacciones para
entrenar, salvo que el usuario lo deshabilite en su configuración. Qué plan usa el banco y
con qué políticas lo define su administrador.

**«¿Por qué el escenario no usa Spring Boot?»**
Porque el escenario tiene que existir en Java y en .NET con la misma salida, compilar sin
descargas en una máquina sin red y ser chico. Un framework agregaría dependencias y
diferencias entre stacks que no aportan al objetivo. El taller no enseña un framework,
enseña a trabajar con un agente.

**«¿Por qué no trabajamos sobre código del banco?»**
Por confidencialidad, porque no todos conocen el mismo código y, sobre todo, porque en este
escenario se sabe qué problemas tiene y dónde. Eso permite verificar si el agente los
encontró. Sobre código desconocido no se puede saber si el agente acertó.

**«¿Cómo se mide si Copilot aporta?»**
Con una línea base antes de extender el uso y métricas de resultado después. Tiempo de
revisión de pull requests, cambios devueltos, cobertura de pruebas de la lógica, defectos
después de integrar. El laboratorio 5.4 deja ese documento armado y GitHub ofrece métricas
de uso para la organización.

**«¿Esto reemplaza al desarrollador?»**
Cambia lo que hace. Escribe menos y especifica y verifica más. Las dos cosas que el taller
ejercita son las que el agente no puede hacer solo.

**«¿Copilot encuentra solo los diez defectos?»**
No de forma confiable. Encuentra algunos si se le pide revisar, y encuentra los demás si
alguien le dice dónde buscar y cómo comprobar. Por eso los laboratorios lo dirigen paso a
paso. Un escáner automático que corrió sobre este código encontró problemas reales y
también señaló como error lo que era intencional. Es el caso de clase 01.

**«¿Qué pasa si Copilot se actualiza durante el taller?»**
Puede pasar, porque Visual Studio Code se actualiza solo. El material se revisó contra la
documentación vigente antes del dictado. Si un comando o un comportamiento cambia en medio
del taller, se usa la salida grabada, se explica qué cambió y se lo toma como ejemplo de lo
que el equipo va a vivir en su trabajo. La guía de mantenimiento dice qué revisar.

---

## 7. El caso de clase de la configuración regional

Está en [`casos-de-clase/caso-02-configuracion-regional.md`](casos-de-clase/caso-02-configuracion-regional.md).
Se cuenta en el subtema 1.2 de la sesión 1, después de la demostración de referencias de
contexto, en diez minutos.

**Cómo se cuenta.** Por niveles, uno a la vez, con una pausa después de cada uno. Después
del primer nivel se pregunta a la sala si daría la verificación por terminada. No se
adelanta cuántos niveles hay. El punto de quiebre es el tercero, cuando queda claro que el
entorno no cambió solo cómo se imprime el resultado sino el cálculo.

**La conclusión que se da.** El entorno de ejecución es una entrada del programa aunque no
aparezca en su firma. Cada nivel enseña qué preguntar en el siguiente. La verificación es
iterativa porque lo que se aprende en un nivel define la pregunta del próximo.

**La conclusión que no se da.** Que bastaba con pedirlo mejor desde el principio. Nadie
sabía del tercer nivel antes de encontrarlo.

Las notas del relator del propio caso traen las preguntas para la sala y el detalle de
cada nivel.

---

## 8. Lo que el relator no dice

- No afirme cumplimiento regulatorio.
- No comprometa configuraciones, licencias ni precios. Remita al administrador del banco y
  a la documentación oficial.
- No prometa que Copilot resuelve solo los defectos.
- No enumere los diez defectos antes de que el laboratorio correspondiente los exponga.
- No diga que el problema de la coma apareció en una máquina en español.
- No compare con otras herramientas.

---

## 9. Fuentes

Documentación oficial que respalda las afirmaciones técnicas del material. Se mantiene
junto con [`10-mantenimiento.md`](10-mantenimiento.md).

| Tema | Fuente | Consultada |
|---|---|---|
| Comandos del chat | https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet | 27 de septiembre de 2026 |
| Planificación y agente Plan | https://code.visualstudio.com/docs/agents/run/planning | 27 de septiembre de 2026 |
| Contexto del chat y `#codebase` | https://code.visualstudio.com/docs/chat/copilot-chat-context | 27 de septiembre de 2026 |
| Skills | https://code.visualstudio.com/docs/agent-customization/agent-skills | 27 de septiembre de 2026 |
| Especificación abierta de skills | https://agentskills.io/specification | 27 de septiembre de 2026 |
| Prompt files y su retiro | https://code.visualstudio.com/docs/agent-customization/prompt-files | 27 de septiembre de 2026 |
| Instrucciones y `AGENTS.md` | https://code.visualstudio.com/docs/agent-customization/custom-instructions | 27 de septiembre de 2026 |
| Instrucciones de repositorio en GitHub | https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions | 27 de septiembre de 2026 |
| Agentes personalizados | https://code.visualstudio.com/docs/agent-customization/custom-agents | 27 de septiembre de 2026 |
| Herramientas del agente | https://code.visualstudio.com/docs/agents/reference/tools-reference | 27 de septiembre de 2026 |
| Aprobación de herramientas | https://code.visualstudio.com/docs/agents/run/approvals | 27 de septiembre de 2026 |
| Configuración MCP | https://code.visualstudio.com/docs/agents/reference/mcp-configuration | 27 de septiembre de 2026 |
| `readOnlyHint` en MCP | https://code.visualstudio.com/api/extension-guides/ai/mcp | 27 de septiembre de 2026 |
| Hooks | https://code.visualstudio.com/docs/agent-customization/hooks | 30 de septiembre de 2026 |
| Referencia de hooks | https://code.visualstudio.com/docs/agents/reference/hooks-reference | 30 de septiembre de 2026 |
| Exclusión de contenido | https://docs.github.com/en/copilot/concepts/context/content-exclusion | 1 de octubre de 2026 |
| Uso de datos para entrenamiento | https://docs.github.com/en/copilot/managing-copilot/managing-copilot-as-an-individual-subscriber/managing-copilot-policies-as-an-individual-subscriber | 1 de octubre de 2026 |
| Planes | https://docs.github.com/en/copilot/get-started/plans | 1 de octubre de 2026 |
| Cobro y uso | https://docs.github.com/en/copilot/concepts/billing | 1 de octubre de 2026 |
| Dominios de red | https://docs.github.com/en/copilot/reference/allowlist-reference | 1 de octubre de 2026 |
