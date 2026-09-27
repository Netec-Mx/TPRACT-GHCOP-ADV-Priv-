# Notas del relator, laboratorio 5.1

Preparación del escenario integrador y criterios de evaluación. 45 minutos.

## Qué va a pasar en la sala

El paso 1 fija la línea base. Los dos escenarios compilan, las pruebas pasan y el
comparador termina en cero. Si algo falla aquí, detenga a esa persona y resuélvalo antes
de seguir, porque el 5.2 y el 5.3 comparan contra esta línea base.

El paso 3 revisa las nueve reglas de negocio contra el código. Es el paso donde aparecen
dos defectos que ningún otro laboratorio del camino obligatorio ejercita.

- **Regla 9, redondeo (DEF-01).** La skill pide recalcular con aritmética decimal exacta el
  total de comisiones de un comercio. Los comercios que muestran la diferencia son CM0011,
  CM0016 y CM0025, a los que les falta un centavo. Si el agente eligió otro comercio y no
  encontró diferencia, pídale que repita con CM0011.
- **Regla 8, periodo en hora de Lima (DEF-04).** Las fechas se calculan con la zona
  horaria del sistema. La transacción TX002005, del 30 de junio a las 23:59, entra o sale
  del periodo según la configuración de la máquina.

Suelen aparecer también el tope del recargo (DEF-03), los bordes de tramo (DEF-08) y el
comercio suspendido liquidado (DEF-09). Se registran en el inventario y ninguno se corrige.

El paso 4 convierte el inventario en criterios verificables. Acuérdelos en voz alta con la
sala, porque se usan en el 5.2 y el 5.3.

## Errores típicos

- Intentar arreglar un fallo del paso 1 con el agente. Si la compilación falla, es un
  problema de ambiente y lo resuelve el relator.
- Inventarios que dicen «el código usa double» sin decir qué regla se incumple ni cuánto
  dinero está en juego.
- Criterios que son opiniones, como «el código queda más limpio». La skill los excluye.

## Tiempos

| Paso | Estimado | Observado en la verificación |
|---|---|---|
| 1 | 8 min | 41 s de agente, con compilación, pruebas y comparador |
| 2 | 10 min | 39 s de agente |
| 3 | 12 min | 92 s de agente. Recalculó los 39 comercios y encontró los tres centavos |
| 4 | 10 min | 26 s de agente |

## Si alguien se atrasa

El paso 2 se puede reemplazar por un mapa proyectado por el relator. Los pasos 1, 3 y 4
no se saltan.

## Solución de referencia

No hay. El laboratorio no modifica código.
