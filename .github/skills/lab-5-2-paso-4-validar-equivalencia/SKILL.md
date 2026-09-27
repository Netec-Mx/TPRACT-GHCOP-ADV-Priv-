---
name: lab-5-2-paso-4-validar-equivalencia
description: 'Lab 5.2 paso 4. Ejecuta el comparador de escenarios e interpreta el resultado de la refactorización.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Comprobar si las refactorizaciones de los pasos 2 y 3 cambiaron el comportamiento.
Funciona igual si el participante no alcanzó a hacer esos pasos.

# Qué hacer

1. Muestra qué archivos de `escenario/` cambiaron respecto del último commit, con
   `git status --short escenario/`.
2. Desde la raíz del repositorio, ejecuta [comparar-escenarios.sh](../../../scripts/comparar-escenarios.sh):

   ```bash
   bash scripts/comparar-escenarios.sh
   ```

3. Interpreta el resultado:
   - Código `0`: la refactorización no cambió la salida.
   - Código `1`: cambió. Identifica la primera línea distinta, el comercio al que
     pertenece y qué parte del cambio la explica.
   - Código `2`: algo impidió comparar, casi siempre un error de compilación. Muestra
     el error.
4. Ejecuta también las pruebas del escenario del participante y di cuántas pasan.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- **No corrijas la diferencia si la hay.** Este paso diagnostica. La corrección la
  decide el participante.
- No modifiques ningún archivo.

# Salida esperada

Los archivos cambiados, el código de salida del comparador, su interpretación y el
resultado de las pruebas.
