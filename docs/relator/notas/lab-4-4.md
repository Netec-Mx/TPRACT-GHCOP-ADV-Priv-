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

El paso 2 registra una decisión técnica que el repositorio todavía no tiene documentada: el
escenario no usa frameworks ni dependencias de ejecución, solo dependencias de prueba. Se
eligió en SPEC-015 por tres razones. Se observa en el código, en `pom.xml` y en los dos
`.csproj`. Ninguna de las tres decisiones de `docs/arquitectura/decisiones/` la cubre; antes
el paso pedía la configuración regional y la compatibilidad de redondeo, que la decisión 0001
ya contiene y el participante tiene a la vista. Y no revela ningún defecto del catálogo.

Lo que se revisa es que el documento separe lo que el código respalda, que no hay
dependencias de ejecución, de lo que es una suposición sobre el porqué, que tiene que quedar
marcada como pendiente de confirmar. Si alguien pregunta el porqué, la respuesta está en las
preguntas difíciles de la guía: el escenario tiene que existir en los dos stacks con la misma
salida, compilar sin descargas y ser chico.

El paso 3 prepara una copia para Confluence y lista lo que se pierde.

El paso 4 es opcional y queda fuera de los 30 minutos. Genera el runbook de troubleshooting
del cálculo con la plantilla de `docs/operacion/runbook-plantilla.md` y ejecuta cada acción
antes de marcarla como verificada. Sirve para quien termina antes y como tarea posterior.
Lo que se revisa es lo mismo que en el paso 1: que nada figure como verificado sin
evidencia.

**La regla 8 puede salir clasificada distinto.** En la verificación, el mismo agente la
dio como no cumplida en el 4.4 y como «cumple en la práctica, sin garantía» en el 5.1. Si
pasa en la sala, no es un error. Pregunte qué criterio usó cada uno y diga que, para comparar
clasificaciones, el criterio tiene que estar escrito en el pedido. Ver HALLAZGO-07 en
`03-hallazgos.md`.

## Errores típicos

- Aceptar el documento del paso 1 sin abrir ninguna de las líneas que cita.
- Documentar lo que dicen los comentarios de clase en lugar de lo que hace el código.
- Pegar código completo en el documento. La convención es citar archivo y línea.

## Tiempos

| Paso | Estimado | Observado en la verificación |
|---|---|---|
| 1 | 10 min | 53 s de agente |
| 2 | 10 min | 41 s de agente |
| 3, opcional | Fuera del tiempo | 55 s de agente |
| 4, opcional | Fuera del tiempo | 156 s de agente y unas 18 aprobaciones. Se estiman 8 a 12 minutos de participante |

En la verificación el agente documentó los tramos como no acumulativos, desde el código, y señaló el comentario. Con Copilot puede salir distinto. Desde SPEC-026 los pasos obligatorios son el 1 y el 2: 10 + 10 = 20 de 30, el 67 %. El paso
3, Confluence, y el 4, el runbook, son opcionales. Si la sesión viene con tiempo, haga el 3
o muéstrelo en pantalla: conecta con el subtema 4.3.

## Si alguien se atrasa

Que haga solo el paso 1. Es el que tiene el momento clave.

## Solución de referencia

No hay. El laboratorio no modifica código.
