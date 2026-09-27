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

Reemplaza `java` por `dotnet` si trabajas con .NET.

Antes de dar por bueno el documento del paso 1, abre dos o tres de las líneas que cita y
compáralas con lo que dice.

## Resultado esperado

Tres archivos en `labs/cap4/lab-4-4-documentacion/entregables/`:

- `calculo-de-comisiones.md`
- `decisiones.md`
- La copia con sufijo `-confluence.md` de uno de los dos.

## Criterios de revisión

- [ ] Verificaste contra el código al menos tres afirmaciones del documento del paso 1.
- [ ] La sección de contraste dice qué reglas coinciden con el código y cuáles no.
- [ ] Cada decisión del paso 2 tiene contexto, decisión y consecuencias.
- [ ] La copia para Confluence lista lo que se perdió.
- [ ] Ningún archivo de código ni comentario del código cambió.
