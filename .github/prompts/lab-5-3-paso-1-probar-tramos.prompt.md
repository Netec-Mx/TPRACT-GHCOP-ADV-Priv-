---
name: 'lab-5-3-paso-1-probar-tramos'
description: 'Lab 5.3 paso 1. Crea pruebas de la seleccion de tramo de comision, incluidos los bordes exactos'
agent: 'agent'
---

# Objetivo

Crear un archivo de pruebas nuevo que cubra la selección del tramo de comisión, incluidos
los montos que caen exactamente en el borde entre dos tramos.

Hoy esa lógica no tiene ninguna prueba.

# Contexto

El código bajo prueba:

- #file:../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraComision.cs
- #file:../../escenario/dotnet/LiquidacionComercios/Modelo/PlanComisiones.cs
- #file:../../escenario/dotnet/LiquidacionComercios/Modelo/TramoComision.cs

El estilo de pruebas que ya usa el proyecto, para que el archivo nuevo se parezca a los que
existen:

- #file:../../escenario/dotnet/LiquidacionComercios.Pruebas/Util/ValidadorFormatoPruebas.cs

Los tramos reales con los que trabaja el sistema están en la primera línea de datos de:

- #file:../../escenario/datos/planes.txt

El plan `PL01` tiene estos tramos: de 0 a 500 al 3,5 %, de 500 a 2000 al 2,9 %, de 2000 a
10000 al 2,5 % y de 10000 en adelante al 2,1 %.

Las reglas de negocio que definen cuál es el comportamiento correcto están en:

- #file:../../escenario/README.md

# Qué probar

Crea `LiquidacionComercios.Pruebas/Calculo/CalculadoraComisionPruebas.cs` con pruebas de
`DeterminarTramo` que cubran, como mínimo:

- Un monto en el interior de cada uno de los cuatro tramos.
- **Los montos que caen exactamente en el borde**: 500.00, 2000.00 y 10000.00.
- Un monto por debajo del primer tramo y uno por encima del último.
- Un plan sin tramos.

Cada prueba debe declarar en su nombre qué espera, en español, siguiendo el estilo de las
pruebas que ya existen.

# Restricciones

- **Crea un archivo nuevo. No modifiques ningún archivo existente**, ni de pruebas ni de
  producción.
- **No corrijas ningún defecto que encuentres.** Este código tiene problemas conocidos y
  son deliberados: forman parte del material del taller.
- Es probable que al probar los bordes encuentres una inconsistencia en el sistema. **No la
  arregles.** Documéntala en tu respuesta y, si quieres, como comentario dentro del archivo
  de pruebas, indicando cuál es el comportamiento correcto según las reglas de negocio.
- Las pruebas deben reflejar **lo que el código hace hoy**, no lo que debería hacer. Si algo
  te parece incorrecto, escribe la prueba que documenta el comportamiento actual y explica
  la discrepancia en tu respuesta.
- No agregues dependencias nuevas al proyecto de pruebas.

# Salida esperada

1. Un archivo nuevo en `LiquidacionComercios.Pruebas/Calculo/CalculadoraComisionPruebas.cs`,
   con el espacio de nombres que corresponde al directorio.
2. Ningún archivo existente modificado.
3. Las pruebas corren y pasan. Desde `escenario/dotnet/`:

   ```bash
   dotnet test LiquidacionComercios.Pruebas
   ```

   Deben ejecutarse las 20 pruebas que ya existían más las nuevas, todas en verde.
4. En tu respuesta, la explicación de cualquier inconsistencia que hayas encontrado al
   probar los bordes, con el comportamiento correcto según las reglas de negocio y **sin
   haberla corregido**.
