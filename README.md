# Taller práctico de productividad avanzada con GitHub Copilot

Repositorio de trabajo del taller dictado para Netec. Contiene el código base de los
laboratorios, los artefactos de personalización de Copilot que construyen los
participantes, un servidor MCP local de demostración y el material de apoyo del relator.

**Duración total:** 13.5 horas (810 minutos), distribuidas en cuatro sesiones.

## Contenido del taller

| Capítulo | Título | Duración |
|---|---|---|
| 1 | Prompt Engineering y uso eficiente de GitHub Copilot Chat | 180 min |
| 2 | Instrucciones, prompt files, agentes y skills reutilizables | 180 min |
| 3 | MCP local bajo restricciones corporativas | 135 min |
| 4 | Documentación técnica con GitHub Copilot y Markdown | 90 min |
| 5 | Laboratorio integrador Java y .NET | 180 min |
| 6 | Medición de adopción y control de consumo | 45 min |

### Distribución por sesión

| Sesión | Contenido | Duración |
|---|---|---|
| 1 | Capítulo 1 | 180 min |
| 2 | Capítulo 2 | 180 min |
| 3 | Capítulos 3 y 4 | 225 min |
| 4 | Capítulos 5 y 6 | 225 min |

## Inicio rápido

Clona el repositorio y ejecuta el script de verificación de ambiente que corresponda a tu
sistema operativo. El script solo diagnostica: no instala ni modifica nada.

```bash
git clone https://github.com/RodrigoMSB/github-copilot-netec.git
cd github-copilot-netec
```

En macOS o Linux:

```bash
bash scripts/verificar-ambiente.sh
```

En Windows, desde Git Bash:

```bash
bash scripts/verificar-ambiente.sh
```

Git Bash viene incluido en Git para Windows, que ya es un requisito del ambiente. No hace
falta instalar ningún intérprete adicional.

Si el script reporta requisitos faltantes, revisa [docs/00-setup-ambiente.md](docs/00-setup-ambiente.md)
antes de continuar. Los problemas conocidos y su solución están en
[docs/02-troubleshooting.md](docs/02-troubleshooting.md).

## Plan de construcción del repositorio

El repositorio se construye por specs numerados. Esta tabla dice qué falta y en qué orden
llega, para que quien lo retome más adelante no tenga que reconstruir el contexto.

| Spec | Contenido | Estado |
|---|---|---|
| SPEC-001 | Estructura del repositorio y scripts de verificación de ambiente | Ejecutado |
| SPEC-002 | Dominio del escenario e implementación en Java | Pendiente |
| SPEC-003 | Implementación equivalente en .NET | Pendiente |
| SPEC-004 | Prompt files de los laboratorios | Pendiente |
| SPEC-005 | Instrucciones de repositorio, agentes y skills | Pendiente |
| SPEC-006 | Servidor MCP local | Pendiente |
| SPEC-007 | Guía del relator y documento de troubleshooting | Pendiente |
| SPEC-008 | Reservado | Reservado |
| SPEC-009 | Reservado | Reservado |
| SPEC-010 a SPEC-018 | Un spec por laboratorio, en el orden de la tabla de `labs/README.md` | Pendiente |

SPEC-008 y SPEC-009 quedan reservados a propósito, para poder incorporar trabajo de
infraestructura sin renumerar los specs de laboratorio.

Cada archivo marcador del repositorio declara en su interior que lo es y nombra el spec
que lo completa.

## Mapa del repositorio

| Ruta | Contenido |
|---|---|
| `.github/` | Artefactos de personalización de Copilot: instrucciones, prompt files, agentes y skills |
| `docs/` | Guía de ambiente, guía del relator y troubleshooting |
| `escenario/` | Código base de los escenarios Java y .NET usados en los laboratorios |
| `labs/` | Enunciados de los nueve laboratorios |
| `mcp/` | Servidor MCP local de demostración |
| `scripts/` | Scripts de verificación de ambiente |

## Antes de tocar el código del escenario

El código de `escenario/` contiene defectos introducidos a propósito. Son el material de
trabajo de los laboratorios, no errores por corregir. Lee [AGENTS.md](AGENTS.md) antes de
pedirle a cualquier agente que trabaje sobre ese directorio.
