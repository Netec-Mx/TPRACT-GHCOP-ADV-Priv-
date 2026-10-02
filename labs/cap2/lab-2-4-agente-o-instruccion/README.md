# Laboratorio 2.4. Creación de un agente local o una instrucción reutilizable

## Objetivo del laboratorio

Construir un artefacto de personalización de Copilot para una tarea concreta del equipo,
comprobar que Copilot lo aplica y dejarlo listo para que lo use otro integrante. Construyes
**uno**, un agente local o una instrucción reutilizable, no los dos.

## Duración

45 minutos.

## Prerrequisitos

- Haber visto en la demostración los artefactos que ya trae el repositorio en
  `.github/agents/`, `.github/instructions/` y `.github/skills/`.
- Punto de partida limpio. Desde la raíz del repositorio, en Git Bash:

  ```bash
  bash scripts/reiniciar-lab.sh lab-2-4
  ```

- Material del laboratorio en este directorio:
  - [`tareas.md`](tareas.md), las cuatro tareas entre las que eliges.
  - [`plantillas/plantilla.agent.md`](plantillas/plantilla.agent.md) y
    [`plantillas/plantilla.instructions.md`](plantillas/plantilla.instructions.md), con los
    huecos marcados `COMPLETAR`.
- Todos los pasos se hacen en modo **Agent**.

## Pasos

| Paso | Qué escribir en el chat | Qué observar | Tiempo |
|---|---|---|---|
| 1 | `/lab-2-4-paso-1-elegir-tarea` | El criterio para elegir entre agente e instrucción. Responde la pregunta del agente con la letra de tu tarea | 7 min |
| 2 | `/lab-2-4-paso-2a-construir-instruccion C` o `/lab-2-4-paso-2b-construir-agente A`, con la letra que elegiste | Qué decisiones te pregunta el agente y cuáles toma solo | 12 min |
| 3 | `/lab-2-4-paso-3-probar-artefacto`, y luego las dos pruebas que propone | Si Copilot aplica tu artefacto. En una instrucción, que aparezca entre las referencias de la respuesta cuando el agente crea o modifica un archivo que coincide con el patrón. En un agente, que aparezca en el selector de agentes y se quede en su rol | 10 min |
| 4 | `/lab-2-4-paso-4-ajustar-y-documentar` | Si otro integrante entendería para qué sirve con leer `description` | 8 min |

**Orden de las pruebas del paso 3.** Ejecuta primero la prueba 1 y después la prueba 2. Si
tu artefacto es una instrucción, la segunda prueba trabaja sobre el archivo que crea la
primera. Si la primera no creó el archivo, no ejecutes la segunda.

Si en el paso 2 no alcanzas a tener un artefacto que funcione, avísale al relator. Te va a
entregar uno de respaldo para que hagas los pasos 3 y 4.

## Resultado esperado

- Un archivo nuevo, en `.github/instructions/` o en `.github/agents/`, sin huecos
  `COMPLETAR`.
- Dos pruebas ejecutadas en el chat que muestran que Copilot lo aplica.

## Criterios de revisión

- [ ] El artefacto resuelve una de las cuatro tareas de `tareas.md` y no duplica ninguno de
      los que ya trae el repositorio.
- [ ] Una instrucción tiene un patrón `applyTo` que apunta a los archivos de la tarea, y la
      viste aplicarse al pedirle al agente que cree o modifique uno de ellos.
- [ ] Un agente declara solo las herramientas que su tarea necesita.
- [ ] Viste a Copilot aplicarlo en el chat.
- [ ] `description` dice qué hace y cuándo usarlo, en una oración.
