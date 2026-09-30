# Escenario: Pasarela Andina

Sistema de liquidación de comisiones de una procesadora de pagos ficticia. Es la base de
código sobre la que se trabaja durante todo el taller.

El escenario existe en dos implementaciones equivalentes, una en Java y otra en .NET, que
resuelven el mismo dominio con las mismas reglas y leen los mismos datos. Un participante
de cada stack hace el mismo ejercicio en su propio lenguaje y ambos pueden comparar
resultados en sala.

> Pasarela Andina no corresponde a ninguna institución real. Los comercios, montos y
> transacciones son generados.

## Qué hace el sistema

Pasarela Andina procesa las ventas de los comercios afiliados a su plataforma. Al cierre
de cada mes calcula cuánto le corresponde cobrar a cada comercio por concepto de
comisiones, le descuenta los contracargos del periodo, aplica las retenciones que
correspondan y produce una liquidación con el monto neto a pagar.

Todos los montos están en soles peruanos con dos decimales. El huso horario de referencia
es América Lima.

## Entidades

| Entidad | Qué representa |
|---|---|
| Comercio | Afiliado a la plataforma, con su plan de comisiones asignado |
| Plan de comisiones | Tarifario por tramos, con monto fijo por transacción y tope mensual |
| Transacción | Una venta autorizada a través de la pasarela |
| Contracargo | Desconocimiento de un cargo por parte del tarjetahabiente |
| Liquidación | Resultado del cierre mensual para un comercio |

## Reglas de negocio

Estas son las reglas que el sistema debe cumplir. Son la verdad funcional del dominio y
conviene tenerlas a mano durante los laboratorios.

1. La comisión de una transacción se calcula aplicando el porcentaje del tramo que
   corresponde a su monto, más el monto fijo por transacción.
2. Los tramos **no son acumulativos**. El monto completo de la transacción se multiplica
   por el porcentaje del tramo en que cae.
3. Las transacciones en cuotas tienen un recargo del 0,5 % adicional por cada cuota sobre
   la primera, con un máximo de 3 %.
4. Las transacciones anuladas no generan comisión.
5. Los contracargos aprobados se descuentan del periodo en que se aprueban, no del
   periodo de la transacción original.
6. Si el total de comisiones del mes supera el tope del plan, se cobra el tope.
7. Un comercio con menos de seis meses de afiliación tiene una retención de garantía del
   5 % sobre el monto neto.
8. El periodo de liquidación va desde el primer día del mes a las 00:00:00 hasta el último
   día a las 23:59:59, en hora de Lima.
9. Todo monto en soles se redondea a dos decimales, medio hacia arriba.

## Cómo se ejecuta

### Java

Desde `escenario/java/`:

```bash
mvn clean package
java -jar target/liquidacion-comercios.jar
```

Se puede indicar otro periodo y otro directorio de datos:

```bash
java -jar target/liquidacion-comercios.jar 2026-05 datos
```

Para correr solo las pruebas:

```bash
mvn test
```

### .NET

Desde `escenario/dotnet/`:

```bash
dotnet build LiquidacionComercios -c Release
dotnet LiquidacionComercios/bin/Release/net8.0/LiquidacionComercios.dll
```

Se puede indicar otro periodo y otro directorio de datos:

```bash
dotnet LiquidacionComercios/bin/Release/net8.0/LiquidacionComercios.dll 2026-05 ../datos
```

Para correr solo las pruebas:

```bash
dotnet test LiquidacionComercios.Pruebas
```

Cada escenario se ejecuta **desde su propio directorio**, porque la ruta a los datos
compartidos es relativa y la misma en ambos.

### Comprobar que ambos coinciden

Los dos escenarios deben producir exactamente la misma salida. Hay un script que lo
verifica:

```bash
bash scripts/comparar-escenarios.sh
```

Termina en cero si las salidas son idénticas y en uno si difieren, mostrando en qué línea.
Si vas a modificar uno de los dos escenarios durante un laboratorio, este script te dice si
te alejaste del otro.

## Datos de ejemplo

Los datos viven en `escenario/datos/` como archivos de texto plano separados por punto y
coma, con una línea de encabezado. Están fuera de `java/` y de `dotnet/` a propósito: son de
los dos y de ninguno. No hay base de datos: todo se carga en memoria al arrancar.

| Archivo | Contenido |
|---|---|
| `planes.txt` | 4 planes de comisiones con sus tramos |
| `comercios.txt` | 40 comercios afiliados |
| `transacciones.txt` | 2.037 transacciones en tres periodos mensuales |
| `contracargos.txt` | 30 contracargos en distintos estados. La fecha de cada contracargo es la de su aprobación |

Los periodos cubiertos son 2026-04, 2026-05 y 2026-06. El periodo por omisión del
ejecutable es **2026-06**.

Los mismos archivos alimentan las dos implementaciones, que producen resultados idénticos
hasta el último centavo. Eso está verificado por `scripts/comparar-escenarios.sh` y no es
una aspiración: es un criterio que se comprueba.

## Antes de empezar a trabajar

Este código es material de un taller y tiene características que fueron elegidas a
propósito para que haya algo que hacer durante los laboratorios. No lo tomes como un
ejemplo de buenas prácticas ni te adelantes a arreglar lo que te parezca mejorable.

Cada laboratorio te va a decir exactamente sobre qué trabajar. Haz eso y nada más. La
explicación completa está en [`AGENTS.md`](../AGENTS.md), en la raíz del repositorio, y
también aplica a cualquier agente que ejecutes sobre este directorio.
