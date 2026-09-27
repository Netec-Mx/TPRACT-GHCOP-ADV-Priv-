# Laboratorio 1.5. Análisis y mejora de un componente

## Objetivo del laboratorio

Analizar la clase que calcula la liquidación de tu escenario con control explícito del
contexto, y aplicar una única mejora acotada que no cambie el comportamiento.

## Duración

60 minutos.

## Prerrequisitos

- Laboratorio 1.4 hecho o, como mínimo, saber invocar una skill con la barra.
- Punto de partida limpio. Desde la raíz del repositorio, en Git Bash:

  ```bash
  bash scripts/reiniciar-lab.sh lab-1-5
  ```

- Los pasos 1 a 4 se hacen en modo **Ask**. El paso 5 en modo **Agent**.

## Pasos

En cada paso, reemplaza `java` por `dotnet` si trabajas con .NET.

| Paso | Qué escribir en el chat | Qué observar | Tiempo |
|---|---|---|---|
| 1 | `/lab-1-5-paso-1-inventario java` | Cuántas responsabilidades encuentra y si coinciden con las que tú ves | 10 min |
| 2 | `/lab-1-5-paso-2-rastrear-lineas-invalidas java` | Si el equipo se enteraría de un problema con los datos de entrada | 10 min |
| 3 | `/lab-1-5-paso-3-contrastar-nombres java` | Si el nombre de cada método describe lo que hace | 10 min |
| 4 | `/lab-1-5-paso-4-proponer-mejora java` | Si la propuesta cabe en una revisión de diez minutos | 12 min |
| 5 | `/lab-1-5-paso-5-extraer-retencion java`, en modo **Agent** | Qué archivos toca, si compila y si el comparador sigue en cero | 12 min |

El paso 5 no depende de lo que haya propuesto el paso 4. La zona a extraer ya está fijada,
para que todos trabajen sobre lo mismo.

En el paso 5 el agente va a pedir permiso para ejecutar comandos en la terminal. Revisa
cada comando antes de aprobarlo.

## Resultado esperado

- Cuatro análisis en el chat.
- Un solo archivo modificado, la clase de cálculo de tu escenario, con un método privado
  nuevo que calcula la retención de garantía.
- `bash scripts/comparar-escenarios.sh` termina en cero.

## Criterios de revisión

- [ ] Encontraste en el análisis algo que no habías visto leyendo el código, y viste algo
      que el agente no encontró.
- [ ] `git status` muestra un único archivo modificado.
- [ ] El proyecto compila.
- [ ] `bash scripts/comparar-escenarios.sh` termina en cero.
- [ ] El agente no cambió nada fuera del bloque pedido. Si lo hizo, lo detectaste en el
      diff.
