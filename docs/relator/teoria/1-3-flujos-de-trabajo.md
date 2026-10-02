# 1.3 Flujos de trabajo con Copilot Chat: analizar, planear, implementar y validar

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 1, sesión 1 |
| Duración | 30 minutos. 20 de exposición y 10 de demostración |
| Demostración | [Analizar, planear, implementar y validar](../demos/demo-1-3-flujo-de-trabajo.md) |
| Artefactos que se proyectan | El selector de modo del chat, `scripts/comparar-escenarios.sh`, el indicador de consumo de la barra de estado |

## La idea en una frase

Cada paso del trabajo tiene su modo y su verificación, y validar no es opcional.

## Contenido

### Cuatro pasos, no uno

El error más común con un agente es pedirle todo de una vez. «Refactoriza este módulo.» El
agente lo intenta, toca diez archivos y deja a quien pidió con un diff que no sabe cómo
revisar. La documentación de Visual Studio Code recomienda otra cosa para los cambios
complejos que abarcan varios archivos. Separar la planificación de la implementación.

El temario nombra cuatro pasos. Analizar, planear, implementar y validar. Cada uno tiene
un modo de trabajo que le corresponde, un costo distinto y una verificación propia antes de
pasar al siguiente.

### Analizar

El objetivo es entender antes de cambiar. Qué hace este código, dónde está tal regla, qué
partes se podrían separar. Para eso alcanza con el chat en modo pregunta, que responde sin
tocar archivos, y con los comandos que trabajan sobre la selección, como `/explain`.

Algunos materiales mencionan un comando `/analyze`. No existe en la versión vigente.
Analizar es preguntar, con buen contexto, en el modo que no modifica nada.

**Verificación de este paso.** Leer la respuesta contra el código. Las respuestas buenas
citan líneas, y las líneas se pueden abrir.

### Planear

El objetivo es decidir qué se va a cambiar antes de cambiarlo. Visual Studio Code tiene un
agente Plan. Según su documentación, investiga el proyecto, hace preguntas para aclarar y
arma un plan para revisar antes de implementar. Por omisión no edita archivos del
proyecto. Se invoca eligiéndolo en el selector o escribiendo `/plan` con el pedido.

El plan se revisa y se decide. Se puede aprobar e implementar en la misma sesión, aprobar
sin ejecutar, o rechazar. En una sesión local, el plan se guarda en la memoria de la
sesión, no como archivo del proyecto.

La documentación da también el criterio para saltarse este paso. Planear conviene cuando el
enfoque no es claro o el cambio abarca varias partes del proyecto. Para una edición chica y
bien definida, se le puede pedir al agente que la implemente directamente.

**Verificación de este paso.** Que el plan diga cómo se va a validar. Un plan sin paso de
validación está incompleto, y se le pide al agente que lo agregue.

### Implementar

El modo agente es el que construye, corrige y crea. Edita archivos y ejecuta comandos, y
para ejecutar comandos pide aprobación. Es el modo que más hace y, por lo general, el que
más consume. Por eso llega último en el flujo, con el plan ya aprobado.

Cuando el agente pide ejecutar un comando, se lee antes de aprobar. Parece obvio. En la sala
va a ser la práctica que más cuesta sostener cuando el agente pide aprobación cinco veces
seguidas.

### Validar

La documentación es explícita. El código generado puede tener errores, problemas de
seguridad o fallas sutiles de lógica, y se trata como punto de partida. Recomienda incluir
casos de prueba en el pedido para que el agente pueda comprobar su propio trabajo, correr
las pruebas uno mismo si el agente no lo hizo y leer el código antes de confirmarlo,
mirando casos borde, manejo de errores y supuestos.

En este repositorio la validación tiene una herramienta concreta. Los dos escenarios, Java
y .NET, producen exactamente la misma salida, y `bash scripts/comparar-escenarios.sh` lo
comprueba en segundos. Una refactorización correcta no cambia la salida. Si la cambia, el
script dice en qué línea.

Si algo salió mal, Visual Studio Code tiene puntos de control para restaurar los archivos y
el historial de la conversación. Y en el taller, `reiniciar-lab.sh` deja cualquier
laboratorio en su punto de partida.

### Lo que cuesta cada modo

Copilot mide el uso en créditos de IA. Según la documentación de GitHub, cada interacción
consume tokens, los que se envían al modelo, los que el modelo genera y los que se
reutilizan desde la caché, y eso se convierte en créditos. Los modelos más capaces cuestan
más por token que los livianos.

Lo que conviene que la sala se lleve es qué consume y qué no.

- **No consumen créditos** en los planes pagos las sugerencias en línea y las sugerencias de
  la próxima edición. Siguen siendo ilimitadas.
- **Consumen créditos** el chat, el modo agente, la línea de comandos de Copilot y el agente
  en la nube, entre otros.
- **Aumentan el consumo** las llamadas a herramientas, cuyo resultado se suma al contexto,
  las conversaciones largas, que el modelo vuelve a procesar, y el esfuerzo de razonamiento
  alto.

La guía de uso de Visual Studio Code agrega una advertencia útil. El modelo más barato no
siempre da el resultado más barato. Un modelo que necesita reintentos o produce retrabajo
puede costar más que uno capaz que termina la tarea a la primera.

Y da formas concretas de bajar el consumo. Abrir una conversación nueva para cada tarea.
Usar `/compact` para resumir una conversación larga. Mantener acotado el conjunto de
herramientas. Elegir el esfuerzo de razonamiento según la tarea.

El consumo se puede ver. Pasando el puntero sobre una respuesta del chat aparece su costo,
el control de la ventana de contexto muestra el acumulado de la sesión y el panel de Copilot
en la barra de estado muestra el consumo del mes.

No dé precios ni cantidades de créditos por plan. Cambian, y en el banco dependen del
acuerdo con su proveedor. Lo que no cambia es el mecanismo, y con el mecanismo el equipo
puede decidir. Analizar y planear son baratos y evitan que el agente implemente lo que no
se quería. Esa es la línea base que el laboratorio 5.4 convierte en presupuesto.

## Cómo se conecta

- **Demostración.** La [demostración 1.3](../demos/demo-1-3-flujo-de-trabajo.md) lleva una
  extracción de método sobre `FormateadorReporte` por los cuatro pasos y termina con el
  comparador.
- **Laboratorios.** El [1.4](../../../labs/cap1/lab-1-4-practica-guiada/README.md) usa
  `/explain` y `/plan`. El [5.2](../../../labs/cap5/lab-5-2-refactorizacion/README.md) es el
  flujo completo sobre la clase de cálculo, con el comparador como validación.
- **Hilo del taller.** Generar es barato. Verificar es caro y sigue siendo trabajo humano.
  Este subtema convierte esa idea en un paso del flujo.

## Preguntas probables

**«¿Cuál es el modo más barato?»**
El que menos procesa. Preguntar y planear consumen menos que dejar al agente implementar y
reintentar. Las sugerencias en línea no consumen créditos en los planes pagos. El costo
real de cada respuesta se ve pasando el puntero sobre ella.

**«¿Siempre hay que planear?»**
No. La documentación lo recomienda cuando el enfoque no es claro o el cambio toca varias
partes. Para una edición chica y clara, se implementa directo.

**«Si el agente corre las pruebas, ¿igual tengo que revisar?»**
Sí. Las pruebas comprueban lo que alguien decidió probar. El código se lee antes de
confirmarlo, como con cualquier otro autor.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Separar planificación e implementación en cambios complejos, código como punto de partida que se revisa, incluir pruebas, leer antes de confirmar, puntos de control | https://code.visualstudio.com/docs/agents/best-practices | 2 de octubre de 2026 |
| Agente Plan, solo lectura por omisión, aprobación del plan, memoria de sesión, cuándo planear y cuándo no | https://code.visualstudio.com/docs/agents/run/planning | 2 de octubre de 2026 |
| Modos y comandos `/plan`, `/explain`, `/fix`, `/tests`, `/doc`, sugerencias en línea y de la próxima edición | https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet | 2 de octubre de 2026 |
| `/analyze` no figura entre los comandos vigentes | https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet | 27 de septiembre de 2026 |
| Aprobación de las herramientas y comandos que ejecuta el agente | https://code.visualstudio.com/docs/agents/run/approvals | 27 de septiembre de 2026 |
| Créditos de IA, tokens de entrada, salida y caché, costo según el modelo, qué funciones consumen créditos, sugerencias en línea y de la próxima edición sin cobro en planes pagos | https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing | 2 de octubre de 2026 |
| Qué aumenta el consumo, el modelo más barato no siempre es el resultado más barato, `/compact`, cómo ver el consumo | https://code.visualstudio.com/docs/agents/guides/optimize-usage | 2 de octubre de 2026 |
