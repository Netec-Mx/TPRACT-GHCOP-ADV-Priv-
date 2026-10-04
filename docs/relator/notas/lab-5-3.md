# Notas del relator, laboratorio 5.3

Estrategia de pruebas, documentación Markdown y checklist de revisión. 45 minutos. Fases de
Pruebas, Integración continua, Mantención correctiva, Revisión de código y Seguridad.

## Qué va a pasar en la sala

**Paso 1.** Las pruebas salen de los criterios del 5.1. En el camino B del 5.2, el que
reutiliza el cálculo de la liquidación, las pruebas del borde de tramo y del tercer decimal
fallan aquí. En el camino A pasan.

**Paso 2.** El participante agrega la conciliación al pipeline con el agente. No recibe
`conciliar.sh`. En el camino A el pipeline queda en rojo por la conciliación de junio,
22,03. En el camino B la conciliación pasa, porque el reporte calcula igual que la
liquidación, y el rojo viene de las pruebas del paso 1. Los dos caminos llegan al mismo
lugar: algo está mal en el cálculo de la liquidación.

**Paso 3, la mantención correctiva.** El agente tiene que separar dos causas:

| Causa | Comercios | Monto |
|---|---|---|
| Borde de tramo, DEF-08 | CM0001 y CM0007, transacciones TX002001 a TX002004 | 22,00 |
| Punto flotante, DEF-01 | CM0011, CM0016 y CM0025 | 0,03 |

Las reglas de `escenario/README.md` no dicen a qué tramo pertenece un monto en el límite. Es
a propósito: el participante tiene que detectar la ambigüedad y escalarla, y el negocio es
usted. Cuando lo pregunten, y solo entonces, responda:

> Un monto que cae exactamente en el límite pertenece al tramo inferior. El límite superior
> de cada tramo es inclusivo. 500 está en el primer tramo, 2000 en el segundo y 10000 en
> el tercero.

No la escriba en ningún archivo que vean los participantes.

**Si alguien encuentra solo la causa grande.** Corrige el borde, la diferencia baja de 22,03
a 0,03 y el pipeline sigue en rojo. Pregunte cuánto suma lo que encontró contra la
diferencia que tenía. No diga dónde están los tres centavos. Sugiera recalcular a mano, con
decimal exacto, el total de comisiones de los comercios que todavía difieren. Si se acaba el
tiempo, entréguele la tabla de arriba.

**El hash esperado.** La corrección cambia la liquidación de junio a propósito. El
participante actualiza solo ese hash y lo justifica en la descripción del pull request.
Cambiar un hash sin causa explicada sería hacer trampa; con la causa y la decisión, es lo
correcto. El hash nuevo es `cd1466305e636d89e4f5af11421a98f97fc75f9dc677083caee8aed83a8c498a`.

**Paso 4.** La revisión de Copilot sobre los cambios sin confirmar la pide el participante
con un botón. La lista de comprobación cubre que no entren secretos ni datos reales y que el
hash que cambió esté justificado.

**Puesta en común.** Proyecte el caso de clase 03,
`docs/relator/casos-de-clase/caso-03-verificacion-obsoleta.md`: a veces lo que quedó viejo es
la verificación, no el código. Un hash esperado es una verificación.

Proponga también la pregunta del paso 2 a toda la sala: qué detectó la conciliación y qué
detectaron las pruebas, en qué periodos y por qué. En el camino A, la conciliación encontró
los 22,03 de junio. En el camino B no encontró nada, porque el reporte y la liquidación usan
el mismo cálculo: conciliar dos cosas que comparten un cálculo no detecta los errores de ese
cálculo. Las pruebas con valores calculados aparte, en cambio, sí. No es un defecto del
camino B, es la enseñanza.

**Monto negativo.** Si alguien encuentra que un monto negativo recibe el último tramo, es un
comportamiento real que nadie plantó. Está en `docs/relator/04-defectos-plantados.md`,
sección «Comportamientos no planificados». No se corrige.

**Mes 2026-13.** Si alguien ejecuta la liquidación con el periodo `2026-13`, el programa
termina sin error y liquida enero de 2027: no valida el mes. Es un hallazgo libre, no está en
el catálogo de defectos. Está bien visto, no es parte del ejercicio y no se corrige en el
taller. Ver HALLAZGO-12 en `03-hallazgos.md`.

**Para la puesta en común: una afirmación falsa del agente.** En la prueba con Copilot real,
en el paso 1, Copilot dijo que la especificación técnica del 5.2 «aún no existe en este
repositorio». Existe: `docs/proyecto/backlog/formato-del-reporte.md`, que el propio 5.2
entregó. Junto con la del 1.4, sirve para mostrar por qué se verifica lo que dice el agente.

## La demostración del 5.3

[`../demos/demo-5-3-pipeline-en-github.md`](../demos/demo-5-3-pipeline-en-github.md) muestra en
GitHub lo que la sala hizo en local. Se presenta desde el respaldo grabado.

**El redondeo en .NET.** `dotnet.instructions.md` pide que todo `Math.Round` indique
`MidpointRounding.AwayFromZero` y que los montos `double` de la liquidación pasen por
`CompatibilidadJava`. La corrección en `decimal` redondea con `Math.Round` y ese argumento, y
cumple la instrucción. Hasta SPEC-016-B la regla prohibía `Math.Round` sin más, y los agentes
de verificación chocaban con ella.

**Un solo stack.** Quien corrige solo su stack deja al otro distinto: `comparar-escenarios.sh`
falla en junio y es lo esperado. El pipeline con un solo stack declarado no compara los dos.

## Errores típicos

- Cambiar la prueba que falla en lugar de entender por qué falla.
- Actualizar los tres hashes esperados en lugar de solo el de junio.
- Corregir también el otro stack. Cada participante trabaja en uno.
- Hacer commit antes de pedir la revisión de Copilot, que solo revisa cambios sin confirmar.

## Tiempos

| Paso | Estimado | Observado en la verificación |
|---|---|---|
| 1 | 8 min | 41 a 80 s de agente y 2 a 3 comandos, en 4 corridas |
| 2 | 8 min | 38 a 58 s de agente y 2 a 3 comandos, en 4 corridas |
| 3 | 15 min | 125 a 311 s de agente y 9 a 17 comandos, en 4 corridas |
| 4 | 8 min | 47 a 73 s de agente y 4 a 5 comandos, en 4 corridas |

Suma 39. Quedan 6 para la puesta en común.

## Si alguien se atrasa

Diga la clave de la hoja de respuestas y que ejecute, con su stack:

```bash
bash scripts/proyecto/ponerse-al-dia.sh lab-5-3 java <clave>
```

Deja el repositorio en el inicio del 5.3 con el trabajo de referencia de los laboratorios anteriores.
Descarta lo que tenía del capítulo y pide escribir `descartar`. No hay que llevarle ningún
archivo.


## Depende del 5.1 y del 5.2

Los criterios del 5.1 son los que prueba el paso 1. A quien llegue sin ellos, entréguele
`../soluciones/lab-5-1/historia-de-referencia.md`. A quien llegue sin el reporte del 5.2,
aplíquele el de referencia.
