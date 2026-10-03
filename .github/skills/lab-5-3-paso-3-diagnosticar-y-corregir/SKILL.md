---
name: lab-5-3-paso-3-diagnosticar-y-corregir
description: 'Lab 5.3 paso 3, mantención correctiva. Diagnostica por qué el pipeline está en rojo, separa las causas, corrige y deja el pipeline en verde.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Llevar el pipeline de rojo a verde entendiendo por qué estaba en rojo. Es la mantención
correctiva de [CICLO-DE-VIDA.md](../../../CICLO-DE-VIDA.md).

El participante indica su stack, `java` o `dotnet`. Si no lo indicó, pregúntale y no hagas
nada más hasta que responda.

# Qué hacer

1. Anota en `docs/proyecto/registro-de-tiempos.md` la hora actual en Mantención.
2. Reproduce el rojo con `bash scripts/integracion-local.sh`. Según el caso, falla la
   conciliación, las pruebas del reporte, o las dos.
3. Diagnostica hasta el nivel de comercio y de transacción. Encuentra qué comercios explican
   la diferencia y cuánto aporta cada uno. Si la diferencia tiene más de una causa,
   sepáralas: para cada una, qué transacciones la producen, cuánto suma y qué regla de
   `escenario/README.md` está en juego. No te detengas en la causa más grande: la suma de
   las causas tiene que dar la diferencia completa, al centavo.
4. Si una causa depende de una regla que el README no decide, detente y dile al participante
   que le lleve la pregunta al negocio, que en esta sala es el relator. No elijas tú.
5. Con la decisión del negocio, propón la corrección mínima en el escenario del stack: solo
   lo necesario para cada causa, sin refactorizar. Espera la aprobación del participante y
   aplícala.
6. La corrección cambia la liquidación de algún periodo a propósito. Muestra qué periodos y
   qué comercios cambian, y actualiza en `scripts/integracion/liquidacion-esperada.sha256`
   solo los hashes de esos periodos. Explica al participante que ese cambio se justifica en
   la descripción del pull request.
7. Ejecuta `bash scripts/integracion-local.sh` hasta que todo esté en verde.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No cambies una prueba ni un hash esperado para que algo pase sin una causa explicada.
- Solo el stack indicado.
- No hagas commit.

# Salida esperada

Una tabla de causas con transacciones, comercios y monto, la suma de las causas contra la
diferencia, el diff de la corrección y el pipeline en verde.
