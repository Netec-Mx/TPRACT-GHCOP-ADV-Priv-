> Los tiempos de este respaldo son de reloj del agente de verificación y no incluyen la
> lectura de la sala.

# Lab 5.2 - Refactorización y validación incremental (Java)

Reinicio previo: `bash scripts/reiniciar-lab.sh lab-5-2 --si` (ya estaba en el punto de partida).
Aviso de ejecución: los tiempos son segundos de reloj de esta corrida simulada.

## Paso 1 - `/lab-5-2-paso-1-plan-incremental java` (modo Ask)

Segundos: 14 s de lectura y análisis (la redacción de la respuesta no se cronometró por separado) (solo lectura, sin modificar archivos; incluye la lectura de las dos calculadoras, `PlanComisiones`, `UtilidadesFecha`, `Liquidacion` y `escenario/README.md`)

### Respuesta del chat (verbatim)

Escenario: Java. No modifiqué ningún archivo.

**1. Valores de negocio escritos como literal**

Archivos: `CalculadoraLiquidacion.java` (CL) y `CalculadoraComision.java` (CC), en `escenario/java/src/main/java/pe/pasarelaandina/calculo/`.

| Valor | Dónde aparece | Regla de `escenario/README.md` | Observación |
|---|---|---|---|
| Recargo por cuota: 0,5 puntos por cada cuota sobre la primera | CL línea 171 (`(transaccion.getCuotas() - 1) * 0.5`); CC línea 52 (`(cuotas - 1) * 0.5`) | Regla 3: 0,5 % adicional por cada cuota sobre la primera | Coincide en las dos. Escrito dos veces. |
| Condición de cuotas `> 1` | CL línea 169; CC línea 49 (`<= 1`) | Regla 3 | Equivalentes. |
| Máximo del recargo | CL línea 173-174: `3.0`. CC línea 53-54: `3.5` | Regla 3: máximo de 3 % | **No coinciden.** CL cumple la regla (3,0). CC no (3,5). |
| Divisor porcentual `100.0` | CL líneas 164, 177; CC líneas 39, 56 | (convención de porcentaje) | Repetido en ambas. |
| Retención de garantía: `0.05` | CL línea 241 (`baseRetencion * 0.05`). No aparece en CC | Regla 7: 5 % sobre el monto neto | Solo en CL. Ver nota abajo sobre la base. |
| Antigüedad para la retención: `6` meses | CL línea 236 (`meses < 6`) | Regla 7: menos de seis meses de afiliación | Solo en CL. |
| Redondeo a dos decimales: `100.0` con `Math.round` | CL líneas 246-249 y 258; CC línea 72 (`redondear`) | Regla 9: dos decimales, medio hacia arriba | Duplicado en las dos clases. |
| Moneda `"PEN"` | CL línea 66 | Todos los montos en soles | Solo en CL. |
| Largo del registro tributario `11` y prefijos `"10"`, `"20"`, `"15"`, `"17"` | CL líneas 268-273 | No definido en las reglas de negocio | No es una regla de comisión, pero es literal de negocio dentro del mismo método. |
| Límite de tramo: `>= montoDesde && < montoHasta` | CL líneas 148-149; CC línea 23 usa `<= montoHasta` | Regla 1 y 2 (no define si el borde superior es inclusivo) | **No coinciden** en el borde: un monto igual al `montoHasta` cae en un tramo en CL y en el siguiente en CC. |
| Tope mensual | No es literal: viene de `plan.getTopeMensual()` (CL línea 202) | Regla 6 | Sin duplicación. |

Notas de negocio que conviene tener presentes antes de tocar nada:
- La regla 7 dice «5 % sobre el monto neto». CL calcula la base como `totalTransado - totalComisiones - totalContracargos` (líneas 238-241), que es el neto antes de retenciones. Es coherente con la regla.
- La regla 8 pide el periodo en hora de Lima. `UtilidadesFecha.calendarioDeTrabajo()` usa la zona horaria del sistema, según su propio comentario. No es un literal de CL ni CC, pero afecta al borde del periodo.
- El comentario de la clase `PlanComisiones` dice que los tramos son acumulativos. La regla 2 dice que **no** lo son, y el código de CL y CC aplica el porcentaje al monto completo. El código y la regla coinciden; el comentario no. No lo toco.
- El comentario de `CalculadoraComision` dice que el monto incluye el IGV y que la comisión se aplica sobre el valor de venta neto, pero el código multiplica el monto completo. No hay regla en el README que respalde el comentario.

**2. Incrementos propuestos**

| # | Qué se extrae o se mueve | Qué debe seguir igual | Cómo se valida |
|---|---|---|---|
| 1 | De `procesarLiquidacionCompleta`, el bloque que va de `double montoTransaccion` (línea 140) hasta `liquidacion.agregarDetalle(linea);` (línea 190) pasa a un método privado de la misma clase que recibe `plan` y `transaccion` y devuelve el `DetalleLiquidacion`. Los acumuladores leen `linea.getMontoTransaccion()` y `linea.getComisionTotal()` | Todos los literales (`0.5`, `3.0`, `100.0`), los tipos `double`, el orden de las operaciones y el orden en que se agregan los detalles | `cd escenario/java && mvn -q clean package` y luego, desde la raíz, `bash scripts/comparar-escenarios.sh` (debe terminar en 0) |
| 2 | El desglose por medio de pago: el cálculo (líneas 284-315) y la impresión (líneas 330-347) pasan a un método privado que recibe la liquidación | Texto impreso carácter por carácter, el criterio `> 0` de cada línea y el contador de cuotas | `mvn -q clean package` y `bash scripts/comparar-escenarios.sh` |
| 3 | El recorrido de contracargos aprobados (líneas 207-226) a un método privado que devuelve `totalContracargos` | Se suma solo con estado `APROBADO`, fecha no nula y dentro de `[inicioPeriodo, finPeriodo]` | `mvn -q clean package`, `bash scripts/comparar-escenarios.sh` y `mvn test` |
| 4 | El cálculo de la retención (líneas 228-244) a un método privado que recibe fecha de afiliación, inicio del periodo y los totales, y devuelve `retenciones` | La antigüedad `meses < 6`, el `0.05`, la base y el orden respecto del redondeo de la línea 249 | `mvn -q clean package`, `bash scripts/comparar-escenarios.sh`, y revisar a mano un comercio con menos de seis meses de afiliación en la salida |
| 5 | La observación del registro tributario (líneas 261-282) a un método privado que devuelve `observacionRegistro` | El bloque `catch` vacío tal como está y los textos de la observación | `bash scripts/comparar-escenarios.sh` y `mvn test` |

Orden sugerido: el 1 primero porque es el que más acorta el método y tiene la frontera más clara; del 2 al 5 son independientes entre sí.

**3. Qué incremento no conviene hacer todavía**

No conviene hacer todavía **ningún incremento que sustituya el cálculo de `CalculadoraLiquidacion` por una llamada a `CalculadoraComision`** (por ejemplo, hacer que el método de cierre use `calcularComisionTotal`). Hay dos diferencias de comportamiento entre ambas clases: el máximo del recargo (3,0 en CL, 3,5 en CC) y el borde superior del tramo (`<` en CL, `<=` en CC). Unificarlas cambiaría la salida para las transacciones en 7 o más cuotas y para los montos exactamente iguales al límite de un tramo, y rompería la comparación entre escenarios. Antes de unificar hay que decidir cuál de las dos copias es la correcta (la regla 3 apunta a 3,0 %; la regla 1 no fija el borde del tramo) y tener pruebas que fijen el comportamiento. Tampoco conviene el incremento 4 antes de tener un caso de prueba con un comercio de menos de seis meses, porque es la zona donde el redondeo y el orden de las operaciones afectan más a la salida.

**Otros problemas vistos y no tocados**
- Montos en `double` en todo el cálculo.
- `procesarLiquidacionCompleta` tiene unas 280 líneas y muchos niveles de anidamiento.
- `catch (Exception e) { }` vacío en las líneas 281-282.
- Uso de `Date` y `Calendar` en lugar de la API de fecha y hora moderna.
- Dos copias de la lógica de comisión (CL y CC) con las diferencias descritas arriba.
- Comentario de `PlanComisiones` («tramos acumulativos») que contradice la regla 2; comentario de `CalculadoraComision` sobre el IGV que el código no implementa.
- `Liquidacion.obtenerMontoNeto()` se llama como consulta pero asigna `montoNeto`.
- Zona horaria del sistema en `UtilidadesFecha` frente a la regla 8 (hora de Lima).

### Verificación del «Salida esperada»
La tabla de valores de negocio, la tabla de incrementos y la advertencia del punto 3: entregadas.

## Paso 2 - `/lab-5-2-paso-2-extraer-comision java` (modo Agent)

Segundos: 14 (edición más `mvn -q clean package` y comparador, medidos desde el inicio de la edición)

### Respuesta del chat (verbatim)

Extraje el bloque de cálculo de comisión a un método privado nuevo y modifiqué un solo archivo: `escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java`.

1. Método nuevo: `private DetalleLiquidacion calcularDetalleDeTransaccion(PlanComisiones plan, Transaccion transaccion)`. Contiene, sin cambios, la búsqueda del tramo, el porcentaje más el monto fijo, el recargo por cuotas y la construcción del `DetalleLiquidacion`. Lo dejé justo antes de `formatearMonto`.
2. En `procesarLiquidacionCompleta` queda `DetalleLiquidacion linea = calcularDetalleDeTransaccion(plan, transaccion);` seguido de `liquidacion.agregarDetalle(linea);`. Los acumuladores `totalTransado`, `totalComisiones` y `acumuladoGeneralComisiones` ahora leen `linea.getMontoTransaccion()` y `linea.getComisionTotal()`, porque `montoTransaccion` y `comisionTotal` ya no existen en ese método.
3. Compilación: `cd escenario/java && mvn -q clean package` terminó sin errores (código 0).
4. Verificación: `bash scripts/comparar-escenarios.sh` compiló los dos escenarios y dijo «Las salidas son identicas» (554 líneas, 20457 bytes). Terminó en código cero.

Lo que no toqué y que vi (dejado como estaba):
- Montos en `double` en todo el cálculo.
- Literales `0.5`, `3.0` y `100.0` copiados tal cual al método nuevo, sin pasarlos a constantes. El máximo del recargo es `3.0` aquí y `3.5` en `CalculadoraComision.calcularRecargoCuotas`. La regla 3 de `escenario/README.md` habla de un máximo de 3 %.
- El borde superior del tramo es `<` en este método y `<=` en `CalculadoraComision.determinarTramo`.
- `procesarLiquidacionCompleta` sigue siendo largo y anidado.
- `catch (Exception e) { }` vacío en la observación del registro tributario.
- `Date` y `Calendar` en lugar de la API moderna de fecha y hora.
- El comentario de `PlanComisiones` dice que los tramos son acumulativos, cosa que contradice la regla 2 del README y lo que hace el código.
- `Liquidacion.obtenerMontoNeto()` consulta y además asigna `montoNeto`.

### Resultado de los comandos

```
$ cd escenario/java && mvn -q clean package
(sin salida) exit 0
$ bash scripts/comparar-escenarios.sh
Comparacion de escenarios, taller de GitHub Copilot
Script version 1.0.0
Periodo: 2026-06
Repositorio: /private/tmp/claude-501/-Users-rodrigosilva-GITHUB-COPILOT-github-copilot-netec/6e2f2b1e-040c-4c7f-bc41-827f7128af25/scratchpad/s11/l3

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

### git diff

```diff
diff --git a/escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java b/escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
index 45e65aa..fa93c9e 100644
--- a/escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
+++ b/escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
@@ -137,63 +137,14 @@ public class CalculadoraLiquidacion {
 
                             if (transaccion.getEstado() == EstadoTransaccion.APROBADA) {
 
-                                double montoTransaccion = transaccion.getMonto();
-                                double porcentajeAplicado = 0.0;
-                                boolean tramoEncontrado = false;
-
-                                for (TramoComision tramo : plan.getTramos()) {
-
-                                    if (!tramoEncontrado) {
-
-                                        if (montoTransaccion >= tramo.getMontoDesde()
-                                                && montoTransaccion < tramo.getMontoHasta()) {
-
-                                            porcentajeAplicado = tramo.getPorcentaje();
-                                            tramoEncontrado = true;
-                                        }
-                                    }
-                                }
-
-                                if (!tramoEncontrado) {
-                                    if (!plan.getTramos().isEmpty()) {
-                                        porcentajeAplicado = plan.getTramos()
-                                                .get(plan.getTramos().size() - 1).getPorcentaje();
-                                    }
-                                }
-
-                                double comisionBase = montoTransaccion * porcentajeAplicado / 100.0;
-                                comisionBase = comisionBase + plan.getMontoFijoPorTransaccion();
-
-                                double recargo = 0.0;
-
-                                if (transaccion.getCuotas() > 1) {
-
-                                    double porcentajeRecargo = (transaccion.getCuotas() - 1) * 0.5;
-
-                                    if (porcentajeRecargo > 3.0) {
-                                        porcentajeRecargo = 3.0;
-                                    }
-
-                                    recargo = comisionBase * porcentajeRecargo / 100.0;
-                                }
-
-                                double comisionTotal = comisionBase + recargo;
-
-                                DetalleLiquidacion linea = new DetalleLiquidacion();
-                                linea.setIdTransaccion(transaccion.getId());
-                                linea.setMontoTransaccion(montoTransaccion);
-                                linea.setComisionBase(comisionBase);
-                                linea.setRecargoCuotas(recargo);
-                                linea.setComisionTotal(comisionTotal);
-                                linea.setCuotas(transaccion.getCuotas());
-                                linea.setMedioPago(transaccion.getMedioPago().name());
+                                DetalleLiquidacion linea = calcularDetalleDeTransaccion(plan, transaccion);
                                 liquidacion.agregarDetalle(linea);
 
-                                totalTransado = totalTransado + montoTransaccion;
-                                totalComisiones = totalComisiones + comisionTotal;
+                                totalTransado = totalTransado + linea.getMontoTransaccion();
+                                totalComisiones = totalComisiones + linea.getComisionTotal();
                                 cantidadTransacciones++;
 
-                                acumuladoGeneralComisiones = acumuladoGeneralComisiones + comisionTotal;
+                                acumuladoGeneralComisiones = acumuladoGeneralComisiones + linea.getComisionTotal();
                             }
                         }
                     }
@@ -363,6 +314,64 @@ public class CalculadoraLiquidacion {
         return resultado;
     }
 
+    /**
+     * Calcula la comision de una transaccion segun el plan y arma su linea de detalle.
+     */
+    private DetalleLiquidacion calcularDetalleDeTransaccion(PlanComisiones plan, Transaccion transaccion) {
+        double montoTransaccion = transaccion.getMonto();
+        double porcentajeAplicado = 0.0;
+        boolean tramoEncontrado = false;
+
+        for (TramoComision tramo : plan.getTramos()) {
+
+            if (!tramoEncontrado) {
+
+                if (montoTransaccion >= tramo.getMontoDesde()
+                        && montoTransaccion < tramo.getMontoHasta()) {
+
+                    porcentajeAplicado = tramo.getPorcentaje();
+                    tramoEncontrado = true;
+                }
+            }
+        }
+
+        if (!tramoEncontrado) {
+            if (!plan.getTramos().isEmpty()) {
+                porcentajeAplicado = plan.getTramos()
+                        .get(plan.getTramos().size() - 1).getPorcentaje();
+            }
+        }
+
+        double comisionBase = montoTransaccion * porcentajeAplicado / 100.0;
+        comisionBase = comisionBase + plan.getMontoFijoPorTransaccion();
+
+        double recargo = 0.0;
+
+        if (transaccion.getCuotas() > 1) {
+
+            double porcentajeRecargo = (transaccion.getCuotas() - 1) * 0.5;
+
+            if (porcentajeRecargo > 3.0) {
+                porcentajeRecargo = 3.0;
+            }
+
+            recargo = comisionBase * porcentajeRecargo / 100.0;
+        }
+
+        double comisionTotal = comisionBase + recargo;
+
+        DetalleLiquidacion linea = new DetalleLiquidacion();
+        linea.setIdTransaccion(transaccion.getId());
+        linea.setMontoTransaccion(montoTransaccion);
+        linea.setComisionBase(comisionBase);
+        linea.setRecargoCuotas(recargo);
+        linea.setComisionTotal(comisionTotal);
+        linea.setCuotas(transaccion.getCuotas());
+        linea.setMedioPago(transaccion.getMedioPago().name());
+
+        return linea;
+    }
+
     private String formatearMonto(double monto) {
         return String.format(ConfiguracionRegional.REGION_DE_SALIDA, "%.2f", monto);
     }
```

### Verificación del «Salida esperada»
Método privado nuevo con nombre en español: sí. Método de cierre acortado con acumuladores leyendo del detalle: sí. Compila: sí. Comparador en cero: sí. Lista de otros problemas: sí. Un solo archivo modificado: sí.

## Paso 3 - `/lab-5-2-paso-3-extraer-desglose-medios java` (modo Agent)

Segundos: 14 (edición más compilación y comparador)

### Respuesta del chat (verbatim)

Extraje el desglose por medio de pago a un método privado y modifiqué un solo archivo: `escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java`.

Antes de mover el cálculo al lugar de la impresión comprobé que es seguro. Entre el final del recorrido del detalle y la impresión solo ocurren `resultado.add(liquidacion)` y varios `System.out.println`, ninguno modifica `liquidacion.getDetalle()`. Y el desglose solo se imprime dentro de `cantidadTransacciones > 0`, así que cuando esa condición es falsa el cálculo anterior no tenía efecto observable.

1. Método nuevo: `private void imprimirDesgloseMediosDePago(Liquidacion liquidacion)`. Recorre `liquidacion.getDetalle()`, suma los montos por medio de pago y cuenta las transacciones en cuotas de tarjeta de crédito, e imprime el desglose con el mismo texto, los mismos espacios y las mismas condiciones `> 0` de antes. Quedó antes de `formatearMonto`.
2. Se borró del método de cierre el bloque que declaraba `montoCredito`, `montoDebito`, `montoBilletera`, `montoTransferencia` y `transaccionesEnCuotas`, y el recorrido del detalle.
3. Donde estaba el bloque de impresión queda `imprimirDesgloseMediosDePago(liquidacion);`. La condición `if (montoCredito > 0 || ...)` se fue dentro del método nuevo, porque depende de los montos calculados allí.
4. Compilación: `mvn -q clean package` en `escenario/java/` terminó sin errores (código 0).
5. `bash scripts/comparar-escenarios.sh` terminó en código 0: «Las salidas son identicas» (554 líneas, 20457 bytes).

Otros problemas que vi y no toqué:
- La cadena de `if` anidados para el medio de pago compara con literales de texto (`"TARJETA_CREDITO"`, `"TARJETA_DEBITO"`, `"BILLETERA_MOVIL"`), y cualquier otro valor cae en «Transferencia».
- Los montos del desglose se suman en `double` y se imprimen sin el redondeo intermedio que sí se hace a los totales.
- `catch (Exception e) { }` vacío en la observación del registro tributario, que sigue en el método de cierre.
- `procesarLiquidacionCompleta` sigue siendo largo, con anidamiento profundo, y mezcla cálculo, acumulación e impresión.
- El máximo del recargo (`3.0` aquí, `3.5` en `CalculadoraComision`) y el borde del tramo (`<` aquí, `<=` allá) siguen sin coincidir.

### Resultado de los comandos

```
$ cd escenario/java && mvn -q clean package
(sin salida) exit 0
$ bash scripts/comparar-escenarios.sh   -> exit 0
== Comparacion ==
  [ OK ] Las salidas son identicas
       554 lineas, 20457 bytes

== Resumen ==
  Escenarios equivalentes. Java y .NET producen la misma salida para 2026-06.
```

### git diff (cambio de este paso; el git diff acumulado de pasos 2 y 3 queda al final del paso 4)

```diff
--- /private/tmp/claude-501/-Users-rodrigosilva-GITHUB-COPILOT-github-copilot-netec/6e2f2b1e-040c-4c7f-bc41-827f7128af25/scratchpad/s11/tmp2/paso2.java	2026-10-01 22:29:40
+++ escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java	2026-10-01 22:29:32
@@ -230,39 +230,6 @@
                         }
                     }
                 } catch (Exception e) {
-                }
-
-                double montoCredito = 0.0;
-                double montoDebito = 0.0;
-                double montoBilletera = 0.0;
-                double montoTransferencia = 0.0;
-                int transaccionesEnCuotas = 0;
-
-                for (DetalleLiquidacion linea : liquidacion.getDetalle()) {
-
-                    if (linea.getMedioPago() != null) {
-
-                        if (linea.getMedioPago().equals("TARJETA_CREDITO")) {
-
-                            montoCredito = montoCredito + linea.getMontoTransaccion();
-
-                            if (linea.getCuotas() > 1) {
-                                transaccionesEnCuotas++;
-                            }
-                        } else {
-
-                            if (linea.getMedioPago().equals("TARJETA_DEBITO")) {
-                                montoDebito = montoDebito + linea.getMontoTransaccion();
-                            } else {
-
-                                if (linea.getMedioPago().equals("BILLETERA_MOVIL")) {
-                                    montoBilletera = montoBilletera + linea.getMontoTransaccion();
-                                } else {
-                                    montoTransferencia = montoTransferencia + linea.getMontoTransaccion();
-                                }
-                            }
-                        }
-                    }
                 }
 
                 if (cantidadTransacciones > 0) {
@@ -278,25 +245,8 @@
                     System.out.println("  Retenciones              : S/ " + formatearMonto(retenciones));
                     System.out.println("  Monto neto a pagar       : S/ " + formatearMonto(neto));
 
-                    if (montoCredito > 0 || montoDebito > 0 || montoBilletera > 0 || montoTransferencia > 0) {
+                    imprimirDesgloseMediosDePago(liquidacion);
 
-                        System.out.println("  Desglose por medio de pago:");
-
-                        if (montoCredito > 0) {
-                            System.out.println("    Tarjeta de credito     : S/ " + formatearMonto(montoCredito)
-                                    + (transaccionesEnCuotas > 0 ? "  (" + transaccionesEnCuotas + " en cuotas)" : ""));
-                        }
-                        if (montoDebito > 0) {
-                            System.out.println("    Tarjeta de debito      : S/ " + formatearMonto(montoDebito));
-                        }
-                        if (montoBilletera > 0) {
-                            System.out.println("    Billetera movil        : S/ " + formatearMonto(montoBilletera));
-                        }
-                        if (montoTransferencia > 0) {
-                            System.out.println("    Transferencia          : S/ " + formatearMonto(montoTransferencia));
-                        }
-                    }
-
                     if (!observacionRegistro.isEmpty()) {
                         System.out.println("  Observacion              : " + observacionRegistro);
                     }
@@ -372,6 +322,63 @@
         return linea;
     }
 
+    /**
+     * Calcula los montos por medio de pago a partir del detalle e imprime el desglose.
+     */
+    private void imprimirDesgloseMediosDePago(Liquidacion liquidacion) {
+double montoCredito = 0.0;
+double montoDebito = 0.0;
+double montoBilletera = 0.0;
+double montoTransferencia = 0.0;
+int transaccionesEnCuotas = 0;
+
+for (DetalleLiquidacion linea : liquidacion.getDetalle()) {
+
+    if (linea.getMedioPago() != null) {
+
+        if (linea.getMedioPago().equals("TARJETA_CREDITO")) {
+
+            montoCredito = montoCredito + linea.getMontoTransaccion();
+
+            if (linea.getCuotas() > 1) {
+                transaccionesEnCuotas++;
+            }
+        } else {
+
+            if (linea.getMedioPago().equals("TARJETA_DEBITO")) {
+                montoDebito = montoDebito + linea.getMontoTransaccion();
+            } else {
+
+                if (linea.getMedioPago().equals("BILLETERA_MOVIL")) {
+                    montoBilletera = montoBilletera + linea.getMontoTransaccion();
+                } else {
+                    montoTransferencia = montoTransferencia + linea.getMontoTransaccion();
+                }
+            }
+        }
+    }
+}
+
+    if (montoCredito > 0 || montoDebito > 0 || montoBilletera > 0 || montoTransferencia > 0) {
+
+        System.out.println("  Desglose por medio de pago:");
+
+        if (montoCredito > 0) {
+            System.out.println("    Tarjeta de credito     : S/ " + formatearMonto(montoCredito)
+                    + (transaccionesEnCuotas > 0 ? "  (" + transaccionesEnCuotas + " en cuotas)" : ""));
+        }
+        if (montoDebito > 0) {
+            System.out.println("    Tarjeta de debito      : S/ " + formatearMonto(montoDebito));
+        }
+        if (montoBilletera > 0) {
+            System.out.println("    Billetera movil        : S/ " + formatearMonto(montoBilletera));
+        }
+        if (montoTransferencia > 0) {
+            System.out.println("    Transferencia          : S/ " + formatearMonto(montoTransferencia));
+        }
+    }
+    }
+
     private String formatearMonto(double monto) {
         return String.format(ConfiguracionRegional.REGION_DE_SALIDA, "%.2f", monto);
     }
```

### Verificación del «Salida esperada»
Método privado que calcula e imprime: sí. Método de cierre sin el cálculo y con la llamada: sí. Compila: sí. Comparador en cero: sí. Otros problemas listados: sí.

## Paso 4 - `/lab-5-2-paso-4-validar-equivalencia java` (modo Agent)

Segundos: 5 (git status, comparador completo con compilación de ambos escenarios, `mvn test`)

### Respuesta del chat (verbatim)

**1. Archivos de `escenario/` cambiados respecto del último commit** (`git status --short escenario/`):

```
 M escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
```

Solo cambió la clase de cálculo de la liquidación.

**2. Comparador** (`bash scripts/comparar-escenarios.sh`): código de salida **0**. Compiló ambos escenarios, ejecutó Java y .NET para 2026-06 (554 líneas cada uno) y dijo «Las salidas son identicas» (554 líneas, 20457 bytes).

**3. Interpretación:** código 0, la refactorización de los pasos 2 y 3 no cambió la salida. No hay primera línea distinta que identificar.

**4. Pruebas del escenario Java** (`mvn test` en `escenario/java/`): 20 pruebas, 0 fallos, 0 errores, 0 omitidas. `BUILD SUCCESS`. Corresponden a `ValidadorFormatoTest` (8), `ComercioTest` (6) y `TransaccionTest` (6). Cabe señalar que ninguna cubre la lógica de cálculo, así que el comparador es la verificación que realmente protege este cambio.

No modifiqué ningún archivo en este paso.

### Salida de los comandos

```
$ git status --short escenario/
 M escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
$ bash scripts/comparar-escenarios.sh
Comparacion de escenarios, taller de GitHub Copilot
Script version 1.0.0
Periodo: 2026-06
Repositorio: /private/tmp/claude-501/-Users-rodrigosilva-GITHUB-COPILOT-github-copilot-netec/6e2f2b1e-040c-4c7f-bc41-827f7128af25/scratchpad/s11/l3

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
cmp exit 0
$ cd escenario/java && mvn test (líneas relevantes)
[INFO] Tests run: 8, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.044 s -- in pe.pasarelaandina.util.ValidadorFormatoTest
[INFO] Tests run: 6, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.014 s -- in pe.pasarelaandina.modelo.ComercioTest
[INFO] Tests run: 6, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.012 s -- in pe.pasarelaandina.modelo.TransaccionTest
[INFO] Tests run: 20, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

### git diff acumulado de pasos 2 y 3

```diff
diff --git a/escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java b/escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
index 45e65aa..718a17e 100644
--- a/escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
+++ b/escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
@@ -137,63 +137,14 @@ public class CalculadoraLiquidacion {
 
                             if (transaccion.getEstado() == EstadoTransaccion.APROBADA) {
 
-                                double montoTransaccion = transaccion.getMonto();
-                                double porcentajeAplicado = 0.0;
-                                boolean tramoEncontrado = false;
-
-                                for (TramoComision tramo : plan.getTramos()) {
-
-                                    if (!tramoEncontrado) {
-
-                                        if (montoTransaccion >= tramo.getMontoDesde()
-                                                && montoTransaccion < tramo.getMontoHasta()) {
-
-                                            porcentajeAplicado = tramo.getPorcentaje();
-                                            tramoEncontrado = true;
-                                        }
-                                    }
-                                }
-
-                                if (!tramoEncontrado) {
-                                    if (!plan.getTramos().isEmpty()) {
-                                        porcentajeAplicado = plan.getTramos()
-                                                .get(plan.getTramos().size() - 1).getPorcentaje();
-                                    }
-                                }
-
-                                double comisionBase = montoTransaccion * porcentajeAplicado / 100.0;
-                                comisionBase = comisionBase + plan.getMontoFijoPorTransaccion();
-
-                                double recargo = 0.0;
-
-                                if (transaccion.getCuotas() > 1) {
-
-                                    double porcentajeRecargo = (transaccion.getCuotas() - 1) * 0.5;
-
-                                    if (porcentajeRecargo > 3.0) {
-                                        porcentajeRecargo = 3.0;
-                                    }
-
-                                    recargo = comisionBase * porcentajeRecargo / 100.0;
-                                }
-
-                                double comisionTotal = comisionBase + recargo;
-
-                                DetalleLiquidacion linea = new DetalleLiquidacion();
-                                linea.setIdTransaccion(transaccion.getId());
-                                linea.setMontoTransaccion(montoTransaccion);
-                                linea.setComisionBase(comisionBase);
-                                linea.setRecargoCuotas(recargo);
-                                linea.setComisionTotal(comisionTotal);
-                                linea.setCuotas(transaccion.getCuotas());
-                                linea.setMedioPago(transaccion.getMedioPago().name());
+                                DetalleLiquidacion linea = calcularDetalleDeTransaccion(plan, transaccion);
                                 liquidacion.agregarDetalle(linea);
 
-                                totalTransado = totalTransado + montoTransaccion;
-                                totalComisiones = totalComisiones + comisionTotal;
+                                totalTransado = totalTransado + linea.getMontoTransaccion();
+                                totalComisiones = totalComisiones + linea.getComisionTotal();
                                 cantidadTransacciones++;
 
-                                acumuladoGeneralComisiones = acumuladoGeneralComisiones + comisionTotal;
+                                acumuladoGeneralComisiones = acumuladoGeneralComisiones + linea.getComisionTotal();
                             }
                         }
                     }
@@ -281,39 +232,6 @@ public class CalculadoraLiquidacion {
                 } catch (Exception e) {
                 }
 
-                double montoCredito = 0.0;
-                double montoDebito = 0.0;
-                double montoBilletera = 0.0;
-                double montoTransferencia = 0.0;
-                int transaccionesEnCuotas = 0;
-
-                for (DetalleLiquidacion linea : liquidacion.getDetalle()) {
-
-                    if (linea.getMedioPago() != null) {
-
-                        if (linea.getMedioPago().equals("TARJETA_CREDITO")) {
-
-                            montoCredito = montoCredito + linea.getMontoTransaccion();
-
-                            if (linea.getCuotas() > 1) {
-                                transaccionesEnCuotas++;
-                            }
-                        } else {
-
-                            if (linea.getMedioPago().equals("TARJETA_DEBITO")) {
-                                montoDebito = montoDebito + linea.getMontoTransaccion();
-                            } else {
-
-                                if (linea.getMedioPago().equals("BILLETERA_MOVIL")) {
-                                    montoBilletera = montoBilletera + linea.getMontoTransaccion();
-                                } else {
-                                    montoTransferencia = montoTransferencia + linea.getMontoTransaccion();
-                                }
-                            }
-                        }
-                    }
-                }
-
                 if (cantidadTransacciones > 0) {
 
                     resultado.add(liquidacion);
@@ -327,24 +245,7 @@ public class CalculadoraLiquidacion {
                     System.out.println("  Retenciones              : S/ " + formatearMonto(retenciones));
                     System.out.println("  Monto neto a pagar       : S/ " + formatearMonto(neto));
 
-                    if (montoCredito > 0 || montoDebito > 0 || montoBilletera > 0 || montoTransferencia > 0) {
-
-                        System.out.println("  Desglose por medio de pago:");
-
-                        if (montoCredito > 0) {
-                            System.out.println("    Tarjeta de credito     : S/ " + formatearMonto(montoCredito)
-                                    + (transaccionesEnCuotas > 0 ? "  (" + transaccionesEnCuotas + " en cuotas)" : ""));
-                        }
-                        if (montoDebito > 0) {
-                            System.out.println("    Tarjeta de debito      : S/ " + formatearMonto(montoDebito));
-                        }
-                        if (montoBilletera > 0) {
-                            System.out.println("    Billetera movil        : S/ " + formatearMonto(montoBilletera));
-                        }
-                        if (montoTransferencia > 0) {
-                            System.out.println("    Transferencia          : S/ " + formatearMonto(montoTransferencia));
-                        }
-                    }
+                    imprimirDesgloseMediosDePago(liquidacion);
 
                     if (!observacionRegistro.isEmpty()) {
                         System.out.println("  Observacion              : " + observacionRegistro);
@@ -363,6 +264,121 @@ public class CalculadoraLiquidacion {
         return resultado;
     }
 
+    /**
+     * Calcula la comision de una transaccion segun el plan y arma su linea de detalle.
+     */
+    private DetalleLiquidacion calcularDetalleDeTransaccion(PlanComisiones plan, Transaccion transaccion) {
+        double montoTransaccion = transaccion.getMonto();
+        double porcentajeAplicado = 0.0;
+        boolean tramoEncontrado = false;
+
+        for (TramoComision tramo : plan.getTramos()) {
+
+            if (!tramoEncontrado) {
+
+                if (montoTransaccion >= tramo.getMontoDesde()
+                        && montoTransaccion < tramo.getMontoHasta()) {
+
+                    porcentajeAplicado = tramo.getPorcentaje();
+                    tramoEncontrado = true;
+                }
+            }
+        }
+
+        if (!tramoEncontrado) {
+            if (!plan.getTramos().isEmpty()) {
+                porcentajeAplicado = plan.getTramos()
+                        .get(plan.getTramos().size() - 1).getPorcentaje();
+            }
+        }
+
+        double comisionBase = montoTransaccion * porcentajeAplicado / 100.0;
+        comisionBase = comisionBase + plan.getMontoFijoPorTransaccion();
+
+        double recargo = 0.0;
+
+        if (transaccion.getCuotas() > 1) {
+
+            double porcentajeRecargo = (transaccion.getCuotas() - 1) * 0.5;
+
+            if (porcentajeRecargo > 3.0) {
+                porcentajeRecargo = 3.0;
+            }
+
+            recargo = comisionBase * porcentajeRecargo / 100.0;
+        }
+
+        double comisionTotal = comisionBase + recargo;
+
+        DetalleLiquidacion linea = new DetalleLiquidacion();
+        linea.setIdTransaccion(transaccion.getId());
+        linea.setMontoTransaccion(montoTransaccion);
+        linea.setComisionBase(comisionBase);
+        linea.setRecargoCuotas(recargo);
+        linea.setComisionTotal(comisionTotal);
+        linea.setCuotas(transaccion.getCuotas());
+        linea.setMedioPago(transaccion.getMedioPago().name());
+
+        return linea;
+    }
+
+    /**
+     * Calcula los montos por medio de pago a partir del detalle e imprime el desglose.
+     */
+    private void imprimirDesgloseMediosDePago(Liquidacion liquidacion) {
+double montoCredito = 0.0;
+double montoDebito = 0.0;
+double montoBilletera = 0.0;
+double montoTransferencia = 0.0;
+int transaccionesEnCuotas = 0;
+
+for (DetalleLiquidacion linea : liquidacion.getDetalle()) {
+
+    if (linea.getMedioPago() != null) {
+
+        if (linea.getMedioPago().equals("TARJETA_CREDITO")) {
+
+            montoCredito = montoCredito + linea.getMontoTransaccion();
+
+            if (linea.getCuotas() > 1) {
+                transaccionesEnCuotas++;
+            }
+        } else {
+
+            if (linea.getMedioPago().equals("TARJETA_DEBITO")) {
+                montoDebito = montoDebito + linea.getMontoTransaccion();
+            } else {
+
+                if (linea.getMedioPago().equals("BILLETERA_MOVIL")) {
+                    montoBilletera = montoBilletera + linea.getMontoTransaccion();
+                } else {
+                    montoTransferencia = montoTransferencia + linea.getMontoTransaccion();
+                }
+            }
+        }
+    }
+}
+
+    if (montoCredito > 0 || montoDebito > 0 || montoBilletera > 0 || montoTransferencia > 0) {
+
+        System.out.println("  Desglose por medio de pago:");
+
+        if (montoCredito > 0) {
+            System.out.println("    Tarjeta de credito     : S/ " + formatearMonto(montoCredito)
+                    + (transaccionesEnCuotas > 0 ? "  (" + transaccionesEnCuotas + " en cuotas)" : ""));
+        }
+        if (montoDebito > 0) {
+            System.out.println("    Tarjeta de debito      : S/ " + formatearMonto(montoDebito));
+        }
+        if (montoBilletera > 0) {
+            System.out.println("    Billetera movil        : S/ " + formatearMonto(montoBilletera));
+        }
+        if (montoTransferencia > 0) {
+            System.out.println("    Transferencia          : S/ " + formatearMonto(montoTransferencia));
+        }
+    }
+    }
+
     private String formatearMonto(double monto) {
         return String.format(ConfiguracionRegional.REGION_DE_SALIDA, "%.2f", monto);
     }
```

### Verificación del «Salida esperada»
Archivos cambiados, código de salida, interpretación y resultado de pruebas: entregados.
