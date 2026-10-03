# Guía de inicio

## Qué es este repositorio

El material de trabajo del taller y lo que te llevas de él. Contiene un sistema de ejemplo
en Java y en .NET, los nueve laboratorios, y los artefactos de personalización de Copilot
que el equipo puede reutilizar: instrucciones, agentes, skills, un hook y un servidor MCP
local. Lo que construyas en los laboratorios queda aquí.

## Cómo está organizado

| Ruta | Qué hay |
|---|---|
| `labs/` | Un enunciado por laboratorio. Empieza por `labs/README.md` |
| `escenario/` | El sistema de ejemplo, en `java/` y `dotnet/`, con datos compartidos en `datos/` |
| `.github/` | Instrucciones, agentes, skills y hooks de Copilot |
| `mcp/` | Servidor MCP local de consulta |
| `CICLO-DE-VIDA.md` | El mapa del ciclo de vida que recorre el capítulo 5 |
| `CHANGELOG.md` | Registro de cambios del sistema |
| `scripts/` | Verificación de ambiente, comparación de escenarios, reinicio de laboratorios, validación de skills, pipeline local (`integracion-local.sh`) y verificación del reporte (`verificar-reporte.sh`) |
| `docs/` | Preparación del ambiente, solución de problemas, arquitectura de referencia y decisiones (`arquitectura/`), política de uso de IA y uso de tokens (`gobierno/`), plantilla de runbook (`operacion/`) y el proyecto del capítulo 5, con su backlog y plantillas (`proyecto/`) |

## El escenario

Pasarela Andina es una procesadora de pagos ficticia que liquida comisiones a sus comercios
afiliados. Existe dos veces, en Java y en .NET, y las dos implementaciones producen la misma
salida sobre los mismos datos. Las reglas de negocio están en `escenario/README.md`. Es
código pensado para trabajar con un agente encima, así que tiene características elegidas a
propósito. No lo corrijas salvo que el laboratorio lo pida.

## Cómo se trabaja un laboratorio

Cada paso es una skill. En el chat de Copilot escribes la barra y su nombre, con el
escenario que usas.

```
/lab-1-5-paso-1-inventario java
```

Usa `dotnet` en lugar de `java` si trabajas con .NET. El enunciado de cada laboratorio dice
qué paso va en modo **Ask** y cuál en modo **Agent**, y qué observar.

Mientras el agente trabaja, mira la lista de referencias de la respuesta y los comandos que
pide ejecutar. Lee cada comando antes de aprobarlo.

Cuando un paso toca código, la verificación es esta, desde la raíz:

```bash
bash scripts/comparar-escenarios.sh
```

Termina en cero si los dos escenarios siguen produciendo la misma salida.

## El capítulo 5: un stack, en tu máquina

En el capítulo 5 recorres el ciclo de vida completo de una funcionalidad nueva. Al empezar
eliges un stack, Java o .NET, y trabajas solo en ese. Lo declaras en la última línea de
`scripts/integracion/stack.txt`, que por omisión dice `ambos`.

Todo el capítulo se hace en tu máquina. Trabajas en una rama local, haces commits y corres
el pipeline de integración continua con:

```bash
bash scripts/integracion-local.sh
```

Es el mismo pipeline que corre en GitHub, paso por paso. Con un solo stack, compara la
liquidación con los hashes esperados de `scripts/integracion/liquidacion-esperada.sha256`.
Para comprobar el reporte que vas a construir:

```bash
bash scripts/verificar-reporte.sh java 2026-06
```

La descripción del pull request se escribe igual, en `docs/proyecto/pull-request.md`, con la
plantilla de `.github/pull_request_template.md`. No necesitas GitHub para nada de esto.

**Si la sala tiene copias en GitHub.** Puedes además empujar tu rama a tu copia, abrir el
pull request y ver el mismo pipeline en Actions. Es un paso opcional al final del 5.3.
Ningún paso posterior depende de él, y lo que aprendes es lo mismo por los dos caminos.

## Cómo volver al punto de partida

```bash
bash scripts/reiniciar-lab.sh lab-5-2
```

El script muestra qué se va a perder y pide que escribas `si`. Si quieres conservar algo,
haz `git commit` antes. Lo que construyes en el laboratorio 2.4 no se borra al reiniciar
otro laboratorio.

En el capítulo 5 cada laboratorio continúa el anterior. Reiniciar el 5.1 devuelve todo el
proyecto al punto de partida; el 5.2, solo el escenario; el 5.3, solo el pipeline y la
descripción del pull request. El 5.4 no se reinicia.

## Si algo no funciona

1. `bash scripts/verificar-ambiente.sh`. Dice qué falta y cómo resolverlo.
2. `docs/02-troubleshooting.md` tiene los problemas conocidos.
3. Si el agente tarda o se corta, avisa al relator. Hay una salida de respaldo para cada
   paso.

Al terminar el taller, sigue con [`DESPUES-DEL-TALLER.md`](DESPUES-DEL-TALLER.md).
