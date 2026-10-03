---
name: lab-5-4-paso-1-liberar
description: 'Lab 5.4 paso 1, fase de Liberación. Versiona el cambio, actualiza el registro de cambios y escribe las notas de versión.'
disable-model-invocation: true
---

# Objetivo

Liberar el reporte y la corrección como una versión nueva, con su registro de cambios y sus
notas para el negocio. Es la fase de Liberación de [CICLO-DE-VIDA.md](../../../CICLO-DE-VIDA.md).

# Qué hacer

1. Anota en `docs/proyecto/registro-de-tiempos.md` la hora actual en Liberación.
2. Sigue la skill `pasarela-notas-de-version` con lo que hay en la rama desde la versión
   1.0.0: el reporte, la conciliación en el pipeline y la corrección de la liquidación.
3. Las notas de versión van en `docs/proyecto/notas-de-version-<versión>.md`. La sección de
   montos tiene que explicar, en lenguaje de negocio, por qué cambia la liquidación de junio
   y para qué comercios, con los montos antes y después obtenidos de una ejecución.
4. Propón el commit y espera la confirmación del participante.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No crees etiquetas ni empujes.

# Salida esperada

El número de versión con su justificación, la entrada del registro de cambios y las notas.
