---
name: lab-5-2-paso-3-verificar-reporte
description: 'Lab 5.2 paso 3. Verifica el reporte contra la salida esperada y la liquidación contra sus hashes, y confirma el trabajo en la rama.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Comprobar lo que se construyó en el paso 2 con las herramientas del repositorio, sin
interpretar.

El participante indica su stack, `java` o `dotnet`. Si no lo indicó, pregúntale y no hagas
nada más hasta que responda.

# Qué hacer

1. Ejecuta `bash scripts/verificar-reporte.sh <stack> P` para 2026-04, 2026-05 y 2026-06,
   los tres, antes de proponer ningún commit.
2. Ejecuta `bash scripts/integracion-local.sh`.
3. Muestra una tabla con cada comprobación y su resultado. `verificar-reporte.sh` solo
   compara hashes: no dice en qué líneas difiere. Si algún periodo no coincide, muestra la
   salida del reporte de ese periodo, sin corregir nada y sin explicar la causa: se
   diagnostica en el 5.3. Anótalo en una sección «Pendiente para el 5.3» de tu respuesta.
4. Anota en `docs/proyecto/registro-de-tiempos.md` la hora de término de Desarrollo, con
   `date +%H:%M`. Si algún periodo no coincidió, agrega en la sección «Hallazgos abiertos»
   del registro una línea por periodo, con el comando que lo muestra, por ejemplo
   «5.2: `verificar-reporte.sh java 2026-06` no coincide». Sin causa. Son los únicos
   cambios de archivo de este paso.
5. Si el pipeline local está en verde, propone al participante el commit con los archivos
   del reporte, el registro de tiempos y la especificación entregada, por ejemplo
   `git add escenario docs/proyecto && git commit -m "Reporte de comisiones por medio de
   pago"`. Si algún periodo no coincidió, el mensaje lo dice, por ejemplo con un segundo
   `-m "Hallazgo abierto: verificar-reporte no coincide en 2026-06"`. Espera a que lo
   confirme. Tú no haces el commit.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques archivos en este paso, salvo el registro de tiempos.

# Salida esperada

La tabla de comprobaciones, `docs/proyecto/registro-de-tiempos.md` completo con la hora de
término que anotaste, no un resumen, y, si corresponde, lo pendiente para el 5.3.
