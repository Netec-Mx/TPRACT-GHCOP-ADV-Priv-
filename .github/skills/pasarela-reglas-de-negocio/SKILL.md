---
name: pasarela-reglas-de-negocio
description: 'Reglas de negocio de Pasarela Andina y formato de sus archivos de datos. Úsala cuando haya que calcular a mano la comisión o la liquidación de un comercio, contrastar el código con las reglas o interpretar una línea de los archivos de datos.'
---

# Reglas de negocio de Pasarela Andina

La fuente de verdad funcional es [escenario/README.md](../../../escenario/README.md),
sección «Reglas de negocio». Léela antes de responder. Si el código, un comentario y esa
sección dicen cosas distintas, la sección manda, y la diferencia se informa sin corregir
nada que no se haya pedido.

## Cómo calcular a mano la comisión de una transacción

1. Busca el comercio en [comercios.txt](../../../escenario/datos/comercios.txt) y toma su
   plan, en la última columna.
2. Busca el plan en [planes.txt](../../../escenario/datos/planes.txt). La columna `tramos`
   tiene el formato `desde:hasta:porcentaje`, separados por `|`.
3. Aplica las reglas 1 a 4 de `escenario/README.md` en ese orden: tramo, porcentaje sobre
   el monto completo, monto fijo, recargo por cuotas con su máximo, anuladas sin comisión.
4. Muestra cada operación intermedia con todos sus decimales y redondea solo al final,
   según la regla 9.

## Cómo calcular a mano la liquidación de un comercio

Suma las comisiones del periodo, aplica el tope del plan (regla 6), descuenta los
contracargos aprobados del periodo (regla 5, archivo
[contracargos.txt](../../../escenario/datos/contracargos.txt)) y aplica la retención de
garantía si corresponde (regla 7). El periodo va de un extremo al otro del mes en hora de
Lima (regla 8).

## Formato de los archivos de datos

Texto plano separado por punto y coma, con una línea de encabezado. Los encabezados dicen
qué es cada columna. Las fechas de transacción van en formato `AAAA-MM-DD HH:MM:SS`.

## Límites

- No modifiques ningún archivo de `escenario/datos/`. Otros resultados dependen de que
  esos datos se mantengan exactamente como están.
- Si una regla no alcanza para decidir un caso, dilo como pregunta abierta en lugar de
  suponer.
