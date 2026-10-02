segundos: 29

## Paso 1 - Abrir instrucciones
java.instructions.md: `applyTo: 'escenario/java/**/*.java,escenario/java/pom.xml'`
dotnet.instructions.md: `applyTo: 'escenario/dotnet/**/*.cs,escenario/dotnet/**/*.csproj'`

## Paso 2 - Agent, chat nuevo
Texto escrito:
```
¿Qué comando uso para correr las pruebas de escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java y con qué framework se escriben?
```
Referencias: .github/instructions/java.instructions.md, escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java, AGENTS.md, .github/copilot-instructions.md

Respuesta:
> Desde `escenario/java/` el comando es:
>
> ```bash
> mvn test
> ```
>
> (Para compilar y empaquetar antes: `mvn -q clean package`.) Las pruebas se escriben con **JUnit 5** (`org.junit.jupiter.api`). Las clases de prueba terminan en `Test`, viven en `src/test/java` con el mismo paquete que la clase probada (aquí `pe.pasarelaandina.reporte.FormateadorReporteTest`), y los nombres de los métodos describen en español lo esperado, en camelCase.
>
> Hoy no existe una prueba para `FormateadorReporte`: en `src/test/java` solo hay pruebas de `modelo` y `util`. Una prueba nueva iría en un archivo nuevo. No agregué nada porque no lo pediste.

## Paso 3 - Agent, chat nuevo
Texto escrito:
```
¿Qué comando uso para correr las pruebas de escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporte.cs y con qué framework se escriben?
```
Referencias: .github/instructions/dotnet.instructions.md, escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporte.cs, AGENTS.md, .github/copilot-instructions.md

Respuesta:
> Desde `escenario/dotnet/`:
>
> ```bash
> dotnet test LiquidacionComercios.Pruebas
> ```
>
> (Para compilar antes: `dotnet build LiquidacionComercios -c Release`.) Las pruebas usan **xUnit**, con `[Fact]`. Las clases terminan en `Pruebas` y viven en `LiquidacionComercios.Pruebas`, en el directorio que corresponde a la clase probada (aquí `Reporte/FormateadorReportePruebas.cs`). Los métodos se nombran en español y en PascalCase.
>
> Hoy no hay pruebas de `FormateadorReporte`: el proyecto solo tiene `Modelo/` y `Util/`. Tampoco agregué nada.

## Paso 4 - Abrir AGENTS.md
Contenido mostrado: título "Contexto del proyecto para agentes de IA", secciones sobre qué es el repositorio, "El código del escenario no se corrige por iniciativa propia", hook en .github/hooks, convenciones y ambiente de clase.

## Esperado contra observado
| Paso | Resultado | Nota |
|---|---|---|
| 1 | Coincide | |
| 2 | Coincide | mvn test, JUnit 5, java.instructions.md en referencias. |
| 3 | Coincide | dotnet test, xUnit, dotnet.instructions.md en referencias. |
| 4 | Coincide | |
