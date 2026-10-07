# Demostración 1.3. Analizar, planear, implementar y validar

**Objetivo.** Llevar un mismo pedido por los cuatro pasos del flujo, usando en cada uno el
modo de trabajo que conviene y verificando antes de pasar al siguiente.

**Subtema y sesión.** 1.3, sesión 1. **Duración.** 10 minutos.

**Antes de empezar.** Repositorio de participantes en su punto de partida. Un Git Bash
abierto en la raíz. Chat abierto. El archivo `FormateadorReporte.java` abierto en el
editor.

## Pasos

1. **Analizar, en modo Ask.** Escriba:

   ```
   #file:escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java ¿Qué partes de formatearDetalle se podrían separar en métodos sin cambiar la salida?
   ```

   Diga: «Ask no toca nada. Es el modo más barato y el que conviene para entender.»

   **Debería pasar.** Una lista de candidatos. Uno suele ser la cabecera del detalle.

2. **Planear, con `/plan`.** Escriba:

   ```
   /plan extraer la cabecera de formatearDetalle a un método privado sin cambiar la salida
   ```

   Diga: «Plan propone pasos y no escribe código. Se revisa el plan antes de aprobarlo.»

   **Debería pasar.** El selector cambia a **Plan** y aparece un plan corto con un paso de
   validación. Si el plan no menciona cómo validar, señálelo.

3. **Implementar, en modo Agent.** Elija **Start Implementation** o cambie el selector a
   **Agent** y pida que aplique el plan.

   Diga: «Agent es el modo que más hace y el que más consume. Por eso llega último.»

   **Debería pasar.** Un único archivo modificado, con un método privado nuevo.

4. **Validar.** En Git Bash:

   ```bash
   git status
   bash scripts/comparar-escenarios.sh
   ```

   **Debería pasar.** Un archivo modificado y «Las salidas son identicas».

5. Restaure el escenario:

   ```bash
   bash scripts/reiniciar-lab.sh lab-1-4 --confirmar
   ```

## Qué puede salir distinto

- El agente puede tocar algo más que la cabecera. Muéstrelo en el diff. Es el motivo del
  paso de validación.
- Si el comparador falla, mejor todavía. La validación detectó un cambio de comportamiento
  antes de que llegara a un pull request.
- Si algo demora, use [`../respaldos/demo-1-3.md`](../respaldos/demo-1-3.md).

## La idea que se cierra

Cada paso tiene su modo y su verificación. Analizar y planear cuestan poco y evitan que el
agente implemente lo que no se quería. Validar no es opcional. Y este mismo ciclo corto se
repite dentro de cada una de las once fases del ciclo de vida que acaba de ver en la tabla.
