# Demostración 4.1. La documentación contra la ejecución

**Objetivo.** Generar la documentación de un método, ejecutarlo con casos concretos y
comparar lo que dice el documento con lo que hace el código.

**Subtema y sesión.** 4.1, sesión 4. **Duración.** 8 minutos.

**Antes de empezar.** Repositorio de participantes abierto. Git Bash en la raíz. El
escenario Java compilado, con `mvn -q -f escenario/java/pom.xml compile`. Chat en modo
**Ask**.

Se usa `UtilidadesFecha.mesesEntre` a propósito. No es la clase de los comentarios del
laboratorio 4.4, que la sala no debe ver antes.

## Pasos

1. Escriba:

   ```
   #file:escenario/java/src/main/java/pe/pasarelaandina/calculo/UtilidadesFecha.java Documenta en Markdown el método mesesEntre y da el resultado esperado para estos casos: del 2026-01-31 al 2026-02-28, del 2026-01-15 al 2026-02-15, del 2025-12-31 al 2026-06-01 y del 2026-03-10 al 2026-03-09.
   ```

   **Debería pasar.** Una descripción del método y una tabla con cuatro resultados.

2. En Git Bash, ejecute el método con los mismos casos.

   ```bash
   printf '%s\n' 'var u = new pe.pasarelaandina.calculo.UtilidadesFecha();' 'for (String[] c : new String[][]{{"2026-01-31","2026-02-28"},{"2026-01-15","2026-02-15"},{"2025-12-31","2026-06-01"},{"2026-03-10","2026-03-09"}}) System.out.println(c[0] + " -> " + c[1] + " = " + u.mesesEntre(u.parsearFecha(c[0]), u.parsearFecha(c[1])));' '/exit' | jshell -q --class-path escenario/java/target/classes
   ```

   **Debería pasar.** Cuatro líneas con los resultados reales, que son 0, 1, 5 y -1. Antes
   de ellas, `jshell` repite las líneas que recibió. Señale solo las cuatro de resultados.

3. Compare la tabla del documento con la salida, caso por caso.

   Diga: «El documento se escribió leyendo el código. La salida es lo que el código hace.
   Cuando no coinciden, manda la ejecución.»

## Qué puede salir distinto

- El documento puede acertar los cuatro casos. Pregunte a la sala cómo lo sabrían sin haber
  ejecutado nada. La idea se sostiene igual.
- El caso del 2026-03-10 al 2026-03-09 da -1. Si el documento dice 0, es el mejor momento
  de la demostración.
- Si `jshell` no está disponible, use [`../respaldos/demo-4-1.md`](../respaldos/demo-4-1.md).

## La idea que se cierra

La documentación generada se verifica contra la ejecución, no contra el texto. En el
laboratorio 4.4 van a tener que hacerlo sin que nadie les diga dónde mirar.
