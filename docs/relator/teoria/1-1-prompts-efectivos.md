# 1.1 Prompts efectivos para desarrollo: objetivo, contexto, restricciones y salida esperada

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 1, sesión 1 |
| Duración | 30 minutos. 22 de exposición y 8 de demostración |
| Demostración | [El pedido pobre y el pedido bueno](../demos/demo-1-1-pedido-pobre-y-pedido-bueno.md) |
| Artefactos que se proyectan | `escenario/README.md`, `escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java` |

## La idea en una frase

Un pedido tiene cuatro partes, objetivo, contexto, restricciones y salida esperada, y las
que faltan las completa el modelo como puede.

## Contenido

### Apertura: dónde está Copilot hoy

El taller abre con un mapa de la herramienta, porque la mayoría de la sala la usa a diario
pero la aprendió en otra etapa. Conviene contarlo en cuatro etapas y sin fechas exactas, que
no aportan.

1. **Autocompletado y chat.** El desarrollador escribe cada línea y la herramienta le ahorra
   tipeo o le responde una pregunta. Es el uso que casi todos conocen, y sigue siendo útil.
2. **Modo agente.** La herramienta recibe un objetivo, no un paso. Según Visual Studio Code,
   el agente reúne contexto, encuentra el código relevante, hace cambios, corre pruebas y
   revisa, en un ciclo de razonamiento, acción y validación. Quien pide revisa y aprueba.
3. **Personalización.** El criterio del equipo queda escrito en el repositorio:
   instrucciones, agentes personalizados, skills, servidores MCP y hooks. Es el capítulo 2 y
   el 3 de este taller.
4. **Plataforma de agentes.** Hoy el agente también trabaja fuera del editor. El agente en la
   nube de GitHub investiga un repositorio, arma un plan y hace cambios en una rama, en su
   propio entorno. Visual Studio Code ejecuta los agentes en un proceso propio, el Agent
   Host, que puede seguir trabajando sin un editor conectado. Y la aplicación de escritorio
   de Copilot, disponible en todos los planes, está hecha para dirigir varias sesiones de
   agentes en paralelo.

Tres cambios recientes tocan directamente al taller, y conviene nombrarlos como muestra de la
velocidad de la herramienta, no como queja. Los prompt files se están retirando en favor de
las skills, y por eso los laboratorios son skills. El uso se cobra en créditos según el
consumo, y por eso el 1.3 trata qué gasta cada modo. Y el agente que trabaja fuera del
editor obliga a pensar en la revisión antes que en la escritura.

### Por qué aprender esto

Cuando la herramienta hace más, el trabajo de quien la usa se desplaza. Escribir código
pesa menos. Pesan más dos cosas que el agente no puede hacer por nosotros. Especificar con
precisión qué queremos y verificar que lo que volvió es lo que queríamos. Este capítulo
trabaja la primera. La segunda atraviesa todo el taller.

La documentación de Visual Studio Code lo dice sin rodeos. El código generado puede tener
errores, problemas de seguridad o fallas sutiles de lógica, y hay que tratarlo como un punto
de partida que se revisa. Conviene citarlo así, porque no es una opinión del relator. Es la
recomendación del fabricante.

### Por qué el pedido importa tanto

El modelo no conoce el proyecto. No sabe qué es Pasarela Andina, qué reglas de negocio
tiene ni qué se considera un buen cambio en este equipo. Lo único que sabe en cada pedido es
lo que le llega en ese momento. Lo que escribimos y el contexto que el editor agrega por su
cuenta.

Cuando el pedido es pobre, el modelo no se detiene a preguntar. Completa lo que falta con
lo más probable, y lo más probable es genérico. Un «mejora este código» produce una lista
larga de sugerencias razonables en abstracto, que cambian de una persona a otra y que nadie
puede evaluar contra un criterio, porque nadie dio uno.

### La anatomía de un pedido

La guía de GitHub para escribir pedidos recomienda empezar por la meta general y después
agregar los requisitos específicos, evitar las referencias ambiguas, indicar el código
relevante, dividir las tareas complejas y dar ejemplos. En la práctica eso se ordena en
cuatro partes. Vale la pena construir el mismo pedido sobre el escenario, una parte a la
vez, para que la sala vea qué aporta cada una.

**Sin nada.** «Mejora este código.» Es el pedido base. El modelo decide qué significa
mejorar, sobre qué archivo y con qué límites.

**Con objetivo.** «Quiero identificar las dos mejoras de legibilidad más útiles en el
método que arma el detalle de una liquidación.» Ahora el modelo sabe qué tipo de mejora se
busca y cuántas. La respuesta se acota.

**Con contexto.** El mismo pedido, con el archivo referenciado de forma explícita,
`#file:escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java`. Ya
no depende de qué archivo tenía abierto cada uno. Todos hablan del mismo código. El
subtema 1.2 trabaja esta parte a fondo.

**Con restricciones.** «No cambies el comportamiento, no cambies tipos de datos, no
propongas bibliotecas nuevas, no modifiques archivos.» Las restricciones son la parte que
más se olvida y la que más cambia el resultado. Sin ellas, el modelo puede proponer con toda
razón cambios que este equipo no acepta, por ejemplo reescribir medio archivo con otro
estilo o agregar una dependencia. Las restricciones dicen qué no es negociable.

**Con salida esperada.** «Una tabla con mejora, líneas afectadas y riesgo de cambiar la
salida.» Pedir la forma de la respuesta parece un detalle y no lo es. Una tabla con
columnas fijas se puede comparar entre dos personas, se puede revisar en dos minutos y se
puede pegar en un pull request. Un texto libre no.

El pedido completo cabe en cuatro líneas. No hace falta escribir más. Hace falta no omitir
ninguna de las cuatro partes.

### Restricciones y verificación van juntas

Una restricción que no se puede comprobar es un deseo. «No cambies el comportamiento» se
comprueba en este repositorio con un comando, `bash scripts/comparar-escenarios.sh`, que
dice si las dos implementaciones del escenario siguen produciendo la misma salida. Cuando
el equipo tiene una forma de comprobar la restricción, el pedido puede ser más ambicioso,
porque el error se detecta en segundos. Cuando no la tiene, conviene que el pedido sea más
chico.

Esta es la relación que el taller va a repetir hasta el último laboratorio. Especificar
bien y verificar con rigor no son dos habilidades separadas. Una restricción bien escrita
dice de antemano cómo se va a verificar.

### Iterar es parte del método

La misma guía de GitHub recomienda experimentar e iterar. Nadie escribe el pedido perfecto
al primer intento, y no hace falta. Lo que hace falta es leer la respuesta, detectar qué
parte del pedido faltaba y agregarla. El laboratorio 1.4 es exactamente eso, el mismo
pedido en tres versiones y la comparación de los resultados.

Hay dos recomendaciones de la guía que conviene mencionar porque la sala las va a sufrir.
Empezar una conversación nueva cuando cambia la tarea, para que el historial de la anterior
no se mezcle con la nueva. Y no usar «esto» ni «eso» cuando hay más de una cosa a la que
podría referirse.

### Qué se gana

Un pedido completo produce respuestas que se pueden comparar, revisar y reutilizar. El
equipo que escribe así sus pedidos empieza a notar que se repiten. El mismo análisis, la
misma revisión, la misma restricción sobre el escenario. Cuando eso pasa, el pedido merece
quedar escrito en el repositorio, y ese es el tema del capítulo 2.

## Cómo se conecta

- **Demostración.** La [demostración 1.1](../demos/demo-1-1-pedido-pobre-y-pedido-bueno.md)
  muestra el pedido pobre y el pedido completo lado a lado sobre `FormateadorReporte`. Se
  hace al final de la exposición.
- **Laboratorio.** El [1.4](../../../labs/cap1/lab-1-4-practica-guiada/README.md) es la
  versión del participante. El mismo pedido, una parte a la vez, sobre la clase de cálculo.
  No anticipe qué van a encontrar en esa clase.
- **Hilo del taller.** Es el primer paso del cambio de oficio. Especificar. El subtema 1.3
  agrega el otro paso, verificar.

## Preguntas probables

**«Escribir cuatro líneas para cada pedido, ¿no es más lento que escribir el código?»**
Para un cambio de una línea, sí, y para eso están las sugerencias en línea. El pedido
completo se justifica cuando la tarea toca varias partes o cuando el resultado se va a
revisar. Y cuando el pedido se repite, se escribe una sola vez en el repositorio, como se ve
en el capítulo 2.

**«¿Por qué dos personas obtienen respuestas distintas con el mismo pedido?»**
Porque el pedido no es lo único que recibe el modelo. El editor agrega contexto por su
cuenta, los archivos del espacio de trabajo y la conversación previa, y eso cambia de una
máquina a otra. Un pedido que referencia el archivo de forma explícita reduce esa
diferencia. Es el tema del subtema siguiente.

**«¿Conviene darle ejemplos?»**
Sí, la guía de GitHub lo recomienda. Un ejemplo de la salida esperada, o de un caso de
entrada y su resultado, le dice al modelo más que una descripción.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Recomendaciones para escribir pedidos: meta general primero, ejemplos, dividir tareas, evitar ambigüedad, indicar el código relevante, iterar, conversación nueva por tarea | https://docs.github.com/en/copilot/concepts/prompting/prompt-engineering | 2 de octubre de 2026 |
| El código generado puede tener errores y se trata como punto de partida que se revisa | https://code.visualstudio.com/docs/agents/best-practices | 2 de octubre de 2026 |
| El agente y su ciclo de razonamiento, acción y validación, tipos de agentes | https://code.visualstudio.com/docs/agents/overview | 3 de octubre de 2026 |
| Agente en la nube: investiga, planifica y cambia código en una rama, en su propio entorno | https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent | 3 de octubre de 2026 |
| Agent Host como proceso propio que puede seguir sin editor conectado | https://code.visualstudio.com/docs/agents/concepts/agent-host | 3 de octubre de 2026 |
| Aplicación de escritorio de Copilot, para desarrollo dirigido por agentes, en todos los planes | https://docs.github.com/en/copilot/concepts/agents/github-copilot-app | 3 de octubre de 2026 |
| Retiro de los prompt files y migración a skills | https://code.visualstudio.com/docs/agent-customization/prompt-files | 3 de octubre de 2026 |
| Cobro en créditos según tokens | https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing | 3 de octubre de 2026 |
| Modos y comandos del chat, incluido el modo agente | https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet | 2 de octubre de 2026 |
| Referencias explícitas a archivos con `#` y contexto agregado por el editor | https://code.visualstudio.com/docs/chat/copilot-chat-context | 2 de octubre de 2026 |
