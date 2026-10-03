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

**Pendiente.** La cuenta usada para grabar no tiene disponible la revisión de Copilot en pull
requests: la solicitud no quedó registrada. Se graba en la máquina virtual con la cuenta de
prueba, según el bloque G del protocolo, y esta sección se completa con su resultado.
