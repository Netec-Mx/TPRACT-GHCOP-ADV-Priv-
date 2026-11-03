# Notas del relator, hook de protección de datos

Material del relator. Explica el hook de `.github/hooks/` y trae una demostración opcional.

## Qué hace

`.github/hooks/proteger-datos-escenario.json` registra un hook `PreToolUse`. Visual Studio
Code lo ejecuta antes de cada herramienta que el agente quiere usar. El script
`proteger-datos-escenario.js` revisa la herramienta y sus argumentos.

- Si la herramienta crea, modifica o borra un archivo dentro de `escenario/datos/`, la
  bloquea. Decide por la ruta de destino, no por el contenido. Lo mismo con un comando de
  terminal que escribe en esa carpeta por redirección, `sed -i`, `tee`, `cp` hacia ella, o que
  mueve o borra uno de sus archivos.
- Todo lo demás pasa. Leer los datos, ejecutar la liquidación con `../datos`, editar
  `escenario/java/` y `escenario/dotnet/`, crear `.vscode/mcp.json` y escribir entregables en
  `labs/` o documentos en `docs/` aunque citen la ruta `escenario/datos/`.

Al bloquear, el agente recibe el mensaje «Los datos del escenario están protegidos y no se
pueden modificar. Ningún laboratorio requiere cambiar los archivos de escenario/datos/.».

## Cómo bloquea

El script termina siempre con código 0. Para bloquear escribe en la salida estándar un JSON
con la decisión y el motivo; para dejar pasar no escribe nada.

```json
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Los datos del escenario están protegidos..."},"permissionDecision":"deny","permissionDecisionReason":"Los datos del escenario están protegidos..."}
```

La decisión va dentro de `hookSpecificOutput`, que es lo que lee Visual Studio Code, y
repetida en el primer nivel, que es lo que lee Copilot CLI. Las tildes van escapadas para
que el motivo llegue intacto aunque la consola de Windows use otra página de códigos.

**Por qué código 0 y no código 2.** La referencia de Visual Studio Code acepta las dos
formas: el código 2 bloquea con el texto de la salida de error, y el código 0 procesa la
salida estándar, donde `permissionDecision` en `deny` bloquea la herramienta. El hook usaba
el código 2. En Windows, Visual Studio Code lo ejecuta a través de Windows PowerShell, que
devuelve 1 cuando el proceso termina con 2. Con cualquier código distinto de 0 y de 2,
Visual Studio Code solo muestra una advertencia y la herramienta se ejecuta: el agente
editaba los datos igual. Lo reportó el relator en la máquina virtual Windows. Con código 0 y
el JSON, el bloqueo no depende del intérprete que ejecute el hook.

Para probarlo en Windows como lo ejecuta Visual Studio Code:

```
'{"tool_name":"editFiles","tool_input":{"files":["escenario/datos/planes.txt"]}}' | powershell -NoProfile -Command "node .github/hooks/proteger-datos-escenario.js"; $LASTEXITCODE
```

Tiene que mostrar el JSON de denegación y después `0`.

## Por qué existe

Tres transacciones de `escenario/datos/transacciones.txt`, de TX002035 a TX002037, se
agregaron a mano para que el error de punto flotante sea visible en la salida (DEF-01). Si
un agente regenera o edita esos datos, el defecto principal puede desaparecer sin que nada
falle, y el problema se descubre frente a la sala. El `AGENTS.md` de los participantes solo
dice que hay un hook, sin explicar qué protege, para no señalar dónde está el ejercicio.

El hook es además un ejemplo concreto de gobierno. La sesión de apertura mostró que existen
hooks para bloquear acciones del agente antes de que ocurran. Este es uno de verdad.

## Límites que conviene conocer

- Es preventivo y heurístico. Reconoce las herramientas de edición por su nombre y su ruta
  por los argumentos que nombran archivos, y los comandos de terminal por patrones como `rm`,
  `mv`, `sed -i` o una redirección hacia la carpeta, tramo por tramo. Un comando que escribe
  por un camino que el patrón no reconoce puede pasar.
- Antes revisaba también el contenido: en la prueba con Copilot CLI bloqueó el caso
  de uso del 3.4 y la descripción del pull request del 5.3 porque citaban la ruta, y Copilot
  tuvo que reformular las citas. Ahora esos casos pasan.
- Funciona igual en Visual Studio Code y en Copilot CLI: lee las dos formas de entrada,
  `tool_name` y `tool_input`, o `toolName` y `toolArgs`.
- Sus casos están en `herramientas/probar-hook.sh`, que corre en los gates: doce que deben
  bloquearse y diez que deben pasar.
- No protege de lo que haga una persona a mano. `bash scripts/reiniciar-lab.sh` restaura los
  datos si alguien los tocó.
- Si la entrada del hook no se puede leer, deja pasar la acción, para no bloquear el trabajo
  del participante por una falla del hook.
- La documentación de Visual Studio Code no lista los nombres exactos de las herramientas.
  El script reconoce los nombres por patrón. En Windows el comando del hook pasa por Windows
  PowerShell, que cambia el código de salida 2 por 1; por eso el bloqueo va en el JSON con
  código 0, como se explica arriba. Su funcionamiento con Copilot real se confirma en el
  bloque A del protocolo de prueba de la máquina virtual.

Fuentes, consultadas el 3 de noviembre de 2026.

- https://code.visualstudio.com/docs/agent-customization/hooks
- https://code.visualstudio.com/docs/agents/reference/hooks-reference

## Demostración opcional, dos minutos

Fuera del camino obligatorio. Sirve en el capítulo 2, al hablar de gobierno de agentes, o
en el 3, al hablar de controles.

1. En el chat, modo **Agent**, pida:

   ```
   Agrega una transacción de prueba al final de escenario/datos/transacciones.txt.
   ```

2. La sala ve que el agente intenta editar el archivo y recibe el bloqueo con el mensaje.
3. Pida después algo permitido sobre el mismo archivo, por ejemplo «¿cuántas transacciones
   tiene escenario/datos/transacciones.txt?». Pasa, porque solo lee.
4. Abra `.github/hooks/proteger-datos-escenario.json` y muestre que el control es un archivo
   del repositorio, versionado y revisable como cualquier otro.

Si el agente no intenta la edición y solo propone el cambio, pídale que lo aplique.
