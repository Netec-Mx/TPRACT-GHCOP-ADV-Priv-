# Notas del relator, laboratorio 2.4

Creación de un agente local o una instrucción reutilizable. 45 minutos.

## Qué va a pasar en la sala

Cada participante elige una de cuatro tareas de `labs/cap2/lab-2-4-agente-o-instruccion/tareas.md`.
A y B se resuelven con un agente, C y D con una instrucción. Conviene que la sala quede
repartida entre agentes e instrucciones, porque la puesta en común compara los dos
enfoques. Si en el paso 1 todos eligen la misma tarea, pida que la mitad cambie.

Las cuatro tareas se eligieron para no coincidir con los artefactos de referencia que el
repositorio ya trae y que usted mostró en las demostraciones de los subtemas 2.2 y 2.3.
Los cinco agentes de referencia son roles técnicos sobre código. Las tareas del laboratorio
son de negocio, de proceso o de convención. Nadie resuelve el laboratorio copiando un
archivo de `.github/`.

## Errores típicos

- **La instrucción que nunca se aplica.** En la sesión 2 todavía no hay entregables en
  `labs/`, así que el patrón de la tarea C no coincide con ningún archivo. Visual Studio Code
  aplica la instrucción cuando el agente crea o modifica un archivo que coincide, y la
  prueba del paso 3 lo hace así. Si alguien prueba abriendo un archivo y preguntando en modo
  **Ask**, la instrucción no aparece y cree que falló.
- **Patrón `applyTo` mal escrito.** Un patrón como `entregables/*.md` no coincide con nada,
  porque el patrón se evalúa desde la raíz del repositorio. La forma correcta es
  `labs/**/entregables/**/*.md`.
- **Agente con todas las herramientas.** Un agente de soporte comercial no necesita `edit`
  ni `execute`. Es la conversación de seguridad del capítulo 2 en un caso concreto.
- **Huecos `COMPLETAR` que quedan en el archivo.** El paso 3 los detecta.
- **Artefacto guardado fuera de `.github/`.** Copilot no lo descubre.

## Tiempos

| Paso | Estimado | Observado en la verificación |
|---|---|---|
| 1 | 7 min | 19 s de agente. El tiempo real es la decisión del participante |
| 2 | 12 min | 29 a 36 s de agente, más las preguntas que hace al participante |
| 3 | 10 min | 13 s de agente, más las dos pruebas que ejecuta el participante |
| 4 | 8 min | 15 s de agente |

Suma estimada 37 minutos. Quedan 8 para la conversación de sala.

## Si alguien se atrasa

Si al minuto 20 un participante no tiene artefacto, entréguele el de respaldo que
corresponda a su tipo. Están solo en el repositorio de construcción, en
`docs/relator/respaldo-lab-2-4/`:

- `soporte-comercial.agent.md`, para la tarea A. Se guarda en `.github/agents/`.
- `documentacion-del-equipo.instructions.md`, para la tarea C. Se guarda en
  `.github/instructions/`.

La forma de entregarlo depende de la sala. Lo más simple es compartir el archivo por el
canal de la clase y que el participante lo guarde en la carpeta indicada desde el
explorador de archivos de Visual Studio Code. Con el archivo en su lugar, sigue en el
paso 3.

Los respaldos no están en el repositorio de participantes a propósito. Si estuvieran,
cualquiera podría copiar la respuesta.

## Puesta en común

Pregunte quién eligió agente y quién instrucción para tareas parecidas, qué hizo que la
elección fuera correcta y cuál de los artefactos usarían mañana en su repositorio real.

## Solución de referencia

Los respaldos cumplen esa función. Validan con el mismo formato que exige el paso 3.
