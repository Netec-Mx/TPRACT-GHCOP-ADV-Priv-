---
name: lab-2-4-paso-3-probar-artefacto
description: 'Lab 2.4 paso 3. Revisa el agente o la instrucción construidos y propone dos pruebas concretas para comprobar que Copilot los aplica.'
disable-model-invocation: true
---

# Objetivo

Comprobar que el artefacto construido en el paso 2 está bien formado y preparar dos
pruebas que el participante ejecuta para ver que Copilot lo aplica.

# Qué hacer

1. Busca en `.github/agents/` y `.github/instructions/` el artefacto nuevo del
   participante, es decir, el que no figura en la lista de abajo. Si no hay ninguno,
   dilo y termina: el participante necesita el artefacto de respaldo del relator.
2. Revisa su formato:
   - Instrucción: metadatos `name`, `description` y `applyTo`, y a qué archivos apunta el
     patrón.
   - Agente: metadatos `name`, `description` y `tools`, con herramientas que existan en
     Visual Studio Code, como `read`, `search`, `edit` o `execute`.
   - Que no queden huecos `COMPLETAR`.
3. Escribe dos pruebas, cada una con el texto exacto a escribir en el chat, de no más
   de una línea, y lo que debe verse si el artefacto se aplica:
   - Instrucción: en modo agente, pedir que cree o modifique un archivo que coincide con
     el patrón. La instrucción aparece en la lista de referencias de la respuesta y el
     archivo cumple sus reglas. Si el patrón no coincide con ningún archivo existente, la
     prueba crea uno nuevo, dentro de `labs/cap2/lab-2-4-agente-o-instruccion/entregables/`
     para la tarea C o de `scripts/` para la tarea D.
   - Agente: seleccionado en el selector de agentes del chat, responde dentro de su rol
     y rechaza algo fuera de su rol.

Artefactos que ya existían y no son del participante: `analista.agent.md`,
`tester.agent.md`, `documentador.agent.md`, `revisor.agent.md`,
`refactorizador.agent.md`, `java.instructions.md`, `dotnet.instructions.md` y
`arquitectura-bian.instructions.md`.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques el artefacto. Si tiene errores, lístalos para el paso 4.

# Salida esperada

Los errores de formato encontrados, o que no hay ninguno, y las dos pruebas.
