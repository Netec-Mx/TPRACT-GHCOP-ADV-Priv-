---
name: lab-5-3-paso-1-probar-criterios
description: 'Lab 5.3 paso 1, fase de Pruebas. Escribe las pruebas del reporte a partir de los criterios de aceptación de la historia.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Convertir cada criterio de aceptación de la historia en pruebas automáticas del reporte. Es
la fase de Pruebas de [CICLO-DE-VIDA.md](../../../CICLO-DE-VIDA.md).

El participante indica su stack, `java` o `dotnet`. Si no lo indicó, pregúntale y no hagas
nada más hasta que responda.

# Qué hacer

1. Anota en `docs/proyecto/registro-de-tiempos.md` la hora de inicio de Pruebas, con `date +%H:%M`, y
   `participante` en Origen.
2. Lee `docs/proyecto/historia-reporte-medios-de-pago.md`. Para cada criterio que se pueda
   comprobar con una prueba unitaria, escribe al menos una prueba en archivos nuevos del
   proyecto de pruebas del stack, con el estilo de las pruebas existentes. Los criterios con
   un valor esperado concreto, como el del límite de un tramo o el de un comercio cuya suma
   termina en medio centavo, se prueban con ese valor exacto. Cada criterio tiene su prueba,
   también el de formato: se prueba sobre la función que da formato a la salida, con un
   caso de medio centavo y uno con miles. La comparación por hash de
   `scripts/verificar-reporte.sh` no reemplaza esa prueba. La prueba del criterio de
   conciliación ejecuta la liquidación y el reporte para el mismo periodo, con los datos del
   escenario, y compara el total del reporte con la suma del total de comisiones de la
   liquidación. No compara el reporte consigo mismo ni con un cálculo hecho dentro de la
   prueba.
3. Si un criterio tiene un valor «pendiente», pregúntale al participante si ya tiene la
   respuesta del negocio. Si no la tiene, deja esa prueba fuera y dilo.
4. Ejecuta las pruebas del stack.
5. **Si alguna prueba falla, no la cambies para que pase y no cambies el código.** Muestra
   qué criterio no se cumple, con el valor esperado y el obtenido. Se diagnostica en el
   paso 3.
6. Al terminar, anota en el registro de tiempos la hora de término de Pruebas.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Solo archivos de prueba nuevos. No modifiques código de producción ni pruebas existentes.
- No hagas commit. La revisión del paso 4 revisa los cambios sin confirmar.

# Salida esperada

Muestra en el chat el contenido completo de cada archivo de prueba nuevo y
`docs/proyecto/registro-de-tiempos.md` completo, con la hora que anotaste, no un resumen.
Después, una tabla criterio por criterio con la prueba que lo cubre y su resultado.

Escribe ese contenido en el texto de tu respuesta, como Markdown o en un bloque de código.
No basta con ejecutar `cat` o `git diff` en la terminal ni con decir que ya se ve en la
vista de una herramienta: el participante lo tiene que poder leer en tu respuesta.
