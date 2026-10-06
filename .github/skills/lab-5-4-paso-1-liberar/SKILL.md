---
name: lab-5-4-paso-1-liberar
description: 'Lab 5.4 paso 1, fase de Liberación. Versiona el cambio, actualiza el registro de cambios y escribe las notas de versión.'
disable-model-invocation: true
---

# Objetivo

Liberar el reporte y la corrección como una versión nueva, con su registro de cambios y sus
notas para el negocio. Es la fase de Liberación de [CICLO-DE-VIDA.md](../../../CICLO-DE-VIDA.md).

# Qué hacer

Este paso tiene dos turnos. En el primero no escribes ningún archivo.

**Primer turno.**

1. Toma la hora de inicio de Liberación con `date +%H:%M` y recuérdala; la anotas en el
   segundo turno.
2. Lee el registro de cambios y lo que hay en la rama desde la versión vigente, 1.4.0: el
   reporte, la conciliación en el pipeline y la corrección de la liquidación. Usa el criterio
   de versionado de la skill `pasarela-notas-de-version`.
3. Propón el número de versión, justifícalo y **termina tu turno**. No escribas el registro de
   cambios, las notas ni el registro de tiempos hasta que el participante confirme el número.

**Segundo turno, con el número confirmado.**

4. Anota en `docs/proyecto/registro-de-tiempos.md` la hora de inicio que tomaste, con
   `participante` en Origen.
5. Sigue la skill `pasarela-notas-de-version` con el número confirmado. Las notas de versión
   van en `docs/proyecto/notas-de-version-<versión>.md`. La sección de montos tiene que
   explicar, en lenguaje de negocio, por qué cambia la liquidación de junio y para qué
   comercios, con los montos antes y después.
   Arma la tabla de montos con dos ejecuciones de la liquidación de junio: la actual y la de
   antes de la corrección. La de antes se compila en una carpeta temporal fuera del
   repositorio, con `git archive <commit anterior a la corrección> escenario | tar -x -C
   <carpeta>` en Git Bash. Compara las dos salidas comercio por comercio, total de comisiones y neto, y
   di si cada monto sube o baja según el signo de la diferencia, después menos antes. No lo
   deduzcas de la descripción del cambio.
6. Anota en el registro de tiempos la hora de término de Liberación.
7. Propón el commit y espera la confirmación del participante.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No crees etiquetas ni empujes.

# Salida esperada

En el primer turno, solo el número de versión con su justificación, sin archivos escritos.
En el segundo, al terminar, muestra en el chat la entrada
completa que agregaste a `CHANGELOG.md`, el contenido completo de las notas de versión y
`docs/proyecto/registro-de-tiempos.md` completo, con la hora que anotaste, no un resumen.

Escribe ese contenido en el texto de tu respuesta, como Markdown o en un bloque de código.
No basta con ejecutar `cat` o `git diff` en la terminal ni con decir que ya se ve en la
vista de una herramienta: el participante lo tiene que poder leer en tu respuesta.
