# Mapeo del escenario a los dominios de servicio BIAN

## Qué es BIAN

BIAN, Banking Industry Architecture Network, es una asociación sin fines de lucro que
publica un marco de arquitectura común para la banca. Su objetivo declarado es ofrecer un
marco común para la interoperabilidad bancaria. El marco divide lo que hace un banco en
dominios de servicio, cada uno con una responsabilidad acotada, y los organiza en un
panorama de servicios.

En un banco sirve para dos cosas prácticas. Dar un vocabulario común a equipos que
construyen sistemas distintos, y decidir dónde termina la responsabilidad de un componente
y empieza la de otro. Cuando dos equipos discuten si una regla va en un servicio o en otro,
el dominio de servicio es una referencia neutral.

Este documento usa los nombres de los dominios tal como aparecen en la versión 14.0.0 de
las Semantic APIs que BIAN publica en GitHub. No reproduce sus descripciones. Para el
detalle de cada dominio, siga el enlace de la tabla.

## Pasarela Andina en una frase

Pasarela Andina adquiere las ventas de sus comercios afiliados, calcula la comisión de cada
venta según el plan del comercio, descuenta contracargos, aplica retenciones y liquida
cada mes el monto neto a pagar. Las reglas están en
[`escenario/README.md`](../../escenario/README.md).

## Dominios de servicio que se usan

| Dominio de servicio | Por qué corresponde |
|---|---|
| [Merchant Relations](https://github.com/bian-official/public/blob/main/release14.0.0/semantic-apis/oas3%20/yamls/MerchantRelations.yaml) | Mantiene las condiciones acordadas con cada comercio. En el escenario, el comercio y su plan de comisiones |
| [Merchant Acquiring Facility](https://github.com/bian-official/public/blob/main/release14.0.0/semantic-apis/oas3%20/yamls/MerchantAcquiringFacility.yaml) | Orquesta la cuenta del comercio, su actividad transaccional, la liquidación y el cobro de comisiones y cargos. Es el centro del escenario |
| [Card Transaction Capture](https://github.com/bian-official/public/blob/main/release14.0.0/semantic-apis/oas3%20/yamls/CardTransactionCapture.yaml) | Captura las transacciones con tarjeta en el punto de venta |
| [Card Case](https://github.com/bian-official/public/blob/main/release14.0.0/semantic-apis/oas3%20/yamls/CardCase.yaml) | Procesa los casos de tarjeta, típicamente un cargo desconocido. En el escenario, el contracargo |

## Mapeo de componentes

| Componente | Java | .NET | Dominio de servicio | Responsabilidad |
|---|---|---|---|---|
| Comercios | `modelo/Comercio.java`, `modelo/EstadoComercio.java`, `modelo/CategoriaNegocio.java`, `modelo/PlanComisiones.java`, `modelo/TramoComision.java` | `Modelo/Comercio.cs`, `Modelo/PlanComisiones.cs`, `Modelo/TramoComision.cs`, `Modelo/Enumeraciones.cs` | Merchant Relations | Guardar quién es el comercio, su estado y las condiciones de su plan de comisiones |
| Transacciones | `modelo/Transaccion.java`, `modelo/EstadoTransaccion.java`, `modelo/MedioPago.java` | `Modelo/Transaccion.cs`, `Modelo/Enumeraciones.cs` | Card Transaction Capture | Representar cada venta autorizada con su monto, sus cuotas, su estado y su medio de pago |
| Cálculo de comisiones | `calculo/CalculadoraComision.java`, `calculo/SimuladorComision.java` | `Calculo/CalculadoraComision.cs`, `Calculo/SimuladorComision.cs` | Merchant Acquiring Facility | Calcular la comisión de una transacción según el plan del comercio |
| Contracargos | `modelo/Contracargo.java`, `modelo/EstadoContracargo.java`, `modelo/MotivoContracargo.java` | `Modelo/Contracargo.cs`, `Modelo/Enumeraciones.cs` | Card Case | Representar el desconocimiento de un cargo, su motivo y su estado |
| Retenciones | `calculo/CalculadoraLiquidacion.java` | `Calculo/CalculadoraLiquidacion.cs` | Merchant Acquiring Facility | Retener una parte del monto neto de los comercios recién afiliados |
| Liquidación | `calculo/CalculadoraLiquidacion.java`, `modelo/Liquidacion.java`, `modelo/DetalleLiquidacion.java`, `reporte/FormateadorReporte.java` | `Calculo/CalculadoraLiquidacion.cs`, `Modelo/Liquidacion.cs`, `Modelo/DetalleLiquidacion.cs`, `Reporte/FormateadorReporte.cs` | Merchant Acquiring Facility | Cerrar el mes de cada comercio y producir el monto neto a pagar |

Las rutas Java son relativas a `escenario/java/src/main/java/pe/pasarelaandina/`. Las rutas
.NET son relativas a `escenario/dotnet/LiquidacionComercios/`.

## Observaciones del mapeo

**Una clase reúne responsabilidades de varios dominios.** `CalculadoraLiquidacion`, en las
dos implementaciones, aplica las comisiones del periodo, descuenta los contracargos
aprobados, aplica la retención y arma la liquidación. En términos de BIAN, combina
responsabilidades de Merchant Acquiring Facility con el uso del resultado de Card Case. Un
diseño que separe esas responsabilidades tendría que decidir dónde vive cada una.

**Las retenciones no tienen un dominio propio en este mapeo.** Se asignaron a Merchant
Acquiring Facility porque forman parte de la liquidación al comercio. Si un equipo necesita
modelarlas como servicio aparte, conviene revisar el panorama completo de BIAN antes de
elegir otro dominio.

**No todos los medios de pago son tarjetas.** El escenario incluye billetera móvil, y los
dominios de captura y de casos usados aquí son de tarjeta. El mapeo los usa como la
referencia más cercana.

**Liquidación al comercio no es liquidación entre bancos.** BIAN tiene además el dominio
[Card Financial Settlement](https://github.com/bian-official/public/blob/main/release14.0.0/semantic-apis/oas3%20/yamls/CardFinancialSettlement.yaml),
que se ocupa de la liquidación entre emisores y adquirentes a través de las redes de
tarjetas. El escenario no hace eso, y por eso no aparece en el mapeo.

## Fuentes

| Qué | Fuente | Consultada |
|---|---|---|
| Objetivo de BIAN | https://bian.org/about-bian/ | 3 de octubre de 2026 |
| Panorama de servicios, versión vigente 14.0 | https://bian.org/deliverables/service-landscape/ | 3 de octubre de 2026 |
| Nombres y ámbito de los dominios de servicio, versión 14.0.0, licencia Apache-2.0 | https://github.com/bian-official/public | 3 de octubre de 2026 |
