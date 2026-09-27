# Laboratorios del taller

Los nueve laboratorios prácticos, en el orden en que se dictan. Cada uno tiene su
enunciado completo en el README de su directorio.

Cada laboratorio corresponde a un bloque práctico del temario contratado, con su mismo
número y su misma duración.

| Bloque | Laboratorio | Enunciado contratado | Duración | Estado |
|---|---|---|---|---|
| 1.4 | [`lab-1-4`](cap1/lab-1-4-practica-guiada/README.md) | Práctica guiada, mejora incremental de prompts y uso de comandos del chat | 30 min | Redactado |
| 1.5 | [`lab-1-5`](cap1/lab-1-5-analisis-componente/README.md) | Laboratorio, análisis y mejora de un componente Java/.NET usando prompts y Copilot Chat | 60 min | Redactado |
| 2.4 | [`lab-2-4`](cap2/lab-2-4-agente-o-instruccion/README.md) | Laboratorio, creación de un agente local o instrucción reutilizable para una tarea del equipo | 45 min | Redactado |
| 3.4 | [`lab-3-4`](cap3/lab-3-4-mcp-local/README.md) | Laboratorio, diseño de un caso de uso de MCP local seguro con documentación técnica local | 45 min | Redactado |
| 4.4 | [`lab-4-4`](cap4/lab-4-4-documentacion/README.md) | Laboratorio, generación breve de documentación Markdown para un proyecto Java o .NET | 30 min | Redactado |
| 5.1 | [`lab-5-1`](cap5/lab-5-1-preparacion/README.md) | Preparación del escenario integrador y criterios de evaluación | 45 min | Redactado |
| 5.2 | [`lab-5-2`](cap5/lab-5-2-refactorizacion/README.md) | Planeación de mejora, refactorización y validación incremental | 45 min | Redactado |
| 5.3 | [`lab-5-3`](cap5/lab-5-3-pruebas-y-revision/README.md) | Estrategia de pruebas, documentación Markdown y checklist de revisión | 45 min | Redactado |
| 5.4 | [`lab-5-4`](cap5/lab-5-4-laboratorio-final/README.md) | Laboratorio final, construcción de activos reutilizables para el equipo | 45 min | Redactado |

Tiempo total de laboratorio: 30 + 60 + 45 + 45 + 30 + 45 + 45 + 45 + 45 = 390 minutos de
los 810 del taller.

El estado pasa de Redactado a Listo cuando el laboratorio se probó de extremo a extremo
sobre una máquina virtual equivalente a la de clase.

Cada paso de laboratorio es una skill de `.github/skills/`, con nombre `lab-` más el
laboratorio y el paso. Se invoca escribiendo la barra y el nombre en el chat. Las skills de
laboratorio no se cargan solas. Solo actúan cuando se las invoca.

Para volver al punto de partida de un laboratorio:

```bash
bash scripts/reiniciar-lab.sh lab-5-2
```

## Plantilla común

Todos los enunciados siguen la misma estructura de seis secciones, en este orden:

1. Objetivo del laboratorio
2. Duración
3. Prerrequisitos
4. Pasos
5. Resultado esperado
6. Criterios de revisión

## Restricciones del ambiente

Los laboratorios se ejecutan por escritorio remoto sobre máquinas virtuales. La latencia
medida es aceptable. Las sugerencias cortas responden rápido y solo las generaciones largas
tardan algunos segundos. Aun así, ningún enunciado pide tipear prompts largos a mano,
copiar y pegar entre ventanas, ni descargar nada durante la clase. Los prompts viven en
archivos del repositorio y se invocan desde el editor, lo que además hace que doce
participantes obtengan resultados comparables.
