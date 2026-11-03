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

   Abra `docs/gobierno/politica-uso-ia.md` en la regla 3. Diga: «Esta es la regla de la
   política que el hook impone. Las reglas que solo están en las instrucciones se le piden
   al agente. Esta se le impide.»

4. En Git Bash, `git status`. Limpio.

## Plan alternativo

Los hooks estaban en vista previa al armar el taller. Si el hook no corre en su máquina, es
decir, si el agente modifica el archivo en el paso 1 o Visual Studio Code solo muestra una
advertencia del hook:

1. Restaure con `bash scripts/reiniciar-lab.sh lab-1-4 --confirmar`.
2. Muestre `proteger-datos-escenario.json` y `proteger-datos-escenario.js` y explique qué
   hace.
3. Muestre la ejecución grabada en [`../respaldos/demo-3-3.md`](../respaldos/demo-3-3.md).
4. Diga que es una función en vista previa y que por eso se verifica en cada ambiente.

Si alguien pregunta cómo bloquea: el script responde un JSON con `permissionDecision` en
`deny` y termina con código 0. No usa el código 2, que la documentación también acepta,
porque en Windows Visual Studio Code ejecuta el hook a través de Windows PowerShell, que
convierte el 2 en 1, y con 1 solo hay una advertencia. El detalle está en
[`../notas/hook-proteccion-datos.md`](../notas/hook-proteccion-datos.md).

## La idea que se cierra

Las instrucciones le piden al agente que no haga algo. Un hook se lo impide. En un banco, lo
que no puede pasar se controla con lo segundo.
