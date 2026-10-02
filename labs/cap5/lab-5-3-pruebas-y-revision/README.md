# Laboratorio 5.3. Estrategia de pruebas, documentación y checklist de revisión

## Objetivo del laboratorio

Cubrir con pruebas una parte de la lógica de negocio que hoy no tiene ninguna, documentar
en Markdown la estrategia de pruebas y revisar el resultado con un checklist de revisión
humana.

## Duración

45 minutos.

## Prerrequisitos

- **El 5.1 hecho en este repositorio.** El capítulo 5 es un solo flujo sobre el mismo
  repositorio. El paso 4 usa los criterios de evaluación que dejó el 5.1 en
  `labs/cap5/lab-5-1-preparacion/entregables/criterios-de-evaluacion.md`. Si no hiciste el
  5.1, pide ese documento al relator y guárdalo en esa ruta antes de empezar.
- Punto de partida. Este laboratorio puede empezar sobre el resultado del 5.2 o desde
  cero. Para empezar desde cero, desde la raíz del repositorio, en Git Bash:

  ```bash
  bash scripts/reiniciar-lab.sh lab-5-3
  ```

- Los pasos 1, 2 y 4 se hacen en modo **Agent**. El paso 3 en modo **Ask**.

## Pasos

| Paso | Qué escribir en el chat | Qué observar | Tiempo |
|---|---|---|---|
| 1 | `/lab-5-3-paso-1-probar-tramos java` | Si las pruebas documentan lo que el código hace o lo que debería hacer, y la tabla de bordes que entrega al final | 12 min |
| 2 | `/lab-5-3-paso-2-documentar-estrategia java` | Qué reglas de negocio quedan sin ninguna prueba | 9 min |
| 3 | `/lab-5-3-paso-3-revision-asistida` | Qué hallazgos clasifica como fuera del alcance del cambio | 9 min |
| 4 | `/lab-5-3-paso-4-checklist-humano` | Qué puntos del checklist no podría responder un agente | 8 min |

Reemplaza `java` por `dotnet` si trabajas con .NET.

Si el paso 1 te muestra dos partes del sistema que no coinciden, no lo corrijas. Busca en
`escenario/README.md` cuál es el comportamiento correcto. Si las reglas no alcanzan para
decidirlo, esa es la pregunta que llevas a la puesta en común.

## Opcional, fuera del camino obligatorio

Si terminas antes, pide pruebas del recargo por cuotas con su máximo, del tope mensual y
de la retención de garantía, en un archivo nuevo distinto del paso 1. No tiene tiempo asignado ni entra en
la puesta en común.

## Resultado esperado

- Un archivo de pruebas nuevo de la calculadora de comisión, con las pruebas en verde.
- `labs/cap5/lab-5-3-pruebas-y-revision/entregables/estrategia-de-pruebas.md`.
- Una revisión del diff en el chat, con cada hallazgo clasificado.
- `labs/cap5/lab-5-3-pruebas-y-revision/entregables/checklist-de-revision.md`.

## Criterios de revisión

- [ ] Las pruebas nuevas pasan junto con las veinte que ya existían.
- [ ] Ningún archivo existente fue modificado por el paso 1.
- [ ] La estrategia dice qué reglas no tienen pruebas y qué valores de borde importan.
- [ ] La revisión clasifica cada hallazgo en aplicar, descartar o decidir.
- [ ] El checklist tiene puntos que se responden con sí o no y dice cómo verificar cada uno.
