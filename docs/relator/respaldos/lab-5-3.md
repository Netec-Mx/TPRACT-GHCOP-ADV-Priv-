> Los tiempos de este respaldo son de reloj del agente de verificación y no incluyen la
> lectura de la sala.

# Lab 5.3 - Estrategia de pruebas, documentación y checklist de revisión (Java)

Partida: sobre el resultado del lab 5.2, sin reiniciar (el README del 5.3 lo permite). Por eso el `git diff` incluye también los cambios de `CalculadoraLiquidacion.java` del 5.2.

## Paso 1 - `/lab-5-3-paso-1-probar-tramos java` (modo Agent)

Segundos: 18 (lectura de código y datos, creación del archivo y `mvn test`)

### Respuesta del chat (verbatim)

Creé un archivo nuevo: `escenario/java/src/test/java/pe/pasarelaandina/calculo/CalculadoraComisionTest.java`, con 13 pruebas de `determinarTramo` y el plan PL01 (0-500 al 3,5 %, 500-2000 al 2,9 %, 2000-10000 al 2,5 %, 10000-999999 al 2,1 %). No modifiqué ningún archivo existente en este paso. Las pruebas reflejan lo que el código hace hoy.

`mvn test` en `escenario/java/`: 33 pruebas, 0 fallos (las 20 existentes más las 13 nuevas), `BUILD SUCCESS`.

Pruebas incluidas: un monto interior por cada uno de los cuatro tramos (250, 1000, 5000, 50000); el monto 0; los bordes 500.00, 2000.00 y 10000.00; un centavo sobre cada borde (500.01, 2000.01, 10000.01); un monto por debajo del primer tramo (-1.00); un monto por encima del último (1000000.00); un plan sin tramos y un plan nulo.

**Bordes: calculadora de comisión frente al cierre de la liquidación**

| Monto en el borde | Calculadora de comisión (`CalculadoraComision.determinarTramo`, usa `<= montoHasta`) | Cierre de la liquidación (`CalculadoraLiquidacion`, usa `>= montoDesde && < montoHasta`) |
|---|---|---|
| 500.00 | 3,5 % (primer tramo) | 2,9 % (segundo tramo) |
| 2000.00 | 2,9 % (segundo tramo) | 2,5 % (tercer tramo) |
| 10000.00 | 2,5 % (tercer tramo) | 2,1 % (cuarto tramo) |

El dato del cierre sale de leer el bloque de selección de tramo en `CalculadoraLiquidacion` (hoy en el método privado `calcularDetalleDeTransaccion`, que salió del método de cierre en el lab 5.2). No escribí pruebas de la liquidación.

**Discrepancia encontrada, sin corregir.** Las dos partes del sistema no coinciden en el borde: la calculadora de comisión trata el límite superior como inclusivo y el cierre como exclusivo. Una transacción de exactamente S/ 500,00 paga 3,5 % si la calcula `CalculadoraComision` (por ejemplo desde `SimuladorComision`) y 2,9 % si la calcula el cierre. Lo que el sistema le cobra realmente al comercio es lo del cierre.

Qué dicen las reglas de `escenario/README.md`: la regla 1 dice que se aplica «el porcentaje del tramo que corresponde a su monto» y la regla 2 que el monto completo se multiplica por el porcentaje del tramo en que cae. Ninguna dice si el límite superior pertenece al tramo de abajo o al de arriba. **Las reglas no alcanzan para decidir cuál de las dos es la correcta.** Eso requiere una decisión de negocio. En los datos, los tramos se escriben `0:500`, `500:2000`, que sugiere intervalos semiabiertos `[desde, hasta)`, lo que coincidiría con el cierre, pero es una inferencia y no una regla.

**Otras observaciones, sin tocar nada:**
- Un monto por debajo del primer tramo (por ejemplo -1.00) hace que `determinarTramo` devuelva el último tramo (2,1 %), porque no cae en ninguno y el método cae al `return` final. La prueba lo documenta como comportamiento actual. Las reglas no dicen nada sobre montos negativos.
- Las dos copias de la lógica difieren también en el máximo del recargo por cuotas: 3,0 en el cierre y 3,5 en `CalculadoraComision.calcularRecargoCuotas`. La regla 3 dice máximo 3 %. Este paso no lo prueba.
- El comentario de la clase `PlanComisiones` dice que los tramos son acumulativos. La regla 2 dice que no lo son y el código no los acumula.
- El comentario de `CalculadoraComision` habla del IGV y de «valor de venta neto», cosa que el código no hace.
- Los montos siguen en `double` y el cierre tiene un `catch` vacío. Fuera del alcance.

### Archivo nuevo (contenido completo)

```java
package pe.pasarelaandina.calculo;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertSame;

import org.junit.jupiter.api.Test;

import pe.pasarelaandina.modelo.PlanComisiones;
import pe.pasarelaandina.modelo.TramoComision;

/**
 * Pruebas de la seleccion de tramo de la calculadora de comision.
 *
 * Las pruebas documentan lo que el codigo hace hoy, no lo que las reglas de negocio
 * dicen que deberia hacer. Usan los tramos del plan PL01 de planes.txt.
 */
class CalculadoraComisionTest {

    private final CalculadoraComision calculadora = new CalculadoraComision();

    private final TramoComision tramo1 = new TramoComision(0, 500, 3.5);
    private final TramoComision tramo2 = new TramoComision(500, 2000, 2.9);
    private final TramoComision tramo3 = new TramoComision(2000, 10000, 2.5);
    private final TramoComision tramo4 = new TramoComision(10000, 999999, 2.1);

    private PlanComisiones planPL01() {
        PlanComisiones plan = new PlanComisiones("PL01", "Basico", 0.30, 8000.00);
        plan.agregarTramo(tramo1);
        plan.agregarTramo(tramo2);
        plan.agregarTramo(tramo3);
        plan.agregarTramo(tramo4);
        return plan;
    }

    @Test
    void eligeElPrimerTramoParaUnMontoInterior() {
        assertSame(tramo1, calculadora.determinarTramo(planPL01(), 250.00));
    }

    @Test
    void eligeElSegundoTramoParaUnMontoInterior() {
        assertSame(tramo2, calculadora.determinarTramo(planPL01(), 1000.00));
    }

    @Test
    void eligeElTercerTramoParaUnMontoInterior() {
        assertSame(tramo3, calculadora.determinarTramo(planPL01(), 5000.00));
    }

    @Test
    void eligeElCuartoTramoParaUnMontoInterior() {
        assertSame(tramo4, calculadora.determinarTramo(planPL01(), 50000.00));
    }

    @Test
    void elMontoCeroCaeEnElPrimerTramo() {
        assertSame(tramo1, calculadora.determinarTramo(planPL01(), 0.00));
    }

    @Test
    void elMontoExactoDe500CaeEnElPrimerTramoPorqueElLimiteSuperiorEsInclusivo() {
        assertSame(tramo1, calculadora.determinarTramo(planPL01(), 500.00));
        assertEquals(3.5, calculadora.determinarTramo(planPL01(), 500.00).getPorcentaje());
    }

    @Test
    void elMontoExactoDe2000CaeEnElSegundoTramoPorqueElLimiteSuperiorEsInclusivo() {
        assertSame(tramo2, calculadora.determinarTramo(planPL01(), 2000.00));
        assertEquals(2.9, calculadora.determinarTramo(planPL01(), 2000.00).getPorcentaje());
    }

    @Test
    void elMontoExactoDe10000CaeEnElTercerTramoPorqueElLimiteSuperiorEsInclusivo() {
        assertSame(tramo3, calculadora.determinarTramo(planPL01(), 10000.00));
        assertEquals(2.5, calculadora.determinarTramo(planPL01(), 10000.00).getPorcentaje());
    }

    @Test
    void unCentimoSobreElBordeCaeEnElTramoSiguiente() {
        assertSame(tramo2, calculadora.determinarTramo(planPL01(), 500.01));
        assertSame(tramo3, calculadora.determinarTramo(planPL01(), 2000.01));
        assertSame(tramo4, calculadora.determinarTramo(planPL01(), 10000.01));
    }

    @Test
    void unMontoPorDebajoDelPrimerTramoDevuelveElUltimoTramo() {
        // Comportamiento actual: un monto negativo no cae en ningun tramo y el metodo
        // devuelve el ultimo. Las reglas de negocio no definen que pasa con montos negativos.
        assertSame(tramo4, calculadora.determinarTramo(planPL01(), -1.00));
    }

    @Test
    void unMontoPorEncimaDelUltimoTramoDevuelveElUltimoTramo() {
        assertSame(tramo4, calculadora.determinarTramo(planPL01(), 1000000.00));
    }

    @Test
    void unPlanSinTramosDevuelveNulo() {
        PlanComisiones planSinTramos = new PlanComisiones("PLXX", "Vacio", 0.30, 8000.00);
        assertNull(calculadora.determinarTramo(planSinTramos, 100.00));
    }

    @Test
    void unPlanNuloDevuelveNulo() {
        assertNull(calculadora.determinarTramo(null, 100.00));
    }
}
```

### Salida de `mvn test`

```
[INFO] Tests run: 8, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.040 s -- in pe.pasarelaandina.util.ValidadorFormatoTest
[INFO] Tests run: 6, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.011 s -- in pe.pasarelaandina.modelo.ComercioTest
[INFO] Tests run: 6, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.010 s -- in pe.pasarelaandina.modelo.TransaccionTest
[INFO] Tests run: 13, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.010 s -- in pe.pasarelaandina.calculo.CalculadoraComisionTest
[INFO] Tests run: 33, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

### Verificación del «Salida esperada»
Archivo nuevo en la ruta indicada: sí. Ningún archivo existente modificado por este paso: sí (el único archivo modificado en el árbol viene del lab 5.2). Pruebas en verde, 20 existentes más 13 nuevas: sí. Tabla de tres bordes: sí. Discrepancia explicada, con lo que dicen las reglas y sin corregir: sí.

## Paso 2 - `/lab-5-3-paso-2-documentar-estrategia java` (modo Agent)

Segundos: 19 (lectura de pruebas existentes y redacción del documento)

### Respuesta del chat (verbatim)

Creé `labs/cap5/lab-5-3-pruebas-y-revision/entregables/estrategia-de-pruebas.md` (unas 900 palabras, dentro de las dos páginas). No escribí pruebas ni toqué código.

Resumen del contenido:
1. **Qué cubren hoy las pruebas.** `ValidadorFormatoTest` (8), `ComercioTest` (6) y `TransaccionTest` (6) cubren getters, setters, enumerados y formato; `CalculadoraComisionTest` (13, del paso 1) cubre solo `determinarTramo`. Total 33, ninguna ejecuta cálculo de dinero más allá de elegir el tramo.
2. **Reglas sin ninguna prueba:** las nueve. Las reglas 1 y 2 tienen cubierta solo la elección del tramo, no la comisión resultante. Las reglas 3 (recargo por cuotas), 4 (anuladas), 5 (contracargos), 6 (tope), 7 (retención), 8 (periodo en hora de Lima) y 9 (redondeo) no tienen ninguna prueba.
3. **Valores de borde**, regla por regla: 500, 2000 y 10000 para tramos; 1, 2, 3, 6, 7 y 8 cuotas; 2026-06-01 00:00:00 y 2026-06-30 23:59:59 con sus vecinos para periodo y contracargos; tope exacto, un centavo sobre y un centavo bajo; antigüedad de 5 meses, 6 meses y 6 meses menos un día para la retención; montos con 5 en la tercera decimal para el redondeo.
4. **Qué reveló el paso 1:** la calculadora de comisión y el cierre de la liquidación discrepan en los bordes de tramo (inclusivo frente a exclusivo). Las reglas 1 y 2 no definen a qué tramo pertenece el límite, así que hace falta una decisión de negocio de quien es dueño del tarifario. El documento lo dice y no lo resuelve.
5. **Orden recomendado:** comisión de punta a punta probando primero el cierre, luego redondeo y tope, luego retención, luego contracargos y periodo, y por último anuladas.

Otros problemas que vi y no toqué: máximo del recargo distinto entre las dos calculadoras (3,0 y 3,5) frente al 3 % de la regla 3; la regla 8 pide hora de Lima y `UtilidadesFecha` usa la zona horaria del sistema; montos en `double`; comentarios de `PlanComisiones` y `CalculadoraComision` que contradicen el código o las reglas.

### Archivo nuevo (contenido completo)

````markdown
# Estrategia de pruebas del escenario Pasarela Andina (Java)

Estado al momento de escribir este documento: 33 pruebas, todas en verde (`mvn test`). Las
reglas de negocio citadas son las de `escenario/README.md`.

## 1. Qué cubren hoy las pruebas

| Clase de prueba | Pruebas | Qué cubre |
|---|---|---|
| `util/ValidadorFormatoTest` | 8 | Formato del registro tributario, del código de autorización, del identificador de comercio y del periodo `aaaa-mm`. |
| `modelo/ComercioTest` | 6 | Constructores, setters, `toString` y que los enumerados de categoría y estado estén completos. |
| `modelo/TransaccionTest` | 6 | Constructores, setters, `toString`, enumerados de medio de pago y estado, y los valores guardados por `DetalleLiquidacion`. |
| `calculo/CalculadoraComisionTest` (paso 1) | 13 | Solo `determinarTramo`: un monto interior por tramo, los bordes 500, 2000 y 10000, un centavo sobre cada borde, monto negativo, monto sobre el último tramo, plan sin tramos y plan nulo. Documenta el comportamiento actual. |

Las 20 pruebas originales cubren getters, setters y validaciones de formato. Ninguna
ejecuta cálculo de dinero. Las 13 nuevas cubren una sola función de `CalculadoraComision`.

## 2. Reglas de negocio sin ninguna prueba

| Regla | Estado |
|---|---|
| 1. Porcentaje del tramo más monto fijo | Sin prueba. Solo se prueba qué tramo se elige, no la comisión resultante. |
| 2. Tramos no acumulativos | Sin prueba. |
| 3. Recargo por cuotas, 0,5 % por cuota sobre la primera, máximo 3 % | Sin prueba. |
| 4. Las transacciones anuladas no generan comisión | Sin prueba. |
| 5. Contracargos aprobados se descuentan en el periodo de su aprobación | Sin prueba. |
| 6. Tope mensual del plan | Sin prueba. |
| 7. Retención de garantía del 5 % con menos de seis meses de afiliación | Sin prueba. |
| 8. Periodo del primer día 00:00:00 al último 23:59:59 en hora de Lima | Sin prueba. Solo se valida el formato del texto `aaaa-mm`. |
| 9. Redondeo a dos decimales, medio hacia arriba | Sin prueba. |

## 3. Casos de borde que importan

Tramos de PL01: 0-500 al 3,5 %, 500-2000 al 2,9 %, 2000-10000 al 2,5 %, 10000-999999 al 2,1 %,
fijo 0,30 y tope 8000,00.

- **Reglas 1 y 2.** Montos 500.00, 2000.00 y 10000.00 en las dos calculadoras. Un monto de 1000.00
  debe dar 1000 x 2,9 % + 0,30 = 29,30, lo que comprueba que el monto completo se multiplica y no se reparte.
- **Regla 3.** 1, 2, 3, 6, 7 y 8 cuotas. Con 7 cuotas el recargo es de 3,0 % en las dos calculadoras;
  con 8 cuotas es de 3,0 % en el cierre y de 3,5 % en la calculadora de comisión.
- **Regla 4.** Una transacción en estado anulado entre transacciones aprobadas, en el periodo.
- **Regla 5.** Contracargo aprobado con fecha 2026-06-01 00:00:00 y 2026-06-30 23:59:59 (dentro),
  2026-05-31 23:59:59 y 2026-07-01 00:00:00 (fuera); contracargo no aprobado.
- **Regla 6.** Total de comisiones justo en el tope (8000.00), un centavo sobre el tope y un centavo bajo.
- **Regla 7.** Afiliación hace exactamente 5 meses, 6 meses y 6 meses menos un día respecto del
  primer día del periodo; base de retención cero o negativa; fecha de afiliación nula.
- **Regla 8.** Transacción a las 2026-06-01 00:00:00 y 2026-06-30 23:59:59 (dentro), 2026-05-31 23:59:59
  y 2026-07-01 00:00:00 (fuera), y una máquina con zona horaria distinta de Lima.
- **Regla 9.** Montos terminados en 5 en la tercera decimal (por ejemplo 0.125 y 2.675). Con `double`
  el medio exacto puede no ser exacto.

## 4. Qué reveló el paso 1

Al probar `determinarTramo` apareció una discrepancia entre dos partes del sistema. La calculadora de
comisión trata el límite superior como inclusivo (`monto <= montoHasta`) y el cierre de la liquidación
como exclusivo (`monto < montoHasta`). En los tres bordes el resultado difiere:

| Monto | Calculadora de comisión | Cierre |
|---|---|---|
| 500.00 | 3,5 % | 2,9 % |
| 2000.00 | 2,9 % | 2,5 % |
| 10000.00 | 2,5 % | 2,1 % |

Las reglas 1 y 2 no dicen a qué tramo pertenece un monto que cae justo en el límite. **Hace falta una
decisión de negocio** de quien es dueño del tarifario: si el límite superior pertenece al tramo de abajo
o al de arriba. Hasta que se decida, las pruebas del paso 1 documentan lo que hace `CalculadoraComision`,
sin afirmar que sea lo correcto. También se vio que un monto negativo devuelve el último tramo, y que el
máximo del recargo por cuotas difiere entre las dos calculadoras (3,0 y 3,5) frente al 3 % de la regla 3.

## 5. Orden recomendado

Por riesgo para el dinero del comercio:

1. Comisión de una transacción de punta a punta (reglas 1, 2 y 3, con los bordes de tramo y de cuotas),
   probando primero el cierre porque es lo que realmente se cobra.
2. Redondeo (regla 9) y tope mensual (regla 6), porque afectan a todos los montos del comercio.
3. Retención de garantía (regla 7), con los bordes de antigüedad.
4. Contracargos y periodo (reglas 5 y 8), que dependen de fechas y de la zona horaria.
5. Anuladas (regla 4), que es la más simple.

Antes de escribir las pruebas 1 y 2, resolver la decisión de negocio de la sección 4.
````

### Verificación del «Salida esperada»
Documento creado, de no más de dos páginas: sí (aprox. 900 palabras). Las cuatro secciones pedidas más el orden recomendado: sí.

## Paso 3 - `/lab-5-3-paso-3-revision-asistida` (modo Ask)

Segundos: 12 (`git diff`, `git status --short` y revisión; sin modificar archivos)

Comandos ejecutados:

```
$ git status --short
 M escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
?? escenario/java/src/test/java/pe/pasarelaandina/calculo/
?? labs/cap5/lab-5-3-pruebas-y-revision/entregables/
$ git diff --stat
 .../calculo/CalculadoraLiquidacion.java | 224 +++++++++++----------   (120 inserciones, 104 eliminaciones)
```

### Respuesta del chat (verbatim)

Revisé el diff acumulado: la refactorización de `CalculadoraLiquidacion.java` (dos métodos privados extraídos), el archivo nuevo `CalculadoraComisionTest.java` y el documento nuevo `estrategia-de-pruebas.md`. No modifiqué ningún archivo.

Verifiqué primero que la refactorización es neutra: el bloque de cálculo se movió sin cambiar literales, tipos ni orden de operaciones; los acumuladores leen los mismos valores desde el detalle; el desglose imprime el mismo texto. `bash scripts/comparar-escenarios.sh` termina en 0 y `mvn test` pasa con 33 pruebas.

| Archivo | Línea | Hallazgo | Clasificación | Justificación |
|---|---|---|---|---|
| `escenario/java/.../calculo/CalculadoraLiquidacion.java` | 270-322 | `calcularDetalleDeTransaccion` es una copia fiel del bloque original, incluidos `0.5`, `3.0` y `100.0` y el tramo con `<` | Descartar | Es lo que pedía el paso 2: mover sin cambiar. El comparador en cero lo respalda. |
| `escenario/java/.../calculo/CalculadoraLiquidacion.java` | 328-359 | `imprimirDesgloseMediosDePago` incluye la condición `> 0` y las impresiones tal como estaban | Descartar | Cumple el paso 3. El cálculo se movió al punto de la impresión sin alterar el resultado. |
| `escenario/java/.../calculo/CalculadoraLiquidacion.java` | 304-305 | El máximo del recargo es `3.0`, mientras `CalculadoraComision.calcularRecargoCuotas` usa `3.5` | Decidir | La regla 3 dice «máximo de 3 %», lo que respalda 3.0, pero cambiar una de las dos copias altera la salida de uno de los caminos. Decide el dueño de negocio y el equipo. Fuera del alcance del cambio. |
| `escenario/java/.../calculo/CalculadoraLiquidacion.java` | 279-280 (dentro del método extraído) | El tramo usa `< montoHasta` y `CalculadoraComision` usa `<= montoHasta` | Decidir | Las reglas 1 y 2 no fijan a qué tramo pertenece el borde. Requiere una decisión de negocio que el agente no puede tomar. |
| `escenario/java/.../calculo/CalculadoraLiquidacion.java` | 232-233 | `catch (Exception e) { }` vacío | Descartar | Fuera del alcance del cambio. Ya existía en código que el cambio no tocó. |
| `escenario/java/.../calculo/CalculadoraLiquidacion.java` | 187, 192 | Literales `6` y `0.05` de la retención, sin nombre | Descartar | Fuera del alcance del cambio. Existían antes y no se tocaron. |
| `escenario/java/.../calculo/CalculadoraLiquidacion.java` | (cierre) | Método de cierre todavía largo, con `double` y `Date`/`Calendar` | Descartar | Fuera del alcance del cambio. Es la deuda previa del escenario. |
| `escenario/java/src/test/.../calculo/CalculadoraComisionTest.java` | 62-76 | Los nombres de las tres pruebas de borde dicen «porque el límite superior es inclusivo», lo que presenta como regla algo que las reglas de negocio no definen | Decidir | Las pruebas fijan el comportamiento actual, y hoy hay dos comportamientos distintos en el sistema. Si negocio decide el borde exclusivo, estas tres pruebas se invierten. Conviene que quien revisa sepa que no certifican corrección. |
| `escenario/java/src/test/.../calculo/CalculadoraComisionTest.java` | 86-91 | La prueba del monto -1.00 fija que se devuelve el último tramo (2,1 %) | Decidir | Es el comportamiento actual, probablemente no intencional. Las reglas no hablan de montos negativos. Decide negocio si debe existir una prueba que lo congele. |
| `escenario/java/src/test/.../calculo/CalculadoraComisionTest.java` | 1-108 | Archivo nuevo en el paquete y estilo del proyecto, sin dependencias nuevas, 13 pruebas en verde | Descartar | No hay nada que corregir. Es parte del cambio y cumple las convenciones de `java.instructions.md`. |
| `labs/cap5/lab-5-3-pruebas-y-revision/entregables/estrategia-de-pruebas.md` | sección 4 | El documento presenta la discrepancia de bordes y dice que requiere decisión de negocio, sin resolverla | Descartar | Es correcto. Registra la pregunta para quien corresponde. |
| `labs/cap5/lab-5-3-pruebas-y-revision/entregables/estrategia-de-pruebas.md` | sección 3 | Los valores de borde de las reglas 5, 7 y 8 y de redondeo son propuestas no verificadas con pruebas ejecutadas | Decidir | Son valores razonables, pero conviene que un humano confirme, por ejemplo, el criterio de los seis meses y la zona horaria, antes de convertirlos en pruebas. |
| (varios) | (varios) | Comentario de `PlanComisiones` («tramos acumulativos») y de `CalculadoraComision` (IGV) que no coinciden con el código | Descartar | Fuera del alcance del cambio. Ya existían y el cambio no los tocó. |

No hay hallazgos en **Aplicar**: nada del cambio tiene que corregirse antes de aceptarlo.

**Recomendación: aceptar.** La refactorización conserva la salida (comparador en 0, 33 pruebas en verde), los dos archivos nuevos cumplen lo pedido, y lo pendiente son decisiones de negocio (borde del tramo y máximo del recargo) que el cambio no cierra ni debía cerrar. Lo único que hay que tener presente al aceptar es que las pruebas de borde documentan el comportamiento actual, no una regla confirmada.

Otros problemas vistos y no tocados: `Liquidacion.obtenerMontoNeto()` consulta y además asigna; `UtilidadesFecha` usa la zona horaria del sistema y la regla 8 pide hora de Lima.

### Verificación del «Salida esperada»
Tabla con las columnas Archivo, Línea, Hallazgo, Clasificación y Justificación: sí. Recomendación final: sí (aceptar). Problemas anteriores al cambio clasificados como Descartar con nota «fuera del alcance del cambio»: sí.

## Paso 4 - `/lab-5-3-paso-4-checklist-humano` (modo Agent)

Segundos: 15 (redacción del checklist; se comprobó que no existe `criterios-de-evaluacion.md`)

### Respuesta del chat (verbatim)

Creé `labs/cap5/lab-5-3-pruebas-y-revision/entregables/checklist-de-revision.md` con 15 puntos agrupados en Alcance (3), Comportamiento (3), Pruebas (3), Decisiones de negocio (3) y Lo que el agente no ve (3). Cada punto se responde con sí o no y dice cómo se verifica. No modifiqué código.

`labs/cap5/lab-5-1-preparacion/entregables/criterios-de-evaluacion.md` no existe en este repositorio (el laboratorio 5.1 no dejó entregables), así que no pude incorporar sus criterios. El punto 15 deja dicho que se revise ese documento cuando exista.

Los puntos que un agente no podría responder por sí solo son el 8 (quién decidió que lo que congelan las pruebas es lo correcto), el 10 (quién es el dueño de cada discrepancia abierta), el 13 (impacto en el dinero de comercios reales), el 14 (configuración del ambiente de producción) y el 15 (criterios acordados por el equipo). Todos dependen de contexto o de autoridad que no está en el repositorio.

Otros problemas que vi y no toqué: ninguno nuevo respecto de los pasos anteriores (borde de tramo y máximo del recargo distintos entre las dos calculadoras, zona horaria, montos en `double`).

### Archivo nuevo (contenido completo)

````markdown
# Checklist de revisión humana de un cambio hecho con ayuda de un agente

Para aplicar a un pull request. Cada punto se responde con sí o no. Un «no» en cualquier
punto de Alcance o Comportamiento detiene la aceptación hasta que se aclare.

## 1. Alcance

1. **¿El diff toca solo los archivos que la tarea nombraba?**
   Verificación: `git diff --stat` y comparar la lista con el enunciado de la tarea.
2. **¿Cada cambio del diff responde a algo que se pidió?** (sin renombres, sin reformateo, sin literales extraídos, sin tipos cambiados por iniciativa del agente)
   Verificación: leer el diff completo, no el resumen del agente; buscar líneas cambiadas que no estén dentro del bloque pedido.
3. **¿Los problemas que el agente vio y no pertenecían a la tarea están anotados y no corregidos?**
   Verificación: la respuesta del agente tiene su lista de «otros problemas» y el diff no los toca.

## 2. Comportamiento

4. **¿La salida del programa es idéntica antes y después en un cambio que no debía alterarla?**
   Verificación: `bash scripts/comparar-escenarios.sh` termina en 0 y dice «Las salidas son identicas».
5. **¿El proyecto compila y todas las pruebas pasan?**
   Verificación: `cd escenario/java && mvn -q clean package && mvn test`, o `dotnet test LiquidacionComercios.Pruebas` desde `escenario/dotnet/`; contar las pruebas y comparar con las esperadas.
6. **¿Se probó con un periodo distinto del periodo por omisión?**
   Verificación: `bash scripts/comparar-escenarios.sh --periodo 2026-05` y `--periodo 2026-04`.

## 3. Pruebas

7. **¿Cada prueba nueva declara en su nombre qué espera, y se sabe si documenta el comportamiento actual o el deseado?**
   Verificación: leer los nombres y los comentarios del archivo; el agente debe haberlo dicho en su respuesta.
8. **¿Alguien con autoridad sobre la regla decidió que lo que las pruebas congelan es lo correcto?**
   Verificación: preguntar quién lo decidió y dónde consta. Si una prueba afirma un valor que las reglas de `escenario/README.md` no definen, la respuesta es no.
9. **¿Las pruebas fallarían si el comportamiento cambiara?** (no solo ejercen el código)
   Verificación: cambiar a mano un valor de borde en el código bajo prueba, correr `mvn test` y comprobar que alguna prueba falla; revertir el cambio.

## 4. Decisiones de negocio

10. **¿Cada discrepancia entre dos partes del sistema o entre el código y las reglas está listada con su dueño?**
    Verificación: el cambio o su descripción nombra las discrepancias (por ejemplo, el borde de tramo y el máximo del recargo por cuotas) y a quién corresponde decidirlas.
11. **¿Se verificó la regla en `escenario/README.md` y no un comentario del código?**
    Verificación: para cada afirmación del agente sobre comportamiento correcto, localizar el número de regla; si solo hay un comentario como respaldo, la respuesta es no.
12. **¿Ninguna discrepancia abierta se resolvió en silencio dentro de este cambio?**
    Verificación: buscar en el diff modificaciones de `<`/`<=`, de topes o de porcentajes.

## 5. Lo que el agente no ve

13. **¿Alguien del equipo confirmó el impacto en el dinero de los comercios reales?** (el agente solo ve los datos de ejemplo)
    Verificación: una persona de negocio o de finanzas firma que los montos cambiados, si los hay, son aceptables.
14. **¿Se consideraron las restricciones del entorno que no están en el repositorio?** (zona horaria del servidor frente a la hora de Lima, cultura de la máquina, versión del JDK o del SDK de producción)
    Verificación: comparar con la configuración del ambiente donde corre el proceso de cierre.
15. **¿El cambio respeta los criterios de evaluación acordados por el equipo?**
    Verificación: revisar `labs/cap5/lab-5-1-preparacion/entregables/criterios-de-evaluacion.md` cuando exista; si el equipo todavía no lo tiene, acordarlo antes de aceptar.
````

### Verificación del «Salida esperada»
Checklist creado con entre diez y quince puntos (15), agrupado en las cinco categorías, con sí/no y modo de verificación: sí. Criterios del 5.1 incorporados: no aplica, el archivo no existe.
