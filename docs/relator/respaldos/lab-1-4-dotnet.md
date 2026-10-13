> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes, escenario .NET. Se grabó en la CLI, no en Visual Studio Code: el modo Ask se
> reprodujo con una sesión sin permiso de edición. Los comandos que pidió el agente se
> aprobaron según la guía de prueba humana. La ruta del repositorio en la máquina se abrevia
> `<repo>`. Los segundos son de trabajo del agente, sin la lectura del participante.

# Lab 1.4 - Salida grabada de respaldo (modo Ask, escenario .NET)

Una sola conversación. Ningún paso modifica archivos.

## Paso 1 - `/lab-1-4-paso-1-prompt-vago`

Escrito: `/lab-1-4-paso-1-prompt-vago `

Modo: Ask. Segundos de trabajo del agente: 8.

Archivos leídos: `escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java`, `escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs`.

Respuesta del chat:

Sin modificar archivos. «Mejora este código» es demasiado vago; no sé qué mejorar (legibilidad, rendimiento, corrección, pruebas), así que no cambié nada. Lo que sigue son observaciones sobre ambas clases, Java y .NET, que son equivalentes.

**Posibles mejoras (sin aplicar)**
- `procesarLiquidacionCompleta` / `ProcesarLiquidacionCompleta` es un método de unas 300 líneas con anidamiento de 6 niveles. Mezcla cálculo, validación, contracargos, retenciones, desglose e impresión.
- Los literales (0.5, 3.0, 0.05, 6 meses, 100.0, los prefijos "10/20/15/17" y "PEN") están sueltos.
- Los `if` anidados se pueden aplanar con guardas y el `if` en cascada de medios de pago se puede reemplazar por un `switch`.
- El bucle de tramos sigue recorriendo la lista después de encontrar el tramo.
- Hay un `catch` vacío.
- Dinero con `double`.
- Hay estado mutable acumulado (`acumuladoGeneral*`, `transaccionesDescartadas`), que se arrastra entre llamadas.
- La impresión por consola está acoplada al cálculo.
- No hay pruebas sobre esta clase.

**Posibles desalineaciones a revisar con `escenario/README.md`** (no las verifiqué)
- El tope mensual se aplica antes de los contracargos.
- `ValidarTransaccion` suma al acumulado general incluso las transacciones que luego no se liquidan.
- Java valida la fecha con `null` y .NET con `DateTime.MinValue`.

Dime qué tipo de mejora quieres y sobre qué archivo. Antes de cambiar nada, `escenario/` exige que lo pidas explícitamente.

## Paso 2 - `/lab-1-4-paso-2-agregar-objetivo dotnet`

Escrito: `/lab-1-4-paso-2-agregar-objetivo dotnet`

Modo: Ask. Segundos de trabajo del agente: 7.

Respuesta del chat:

Escenario: .NET, método `ProcesarLiquidacionCompleta`. No modifiqué ningún archivo.

#### Las tres mejoras de mayor impacto en legibilidad

1. **Extraer el cálculo de comisión de una transacción** (método privado de comisión por transacción, con la selección de tramo y el recargo por cuotas).
   - Hoy ese cálculo queda a 8 niveles de anidación dentro de `foreach`, `if` de validación, `if` de periodo e `if` de estado.
   - Es el núcleo del dominio y lo más difícil de leer.
   - El bucle de tramos con la bandera `tramoEncontrado` se vuelve una búsqueda simple dentro del método extraído.

2. **Aplanar el anidamiento con guardas** (`continue` y condiciones combinadas) en los tres bucles: transacciones, contracargos y comercios.
   - `if (plan != null)`, `ValidarTransaccion`, el rango de fechas y el estado se combinan en una sola condición o en guardas tempranas.
   - Lo mismo aplica al desglose por medio de pago, que hoy es un `if/else` en cascada de 4 niveles. Un `switch` lo deja plano.

3. **Separar el cálculo de la impresión por consola.**
   - El método construye la `Liquidacion` y además hace unas 30 llamadas a `Console.WriteLine`, incluido el desglose por medio de pago.
   - Extraer un método de impresión de la liquidación (cabecera, comercio, desglose y pie) deja el método principal como orquestador.
   - Los totales y el desglose se calcularían en métodos separados: contracargos, retenciones y observación del registro.

#### Observaciones fuera de alcance (no las toqué)

- El `catch (Exception)` vacío en la observación del registro tributario.
- Hay literales sueltos (`0.5`, `3.0`, `0.05`, `6`, prefijos de registro, `"PEN"`).
- Se usa `double` para dinero.
- `ValidarTransaccion` suma al acumulado general transacciones que luego pueden quedar fuera del periodo o no estar aprobadas.
- El tope mensual se aplica antes de los contracargos.
- Estas dos últimas hay que contrastarlas con las reglas de `escenario/README.md`.
- No hay pruebas de esta clase.

## Paso 3 - `/lab-1-4-paso-3-agregar-restricciones dotnet`

Escrito: `/lab-1-4-paso-3-agregar-restricciones dotnet`

Modo: Ask. Segundos de trabajo del agente: 13.

Archivos leídos: `escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs`.
Búsquedas: 1.

Respuesta del chat:

| Mejora | Líneas | Por qué mejora la legibilidad | Riesgo de cambiar la salida |
|---|---|---|---|
| 1. Extraer el cálculo de comisión de una transacción (tramo, monto fijo y recargo por cuotas) a un método privado | 136-178 | Es la regla de negocio central y hoy está a 8 niveles de anidación. El bucle con la bandera `tramoEncontrado` pasa a ser una búsqueda corta con nombre propio. | Bajo. Es lógica pura con los mismos `double` y el mismo orden de operaciones. Hay que conservar el último tramo como valor por defecto y el tope de 3.0 del recargo. |
| 2. Aplanar el anidamiento de los tres `if` (validación, rango de fechas y estado aprobado) con una condición combinada o guardas con `continue` | 128-201 | Quita 3 niveles de sangría alrededor del cálculo y deja visible qué transacciones se liquidan. | Medio. `ValidarTransaccion` (línea 128) incrementa `transaccionesDescartadas` y acumula el total general como efecto lateral. Debe seguir ejecutándose primero y una sola vez por transacción. |
| 3. Extraer la impresión de cada comercio a un método privado, con el desglose por medio de pago | 329-373 | Separa el cálculo de la presentación y deja el método principal como orquestador. | Bajo. Se conservan los textos, los espacios y el orden de las líneas. Hay que seguir llamando a `FormatearMonto` y agregar a `resultado` antes de imprimir. |

Vistos y no tocados: el `catch (Exception)` vacío (línea 285), el tope mensual aplicado antes de los contracargos (líneas 203-206) y los literales sueltos.

## Paso 4 - acción 1: equivalente de `/explain` (método `ProcesarLiquidacionCompleta`, líneas 79-381)

Escrito: `Explica el código seleccionado: escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs, líneas 79 a 381, el método ProcesarLiquidacionCompleta.`

Modo: Ask. Segundos de trabajo del agente: 8.

La CLI no tiene `/explain`. Se escribió el pedido que el editor arma con la selección: explicar el código seleccionado, con el archivo y el rango de líneas.

Respuesta del chat:

`ProcesarLiquidacionCompleta(periodo, rutaDirectorioDatos)` hace el cierre mensual. Devuelve una `List<Liquidacion>` y también imprime el resultado por consola.

**1. Preparación (líneas 79-101)**
- Si no hay repositorio, carga los datos desde la ruta indicada.
- Calcula `inicioPeriodo` y `finPeriodo` a partir del periodo.
- Imprime la cabecera con las fechas en formato `dd/MM/yyyy HH:mm`.

**2. Bucle por comercio (103-112)**
- Recorre los comercios activos y salta los que están `DE_BAJA`.
- Busca el plan de comisiones del comercio y, si no existe, el comercio se omite sin avisar.
- Crea una `Liquidacion` con el id del comercio, la razón social, el periodo y la fecha de generación.

**3. Comisiones por transacción (126-201)**
- `ValidarTransaccion` descarta las transacciones nulas, sin fecha, en una moneda distinta de `PEN` o con monto menor o igual a 0. Cuenta las descartadas y suma el monto de las válidas al acumulado general.
- Solo se liquidan las válidas dentro del periodo y en estado `APROBADA`.
- El porcentaje sale del primer tramo donde `MontoDesde <= monto < MontoHasta`. Si ninguno calza, usa el último tramo.
- La comisión base es `monto × porcentaje / 100` más el monto fijo del plan.
- Si hay más de una cuota, el recargo es `(cuotas − 1) × 0,5 %`, con tope de 3 %, aplicado sobre la comisión base.
- Cada transacción agrega una línea de detalle y suma a los totales.

**4. Tope, contracargos y retenciones (203-259)**
- Si las comisiones superan `TopeMensual`, se fijan en el tope y se marca `TopeAplicado`.
- Los contracargos `APROBADO` con fecha dentro del periodo se suman.
- Si el comercio se afilió hace menos de 6 meses, la retención es el 5 % de `transado − comisiones − contracargos`, solo si esa base es positiva.

**5. Cierre del cálculo (261-287)**
- Redondea a 2 decimales los totales, las retenciones y el neto, y los guarda en la liquidación.
- Genera una observación sobre el registro tributario: si no mide 11 caracteres es «largo inválido»; si el prefijo no es 10, 20, 15 ni 17, es «prefijo no habitual». El `catch` vacío traga cualquier excepción.

**6. Desglose e impresión (289-373)**
- Acumula el monto por medio de pago y cuenta las transacciones en cuotas de tarjeta de crédito.
- Solo si el comercio tuvo transacciones liquidadas, agrega la liquidación a `resultado` e imprime los totales, el desglose y la observación.

**7. Pie (375-381)**
- Imprime el número de comercios liquidados y de transacciones descartadas, y devuelve el resultado.

**Observaciones sin tocar**
- Las transacciones fuera del periodo o no aprobadas suman igual al acumulado general de transado.
- El tope se aplica antes de restar los contracargos.
- Las dos últimas hay que compararlas con `escenario/README.md`.
- `transaccionesDescartadas` y los acumulados no se reinician entre llamadas.

## Paso 4 - acción 2: `/plan dividir este método en partes que se puedan probar por separado`

Escrito: `/plan dividir este método en partes que se puedan probar por separado`

Modo: Plan, solo propone, no toca código. Segundos de trabajo del agente: 28.

Archivos leídos: `.github/instructions/dotnet.instructions.md`, `escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraComision.cs`.
Búsquedas: 3.
Archivos escritos: `plan.md`, en la carpeta de la sesión, fuera del repositorio.

Respuesta del chat:

Plan guardado en la carpeta de sesión (`plan.md`) y las 9 tareas están registradas en SQL.

**Enfoque:** refactorización sin cambio de comportamiento, en .NET y dentro de la misma clase. Se extraen estas partes:
- comisión de una transacción,
- contracargos,
- retención,
- observación del registro,
- desglose por medio de pago,
- impresión.

`ProcesarLiquidacionCompleta` queda como orquestador. Antes de empezar se guarda la salida base en la carpeta temporal, y al final se corre `dotnet test` y `bash scripts/comparar-escenarios.sh`.

**Hallazgo clave:** `CalculadoraComision.cs` ya existe, pero no se puede reutilizar. Usa `<=` en el tramo y un tope de recargo de 3,5 en lugar de 3,0, así que cambiaría la salida.

**Preguntas para ti:**
1. ¿Solo .NET o también Java?
2. ¿Visibilidad de los métodos extraídos: `public` o `internal` con `InternalsVisibleTo`? Con `private` no se podrían probar directamente.
3. ¿Escribo también las pruebas unitarias, en archivos nuevos, o solo la refactorización?
4. ¿Hago todas las extracciones o solo las tres de mayor impacto?

Plan guardado:

````markdown
# Plan: dividir `ProcesarLiquidacionCompleta` en partes probables por separado

## Problema
`CalculadoraLiquidacion.ProcesarLiquidacionCompleta` (.NET, líneas 79-381) mezcla carga de
datos, cálculo de comisión, tope, contracargos, retenciones, observación de registro,
desglose por medio de pago e impresión. Solo se puede probar de punta a punta.

## Enfoque
Refactorización que no cambia el comportamiento: extraer métodos con nombre propio, en el
mismo archivo, con la misma lógica y el mismo orden de operaciones. La salida debe ser
idéntica (`bash scripts/comparar-escenarios.sh`).

## Hallazgos del análisis
- Ya existe `Calculo/CalculadoraComision.cs`, pero **NO se debe reutilizar**: difiere de la
  lógica inline (tramo con `<=` en vez de `<`, tope de recargo 3.5 en vez de 3.0, devuelve 0
  sin tramos). Reusarla cambiaría la salida. Se extrae lógica nueva idéntica a la inline.
- Efectos laterales de `ValidarTransaccion` (contador de descartadas y acumulado general):
  deben ejecutarse primero y una sola vez por transacción.
- Solo hay pruebas de `UtilidadesFecha`, `Transaccion`, `Comercio` y `ValidadorFormato`;
  ninguna de la calculadora.
- Las pruebas nuevas van en archivos nuevos, solo si el usuario las pide.

## Extracciones propuestas (en orden de ejecución)
1. Comisión de una transacción: tramo + monto fijo + recargo por cuotas (líneas 136-178).
2. Total de contracargos aprobados del periodo (206-225).
3. Retención de garantía (227-259).
4. Observación del registro tributario (261-287), conservando el `catch` vacío.
5. Desglose por medio de pago (289-327).
6. Impresión de cada liquidación y de cabecera/pie (92-101, 329-381).
7. Dejar `ProcesarLiquidacionCompleta` como orquestador: carga, bucle por comercio,
   llamadas a los métodos anteriores.

Visibilidad: los métodos deben ser alcanzables desde pruebas. `internal` exigiría
`InternalsVisibleTo` (cambio en el proyecto); `public` cambia la API. Pendiente de decisión.

## Todos
Ver tabla `todos` en SQL (`dividir-*`).

## Verificación
- Guardar la salida de antes en la carpeta temporal del sistema, antes de cambiar nada.
- `dotnet build LiquidacionComercios -c Release` y `dotnet test LiquidacionComercios.Pruebas`
  desde `escenario/dotnet/`.
- `bash scripts/comparar-escenarios.sh` debe terminar en cero.
- Sin commits ni push: se propone el commit al participante.

## Preguntas abiertas
1. ¿Solo .NET o también Java (para mantener equivalencia de estructura)?
2. ¿Visibilidad de los métodos extraídos: `public`, `internal` + `InternalsVisibleTo`, o
   `private` sin pruebas directas?
3. ¿Escribo pruebas unitarias de las partes extraídas (archivo nuevo) o solo la refactorización?
4. ¿Todas las extracciones o solo las tres de mayor impacto (1, 2/aplanar, 6)?
5. ¿Extraer a la misma clase o a clases nuevas? (Misma clase por defecto.)
6. Las divergencias con `CalculadoraComision` y con el README (tope antes de contracargos,
   acumulado general) no se tocan.
````

## Paso 4 - acción 3: `/lab-1-4-paso-4-comparar-resultados`

Escrito: `/lab-1-4-paso-4-comparar-resultados`

Modo: Ask, de vuelta desde Plan. Segundos de trabajo del agente: 6.

Las preguntas del plan no se respondieron: el laboratorio no implementa el plan.

Respuesta del chat:

| Criterio | Paso 3 | /explain | /plan |
|---|---|---|---|
| Qué tipo de resultado entrega | Un diagnóstico acotado: tres mejoras con líneas, motivo y riesgo. | Una descripción narrativa de lo que hace el método, por etapas. | Un plan de trabajo con extracciones, tareas, dependencias y preguntas abiertas. |
| Cuánto hubo que escribir para obtenerlo | Mucho: objetivo, alcance, restricciones y formato. | Casi nada: seleccionar el método y pedir la explicación. | Una frase corta, a la que el agente respondió con análisis propio. |
| Si se puede comparar con el de otro participante | Sí: tabla fija de tres filas con las mismas columnas. | No: la estructura y la profundidad dependen del modelo. | Parcialmente: el contenido varía, aunque el plan tiene secciones. |
| Si sirve tal cual para un pull request | No: no cambia código. Sirve como justificación del alcance. | No: es solo comprensión. | No: es un paso previo. Sus tareas y verificaciones sí se pueden trasladar a la descripción. |
| Qué no respondió y habría hecho falta | Orden de ejecución, pruebas y decisiones pendientes (visibilidad, Java). | Qué mejorar, el riesgo de cambiar la salida y por dónde empezar. | Cierra solo si se responden las preguntas abiertas. Faltan la estimación y los criterios de aceptación. |

Conviene el paso 3 para decidir por dónde empezar y comparar con otros, `/explain` para entender código desconocido antes de tocarlo y `/plan` para pasar de la decisión a un trabajo ordenado.

Fuera de alcance, sin tocar: las desalineaciones con `escenario/README.md` y con `CalculadoraComision.cs` ya mencionadas.

## Verificación

`git status --short` al terminar: vacío. Ningún archivo modificado.

## Esperado contra observado

- Paso 1: esperado una respuesta larga con muchos temas. Observado una lista de nueve
  mejoras y tres desalineaciones posibles, sobre las clases Java y .NET a la vez, con la
  advertencia de que el pedido es vago.
- Paso 2: esperado tres mejoras de legibilidad de `ProcesarLiquidacionCompleta`. Observado
  igual, más corto y enfocado que el paso 1.
- Paso 3: esperado una tabla de tres filas con rangos de líneas, sin texto antes. Observado
  igual: comisión por transacción, anidamiento e impresión.
- Paso 4: `/explain` no existe en la CLI y se usó el pedido equivalente. `/plan` propuso
  extraer seis partes y terminó con cuatro preguntas, que no se respondieron. La
  comparación entregó la tabla de tres columnas.
- `git status`: sin cambios.
