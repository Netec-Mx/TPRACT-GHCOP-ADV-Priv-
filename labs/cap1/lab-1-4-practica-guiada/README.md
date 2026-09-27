# Laboratorio 1.4. Práctica guiada de mejora incremental de prompts

## Objetivo del laboratorio

Ejecutar el mismo pedido varias veces sobre el mismo método, agregando en cada vuelta un
elemento del prompt, y usar los comandos del chat que trae Visual Studio Code. Al final vas
a poder decir qué aporta cada elemento y cuándo conviene un comando en lugar de un prompt
escrito.

## Duración

30 minutos.

## Prerrequisitos

- `bash scripts/verificar-ambiente.sh` termina en cero.
- El repositorio está abierto como carpeta de trabajo en Visual Studio Code.
- Sabes si trabajas con el escenario Java o con el .NET. En los pasos que lo piden, se
  escribe `java` o `dotnet` después del nombre del paso.
- Ningún paso modifica archivos. No hace falta reiniciar nada antes.

## Pasos

Todo el laboratorio se hace **en una misma conversación**, con el chat en modo **Ask**. El
paso 4 compara lo que quedó en esa conversación.

| Paso | Qué escribir en el chat | Qué observar | Tiempo |
|---|---|---|---|
| 1 | `/lab-1-4-paso-1-prompt-vago` | Largo de la respuesta, cuántos temas toca, si podrías compararla con la de tu vecino | 5 min |
| 2 | `/lab-1-4-paso-2-agregar-objetivo java` | Qué cambió al fijar objetivo y alcance | 6 min |
| 3 | `/lab-1-4-paso-3-agregar-restricciones java` | Si la tabla que entrega se parece a la de tu vecino | 6 min |
| 4 | Ver abajo | Qué entrega cada vía y cuánto hubo que escribir | 8 min |

**Paso 4.** Tres acciones en la misma conversación:

1. Abre `CalculadoraLiquidacion` de tu escenario, selecciona el método que calcula la
   liquidación completa y escribe `/explain`.
2. Escribe `/plan dividir este método en partes que se puedan probar por separado`.
   El chat pasa al agente **Plan**, que propone un plan sin tocar código.
3. Vuelve al modo **Ask** con el selector de agente y escribe
   `/lab-1-4-paso-4-comparar-resultados`.

Los pasos 1 a 3 también son comandos. Cada `/lab-...` es una skill del repositorio, y así es
como Visual Studio Code expone las skills en el chat.

## Resultado esperado

- Cuatro respuestas del chat sobre el mismo método, cada una más acotada que la anterior.
- Una tabla que compara el resultado del paso 3, el de `/explain` y el de `/plan`.
- Ningún archivo modificado. `git status` no muestra cambios.

## Criterios de revisión

- [ ] La respuesta del paso 3 es una tabla de tres filas con rango de líneas en cada una.
- [ ] Puedes nombrar el elemento del prompt que más cambió la respuesta, entre objetivo,
      alcance, restricciones y formato.
- [ ] Ejecutaste `/explain` y `/plan` y sabes qué entrega cada uno.
- [ ] `git status` no muestra cambios en el repositorio.
