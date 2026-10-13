> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes, escenario .NET. Se grabó en la CLI, no en Visual Studio Code: el modo Ask se
> reprodujo con una sesión sin permiso de edición. Los comandos que pidió el agente se
> aprobaron según la guía de prueba humana. La ruta del repositorio en la máquina se abrevia
> `<repo>`. Los segundos son de trabajo del agente, sin la lectura del participante.

# Lab 4.4 salida grabada de respaldo (escenario .NET)

Una sola conversación, en modo Agent. Antes del laboratorio:
`bash scripts/reiniciar-lab.sh lab-4-4 --confirmar`, que respondió «Ya esta en el punto de
partida. No hay nada que descartar.» Sin llamadas MCP.

## Paso 1: `/lab-4-4-paso-1-documentar-reglas dotnet`

Escrito: `/lab-4-4-paso-1-documentar-reglas dotnet`

Modo: Agent. Segundos de trabajo del agente: 80.

Archivos leídos: `escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraComision.cs`, `escenario/dotnet/LiquidacionComercios/Modelo/PlanComisiones.cs`, `escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs`, `escenario/README.md`.
Búsquedas: 1.
Archivos escritos: `labs/cap4/lab-4-4-documentacion/entregables/calculo-de-comisiones.md`.
Comandos, todos con aprobación: `cd <repo>\escenario\dotnet\LiquidacionComercios; $i=0; Get-Content Calculo\CalculadoraLiquidacio`; `cd <repo>\escenario\dotnet\LiquidacionComercios; $i=0; Get-Content Calculo\CalculadoraLiquidacio`; `New-Item -ItemType Directory -Force <repo>\labs\cap4\lab-4-4-documentacion\entregables | Out-Nul`.

Mensaje durante el trabajo: «Lines verified. Creating the file now.»

Respuesta del chat:

Creé `labs\cap4\lab-4-4-documentacion\entregables\calculo-de-comisiones.md`. El documento supera las 150 líneas, así que aquí van completas las dos secciones pedidas. El resto está en ese archivo: transacciones que entran al cálculo, porcentaje y monto fijo, recargo por cuotas, redondeo y totales del comercio.

Abreviaturas: CL = `CalculadoraLiquidacion.cs`, CC = `CalculadoraComision.cs`, PC = `PlanComisiones.cs`, UF = `UtilidadesFecha.cs`, CJ = `CompatibilidadJava.cs`.

#### Selección del tramo

Los tramos son **no acumulativos**: se elige un solo tramo y su porcentaje se aplica al monto completo (CL:161).

**Liquidación (CL:140-151):**
- Se recorren los tramos en el orden del plan y se toma el primero con `monto >= MontoDesde && monto < MontoHasta` (CL:144-145). El límite superior es **exclusivo**.
- Si ningún tramo calza, se usa el porcentaje del **último** tramo (CL:153-158).

**CC (`DeterminarTramo`, CC:19-31), no usado por la liquidación:**
- Primer tramo con `monto >= MontoDesde && monto <= MontoHasta` (CC:25). El límite superior es **inclusivo**.
- Si ninguno calza, devuelve el último tramo (CC:30). Si el plan es nulo o no tiene tramos, devuelve `null` (CC:21-24) y la comisión base es 0 (CC:39-42).

Un monto exactamente igual al límite entre dos tramos, por ejemplo 500.00 en PL01 (`0:500:3.5|500:2000:2.9`, `escenario\datos\planes.txt`), cae en el tramo siguiente en CL y en el anterior en CC.

El comentario de PC (PC:7-8) dice que los tramos son acumulativos. El código no lo hace en ninguna de las dos rutas.

#### Contraste con las reglas declaradas

| # | Regla declarada | Qué hace el código | ¿Coincide? |
|---|---|---|---|
| 1 | Comisión = porcentaje del tramo + monto fijo | `monto * % / 100 + fijo` (CL:161-162; CC:44-45) | Sí |
| 2 | Tramos no acumulativos | Un solo tramo, porcentaje sobre el monto completo (CL:140-161). El comentario de PC:7-8 dice lo contrario, pero el código no lo implementa | Sí (el comentario de PC contradice la regla) |
| 3 | Recargo 0,5 % por cuota sobre la primera, máximo 3 % | CL tiene tope 3.0 (CL:170-172) y coincide. CC tiene tope 3.5 (CC:60-62) y no coincide, pero CC no se usa en el cierre | No (coincide en CL, no en CC) |
| 4 | Las anuladas no generan comisión | Solo `APROBADA` genera comisión (CL:134) | Sí |
| 5 | Contracargos aprobados se descuentan en el periodo de aprobación | Estado `APROBADO` y fecha del contracargo dentro del periodo (CL:212-221) | Sí |
| 6 | Si las comisiones superan el tope, se cobra el tope | CL:200-204 | Sí |
| 7 | Menos de 6 meses de afiliación: retención de 5 % sobre el neto | `meses < 6`; 5 % de transado − comisiones − contracargos (CL:235-241) | Sí |
| 8 | Periodo del día 1 a las 00:00:00 al último día a las 23:59:59, hora de Lima | UF:65 y UF:77 usan esos límites. No hay conversión de huso horario | Sí (huso no modelado) |
| 9 | Todo monto en soles se redondea a 2 decimales, medio hacia arriba | Medio hacia arriba (CJ:59), pero solo en los totales y el neto (CL:246-258). Comisión y recargo por transacción no se redondean | No (parcial) |

**Resultado: 7 reglas coinciden (1, 2, 4, 5, 6, 7, 8) y 2 no (3 en `CalculadoraComision` y 9).**

#### Problemas que vi y no toqué

- El cierre mensual no usa `CalculadoraComision`: `CalculadoraLiquidacion` duplica la lógica, y las dos copias difieren en el tope del recargo y en el límite del tramo.
- El comentario de CC:7-9 dice que la comisión se aplica sobre el valor de venta neto, sin IGV. El código no descuenta el IGV.

No modifiqué código ni ejecuté `comparar-escenarios.sh`. No hice commit. Creé la carpeta `entregables`, que no existía.

## Paso 2: `/lab-4-4-paso-2-documentar-decisiones`

Escrito: `/lab-4-4-paso-2-documentar-decisiones`

Modo: Agent. Segundos de trabajo del agente: 35.

Búsquedas: 2.
Archivos escritos: `labs/cap4/lab-4-4-documentacion/entregables/decisiones.md`.
Comandos, todos con aprobación: `cd <repo>; foreach($f in 'docs\arquitectura\decisiones\README.md','docs\arquitectura\decisiones\`.

Respuesta del chat:

Revisé el índice de `docs\arquitectura\decisiones\`. Las decisiones 0001, 0002 y 0003 tratan de las dos implementaciones, el servidor MCP y el hook. Ninguna cubre esta, así que registré una nueva como 0004.

Creé `labs\cap4\lab-4-4-documentacion\entregables\decisiones.md`. Esto es el documento completo:

````markdown
# 0004. Escenario sin frameworks ni dependencias de ejecución

| Campo | Valor |
|---|---|
| Estado | Propuesta |
| Fecha | 2026-10-12 |
| Responsable | Pendiente de confirmar con el equipo |

## Contexto

Hechos respaldados por el código:

- El proyecto Java declara una única dependencia, `junit-jupiter` 5.12.2, con `scope` `test`
  (`escenario/java/pom.xml:23`, `:26-33`). Los plugins de `build` son de Maven (compilador,
  surefire y jar, `pom.xml:38-59`), no dependencias del programa.
- El JAR se arma con el plugin jar y solo declara la clase principal (`pom.xml:48-58`). No hay
  plugin que empaquete dependencias dentro del JAR.
- El proyecto .NET de producción no tiene ningún `PackageReference` ni `ProjectReference`
  (`escenario/dotnet/LiquidacionComercios/LiquidacionComercios.csproj:1-20`).
- El proyecto .NET de pruebas es el único con paquetes: `Microsoft.NET.Test.Sdk` 17.11.1,
  `xunit` 2.9.2 y `xunit.runner.visualstudio` 2.8.2
  (`LiquidacionComercios.Pruebas.csproj:13-17`), más una referencia al proyecto de producción
  (`:20`).
- No hay base de datos: los datos se leen de archivos de texto y se cargan en memoria
  (`escenario/README.md:119`).
- Ambos proyectos fijan la versión de la plataforma: Java 21 (`pom.xml:20-21`) y `net10.0`
  (`LiquidacionComercios.csproj:5`).

Suposiciones sobre el porqué, **pendiente de confirmar con el equipo**:

- Que la ausencia de frameworks busca mantener las dos implementaciones comparables salida
  por salida.
- Que busca que el taller corra en máquinas sin descargas durante la clase.
- Que busca que el código del laboratorio sea corto y legible.

## Alternativas consideradas

- **Solo biblioteca estándar en ejecución y dependencias solo de prueba (la elegida).**
  Ventaja: no hay nada que resolver ni actualizar para ejecutar. Costo: lo que daría un
  framework (inyección de dependencias, lectura de configuración, registro) hay que escribirlo
  a mano.
- **Un framework de aplicación por escenario (por ejemplo Spring en Java y el host genérico
  en .NET).** Ventaja: estructura estándar. Costo: dos ecosistemas distintos que habría que
  mantener equivalentes. Pendiente de confirmar con el equipo si se evaluó.
- **Bibliotecas puntuales de ejecución (lectura de archivos, formato de números).** Ventaja:
  menos código propio. Costo: dependencias a versionar y a precargar. Pendiente de confirmar
  con el equipo si se evaluó.

## Decisión

El escenario Java y el escenario .NET no usan frameworks ni bibliotecas de terceros en
ejecución. Las únicas dependencias externas son las de prueba: JUnit en Java y xUnit en .NET.
Toda dependencia nueva de ejecución se propone como una decisión nueva.

## Consecuencias

Respaldadas por el código:

- Para ejecutar basta la plataforma: el JAR no incluye dependencias (`pom.xml:48-58`) y el
  proyecto .NET no restaura paquetes (`LiquidacionComercios.csproj:1-20`).
- Las diferencias entre lenguajes, como el redondeo y el formato de números, se resuelven con
  código propio, por ejemplo `Util/CompatibilidadJava.cs`, y no con una biblioteca.
- Las pruebas son la única parte que necesita paquetes externos
  (`LiquidacionComercios.Pruebas.csproj:13-17`; `pom.xml:26-33`).

Pendiente de confirmar con el equipo:

- Que el equipo asume el costo de escribir y mantener a mano lo que un framework resolvería.
- Que se vigila la actualización de las versiones de prueba fijadas.

## Verificación

- Java: `mvn dependency:tree` en `escenario/java` no debe mostrar dependencias con alcance
  distinto de `test` (requiere el plugin de dependencias en la máquina; pendiente de confirmar
  con el equipo).
- .NET: `dotnet list LiquidacionComercios package` en `escenario/dotnet` no debe listar
  paquetes.
- Revisión: cualquier cambio en `pom.xml` o en los `.csproj` que agregue una dependencia sin
  `scope` `test` o un `PackageReference` en el proyecto de producción requiere una decisión
  nueva.
- `bash scripts/comparar-escenarios.sh` comprueba que ambas implementaciones siguen dando la
  misma salida.
````

**Quedaron pendientes de confirmar con el equipo:**
- El responsable de la decisión.
- Los tres motivos del contexto: comparabilidad de la salida, clase sin descargas y código corto.
- Que se evaluaron un framework de aplicación y bibliotecas puntuales.
- Que el equipo asume el costo de escribir a mano lo que un framework resolvería.
- Que se vigilan las versiones de prueba.
- Que el plugin de dependencias está disponible para `mvn dependency:tree`.

Los comandos de verificación no los ejecuté.

**Observación sin tocar:** el índice `README.md` de decisiones no lista la 0004, porque este paso no permitía modificar esa carpeta.

## Paso 3: `/lab-4-4-paso-3-preparar-para-confluence`

Escrito: `/lab-4-4-paso-3-preparar-para-confluence`

Modo: Agent. Segundos de trabajo del agente: 29.

Archivos escritos: `labs/cap4/lab-4-4-documentacion/entregables/calculo-de-comisiones-confluence.md`.

Respuesta del chat:

Creé `calculo-de-comisiones-confluence.md` en `labs\cap4\lab-4-4-documentacion\entregables\`, a partir de `calculo-de-comisiones.md`. El original no lo toqué.

Revisé el documento buscando lo que Confluence no conserva al importar Markdown y no encontré nada que reemplazar:

| Elemento | Resultado |
|---|---|
| Enlaces relativos a archivos | No hay; las rutas están como código en línea. |
| Tablas con celdas de varias líneas | La única tabla tiene todas las celdas en una línea. |
| Bloques de código sin lenguaje | No hay bloques, solo código en línea. |
| HTML incrustado | No hay. |

La copia es idéntica al original, salvo por una sección nueva al final. Esto es esa sección, «Qué se perdió en el traslado»:

```markdown
## Qué se perdió en el traslado

Se revisó el original buscando los cuatro elementos que Confluence no conserva al importar
Markdown. No hubo nada que reemplazar:

| Elemento | Resultado de la revisión |
|---|---|
| Enlaces relativos a archivos del repositorio | No hay enlaces; las rutas están como texto en código en línea, que se conserva |
| Tablas con celdas de varias líneas | La única tabla tiene todas sus celdas en una línea |
| Bloques de código sin lenguaje | No hay bloques de código, solo código en línea |
| HTML incrustado | No hay |

Cambios hechos respecto del original: ninguno en el contenido; solo se agregó esta sección.
Al pegar, conviene comprobar a mano que la tabla conserve sus cuatro columnas y que las
referencias `ARCHIVO:línea` se vean como texto.
```

El resto del documento es el mismo que te mostré en el paso 1 (sección «Selección del tramo» y tabla de contraste incluidas). Ábrelo en el archivo indicado.

No vi nada en este paso que mereciera mencionarse como problema.

## Paso 4: `/lab-4-4-paso-4-generar-runbook dotnet`

Escrito: `/lab-4-4-paso-4-generar-runbook dotnet`

Modo: Agent. Segundos de trabajo del agente: 89.

Archivos escritos: `labs/cap4/lab-4-4-documentacion/entregables/runbook-calculo-de-comisiones.md`.
Comandos, todos con aprobación: `cd <repo>; Get-Content docs\operacion\runbook-plantilla.md; "=== script"; Get-Content scripts\co`; `cd <repo>\escenario\dotnet; dotnet build LiquidacionComercios -c Release 2>&1 | select -Last 6; `; `cd <repo>\escenario\dotnet; $o = dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionCome`.

Respuesta del chat:

Creé `labs\cap4\lab-4-4-documentacion\entregables\runbook-calculo-de-comisiones.md`. Tiene menos de 150 líneas, así que va completo:

````markdown
# Runbook: Cálculo de comisiones y liquidación de comercios (escenario .NET)

| Campo | Valor |
|---|---|
| Servicio | Cálculo de comisiones y liquidación mensual, escenario .NET (`escenario/dotnet`) |
| Responsable | Pendiente de confirmar con el equipo |
| Última verificación | 2026-10-12, Copilot con el participante, en Windows con Git Bash |
| Documentos relacionados | `labs/cap4/lab-4-4-documentacion/entregables/calculo-de-comisiones.md`, `labs/cap4/lab-4-4-documentacion/entregables/decisiones.md`, `escenario/README.md` |

## Cómo usar este runbook

Se busca el síntoma, no la causa. Cada síntoma tiene su diagnóstico, sus acciones y cuándo
escalar. Una acción que no se verificó contra una ejecución real se marca como «no
verificada», con la razón. Todos los comandos .NET se ejecutan desde `escenario/dotnet`,
como indica `escenario/README.md`; el script de comparación, desde la raíz del repositorio.

## Síntoma 1: el programa no compila, las pruebas fallan o termina con error al arrancar

**Cómo se ve.** `dotnet build` termina con errores, `dotnet test` informa pruebas con error,
o el programa imprime «No se pudo leer el archivo de ...» o una excepción con pila de
llamadas al arrancar.

### Diagnóstico

1. Compilar el proyecto.

   ```bash
   dotnet build LiquidacionComercios -c Release
   ```

   **Resultado esperado.** «Compilación correcta», 0 advertencias y 0 errores.
   **Si muestra otra cosa.** El mensaje indica el archivo y la línea con el error de
   compilación.

   **Verificado.** 2026-10-12: compilación correcta, 0 advertencias, 0 errores.

2. Correr las pruebas.

   ```bash
   dotnet test LiquidacionComercios.Pruebas
   ```

   **Resultado esperado.** «Correctas!», con 0 con error.
   **Si muestra otra cosa.** El nombre de la prueba que falla señala la regla afectada.

   **Verificado.** 2026-10-12: «Correctas! - Con error: 0, Superado: 21, Omitido: 0, Total: 21».

### Acciones

1. Si aparece «No se pudo leer el archivo de planes: ...», el directorio de datos indicado no
   existe o es incorrecto. Ejecutar desde `escenario/dotnet` con la ruta relativa de datos.

   ```bash
   dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll 2026-06 ../datos
   ```

   **Verificado.** 2026-10-12: con `../datos` carga 40 comercios, 2037 transacciones y 30
   contracargos. Con `../noexiste` imprime cuatro mensajes «No se pudo leer el archivo de
   planes/comercios/transacciones/contracargos».

2. Si aparece una excepción en `UtilidadesFecha.InicioDePeriodo`, el periodo no tiene el
   formato `aaaa-mm` o el mes no existe. Repetir con un periodo válido, por ejemplo `2026-06`
   (los datos cubren 2026-04, 2026-05 y 2026-06).

   ```bash
   dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll 2026-06 ../datos
   ```

   **Verificado.** 2026-10-12: con `2026-13` la ejecución termina con una excepción en
   `UtilidadesFecha.cs:62`; con `2026-06` termina bien y liquida 39 comercios.

### Escalamiento

Escalar al equipo responsable si el error persiste con el periodo y la ruta correctos. Enviar
el comando ejecutado, la salida completa y el directorio desde el que se ejecutó.

## Síntoma 2: las salidas de Java y .NET no coinciden

**Cómo se ve.** `bash scripts/comparar-escenarios.sh` termina con código 1 y muestra en qué
línea difieren las salidas, o con código 2 si no puede ejecutar la comparación.

### Diagnóstico

1. Ejecutar la comparación sobre el periodo por omisión.

   ```bash
   bash scripts/comparar-escenarios.sh
   ```

   **Resultado esperado.** Código de salida 0 y «Las salidas son identicas».
   **Si muestra otra cosa.** Código 1: hay diferencia, y el script indica la línea. Código 2:
   algo impide ejecutar (compilación o ambiente).

   **Verificado.** 2026-10-12: ambos escenarios ejecutados, 554 líneas cada uno, salidas
   idénticas (20457 bytes), código de salida 0.

### Acciones

1. Si hay diferencia, abrir la línea que indica el script y comparar el monto: una diferencia
   de un centavo suele venir del redondeo (`Util/CompatibilidadJava.cs`).

   **No verificada.** Solo se observó el caso idéntico; provocar una diferencia exigiría
   modificar código del escenario.

2. Descartar un problema del lado Java con las pruebas de ese escenario, desde
   `escenario/java`.

   ```bash
   mvn test
   ```

   **No verificada.** No se ejecutó en esta sesión.

### Escalamiento

Escalar con la salida del script, el periodo y la línea que difiere. No corregir un
escenario para igualar al otro sin aprobación.

## Síntoma 3: la liquidación de un comercio no se explica con las reglas de negocio

**Cómo se ve.** Un comercio reclama que su total de comisiones, su retención o su neto no
coincide con lo que calcula a mano con `escenario/README.md`.

### Diagnóstico

1. Obtener la liquidación del comercio y su periodo.

   ```bash
   dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll 2026-06 ../datos
   ```

   Buscar el bloque «Comercio IDCOMERCIO» y revisar total transado, comisiones (y si dice
   «tope aplicado»), contracargos, retenciones y neto.

   **Resultado esperado.** Un bloque con esos seis valores; el neto es transado − comisiones
   − contracargos − retenciones.
   **Si muestra otra cosa.** Si el comercio no aparece, no tuvo transacciones aprobadas en el
   periodo, está de baja o no tiene plan (el cierre no lo imprime).

   **Verificado.** 2026-10-12: la salida del periodo 2026-06 lista 39 comercios liquidados,
   0 transacciones descartadas, y al menos un comercio con «(tope aplicado)» y comisiones de
   S/ 5000.00.

### Acciones

1. Repetir con el periodo anterior para ver si la diferencia es solo de ese mes.

   ```bash
   dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll 2026-05 ../datos
   ```

   **Verificado.** 2026-10-12: el periodo 2026-05 se ejecuta y muestra el encabezado
   «Desde: 01/05/2026 00:00, Hasta: 31/05/2026 23:59».

2. Calcular a mano el caso con las reglas y compararlo con `calculo-de-comisiones.md`. Tener
   presentes las diferencias entre `CalculadoraComision` y `CalculadoraLiquidacion` (límite
   de tramo y tope del recargo) que ese documento describe.

   **No verificada.** No es un comando; depende de las transacciones de cada comercio y no
   se ejecutó para un caso concreto.

### Escalamiento

Escalar con el identificador del comercio, el periodo, la salida del diagnóstico y el cálculo
a mano. Si la discrepancia es con una regla de `escenario/README.md`, indicar el número de
la regla.

## Lo que este runbook no cubre

- Cualquier cambio en `escenario/datos/`: los datos no se modifican; se escala.
- El escenario Java más allá de `mvn test`.
- Reclamos por el tratamiento del IGV: el código aplica el porcentaje sobre el monto tal cual.
- Fallos del ambiente de la máquina o de la instalación de .NET.
````

**Acciones: 3 verificadas y 3 no verificadas.**
- Verificadas: la ruta de datos del síntoma 1, el periodo inválido del síntoma 1 y la repetición con el periodo anterior del síntoma 3.
- No verificadas: la comparación por línea y `mvn test`, del síntoma 2, y el cálculo a mano, del síntoma 3.

Los cuatro diagnósticos (compilación, pruebas, comparación de escenarios y salida de la liquidación) sí se ejecutaron.

**Observaciones, sin tocar:**
- Con un periodo inválido como `2026-13` el programa termina con una excepción no controlada.
- Al compilar se generaron carpetas `bin` y `obj`. No aparecen como cambios en `git status`, solo la carpeta `entregables`, que está sin rastrear.

## Archivos creados

El documento de decisión del paso 2 y el runbook del paso 4 están completos en las respuestas.
La copia del paso 3 es este mismo documento más la sección final que muestra la respuesta.

### Archivo creado en el paso 1: `calculo-de-comisiones.md`

````markdown
# Cálculo de comisiones y liquidación (escenario .NET)

Documento derivado de lo que **hace el código**. Abreviaturas de archivo:

- **CL** = `escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs`
- **CC** = `escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraComision.cs`
- **PC** = `escenario/dotnet/LiquidacionComercios/Modelo/PlanComisiones.cs`
- **UF** = `escenario/dotnet/LiquidacionComercios/Calculo/UtilidadesFecha.cs`
- **LQ** = `escenario/dotnet/LiquidacionComercios/Modelo/Liquidacion.cs`
- **CJ** = `escenario/dotnet/LiquidacionComercios/Util/CompatibilidadJava.cs`

## 1. Dos implementaciones del cálculo

El cierre mensual **no usa** `CalculadoraComision`: `CL` repite la lógica en línea (CL:134-178)
y nunca instancia ni llama a `CC` (no hay referencia a `CalculadoraComision` en `CL`).
Por eso hay dos versiones de la regla, que no son idénticas. Este documento describe
primero la que se ejecuta en la liquidación (CL) y señala las diferencias con CC.

## 2. Transacciones que entran al cálculo

1. Se omiten los comercios de baja (CL:105) y los que no tienen plan (CL:110-112).
2. `ValidarTransaccion` descarta, y cuenta como descartada, la transacción nula, sin fecha,
   con moneda distinta de `"PEN"` (CL:61) o con monto ≤ 0 (CL:66). Solo las válidas suman
   al acumulado general (CL:49-72).
3. La fecha debe estar en el periodo, límites incluidos (CL:132).
4. El estado debe ser `APROBADA` (CL:134); cualquier otro no genera comisión.
5. Periodo: del día 1 a las 00:00:00 al último día a las 23:59:59 (UF:65, UF:77), sin
   conversión de huso horario.

## 3. Selección del tramo

Los tramos son **no acumulativos**: se elige un solo tramo y su porcentaje se aplica al
monto completo (CL:161).

**Liquidación (CL:140-151):**
- Se recorren los tramos en el orden del plan y se toma el primero con
  `monto >= MontoDesde && monto < MontoHasta` (CL:144-145). El límite superior es **exclusivo**.
- Si ningún tramo calza, se usa el porcentaje del **último** tramo (CL:153-158).

**CC (`DeterminarTramo`, CC:19-31), no usado por la liquidación:**
- Primer tramo con `monto >= MontoDesde && monto <= MontoHasta` (CC:25): límite superior
  **inclusivo**.
- Si ninguno calza, devuelve el último tramo (CC:30); si el plan es nulo o sin tramos,
  devuelve `null` (CC:21-24) y la comisión base es 0 (CC:39-42).

Diferencia: un monto exactamente igual al límite entre dos tramos (por ejemplo 500.00 en
PL01, `0:500:3.5|500:2000:2.9`, datos/planes.txt) cae en el tramo siguiente en CL y en el
anterior en CC.

El comentario de `PC` (PC:7-8) dice que los tramos son acumulativos y reparten el monto
entre los tramos que atraviesa. El código no lo hace en ninguna de las dos rutas.

## 4. Porcentaje y monto fijo

- Comisión base = `monto * porcentaje / 100` + `MontoFijoPorTransaccion` del plan
  (CL:161-162; CC:44-45).
- El monto fijo se suma una vez por transacción, sin importar el tramo.
- El comentario de CC:7-9 afirma que la comisión se aplica sobre el valor de venta neto
  (sin IGV); el código aplica el porcentaje sobre `Monto` tal cual (CC:44, CL:161).

## 5. Recargo por cuotas

- Solo si `Cuotas > 1` (CL:166; CC:55).
- Porcentaje de recargo = `(Cuotas - 1) * 0.5` (CL:168; CC:59).
- Tope del porcentaje: **3.0** en CL (CL:170-172) y **3.5** en CC (CC:60-62).
- Recargo = `comisionBase * porcentajeRecargo / 100` (CL:175; CC:64): se aplica sobre la
  comisión base (que ya incluye el monto fijo), no sobre el monto.
- Comisión total = base + recargo (CL:178; CC:70-74).

Con la rama de CL, el tope de 3.0 se alcanza desde 7 cuotas; con la de CC, desde 8.

## 6. Redondeo

- No se redondea por transacción: `ComisionBase`, `RecargoCuotas` y `ComisionTotal` del
  detalle quedan sin redondear (CL:161-186).
- Se redondea a 2 decimales, medio hacia arriba, `Math.Floor(x * 100 + 0.5) / 100` (CJ:57-59),
  solo sobre los totales: transado, comisiones, contracargos y retenciones (CL:246-249), y
  sobre el neto (CL:257-258).

## 7. Totales del comercio

1. `totalTransado` suma los montos de las transacciones aprobadas del periodo (CL:190);
   `totalComisiones` suma las comisiones totales (CL:191).
2. **Tope mensual**: si `totalComisiones > plan.TopeMensual`, el total pasa a ser el
   tope y se marca `TopeAplicado` (CL:200-204). El tope se aplica al total del mes, no por
   transacción, y el detalle por línea no se ajusta.
3. **Contracargos**: se suman los de estado `APROBADO` cuya `Fecha` (con valor) está en el
   periodo, límites incluidos (CL:210-224). El periodo es el de la fecha del contracargo, no
   el de la transacción original.
4. **Retención**: se calculan los meses completos entre `FechaAfiliacion` y el inicio del
   periodo (CL:233; UF:97-113). Si son menos de 6 (CL:235) y la base es positiva, la
   retención es `5 %` de `totalTransado - totalComisiones - totalContracargos` (CL:237-241),
   usando el total de comisiones ya topado. Si no hay fecha de afiliación, no hay retención
   (CL:231).
5. **Neto** = `TotalTransado - TotalComisiones - TotalContracargos - Retenciones` (LQ:34),
   redondeado (CL:257-258).
6. Solo se agrega a los resultados y se imprime el comercio con al menos una transacción
   liquidada (CL:329).

## Contraste con las reglas declaradas

Reglas de `escenario/README.md` (sección «Reglas de negocio»).

| # | Regla declarada | Qué hace el código | ¿Coincide? |
|---|---|---|---|
| 1 | Comisión = porcentaje del tramo + monto fijo | `monto * % / 100 + fijo` (CL:161-162; CC:44-45) | Sí |
| 2 | Tramos no acumulativos: monto completo por el % del tramo | Un solo tramo, porcentaje sobre el monto completo (CL:140-161). El comentario de PC:7-8 dice lo contrario, pero el código no lo implementa | Sí (el comentario de PC contradice la regla) |
| 3 | Recargo 0,5 % por cuota sobre la primera, máximo 3 % | CL: tope 3.0 (CL:170-172), coincide. CC: tope 3.5 (CC:60-62), no coincide, pero CC no se usa en el cierre | No (coincide en CL, no en CC) |
| 4 | Las anuladas no generan comisión | Solo `APROBADA` genera comisión (CL:134) | Sí |
| 5 | Contracargos aprobados se descuentan en el periodo de aprobación | Estado `APROBADO` y fecha del contracargo (de aprobación según datos) en el periodo (CL:212-221) | Sí |
| 6 | Si las comisiones superan el tope, se cobra el tope | CL:200-204 | Sí |
| 7 | Menos de 6 meses de afiliación: retención de 5 % sobre el monto neto | `meses < 6`; 5 % de transado − comisiones − contracargos (CL:235-241), es decir, el neto antes de retención | Sí |
| 8 | Periodo del día 1 a las 00:00:00 al último día a las 23:59:59, hora de Lima | UF:65 y UF:77 usan esos límites; no hay conversión explícita a hora de Lima, se toman las fechas tal cual vienen | Sí (huso no modelado) |
| 9 | Todo monto en soles se redondea a 2 decimales, medio hacia arriba | Medio hacia arriba (CJ:59), pero solo en los totales y el neto (CL:246-258); las comisiones y el recargo por transacción y por línea de detalle no se redondean | No (parcial) |

**Resultado: 7 reglas coinciden (1, 2, 4, 5, 6, 7, 8) y 2 no (3 en `CalculadoraComision` y 9).**
````

## Verificación

`git status --short -uall` al terminar:

```
?? labs/cap4/lab-4-4-documentacion/entregables/calculo-de-comisiones-confluence.md
?? labs/cap4/lab-4-4-documentacion/entregables/calculo-de-comisiones.md
?? labs/cap4/lab-4-4-documentacion/entregables/decisiones.md
?? labs/cap4/lab-4-4-documentacion/entregables/runbook-calculo-de-comisiones.md
```

Los cuatro nombres son exactos. Solo archivos nuevos en la carpeta de entregables.

## Esperado contra observado

- Paso 1: esperado que diga que los tramos **no** son acumulativos. Observado igual, y señala
  que el comentario de `PlanComisiones.cs` dice lo contrario. Siete reglas coinciden y dos
  no: la 3 en `CalculadoraComision` y la 9.
- Paso 2: esperado una sola decisión, sin dependencias de ejecución, con el porqué pendiente
  de confirmar. Observado igual, numerada 0004.
- Paso 3: esperado la copia `-confluence.md` y el original sin cambios. Observado igual. No
  encontró nada que Confluence pierda y lo dejó escrito en la sección final.
- Paso 4: esperado entre 15 y 18 comandos aprobados y ninguna acción verificada sin
  ejecución. Observado tres comandos, porque Copilot agrupó varias verificaciones en cada
  uno. Cuatro diagnósticos ejecutados, tres acciones verificadas y tres marcadas «No
  verificada» con su razón. Ninguna acción toca `escenario/datos/`.
- `git status`: solo los cuatro archivos nuevos.
