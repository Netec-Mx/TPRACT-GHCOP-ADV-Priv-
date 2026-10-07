> Documento de referencia para el relator, escrito sin Copilot.

# NNNN. Escenario sin frameworks ni dependencias de ejecución

| Campo | Valor |
|---|---|
| Estado | Propuesta |
| Fecha | 2026-10-07 |
| Responsable | Pendiente de confirmar con el equipo |

> Borrador del laboratorio 4.4. No está registrada en `docs/arquitectura/decisiones/`; el
> número se asigna si el equipo decide registrarla. El índice
> (`docs/arquitectura/decisiones/README.md:8-10`) tiene tres decisiones: 0001, dos
> implementaciones con salida idéntica; 0002, servidor MCP local de solo lectura; 0003, hook
> de protección de datos. Ninguna trata las dependencias del escenario. La 0002 habla de
> dependencias, pero de las del servidor MCP.

## Contexto

### Lo que respalda el código

El escenario tiene tres proyectos. Sus dependencias declaradas son estas:

| Proyecto | Dependencia | Tipo | Respaldo |
|---|---|---|---|
| Java, `escenario/java/pom.xml` | `org.junit.jupiter:junit-jupiter` 5.12.2 | Prueba, `<scope>test</scope>` | `escenario/java/pom.xml:23`, `escenario/java/pom.xml:26-33` |
| Java | `maven-compiler-plugin` 3.13.0, `maven-surefire-plugin` 3.5.6, `maven-jar-plugin` 3.4.2 | Plugins de construcción; no forman parte del jar | `escenario/java/pom.xml:37-60` |
| .NET, `LiquidacionComercios.csproj` | Ninguna `PackageReference` | Solo la plataforma: SDK `Microsoft.NET.Sdk` y destino `net10.0` | `escenario/dotnet/LiquidacionComercios/LiquidacionComercios.csproj:1`, `escenario/dotnet/LiquidacionComercios/LiquidacionComercios.csproj:5`; el archivo no tiene `ItemGroup` (`escenario/dotnet/LiquidacionComercios/LiquidacionComercios.csproj:1-20`) |
| .NET, `LiquidacionComercios.Pruebas.csproj` | `Microsoft.NET.Test.Sdk` 17.11.1, `xunit` 2.9.2, `xunit.runner.visualstudio` 2.8.2 | Prueba | `escenario/dotnet/LiquidacionComercios.Pruebas/LiquidacionComercios.Pruebas.csproj:14-16` |
| .NET, pruebas | El proyecto `LiquidacionComercios` | Referencia a proyecto propio | `escenario/dotnet/LiquidacionComercios.Pruebas/LiquidacionComercios.Pruebas.csproj:20` |

El `pom.xml` declara una sola dependencia y es de prueba. El proyecto .NET ejecutable no
declara paquetes; `dotnet list LiquidacionComercios package`, ejecutado desde
`escenario/dotnet/`, responde «No packages were found for this framework».

El código de producción tampoco usa bibliotecas externas:

- Los `import` de `escenario/java/src/main` son todos de `java.*` o del propio paquete
  `pe.pasarelaandina`. Los únicos externos están en `escenario/java/src/test` y son de
  `org.junit.jupiter`.
- Los `using` de `escenario/dotnet/LiquidacionComercios` son todos de `System.*` o del propio
  espacio de nombres `Pe.PasarelaAndina`. `Xunit` aparece solo en el proyecto de pruebas.

No hay base de datos: los datos se leen de archivos de texto y se cargan en memoria al arrancar
(`escenario/README.md:117-119`). La aplicación Java se empaqueta como un jar con clase principal
declarada (`escenario/java/pom.xml:55`) y la .NET como un ejecutable de consola
(`escenario/dotnet/LiquidacionComercios/LiquidacionComercios.csproj:4`).

Las instrucciones del repositorio ya piden no agregar dependencias:
`.github/instructions/java.instructions.md:13` dice «No agregues dependencias al `pom.xml`. La
única dependencia es JUnit 5 para pruebas.» y `.github/instructions/dotnet.instructions.md:13`
dice «No agregues paquetes NuGet. El proyecto de pruebas ya tiene xUnit.». Ninguna de las dos
explica por qué.

### Suposiciones sobre el porqué

- **Pendiente de confirmar con el equipo:** se evitaron frameworks para que el código se pueda
  leer completo durante un laboratorio, sin inyección de dependencias ni configuración que
  entender antes de llegar al cálculo.
- **Pendiente de confirmar con el equipo:** se evitaron dependencias de ejecución porque las
  máquinas de clase no descargan nada durante la sesión. `AGENTS.md:58-60` y
  `.github/copilot-instructions.md:86` dicen que no hay descargas y que todo está instalado en
  la imagen, pero no presentan eso como la razón de esta decisión.
- **Pendiente de confirmar con el equipo:** se mantiene la misma ausencia de dependencias en los
  dos stacks para que las implementaciones sean comparables y produzcan la misma salida, en
  línea con la decisión 0001.

## Alternativas consideradas

- **Biblioteca estándar en producción y un framework de pruebas (elegida).** Sin dependencias
  que precargar para ejecutar y con un código que se lee de principio a fin. Su costo es que la
  carga de datos, el formateo y la salida se escriben a mano.
- **Un framework de aplicación en cada stack, por ejemplo Spring Boot y ASP.NET Core.** Más
  parecido a un sistema en producción. Agrega dependencias de ejecución y una estructura que el
  participante tiene que entender antes de llegar al cálculo.
- **Bibliotecas puntuales de ejecución, por ejemplo para leer archivos delimitados.** Menos
  código propio. Cada biblioteca es una dependencia más que precargar en la imagen y una
  diferencia más entre los dos stacks.

## Decisión

El código de producción del escenario usa solo la biblioteca estándar de cada plataforma. Las
únicas dependencias externas son las de prueba: JUnit 5 en Java y xUnit con su ejecutor y el
SDK de pruebas en .NET. Los plugins de Maven se usan solo para compilar, probar y empaquetar.

## Consecuencias

### Respaldadas por el código

- Ejecutar la aplicación no requiere paquetes externos: el jar Java solo contiene clases
  propias y el ejecutable .NET no tiene referencias a paquetes
  (`escenario/java/pom.xml:26-33`,
  `escenario/dotnet/LiquidacionComercios/LiquidacionComercios.csproj:1-20`).
- Compilar y probar sí requiere los artefactos de prueba y, en Java, los tres plugins de
  construcción (`escenario/java/pom.xml:37-60`,
  `escenario/dotnet/LiquidacionComercios.Pruebas/LiquidacionComercios.Pruebas.csproj:14-16`).
  `mvn -o -q test` termina bien sin red en la imagen de verificación, de modo que esos
  artefactos están precargados en ella.
- La carga de datos, el cálculo y la salida están escritos con clases propias, porque el código
  de producción no importa nada fuera de la biblioteca estándar.
- Agregar una dependencia contradice las instrucciones por ruta
  (`.github/instructions/java.instructions.md:13`,
  `.github/instructions/dotnet.instructions.md:13`).

### Suposiciones

- **Pendiente de confirmar con el equipo:** la imagen de las máquinas virtuales de clase solo
  necesita precargar las dependencias de prueba y los plugins de Maven para compilar y probar sin
  red. Se comprobó en la imagen de verificación, no en las máquinas de clase.
- **Pendiente de confirmar con el equipo:** un laboratorio que necesite una biblioteca nueva
  tendría que reabrir esta decisión y actualizar la imagen.

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

# .NET: el código de producción solo usa System y el propio espacio de nombres
grep -rh "^using " escenario/dotnet/LiquidacionComercios --include="*.cs" | grep -v "using System\|using Pe\.PasarelaAndina"
```

El primer comando devuelve 1, el segundo muestra una línea con `<scope>test</scope>`, el tercero
no muestra nada, el cuarto devuelve 0 y el quinto no muestra nada. Desde `escenario/dotnet/`,
`dotnet list LiquidacionComercios package` no debe listar paquetes.
