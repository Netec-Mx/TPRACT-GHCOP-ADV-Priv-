# Demostración 1.2. Las referencias de contexto

**Objetivo.** Mostrar qué cambia cuando se referencia el archivo correcto, cuando se
referencia uno incorrecto y cuando no se referencia nada.

**Subtema y sesión.** 1.2, sesión 1. **Duración.** 8 minutos.

**Antes de empezar.** Repositorio de participantes abierto. Chat en modo **Ask**. Ningún
archivo abierto en el editor, para que el contexto implícito no ayude.

## Pasos

1. Conversación nueva. Escriba:

   ```
   ¿Cómo se calcula la retención de garantía de un comercio en este sistema?
   ```

   **Debería pasar.** Una respuesta genérica o una búsqueda propia del modelo. Despliegue
   la lista de referencias y muestre qué usó.

2. Conversación nueva. Escriba:

   ```
   #file:escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java ¿Cómo se calcula la retención de garantía de un comercio en este sistema?
   ```

   Diga: «Le dimos un archivo, pero el equivocado.»

   **Debería pasar.** El modelo dice que en ese archivo solo se suma la retención ya
   calculada, o inventa una explicación a partir de lo que ve. Las dos sirven.

3. Conversación nueva. Escriba:

   ```
   #file:escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java ¿Cómo se calcula la retención de garantía de un comercio en este sistema?
   ```

   **Debería pasar.** La regla concreta, con la condición de antigüedad, la base de cálculo
   y el porcentaje, citando las líneas.

4. Conversación nueva. Escriba:

   ```
   #codebase ¿Cómo se calcula la retención de garantía de un comercio en este sistema?
   ```

   Diga: «Esta es la forma vigente de pedir el repositorio completo. Algunos materiales
   todavía hablan de `/workspace`, que ya no existe.»

   **Debería pasar.** El modelo encuentra la clase correcta por su cuenta, con más demora.

## Qué puede salir distinto

- En el paso 1 el modelo puede encontrar la respuesta solo. Muestre en las referencias qué
  archivos leyó y pregunte si eso pasaría igual en un repositorio de mil clases.
- Si el chat demora, use [`../respaldos/demo-1-2.md`](../respaldos/demo-1-2.md).

## La idea que se cierra

El modelo responde sobre lo que tiene en el contexto. Elegir qué entra es trabajo de quien
pide, y la lista de referencias es la forma de comprobar qué entró.

Al terminar, siga con el caso de clase de la configuración regional.
