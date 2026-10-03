# 1.3 Flujos de trabajo con Copilot Chat: analizar, planear, implementar y validar

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 1, sesión 1 |
| Duración | 30 minutos. 20 de exposición y 10 de demostración |
| Demostración | [Analizar, planear, implementar y validar](../demos/demo-1-3-flujo-de-trabajo.md) |
| Artefactos que se proyectan | La tabla del ciclo de vida de este documento, el selector de modo del chat, `scripts/comparar-escenarios.sh`, `docs/gobierno/uso-responsable-de-tokens.md` |

## La idea en una frase

La IA participa en todas las fases del ciclo de vida del software, y en cada una se repite
el mismo ciclo corto: analizar, planear, implementar y validar.

## Contenido

### El marco del taller

Este subtema da el mapa que se usa hasta la última sesión. El desarrollo de software con IA
no es solo escribir código más rápido. La IA aporta en cada fase del ciclo de vida, desde el
requerimiento hasta la mantención, y en cada fase hay algo que la persona decide y algo que
se verifica antes de seguir.

Conviene proyectar la tabla y recorrerla sin detenerse en cada celda. Lo que la sala tiene
que ver es el patrón: la IA propone, la persona decide, algo se verifica y queda un
artefacto.

### Las once fases

| Fase | Qué aporta la IA | Qué hace y decide la persona | Qué se verifica antes de seguir | Artefacto que queda |
|---|---|---|---|---|
| Requerimientos | Redacta historias de usuario y criterios de aceptación a partir de notas | Decide qué se construye y para quién | Que cada criterio se pueda comprobar | Historia de usuario con criterios |
| Estimación | Desglosa la historia en tareas e identifica riesgos | Fija el costo y el tiempo, incluido el consumo de créditos | Que el desglose cubra todos los criterios | Estimación con supuestos escritos |
| Análisis y diseño | Lee el código existente y propone alternativas | Elige la alternativa y sus límites de responsabilidad | Que la decisión tenga alternativas y consecuencias | Decisión de arquitectura |
| Desarrollo | Implementa en pasos, con un plan aprobado | Aprueba el plan y lee cada comando antes de aprobarlo | Que compile y que el alcance sea el pedido | Cambio en una rama |
| Pruebas | Propone casos, incluidos los bordes, y escribe pruebas | Decide qué comportamiento es el correcto | Que las pruebas fallen ante un error conocido | Pruebas y estrategia de pruebas |
| Revisión de código | Revisa el diff y clasifica hallazgos | Acepta, descarta o escala cada hallazgo | Que nada fuera del alcance haya cambiado | Pull request revisado |
| Seguridad | Señala datos sensibles y riesgos en el cambio | Aplica la política de uso de IA | Qué leyó, qué envió y qué se le permitió al agente | Revisión de seguridad registrada |
| Integración continua | Ayuda a escribir y diagnosticar el pipeline | Decide qué bloquea una integración | Que el pipeline pase en limpio | Pipeline en verde |
| Liberación | Redacta notas de versión desde los cambios | Decide qué se libera y cuándo | Que las notas coincidan con lo integrado | Notas de versión |
| Operación y soporte | Genera runbooks y ayuda a diagnosticar | Ejecuta las acciones y escala | Que cada acción del runbook se haya ejecutado de verdad | Runbook verificado |
| Mantención, correctiva y evolutiva | Localiza la causa o el punto de extensión | Decide si corrige, extiende o reescribe | Que el comportamiento que no debía cambiar no cambió | Cambio con su decisión y sus pruebas |

Tres columnas se repiten en todos los capítulos. La tercera, lo que decide la persona, es lo
que no se delega. La cuarta, la verificación, es lo que el taller entrena. La quinta, el
artefacto, es lo que queda en el repositorio para el próximo.

### El ciclo corto dentro de cada fase

El título del subtema enumera cuatro pasos. No son una fase más: son el ciclo que se repite
dentro de cada fase. Redactar una historia, diseñar o corregir un defecto siguen el mismo
patrón.

**Analizar.** Entender antes de cambiar. Basta el chat en modo pregunta, que no toca
archivos, y comandos como `/explain` sobre la selección. Algunos materiales mencionan un
comando `/analyze`, que no existe en la versión vigente. Se verifica leyendo la respuesta
contra las líneas que cita.

**Planear.** Decidir qué se cambia antes de cambiarlo. El agente Plan de Visual Studio Code
investiga, pregunta y arma un plan para revisar, y por omisión no edita archivos. Se invoca
desde el selector o con `/plan`. Conviene cuando el enfoque no es claro o el cambio toca
varias partes; para una edición chica, se implementa directo. Un plan sin paso de
validación está incompleto.

**Implementar.** El modo agente edita y ejecuta, y pide aprobación para los comandos. Llega
último, con el plan aprobado. Leer cada comando antes de aprobar es la práctica que más
cuesta sostener.

**Validar.** La documentación es explícita: el código generado puede tener errores y se
trata como punto de partida. Recomienda incluir pruebas en el pedido, correrlas y leer el
código antes de confirmarlo. En este repositorio, `bash scripts/comparar-escenarios.sh`
comprueba en segundos que Java y .NET siguen dando la misma salida. Si algo salió mal, los
puntos de control de Visual Studio Code restauran archivos y conversación.

### Lo que cuesta cada modo

El uso se cobra en créditos de IA, que se consumen por tokens de entrada, de salida y en
caché. El costo depende del modelo. En los planes pagos, las sugerencias en línea y las de la
próxima edición no consumen créditos; el chat, el agente, la línea de comandos y el agente
en la nube sí. Las llamadas a herramientas y las conversaciones largas aumentan el consumo.

Analizar y planear son baratos y evitan que el agente implemente lo que no se quería. La guía
[`docs/gobierno/uso-responsable-de-tokens.md`](../../gobierno/uso-responsable-de-tokens.md)
lo resume en una página, con qué modo conviene según la tarea y cómo ver el consumo.
Proyéctela al cerrar este punto. No dé precios ni cantidades por plan.

### Cómo sigue el taller

Los capítulos 1 a 4 profundizan fases sueltas: el pedido y el contexto, la personalización,
la seguridad y la documentación. El capítulo 5 recorre las once fases con una sola historia,
de punta a punta. No adelante los laboratorios; basta con decir que el mapa de hoy es el que
se va a recorrer completo al final.

## Cómo se conecta

- **Demostración.** La [demostración 1.3](../demos/demo-1-3-flujo-de-trabajo.md) lleva una
  extracción de método sobre `FormateadorReporte` por los cuatro pasos del ciclo corto y
  termina con el comparador.
- **Laboratorios.** El [1.4](../../../labs/cap1/lab-1-4-practica-guiada/README.md) usa
  `/explain` y `/plan`. El capítulo 5 recorre el ciclo de vida completo.
- **Hilo del taller.** Generar es barato. Verificar es caro y sigue siendo trabajo humano.
  La tabla lo muestra fase por fase.

## Preguntas probables

**«¿La IA reemplaza alguna de estas fases?»**
No. Acelera lo que propone y redacta. La columna de lo que decide la persona no cambia.

**«¿Siempre hay que planear?»**
No. La documentación lo recomienda cuando el enfoque no es claro o el cambio toca varias
partes. Para una edición chica y clara, se implementa directo.

**«¿Cuál es el modo más barato?»**
El que menos procesa. Preguntar y planear consumen menos que dejar al agente implementar y
reintentar. El costo de cada respuesta se ve pasando el puntero sobre ella.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Separar planificación e implementación, código como punto de partida que se revisa, incluir pruebas, leer antes de confirmar, puntos de control | https://code.visualstudio.com/docs/agents/best-practices | 2 de octubre de 2026 |
| Agente Plan, solo lectura por omisión, cuándo planear y cuándo no | https://code.visualstudio.com/docs/agents/run/planning | 2 de octubre de 2026 |
| Comandos `/plan` y `/explain`, `/analyze` no figura | https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet | 2 de octubre de 2026 |
| Aprobación de herramientas y comandos | https://code.visualstudio.com/docs/agents/run/approvals | 2 de octubre de 2026 |
| Ciclo del agente: contexto, cambios, pruebas y revisión | https://code.visualstudio.com/docs/agents/overview | 3 de octubre de 2026 |
| Validar siempre lo que sugiere Copilot | https://docs.github.com/en/copilot/get-started/best-practices | 2 de octubre de 2026 |
| Créditos por tokens, costo según el modelo, qué consume y qué no | https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing | 3 de octubre de 2026 |
| Qué aumenta el consumo, cómo ver el consumo | https://code.visualstudio.com/docs/agents/guides/optimize-usage | 3 de octubre de 2026 |
