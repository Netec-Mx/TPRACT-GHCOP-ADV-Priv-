> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes, escenario .NET. Se grabó en la CLI, no en Visual Studio Code: el modo Ask se
> reprodujo con una sesión sin permiso de edición. Los comandos que pidió el agente se
> aprobaron según la guía de prueba humana. La ruta del repositorio en la máquina se abrevia
> `<repo>`. Los segundos son de trabajo del agente, sin la lectura del participante.

# Lab 1.5 - Salida grabada de respaldo (escenario .NET)

Pasos 1 a 4 en modo Ask; paso 5 en modo Agent. Antes del laboratorio:
`bash scripts/reiniciar-lab.sh lab-1-5 --confirmar`, que respondió «Ya esta en el punto de
partida. No hay nada que descartar.»

## Paso 1 - `/lab-1-5-paso-1-inventario dotnet`

Escrito: `/lab-1-5-paso-1-inventario dotnet`

Modo: Ask. Segundos de trabajo del agente: 17.

Archivos leídos: `escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs`.
Búsquedas: 1.

Respuesta del chat:

Inventario de `ProcesarLiquidacionCompleta` (.NET, líneas 79–373).

| Responsabilidad | Líneas | Qué datos usa | Qué efecto tiene fuera del método |
|---|---|---|---|
| 1. Carga perezosa de datos | 83–89 | `repositorio`, `rutaDirectorioDatos` | Asigna el campo `repositorio` y lee archivos del disco |
| 2. Calcular rango del periodo | 91–92 | `periodo`, `utilidadesFecha` | Ninguno |
| 3. Imprimir encabezado | 94–101 | `periodo`, inicio y fin | Escribe en consola |
| 4. Seleccionar comercios (activos, excluye DE_BAJA) y su plan | 103–115 | Repositorio, `Estado`, `IdPlanComisiones` | Ninguno; omite comercios sin plan |
| 5. Crear y poblar la cabecera de la liquidación | 117–122 | Comercio, periodo, `DateTime.Now` | Ninguno; depende del reloj |
| 6. Validar y filtrar transacciones (nulas, sin fecha, no PEN, monto ≤ 0) | 128–131 (+ `ValidarTransaccion`, 47–67) | Transacción | Incrementa `transaccionesDescartadas` y `acumuladoGeneralTransado` |
| 7. Filtrar por periodo y estado APROBADA | 133–138 | Fecha, estado, rango | Ninguno |
| 8. Buscar el tramo y su porcentaje (con fallback al último tramo) | 140–166 | Monto, `plan.Tramos` | Ninguno |
| 9. Calcular comisión base, monto fijo y recargo por cuotas (tope 3 %) | 168–185 | Monto, porcentaje, `MontoFijoPorTransaccion`, cuotas | Ninguno |
| 10. Construir las líneas de detalle | 187–196 | Transacción, comisiones | Agrega detalle a la liquidación |
| 11. Acumular totales por comercio y generales | 198–202 | Montos, comisiones | Modifica `acumuladoGeneralComisiones` |
| 12. Aplicar el tope mensual | 206–210 | `totalComisiones`, `TopeMensual` | Marca `TopeAplicado` |
| 13. Sumar contracargos aprobados del periodo | 212–232 | Contracargos, estado, fecha, rango | Ninguno |
| 14. Calcular retenciones (afiliación < 6 meses, 5 %) | 234–251 | `FechaAfiliacion`, `MesesEntre`, totales | Ninguno |
| 15. Redondear y asignar totales, calcular el neto | 253–268 | Totales, `CompatibilidadJava` | Escribe totales y neto en la liquidación |
| 16. Validar el registro tributario | 270–296 | `RegistroTributario` (largo y prefijo) | Ninguno; el `catch` vacío traga excepciones |
| 17. Desglosar por medio de pago | 298–336 | Líneas de detalle, medio de pago, cuotas | Ninguno |
| 18. Agregar al resultado (solo con transacciones) | 338–340 | `cantidadTransacciones` | Agrega a la lista devuelta |
| 19. Imprimir el detalle del comercio y el desglose | 341–374 | Totales, desglose, observación, `FormatearMonto` | Escribe en consola |
| 20. Imprimir el pie y devolver el resultado | 378–384 | Contador, descartadas | Escribe en consola |

**Total: 20 responsabilidades.**

**Anidamiento máximo: 11 niveles**, desde el método hasta el cuerpo del `if (montoTransaccion >= …)` dentro de los bucles de tramos. La cadena es `foreach comercio` → `if plan` → `foreach transacción` → `if Validar` → `if periodo` → `if APROBADA` → `foreach tramo` → `if !tramoEncontrado` → `if monto`.

**Observaciones, sin tocar nada:**
- `ValidarTransaccion` acumula estadísticas dentro de una validación (efecto lateral).
- El estado acumulado se mantiene entre llamadas.
- El `catch (Exception)` está vacío.
- Hay literales sueltos: 0.05, 6, 3.0, 0.5 y los prefijos de registro.
- Se usa `double` para montos.
- `transaccionesDescartadas` y `acumuladoGeneralTransado` cuentan transacciones de todos los periodos, porque la validación ocurre antes del filtro por periodo.

Las líneas son aproximadas. No modifiqué ningún archivo.

## Paso 2 - `/lab-1-5-paso-2-rastrear-lineas-invalidas dotnet`

Escrito: `/lab-1-5-paso-2-rastrear-lineas-invalidas dotnet`

Modo: Ask. Segundos de trabajo del agente: 17.

Archivos leídos: `escenario/dotnet/LiquidacionComercios/Repositorio/CargadorDatos.cs`.
Búsquedas: 2.

Mensaje durante el trabajo: «Necesito los parsers para saber si devuelven valores por defecto sin lanzar excepción.»

Respuesta del chat:

Rastro de una línea mal formada en `transacciones.txt` (.NET). Los números de línea son aproximados.

| Archivo y línea | Qué puede fallar | Qué hace el código | Queda rastro en la salida |
|---|---|---|---|
| `CargadorDatos.cs` 123 (`transacciones.txt`) | El archivo no existe o no se puede leer (`IOException`) | Imprime «No se pudo leer el archivo de transacciones» y sigue sin transacciones | Sí, un mensaje |
| `CargadorDatos.cs` 127 | La primera línea | Se descarta como encabezado sin validarla | No |
| `CargadorDatos.cs` 128–131 | Línea vacía | Se omite con `continue` | No |
| `CargadorDatos.cs` 137–145 | Pocos campos (`campos[n]` fuera de rango) | `IndexOutOfRangeException` capturada por el `catch (Exception)` vacío (150). La línea se pierde, y también las asignaciones previas | No |
| `CargadorDatos.cs` 139 (`LeerDecimal`, monto) | Monto que no es número | `double.Parse` lanza `FormatException`. El `catch` vacío descarta la línea completa | No |
| `CargadorDatos.cs` 141 (`ParsearFechaHora`) | Fecha mal formada | `TryParseExact` falla y devuelve `DateTime.MinValue`, sin excepción. La línea entra al repositorio | Solo indirecto: `ValidarTransaccion` la descarta y suma 1 a «Transacciones descartadas» |
| `CargadorDatos.cs` 142 y 144 (`Enum.Parse`, medio de pago o estado) | Valor que no pertenece al enum | Lanza excepción. El `catch` vacío descarta la línea | No |
| `CargadorDatos.cs` 143 (`LeerEntero`, cuotas) | Cuotas no numéricas | Lanza `FormatException`. El `catch` vacío descarta la línea | No |
| `CargadorDatos.cs` 140 (moneda) | Moneda distinta de PEN, nula o vacía | Se carga. `ValidarTransaccion` la descarta | Solo el contador agregado |
| `CalculadoraLiquidacion.cs` 47–67 (`ValidarTransaccion`) | Fecha mínima, moneda ≠ PEN, monto ≤ 0 | Incrementa `transaccionesDescartadas` y devuelve false | Solo el total en la línea final «Transacciones descartadas: N» |
| `CalculadoraLiquidacion.cs` 128–138 | Transacción con `IdComercio` inexistente, fuera de periodo o no APROBADA | Nunca se consulta o se ignora en silencio | No |

Los otros tres archivos (`planes.txt`, `comercios.txt`, `contracargos.txt`) tienen el mismo patrón: el `catch (Exception)` vacío descarta la línea sin dejar rastro.

**Si mañana llega un archivo con diez líneas corruptas, ¿cómo se entera el equipo?** No se entera por sí solo. Las líneas con monto, cuotas o enums inválidos desaparecen sin aviso. Solo las líneas con fecha inválida, moneda distinta o monto ≤ 0 incrementan el contador agregado, sin indicar cuáles son.

**Observaciones, sin tocar nada:**
- Las excepciones se tragan en los cuatro cargadores.
- El mensaje de `IOException` es el único aviso de la carga.
- Una fecha inválida produce `MinValue` en vez de un error.
- Si el monto es ≤ 0 o la moneda no es PEN, el contador de descartadas mezcla causas distintas.

No modifiqué ningún archivo.

## Paso 3 - `/lab-1-5-paso-3-contrastar-nombres dotnet`

Escrito: `/lab-1-5-paso-3-contrastar-nombres dotnet`

Modo: Ask. Segundos de trabajo del agente: 12.

Archivos leídos: `escenario/datos/comercios.txt`.
Búsquedas: 2.

Respuesta del chat:

| Método | Qué promete el nombre | Qué hace | Consecuencia observable |
|---|---|---|---|
| `ObtenerMontoNeto` (`Liquidacion.cs` 32–36) | Un getter sin efectos que devuelve el neto ya guardado | Recalcula `TotalTransado - TotalComisiones - TotalContracargos - Retenciones`, **sobrescribe** el campo `montoNeto` y lo devuelve | Es un setter disfrazado de getter. En `CalculadoraLiquidacion.cs` 257–259 se llama tras redondear los totales. Luego el neto se redondea y se restablece con `EstablecerMontoNeto`. En `FormateadorReporte.cs` 36 una simple lectura vuelve a recalcular y a pisar el neto redondeado con el valor sin redondear. El monto del reporte puede diferir en centésimas del impreso por consola, y depende del orden de las llamadas. |
| `BuscarComerciosActivos` (`RepositorioMemoria.cs` 48–56) | Devolver solo comercios con estado ACTIVO | No filtra: copia **todos** los comercios, sea cual sea su estado | En `comercios.txt` hay un `SUSPENDIDO` (CM0031) y un `DE_BAJA` (CM0036). El método devuelve ambos. El filtro real lo hace después `ProcesarLiquidacionCompleta` (líneas 107–110), pero solo excluye `DE_BAJA`. **CM0031 (SUSPENDIDO) se liquida igual** si tiene transacciones aprobadas del periodo. |
| `ValidarTransaccion` (`CalculadoraLiquidacion.cs` 49–68) | Una consulta pura que responde si la transacción es válida | Devuelve el booleano, pero también incrementa `transaccionesDescartadas` y suma el monto a `acumuladoGeneralTransado` | El estado de la instancia cambia en cada llamada. Los acumulados incluyen transacciones de **cualquier periodo** y de cualquier estado, porque la validación ocurre antes del filtro por periodo y por APROBADA. Llamar al proceso dos veces con la misma instancia duplica los acumulados y las descartadas. Las propiedades públicas `AcumuladoGeneralTransado` y `TransaccionesDescartadas` quedan sobreestimadas. |

**Observaciones, sin tocar nada:**
- En la regla de negocio de `escenario/README.md` podría estar definido qué comercios se liquidan. No lo contrasté en este paso, así que conviene confirmar si un comercio SUSPENDIDO debe liquidarse.
- `acumuladoGeneralComisiones` se acumula antes de aplicar el tope mensual.

No modifiqué ningún archivo.

## Paso 4 - `/lab-1-5-paso-4-proponer-mejora dotnet`

Escrito: `/lab-1-5-paso-4-proponer-mejora dotnet`

Modo: Ask. Segundos de trabajo del agente: 8.

Respuesta del chat:

**1. Bloque:** la búsqueda del tramo de comisión, `CalculadoraLiquidacion.cs` líneas 140–166 (27 líneas). Va desde `double montoTransaccion` hasta el `if (!tramoEncontrado)` con el fallback.

**2. Cambio:** extraer ese bloque a un método privado `ObtenerPorcentajeTramo(PlanComisiones plan, double monto)`. Conserva literalmente la lógica: recorrer los tramos con `>= MontoDesde` y `< MontoHasta`, y usar el último tramo si ninguno coincide. En el método principal queda `double porcentajeAplicado = ObtenerPorcentajeTramo(plan, montoTransaccion);`. Esto además quita tres niveles de anidamiento, de 11 a 8.

**3. Por qué este y no otro:**
- Es una responsabilidad pura: no escribe en consola, no toca campos y no depende del reloj. Por eso extraerla no puede alterar la salida.
- Es el bloque más profundo (la 8 del inventario del paso 1).
- Representa la regla de negocio de los tramos de comisión.
- Los candidatos que sí tienen efectos (`ValidarTransaccion`, el desglose por medio de pago o la impresión) exigen decisiones sobre estado o formato.
- El cambio es mecánico y se revisa en diez minutos.

**4. Qué podría salir mal y cómo se detecta:**
- Cambiar sin querer `<` por `<=`, o el orden de los tramos, desplaza la comisión de los montos que caen justo en un límite. Los montos en el borde de un tramo cambiarían de porcentaje.
- Si el plan no tiene tramos, el porcentaje debe seguir siendo 0.0.
- Se detecta con `bash scripts/comparar-escenarios.sh`, que compara la salida de ambos escenarios. Como Java no cambia, el script solo detecta la divergencia si .NET se aparta. Conviene además guardar antes la salida .NET en un archivo temporal fuera del repositorio y compararla después con `diff`.
- Por la regla de equivalencia, quien aplique esto debería evaluar si el método equivalente en Java también debe extraerse. No lo propongo aquí.

**Otras mejoras vistas, una línea cada una, sin tocar:**
- Extraer el desglose por medio de pago (298–336) a un método.
- Extraer la validación del registro tributario (270–296).
- Extraer la suma de contracargos aprobados del periodo (212–232).
- El `catch (Exception)` vacío del registro tributario (y los de `CargadorDatos`) oculta errores.
- `ValidarTransaccion` tiene efectos laterales sobre los acumulados.

No modifiqué ningún archivo.

## Paso 5 - `/lab-1-5-paso-5-extraer-retencion dotnet`

Escrito: `/lab-1-5-paso-5-extraer-retencion dotnet`

Modo: Agent. Segundos de trabajo del agente: 60.

Archivos leídos: `.github/instructions/dotnet.instructions.md`, `escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs`.
Búsquedas: 1.
Archivos escritos: `escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs`.
Comandos, todos con aprobación: `$t=$env:TEMP; & "C:\Program Files\Git\bin\bash.exe" -c "cd <repo> && bash scripts/comparar-escen`; `$t=$env:TEMP; cd escenario\dotnet; dotnet build LiquidacionComercios -c Release 2>&1 | Select-Object -Last 6; cd ..\..; & "C:\Program Files\`.

Mensaje durante el trabajo: «Línea base OK. Ahora aplico la extracción.»

Respuesta del chat:

Extraje el cálculo a `CalcularRetencionGarantia`, un método privado en `CalculadoraLiquidacion.cs`. Es el único archivo modificado.

- **Compilación:** `dotnet build LiquidacionComercios -c Release` terminó con 0 advertencias y 0 errores.
- **Equivalencia:** `bash scripts/comparar-escenarios.sh` terminó en cero, con salidas idénticas (554 líneas, 20457 bytes), igual que antes del cambio.
- **No ejecuté:** `dotnet test`, porque el paso no lo pedía.
- **Archivos temporales:** guardé la salida de antes y de después en la carpeta temporal del sistema (`antes.txt`, `despues.txt`), fuera del repositorio.

#### Diff

```diff
diff --git a/escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs b/escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs
index 3a3c1a7..e998a95 100644
--- a/escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs
+++ b/escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs
@@ -224,24 +224,8 @@ namespace Pe.PasarelaAndina.Calculo
                         }
                     }
 
-                    double retenciones = 0.0;
-
-                    DateTime fechaAfiliacion = comercio.FechaAfiliacion;
-
-                    if (fechaAfiliacion != DateTime.MinValue)
-                    {
-                        int meses = utilidadesFecha.MesesEntre(fechaAfiliacion, inicioPeriodo);
-
-                        if (meses < 6)
-                        {
-                            double baseRetencion = totalTransado - totalComisiones - totalContracargos;
-
-                            if (baseRetencion > 0)
-                            {
-                                retenciones = baseRetencion * 0.05;
-                            }
-                        }
-                    }
+                    double retenciones = CalcularRetencionGarantia(comercio, inicioPeriodo,
+                            totalTransado, totalComisiones, totalContracargos);
 
                     totalTransado = CompatibilidadJava.RedondearADosDecimales(totalTransado);
                     totalComisiones = CompatibilidadJava.RedondearADosDecimales(totalComisiones);
@@ -380,6 +364,34 @@ namespace Pe.PasarelaAndina.Calculo
             return resultado;
         }
 
+        /// <summary>
+        /// Calcula la retencion de garantia de un comercio con menos de seis meses de afiliacion.
+        /// </summary>
+        private double CalcularRetencionGarantia(Comercio comercio, DateTime inicioPeriodo,
+                double totalTransado, double totalComisiones, double totalContracargos)
+        {
+            double retenciones = 0.0;
+
+            DateTime fechaAfiliacion = comercio.FechaAfiliacion;
+
+            if (fechaAfiliacion != DateTime.MinValue)
+            {
+                int meses = utilidadesFecha.MesesEntre(fechaAfiliacion, inicioPeriodo);
+
+                if (meses < 6)
+                {
+                    double baseRetencion = totalTransado - totalComisiones - totalContracargos;
+
+                    if (baseRetencion > 0)
+                    {
+                        retenciones = baseRetencion * 0.05;
+                    }
+                }
+            }
+
+            return retenciones;
+        }
+
         private string FormatearMonto(double monto)
         {
             return CompatibilidadJava.FormatearDosDecimales(monto);
```

#### Otros problemas vistos y no tocados

- **Regla 7 del README:** pide una retención del 5 % «sobre el monto neto». El código la calcula sobre transado − comisiones − contracargos, es decir, el neto antes de retenciones. Es coherente, pero conviene confirmarlo.
- **`ValidarTransaccion`:** tiene efectos laterales sobre los acumulados.
- **`BuscarComerciosActivos`:** no filtra por estado, y el SUSPENDIDO CM0031 se liquida.
- **`ObtenerMontoNeto`:** pisa el campo `montoNeto`.
- **`catch (Exception)` vacíos:** hay uno en el registro tributario y varios en `CargadorDatos`.
- **Literales sueltos:** 0.05, 6 y otros, con montos en `double`.
- **Escenario Java:** no lo toqué, por lo que su método sigue sin extraer.

Propongo el commit, sin ejecutarlo: `refactor(dotnet): extraer calculo de retencion de garantia a metodo privado`.

## Verificación del paso 5, ejecución real

```
$ git status --short
 M escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs
$ git diff --stat
 .../Calculo/CalculadoraLiquidacion.cs              | 48 ++++++++++++++--------
 1 file changed, 30 insertions(+), 18 deletions(-)
$ bash scripts/comparar-escenarios.sh
Comparacion de escenarios, taller de GitHub Copilot
Script version 1.1.0
Periodo: 2026-06
Repositorio: <repo>

== Requisitos ==
  [ OK ] JDK disponible
  [ OK ] Apache Maven disponible
  [ OK ] SDK de .NET disponible
  [ OK ] diff disponible
  [ OK ] java encontrado
  [ OK ] dotnet encontrado
  [ OK ] datos encontrado

== Compilacion ==
  [ OK ] Escenario Java compilado
  [ OK ] Escenario .NET compilado

== Ejecucion ==
  [ OK ] Escenario Java ejecutado (554 lineas)
  [ OK ] Escenario .NET ejecutado (554 lineas)

== Comparacion ==
  [ OK ] Las salidas son identicas
       554 lineas, 20457 bytes

== Resumen ==
  Escenarios equivalentes. Java y .NET producen la misma salida para 2026-06.
(exit 0)
```

Al cerrar, `bash scripts/reiniciar-lab.sh lab-1-5 --confirmar` dejó el árbol limpio.

## Esperado contra observado

- Paso 1: esperado una tabla de responsabilidades con líneas, su cantidad y el anidamiento.
  Observado 20 responsabilidades, con todas las que no pueden faltar. Dice 11 niveles de
  anidamiento, pero la cadena que muestra tiene nueve: es la cifra del material.
- Paso 2: esperado los `catch` vacíos del cargador. Observado igual, con el aviso de que una
  línea corrupta desaparece sin rastro.
- Paso 3: esperado `ObtenerMontoNeto` recalcula y asigna, `BuscarComerciosActivos` devuelve
  suspendidos, `ValidarTransaccion` acumula, y CM0031 suspendido se liquida. Observado igual.
  No preguntó si un comercio suspendido se liquida: lo dejó como observación.
- Paso 4: esperado una sola propuesta en cuatro puntos. Observado igual, la extracción de la
  búsqueda del tramo.
- Paso 5: esperado el diff completo y el comparador en cero. Observado igual: un método
  privado `CalcularRetencionGarantia`, la llamada en su lugar, ningún tipo cambiado, ningún
  número convertido en constante, un solo archivo modificado.
