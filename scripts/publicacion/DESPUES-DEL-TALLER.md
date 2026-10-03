# Después del taller

Qué te llevas, cómo pasarlo a un repositorio real del equipo y qué hacer en las semanas
siguientes.

## Qué quedó en este repositorio

| Activo | Dónde | Para qué sirve |
|---|---|---|
| Instrucciones de repositorio | `.github/copilot-instructions.md` | Reglas que Copilot aplica siempre, sin que nadie las pida |
| Instrucciones por ruta | `.github/instructions/` | Reglas propias de Java y de .NET, aplicadas según el archivo |
| Contexto portable | `AGENTS.md` | Lo que cualquier agente debe saber del repositorio, también fuera de Visual Studio Code |
| Agentes por rol | `.github/agents/` | Analista, tester, documentador, revisor y refactorizador, con herramientas acotadas |
| Skills | `.github/skills/` | Tareas repetibles que se invocan por nombre. Las `pasarela-` son ejemplos de dominio |
| Hook | `.github/hooks/` | Un control que bloquea acciones del agente antes de que ocurran |
| Servidor MCP | `mcp/` | Ejemplo de acceso a datos internos por un proceso local, sin red y de solo lectura |
| Tu agente o instrucción | `.github/agents/` o `.github/instructions/` | Lo que construiste en el laboratorio 2.4 |
| Entregables | `labs/*/*/entregables/` | Documentos de los laboratorios de los capítulos 1 a 4 |
| El ciclo de vida | `CICLO-DE-VIDA.md` y `docs/proyecto/` | La historia, la estimación, el registro de tiempos, el pull request, las notas de versión y el incidente del capítulo 5 |
| Skills del ciclo | `.github/skills/pasarela-*` | Historia de usuario, estimación, decisiones de arquitectura, notas de versión y análisis de incidentes, reutilizables en otro proyecto |
| Plantillas | `docs/proyecto/plantillas/` y `docs/operacion/` | Historia, estimación, registro de tiempos, notas de versión y runbook |
| Pipeline | `scripts/integracion-local.sh` y `.github/workflows/` | El mismo pipeline en local y en GitHub Actions, con la conciliación que agregaste |
| Medición y presupuesto | `docs/proyecto/medicion-y-presupuesto.md` | Línea base de adopción y presupuesto de créditos |

## Cómo llevarlo a un repositorio del equipo

1. **Empieza por las instrucciones de repositorio.** Copia `.github/copilot-instructions.md`
   y reemplaza lo que habla del escenario por las reglas reales del equipo. Deja solo
   reglas que se puedan verificar.
2. **Agrega las instrucciones por ruta.** Copia las de `.github/instructions/` y ajusta el
   `applyTo` a la estructura real del proyecto. Comprueba que el patrón coincida con
   archivos que existen.
3. **Escribe `AGENTS.md`.** Lo que cualquier agente debe saber, en una página. Qué es el
   proyecto, qué no se toca y cómo se compila y se prueba.
4. **Elige dos agentes, no cinco.** Los que el equipo vaya a usar de verdad. Revisa que sus
   herramientas sean las mínimas. Un revisor no necesita editar.
5. **Lleva tu agente o instrucción del 2.4.** Ya está hecho para una tarea del equipo.
6. **Convierte en skill una tarea que se repita.** Una carpeta en `.github/skills/` con un
   `SKILL.md`. Si no quieres que el agente la cargue solo, declara
   `disable-model-invocation: true`.
7. **Lleva el ciclo.** Las skills `pasarela-historia-de-usuario`, `pasarela-estimar`,
   `pasarela-registrar-decision`, `pasarela-notas-de-version` y `pasarela-analizar-incidente`
   y sus plantillas sirven en cualquier proyecto. Cambia las rutas y las reglas del dominio.
   Tu `docs/proyecto/registro-de-tiempos.md` es el primer dato real para estimar el próximo
   cambio.
8. **Revisa todo en un pull request,** como cualquier otro código. Estos archivos cambian el
   comportamiento del agente para todo el equipo.

`scripts/validar-skills.sh` sirve también en tu repositorio para revisar el formato de las
skills.

## La medición

`docs/proyecto/medicion-y-presupuesto.md`, del laboratorio 5.4, tiene una línea base con
campos a completar.

- **Antes de extender el uso.** Completa los valores actuales con datos reales del equipo y
  anota la fuente de cada uno.
- **A las cuatro semanas.** Repite la medición. Compara uso, tiempo de revisión de pull
  requests y cambios devueltos. Revisa el consumo de créditos contra el presupuesto y
  ajusta los límites por perfil.
- **A las ocho semanas.** Repite otra vez. Decide con números qué activos se quedan, cuáles
  se ajustan y cuáles se retiran. Un activo que nadie usa se borra.

## Cuando Copilot cambie

Copilot y Visual Studio Code cambian cada pocas semanas. Una vez al mes, o cuando el editor
se actualice:

1. Lee las notas de la versión nueva de Visual Studio Code en https://code.visualstudio.com/updates.
2. Revisa si cambió algo en skills, agentes, instrucciones, hooks o MCP, en
   https://code.visualstudio.com/docs/agent-customization.
3. Revisa si algún tipo de artefacto entró en retiro. Ya pasó con los prompt files.
4. Corre `bash scripts/validar-skills.sh` y prueba un agente y una skill a mano.
5. Si cambió el modelo de cobro, actualiza el presupuesto.
