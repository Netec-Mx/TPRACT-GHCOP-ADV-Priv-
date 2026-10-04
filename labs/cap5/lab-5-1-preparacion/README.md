# Laboratorio 5.1. Preparación del escenario integrador

## Objetivo del laboratorio

Empezar el recorrido del ciclo de vida completo con una funcionalidad nueva: convertir la
solicitud del área comercial en una historia con criterios de aceptación, estimarla con y
sin IA, y decidir dónde va a vivir. Son las fases de Requerimientos, Estimación y Análisis y
diseño de [`CICLO-DE-VIDA.md`](../../../CICLO-DE-VIDA.md). Los criterios que escribas aquí son
los que van a evaluar los laboratorios 5.2 y 5.3.

## Duración

45 minutos.

## Prerrequisitos

- Elige un stack, Java o .NET. Vas a trabajar solo en ese durante todo el capítulo.
- Punto de partida limpio y una rama local para el capítulo. Desde la raíz del repositorio,
  en Git Bash:

  ```bash
  bash scripts/reiniciar-lab.sh lab-5-1
  git switch -c reporte-medios-de-pago
  ```

- Todos los pasos se hacen en modo **Agent**. Los documentos quedan en `docs/proyecto/`.
- No necesitas GitHub. Todo el capítulo se hace en tu máquina.

## Pasos

| Paso | Qué escribir en el chat | Qué observar | Tiempo |
|---|---|---|---|
| 1 | `/lab-5-1-paso-1-historia-de-usuario java` | Qué preguntas abiertas lista el agente antes de escribir criterios. Llévaselas al relator, que en esta sala es el negocio, y vuelve con las respuestas. En la historia que muestra al final, que cada criterio tenga su valor esperado y la cuenta | 15 min |
| 2 | `/lab-5-1-paso-2-estimar` | En la estimación que muestra el agente, qué supuestos escribe en cada fase y en qué fases la IA cambia más la estimación | 10 min |
| 3 | `/lab-5-1-paso-3-ubicar-en-arquitectura java` | Qué alternativas propone y, en la decisión que muestra al final, qué componentes del escenario va a tocar la que elijas | 10 min |

Reemplaza `java` por `dotnet` si trabajas con .NET.

Al terminar, confirma el trabajo en tu rama:

```bash
git add docs scripts/integracion/stack.txt && git commit -m "Historia, estimacion y decision del reporte"
```

## Resultado esperado

- `docs/proyecto/historia-reporte-medios-de-pago.md`, con preguntas abiertas respondidas y
  criterios de aceptación comprobables.
- `docs/proyecto/estimacion.md` y `docs/proyecto/registro-de-tiempos.md`, con la hora de
  inicio de las tres primeras fases.
- Una decisión nueva en `docs/arquitectura/decisiones/`.
- `scripts/integracion/stack.txt` con tu stack.
- Ningún archivo de `escenario/` modificado.

## Criterios de revisión

- [ ] Las preguntas abiertas se listaron antes de escribir los criterios.
- [ ] Cada criterio se puede comprobar con un comando o una prueba.
- [ ] Hay un criterio con una transacción en el límite de un tramo y otro con un comercio
      cuya suma exacta de comisiones termina en 5 en el tercer decimal, cada uno con su valor
      esperado.
- [ ] La estimación separa el tiempo de la persona del tiempo del agente y no tiene precios.
- [ ] La decisión de arquitectura tiene alternativas y consecuencias.
