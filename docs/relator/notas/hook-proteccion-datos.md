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
- Hasta SPEC-024 revisaba también el contenido: en la prueba con Copilot CLI bloqueó el caso
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
- La documentación de Visual Studio Code al 30 de septiembre de 2026 no dice qué intérprete
  ejecuta el comando del hook en Windows ni lista los nombres exactos de las herramientas.
  El script usa Node, que funciona desde cualquier intérprete, y reconoce los nombres por
  patrón. Su funcionamiento con Copilot real se confirma en el bloque A del protocolo de
  prueba de la máquina virtual.

Fuentes, consultadas el 30 de septiembre de 2026.

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
