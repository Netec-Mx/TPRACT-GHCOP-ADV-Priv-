# Defectos plantados en el escenario

> **Documento del relator.** No se entrega a los participantes. Si alguien lo lee antes de
> los laboratorios, los ejercicios pierden sentido.

El código de `escenario/` tiene defectos introducidos a propósito. Este documento dice
cuáles son, dónde están exactamente y qué laboratorio se apoya en cada uno.

Las ubicaciones corresponden a la implementación Java de SPEC-002. La implementación .NET
de SPEC-003 debe replicar los mismos diez defectos en los archivos equivalentes.

## Principio de diseño

El comportamiento visible es correcto. La estructura interna es mala.

El sistema compila, corre y produce resultados correctos para las reglas de negocio, con
una sola excepción deliberada: los errores de redondeo de DEF-01, que son el punto del
ejercicio. Esa combinación es lo que hace creíble el escenario, porque es exactamente lo
que los participantes tienen en producción.

## Advertencia sobre los datos de ejemplo

**Los datos fueron generados con un generador determinista de semilla fija `20260911`, que
no está versionado en este repositorio.**

Las transacciones **`TX002035`, `TX002036` y `TX002037`**, al final de
`transacciones.txt`, no son aleatorias. Se eligieron por búsqueda, una por una, para que el
acumulado de comisiones de su comercio caiga exactamente sobre un punto medio y el error de
punto flotante sobreviva al redondeo final. Son las que hacen visible a DEF-01.

Los datos originales **no** producían ninguna diferencia visible: el error existía pero el
redondeo a dos decimales lo absorbía siempre.

Consecuencias prácticas:

- **Si alguien regenera los datos, DEF-01 deja de ser demostrable** y el laboratorio que se
  apoya en él pierde su caso. El resto del escenario seguiría funcionando, así que el
  problema no se notaría hasta estar frente a la sala.
- **Si alguien borra o edita esas tres transacciones**, ocurre lo mismo.
- Cualquier cambio en la fórmula de cálculo desplaza los acumulados y también puede
  anularlas. Ya pasó una vez: al corregir el tope del recargo por cuotas de 3,5 a 3,0 hubo
  que verificar que los tres casos sobrevivieran.

Si hace falta regenerar los datos, hay que volver a buscar los montos que producen la
diferencia y actualizar la tabla de DEF-01 con los nuevos valores. No basta con correr el
generador de nuevo.

Los mismos archivos alimentan al escenario .NET, de modo que tampoco se pueden tocar sin
romper la equivalencia entre ambas implementaciones.

## Tabla resumen

| ID | Defecto | Ubicación principal | Laboratorio |
|---|---|---|---|
| DEF-01 | Dinero en punto flotante | Transversal, todo el modelo y el cálculo | 1.5, 5.2, 5.3 |
| DEF-02 | Método monstruo de 282 líneas | `CalculadoraLiquidacion.java:81` | 1.5, 5.1, 5.2 |
| DEF-03 | Números mágicos e inconsistentes | `CalculadoraLiquidacion.java`, `CalculadoraComision.java` | 2.5, 5.2 |
| DEF-04 | Fechas sin zona horaria | `UtilidadesFecha.java`, modelo completo | 1.5, 5.3 |
| DEF-05 | Pruebas que no cubren lo que importa | `src/test/`, 20 pruebas triviales | 5.3 |
| DEF-06 | Responsabilidades mezcladas | `CalculadoraLiquidacion.java` | 5.1, 5.2 |
| DEF-07 | Errores tragados en silencio | `CargadorDatos.java`, `CalculadoraLiquidacion.java` | 1.5, 5.3 |
| DEF-08 | Lógica de tramos duplicada y divergente | `CalculadoraComision.java:18` y `CalculadoraLiquidacion.java:146` | 5.1, 5.2 |
| DEF-09 | Nombres que mienten | Tres métodos en tres clases | 1.4, 1.5 |
| DEF-10 | Comentarios desactualizados | Tres comentarios de clase | 1.4, 4.4 |

---

## DEF-01. Dinero en punto flotante

**Es el defecto principal del escenario.**

Todos los montos usan `double`: `Transaccion.monto`, `Contracargo.monto`, todos los campos
de `Liquidacion` y `DetalleLiquidacion`, `TramoComision.porcentaje`, y las variables
acumuladoras del cálculo.

Ubicaciones: `modelo/Transaccion.java`, `modelo/Contracargo.java`, `modelo/Liquidacion.java`,
`modelo/DetalleLiquidacion.java`, `modelo/TramoComision.java`, `modelo/PlanComisiones.java`,
y los acumuladores de `calculo/CalculadoraLiquidacion.java`.

### Demostración con los datos incluidos

Tres comercios reciben un centavo menos del que les corresponde. La diferencia sobrevive
al redondeo final, así que es visible en la salida del programa y no solo en el depurador.

| Comercio | Acumulado en `double` | Acumulado exacto | Informa | Correcto | Diferencia |
|---|---|---|---|---|---|
| CM0011 | `137.825` | `137.825` | S/ 137.82 | S/ 137.83 | −0,01 |
| CM0016 | `493.99499999999995` | `493.995` | S/ 493.99 | S/ 494.00 | −0,01 |
| CM0025 | `957.1849999999998` | `957.185` | S/ 957.18 | S/ 957.19 | −0,01 |

**CM0011 es el caso más didáctico.** El acumulado se imprime como `137.825`, o sea que
*parece* exacto. El error no está ahí: aparece al redondear. `Math.round(137.825 * 100.0)`
evalúa `137.825 * 100.0`, que en `double` da `13782.499999999998`, no `13782.5`. El
redondeo baja en lugar de subir y el comercio pierde un centavo.

Las transacciones que producen estos tres casos son `TX002035`, `TX002036` y `TX002037`,
agregadas al final de `transacciones.txt` precisamente para que el defecto sea demostrable.

Para verificarlo en clase:

```bash
cd escenario/java
java -jar target/liquidacion-comercios.jar | grep -A 4 "Comercio CM0011"
```

Un comercio con 30.000 transacciones al mes pierde así varios soles mensuales, y el
descuadre no aparece en ninguna prueba porque no hay ninguna que cubra el acumulado.

---

## DEF-02. Método monstruo

`calculo/CalculadoraLiquidacion.java`, método `procesarLiquidacionCompleta`, línea 81.

**282 líneas** en un solo método, con hasta **nueve niveles de anidamiento** en el punto más
profundo: recorrido de comercios, comprobación de plan, recorrido de transacciones,
validación, comprobación de periodo, comprobación de estado, recorrido de tramos y las
condiciones internas.

En ese único método conviven la validación de datos, la búsqueda de tramo, el cálculo de
comisión, el recargo por cuotas, la aplicación del tope, el descuento de contracargos, el
cálculo de retención, el redondeo, el armado del resultado, la agregación estadística por
medio de pago y la impresión por consola.

---

## DEF-03. Números mágicos, con una inconsistencia real

Los valores de negocio aparecen como literales, repetidos y sin nombre:

| Valor | Dónde | Qué significa |
|---|---|---|
| `0.5` | `CalculadoraLiquidacion.java:169` y `CalculadoraComision.java:52` | Recargo porcentual por cuota |
| `3.0` | `CalculadoraLiquidacion.java:172` | Tope del recargo por cuotas |
| `3.5` | `CalculadoraComision.java:54` | Tope del recargo por cuotas |
| `0.05` | `CalculadoraLiquidacion.java:239` | Retención de garantía |
| `6` | `CalculadoraLiquidacion.java:235` | Meses de antigüedad para la retención |
| `100.0` | Ocho apariciones | Conversión de porcentaje y factor de redondeo |

**La inconsistencia está en el tope del recargo por cuotas: 3.0 en un archivo y 3.5 en el
otro.** La regla de negocio dice 3 %, así que el cierre factura bien y es
`CalculadoraComision` la que está equivocada. Como esa clase alimenta al simulador que usa
el área comercial, el comercio recibe una cotización más alta que lo que después se le
cobra, y nadie lo nota porque son procesos distintos.

Esto se cruza con DEF-08: las dos clases discrepan en el tope del recargo **y** en el borde
de los tramos. Un participante que solo unifique una de las dos diferencias deja la otra
viva.

Para verlo en clase, comparar cualquier transacción de 12, 18 o 24 cuotas: el recargo topa
en 3 % en la liquidación y en 3,5 % en el simulador. Hay 157 transacciones en cuotas en los
datos, 30 de ellas con 24 cuotas.

---

## DEF-04. Fechas sin zona horaria

`calculo/UtilidadesFecha.java` usa `Date`, `Calendar` y `SimpleDateFormat` en lugar de la
API de fecha y hora moderna. El modelo completo (`Comercio`, `Transaccion`, `Contracargo`,
`Liquidacion`) expone `Date`.

`Calendar.getInstance()` y `new SimpleDateFormat(...)` toman **la zona horaria del sistema
donde corre el proceso**, que no necesariamente es América Lima. Los límites de periodo que
calculan `inicioDePeriodo` y `finDePeriodo` se desplazan con la máquina.

La transacción `TX002005`, del 30 de junio a las 23:59:00, entra o queda fuera del periodo
según dónde se ejecute el programa. En una máquina configurada al este de Lima, cae fuera.

`SimpleDateFormat` además no es seguro entre hilos, aunque el escenario es de un solo hilo
y eso todavía no se manifiesta.

---

## DEF-05. Pruebas que no cubren lo que importa

20 pruebas en tres clases, todas verdes, todas triviales:

| Clase | Pruebas | Qué cubre |
|---|---|---|
| `ComercioTest` | 6 | Constructores, getters, setters, `toString`, tamaño de enums |
| `TransaccionTest` | 6 | Constructores, getters, setters, `toString`, tamaño de enums |
| `ValidadorFormatoTest` | 8 | Formato de registro tributario, código de autorización, identificador y periodo |

**No existe ni una sola prueba de:** selección de tramo, cálculo de comisión, recargo por
cuotas, aplicación del tope mensual, retención de garantía, descuento de contracargos,
límites del periodo ni redondeo.

El número de pruebas da una sensación de cobertura que no se corresponde con nada. Es
material directo para el laboratorio 5.3.

---

## DEF-06. Responsabilidades mezcladas

`calculo/CalculadoraLiquidacion.java` hace tres cosas que no le corresponden:

- **Lee archivos.** Instancia `CargadorDatos` en `prepararDatos` (línea 49) y otra vez
  dentro del método de cálculo (línea 87).
- **Formatea.** Tiene su propio `formatearMonto` y arma cadenas de presentación.
- **Imprime.** **25 llamadas a `System.out.println`** dentro de la clase de cálculo.

La consecuencia práctica es que no se puede probar el cálculo sin leer archivos del disco
ni capturar la salida estándar. Eso explica en parte por qué no hay pruebas de la lógica.

---

## DEF-07. Errores tragados en silencio

Cuatro bloques `catch (Exception e) { }` completamente vacíos en
`repositorio/CargadorDatos.java`, líneas 65, 95, 127 y 156, uno por cada archivo que se
carga. Hay un quinto en `cerrar`, sobre `IOException`.

Un sexto está en `calculo/CalculadoraLiquidacion.java`, en la validación del registro
tributario.

Una línea malformada en `transacciones.txt` desaparece sin dejar rastro: no se registra, no
se cuenta, no se avisa. La liquidación sale con menos transacciones y cuadra consigo misma,
así que nadie lo nota.

Para demostrarlo en clase, corromper una línea del archivo de datos y comparar el total de
transacciones cargadas.

---

## DEF-08. Lógica de tramos duplicada y divergente

La misma decisión está implementada dos veces, con una diferencia de un carácter:

| Implementación | Ubicación | Condición del borde superior |
|---|---|---|
| `CalculadoraComision.determinarTramo` | `CalculadoraComision.java:18` | `monto <= tramo.getMontoHasta()` |
| Código en línea del método monstruo | `CalculadoraLiquidacion.java:146` | `monto < tramo.getMontoHasta()` |

Las dos están vivas. La primera la usa `SimuladorComision`, que es lo que el área comercial
usa para cotizar. La segunda es la que factura en el cierre.

En cada borde de tramo del plan PL01 dan resultados distintos:

| Monto | Simulador (`<=`) | Liquidación (`<`) |
|---|---|---|
| 499.99 | 3,5 % | 3,5 % |
| **500.00** | **3,5 %** | **2,9 %** |
| 1999.99 | 2,9 % | 2,9 % |
| **2000.00** | **2,9 %** | **2,5 %** |
| **10000.00** | **2,5 %** | **2,1 %** |

Es decir: al comercio se le cotiza una comisión y se le cobra otra. Las transacciones
`TX002001` a `TX002004` están en los datos con montos de exactamente 500.00 y 2000.00 para
que el caso se pueda reproducir.

---

## DEF-09. Nombres que mienten

| Método | Ubicación | Qué dice el nombre | Qué hace en realidad |
|---|---|---|---|
| `obtenerMontoNeto()` | `modelo/Liquidacion.java:87` | Consultar un valor | **Recalcula y reasigna `montoNeto`.** Una consulta que muta estado, llamada desde dos lugares distintos |
| `buscarComerciosActivos()` | `repositorio/RepositorioMemoria.java:56` | Filtrar por estado activo | **Devuelve todos los comercios**, incluidos suspendidos y de baja. El filtro real de baja quedó disperso en el método monstruo |
| `validarTransaccion()` | `calculo/CalculadoraLiquidacion.java:56` | Validar | Valida **y además** acumula en `acumuladoGeneralTransado` e incrementa el contador de descartadas |

El caso de `buscarComerciosActivos` tiene consecuencia funcional: los comercios
`SUSPENDIDO` se liquidan igual, porque el único filtro que sobrevive en el cálculo es el de
`DE_BAJA`. En los datos, `CM0031` está suspendido y aparece en la liquidación.

---

## DEF-10. Comentarios desactualizados

| Archivo | Comentario | Realidad |
|---|---|---|
| `modelo/Comercio.java:8` | «El estado se valida en el setter contra la lista de estados permitidos» | El setter asigna sin validar nada |
| `modelo/PlanComisiones.java:9` | «Los tramos son acumulativos: el monto se reparte entre los tramos que atraviesa» | Es exactamente lo contrario. La regla 2 dice que no son acumulativos y el código aplica un único tramo |
| `calculo/CalculadoraComision.java:10` | «El monto incluye el impuesto general a las ventas, de modo que la comisión se aplica sobre el valor de venta neto» | La comisión se aplica sobre el monto completo. No hay ningún descuento de impuesto |

El de `PlanComisiones` es el más peligroso: un desarrollador que confíe en él va a
implementar el cálculo al revés. Sirve para mostrar en clase que un agente que lee el
comentario como contexto puede proponer un cambio incorrecto con total seguridad.

---

## Distribución

Ningún archivo concentra todos los defectos y todo archivo relevante tiene algo.

| Archivo | Defectos |
|---|---|
| `CalculadoraLiquidacion.java` | DEF-01, DEF-02, DEF-03, DEF-04, DEF-06, DEF-07, DEF-08, DEF-09 |
| `CalculadoraComision.java` | DEF-01, DEF-03, DEF-08, DEF-10 |
| `CargadorDatos.java` | DEF-07 |
| `UtilidadesFecha.java` | DEF-04 |
| `RepositorioMemoria.java` | DEF-09 |
| `Liquidacion.java` | DEF-01, DEF-04, DEF-09 |
| `Comercio.java` | DEF-04, DEF-10 |
| `PlanComisiones.java` | DEF-01, DEF-10 |
| `Transaccion.java`, `Contracargo.java` | DEF-01, DEF-04 |
| `src/test/` | DEF-05 |

`CalculadoraLiquidacion` es el epicentro a propósito: es la clase que los laboratorios del
capítulo 5 desarman.

## Lo que no se plantó

No hay vulnerabilidades de seguridad, inyección, credenciales, tokens ni secretos falsos.
El escenario vive en máquinas de un banco y un archivo con algo que parezca una credencial
dispara alertas que cuestan más explicaciones que el valor pedagógico que aportarían.

Tampoco hay código que no compile ni errores funcionales visibles fuera de los tres
centavos de DEF-01.
