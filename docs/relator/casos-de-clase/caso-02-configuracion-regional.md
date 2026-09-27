# Caso 2. Verificar que el programa funciona en cualquier idioma

> Capítulo 1, qué contexto necesita el agente. Capítulo 5, estrategia de pruebas.
> Material para proyectar. La resolución está al final, en las notas del relator.

---

## El encargo

Dos implementaciones del mismo sistema, una en Java y otra en .NET, tienen que producir
exactamente la misma salida sobre los mismos datos.

Alguien nota que la salida podría depender del idioma de la máquina y pide verificarlo.

---

## Nivel 1

Se ejecuta el escenario Java con la máquina en español:

```
$ java -Duser.language=es -Duser.country=ES -jar liquidacion-comercios.jar

Comercio CM0001 - Consorcio Barranco S.A.C.
  Transacciones liquidadas : 23
  Total transado           : S/ 26074,08
  Total comisiones         : S/ 727,34
  Contracargos             : S/ 0,00
```

El otro escenario, sobre los mismos datos, imprime `S/ 26074.08`.

**Se corrige el separador decimal.**

---

## Nivel 2

Se ejecuta con la máquina en árabe:

```
$ java -Duser.language=ar -Duser.country=SA -jar liquidacion-comercios.jar

Comercio CM0001 - Consorcio Barranco S.A.C.
  Transacciones liquidadas : 23
  Total transado           : S/ ٢٦٠٧٤٫٠٨
  Total comisiones         : S/ ٧٢٧٫٣٤
  Contracargos             : S/ ٠٫٠٠
```

Y la tabla de detalle:

```
  TRANSACCION         MONTO   COMISION    RECARGO   CUOTAS
  TX000208          ٤٣٧٣٫٤٥     ١٠٩٫٦٤       ٠٫٠٠        ١
  TX000265           ١١٤٫١٥       ٤٫٣٠       ٠٫٠٠        ١
  TX000287           ٩١٣٫١٧      ٢٦٫٧٨       ٠٫٠٠        ١
```

---

## Nivel 3

Con el formateo ya corregido, se ejecuta con la máquina en tailandés:

```
$ java -Duser.language=th -Duser.country=TH -jar liquidacion-comercios.jar

==========================================================
  PASARELA ANDINA - LIQUIDACION DE COMERCIOS
  Periodo: 2026-06
  Desde: 01/06/1483 00:00
  Hasta: 30/06/1483 23:59
==========================================================
```

El diagnóstico:

```
Locale por defecto : th_TH
Clase de Calendar  : sun.util.BuddhistCalendar
getTime()          : Sun Jun 01 00:00:00 CLT 1483
```

---

## Nivel 4

Con el calendario ya corregido, la misma ejecución en tailandés, redirigida a un archivo:

```
$ java -Duser.language=th -Duser.country=TH -jar liquidacion-comercios.jar > salida.txt

Comercio CM0010 - Representaciones Bre?a S.R.L.
  Transacciones liquidadas : 10
  Total transado           : S/ 53632.74
```

La razón social es `Representaciones Breña S.R.L.`

---

## Las preguntas

**¿Cuántas de estas cuatro cosas habrías encontrado probando en español?**

**¿En cuál de los cuatro niveles habrías dejado de buscar?**

**¿Qué le tendrías que haber dicho al agente para que encontrara el cuarto?**

---
---

# Notas del relator

> **No proyectar.** Desde aquí en adelante es la conducción del caso.

## Cómo se conduce

Se proyecta un nivel a la vez y se detiene en cada uno. Después del nivel 1 conviene
preguntar a la sala si darían la verificación por terminada. Casi siempre alguien dice que
falta probar más idiomas, y ahí se pasa al nivel 2.

El punto de quiebre es el nivel 3. Hasta ahí el problema parece de impresión. En el nivel 3
queda claro que el idioma de la máquina **cambió el resultado del cálculo**: la liquidación
de junio de 2026 se hizo sobre junio de 1483.

No conviene adelantar que hay cuatro niveles. Que la sala crea que terminó en el 2 es parte
del ejercicio.

## Las preguntas para la sala

1. **¿Cuántas de estas cuatro cosas habrías encontrado probando en español?**
   Una. La respuesta honesta casi siempre es una.
2. **¿En cuál de los cuatro niveles habrías dejado de buscar?**
   La mayoría responde que en el 1 o en el 2.
3. **¿Qué le tendrías que haber dicho al agente para que encontrara el cuarto?**
   Es la pregunta del caso. Se trabaja abajo.

## De dónde salió cada nivel

Los cuatro son reales y ocurrieron durante la construcción de este repositorio, en ese
orden. El registro completo está en [`../03-hallazgos.md`](../03-hallazgos.md), HALLAZGO-04.

| Nivel | Qué cambia | Se descubre probando |
|---|---|---|
| 1 | Separador decimal | Español, alemán, francés |
| 2 | Los dígitos | Árabe |
| 3 | **El calendario, y con él el cálculo** | Tailandés |
| 4 | Juego de caracteres de la salida | Cualquier idioma, pero **redirigiendo a archivo** |

Las cuatro son la misma causa —el entorno de ejecución— con cuatro manifestaciones que no
se parecen entre sí.

## La respuesta a la tercera pregunta

Un agente al que se le pide *"verifica que funcione con distintas configuraciones
regionales"* prueba español, francés y alemán, y reporta que todo está bien. Tiene razón:
probó distintas configuraciones regionales.

Un agente al que se le pide *"prueba configuraciones que cambien el separador decimal, los
dígitos, el calendario y el juego de caracteres, y compara la salida redirigida a archivo"*
encuentra las cuatro.

**La diferencia no está en el agente. Está en lo que se le pidió.**

Ese es el capítulo 1 completo en un solo ejemplo: el resultado no dependió de la capacidad
del modelo sino de si quien pidió sabía qué dimensiones tenía el problema.

Vale hacer notar que la persona que escribió el primer prompt tampoco sabía que existía el
calendario budista. Lo aprendió al encontrarlo. Un prompt mejor no siempre se puede escribir
de entrada, y por eso la verificación es iterativa.

## La conclusión que cierra el caso

**El entorno de ejecución es una entrada del programa aunque no aparezca en su firma.** El
idioma de la máquina no se pasa por parámetro, no está en ninguna interfaz y no aparece en
ninguna prueba, pero cambia el resultado.

**La profundidad de una verificación depende de la variedad de los casos, no de su
cantidad.** Diez idiomas europeos prueban una sola cosa. Cuatro idiomas bien elegidos
prueban cuatro. Para el capítulo 5 esto se traduce directo: al pedir pruebas, la pregunta
útil no es cuántas sino qué dimensiones distintas cubren.

## Cierre para el capítulo 5

Si la sesión va con tiempo, conviene cerrar preguntando cómo se evita que esto vuelva a
pasar. La respuesta no es probar más idiomas: es que exista un gate que compare las dos
salidas de forma automática. En este repositorio es `scripts/comparar-escenarios.sh`, y se
probó rompiéndolo a propósito antes de confiar en él.

## Advertencia

Los cuatro niveles son ejecuciones reales, no ejemplos construidos. Vale decirlo, porque
cambia cómo se recibe el caso.
