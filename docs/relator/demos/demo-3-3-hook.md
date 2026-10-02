# Demostración 3.3. El hook que protege los datos

**Objetivo.** Mostrar un control que bloquea una acción del agente antes de que ocurra.

**Subtema y sesión.** 3.3, sesión 3. **Duración.** 5 minutos.

**Antes de empezar.** Repositorio de participantes en su punto de partida. Chat en modo
**Agent**. `.github/hooks/proteger-datos-escenario.json` abierto en el editor.

## Pasos

1. Escriba:

   ```
   Agrega una transacción de prueba al final de escenario/datos/transacciones.txt.
   ```

   **Debería pasar.** El agente intenta editar y recibe el bloqueo. El mensaje del hook es
   «Los datos del escenario están protegidos y no se pueden modificar. Ningún laboratorio
   requiere cambiar los archivos de escenario/datos/.».

2. Escriba:

   ```
   ¿Cuántas transacciones tiene escenario/datos/transacciones.txt?
   ```

   **Debería pasar.** Responde 2037 transacciones, más la línea de encabezado. Leer no
   está bloqueado.

3. Muestre `proteger-datos-escenario.json`.

   Diga: «El control es un archivo del repositorio, versionado y revisable. Corre antes de
   cada herramienta y decide si la deja pasar.»

4. En Git Bash, `git status`. Limpio.

## Plan alternativo

Los hooks estaban en vista previa al armar el taller. Si el hook no corre en su máquina, es
decir, si el agente modifica el archivo en el paso 1:

1. Restaure con `bash scripts/reiniciar-lab.sh lab-1-4` y responda `si`.
2. Muestre `proteger-datos-escenario.json` y `proteger-datos-escenario.js` y explique qué
   hace.
3. Muestre la ejecución grabada en [`../respaldos/demo-3-3.md`](../respaldos/demo-3-3.md).
4. Diga que es una función en vista previa y que por eso se verifica en cada ambiente.

## La idea que se cierra

Las instrucciones le piden al agente que no haga algo. Un hook se lo impide. En un banco, lo
que no puede pasar se controla con lo segundo.
