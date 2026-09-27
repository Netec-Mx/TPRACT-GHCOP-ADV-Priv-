# Laboratorio 5.2. Refactorización y validación incremental

## Objetivo del laboratorio

Planear una mejora del método que calcula la liquidación y ejecutarla con el modo agente
en incrementos, validando cada uno contra el otro escenario.

## Duración

45 minutos.

## Prerrequisitos

- Laboratorio 5.1 hecho, con los criterios de evaluación acordados.
- Punto de partida limpio. Desde la raíz del repositorio, en Git Bash:

  ```bash
  bash scripts/reiniciar-lab.sh lab-5-2
  ```

- El paso 1 se hace en modo **Ask**. Los pasos 2 a 4 en modo **Agent**.

## Pasos

| Paso | Qué escribir en el chat | Qué observar | Tiempo |
|---|---|---|---|
| 1 | `/lab-5-2-paso-1-plan-incremental java` | Qué valores de negocio aparecen escritos en más de un lugar y qué incremento conviene no hacer todavía | 10 min |
| 2 | `/lab-5-2-paso-2-extraer-comision java` | Qué archivos toca, si compila y si el comparador sigue en cero | 12 min |
| 3 | `/lab-5-2-paso-3-extraer-desglose-medios java` | Lo mismo que en el paso 2, en otra zona del mismo método | 12 min |
| 4 | `/lab-5-2-paso-4-validar-equivalencia java` | Si la refactorización cambió la salida, y en qué línea | 8 min |

Reemplaza `java` por `dotnet` si trabajas con .NET.

Los pasos 2 y 3 tocan zonas distintas del mismo archivo. Si no alcanzas a hacer uno de los
dos, el otro funciona igual. El paso 4 funciona aunque no hayas hecho ninguno.

Después de cada paso que modifica código, revisa el diff antes de seguir. En el panel de
control de código fuente (menú **View**, **Source Control**) se ve archivo por archivo.

## Resultado esperado

- La clase de cálculo de tu escenario con uno o dos métodos privados nuevos.
- `bash scripts/comparar-escenarios.sh` termina en cero.
- Las pruebas del escenario siguen pasando.

## Criterios de revisión

- [ ] Revisaste el diff de cada paso y solo cambió la clase de cálculo.
- [ ] El proyecto compila y las pruebas pasan.
- [ ] `bash scripts/comparar-escenarios.sh` termina en cero.
- [ ] Ningún valor de negocio cambió de tipo, de nombre ni de lugar fuera de los bloques
      extraídos.
- [ ] Se cumplen los criterios acordados en el laboratorio 5.1 que aplican a este cambio.
