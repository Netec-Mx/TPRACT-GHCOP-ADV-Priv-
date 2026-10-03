# Respaldo de la demostración 5.3

Corrida real del 3 de octubre de 2026, en `RodrigoMSB/github-copilot-netec-demo`, un
repositorio privado de grabación que no se comparte con los participantes. Pull request #1,
cerrado sin integrar y con la rama borrada. Stack `ambos`.

## Primera corrida, sin la corrección

Rama con el reporte de referencia y el paso `conciliacion` en el pipeline. Ejecución
37137957343, 59 segundos de punta a punta. Resultado: **failure**.

| Trabajo | Resultado | Inicio | Fin |
|---|---|---|---|
| Stack declarado | success | 16:44:28 | 16:44:34 |
| Java, compilacion, pruebas y dependencias | success | 16:44:36 | 16:45:07 |
| .NET, compilacion, pruebas y dependencias | success | 16:44:37 | 16:45:17 |
| Liquidacion contra los hashes esperados y equivalencia | **failure** | 16:44:36 | 16:45:22 |

Registro del trabajo de equivalencia y conciliación:

```
  [ OK ] Apache Maven disponible
  [ OK ] Escenario .NET ejecutado (554 lineas)
  [ OK ] Escenario .NET ejecutado (558 lineas)
  [ OK ] Escenario Java ejecutado (554 lineas)
  [ OK ] Escenario Java ejecutado (558 lineas)
  [ OK ] JDK disponible
  [ OK ] Las salidas son identicas
  [ OK ] SDK de .NET disponible
  [ OK ] datos encontrado
  [ OK ] diff disponible
  [ OK ] dotnet 2026-04 coincide con el hash esperado
  [ OK ] dotnet 2026-04 concilia
  [ OK ] dotnet 2026-05 coincide con el hash esperado
  [ OK ] dotnet 2026-05 concilia
  [ OK ] dotnet 2026-06 coincide con el hash esperado
  [ OK ] dotnet encontrado
  [ OK ] java 2026-04 coincide con el hash esperado
  [ OK ] java 2026-04 concilia
  [ OK ] java 2026-05 coincide con el hash esperado
  [ OK ] java 2026-05 concilia
  [ OK ] java 2026-06 coincide con el hash esperado
  [ OK ] java encontrado
  [FALLA] dotnet 2026-06 no concilia: reporte menos liquidaciones = 2203 centavos
  [FALLA] java 2026-06 no concilia: reporte menos liquidaciones = 2203 centavos
```

## Segunda corrida, con la corrección

Se empujó la corrección de los dos stacks y el hash esperado nuevo de junio. Ejecución
37138080786, 59 segundos. Resultado: **success**.

| Trabajo | Resultado | Inicio | Fin |
|---|---|---|---|
| Stack declarado | success | 16:46:22 | 16:46:27 |
| Java, compilacion, pruebas y dependencias | success | 16:46:29 | 16:46:48 |
| .NET, compilacion, pruebas y dependencias | success | 16:46:29 | 16:46:49 |
| Liquidacion contra los hashes esperados y equivalencia | success | 16:46:29 | 16:47:18 |

```
  [ OK ] Apache Maven disponible
  [ OK ] Escenario .NET ejecutado (554 lineas)
  [ OK ] Escenario .NET ejecutado (558 lineas)
  [ OK ] Escenario Java ejecutado (554 lineas)
  [ OK ] Escenario Java ejecutado (558 lineas)
  [ OK ] JDK disponible
  [ OK ] Las salidas son identicas
  [ OK ] SDK de .NET disponible
  [ OK ] datos encontrado
  [ OK ] diff disponible
  [ OK ] dotnet 2026-04 coincide con el hash esperado
  [ OK ] dotnet 2026-04 concilia
  [ OK ] dotnet 2026-05 coincide con el hash esperado
  [ OK ] dotnet 2026-05 concilia
  [ OK ] dotnet 2026-06 coincide con el hash esperado
  [ OK ] dotnet 2026-06 concilia
  [ OK ] dotnet encontrado
  [ OK ] java 2026-04 coincide con el hash esperado
  [ OK ] java 2026-04 concilia
  [ OK ] java 2026-05 coincide con el hash esperado
  [ OK ] java 2026-05 concilia
  [ OK ] java 2026-06 coincide con el hash esperado
  [ OK ] java 2026-06 concilia
  [ OK ] java encontrado
```

## Revisión de Copilot

Pull request #2 del repositorio de demostración, con el cambio completo y el stack `ambos`.
Revisión pedida el 3 de octubre de 2026 a las 21:12 UTC con `gh pr edit 2 --add-reviewer
@copilot` y publicada a las 21:17 UTC. Un primer intento, 20:55 UTC, terminó en «Copilot
encountered an error and was unable to review this pull request». El pull request se cerró
sin integrar y la rama se borró.

Resumen de la revisión, textual:

> **Changes recommended.** La conciliación ignora fallos de ejecución y el código .NET omite
> la utilidad obligatoria de compatibilidad monetaria.
>
> Review effort: Balanced. Findings: 4, severidad media.

Comentarios en el código, textuales:

**`escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs`, línea 249,
«Usar CompatibilidadJava para redondear comisiones».**

> El nuevo redondeo de comisiones evita `CompatibilidadJava`, mientras los demás montos de
> esta misma liquidación pasan por esa clase y la convención exige centralizarlos allí
> (`CompatibilidadJava.cs:53-76`). Incorporen una sobrecarga para `decimal` y úsela aquí para
> que la equivalencia no dependa de una implementación paralela.

**`escenario/dotnet/LiquidacionComercios/Reporte/CalculadoraReporteMedios.cs`, línea 198,
«Centralizar el redondeo decimal en CompatibilidadJava».**

> Este helper introduce otro punto de redondeo fuera de `Util/CompatibilidadJava`, en contra
> de la convención establecida en `CompatibilidadJava.cs:53-76` para mantener idénticos los
> escenarios. Centralicen también el redondeo de `decimal` en esa utilidad y hagan que esta
> calculadora lo consuma.

**`escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporteMedios.cs`, línea 84,
«Centralizar el formateo monetario en CompatibilidadJava».**

> Este formateo vuelve a implementar directamente el redondeo y `ToString`, pero la
> convención del escenario .NET centraliza todo formateo monetario en `Util/CompatibilidadJava`
> para conservar la equivalencia con Java (`CompatibilidadJava.cs:53-76`). Agreguen allí una
> sobrecarga para `decimal` y reutilícenla desde este formateador; mantener una segunda
> implementación permite que ambas salidas diverjan cuando cambie alguna regla de
> compatibilidad.

**`scripts/integracion-local.sh`, línea 184, «Verificar códigos de salida antes de analizar
resultados».**

> Ambas ejecuciones descartan su código de salida; como el script solo usa `set -u`, un
> proceso que falle continúa hacia la conciliación y el resultado se decide a partir de
> archivos parciales o vacíos en vez de fallar por la ejecución. Comprueben cada llamada y
> contabilicen el fallo antes de analizar los totales.
