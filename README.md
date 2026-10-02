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

### Subtemas del temario contratado

Títulos y minutos textuales del documento de Netec, Propuesta Temario 1. Son la única
fuente de los planes de sesión de `docs/relator/01-guia-del-relator.md`.

| Subtema | Título | Min | Sesión |
|---|---|---|---|
| 1.1 | Prompts efectivos para desarrollo: objetivo, contexto, restricciones y salida esperada | 30 | 1 |
| 1.2 | Uso de contexto: archivos abiertos, selección de código, workspace y referencias específicas | 30 | 1 |
| 1.3 | Flujos de trabajo con Copilot Chat: analizar, planear, implementar y validar | 30 | 1 |
| 1.4 | Práctica guiada: mejora incremental de prompts y uso de comandos del chat | 30 | 1 |
| 1.5 | Laboratorio: análisis y mejora de un componente Java/.NET usando prompts y Copilot Chat | 60 | 1 |
| 2.1 | Conceptos: agentes locales, skills, prompt files e instrucciones personalizadas | 45 | 2 |
| 2.2 | Diseño de agentes por rol: analista, tester, documentador, revisor y refactorizador | 45 | 2 |
| 2.3 | Instrucciones reutilizables para proyectos Java, .NET y repositorios corporativos | 45 | 2 |
| 2.4 | Laboratorio: creación de un agente local o instrucción reutilizable para una tarea del equipo | 45 | 2 |
| 3.1 | Qué es MCP y cómo se relaciona con contexto, agentes y herramientas locales | 45 | 3 |
| 3.2 | Diferencia entre MCP local y MCP externo en ambientes restringidos | 45 | 3 |
| 3.3 | Riesgos de seguridad: exposición de información, conectores no autorizados y fuga de contexto | 45 | 3 |
| 3.4 | Laboratorio: diseño de un caso de uso de MCP local seguro con documentación técnica local | 45 | 3 |
| 4.1 | Uso de Copilot para documentación técnica y generación de Markdown | 20 | 4 |
| 4.2 | Documentación de proyectos, endpoints, pruebas, decisiones técnicas y troubleshooting | 20 | 4 |
| 4.3 | Buenas prácticas para preparar documentación compatible con Confluence | 20 | 4 |
| 4.4 | Laboratorio: generación breve de documentación Markdown para un proyecto Java o .NET | 30 | 4 |
| 5.1 | Preparación del escenario integrador y criterios de evaluación | 45 | 4 |
| 5.2 | Planeación de mejora, refactorización y validación incremental | 45 | 4 |
| 5.3 | Estrategia de pruebas, documentación Markdown y checklist de revisión | 45 | 4 |
| 5.4 | Laboratorio final: construcción de activos reutilizables para el equipo | 45 | 4 |

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
| `herramientas/` | Imagen de Docker de los gates, con las versiones de la máquina virtual |
| `labs/` | Enunciados de los nueve laboratorios |
| `mcp/` | Servidor MCP local de demostración |
| `scripts/` | Scripts de verificación, reinicio y publicación. `scripts/publicacion/` tiene la lista de inclusión del repositorio de participantes |

## Gates

Desde la raíz del repositorio de construcción, con Docker:

```bash
bash scripts/gates.sh
```

Corre sin red, dentro de la imagen de `herramientas/Dockerfile`, el verificador de
ambiente, la validación de skills, el comparador de escenarios en los tres periodos, las
pruebas de los dos escenarios y el gate de fugas. La máquina de construcción no necesita
tener las versiones del taller instaladas. La primera vez construye la imagen y para eso
necesita red.

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
