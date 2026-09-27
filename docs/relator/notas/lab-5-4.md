# Notas del relator, laboratorio 5.4

Laboratorio final, construcción de activos reutilizables para el equipo. 45 minutos.

## Qué va a pasar en la sala

El paso 1 es deliberadamente abierto. El agente decide qué consolidar. En las dos
ejecuciones de verificación eligió generalizar los agentes, las instrucciones y los
checklists del taller, y los dejó en `entregables/activos/` con un README. Ninguna de las
dos tocó el escenario, aunque la skill lo permite, incluida la migración del dinero a un
tipo decimal (DEF-01). Si alguien lo intenta, el comparador le va a mostrar cuánto cambió
la salida, y es una buena conversación sobre el costo de corregir DEF-01 de verdad.

El paso 2 produce el documento de línea base de medición y presupuesto de créditos. Es un
entregable del temario. Se apoya en lo que se vio en el subtema 1.3 sobre el consumo de
cada modo de trabajo.

## Qué mirar en el paso 1

- Qué decidió el agente sin que nadie lo acotara, y si se puede usar al día siguiente.
- Errores de formato. En una ejecución de verificación el agente creó una skill como un
  archivo `nombre.skill.md` suelto. Visual Studio Code no la reconoce. Una skill es un
  directorio con un `SKILL.md` adentro. Es un ejemplo concreto de por qué se revisa.
- Cantidad de archivos. Diez y catorce en las dos ejecuciones. La pregunta para la sala es
  cuántos de ellos usarían de verdad.

## Qué mirar en el paso 2

- Que no invente precios, cuotas ni límites. La skill lo prohíbe y la verificación lo
  cumplió, dejando campos a completar.
- Que las métricas tengan fuente y responsable.

## Tiempos

| Paso | Estimado | Observado en la verificación |
|---|---|---|
| 1 | 32 min | 251 y 384 s de agente, entre 10 y 14 archivos |
| 2 | 8 min | 86 s de agente |

Si el paso 1 sigue corriendo a los 32 minutos, pida que lo detengan y pasen al paso 2.

## Si alguien se atrasa

Que haga el paso 2 primero. Es el entregable obligatorio.

## Solución de referencia

`docs/relator/soluciones/lab-5-4/activos-ejemplo/`, el resultado de una ejecución de
verificación del paso 1. Sirve como ejemplo de lo que produce el agente, no como respuesta
correcta. No modifica el escenario, así que la compilación y el comparador no cambian.
