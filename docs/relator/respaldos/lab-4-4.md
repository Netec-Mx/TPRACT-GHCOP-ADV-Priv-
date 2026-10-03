> Los tiempos de este respaldo son aproximados. Miden los comandos de cada paso, no la
> generación del texto.

# Lab 4.4 salida grabada de respaldo

Nota sobre los segundos: son los medidos entre el inicio y el fin de los comandos de cada paso (lectura, escritura). No incluyen el tiempo de generación del texto. Sin llamadas MCP en este lab. Reinicio previo con `bash scripts/reiniciar-lab.sh lab-4-4 --si`: ya estaba en el punto de partida.

## Paso 1: `/lab-4-4-paso-1-documentar-reglas java`

Segundos: 45. Archivos leídos: `CalculadoraComision.java`, `PlanComisiones.java`, `CalculadoraLiquidacion.java`, `UtilidadesFecha.java`, `Liquidacion.java`, `EstadoTransaccion.java`, `escenario/README.md`. Se aplicó `.github/instructions/java.instructions.md` (solo lectura; no se editó código Java).

### Respuesta final del chat

He creado `labs/cap4/lab-4-4-documentacion/entregables/calculo-de-comisiones.md`, con cada afirmación citando archivo y línea, y la sección final «Contraste con las reglas declaradas».

Resultado del contraste con las 9 reglas de `escenario/README.md`:
- **Coinciden 7**: reglas 1, 2, 4, 5, 6, 7 y 9.
- **No coinciden, o coinciden solo en parte, 2**: la regla 3 (el tope del recargo por cuotas es 3.0 en `CalculadoraLiquidacion.java:173-175`, pero 3.5 en `CalculadoraComision.java:53-55`) y la regla 8 (el periodo usa la zona horaria del sistema, `UtilidadesFecha.java:35`, y no fija Lima).

Observaciones fuera del alcance del paso, que no toqué:
- El comentario de `PlanComisiones.java:9-10` dice que los tramos son acumulativos; el código aplica el porcentaje al monto completo y la regla 2 también. El código y el README mandan sobre el comentario.
- El cálculo real está en línea en `CalculadoraLiquidacion.java`; `CalculadoraComision` solo la usa `SimuladorComision`. Los límites de tramo difieren (`<` en `CalculadoraLiquidacion.java:149`, `<=` en `CalculadoraComision.java:23`).
- El bloque `catch` vacío en `CalculadoraLiquidacion.java:281-282` y el uso de `double` para montos.
- El acumulado general de comisiones se suma antes de aplicar el tope (`CalculadoraLiquidacion.java:196`).

Recomiendo abrir dos o tres de las líneas citadas (por ejemplo `CalculadoraLiquidacion.java:164`, `:173` y `:202`) y compararlas con lo que dice el documento.

Salida esperada (documento creado y número de reglas que coinciden y no coinciden): cumplida.

### Archivo creado: `calculo-de-comisiones.md`

# Cálculo de comisiones según el código (escenario Java)

Este documento describe lo que hace el código, no lo que dicen sus comentarios. Las rutas
son relativas a `escenario/java/src/main/java/pe/pasarelaandina/`. Abreviaturas:
`Liq` = `calculo/CalculadoraLiquidacion.java`, `Com` = `calculo/CalculadoraComision.java`,
`Plan` = `modelo/PlanComisiones.java`, `Fecha` = `calculo/UtilidadesFecha.java`.

## 1. Qué clase calcula de verdad

El cálculo que produce la liquidación está escrito en línea dentro de
`procesarLiquidacionCompleta` (`Liq:82-364`). No llama a `CalculadoraComision`: esa clase
solo la usa `calculo/SimuladorComision.java` (búsqueda de referencias en `escenario/java/src`).
Por eso hay dos versiones del cálculo de una transacción y no son idénticas (ver secciones 3 y 4).

## 2. Qué transacciones entran

1. Una transacción se descarta, y se cuenta en `transaccionesDescartadas`, si es nula, no tiene
   fecha, su moneda no es `PEN` o su monto es menor o igual a cero (`Liq:57-73`). Solo las
   válidas suman a `acumuladoGeneralTransado` (`Liq:74`).
2. Debe caer en el periodo: no anterior al inicio y no posterior al fin (`Liq:136`).
3. Debe estar en estado `APROBADA` (`Liq:138`). Las `ANULADA`, `RECHAZADA` y `PENDIENTE` no
   generan comisión (estados en `modelo/EstadoTransaccion.java:6-9`).
4. Se liquidan los comercios que no están `DE_BAJA` (`Liq:110-112`) y cuyo plan existe (`Liq:114-116`).
   Un comercio sin transacciones liquidadas no se imprime ni se agrega al resultado (`Liq:317-319`).

## 3. Selección del tramo y porcentaje

- Flujo de liquidación: recorre los tramos en orden y toma el primero con
  `monto >= desde` y `monto < hasta` (`Liq:144-155`). Si ninguno calza, toma el porcentaje del
  último tramo (`Liq:157-162`).
- `CalculadoraComision.determinarTramo` usa `monto >= desde` y `monto <= hasta` (`Com:23`), es
  decir, el límite superior es inclusivo. Un monto exactamente igual a un límite cae en tramos
  distintos según qué versión se use.
- Los tramos **no son acumulativos** en el código: el porcentaje del tramo encontrado se
  aplica al monto completo (`Liq:164`, `Com:38-39`). El comentario de `Plan:9-10` afirma lo
  contrario (que son acumulativos); el código no lo hace así.

## 4. Comisión base, monto fijo y recargo por cuotas

- Comisión base = `monto * porcentaje / 100` y luego se suma el monto fijo del plan
  (`Liq:164-165`, `Com:39-40`).
- Recargo por cuotas: si `cuotas > 1`, el porcentaje de recargo es `(cuotas - 1) * 0.5`
  (`Liq:169-171`), con tope de `3.0` en el flujo de liquidación (`Liq:173-175`). El recargo se
  calcula sobre la comisión base, ya con el monto fijo incluido: `comisionBase * porcentajeRecargo / 100`
  (`Liq:177`).
- En `CalculadoraComision` el mismo tope es `3.5` (`Com:53-55`), no `3.0`.
- Comisión total de la transacción = base + recargo (`Liq:180`, `Com:65`).
- El monto de cada línea de detalle no se redondea (`Liq:182-190`).

## 5. Total del comercio y tope mensual

- `totalTransado`, `totalComisiones` y `cantidadTransacciones` se acumulan con `double`
  (`Liq:192-194`).
- Si `totalComisiones` supera el tope del plan, se reemplaza por el tope y se marca
  `topeAplicado` (`Liq:202-205`). El acumulado general de comisiones se suma antes del tope
  (`Liq:196`), por lo que no refleja el tope.

## 6. Contracargos

Se suman los contracargos del comercio con estado `APROBADO`, fecha no nula y fecha dentro
del periodo (`Liq:211-226`). La fecha es la de aprobación según `escenario/README.md`, de modo que
se descuentan en el periodo en que se aprueban. No se descuentan en el periodo de la transacción
original.

## 7. Retención de garantía

Si el comercio tiene fecha de afiliación, se calculan los meses completos entre esa fecha y el
inicio del periodo (`Liq:230-234`, `Fecha:125-143`). Si son menos de 6, la base es
`totalTransado - totalComisiones - totalContracargos` y, si es positiva, la retención es el 5 %
de esa base (`Liq:236-243`). Ese 5 % es un literal en la línea 241.

## 8. Redondeo y neto

- `totalTransado`, `totalComisiones`, `totalContracargos` y `retenciones` se redondean con
  `Math.round(x * 100.0) / 100.0` (`Liq:246-249`). Se redondea solo en los totales.
- El neto es `totalTransado - totalComisiones - totalContracargos - retenciones`
  (`modelo/Liquidacion.java:99-101`) y se vuelve a redondear (`Liq:257-259`).

## 9. Periodo

El inicio es el día 1 a las 00:00:00 y el fin el último día a las 23:59:59 (`Fecha:77-108`). Se
usa `Calendar.getInstance(ConfiguracionRegional.REGION_DE_SALIDA)` (`Fecha:35`), que fija la
configuración regional pero no la zona horaria: se toma la del sistema (`util/ConfiguracionRegional.java:34-35`).

## Contraste con las reglas declaradas

Reglas de `escenario/README.md`, secciones «Reglas de negocio» 1 a 9.

| Regla | Qué dice | Qué hace el código | Resultado |
|---|---|---|---|
| 1 | Porcentaje del tramo más monto fijo | `Liq:164-165` | Coincide |
| 2 | Tramos no acumulativos | `Liq:164` aplica el porcentaje al monto completo. El comentario `Plan:9-10` dice lo contrario | Coincide el código. El comentario contradice la regla |
| 3 | Recargo 0,5 % por cuota sobre la primera, máximo 3 % | Flujo de liquidación: tope 3.0 (`Liq:173-175`). `CalculadoraComision`: tope 3.5 (`Com:53-55`) | No coincide en `CalculadoraComision`; coincide en la liquidación |
| 4 | Anuladas no generan comisión | Solo `APROBADA` genera comisión (`Liq:138`) | Coincide (y también excluye rechazadas y pendientes) |
| 5 | Contracargos aprobados en el periodo en que se aprueban | `Liq:213-222` | Coincide |
| 6 | Si el total supera el tope, se cobra el tope | `Liq:202-205` | Coincide |
| 7 | Retención del 5 % si hay menos de seis meses | `Liq:236-243`; la base es transado menos comisiones menos contracargos | Coincide (la base «monto neto» se interpreta así, sin restar la retención) |
| 8 | Periodo en hora de Lima | `Fecha:35` y `Fecha:77-108` usan la zona horaria del sistema, no fijan Lima | No coincide, o depende de la máquina |
| 9 | Dos decimales, medio hacia arriba | `Math.round(x * 100.0) / 100.0` en totales (`Liq:246-249`). Las líneas de detalle no se redondean | Coincide en los totales |

Resumen: coinciden 7 reglas (1, 2, 4, 5, 6, 7, 9). No coinciden o coinciden solo en parte 2
(3, en `CalculadoraComision`; y 8, la zona horaria).

## Paso 2: `/lab-4-4-paso-2-documentar-decisiones`

Grabado en SPEC-015, después de reescribir el paso. Segundos: 73. Archivos leídos: el índice
de `docs/arquitectura/decisiones/`, la plantilla, `pom.xml`, los dos `.csproj` y
`escenario/README.md`.

### Respuesta final del chat

**1. ¿Ya está registrada?** No. El índice `docs/arquitectura/decisiones/README.md`
(líneas 6-10) tiene tres decisiones: 0001 (dos implementaciones con salida idéntica), 0002
(servidor MCP local de solo lectura) y 0003 (hook de protección de datos). Ninguna trata
las dependencias del escenario; 0002 habla de dependencias, pero de las del servidor MCP.

**2. Dependencias por proyecto.**

- Java (`escenario/java/pom.xml`): una sola dependencia, `junit-jupiter` 5.12.2 con
  `<scope>test</scope>` (líneas 23 y 26-33). Además, tres plugins de construcción con
  versión fija (37-60).
- .NET ejecutable (`LiquidacionComercios.csproj`): ninguna `PackageReference`; solo el SDK
  `Microsoft.NET.Sdk` y `net10.0` (líneas 1 y 5). `dotnet list LiquidacionComercios
  package` lo confirma.
- .NET pruebas (`LiquidacionComercios.Pruebas.csproj`): `Microsoft.NET.Test.Sdk`, `xunit` y
  `xunit.runner.visualstudio` (14-16), más la referencia al proyecto principal (20).
- El código de producción solo importa `java.*` y `System.*`; JUnit y xUnit aparecen solo
  en las pruebas.

**3.** Creé `labs/cap4/lab-4-4-documentacion/entregables/decisiones.md` con una sola
decisión en el formato de la plantilla: contexto, alternativas, decisión, consecuencias y
verificación. Probé los cuatro comandos de verificación y devuelven lo que dice el
documento.

**4. Quedaron como pendientes de confirmar con el equipo:**

- Que se evitaron frameworks para que el código se pueda leer completo durante un
  laboratorio.
- Que se evitaron dependencias de ejecución por la falta de descargas en la clase.
- Que se buscó la misma ausencia de dependencias en ambos stacks para mantenerlos
  comparables (relación con 0001).
- Que la imagen de la máquina solo necesita precargar las dependencias de prueba y los
  plugins de Maven.
- Que un laboratorio que necesite una biblioteca nueva tendría que reabrir la decisión.
- El responsable de la decisión.

No usé la skill `pasarela-registrar-decision` ni escribí en `docs/arquitectura/decisiones/`.
No modifiqué código.

Notas:

- `mvn dependency:list` no funciona sin red en esta máquina porque el plugin
  `maven-dependency-plugin` no está precargado; por eso la verificación de Java usa `grep`.
- Al ejecutar `dotnet list ... package` se generó `escenario/dotnet/LiquidacionComercios/obj/`,
  que git ignora; lo borré para dejar el escenario como estaba.

### Archivo creado: `decisiones.md`

# NNNN. Escenario sin frameworks ni dependencias de ejecución

| Campo | Valor |
|---|---|
| Estado | Propuesta |
| Fecha | 2026-10-03 |
| Responsable | Pendiente de confirmar con el equipo |

> Borrador del laboratorio 4.4. No está registrada en `docs/arquitectura/decisiones/`; el
> número se asigna si el equipo decide registrarla. Ninguna de las decisiones 0001, 0002 y
> 0003 del índice trata las dependencias del escenario.

## Contexto

### Lo que respalda el código

El escenario tiene tres proyectos. Sus dependencias declaradas son estas:

| Proyecto | Dependencia | Tipo | Respaldo |
|---|---|---|---|
| Java, `escenario/java/pom.xml` | `org.junit.jupiter:junit-jupiter` 5.12.2 | Prueba (`<scope>test</scope>`) | `pom.xml` 23 y 26-33 |
| Java | `maven-compiler-plugin` 3.13.0, `maven-surefire-plugin` 3.5.6, `maven-jar-plugin` 3.4.2 | Plugins de construcción, no se empaquetan con la aplicación | `pom.xml` 37-60 |
| .NET, `LiquidacionComercios.csproj` | Ninguna `PackageReference` | Solo la plataforma: SDK `Microsoft.NET.Sdk`, destino `net10.0` | `LiquidacionComercios.csproj` 1 y 5; el archivo no tiene `ItemGroup` (1-20) |
| .NET, `LiquidacionComercios.Pruebas.csproj` | `Microsoft.NET.Test.Sdk` 17.11.1, `xunit` 2.9.2, `xunit.runner.visualstudio` 2.8.2 | Prueba | `LiquidacionComercios.Pruebas.csproj` 14-16 |
| .NET, pruebas | Referencia al proyecto `LiquidacionComercios` | Proyecto propio | `LiquidacionComercios.Pruebas.csproj` 20 |

El `pom.xml` declara una sola dependencia y es de prueba (26-33). El proyecto .NET
ejecutable no declara paquetes; `dotnet list LiquidacionComercios package` lo confirma con
«No packages were found for this framework».

El código de producción tampoco usa bibliotecas externas:

- Los `import` de `escenario/java/src/main` son solo de `java.*` y del propio paquete
  `pe.pasarelaandina`. Los únicos externos están en `src/test` y son de
  `org.junit.jupiter`.
- Los `using` de `escenario/dotnet/LiquidacionComercios` son solo de `System.*` y del
  propio espacio de nombres. `Xunit` aparece únicamente en el proyecto de pruebas.

No hay base de datos: los datos se leen de archivos de texto y se cargan en memoria al
arrancar ([escenario/README.md](../../../../escenario/README.md), líneas 117-119). La
aplicación Java se ejecuta como un jar con clase principal declarada (`pom.xml` 52-58,
README 61-64) y la .NET como un ejecutable de consola (`LiquidacionComercios.csproj` 4,
README 82-85).

### Suposiciones sobre el porqué

- **Pendiente de confirmar con el equipo:** se evitaron frameworks para que el código
  quepa en la cabeza de un participante en el tiempo de un laboratorio, sin capas de
  inyección de dependencias ni configuración que leer antes de llegar al cálculo.
- **Pendiente de confirmar con el equipo:** se evitaron dependencias de ejecución porque
  las máquinas de clase no tienen descargas durante la sesión. `AGENTS.md` y
  `.github/copilot-instructions.md` dicen que todo está instalado en la imagen, pero no
  dicen que esa sea la razón de esta decisión.
- **Pendiente de confirmar con el equipo:** se mantiene la misma ausencia de dependencias
  en ambos stacks para que las dos implementaciones sean comparables, en línea con la
  decisión 0001.

## Alternativas consideradas

- **Biblioteca estándar más un framework de pruebas (elegida).** Sin descargas en
  ejecución y con un código que se lee de principio a fin. El costo es que todo lo que un
  framework daría hecho, como la carga de datos o la configuración, se escribe a mano.
- **Framework de aplicación en cada stack, por ejemplo Spring Boot y ASP.NET Core.** Más
  parecido a un sistema de producción. Agrega dependencias de ejecución y estructura que
  el participante tiene que entender antes de llegar al cálculo.
- **Bibliotecas puntuales de ejecución, por ejemplo para leer archivos delimitados.**
  Menos código propio. Cada biblioteca es una dependencia más que precargar en la imagen y
  una diferencia más entre los dos stacks.

## Decisión

El escenario usa solo la biblioteca estándar de cada plataforma en el código de
producción. Las únicas dependencias externas son las de prueba: JUnit 5 en Java y xUnit
con su ejecutor en .NET. Los plugins de Maven se usan solo para construir.

## Consecuencias

### Respaldadas por el código

- Construir y ejecutar la aplicación no requiere más paquetes que los de prueba y, en
  Java, los plugins de construcción (`pom.xml` 26-60, `LiquidacionComercios.csproj` 1-20).
- La carga de datos, el cálculo y la salida están escritos con clases propias: el código
  de producción no importa nada fuera de la biblioteca estándar.
- Las instrucciones por ruta prohíben agregar dependencias:
  `.github/instructions/java.instructions.md` («No agregues dependencias al `pom.xml`») y
  `.github/instructions/dotnet.instructions.md` («No agregues paquetes NuGet»).

### Suposiciones

- **Pendiente de confirmar con el equipo:** la imagen de las máquinas virtuales solo
  necesita precargar las dependencias de prueba y los plugins de Maven para compilar y
  probar sin red.
- **Pendiente de confirmar con el equipo:** un laboratorio que necesite una biblioteca
  nueva tendría que reabrir esta decisión, porque contradice las instrucciones por ruta.

## Verificación

Desde la raíz del repositorio, en Git Bash:

```bash
# Java: una sola dependencia y es de prueba
grep -c "<dependency>" escenario/java/pom.xml
grep -A4 "<dependency>" escenario/java/pom.xml | grep "<scope>test</scope>"

# Java: el código de producción solo importa la biblioteca estándar y el propio paquete
grep -rh "^import " escenario/java/src/main | grep -v "import java\.\|import pe\.pasarelaandina"

# .NET: el proyecto ejecutable no tiene paquetes
grep -c "PackageReference" escenario/dotnet/LiquidacionComercios/LiquidacionComercios.csproj
```

El primer comando devuelve 1, el segundo muestra una línea, el tercero no muestra nada y
el cuarto devuelve 0. En .NET también sirve, desde `escenario/dotnet/`,
`dotnet list LiquidacionComercios package`, que no debe listar paquetes.

## Paso 3: `/lab-4-4-paso-3-preparar-para-confluence` (sin argumento)

Segundos: 5. Sin argumento: se usó por omisión `calculo-de-comisiones.md`, que existe.

### Respuesta final del chat

He creado `labs/cap4/lab-4-4-documentacion/entregables/calculo-de-comisiones-confluence.md`, copia de `calculo-de-comisiones.md`, que no se modificó.

Lo que se perdió o cambió, tras revisar las cuatro categorías:
- Enlaces relativos al repositorio: no había ninguno (las rutas ya estaban como texto en código); no se cambió nada.
- Tablas con celdas de varias líneas: ninguna.
- Bloques de código sin lenguaje: ninguno (no hay bloques delimitados).
- HTML incrustado: ninguno.

En consecuencia la copia solo agrega la sección «Qué se perdió en el traslado», que lo registra. Lo que Confluence no puede conservar es la navegabilidad de las rutas y la vigencia de las citas de línea.

Salida esperada (copia creada y lista de lo que se perdió): cumplida, con la salvedad de que el documento no contenía nada que reemplazar.

### Archivo creado: `calculo-de-comisiones-confluence.md`

# Cálculo de comisiones según el código (escenario Java)

Este documento describe lo que hace el código, no lo que dicen sus comentarios. Las rutas
son relativas a `escenario/java/src/main/java/pe/pasarelaandina/`. Abreviaturas:
`Liq` = `calculo/CalculadoraLiquidacion.java`, `Com` = `calculo/CalculadoraComision.java`,
`Plan` = `modelo/PlanComisiones.java`, `Fecha` = `calculo/UtilidadesFecha.java`.

## 1. Qué clase calcula de verdad

El cálculo que produce la liquidación está escrito en línea dentro de
`procesarLiquidacionCompleta` (`Liq:82-364`). No llama a `CalculadoraComision`: esa clase
solo la usa `calculo/SimuladorComision.java` (búsqueda de referencias en `escenario/java/src`).
Por eso hay dos versiones del cálculo de una transacción y no son idénticas (ver secciones 3 y 4).

## 2. Qué transacciones entran

1. Una transacción se descarta, y se cuenta en `transaccionesDescartadas`, si es nula, no tiene
   fecha, su moneda no es `PEN` o su monto es menor o igual a cero (`Liq:57-73`). Solo las
   válidas suman a `acumuladoGeneralTransado` (`Liq:74`).
2. Debe caer en el periodo: no anterior al inicio y no posterior al fin (`Liq:136`).
3. Debe estar en estado `APROBADA` (`Liq:138`). Las `ANULADA`, `RECHAZADA` y `PENDIENTE` no
   generan comisión (estados en `modelo/EstadoTransaccion.java:6-9`).
4. Se liquidan los comercios que no están `DE_BAJA` (`Liq:110-112`) y cuyo plan existe (`Liq:114-116`).
   Un comercio sin transacciones liquidadas no se imprime ni se agrega al resultado (`Liq:317-319`).

## 3. Selección del tramo y porcentaje

- Flujo de liquidación: recorre los tramos en orden y toma el primero con
  `monto >= desde` y `monto < hasta` (`Liq:144-155`). Si ninguno calza, toma el porcentaje del
  último tramo (`Liq:157-162`).
- `CalculadoraComision.determinarTramo` usa `monto >= desde` y `monto <= hasta` (`Com:23`), es
  decir, el límite superior es inclusivo. Un monto exactamente igual a un límite cae en tramos
  distintos según qué versión se use.
- Los tramos **no son acumulativos** en el código: el porcentaje del tramo encontrado se
  aplica al monto completo (`Liq:164`, `Com:38-39`). El comentario de `Plan:9-10` afirma lo
  contrario (que son acumulativos); el código no lo hace así.

## 4. Comisión base, monto fijo y recargo por cuotas

- Comisión base = `monto * porcentaje / 100` y luego se suma el monto fijo del plan
  (`Liq:164-165`, `Com:39-40`).
- Recargo por cuotas: si `cuotas > 1`, el porcentaje de recargo es `(cuotas - 1) * 0.5`
  (`Liq:169-171`), con tope de `3.0` en el flujo de liquidación (`Liq:173-175`). El recargo se
  calcula sobre la comisión base, ya con el monto fijo incluido: `comisionBase * porcentajeRecargo / 100`
  (`Liq:177`).
- En `CalculadoraComision` el mismo tope es `3.5` (`Com:53-55`), no `3.0`.
- Comisión total de la transacción = base + recargo (`Liq:180`, `Com:65`).
- El monto de cada línea de detalle no se redondea (`Liq:182-190`).

## 5. Total del comercio y tope mensual

- `totalTransado`, `totalComisiones` y `cantidadTransacciones` se acumulan con `double`
  (`Liq:192-194`).
- Si `totalComisiones` supera el tope del plan, se reemplaza por el tope y se marca
  `topeAplicado` (`Liq:202-205`). El acumulado general de comisiones se suma antes del tope
  (`Liq:196`), por lo que no refleja el tope.

## 6. Contracargos

Se suman los contracargos del comercio con estado `APROBADO`, fecha no nula y fecha dentro
del periodo (`Liq:211-226`). La fecha es la de aprobación según `escenario/README.md`, de modo que
se descuentan en el periodo en que se aprueban. No se descuentan en el periodo de la transacción
original.

## 7. Retención de garantía

Si el comercio tiene fecha de afiliación, se calculan los meses completos entre esa fecha y el
inicio del periodo (`Liq:230-234`, `Fecha:125-143`). Si son menos de 6, la base es
`totalTransado - totalComisiones - totalContracargos` y, si es positiva, la retención es el 5 %
de esa base (`Liq:236-243`). Ese 5 % es un literal en la línea 241.

## 8. Redondeo y neto

- `totalTransado`, `totalComisiones`, `totalContracargos` y `retenciones` se redondean con
  `Math.round(x * 100.0) / 100.0` (`Liq:246-249`). Se redondea solo en los totales.
- El neto es `totalTransado - totalComisiones - totalContracargos - retenciones`
  (`modelo/Liquidacion.java:99-101`) y se vuelve a redondear (`Liq:257-259`).

## 9. Periodo

El inicio es el día 1 a las 00:00:00 y el fin el último día a las 23:59:59 (`Fecha:77-108`). Se
usa `Calendar.getInstance(ConfiguracionRegional.REGION_DE_SALIDA)` (`Fecha:35`), que fija la
configuración regional pero no la zona horaria: se toma la del sistema (`util/ConfiguracionRegional.java:34-35`).

## Contraste con las reglas declaradas

Reglas de `escenario/README.md`, secciones «Reglas de negocio» 1 a 9.

| Regla | Qué dice | Qué hace el código | Resultado |
|---|---|---|---|
| 1 | Porcentaje del tramo más monto fijo | `Liq:164-165` | Coincide |
| 2 | Tramos no acumulativos | `Liq:164` aplica el porcentaje al monto completo. El comentario `Plan:9-10` dice lo contrario | Coincide el código. El comentario contradice la regla |
| 3 | Recargo 0,5 % por cuota sobre la primera, máximo 3 % | Flujo de liquidación: tope 3.0 (`Liq:173-175`). `CalculadoraComision`: tope 3.5 (`Com:53-55`) | No coincide en `CalculadoraComision`; coincide en la liquidación |
| 4 | Anuladas no generan comisión | Solo `APROBADA` genera comisión (`Liq:138`) | Coincide (y también excluye rechazadas y pendientes) |
| 5 | Contracargos aprobados en el periodo en que se aprueban | `Liq:213-222` | Coincide |
| 6 | Si el total supera el tope, se cobra el tope | `Liq:202-205` | Coincide |
| 7 | Retención del 5 % si hay menos de seis meses | `Liq:236-243`; la base es transado menos comisiones menos contracargos | Coincide (la base «monto neto» se interpreta así, sin restar la retención) |
| 8 | Periodo en hora de Lima | `Fecha:35` y `Fecha:77-108` usan la zona horaria del sistema, no fijan Lima | No coincide, o depende de la máquina |
| 9 | Dos decimales, medio hacia arriba | `Math.round(x * 100.0) / 100.0` en totales (`Liq:246-249`). Las líneas de detalle no se redondean | Coincide en los totales |

Resumen: coinciden 7 reglas (1, 2, 4, 5, 6, 7, 9). No coinciden o coinciden solo en parte 2
(3, en `CalculadoraComision`; y 8, la zona horaria).

## Qué se perdió en el traslado

Se revisó el documento contra las cuatro cosas que Confluence no conserva al importar Markdown:

- Enlaces relativos a archivos del repositorio: no había ninguno. Todas las rutas del documento están
  escritas como texto en formato de código, sin enlace, así que no se cambió nada. Al pegarlo en
  Confluence esas rutas no serán navegables, y no hay forma de volverlas enlaces sin una URL del repositorio.
- Tablas con celdas de varias líneas: no había ninguna. La tabla de contraste tiene una línea por celda.
  Las celdas son largas y en Confluence quedan como columnas anchas.
- Bloques de código sin lenguaje declarado: no había bloques de código delimitados. Solo hay fragmentos en
  línea, que Confluence conserva.
- HTML incrustado: no había ninguno.

Cambios hechos en la copia: ninguno en el contenido, solo se agregó esta sección. El original no se
modificó.

Lo que sí cambia al pegar en Confluence, aunque no se pueda corregir en el archivo:

- Las abreviaturas `Liq`, `Com`, `Plan` y `Fecha` de la introducción son una convención del documento y no se
  vinculan con los archivos.
- Las citas de línea (`Liq:164`) quedan como texto y pierden vigencia si el código cambia.
