# Notas del relator, laboratorio 5.3

Estrategia de pruebas, documentación Markdown y checklist de revisión. 45 minutos.

## Qué va a pasar en la sala

El paso 1 crea pruebas de la selección de tramo y termina con una tabla que compara, en
cada borde, el tramo que elige la calculadora de comisión con el que elige el cierre de la
liquidación. No coinciden en ninguno de los tres bordes (DEF-08).

| Monto | Calculadora de comisión | Cierre de la liquidación |
|---|---|---|
| 500.00 | 3,5 % | 2,9 % |
| 2000.00 | 2,9 % | 2,5 % |
| 10000.00 | 2,5 % | 2,1 % |

Al comercio se le cotiza con una y se le cobra con la otra.

**Punto delicado.** Las reglas de negocio de `escenario/README.md` no dicen a qué tramo
pertenece un monto que cae exactamente en el límite. No hay una respuesta correcta en el
material. La conclusión que se busca en la sala es que las dos implementaciones tienen que
coincidir y que decidir cuál vale es una decisión de negocio, no del desarrollador ni del
agente. Si alguien afirma que una de las dos es la correcta, pregunte en qué regla se
apoya.

La verificación encontró además que un monto negativo cae en el último tramo en las dos
calculadoras. No figura en el catálogo de defectos. Ver la sección de hallazgos del informe
de SPEC-009. Si aparece en la sala, se reconoce y no se corrige.

El paso 2 documenta la estrategia de pruebas en Markdown. El paso 3 revisa el diff y
clasifica hallazgos. Es el momento de proyectar el caso de clase 01,
`docs/relator/casos-de-clase/caso-01-escaner-vs-defectos-plantados.md`. El paso 4 produce el
checklist humano.

DEF-05 queda a la vista desde el inicio. Hay veinte pruebas y ninguna cubre la lógica de
negocio.

## Errores típicos

- Pruebas que documentan lo que el código debería hacer en lugar de lo que hace. Fallan, y
  el participante cree que escribió mal la prueba.
- El agente corrige una de las dos calculadoras para que coincidan. La skill lo prohíbe,
  pero hay que mirar el diff.
- Revisar en el paso 3 el escenario completo en lugar del diff. Si el diff está vacío, la
  skill revisa el escenario y lo dice, lo que es correcto.

## Tiempos

| Paso | Estimado | Observado en la verificación |
|---|---|---|
| 1 | 12 min | 31 a 54 s de agente por escenario, con pruebas |
| 2 | 9 min | 56 s de agente |
| 3 | 9 min | 51 s de agente |
| 4 | 8 min | 28 s de agente |

## Iteración de la skill del paso 1

La primera versión pedía probar solo la calculadora de comisión. En las dos ejecuciones de
verificación el agente escribió pruebas correctas pero no llegó a ver la diferencia con la
liquidación. Se agregó la sección «Contraste con el cierre de la liquidación» y en las dos
ejecuciones siguientes la divergencia apareció en los dos escenarios.

## Opcional

Las pruebas del recargo por cuotas con su máximo, del tope mensual y de la retención están
marcadas como opcionales en el enunciado. Ahí aparece la diferencia 3.0 y 3.5 del tope del
recargo si alguien no la vio en el 5.2.

## Si alguien se atrasa

El paso 2 funciona sin el paso 1. Si alguien no terminó el paso 1 a los 15 minutos, que
pase al paso 2 y vea la tabla de bordes en la pantalla de un compañero.

## Solución de referencia

`docs/relator/soluciones/lab-5-3/paso-1-probar-tramos-java.patch` y
`paso-1-probar-tramos-dotnet.patch`. Un archivo nuevo de pruebas en cada escenario,
verificado sobre una copia limpia. 30 pruebas en verde y el comparador en cero.
