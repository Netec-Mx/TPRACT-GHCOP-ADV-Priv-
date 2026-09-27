# Notas del relator, laboratorio 1.5

Análisis y mejora de un componente Java/.NET. 60 minutos.

## Qué va a pasar en la sala

| Paso | Qué suele aparecer |
|---|---|
| 1 | Entre ocho y doce responsabilidades en el método de cálculo, con lectura de archivos, cálculo, impresión y estadísticas mezcladas (DEF-02, DEF-06) |
| 2 | Los `catch` vacíos del cargador de datos. Una línea mal formada desaparece sin rastro y la liquidación cuadra igual (DEF-07) |
| 3 | `obtenerMontoNeto` recalcula y asigna, `buscarComerciosActivos` devuelve también los suspendidos y `validarTransaccion` acumula. `CM0031` está suspendido y aparece liquidado (DEF-09) |
| 4 | Propuestas variadas. La más frecuente es extraer el cálculo de comisión |
| 5 | Extracción de la retención de garantía a un método propio, con el comparador en cero |

En el paso 2, si hay tiempo, muestre en vivo cómo desaparece una línea. Corrompa el monto
de una transacción en `escenario/datos/transacciones.txt`, ejecute el escenario y compare
el total de transacciones. Después restaure con `bash scripts/reiniciar-lab.sh lab-1-5`.

## Errores típicos

- Hacer el paso 5 en modo **Ask**. El agente propone el cambio pero no lo aplica.
- Aprobar sin leer los comandos que el agente quiere ejecutar en la terminal. Es el
  momento de insistir en leerlos.
- Que el agente agregue un comentario de documentación al método nuevo. Ocurrió en las dos
  ejecuciones de verificación. No viola la restricción, pero vale la pena preguntar a la
  sala si lo habrían aceptado en un pull request.

## Tiempos

| Paso | Estimado | Observado en la verificación | Comentario |
|---|---|---|---|
| 1 a 4 | 10, 10, 10 y 12 min | Respuestas en segundos | El tiempo se va en leer y comparar |
| 5 | 12 min | Entre 26 y 42 segundos de agente, más compilación | El comparador compila los dos escenarios y tarda cerca de un minuto |

## Si alguien se atrasa

Que salte al paso 5. No depende de los anteriores, porque la zona a extraer está fijada.
Si el paso 5 falla, que reinicie con `bash scripts/reiniciar-lab.sh lab-1-5` y lo repita.

## Solución de referencia

`docs/relator/soluciones/lab-1-5/paso-5-extraer-retencion-java.patch` y
`paso-5-extraer-retencion-dotnet.patch`. Verificadas sobre una copia limpia del repositorio
de participantes. Un archivo modificado, compila, las 20 pruebas pasan y el comparador
termina en cero.

Para mostrarla, desde la raíz de un repositorio en su punto de partida:

```bash
git apply docs/relator/soluciones/lab-1-5/paso-5-extraer-retencion-java.patch
```

Las dos ejecuciones de verificación eligieron el mismo nombre de método,
`calcularRetencionGarantia`, pero lo ubicaron en lugares distintos de la clase. Es una
buena muestra de variabilidad aceptable.
