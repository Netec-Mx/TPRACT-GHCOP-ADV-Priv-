---
name: 'Escenario .NET'
description: 'Convenciones para trabajar sobre el escenario .NET: versión, pruebas, compilación y alcance de los cambios'
applyTo: 'escenario/dotnet/**/*.cs,escenario/dotnet/**/*.csproj'
---

# Escenario .NET

## Versión y compilación

- Los proyectos apuntan a `net10.0`, con `Nullable` e `ImplicitUsings` deshabilitados. No
  los habilites y no uses características que exijan otra versión de destino.
- No agregues paquetes NuGet. El proyecto de pruebas ya tiene xUnit.
- Compila y prueba desde `escenario/dotnet/`:

  ```bash
  dotnet build LiquidacionComercios -c Release
  dotnet test LiquidacionComercios.Pruebas
  ```

## Estilo del código existente

- Espacio de nombres raíz `Pe.PasarelaAndina`, con `Modelo`, `Repositorio`, `Calculo`,
  `Reporte` y `Util`. El espacio de nombres corresponde al directorio.
- Nombres en español, en PascalCase para tipos y miembros públicos.
- Todo `Math.Round` indica `MidpointRounding.AwayFromZero`, que es medio hacia arriba, como
  pide la regla 9 de `escenario/README.md`. Sin ese argumento, .NET redondea al par.
- Los montos `double` de la liquidación se redondean y se formatean con
  `Util/CompatibilidadJava.cs`, que reproduce exactamente a Java para que los dos escenarios
  produzcan la misma salida. No la reemplaces por `Math.Round` sobre `double` ni por
  `ToString("F2")`, porque la salida dejaría de coincidir con la de Java.

## Pruebas

- xUnit, con `[Fact]`. Las clases de prueba terminan en `Pruebas` y viven en
  `LiquidacionComercios.Pruebas`, en el directorio que corresponde a la clase probada.
- Los nombres de los métodos de prueba describen en español lo que se espera, en
  PascalCase, por ejemplo `RechazaRegistrosTributariosMalFormados`.
- Una prueba nueva va en un archivo nuevo salvo que la tarea diga otra cosa.

## Alcance

- Las mismas reglas de `.github/copilot-instructions.md` aplican aquí. En particular, no
  cambies tipos, no extraigas literales, no unifiques código entre clases ni renombres
  nada que la tarea no nombre.
- El escenario Java tiene un archivo equivalente para cada archivo .NET. Si la tarea es
  sobre un solo escenario, no toques el otro.
