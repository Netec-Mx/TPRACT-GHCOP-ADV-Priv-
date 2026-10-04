---
name: lab-2-4-paso-4-ajustar-y-documentar
description: 'Lab 2.4 paso 4. Corrige lo que falló en la prueba del artefacto y agrega lo que otro integrante del equipo necesita para usarlo.'
disable-model-invocation: true
---

# Objetivo

Dejar el agente o la instrucción del participante listo para que otro integrante del
equipo lo use sin preguntar.

# Qué hacer

1. Busca el artefacto del participante en `.github/agents/` o `.github/instructions/`.
   Los que ya existían son `analista`, `tester`, `documentador`, `revisor`,
   `refactorizador`, `java`, `dotnet` y `arquitectura-bian`. Si dudas, el del participante
   es el que aparece como nuevo en `git status`.
2. Pregunta al participante, en una sola pregunta, qué falló en la prueba del paso 3. Si
   no falló nada, dilo y pasa al punto 4.
3. Corrige solo lo que falló.
4. Revisa que `description` diga para qué sirve el artefacto y cuándo usarlo, en una
   oración que alguien que no estuvo en el taller entienda.
5. Si es un agente, agrega al final del cuerpo una sección «Cómo usarlo» con un ejemplo
   de pedido de una línea.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Modifica solo el artefacto del participante.

# Salida esperada

El diff completo del artefacto, mostrado en el chat, no un resumen, y una línea que diga qué
cambió y por qué. Si el artefacto no está versionado, que es lo habitual porque se creó en
este laboratorio, `git diff` sale vacío: muéstralo con `git diff --no-index /dev/null
<archivo>`. Si está versionado, con `git diff -- <archivo>`. Para saber cuál es el caso, usa
`git ls-files --error-unmatch <archivo>`. `git diff --no-index` termina con código 1
cuando hay diferencias: es lo normal, no un error. Si el diff sale vacío, di que el artefacto
no tiene cambios respecto de lo confirmado.
