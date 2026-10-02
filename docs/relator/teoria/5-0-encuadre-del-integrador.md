# 5 Encuadre del laboratorio integrador

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 5, sesión 4 |
| Duración | Sin minutos propios. Se dicta en los primeros minutos de cada bloque, ya contados en las notas de laboratorio |
| Demostración | No tiene |
| Artefactos que se proyectan | `labs/cap5/*/README.md`, `.github/skills/lab-5-4-paso-2-medicion-y-presupuesto/SKILL.md` |

## La idea en una frase

Los cuatro bloques repiten el ciclo del taller sobre un mismo sistema, y en cada uno el
agente produce y la persona verifica, porque la verificación es el trabajo que no se delega.

## Contenido

### Cómo se usa este documento

El capítulo 5 no tiene subtemas de teoría en el temario. Sus cuatro bloques son de práctica.
Este documento reúne lo que el relator dice al abrir cada bloque: dónde está el grupo en el
hilo, qué se va a verificar y, en el último, el marco para la medición y el presupuesto.
Cada apertura dura pocos minutos y sale del tiempo del laboratorio.

### El hilo de los cuatro bloques

Los cuatro laboratorios trabajan sobre el mismo escenario y se encadenan. Lo que produce uno
es la entrada del siguiente.

**5.1, preparación y criterios.** Se levanta el escenario con una línea base verificada, se
arma un mapa del sistema, un inventario de riesgos y los criterios con que se van a evaluar
los dos bloques siguientes. Retoma el capítulo 1: contexto antes de pedir y un pedido que
dice qué es éxito.

**5.2, mejora incremental.** Se planea una mejora del método que calcula la liquidación y se
ejecuta en incrementos, cada uno validado contra el otro escenario. Retoma el flujo del
subtema 1.3, analizar, planear, implementar y validar, y los agentes por rol del capítulo 2.

**5.3, pruebas, documentación y revisión.** Se cubre con pruebas una parte de la lógica de
negocio, se documenta la estrategia y se revisa el resultado con un checklist humano.
Retoma el capítulo 4.

**5.4, activos para el equipo.** El agente trabaja sobre una tarea completa sin guía paso a
paso y consolida lo aprendido en activos que el equipo pueda llevar a sus repositorios. Y se
deja el documento de medición y presupuesto.

Al abrir cada bloque, conviene decir en una frase de qué capítulo viene lo que se va a usar.
La sala ve así que el integrador no es un ejercicio nuevo sino el taller entero sobre un solo
sistema.

### La verificación como trabajo humano

Es la idea que cierra el taller, y conviene repetirla en cada apertura con un ejemplo del
bloque.

La guía de buenas prácticas de GitHub lo dice de forma directa: Copilot es una herramienta
capaz de equivocarse, y lo que sugiere se valida siempre. Recomienda revisar con cuidado, no
solo si funciona sino su seguridad, su legibilidad y su mantenibilidad, y usar pruebas
automatizadas y herramientas para comprobar su trabajo.

Cada bloque del integrador tiene un punto donde esa verificación es explícita.

- **En el 5.1**, cada criterio de evaluación tiene que poder comprobarse con un comando o
  una prueba. Un criterio que no se puede comprobar no es un criterio.
- **En el 5.2**, cada incremento se valida con el comparador de escenarios. Si la salida
  cambió, se sabe en qué línea.
- **En el 5.3**, la pregunta es si las pruebas documentan lo que el código hace o lo que
  debería hacer. El agente escribe pruebas que pasan. Decidir si lo que pasa es correcto
  es de la persona.
- **En el 5.4**, se observa qué decide el agente cuando nadie lo acota, y se revisa el
  documento de presupuesto buscando valores inventados.

En el 5.1 y en el 5.3 el agente va a encontrar comportamientos del sistema que merecen una
decisión. No las anticipe al abrir el bloque. Las notas de cada laboratorio dicen cuándo y
cómo se cierran.

### El marco para la medición y el presupuesto

El paso 2 del 5.4 produce un documento corto con dos partes, una línea base de medición y
una propuesta de presupuesto de créditos. El agente lo escribe con campos a completar. Lo
que sigue es lo que el relator necesita saber para abrir ese paso y responder preguntas. No
se dan cifras en clase, porque cambian y porque dependen del plan de la organización.

#### Cómo se cobra hoy

Según la documentación de cobro de GitHub, el uso de Copilot se mide en créditos de IA. Los
créditos se consumen por tokens, de entrada, de salida y en caché, y el costo por token
depende del modelo que se use. En los planes pagos, las sugerencias en línea y las
sugerencias de la próxima edición no consumen créditos. El chat, el modo agente, la línea de
comandos y el agente en la nube sí.

Eso conecta con lo que el capítulo 1 trató sobre el consumo de cada modo de trabajo. Un
pedido en modo agente con muchas herramientas y mucho contexto consume más que una pregunta
acotada. El presupuesto por perfil de uso del documento sale de ahí.

#### Cómo se controla el gasto

GitHub permite fijar presupuestos en varios niveles: por usuario, por centro de costo, por
organización y por empresa. La documentación de presupuestos indica que el de usuario bloquea
el uso de forma automática al llegar al límite. Para los demás, existe el ajuste para detener
el uso al alcanzar el límite, y la documentación recomienda habilitarlo siempre.

En el documento del laboratorio, el presupuesto por persona queda como campo a completar con
los valores del plan vigente, y el equipo decide qué hace cuando alguien se acerca al límite.

#### Cómo se mide la adopción

GitHub ofrece métricas de uso de Copilot. Según su documentación incluyen usuarios activos,
fases de adopción, tasas de aceptación de sugerencias, líneas sugeridas, agregadas y
eliminadas, y uso del chat y del agente. Se pueden ver por empresa, por organización, por
repositorio y por usuario, y se accede a ellas por las API de métricas de uso, por un panel
con los últimos 28 días y por exportación en NDJSON.

Hay tres advertencias de la misma documentación que conviene repetir a la sala.

- Los datos están disponibles con un desfase de hasta dos días completos.
- Los valores de distintos recursos de la API no se comparan directamente entre sí.
- La fase de adopción se recalcula cada día.

Las métricas de GitHub miden uso. La línea base del laboratorio pide además medir resultado
y calidad, como el tiempo de revisión de pull requests o los defectos encontrados después de
integrar un cambio. Esos datos no salen de las métricas de Copilot. Salen de las
herramientas del equipo, y por eso cada métrica del documento tiene una fuente y un
responsable.

#### Lo que se revisa en el documento

Al cerrar el paso, la pregunta es una sola: si el documento deja los valores como campos a
completar o los inventa. Un documento de presupuesto con cifras que nadie consultó parece
terminado y es peligroso. Es la misma lección de la documentación técnica, aplicada a un
documento de gestión.

## Cómo se conecta

- **Demostración.** No tiene.
- **Laboratorios.** El
  [5.1](../../../labs/cap5/lab-5-1-preparacion/README.md), el
  [5.2](../../../labs/cap5/lab-5-2-refactorizacion/README.md), el
  [5.3](../../../labs/cap5/lab-5-3-pruebas-y-revision/README.md) y el
  [5.4](../../../labs/cap5/lab-5-4-laboratorio-final/README.md).
- **Hilo del taller.** El integrador es el taller completo sobre un solo sistema. Lo que se
  lleva el equipo no es el código del escenario, sino los activos del 5.4 y el hábito de
  verificar.

## Preguntas probables

**«¿Cuántos créditos trae nuestro plan?»**
No se responde en clase. Está en la documentación de planes de GitHub y en la configuración
de la organización. Por eso el documento deja el campo a completar.

**«¿Las sugerencias en línea gastan créditos?»**
Según la documentación de cobro vigente, en los planes pagos no. El chat y el agente sí.

**«¿Podemos ver cuánto usa cada persona?»**
Las métricas se pueden ver por usuario, además de por repositorio, organización y empresa.
Quién tiene acceso a ese nivel lo define la organización.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Copilot puede equivocarse, validar siempre, revisar seguridad, legibilidad y mantenibilidad, pruebas automatizadas | https://docs.github.com/en/copilot/get-started/best-practices | 2 de octubre de 2026 |
| Créditos de IA por tokens de entrada, salida y caché, costo según el modelo, sugerencias en línea y de próxima edición sin consumo en planes pagos, chat, agente, línea de comandos y agente en la nube con consumo | https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing | 2 de octubre de 2026 |
| Presupuestos por usuario, centro de costo, organización y empresa, bloqueo automático del de usuario, detener el uso al alcanzar el límite | https://docs.github.com/en/copilot/concepts/billing-and-usage/organizations-and-enterprises/budgets | 2 de octubre de 2026 |
| Métricas de uso, niveles, API, panel de 28 días, NDJSON, desfase de dos días, no comparar recursos, fase recalculada a diario | https://docs.github.com/en/copilot/concepts/billing-and-usage/copilot-usage-metrics/copilot-metrics | 2 de octubre de 2026 |
