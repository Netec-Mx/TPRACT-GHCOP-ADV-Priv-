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

1. Anota en `docs/proyecto/registro-de-tiempos.md` la hora de inicio de Mantención, con
   `date +%H:%M`, y `participante` en Origen.
2. Reproduce el rojo con `bash scripts/integracion-local.sh`. Según el caso, falla la
   conciliación, las pruebas del reporte, o las dos.
3. Diagnostica hasta el nivel de comercio y de transacción. Encuentra qué comercios explican
   la diferencia y cuánto aporta cada uno. Si la diferencia tiene más de una causa,
   sepáralas: para cada una, qué transacciones la producen, cuánto suma y qué regla de
   `escenario/README.md` está en juego. No te detengas en la causa más grande: la suma de
   las causas tiene que dar la diferencia completa, al centavo.
4. Explica por separado cada causa con su monto y los comercios afectados, aunque las
   pruebas ya hayan dejado alguna en evidencia. Una prueba que falla muestra un caso, no
   cuánto suma la causa ni a quién más afecta. Si la conciliación da cero porque el reporte
   comparte el cálculo de la liquidación, la diferencia completa no aparece sola:
   obténla comparando, comercio por comercio, el total de comisiones de la liquidación con
   un cálculo exacto e independiente de las reglas de `escenario/README.md`, con decimal y
   sin punto flotante, y explica esa diferencia completa, no solo lo que fallan las
   pruebas. Donde el README no decide un caso, el cálculo usa la respuesta del negocio de
   la tabla de preguntas de la historia, como dice el punto 5.
5. Si una causa depende de una regla que el README no decide, busca primero la respuesta del
   negocio en la tabla de preguntas de `docs/proyecto/historia-reporte-medios-de-pago.md`. Si
   está, úsala y cítala. Si no está, detente y dile al participante que le lleve la pregunta
   al negocio, que en esta sala es el relator. No elijas tú.
6. Con la decisión del negocio, propón la corrección mínima en el escenario del stack: solo
   lo necesario para cada causa, sin refactorizar. Distingue dos casos y di en cuál está
   cada corrección. Una diferencia del cálculo de comisión se corrige en la liquidación, no
   en el reporte. Un error del propio reporte, como un formato que redondea antes de tiempo,
   se corrige en el reporte, porque es código que el participante escribió en el 5.2; suelen
   encontrarlo las pruebas del paso 1. Si el reporte reutiliza el cálculo de la liquidación,
   queda corregido con la misma corrección: no propongas reescribirlo. Si el reporte calcula
   por su cuenta, la conciliación queda en cero al corregir la liquidación. Si la corrección
   exige algo que las instrucciones del repositorio prohíben salvo pedido explícito, como
   cambiar un tipo de dato o una forma de redondear, dilo y muestra qué regla toca. Espera
   la aprobación del participante y recién entonces aplícala.
7. La corrección cambia la liquidación de algún periodo a propósito. Muestra qué periodos y
   qué comercios cambian, y actualiza en `scripts/integracion/liquidacion-esperada.sha256`
   solo los hashes de esos periodos. Explica al participante que ese cambio se justifica en
   la descripción del pull request. Explícale también que la corrección es solo del stack de
   `scripts/integracion/stack.txt`: el otro stack conserva la diferencia, queda fuera del
   alcance y la descripción del pull request lo deja escrito. No lo corrijas.
8. Comprueba la corrección antes de darla por buena: `bash scripts/verificar-reporte.sh
   <stack> P` tiene que coincidir en 2026-04, 2026-05 y 2026-06, y la conciliación tiene
   que dar cero en los tres periodos. Si propones cambiar solo la forma de redondear, pruébalo primero en junio: no lo
   des por bueno hasta que junio coincida.
9. Ejecuta `bash scripts/integracion-local.sh` hasta que todo esté en verde.
10. Al terminar, anota en el registro de tiempos la hora de término de Mantención. Si su
   sección «Hallazgos abiertos» tiene alguno que esta corrección resuelve, márcalo como
   resuelto en el 5.3, con el comando que ahora pasa.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No cambies una prueba ni un hash esperado para que algo pase sin una causa explicada.
- Solo el stack indicado.
- No hagas commit.

# Salida esperada

Una tabla de causas con transacciones, comercios y monto, y la suma de las causas contra la
diferencia. Al terminar, muestra en el chat el diff completo de la corrección, con `git diff
--` y los archivos que cambiaste en este paso, incluido
`scripts/integracion/liquidacion-esperada.sha256`, no un resumen. Los cambios de los pasos 1
y 2 todavía no están confirmados: no los repitas. Muestra también
`docs/proyecto/registro-de-tiempos.md` completo, con la hora que anotaste. Al final, el
pipeline en verde.
