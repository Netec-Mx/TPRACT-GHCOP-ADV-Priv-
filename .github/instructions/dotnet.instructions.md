---
description: "Reglas de Copilot para el escenario .NET del taller"
applyTo: "escenario/dotnet/**/*.cs"
---

# Instrucciones para código .NET

> **Archivo marcador.** El bloque de metadatos de arriba ya declara el alcance real por
> patrón de ruta, pero el cuerpo no contiene reglas activas. Su contenido se define en
> **SPEC-005**.

## Qué irá en este archivo

Las convenciones que Copilot debe respetar al trabajar sobre `escenario/dotnet/`: versión
del lenguaje y del SDK, tipos de referencia que admiten null, estilo de nombres, manejo de
excepciones, framework y estilo de pruebas, uso de inyección de dependencias y criterios
de refactorización aceptables durante los laboratorios.

## Pendiente

- [ ] Redactar las reglas de .NET (SPEC-005)
- [ ] Confirmar que el patrón de `applyTo` coincide con la estructura real del escenario,
      una vez que SPEC-003 lo construya
