# 2.2 Diseño de agentes por rol: analista, tester, documentador, revisor y refactorizador

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 2, sesión 2 |
| Duración | 45 minutos. 35 de exposición y 10 de demostración |
| Demostración | [Los agentes por rol](../demos/demo-2-2-agentes-por-rol.md) |
| Artefactos que se proyectan | `.github/agents/analista.agent.md`, `tester.agent.md`, `documentador.agent.md`, `revisor.agent.md`, `refactorizador.agent.md` |

## La idea en una frase

Un agente por rol es contexto más permisos, y el permiso que no se le da es una garantía
más fuerte que la instrucción que se le escribe.

## Contenido

### Qué es un agente personalizado

La documentación de Visual Studio Code define un agente personalizado como la combinación de
instrucciones, herramientas y un modelo opcional en una configuración reutilizable para un
rol específico, como planificar o revisar código. Es un archivo Markdown con extensión
`.agent.md` dentro de `.github/agents/`, con un encabezado de configuración y un cuerpo con
las instrucciones del rol.

Cuando el participante elige el agente en el selector del chat, las instrucciones del cuerpo
se suman a cada pedido y solo quedan disponibles las herramientas que el encabezado declara.
Eso es todo. No hay magia. Un agente es un pedido largo que no hay que volver a escribir,
más una lista de lo que el modelo puede tocar.

### Los campos que importan

El encabezado admite varios campos. Para diseñar por rol, cuatro son los que hay que
entender.

- **`description`.** Lo que el agente hace, en una frase. Aparece como texto de ayuda en el
  chat.
- **`tools`.** La lista de herramientas o conjuntos de herramientas disponibles. Es el campo
  que define qué puede hacer el agente. Según la documentación, si una herramienta declarada
  no está disponible, se ignora.
- **`handoffs`.** Acciones sugeridas para pasar el trabajo a otro agente, con el pedido ya
  escrito. Permiten armar un flujo entre roles, por ejemplo del que analiza al que
  refactoriza.
- **`model`.** El modelo que usa el agente. Es opcional. Si no se declara, usa el que esté
  elegido en el chat. El taller no lo fija, porque los modelos disponibles cambian y
  dependen del plan.

Hay dos campos más que conviene conocer. `user-invocable` controla si el agente aparece en el
selector. `disable-model-invocation`, en un agente, impide que otro agente lo use como
subagente. Ojo con la confusión. En una skill, ese mismo campo impide la carga automática.
Mismo nombre, efecto distinto según el artefacto.

### Las herramientas son el límite duro

Visual Studio Code agrupa las herramientas en conjuntos. Los que usan los agentes del taller
son cuatro. `read` para leer archivos, `search` para buscar en el espacio de trabajo, `edit`
para crear y modificar archivos y `execute` para ejecutar comandos en la terminal.

Esto lleva a la idea central del subtema. A un agente se le pueden decir dos cosas.
Qué no hacer, en sus instrucciones, y qué puede hacer, en sus herramientas. Las
instrucciones el modelo las sigue casi siempre. Las herramientas no son negociables. Un
agente sin `edit` no puede editar, por más que el pedido se lo exija.

Diseñar un agente por rol es decidir, para cada rol, qué límites van en las herramientas y
cuáles quedan en las instrucciones.

### Los cinco agentes del repositorio

El temario nombra cinco roles. El repositorio del taller tiene un agente para cada uno, y
vale la pena recorrer por qué cada uno tiene las herramientas que tiene.

**Analista.** Herramientas `read` y `search`. Su trabajo es entender código y explicarlo con
evidencia, citando archivo y línea. No necesita modificar nada, así que no puede. Tiene un
traspaso sugerido hacia el refactorizador, para cuando el análisis termina en una mejora
concreta. Es el patrón que la documentación muestra con su ejemplo de planificador, un
agente que investiga con herramientas de solo lectura.

**Tester.** Herramientas `read`, `search`, `edit` y `execute`. Necesita crear archivos de
prueba y correrlos, así que necesita editar y ejecutar. Su instrucción dice que no toca el
código de producción. Aquí está la debilidad que conviene señalar. Esa regla vive en las
instrucciones, no en las herramientas. El permiso de editar no distingue entre un archivo de
prueba y uno de producción. Si el tester se pasa de la raya, lo detecta la revisión del
diff, no el editor.

**Documentador.** Herramientas `read`, `search` y `edit`. Escribe Markdown, así que edita.
No ejecuta nada. Su instrucción le pide documentar lo que el código hace y no lo que dicen
los comentarios, y contrastar con las reglas de negocio. El capítulo 4 vuelve sobre esto.

**Revisor.** Herramientas `read` y `search`. Es el caso más claro. Revisa cambios y clasifica
hallazgos en aplicar, descartar o decidir. No aplica nada, y no puede. En la demostración se
le pide «revisa y corrige», y lo único que entrega es la revisión. Su instrucción tiene
además una regla que importa en este repositorio. Un problema que ya existía en código que
el cambio no tocó se descarta como fuera del alcance, aunque sea real.

**Refactorizador.** Herramientas `read`, `search`, `edit` y `execute`. Necesita cambiar
código, compilar y correr el comparador. Es el rol con más permisos, y por eso es el que más
instrucciones tiene sobre lo que no hace. No cambia tipos, no extrae literales, no unifica
código entre clases, no renombra, no agrega manejo de errores. Si ve algo de eso, lo
menciona y lo deja. En la demostración, la última parte de su respuesta es justamente la
lista de lo que vio y no tocó.

### Por qué tantos roles y no uno

Un solo agente general con todas las herramientas puede hacer el trabajo de los cinco. La
razón para separarlos no es la capacidad. Es el control. Cada rol trae su foco, su formato
de respuesta y sus permisos mínimos. Cuando alguien elige el revisor, sabe que no va a
encontrar archivos modificados. Cuando elige el refactorizador, sabe que va a recibir un
diff acotado y el resultado del comparador.

También hay un argumento de costo. La guía de uso de Visual Studio Code recomienda mantener
acotado el conjunto de herramientas, porque las definiciones y los resultados de las
herramientas también entran al contexto. Un agente con cuatro herramientas consume menos
que uno con todas.

### Cómo se diseña un rol

Para el laboratorio 2.4 y para el trabajo real, el procedimiento es corto.

1. Escribir en una frase qué entrega el rol y para quién.
2. Listar las herramientas mínimas para entregarlo. Si el rol solo responde, no necesita
   editar ni ejecutar.
3. Escribir lo que el rol no hace como frases verificables. «No modifica archivos fuera de
   `docs/`» se puede comprobar. «Es cuidadoso» no.
4. Fijar el formato de la respuesta, como en el capítulo 1.
5. Probarlo con un pedido dentro del rol y con uno fuera del rol, y mirar qué hace con el
   segundo.

### Un flujo entre roles sobre el escenario

Los traspasos permiten encadenar roles sin que el participante reescriba el pedido. Un flujo
posible sobre el repositorio del taller muestra cómo cada rol hace una parte y deja la
siguiente lista.

1. **Analista.** Se le pregunta qué bloques del método que arma el detalle del reporte se
   podrían separar sin cambiar la salida. Responde con una tabla y líneas citadas. No toca
   nada.
2. **Traspaso al refactorizador.** El analista ofrece pasar el trabajo con el pedido ya
   escrito, aplicar solo la mejora acotada que quedó propuesta. El participante revisa el
   pedido antes de enviarlo.
3. **Refactorizador.** Dice qué archivo y qué bloque va a tocar, aplica el cambio, compila y
   corre el comparador. Termina con la lista de lo que vio y no tocó.
4. **Revisor.** Se le pide revisar el diff. Clasifica cada hallazgo y recomienda aceptar,
   aceptar con cambios o rechazar. No aplica nada.

En cada paso, quien decide pasar al siguiente es una persona. El flujo no es automático, y
está bien que no lo sea. Los traspasos ahorran escritura, no criterio.

### Errores típicos al diseñar un agente

Estos son los que aparecen en el laboratorio 2.4 y en los repositorios reales.

- **Todas las herramientas por si acaso.** Un agente que solo responde preguntas no necesita
  `edit` ni `execute`. Cada herramienta de más es una capacidad que alguien va a tener que
  revisar y un costo de contexto.
- **Límites escritos como deseos.** «Ten cuidado con el código de producción» no se puede
  comprobar. «No modifiques archivos fuera de `src/test/`» sí.
- **Sin formato de respuesta.** Si el agente no tiene una salida fija, cada respuesta es
  distinta y nadie puede comparar ni revisar rápido.
- **Roles que se pisan.** Dos agentes que hacen casi lo mismo con instrucciones distintas
  confunden al equipo. Es mejor uno bien definido que dos ambiguos.
- **Un agente para no pensar.** Un rol no reemplaza el pedido. El agente trae el contexto
  fijo del rol, pero la tarea concreta la sigue escribiendo una persona.

### Cómo se prueba un agente antes de compartirlo

Un agente es configuración que va a usar todo el equipo, así que se prueba antes de
integrarlo. Tres pruebas cortas alcanzan para la mayoría de los roles.

**Dentro del rol.** Un pedido típico de la tarea para la que se diseñó. La respuesta tiene
que llegar en el formato fijado y citar el código que usó.

**Fuera del rol.** Un pedido que el rol no debería atender, por ejemplo pedirle al revisor
que corrija. Lo esperable es que se niegue o que entregue solo lo que le corresponde. Si
hace el trabajo de otro rol, sus límites están mal escritos.

**En el borde de sus permisos.** Un pedido que exigiría una herramienta que no tiene. El
agente no debería poder cumplirlo, y la respuesta muestra si el límite está en las
herramientas o solo en las instrucciones.

Las tres pruebas se dejan escritas junto al agente, por ejemplo al final de su cuerpo, para
que quien lo modifique después las repita. Es la misma disciplina de los gates del
repositorio aplicada a la personalización. Un control no vale hasta que se lo vio fallar.

### Lo que un agente no reemplaza

Un agente bien diseñado reduce el error, no lo elimina. Las instrucciones se siguen casi
siempre, no siempre. Las herramientas acotan, pero un permiso de edición sigue permitiendo
editar mal. La documentación lo dice para todo el trabajo con agentes. El código generado se
revisa antes de confirmarlo. El agente por rol hace esa revisión más fácil, porque el diff
es más chico y más predecible. No la hace innecesaria.

## Cómo se conecta

- **Demostración.** La [demostración 2.2](../demos/demo-2-2-agentes-por-rol.md) muestra los
  cinco agentes en el selector, el revisor negándose a editar y el refactorizador aplicando
  un cambio acotado con el comparador.
- **Laboratorio.** En el [2.4](../../../labs/cap2/lab-2-4-agente-o-instruccion/README.md),
  quien elige construir un agente aplica el procedimiento de este subtema con la plantilla
  del laboratorio.
- **Hilo del taller.** Un agente por rol pone por escrito qué se espera de cada tarea y qué
  no se permite. Especificar, en el repositorio, y dejar a la vista qué hay que verificar.

## Preguntas probables

**«¿El tester no debería poder escribir solo en las carpetas de pruebas?»**
Sería lo ideal, y el permiso de edición no lo distingue. Por eso la regla queda en las
instrucciones y la verificación queda en la revisión del diff. Un hook que bloquee
ediciones fuera de las pruebas es una forma de endurecerlo, como se ve en el capítulo 3.

**«¿Conviene fijar el modelo en cada agente?»**
Solo si el equipo tiene una razón medida. Los modelos disponibles cambian y dependen del
plan. Si no se declara, el agente usa el elegido en el chat.

**«¿Puede un agente llamar a otro?»**
Sí. El campo `agents` lista los agentes disponibles como subagentes, y los traspasos
sugieren pasar el trabajo de un rol a otro con el pedido ya escrito.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Definición de agente personalizado, ubicación, campos del encabezado, herramientas no disponibles se ignoran, traspasos, ejemplo de planificador de solo lectura | https://code.visualstudio.com/docs/agent-customization/custom-agents | 2 de octubre de 2026 |
| Conjuntos de herramientas `read`, `search`, `edit` y `execute` | https://code.visualstudio.com/docs/agents/reference/tools-reference | 2 de octubre de 2026 |
| `disable-model-invocation` en skills impide la carga automática | https://code.visualstudio.com/docs/agent-customization/agent-skills | 2 de octubre de 2026 |
| Mantener acotado el conjunto de herramientas para reducir el consumo | https://code.visualstudio.com/docs/agents/guides/optimize-usage | 2 de octubre de 2026 |
| El código generado se revisa antes de confirmarlo | https://code.visualstudio.com/docs/agents/best-practices | 2 de octubre de 2026 |
