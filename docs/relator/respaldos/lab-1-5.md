> Los tiempos de este respaldo son estimados por el agente de verificación, salvo los que
> dicen «medido».

# Lab 1.5 - Salida grabada de respaldo (escenario Java)

Pasos 1 a 4 en modo Ask; paso 5 en modo Agent. Antes del laboratorio: `bash scripts/reiniciar-lab.sh lab-1-5 --si` (ya estaba en el punto de partida).

## Paso 1 - `/lab-1-5-paso-1-inventario java`

Modo: Ask

Respuesta del chat:

| Responsabilidad | Líneas | Qué datos usa | Qué efecto tiene fuera del método |
|---|---|---|---|
| Cargar los datos si el repositorio no existe | 86-90 | `repositorio`, `rutaDirectorioDatos` | Asigna el campo `repositorio` y lee cuatro archivos de disco |
| Calcular el periodo | 92-93 | `periodo`, `utilidadesFecha` | Ninguno |
| Imprimir el encabezado | 95-104 | `periodo`, fechas de inicio y fin, `ConfiguracionRegional` | Escribe en la consola |
| Seleccionar los comercios a procesar | 106-116 | Repositorio de comercios y planes, estado del comercio | Ninguno |
| Crear la liquidación del comercio | 118-126 | Datos del comercio, fecha actual | Ninguno (la liquidación es local) |
| Validar cada transacción | 132 (llama a `validarTransaccion`, 57-76) | Transacción | Modifica los contadores del objeto `transaccionesDescartadas` y `acumuladoGeneralTransado` |
| Filtrar por periodo y estado | 134-138 | Fecha y estado de la transacción | Ninguno |
| Buscar el tramo y su porcentaje | 140-162 | Plan, monto de la transacción | Ninguno |
| Calcular comisión base y recargo por cuotas | 164-180 | Monto, porcentaje, monto fijo del plan, cuotas | Ninguno |
| Armar la línea de detalle | 182-190 | Transacción, comisión | Agrega el detalle a la liquidación |
| Acumular totales del comercio y generales | 192-196 | Montos y comisiones | Modifica `acumuladoGeneralComisiones` del objeto |
| Aplicar el tope mensual | 202-205 | Total de comisiones, tope del plan | Marca `topeAplicado` en la liquidación |
| Sumar contracargos del periodo | 207-226 | Contracargos del comercio, estado, fecha | Ninguno |
| Calcular la retención de garantía | 228-244 | Fecha de afiliación, totales | Ninguno |
| Redondear y fijar los totales | 246-259 | Totales calculados | Modifica la liquidación, incluido el neto |
| Observar el registro tributario | 261-282 | Registro del comercio | Ninguno; cualquier excepción se descarta |
| Desglosar por medio de pago | 284-315 | Detalle de la liquidación | Ninguno |
| Decidir qué liquidaciones entregan resultado | 317-319 | Cantidad de transacciones | Agrega la liquidación a la lista devuelta |
| Imprimir la liquidación del comercio | 321-353 | Totales, desglose, observación | Escribe en la consola |
| Imprimir el resumen final | 358-361 | Cantidad de liquidadas, `transaccionesDescartadas` | Escribe en la consola |
| Dar formato a los montos | 323-345 (usa `formatearMonto`) | `ConfiguracionRegional` | Ninguno |

Total: 20 responsabilidades. Nivel máximo de anidamiento: 9 niveles de control dentro del método (`for` de comercios, `if` del plan, `for` de transacciones, `if` de validación, `if` del periodo, `if` de estado aprobada, `for` de tramos, `if` de tramo no encontrado y `if` del rango de montos); el punto más profundo es la línea 151.

Otros problemas vistos y no tocados: `double` para dinero, números sueltos repetidos, `Date`/`Calendar`, `catch` vacío (líneas 281-282) y el hecho de que `procesarLiquidacionCompleta` calcula e imprime a la vez.

Tiempo: 15 s (estimado)

## Paso 2 - `/lab-1-5-paso-2-rastrear-lineas-invalidas java`

Modo: Ask

Respuesta del chat:

| Archivo y línea | Qué puede fallar | Qué hace el código | Queda rastro en la salida |
|---|---|---|---|
| `CargadorDatos.java` 41, 78, 108, 140 (apertura del archivo) | El archivo no existe o no se puede leer | Captura `IOException` e imprime "No se pudo leer el archivo de ..." | Sí, un mensaje en consola por archivo |
| `CargadorDatos.java` 42, 79, 109, 141 (línea de encabezado) | Archivo vacío | `readLine()` devuelve `null` y el ciclo no corre | No |
| `CargadorDatos.java` 47-66 (planes) | Faltan campos, números mal escritos, tramos mal formados | `catch (Exception e)` vacío: la línea se omite | No |
| `CargadorDatos.java` 84-96 (comercios) | Faltan campos, categoría o estado que no existen en el enum, fecha ilegible | `catch (Exception e)` vacío: la línea se omite. Una fecha ilegible no lanza excepción, porque `parsearFecha` devuelve `null` y el comercio se carga sin fecha | No |
| `CargadorDatos.java` 114-128, línea 119 (monto) | Monto que no es número (`NumberFormatException`) | `catch (Exception e)` vacío: la transacción no se agrega al repositorio | No |
| `CargadorDatos.java` 114-128, línea 121 (fecha y hora) | Fecha mal formada | `parsearFechaHora` devuelve `null`, la transacción se agrega con fecha nula y luego `validarTransaccion` la cuenta como descartada | Parcial: suma uno a "Transacciones descartadas" |
| `CargadorDatos.java` 122, 123, 124 (medio de pago, cuotas, estado) | Valor que no existe en el enum o cuotas no numéricas | `catch (Exception e)` vacío: la transacción no se agrega | No |
| `CargadorDatos.java` 115-125 (campos) | Menos de 9 campos | `ArrayIndexOutOfBoundsException` capturada por el `catch` vacío: se omite la línea | No |
| `CargadorDatos.java` 146-157 (contracargos) | Monto, motivo o estado inválidos; menos campos | `catch (Exception e)` vacío: se omite la línea. Una fecha ilegible da `null` y el contracargo se agrega sin fecha | No |
| `CalculadoraLiquidacion.java` 57-76 (`validarTransaccion`) | Transacción con fecha nula, moneda distinta de `PEN` o monto menor o igual a cero | Cuenta la transacción como descartada y sigue | Solo el total "Transacciones descartadas" del resumen final, sin decir cuál ni por qué |
| `CalculadoraLiquidacion.java` 213-217 (contracargos) | Contracargo con fecha nula | Se ignora sin avisar | No |

Respuesta de una línea: si llegan diez líneas corruptas, el equipo no se entera en casi ningún caso, porque la lectura las descarta en silencio y solo las que llegan con fecha, moneda o monto inválidos suben el contador "Transacciones descartadas".

Otros problemas vistos y no tocados: los `catch` vacíos son cinco bloques en `CargadorDatos` y uno en `CalculadoraLiquidacion`; el contador de descartadas incluye transacciones de todos los periodos, no solo las del periodo liquidado.

Tiempo: 16 s (estimado)

## Paso 3 - `/lab-1-5-paso-3-contrastar-nombres java`

Modo: Ask

Respuesta del chat:

| Método | Qué promete el nombre | Qué hace | Consecuencia observable |
|---|---|---|---|
| `Liquidacion.obtenerMontoNeto` (`Liquidacion.java` 87-90) | Una consulta: devuelve el monto neto | Calcula `totalTransado - totalComisiones - totalContracargos - retenciones`, **guarda el resultado en el campo `montoNeto`** y lo devuelve. Es una consulta que además muta | `CalculadoraLiquidacion` lo llama en la línea 257 y vuelve a fijar `montoNeto` redondeado con `setMontoNeto`. `FormateadorReporte` (línea 33) lo llama otra vez y, sin redondear, reemplaza el neto redondeado por el valor sin redondear. Cualquier lectura posterior del neto depende de quién lo llamó último |
| `RepositorioMemoria.buscarComerciosActivos` (`RepositorioMemoria.java` 56-62) | Los comercios con estado ACTIVO | Copia **todos** los comercios, sin filtrar por estado | Se procesan también comercios suspendidos. En `comercios.txt`, CM0031 está `SUSPENDIDO` y entra al ciclo de liquidación. CM0036, que está `DE_BAJA`, entra a la lista pero el método de cálculo lo descarta en la línea 110 |
| `CalculadoraLiquidacion.validarTransaccion` (57-76) | Una validación que responde sí o no | Valida, pero también incrementa `transaccionesDescartadas` cuando falla y suma el monto a `acumuladoGeneralTransado` cuando pasa. Esto ocurre para todas las transacciones del comercio, sin importar el periodo | El resumen "Transacciones descartadas" y `getAcumuladoGeneralTransado` incluyen transacciones fuera del periodo. Llamarlo dos veces con la misma transacción duplica el acumulado |

Otros problemas vistos y no tocados: la regla 5 y la regla 6 de `escenario/README.md` no mencionan comercios suspendidos, así que no puedo decir si liquidar a CM0031 es correcto; el método de cálculo usa `getEstado() == DE_BAJA` como único filtro.

Tiempo: 13 s (estimado)

## Paso 4 - `/lab-1-5-paso-4-proponer-mejora java`

Modo: Ask

Respuesta del chat:

1. **Bloque.** Líneas 284-315 de `CalculadoraLiquidacion.java`: el desglose por medio de pago (31 líneas, un solo bloque).

2. **Cambio.** Reemplazar los `if/else` anidados por una estructura plana (`else if` o `switch` sobre el nombre del medio) manteniendo exactamente los mismos acumuladores y el mismo caso por omisión: lo que no sea crédito, débito o billetera se suma a transferencia. El conteo de transacciones en cuotas se conserva solo para crédito.

3. **Por qué este.** Es la zona con más niveles de `else` anidados del método sin tocar la regla de negocio, no mueve el orden de las sumas de `double` de las comisiones y cabe en una revisión de diez minutos. Otros bloques, como el cálculo de la comisión, tocan reglas 1 a 3 del `README` y piden más cuidado.

4. **Qué podría salir mal.** Que un medio de pago con medio nulo o desconocido pase de transferencia a otro grupo. Se detecta con `bash scripts/comparar-escenarios.sh`, que compara la salida de Java con la de .NET, y comparando la salida del periodo 2026-06 antes y después del cambio. Si el desglose cambia en algún comercio, la comparación falla.

Otras mejoras vistas y no propuestas:
- Extraer la búsqueda del tramo (líneas 144-162).
- Extraer el cálculo de la retención (líneas 228-244).
- Separar la impresión por consola (líneas 317-354).
- Reemplazar el `catch` vacío de las líneas 281-282.

Tiempo: 10 s (estimado)

## Paso 5 - `/lab-1-5-paso-5-extraer-retencion java`

Modo: Agent

Comandos que el agente pidió aprobar en la terminal y que se ejecutaron:

1. `mvn -q clean package` (desde `escenario/java/`), antes y después del cambio. En esta grabación se usó `mvn -q -o clean package`, porque la máquina no tiene red. Compila sin errores.
2. `java -jar target/liquidacion-comercios.jar`, antes y después, comparando las dos salidas con `diff`: idénticas (554 líneas).
3. `bash scripts/comparar-escenarios.sh`: **no pudo completar en esta máquina de grabación.** La compilación del escenario .NET falla con `NETSDK1045: The current .NET SDK does not support targeting .NET 10.0` (hay instalado el SDK 8.0.401). Esto es un límite del ambiente de grabación, no del cambio. En la máquina de clase, con .NET 10, debe terminar en cero porque el cambio solo mueve código en Java.

Archivos modificados (`git status --short`):

```
 M escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
```

Respuesta final del chat:

Extraje el cálculo de la retención de garantía a un método privado nuevo, `calcularRetencionGarantia(Comercio comercio, Date inicioPeriodo, double totalTransado, double totalComisiones, double totalContracargos)`, en `CalculadoraLiquidacion.java`. El método devuelve el monto de la retención con la misma lógica de antes (regla 7 de `escenario/README.md`: menos de seis meses de afiliación, base positiva, 5 %). En `procesarLiquidacionCompleta` quedó `double retenciones = calcularRetencionGarantia(...)` en lugar del bloque, justo antes del redondeo de los totales.

Verificación:
- `mvn -q clean package` termina sin errores.
- La salida de `java -jar target/liquidacion-comercios.jar` es idéntica antes y después del cambio (comparada con `diff`).
- `bash scripts/comparar-escenarios.sh` no pude cerrarlo en este equipo: el SDK de .NET instalado es el 8 y el proyecto apunta a .NET 10, de modo que la parte .NET no compila. Hay que correrlo en una máquina con .NET 10.
- Solo se modificó un archivo.

Otros problemas que vi y no toqué:
- Dinero en `double` en toda la clase.
- Números sueltos (`0.05`, `6`, `100.0`) que ahora quedaron también dentro del método nuevo, tal como estaban.
- Uso de `Date` y `Calendar`.
- `catch (Exception e)` vacío en las líneas del registro tributario.
- `buscarComerciosActivos` devuelve también comercios suspendidos.
- `validarTransaccion` modifica contadores de la clase.
- `obtenerMontoNeto` consulta y además guarda el resultado en el objeto.

Tiempo: 28 s (medido, incluye compilación y comparación de salidas)

`git diff`:

```diff
diff --git a/escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java b/escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
index 45e65aa..741e534 100644
--- a/escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
+++ b/escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
@@ -225,23 +225,8 @@ public class CalculadoraLiquidacion {
                     }
                 }
 
-                double retenciones = 0.0;
-
-                Date fechaAfiliacion = comercio.getFechaAfiliacion();
-
-                if (fechaAfiliacion != null) {
-
-                    int meses = utilidadesFecha.mesesEntre(fechaAfiliacion, inicioPeriodo);
-
-                    if (meses < 6) {
-
-                        double baseRetencion = totalTransado - totalComisiones - totalContracargos;
-
-                        if (baseRetencion > 0) {
-                            retenciones = baseRetencion * 0.05;
-                        }
-                    }
-                }
+                double retenciones = calcularRetencionGarantia(comercio, inicioPeriodo,
+                        totalTransado, totalComisiones, totalContracargos);
 
                 totalTransado = Math.round(totalTransado * 100.0) / 100.0;
                 totalComisiones = Math.round(totalComisiones * 100.0) / 100.0;
@@ -363,6 +348,33 @@ public class CalculadoraLiquidacion {
         return resultado;
     }
 
+    /**
+     * Calcula la retencion de garantia de un comercio con menos de seis meses de afiliacion.
+     */
+    private double calcularRetencionGarantia(Comercio comercio, Date inicioPeriodo,
+            double totalTransado, double totalComisiones, double totalContracargos) {
+
+        double retenciones = 0.0;
+
+        Date fechaAfiliacion = comercio.getFechaAfiliacion();
+
+        if (fechaAfiliacion != null) {
+
+            int meses = utilidadesFecha.mesesEntre(fechaAfiliacion, inicioPeriodo);
+
+            if (meses < 6) {
+
+                double baseRetencion = totalTransado - totalComisiones - totalContracargos;
+
+                if (baseRetencion > 0) {
+                    retenciones = baseRetencion * 0.05;
+                }
+            }
+        }
+
+        return retenciones;
+    }
+
     private String formatearMonto(double monto) {
         return String.format(ConfiguracionRegional.REGION_DE_SALIDA, "%.2f", monto);
     }
```


## Comparador del paso 5, ejecución real

En la ejecución de verificación de este respaldo, la máquina no tenía el SDK de .NET 10 y el
comparador no llegó a correr. Esta es la salida real de `bash scripts/comparar-escenarios.sh`
con la solución de referencia del paso 5 aplicada sobre una copia limpia, con .NET 10.

```
Comparacion de escenarios, taller de GitHub Copilot
Script version 1.0.0
Periodo: 2026-06
Repositorio: /private/tmp/claude-501/-Users-rodrigosilva-GITHUB-COPILOT-github-copilot-netec/6e2f2b1e-040c-4c7f-bc41-827f7128af25/scratchpad/s11/v15

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
```
