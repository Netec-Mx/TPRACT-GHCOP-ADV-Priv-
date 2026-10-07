# Demostración 2.2. Los agentes por rol

**Objetivo.** Mostrar que un agente con rol y herramientas acotadas se comporta distinto
del agente general, y que los límites escritos se respetan.

**Subtema y sesión.** 2.2, sesión 2. **Duración.** 10 minutos.

**Antes de empezar.** Repositorio de participantes en su punto de partida. Git Bash
abierto. `.github/agents/revisor.agent.md` y `refactorizador.agent.md` abiertos en el
editor.

## Pasos

1. Abra el selector de modo del chat y muestre los cinco agentes. Analista, Tester,
   Documentador, Revisor y Refactorizador.

2. Muestre el encabezado de `revisor.agent.md`, con `tools: ['read', 'search']`.

   Diga: «El revisor no tiene herramientas de edición. No es que se le pida no editar. No
   puede.»

3. Seleccione **Revisor**. Escriba:

   ```
   Revisa FormateadorReporte.java y corrige lo que encuentres.
   ```

   **Debería pasar.** Una tabla de hallazgos clasificados y ningún cambio. Si dice que no
   puede editar, mejor. Muestre `git status` limpio.

4. Seleccione **Refactorizador**. Escriba:

   ```
   En escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java extrae la cabecera de formatearDetalle a un método privado.
   ```

   **Debería pasar.** Dice qué archivo y qué bloque va a tocar, aplica el cambio, compila y
   corre el comparador. Al final menciona otros problemas que vio y no tocó.

   Diga: «Fíjense en la última parte. Vio cosas y no las corrigió. Está escrito en su
   archivo.»

5. Muestre el diff en Git Bash con `git diff --stat`. Un solo archivo.

6. Restaure con `bash scripts/reiniciar-lab.sh lab-1-4 --confirmar`.

## Qué puede salir distinto

- El refactorizador puede no correr el comparador. Señálelo como lo que un revisor humano
  tendría que pedir.
- Si toca algo fuera del bloque, muéstrelo. Es la razón de revisar el diff.
- Si algo demora, use [`../respaldos/demo-2-2.md`](../respaldos/demo-2-2.md).

## La idea que se cierra

Un agente por rol es contexto más permisos. El rol dice qué hacer y las herramientas
definen qué puede hacer. El segundo control es más fuerte que el primero.
