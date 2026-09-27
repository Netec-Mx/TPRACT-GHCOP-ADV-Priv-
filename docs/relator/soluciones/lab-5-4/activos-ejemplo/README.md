# Activos reutilizables del taller

Lo que este equipo se lleva del taller de GitHub Copilot para usar mañana en sus
repositorios reales, Java o .NET. Ninguno de estos archivos depende de Pasarela Andina ni
del escenario del taller: cada uno se generalizó a partir de un artefacto concreto que sí
lo usaba, y el pie de cada archivo dice de cuál.

No se modificó ningún artefacto existente de `.github/` del repositorio del taller. Todo
lo de aquí es nuevo, vive en este directorio de entregables y se copia a mano al
repositorio de destino.

## Qué hay y para qué sirve

| Activo | Qué es | Para qué sirve |
|---|---|---|
| [`agentes/analista.agent.md`](agentes/analista.agent.md) | Agente de solo lectura | Responde preguntas sobre código existente, con citas de archivo y línea, sin editar nada. |
| [`agentes/documentador.agent.md`](agentes/documentador.agent.md) | Agente que solo escribe Markdown | Produce documentación técnica derivada del código, sin tocar código. |
| [`agentes/refactorizador.agent.md`](agentes/refactorizador.agent.md) | Agente de refactorización acotada | Aplica un cambio pequeño en un archivo y exige una verificación de regresión antes de darlo por bueno. |
| [`agentes/revisor.agent.md`](agentes/revisor.agent.md) | Agente de revisión de diffs | Clasifica cada hallazgo de un cambio en aplicar, descartar o decidir, sin aplicar nada él mismo. |
| [`agentes/tester.agent.md`](agentes/tester.agent.md) | Agente que solo escribe pruebas | Escribe pruebas que documentan el comportamiento actual, sin corregir producción de paso. |
| [`instrucciones/lineamientos-calidad-agentica.instructions.md`](instrucciones/lineamientos-calidad-agentica.instructions.md) | Instrucción de repositorio (`applyTo`) | Reglas por defecto para que un agente no introduzca, en código nuevo, la misma clase de defectos que el taller enseñó a reconocer (dinero en `double`, métodos largos, números mágicos, fechas legacy, catch vacíos). |
| [`skills/documentar-calculo-de-negocio.skill.md`](skills/documentar-calculo-de-negocio.skill.md) | Skill de invocación manual | Documenta un cálculo de negocio tal como lo hace el código hoy y lo contrasta con la especificación, sin corregir discrepancias. |
| [`plantillas-de-documentacion/checklist-revision-con-agentes.md`](plantillas-de-documentacion/checklist-revision-con-agentes.md) | Plantilla de checklist | Lo que un revisor humano confirma en un pull request hecho con ayuda de un agente, que un agente no puede confirmar por sí mismo. |
| [`plantillas-de-documentacion/plantilla-caso-de-uso-mcp.md`](plantillas-de-documentacion/plantilla-caso-de-uso-mcp.md) | Plantilla de documento | Caso de uso de un servidor MCP para que un área de seguridad lo apruebe o lo rechace. |

## Cómo se instala en otro repositorio

1. **Agentes.** Copia cada archivo de `agentes/` a `.github/agents/` del repositorio de
   destino, con el mismo nombre. Completa los `COMPLETAR` que quedaron marcados: la ruta
   al documento de reglas de negocio del equipo (si existe) y, en `refactorizador.agent.md`,
   el comando de verificación de regresión de ese repositorio (suite de pruebas, comparación
   de snapshots o equivalente).
2. **Instrucción de calidad.** Copia `instrucciones/lineamientos-calidad-agentica.instructions.md`
   a `.github/instructions/` del repositorio de destino y ajusta el `applyTo` al patrón de
   archivos de producción de ese proyecto (por ejemplo `src/**/*.java` o `src/**/*.cs`).
3. **Skill de documentación.** Copia `skills/documentar-calculo-de-negocio.skill.md` a
   `.github/skills/<nombre-de-carpeta>/SKILL.md` del repositorio de destino (cada skill vive
   en su propia carpeta) y completa las rutas marcadas con `COMPLETAR`.
4. **Plantillas.** Los dos archivos de `plantillas-de-documentacion/` no son artefactos de
   Copilot: son documentos Markdown de uso directo. Cópialos a donde el equipo guarde su
   documentación (por ejemplo `docs/`) y complétalos por cada cambio o servidor MCP que
   corresponda.

Ningún paso de esta instalación descarga ni instala nada: es copiar archivos y completar
los marcadores de texto que ya están señalados en cada uno.

## Decisiones tomadas en este paso

- **No se modificó `escenario/`.** El paso permitía modificarlo, incluido el tipo de dato
  de los montos, si se documentaba como parte de un activo. Se decidió no hacerlo: migrar
  `double` a `BigDecimal`/`decimal` en el escenario cambia el redondeo y por lo tanto la
  salida esperada de los laboratorios 5.1 a 5.3, que asumen la salida actual. Convertirlo
  en un activo real habría requerido rehacer esa cadena de laboratorios, que excede el
  alcance de este paso. En cambio, la lección se capturó en
  `instrucciones/lineamientos-calidad-agentica.instructions.md`, como regla hacia
  adelante para código nuevo, que es como se aplicaría en un equipo real de todos modos:
  no se reescribe de golpe una base de código existente, se evita seguir sumando el mismo
  defecto.
- **No se tocó ningún artefacto de `.github/`.** La restricción del paso lo pedía
  explícitamente. Las versiones mejoradas quedan aquí, en `activos/`.
- Los agentes y la skill son adaptaciones directas de los artefactos del taller citados en
  el pie de cada archivo, con las referencias específicas de Pasarela Andina
  reemplazadas por marcadores `COMPLETAR`. El checklist y la plantilla de caso de uso MCP
  se generalizaron de la misma forma.

## Hallazgos fuera del alcance de este paso

Reportados aquí y no corregidos, según la restricción del paso y de `AGENTS.md`:

- `AGENTS.md`, en la raíz del repositorio, referencia
  `docs/04-defectos-plantados.md` como el catálogo de los diez defectos intencionales del
  escenario. Ese archivo no existe en este repositorio (`docs/` solo tiene
  `00-setup-ambiente.md` y `02-troubleshooting.md`). No se creó ni se completó, porque
  hacerlo no es parte de este paso; se deja mencionado para que el equipo del taller lo
  revise.
