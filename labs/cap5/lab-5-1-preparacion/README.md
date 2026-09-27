# Laboratorio 5.1. Preparación del escenario integrador

## Objetivo del laboratorio

Levantar el escenario con una línea base verificada, entenderlo con un mapa del sistema y
un inventario de riesgos, y acordar los criterios con que se van a evaluar los
laboratorios 5.2 y 5.3.

## Duración

45 minutos.

## Prerrequisitos

- Punto de partida limpio. Desde la raíz del repositorio, en Git Bash:

  ```bash
  bash scripts/reiniciar-lab.sh lab-5-1
  ```

- Todos los pasos se hacen en modo **Agent**. Los documentos quedan en
  `labs/cap5/lab-5-1-preparacion/entregables/`.

## Pasos

| Paso | Qué escribir en el chat | Qué observar | Tiempo |
|---|---|---|---|
| 1 | `/lab-5-1-paso-1-levantar-y-verificar` | Que todo esté en verde antes de tocar nada. Si algo falla, avisa al relator | 8 min |
| 2 | `/lab-5-1-paso-2-mapa-del-sistema java` | Si las rutas del mapa existen | 10 min |
| 3 | `/lab-5-1-paso-3-inventario-de-riesgos java` | Qué reglas de negocio el sistema no cumple del todo, y cómo lo demuestra el agente | 12 min |
| 4 | `/lab-5-1-paso-4-criterios-de-evaluacion` | Si cada criterio se puede comprobar con un comando o una prueba | 10 min |

Reemplaza `java` por `dotnet` si trabajas con .NET.

## Resultado esperado

- La línea base. Los dos escenarios compilan, las pruebas pasan y el comparador termina en
  cero.
- Tres documentos en `entregables/`: `mapa-del-sistema.md`, `inventario-de-riesgos.md` y
  `criterios-de-evaluacion.md`.
- Ningún archivo de `escenario/` modificado.

## Criterios de revisión

- [ ] La línea base quedó registrada con el resultado de cada comando.
- [ ] El inventario revisa las nueve reglas de negocio una por una.
- [ ] Cada problema del inventario cita archivo y línea, y ninguno fue corregido.
- [ ] Cada criterio de evaluación dice cómo se comprueba y qué resultado lo da por
      cumplido.
- [ ] Los criterios se acordaron en sala antes de pasar al 5.2.
