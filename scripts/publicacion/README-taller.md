# Taller práctico de GitHub Copilot

Repositorio de trabajo del taller. Contiene el código base de los laboratorios, los
artefactos de personalización de Copilot, un servidor MCP local y los scripts de soporte.
Lo que construyas durante el taller queda en este repositorio y te lo llevas.

## Antes de la primera sesión

Desde la raíz del repositorio, en Git Bash:

```bash
bash scripts/verificar-ambiente.sh
```

El script solo diagnostica y no modifica nada. Debe terminar en cero. Si reporta algo
faltante, revisa [`docs/00-setup-ambiente.md`](docs/00-setup-ambiente.md) y
[`docs/02-troubleshooting.md`](docs/02-troubleshooting.md).

## Contenido del taller

| Capítulo | Título | Duración |
|---|---|---|
| 1 | Prompt Engineering y uso eficiente de GitHub Copilot Chat | 180 min |
| 2 | Agentes locales, skills e instrucciones reutilizables | 180 min |
| 3 | MCP local bajo restricciones corporativas | 180 min |
| 4 | Documentación técnica con GitHub Copilot y Markdown | 90 min |
| 5 | Laboratorio integrador Java/.NET | 180 min |

Los nueve laboratorios están en [`labs/`](labs/README.md).

## Mapa del repositorio

| Ruta | Contenido |
|---|---|
| `.github/` | Instrucciones, agentes, skills y hooks de Copilot |
| `docs/` | Preparación del ambiente y solución de problemas |
| `escenario/` | Código base Java y .NET de los laboratorios |
| `labs/` | Enunciados de los laboratorios |
| `mcp/` | Servidor MCP local de consulta |
| `scripts/` | Verificación de ambiente, comparación de escenarios, reinicio de laboratorios y validación de skills |

## Volver al punto de partida de un laboratorio

Si un laboratorio quedó a medias o quieres repetirlo:

```bash
bash scripts/reiniciar-lab.sh lab-5-2
```

El script muestra qué cambios se van a descartar y pide confirmación antes de tocar nada.

## Antes de pedirle algo a un agente sobre el escenario

Lee [`AGENTS.md`](AGENTS.md). El código del escenario tiene características elegidas a
propósito para los laboratorios y no se corrige salvo que el laboratorio lo pida.
