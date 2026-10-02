# Laboratorio 5.4. Laboratorio final de activos reutilizables

## Objetivo del laboratorio

Soltar el agente sobre una tarea completa, sin guía paso a paso, para que consolide lo
aprendido en activos que el equipo pueda usar en sus repositorios reales. Y dejar el
documento con la línea base de medición de adopción y la propuesta de presupuesto de
créditos del equipo.

## Duración

45 minutos.

## Prerrequisitos

- Los laboratorios 5.1, 5.2 y 5.3 hechos en este mismo repositorio. El paso 1 construye
  los activos a partir de su trabajo.
- **Este laboratorio no se reinicia.** No tiene punto de partida propio. Se continúa sobre
  el estado que dejó el 5.3. Si ejecutas `bash scripts/reiniciar-lab.sh lab-5-4`, el script
  te advierte que se descarta el trabajo del 5.2 y el 5.3 y te pide escribir `descartar`
  para seguir.

- Los dos pasos se hacen en modo **Agent**.

## Pasos

| Paso | Qué escribir en el chat | Qué observar | Tiempo |
|---|---|---|---|
| 1 | `/lab-5-4-paso-1-consolidar-activos` | Qué decide el agente cuando nadie lo acota: por dónde empieza, qué deja fuera, cuántos archivos crea | 32 min |
| 2 | `/lab-5-4-paso-2-medicion-y-presupuesto` | Si el documento deja los valores como campos a completar en lugar de inventarlos | 8 min |

El paso 1 es deliberadamente abierto. Déjalo correr y revisa lo que produjo. A los 32
minutos, pasa al paso 2 aunque el paso 1 no haya terminado.

En este laboratorio sí puedes modificar el escenario, si decides que es parte de un activo.
Si lo haces, `bash scripts/comparar-escenarios.sh` te dice si cambió la salida.

## Resultado esperado

- `labs/cap5/lab-5-4-laboratorio-final/entregables/activos/`, con un `README.md` que explica
  cada activo y cómo se instala en otro repositorio.
- `labs/cap5/lab-5-4-laboratorio-final/entregables/medicion-y-presupuesto.md`.

## Criterios de revisión

- [ ] Hay al menos un activo que usarías mañana en tu repositorio real.
- [ ] El `README.md` de los activos dice cómo instalar cada uno.
- [ ] El documento de medición tiene métricas de uso, de resultado y de calidad, con su
      fuente.
- [ ] El presupuesto de créditos no inventa precios ni límites. Deja campos a completar y
      dice dónde consultarlos.
- [ ] Si el escenario cambió, sabes si cambió la salida y por qué.
