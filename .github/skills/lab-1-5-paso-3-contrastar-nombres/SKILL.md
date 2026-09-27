---
name: lab-1-5-paso-3-contrastar-nombres
description: 'Lab 1.5 paso 3. Contrasta el nombre de tres métodos con lo que hacen de verdad.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Verificar si el nombre de tres métodos describe lo que hacen.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

| Método | Java | .NET |
|---|---|---|
| Obtener el monto neto | [Liquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/modelo/Liquidacion.java), `obtenerMontoNeto` | [Liquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Modelo/Liquidacion.cs), `ObtenerMontoNeto` |
| Buscar los comercios activos | [RepositorioMemoria.java](../../../escenario/java/src/main/java/pe/pasarelaandina/repositorio/RepositorioMemoria.java), `buscarComerciosActivos` | [RepositorioMemoria.cs](../../../escenario/dotnet/LiquidacionComercios/Repositorio/RepositorioMemoria.cs), `BuscarComerciosActivos` |
| Validar una transacción | [CalculadoraLiquidacion.java](../../../escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java), `validarTransaccion` | [CalculadoraLiquidacion.cs](../../../escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs), `ValidarTransaccion` |

# Qué hacer

Para cada método, lee su cuerpo completo y todos los lugares donde se llama. Compara lo
que promete el nombre con lo que hace, incluido cualquier efecto sobre el estado del
objeto o de la clase. Si una diferencia tiene consecuencias en la liquidación, búscala
en los datos de [comercios.txt](../../../escenario/datos/comercios.txt) y dila.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No renombres nada ni modifiques ningún archivo. Responde en el chat.

# Salida esperada

| Método | Qué promete el nombre | Qué hace | Consecuencia observable |
|---|---|---|---|
