# Notas del relator por laboratorio

Material para quien dicta el taller. No se entrega a los participantes y no se publica en
el repositorio que ellos clonan.

Cada archivo corresponde a un laboratorio y responde lo mismo. Qué va a pasar en la sala,
qué errores son típicos, cómo conducir la conversación, cuánto tiempo toma de verdad cada
paso, qué hacer si alguien se atrasa y dónde está la solución de referencia.

| Laboratorio | Notas | Solución de referencia |
|---|---|---|
| 1.4 | [lab-1-4.md](lab-1-4.md) | No modifica código |
| 1.5 | [lab-1-5.md](lab-1-5.md) | [`../soluciones/lab-1-5/`](../soluciones/lab-1-5/) |
| 2.4 | [lab-2-4.md](lab-2-4.md) | Respaldo en [`../respaldo-lab-2-4/`](../respaldo-lab-2-4/) |
| 3.4 | [lab-3-4.md](lab-3-4.md) | `.vscode/mcp.json` del repositorio de construcción |
| 4.4 | [lab-4-4.md](lab-4-4.md) | No modifica código |
| 5.1 | [lab-5-1.md](lab-5-1.md) | [`../soluciones/lab-5-1/`](../soluciones/lab-5-1/) |
| 5.2 | [lab-5-2.md](lab-5-2.md) | [`../soluciones/lab-5-2/`](../soluciones/lab-5-2/) |
| 5.3 | [lab-5-3.md](lab-5-3.md) | [`../soluciones/lab-5-3/`](../soluciones/lab-5-3/) |
| 5.4 | [lab-5-4.md](lab-5-4.md) | [`../soluciones/lab-5-4/`](../soluciones/lab-5-4/) |

El hook que protege los datos del escenario tiene sus propias notas, con una demostración
opcional, en [hook-proteccion-datos.md](hook-proteccion-datos.md).

## Antes de cada laboratorio

Cada participante corre `bash scripts/reiniciar-lab.sh lab-X-Y` desde la raíz de su
repositorio. El script muestra qué se va a perder y pide que escriba `si`. Si alguien tiene
trabajo que quiere conservar, que lo confirme con `git commit` antes de reiniciar. Los
commits no se pierden al reiniciar.

Las skills de laboratorio no se cargan solas. Si un participante ve que el agente actúa
como si conociera un paso que todavía no invocó, anótalo y avísalo. Es una falla del
material, no del participante.

## La sesión 4 dura 270 minutos

Es la sesión más larga del taller. Tiene el capítulo 4 completo, 90 minutos con el
laboratorio 4.4, y el capítulo 5 completo, 180 minutos con los laboratorios 5.1 a 5.4. Los
270 minutos no incluyen pausas. Si el horario del cliente tiene pausas dentro de esas
horas, el tiempo de trabajo real es menor y hay que recortar desde el inicio.

El único recorte definido es el del capítulo 4: el paso 3 del 4.4, Confluence, se muestra en
pantalla en lugar de hacerlo, y se recuperan 8 minutos.

El capítulo 5 se rehízo en SPEC-016 como un solo recorrido del ciclo de vida. Qué pasos pasan
a opcionales se decide después de la prueba en la máquina virtual, con la medición de tiempos
de cada paso. Hasta entonces no tiene recortes definidos.
