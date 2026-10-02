# Demostración 2.1. La jerarquía de personalización y las skills

**Objetivo.** Mostrar las instrucciones del repositorio activas sin que nadie las invoque,
una skill del dominio invocada por nombre y la velocidad con que cambian estos artefactos.

**Subtema y sesión.** 2.1, sesión 2. **Duración.** 10 minutos.

**Antes de empezar.** Repositorio de participantes abierto. Chat en modo **Ask**. El
explorador de archivos con `.github/` desplegado.

## Pasos

1. Muestre `.github/` en el explorador. `copilot-instructions.md`, `instructions/`,
   `agents/`, `skills/` y `hooks/`.

   Diga: «Todo esto es contexto que el equipo deja escrito para que no dependa de quién
   pide.»

2. Conversación nueva. Escriba:

   ```
   ¿En qué idioma tengo que escribir los mensajes de commit en este repositorio?
   ```

   **Debería pasar.** «En español», citando `copilot-instructions.md` entre las
   referencias. Muéstrelo. Nadie lo invocó.

3. Abra `.github/skills/pasarela-reglas-de-negocio/SKILL.md`. Muestre el encabezado con
   `name` y `description`, y el cuerpo con enlaces a los datos.

   Diga: «Una skill es una carpeta con un `SKILL.md`. La descripción le dice al agente
   cuándo usarla.»

4. Modo **Agent**, conversación nueva. Escriba:

   ```
   /pasarela-reglas-de-negocio ¿qué tramo y qué porcentaje le corresponden a una venta de 750 soles del comercio CM0001?
   ```

   **Debería pasar.** El plan del comercio, el tramo de 500 a 2000 y el porcentaje, leídos
   de los datos.

5. Muestre una skill de laboratorio, por ejemplo
   `.github/skills/lab-1-4-paso-1-prompt-vago/SKILL.md`, y su línea
   `disable-model-invocation: true`.

   Diga: «Las del dominio se pueden cargar solas cuando son relevantes. Las de laboratorio
   no, para que un laboratorio no contamine a otro.»

6. Cuente la migración. «Hasta septiembre este material usaba prompt files. La
   documentación de Visual Studio Code los declaró en retiro y recomendó skills. Hubo que
   rehacer treinta y cinco pasos semanas antes del taller.»

## Qué puede salir distinto

- En el paso 2 la instrucción puede no figurar en las referencias aunque la respuesta sea
  correcta. Abra `copilot-instructions.md` y muestre la regla.
- En el paso 4 el modelo puede no usar la skill. Despliegue las referencias. Si no aparece,
  pruebe de nuevo escribiendo el nombre completo con la barra y elíjala de la lista.
- Si algo demora, use [`../respaldos/demo-2-1.md`](../respaldos/demo-2-1.md).

## La idea que se cierra

Instrucciones siempre activas, instrucciones por ruta, skills y agentes son capas de
contexto escrito. Y son artefactos vivos. Uno de ellos cambió de estado mientras se armaba
este taller.
