# Notas del relator, laboratorio 5.4

Laboratorio final: construcción de activos reutilizables. 45 minutos. Fases de Liberación,
Operación y soporte y Mantención evolutiva, y el cierre del ciclo.

## Qué va a pasar en la sala

**El 5.4 no se reinicia.** Continúa sobre lo que dejaron el 5.1 al 5.3 en la rama de cada
participante. `reiniciar-lab.sh lab-5-4` lo advierte y pide escribir `descartar`.

**Paso 1, liberación.** La conversación que vale es el número de versión. 1.1.0 es la
respuesta de referencia; 2.0.0 se puede defender porque cambian montos que ya se cobraban;
1.0.1 no, porque se agrega una funcionalidad. Lo importante es que las notas expliquen el
cambio de junio en lenguaje de negocio.

**Paso 2, el incidente.** No tiene que repartir nada. La skill ejecuta
`scripts/proyecto/entregar.sh incidente`, que crea el reclamo de CM0001 en
`docs/proyecto/incidentes/`. El texto viaja codificado en el script para que nadie lo lea
antes. El análisis tiene que llegar a las notas de versión y a la decisión del borde. Si
alguien propone revertir la versión, pregunte qué decisión respalda el monto nuevo y dónde
está registrada.

**Paso 3, la evolutiva.** La solicitud está publicada en el backlog. No la tiene que
proponer usted. Lo que vale la pena observar es si la estimación usa como dato el registro de
tiempos real del ciclo.

**Paso 4, el cierre.** El estimado contra el real. En la puesta en común, pida la fase donde
cada uno más se equivocó. Suele ser Requerimientos o Mantención, que dependen de personas y
no del agente.

## Errores típicos

- Notas de versión con nombres de clases.
- Una respuesta al comercio que promete devolver la diferencia.
- Un presupuesto con precios inventados.

## Tiempos

| Paso | Estimado | Observado en la verificación |
|---|---|---|
| 1 | 8 min | 37 a 50 s de agente y 2 a 3 comandos, en 2 corridas |
| 2 | 12 min | 54 a 56 s de agente y 3 a 4 comandos, en 2 corridas |
| 3 | 8 min | 34 a 42 s de agente y 2 a 3 comandos, en 2 corridas |
| 4 | 10 min | 62 a 71 s de agente y 2 a 3 comandos, en 2 corridas |

Suma 38. Quedan 7 para la puesta en común y el cierre del taller.

## Si alguien se atrasa

Sin el 5.3 terminado, aplíquele la solución del 5.3 con los parches de
`../soluciones/lab-5-3/`. El paso 2 funciona con cualquier estado de la rama: el incidente
se analiza con las notas de referencia de `../soluciones/lab-5-4/README.md`.

## Solución de referencia

En `../soluciones/lab-5-4/README.md`: la versión y las notas, el análisis y la respuesta al
incidente, y tres evolutivas posibles con su estimación.
