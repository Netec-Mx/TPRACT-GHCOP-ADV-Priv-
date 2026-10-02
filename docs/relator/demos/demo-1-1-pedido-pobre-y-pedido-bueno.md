# Demostración 1.1. El pedido pobre y el pedido bueno

**Objetivo.** Mostrar que el mismo pedido, con objetivo, contexto, restricciones y salida
esperada, produce un resultado que se puede usar y comparar.

**Subtema y sesión.** 1.1, sesión 1. **Duración.** 8 minutos.

**Antes de empezar.** Repositorio de participantes abierto, en su punto de partida. El chat
abierto en modo **Ask**. Dos conversaciones listas, una por pedido. El archivo
`escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java` abierto en
el editor.

Se usa `FormateadorReporte` y no la clase de cálculo a propósito. La clase de cálculo es la
del laboratorio 1.4, que viene después.

## Pasos

1. En la primera conversación, escriba:

   ```
   Mejora este código.
   ```

   Diga: «Esto es lo que escribimos casi todos cuando tenemos apuro.»

   **Debería pasar.** Una respuesta larga, con sugerencias de todo tipo, de estilo, de
   nombres, de rendimiento, quizás un cambio de tipos. Difícil de evaluar y distinta en
   cada máquina.

2. En la segunda conversación, escriba:

   ```
   Objetivo: identificar las dos mejoras de legibilidad más útiles en formatearDetalle.
   Contexto: #file:escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java
   Restricciones: no cambies el comportamiento, no cambies tipos de datos, no propongas bibliotecas nuevas, no modifiques archivos.
   Salida: una tabla con mejora, líneas afectadas y riesgo de cambiar la salida.
   ```

   Diga: «Mismo modelo, mismo archivo. Cambia lo que le dimos.»

   **Debería pasar.** Una tabla de dos filas con rangos de líneas concretos.

3. Ponga las dos respuestas lado a lado y pregunte a la sala cuál usarían en un pull
   request y por qué.

## Qué puede salir distinto

- El pedido pobre puede salir razonable. Pregunte si dos personas en la sala obtendrían lo
  mismo con ese pedido. Esa es la diferencia que importa.
- Si el modelo propone cambiar `double` por otro tipo en el pedido pobre, no lo comente
  como defecto. Diga que el pedido no le dio ningún límite.
- Si el chat demora, use [`../respaldos/demo-1-1.md`](../respaldos/demo-1-1.md).

## La idea que se cierra

Un pedido tiene cuatro partes. Objetivo, contexto, restricciones y salida esperada. Las que
faltan las completa el modelo como puede.
