# Taller práctico de productividad avanzada con GitHub Copilot

Repositorio de trabajo del taller dictado para Netec. Contiene el código base de los
laboratorios, los artefactos de personalización de Copilot que construyen los
participantes, un servidor MCP local de demostración y el material de apoyo del relator.

**Duración total:** 13.5 horas (810 minutos), distribuidas en cuatro sesiones.

## Contenido del taller

La estructura sigue el temario que Netec acordó con el cliente: su numeración, sus títulos y
sus minutos.

| Capítulo | Título | Duración | Sesión |
|---|---|---|---|
| 1 | Prompt Engineering y uso eficiente de GitHub Copilot Chat | 180 min | 1 |
| 2 | Agentes locales, skills e instrucciones reutilizables | 180 min | 2 |
| 3 | MCP local bajo restricciones corporativas | 180 min | 3 |
| 4 | Documentación técnica con GitHub Copilot y Markdown | 90 min | 4 |
| 5 | Laboratorio integrador Java/.NET | 180 min | 4 |

De los 810 minutos, 420 son teoría y 390 son práctica, repartidos en nueve bloques
prácticos. Cada bloque práctico corresponde a un laboratorio de [`labs/`](labs/README.md).

### Distribución por sesión

| Sesión | Contenido | Duración |
|---|---|---|
| 1 | Capítulo 1 | 180 min |
| 2 | Capítulo 2 | 180 min |
| 3 | Capítulo 3 | 180 min |
| 4 | Capítulos 4 y 5 | 270 min |

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
| SPEC-001 a SPEC-001-C | Estructura, verificador de ambiente y sus correcciones | Cerrado |
| SPEC-002 y SPEC-002-A | Escenario Java | Cerrado |
| SPEC-003 a SPEC-003-B | Escenario .NET y equivalencia | Cerrado |
| SPEC-004 | Prompt files, solo la calibración | Absorbido por SPEC-009 |
| SPEC-005 y SPEC-006 | Activos de referencia y servidor MCP | Absorbidos por SPEC-009 |
| SPEC-007 | Guía general del relator | Pendiente, después de SPEC-009 |
| SPEC-008 | Realineación al temario contratado | Cerrado |
| SPEC-009 | Construcción completa de los nueve laboratorios | Cerrado por SPEC-010 |
| SPEC-010 | Cierre de SPEC-009, hook de protección de datos, .NET 10 y protocolo de prueba | Ejecutado, pendiente de prueba en la máquina virtual |
| SPEC-010 a SPEC-018 | README de cada laboratorio | Absorbidos por SPEC-009 |

SPEC-010 a SPEC-018 conservan su correspondencia con los laboratorios, en el orden de la
tabla de [`labs/README.md`](labs/README.md), aunque su trabajo se ejecute dentro de
SPEC-009. SPEC-012 corresponde a `lab-2-4-agente-o-instruccion`.

Cada archivo marcador del repositorio declara en su interior que lo es y nombra el spec
que lo completa.

## Mapa del repositorio

| Ruta | Contenido |
|---|---|
| `.github/` | Artefactos de personalización de Copilot: instrucciones, prompt files, agentes y skills |
| `docs/` | Guía de ambiente y troubleshooting, que también reciben los participantes |
| `docs/relator/` | Material del relator. Nunca llega al repositorio de participantes |
| `escenario/` | Código base de los escenarios Java y .NET usados en los laboratorios |
| `labs/` | Enunciados de los nueve laboratorios |
| `mcp/` | Servidor MCP local de demostración |
| `scripts/` | Scripts de verificación, reinicio y publicación. `scripts/publicacion/` tiene la lista de inclusión del repositorio de participantes |

## Repositorio de participantes

Este es el repositorio de construcción y del relator. Los participantes clonan otro,
[`github-copilot-netec-taller`](https://github.com/RodrigoMSB/github-copilot-netec-taller),
privado, que se genera desde este con `scripts/publicar-taller.sh`.
Solo llega allá lo que figura en `scripts/publicacion/incluir.txt`, y el script se niega a
publicar si encuentra material del relator en el contenido generado.

La prueba del material en la máquina virtual de Netec se hace siguiendo
[`docs/relator/07-protocolo-prueba-vm.md`](docs/relator/07-protocolo-prueba-vm.md).

## Antes de tocar el código del escenario

El código de `escenario/` contiene defectos introducidos a propósito. Son el material de
trabajo de los laboratorios, no errores por corregir. Lee [AGENTS.md](AGENTS.md) antes de
pedirle a cualquier agente que trabaje sobre ese directorio.
