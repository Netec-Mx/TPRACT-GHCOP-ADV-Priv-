# Demostración 2.3. Las instrucciones por ruta

**Objetivo.** Mostrar que la misma pregunta sobre un archivo Java y sobre uno .NET recibe
reglas distintas, y que `AGENTS.md` es el contexto portable que leen otros editores y la
línea de comandos.

**Subtema y sesión.** 2.3, sesión 2. **Duración.** 8 minutos.

**Antes de empezar.** Repositorio de participantes abierto. Chat en modo **Agent**.

## Pasos

1. Abra `.github/instructions/java.instructions.md` y `dotnet.instructions.md`. Muestre el
   `applyTo` de cada una.

2. Conversación nueva. Escriba:

   ```
   ¿Qué comando uso para correr las pruebas de escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java y con qué framework se escriben?
   ```

   **Debería pasar.** `mvn test` y JUnit 5, con `java.instructions.md` en las referencias.

3. Conversación nueva. La misma pregunta sobre
   `escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporte.cs`.

   **Debería pasar.** `dotnet test` y xUnit, con `dotnet.instructions.md` en las
   referencias.

   Diga: «Mismo pedido, reglas distintas según dónde cae el archivo.»

4. Abra `.github/instructions/arquitectura-bian.instructions.md` y, al lado,
   `docs/arquitectura/bian-mapeo.md`. Muestre que su `applyTo` apunta a
   `docs/arquitectura/**` y `docs/proyecto/**`, no al código.

   Diga: «Esta es una instrucción de repositorio corporativo. No es de un lenguaje, es de
   la arquitectura de referencia del banco. Pide usar el vocabulario de los dominios de
   servicio BIAN y remite al mapeo, en lugar de copiar el estándar. Se aplica cuando el
   agente escribe un documento de arquitectura, así que no cambia lo que hace sobre el
   código.»

5. Muestre la instrucción BIAN aplicándose. Conversación nueva, modo **Agent**. Escriba:

   ```
   Crea docs/proyecto/nota-arquitectura.md con un párrafo que explique en qué parte de la arquitectura vive el cálculo de comisiones de la liquidación.
   ```

   **Debería pasar.** `arquitectura-bian.instructions.md` aparece en las referencias,
   porque el archivo cae en `docs/proyecto/**`. El párrafo nombra el dominio de servicio
   en inglés, como en el mapeo, **Merchant Acquiring Facility**, y remite a
   `docs/arquitectura/bian-mapeo.md` en lugar de copiar la definición del estándar.

   Diga: «La misma instrucción que acabamos de leer, aplicada sola porque el archivo cae en
   su ruta.»

   Al terminar, en Git Bash, deje el repositorio como estaba:

   ```bash
   bash scripts/reiniciar-lab.sh lab-5-1 --confirmar
   ```

6. Abra `AGENTS.md` en la raíz.

   Diga: «Este archivo no es de Visual Studio Code. Es un formato que leen varios agentes,
   incluida la línea de comandos de Copilot. Es el lugar para lo que el equipo quiere que
   cualquier herramienta sepa.»

## Qué puede salir distinto

- La instrucción por ruta se adjunta con seguridad cuando el agente crea o modifica un
  archivo que coincide con el patrón. Si en una pregunta no aparece en las referencias,
  pida un cambio mínimo en el archivo y muéstrela ahí. Después reinicie con
  `bash scripts/reiniciar-lab.sh lab-1-4 --confirmar`.
- Si en el paso 5 la instrucción BIAN no aparece en las referencias, pida un cambio mínimo
  al archivo recién creado y muéstrela ahí.
- Si algo demora, use [`../respaldos/demo-2-3.md`](../respaldos/demo-2-3.md).

## La idea que se cierra

Instrucciones generales para todo el repositorio, instrucciones por ruta para cada stack o
para cada zona, como la arquitectura, y `AGENTS.md` para cualquier herramienta. En un repositorio corporativo, ese reparto es lo que
evita una sola instrucción enorme que nadie mantiene.
