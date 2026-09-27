# Notas del relator, laboratorio 4.4

Generación breve de documentación Markdown para un proyecto Java o .NET. 30 minutos.

## Qué va a pasar en la sala

**Momento clave del taller.** El paso 1 pide documentar el cálculo de comisiones leyendo
el código. `PlanComisiones` tiene un comentario que afirma que los tramos son acumulativos
(DEF-10). La regla 2 de `escenario/README.md` dice lo contrario y el código aplica un solo
tramo. Un agente que tome el comentario como verdad documenta el cálculo al revés, con
total seguridad.

La skill pide documentar desde el código y contrastar después con las reglas declaradas,
así que lo más probable es que el documento salga correcto y que la sección de contraste
mencione el comentario. Si en alguna pantalla el documento dice «acumulativos», proyéctelo.
Es el mejor ejemplo del taller sobre por qué la documentación generada se revisa.

La otra diferencia que suele aparecer en el contraste es la de los bordes de tramo, que se
trabaja en el 5.3. Si aparece aquí, se anota y se deja para ese laboratorio.

El paso 2 produce un registro de decisiones. Dos salen del material, la configuración
regional fija en Java y la compatibilidad de redondeo en .NET. La tercera la elige el
participante.

El paso 3 prepara una copia para Confluence y lista lo que se pierde.

## Errores típicos

- Aceptar el documento del paso 1 sin abrir ninguna de las líneas que cita.
- Documentar lo que dicen los comentarios de clase en lugar de lo que hace el código.
- Pegar código completo en el documento. La convención es citar archivo y línea.

## Tiempos

| Paso | Estimado | Observado en la verificación |
|---|---|---|
| 1 | 10 min | Ver el registro de verificación de SPEC-009 |
| 2 | 10 min | Ver el registro de verificación de SPEC-009 |
| 3 | 8 min | Ver el registro de verificación de SPEC-009 |

Es el laboratorio con menos holgura del taller, dos minutos. Si la sesión 4 viene
atrasada, el paso 3 se muestra en pantalla en lugar de hacerlo.

## Si alguien se atrasa

Que haga solo el paso 1. Es el que tiene el momento clave.

## Solución de referencia

No hay. El laboratorio no modifica código.
