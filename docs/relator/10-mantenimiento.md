# Mantenimiento antes de cada dictado

GitHub Copilot y Visual Studio Code cambian cada pocas semanas. Un material que funcionó en
la última prueba puede fallar en la próxima clase sin que nadie haya tocado el repositorio.
Este documento dice qué revisar antes de cada dictado, en qué orden, dónde está la fuente,
qué archivos dependen de cada punto y qué gate lo detectaría.

Fuentes vigentes al 1 de octubre de 2026.

## Cuándo y cómo

Una semana antes de cada dictado, y otra vez la víspera si hubo una versión nueva de Visual
Studio Code en el medio.

1. Revisar los puntos de este documento en el orden en que aparecen. Están ordenados por el
   daño que causan si cambiaron. Los primeros rompen laboratorios completos.
2. Para cada punto, leer la fuente y compararla con lo que suponen los archivos que
   dependen de él.
3. Correr `bash scripts/gates.sh` en el repositorio de construcción.
4. Si algo cambió, corregir por spec, republicar con `bash scripts/publicar-taller.sh
   --publicar https://github.com/RodrigoMSB/github-copilot-netec-taller.git --reemplazar`
   y repetir en la máquina virtual los bloques A y B de
   [`07-protocolo-prueba-vm.md`](07-protocolo-prueba-vm.md).

Lo que ningún gate cubre se marca como «revisión manual». Son los puntos que más fácil se
olvidan.

**Un ejemplo de por qué esto existe.** GitHub reorganizó su documentación de cobro. Una
página de la estructura anterior, como
`https://docs.github.com/en/copilot/concepts/billing/organizations-and-enterprises`, todavía
aparece en buscadores, pero la ruta equivalente para planes individuales,
`https://docs.github.com/en/copilot/concepts/billing/individuals`, daba 404 el 2 de octubre de
2026. La página vigente es
`https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing`. Nada del
repositorio había cambiado y ningún gate lo habría detectado. Por eso las fuentes se vuelven
a consultar, siguiendo los enlaces de la documentación vigente y no rutas recordadas, antes
de cada dictado.

## 1. Versión de Visual Studio Code en la imagen de Netec

**Por qué importa.** Todo lo demás depende de la versión instalada. Copilot viene integrado
desde la 1.116 y llega deshabilitado en un perfil nuevo.

**Fuente.** https://code.visualstudio.com/updates, las notas de cada versión. Confirmar con
Netec qué versión trae la imagen y si se actualiza sola.

**Archivos que dependen.** `scripts/verificar-ambiente.sh` (`MIN_CODE` y la lectura del
perfil del editor), `docs/00-setup-ambiente.md`, sección «GitHub Copilot en Visual Studio
Code», y el bloque A del protocolo.

**Gate.** `verificar-ambiente.sh` reprueba una versión anterior a la mínima y detecta las
funciones de IA deshabilitadas. Si el editor cambia dónde guarda ese estado, el gate falla
al revés (HALLAZGO-05).

## 2. Skills

**Por qué importa.** Cada paso de laboratorio es una skill con prefijo `lab-`. La lista
completa sale de `ls -d .github/skills/lab-*`, y `bash scripts/validar-skills.sh` informa
cuántas revisó. Un cambio en los campos admitidos, en la invocación con la barra o en la
carga automática deja sin laboratorios.

**Fuente.** https://code.visualstudio.com/docs/agent-customization/agent-skills y
https://agentskills.io/specification.

**Qué mirar.** Que `disable-model-invocation: true` siga impidiendo la carga automática.
Los campos admitidos. Cómo se referencian archivos fuera de la carpeta de la skill. Si las
skills funcionan en modo Ask.

**Archivos que dependen.** `.github/skills/*/SKILL.md`, `scripts/validar-skills.sh` y su
lista `CAMPOS_ADMITIDOS`, `labs/*/*/README.md`.

**Gate.** `validar-skills.sh` reprueba campos no admitidos, nombres inválidos, archivos
referenciados que no existen y skills de laboratorio sin restricción de invocación. No
detecta un cambio de comportamiento del editor. Eso lo cubre el bloque B del protocolo.

## 3. Política de retiro de prompt files

**Por qué importa.** El taller ya perdió un diseño completo por construir sobre prompt
files en retiro (HALLAZGO-06). Lo mismo puede pasarle a cualquier otro artefacto.

**Fuente.** https://code.visualstudio.com/docs/agent-customization/prompt-files. Revisar
también, en las páginas de skills, agentes y hooks, cualquier aviso de retiro o de cambio
de entorno, por ejemplo agente local frente a Agent Host.

**Archivos que dependen.** Ninguno usa prompt files hoy. El punto existe para detectar a
tiempo si skills, agentes o hooks entran en el mismo camino.

**Gate.** Ninguno. Revisión manual.

## 4. Hooks

**Por qué importa.** El hook de `.github/hooks/` protege los datos que sostienen el defecto
principal del escenario. Los hooks estaban en vista previa al construirlo.

**Fuente.** https://code.visualstudio.com/docs/agent-customization/hooks y
https://code.visualstudio.com/docs/agents/reference/hooks-reference.

**Qué mirar.** Ubicación de los archivos, formato de la respuesta (`permissionDecision` y
código de salida 2), el ajuste `chat.useHooks` y su valor por omisión, qué entorno ejecuta
los hooks del espacio de trabajo y si se publicaron los nombres de las herramientas.

**Archivos que dependen.** `.github/hooks/proteger-datos-escenario.json` y `.js`,
`scripts/verificar-ambiente.sh` (sección del hook), `docs/00-setup-ambiente.md`,
`notas/hook-proteccion-datos.md`.

**Gate.** `verificar-ambiente.sh` prueba el script del hook en los dos sentidos y reprueba
`chat.useHooks` en `false`. No prueba que Visual Studio Code lo ejecute. Eso lo cubre el
paso A5 del protocolo.

## 5. Agentes personalizados

**Por qué importa.** Los cinco agentes de `.github/agents/` se muestran en el capítulo 2 y
el laboratorio 2.4 construye uno.

**Fuente.** https://code.visualstudio.com/docs/agent-customization/custom-agents y
https://docs.github.com/en/copilot/reference/custom-agents-configuration.

**Qué mirar.** Campos del encabezado, nombres de las herramientas (`read`, `search`,
`edit`, `execute`), `handoffs` y cómo se selecciona un agente en el chat.

**Archivos que dependen.** `.github/agents/*.agent.md`,
`labs/cap2/lab-2-4-agente-o-instruccion/plantillas/plantilla.agent.md`,
`docs/relator/respaldo-lab-2-4/soporte-comercial.agent.md` y las skills `lab-2-4-*`.

**Gate.** Ninguno. Revisión manual y paso E5 del protocolo.

## 6. MCP

**Por qué importa.** El laboratorio 3.4 depende de que Visual Studio Code arranque el
servidor local y pida aprobación por cada llamada.

**Fuente.** https://code.visualstudio.com/docs/agents/reference/mcp-configuration,
https://code.visualstudio.com/docs/agent-customization/mcp-servers y, para el SDK,
https://www.npmjs.com/package/@modelcontextprotocol/server.

**Qué mirar.** Formato de `.vscode/mcp.json`, confianza del espacio de trabajo, cuándo se
pide aprobación y el efecto de `readOnlyHint`. En el SDK, si la línea 2.x sigue siendo la
estable y si hay correcciones de seguridad.

**Archivos que dependen.** `.vscode/mcp.json`, `mcp/servidor-local/`, `mcp/README.md`,
las skills `lab-3-4-*` y `notas/lab-3-4.md`.

**Gate.** `verificar-ambiente.sh` comprueba las dependencias con versión exacta y que el
servidor arranque y liste sus herramientas. No detecta un cambio en el cliente. Eso lo
cubre el bloque D del protocolo.

## 7. Modelo de cobro y planes

**Por qué importa.** El subtema 1.3 trata el consumo de cada modo de trabajo y el
laboratorio 5.4 produce la propuesta de presupuesto. Al construir el material, GitHub
hablaba de créditos de IA. Un cambio de modelo de cobro deja desactualizada la teoría y el
entregable.

**Fuente.** https://docs.github.com/en/copilot/get-started/plans y
https://docs.github.com/en/copilot/concepts/billing, con sus páginas para individuos y
para organizaciones.

**Archivos que dependen.** `.github/skills/lab-5-4-paso-2-medicion-y-presupuesto/SKILL.md`,
`notas/lab-5-4.md`, `notas/README.md` y `docs/00-setup-ambiente.md`, sección 4.

**Gate.** Ninguno. Revisión manual. La skill del 5.4 prohíbe inventar precios, así que un
cambio no produce un documento falso, pero sí una conversación desactualizada.

## 8. Dominios de salida que necesita Copilot

**Por qué importa.** Si la red del cliente bloquea un dominio nuevo, Copilot deja de
responder en clase.

**Fuente.** https://docs.github.com/en/copilot/reference/allowlist-reference.

**Archivos que dependen.** `scripts/verificar-ambiente.sh` (`DOMINIOS_OBLIGATORIOS` y
`DOMINIOS_RECOMENDADOS`) y `docs/00-setup-ambiente.md`, sección 3.

**Gate.** `verificar-ambiente.sh` comprueba la conectividad a los dominios que conoce. Un
dominio que falte en su lista no lo detecta nadie. Comparar la lista del script con la de
la fuente.

## 9. Herramientas de la imagen

**Por qué importa.** El escenario apunta a `net10.0` y a Java 21. Una imagen con otro SDK
o JDK, o sin la caché de dependencias, rompe la compilación en clase.

**Fuente.** Confirmación de Netec sobre la imagen. Para la imagen de gates,
`herramientas/Dockerfile`.

**Archivos que dependen.** `escenario/dotnet/*/*.csproj`, `escenario/java/pom.xml`,
`scripts/verificar-ambiente.sh`, `docs/00-setup-ambiente.md` y `herramientas/Dockerfile`.

**Gate.** `verificar-ambiente.sh` comprueba versiones mínimas y compila los dos escenarios
sin red. `gates.sh` hace lo mismo en la imagen de construcción.
