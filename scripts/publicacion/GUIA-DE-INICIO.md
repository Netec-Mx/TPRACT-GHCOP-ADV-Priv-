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
| `scripts/` | Verificación de ambiente, comparación de escenarios, reinicio de laboratorios y validación de skills |
| `docs/` | Preparación del ambiente y solución de problemas |

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

## Cómo volver al punto de partida

```bash
bash scripts/reiniciar-lab.sh lab-5-2
```

El script muestra qué se va a perder y pide que escribas `si`. Si quieres conservar algo,
haz `git commit` antes. Lo que construyes en el laboratorio 2.4 no se borra al reiniciar
otro laboratorio.

## Si algo no funciona

1. `bash scripts/verificar-ambiente.sh`. Dice qué falta y cómo resolverlo.
2. `docs/02-troubleshooting.md` tiene los problemas conocidos.
3. Si el agente tarda o se corta, avisa al relator. Hay una salida de respaldo para cada
   paso.

Al terminar el taller, sigue con [`DESPUES-DEL-TALLER.md`](DESPUES-DEL-TALLER.md).
