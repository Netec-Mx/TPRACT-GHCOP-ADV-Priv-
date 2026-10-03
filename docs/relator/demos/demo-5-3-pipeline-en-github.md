# Demostración 5.3. El mismo pipeline, en GitHub

**Objetivo.** Mostrar en GitHub lo que la sala hizo en local: el pipeline en rojo en Actions
por la conciliación, el verde después de la mantención correctiva y la revisión de Copilot
en el pull request.

**Subtema y sesión.** 5.3, sesión 4, en la puesta en común. **Duración.** 5 minutos.

**Se presenta desde el respaldo.** [`../respaldos/demo-5-3.md`](../respaldos/demo-5-3.md) tiene
la corrida real grabada, con las dos ejecuciones del pipeline y sus registros. No hace falta
conexión, copia propia en GitHub ni esperar a Actions. Hacerla en vivo es opcional, con los
pasos de abajo.

## Pasos desde el respaldo

1. Abra el respaldo en la sección «Primera corrida». Muestre la tabla de trabajos: compila,
   pruebas y equivalencia en verde, conciliación en rojo.

   Diga: «Es el mismo rojo que vieron en `integracion-local.sh`. El pipeline es el mismo
   script; GitHub solo lo corre en otra máquina.»

2. Muestre el registro de la conciliación: abril y mayo concilian, junio no, por 2203
   centavos en los dos stacks.

3. Pase a «Segunda corrida», después de empujar la corrección y el hash de junio. Todo en
   verde, y los tres hashes esperados coinciden.

   Diga: «El cambio del hash de junio está en el diff del pull request, a la vista del
   revisor. Por eso no es trampa: es una decisión que se revisa.»

4. Muestre la sección «Revisión de Copilot». Si figura como pendiente, diga que la revisión de
   Copilot en un pull request es la misma que pidieron en local con el botón de la vista
   **Source Control**, y siga.

## Pasos en vivo, opcionales

Solo si usted quiere hacerla en vivo y tiene una copia del repositorio en GitHub con Actions
habilitado.

1. En una rama, aplique el reporte y el paso de conciliación con los parches de
   `../soluciones/lab-5-3/`, en el orden de su README, sin la corrección. Empuje y abra el
   pull request. Espere el rojo, alrededor de un minuto.
2. Aplique la corrección de su stack y `hash-junio.patch`, confirme y empuje. Espere el verde.
3. En el pull request, pida la revisión de Copilot desde **Reviewers**.
4. Cierre el pull request sin integrar.

## Qué puede salir distinto

- Si Actions tarda o la sala no tiene red, quédese con el respaldo. Es la forma prevista.
- Si la revisión de Copilot no está disponible en la cuenta, dígalo y muestre la revisión
  local.

## La idea que se cierra

El pipeline local y el de GitHub son el mismo. Lo que GitHub agrega es el lugar donde el
equipo ve el rojo, el verde y la revisión al mismo tiempo, en el pull request.
