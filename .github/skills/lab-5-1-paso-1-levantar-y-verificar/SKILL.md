---
name: lab-5-1-paso-1-levantar-y-verificar
description: 'Lab 5.1 paso 1. Compila y ejecuta los dos escenarios y corre el comparador, para tener una línea base verificada.'
disable-model-invocation: true
---

# Objetivo

Establecer una línea base verificada antes de tocar nada: los dos escenarios compilan,
sus pruebas pasan y producen la misma salida.

# Qué hacer

Ejecuta en la terminal, en este orden, y registra el resultado de cada comando:

1. Desde `escenario/java/`: `mvn -q clean package`
2. Desde `escenario/dotnet/`: `dotnet build LiquidacionComercios -c Release`
3. Desde `escenario/dotnet/`: `dotnet test LiquidacionComercios.Pruebas`
4. Desde la raíz del repositorio: `bash scripts/comparar-escenarios.sh`

Si un comando falla, detente, muestra el error y no intentes arreglarlo.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques ningún archivo.
- No instales ni descargues nada.

# Salida esperada

| Comando | Resultado | Duración aproximada | Observación |
|---|---|---|---|

Debajo, la cantidad de pruebas que corrieron y la última línea del comparador.
