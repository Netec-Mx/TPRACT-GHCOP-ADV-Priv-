---
name: lab-5-1-paso-2-mapa-del-sistema
description: 'Lab 5.1 paso 2. Produce el mapa de componentes y dependencias del escenario, con las rutas reales.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Producir un mapa del sistema que sirva para decidir dónde se puede tocar sin romper
nada.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

El código está en `escenario/java/src/main/java/pe/pasarelaandina/` o en
`escenario/dotnet/LiquidacionComercios/`.

# Qué hacer

Crea `labs/cap5/lab-5-1-preparacion/entregables/mapa-del-sistema.md` con:

1. Una tabla de componentes: clase, ruta real, responsabilidad en una línea.
2. Un diagrama de dependencias en Mermaid, de quién usa a quién.
3. El recorrido de los datos, desde los archivos de `escenario/datos/` hasta la salida
   impresa.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Crea un solo archivo. No modifiques código.
- Rutas reales. Nada que no exista en el repositorio.

# Salida esperada

El documento creado.
