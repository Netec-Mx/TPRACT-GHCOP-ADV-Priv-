segundos: 13

> Actualizado en SPEC-011-B. El hook imprime ahora el mensaje con tildes. Las salidas
> estándar y de error del paso 1 son las del hook corregido, ejecutado de nuevo con la misma
> entrada.

# Demo 3.3 simulada

## Paso 1
Texto: Agrega una transacción de prueba al final de escenario/datos/transacciones.txt.
Modo Agent. El agente decide editar con editFiles.
Hook: printf '%s' '{"tool_name":"editFiles","tool_input":{"files":["escenario/datos/transacciones.txt"]}}' | node .github/hooks/proteger-datos-escenario.js
Salida estandar:
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Los datos del escenario están protegidos y no se pueden modificar. Ningún laboratorio requiere cambiar los archivos de escenario/datos/."},"permissionDecision":"deny","permissionDecisionReason":"Los datos del escenario están protegidos y no se pueden modificar. Ningún laboratorio requiere cambiar los archivos de escenario/datos/."}
Error estandar: Los datos del escenario están protegidos y no se pueden modificar. Ningún laboratorio requiere cambiar los archivos de escenario/datos/.
Codigo de salida: 2 -> accion NO realizada.
Intento alterno por terminal (echo "TX_PRUEBA" >> escenario/datos/transacciones.txt): mismo bloqueo, exit 2, no ejecutado.
Respuesta del chat (simulada): "No pude agregar la transacción: un hook del repositorio bloqueó la edición con el mensaje «Los datos del escenario están protegidos y no se pueden modificar. Ningún laboratorio requiere cambiar los archivos de escenario/datos/.» Si necesitas una transacción de prueba, puedo proponerte el texto de la línea para que la agregues tú o usar otro archivo fuera de escenario/datos/."

## Paso 2
Texto: ¿Cuántas transacciones tiene escenario/datos/transacciones.txt?
Hook para lectura (readFile) exit 0; para run_in_terminal "wc -l escenario/datos/transacciones.txt" exit 0.
Comando: wc -l -> 2038; el archivo tiene encabezado (id;idComercio;monto;moneda;fechaHora;medioPago;cuotas;estado;codigoAutorizacion).
Respuesta del chat: "El archivo tiene 2.037 transacciones (2.038 líneas, contando la fila de encabezado)."

## Paso 3
Se muestra .github/hooks/proteger-datos-escenario.json (hooks.PreToolUse con type command, command "node .github/hooks/proteger-datos-escenario.js", timeout 10).

## Paso 4
git status: "On branch main / Untracked files: mcp-llamar.sh / nothing added to commit but untracked files present". Tras el bloqueo, transacciones.txt sigue con 2038 lineas y sin cambios. No es "limpio" literal por el archivo mcp-llamar.sh del simulador (no existiria en la maquina real).

## Esperado contra observado
- Paso 1: coincide en la sustancia, pero el mensaje real carece de tildes ("estan", "Ningun") y el guion cita «Los datos del escenario están protegidos y no se pueden modificar» (con tilde, y el mensaje real agrega una segunda oracion). Diferencia menor, visible en pantalla.
- Paso 2: coincide; el guion no da la cifra; es 2037 (no 2038 lineas).
- Paso 3: coincide.
- Paso 4: coincide salvo el archivo del simulador. No fue necesario el plan alternativo.
