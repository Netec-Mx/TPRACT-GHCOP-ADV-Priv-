# Laboratorio 4.4. Generación de documentación Markdown

## Objetivo del laboratorio

Producir documentación técnica en Markdown derivada del código de tu escenario, revisable
contra el código y trasladable a Confluence.

## Duración

30 minutos.

## Prerrequisitos

- Punto de partida limpio. Desde la raíz del repositorio, en Git Bash:

  ```bash
  bash scripts/reiniciar-lab.sh lab-4-4
  ```

- Todos los pasos se hacen en modo **Agent**. Los documentos quedan en
  `labs/cap4/lab-4-4-documentacion/entregables/`.

## Pasos

| Paso | Qué escribir en el chat | Qué observar | Tiempo |
|---|---|---|---|
| 1 | `/lab-4-4-paso-1-documentar-reglas java` | Si cada afirmación del documento está respaldada por una línea de código. Revisa la sección de contraste con las reglas declaradas | 10 min |
| 2 | `/lab-4-4-paso-2-documentar-decisiones` | Si las consecuencias que documenta son verificables | 10 min |
| 3 | `/lab-4-4-paso-3-preparar-para-confluence` | Qué se pierde al trasladar el Markdown | 8 min |
| 4, opcional | `/lab-4-4-paso-4-generar-runbook java` | Qué acciones del runbook quedaron verificadas con una ejecución real y cuáles no | Fuera de los 30 min |

Reemplaza `java` por `dotnet` si trabajas con .NET.

El paso 4 es opcional. Hazlo si terminaste los tres primeros antes de tiempo o después de
la sesión. Usa la plantilla de [`docs/operacion/runbook-plantilla.md`](../../../docs/operacion/runbook-plantilla.md).

Antes de dar por bueno el documento del paso 1, abre dos o tres de las líneas que cita y
compáralas con lo que dice.

## Resultado esperado

Tres archivos en `labs/cap4/lab-4-4-documentacion/entregables/`:

- `calculo-de-comisiones.md`
- `decisiones.md`
- La copia con sufijo `-confluence.md` de uno de los dos.

Si hiciste el paso 4, además `runbook-calculo-de-comisiones.md`.

## Criterios de revisión

- [ ] Verificaste contra el código al menos tres afirmaciones del documento del paso 1.
- [ ] La sección de contraste dice qué reglas coinciden con el código y cuáles no.
- [ ] Cada decisión del paso 2 tiene contexto, decisión y consecuencias.
- [ ] La copia para Confluence lista lo que se perdió.
- [ ] Si hiciste el paso 4, ninguna acción del runbook figura como verificada sin una
      ejecución real.
- [ ] Ningún archivo de código ni comentario del código cambió.
