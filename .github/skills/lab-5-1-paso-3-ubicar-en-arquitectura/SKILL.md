---
name: lab-5-1-paso-3-ubicar-en-arquitectura
description: 'Lab 5.1 paso 3, fase de Análisis y diseño. Ubica el reporte en el mapeo BIAN y registra la decisión de dónde vive.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Decidir dónde vive el reporte en el sistema y dejar la decisión registrada. Es la fase de
Análisis y diseño de [CICLO-DE-VIDA.md](../../../CICLO-DE-VIDA.md).

El participante indica su stack, `java` o `dotnet`. Si no lo indicó, pregúntale y no hagas
nada más hasta que responda.

Material de partida:

- `docs/proyecto/historia-reporte-medios-de-pago.md`
- [El mapeo BIAN](../../../docs/arquitectura/bian-mapeo.md)
- El código del escenario del stack indicado

# Qué hacer

1. Anota en `docs/proyecto/registro-de-tiempos.md` la hora de inicio de Análisis y diseño, con `date +%H:%M`, y
   `participante` en Origen.
2. Ubica la responsabilidad del reporte en el mapeo: a qué dominio de servicio pertenece y
   qué componentes del escenario necesita leer. Cita archivo y línea.
3. Propón al menos dos alternativas de dónde vive el código del reporte, por ejemplo una
   clase propia o un método dentro de una clase existente, y para cada una qué tendría que
   reutilizar o duplicar.
4. Pregunta al participante qué alternativa elige. Con su respuesta, registra la decisión
   con la skill `pasarela-registrar-decision` en `docs/arquitectura/decisiones/`. Registra
   la alternativa que el participante eligió de verdad, con sus consecuencias, aunque no
   sea la que recomendarías. Si elige reutilizar el cálculo de comisión de la liquidación,
   una de sus consecuencias es que el reporte hereda cualquier diferencia de ese cálculo.
5. Al terminar, anota en el registro de tiempos la hora de término de Análisis y diseño.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques código. Este paso decide; el 5.2 implementa.

# Salida esperada

Muestra en el chat el contenido completo de la decisión creada, la fila que agregaste al
índice de `docs/arquitectura/decisiones/README.md` y `docs/proyecto/registro-de-tiempos.md`
completo, con la hora que anotaste, no un resumen. Al final, qué componentes del escenario
va a tocar el 5.2.

Escribe ese contenido en el texto de tu respuesta, como Markdown o en un bloque de código.
No basta con ejecutar `cat` o `git diff` en la terminal ni con decir que ya se ve en la
vista de una herramienta: el participante lo tiene que poder leer en tu respuesta.
