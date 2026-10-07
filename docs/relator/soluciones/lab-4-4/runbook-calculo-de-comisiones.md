> Respaldo del paso 4 del laboratorio 4.4. Documento de referencia para el relator, escrito sin Copilot.

# Runbook: cálculo de comisiones y liquidación mensual, escenario Java

| Campo | Valor |
|---|---|
| Servicio | Cálculo de comisiones y liquidación mensual de Pasarela Andina, implementación Java (`escenario/java/`) |
| Responsable | Relator del taller. El escenario es material de laboratorio y no tiene un equipo de operación real |
| Última verificación | 2026-10-07, por el relator, en una copia limpia del repositorio de participantes (commit `1169720`), Linux sin red, OpenJDK 25.0.4.1, Apache Maven 3.9.16, zona horaria del sistema `America/Lima` |
| Documentos relacionados | `escenario/README.md` (reglas de negocio y «Cómo se ejecuta»), `labs/cap4/lab-4-4-documentacion/entregables/calculo-de-comisiones.md` (paso 1 del laboratorio), `docs/arquitectura/decisiones/0001-dos-implementaciones-con-salida-identica.md`, `docs/02-troubleshooting.md` |

## Cómo usar este runbook

Se busca el síntoma, no la causa. Cada síntoma tiene su diagnóstico, sus acciones y cuándo
escalar. Una acción que no se verificó contra una ejecución real se marca como «no
verificada», con la razón.

Todos los comandos se ejecutan desde `escenario/java/`, como indica
`escenario/README.md:59`, salvo los que dicen otra cosa. `comparar-escenarios.sh` y `git`
se ejecutan desde la raíz del repositorio.

Ninguna acción de este runbook modifica `escenario/datos/`. Los datos se leen con `grep`,
`awk` o `wc`, nunca se editan: alimentan a los dos escenarios a la vez
(`escenario/README.md:117-119`).

## Síntoma 1: la compilación del escenario Java falla

**Cómo se ve.** `mvn clean package` termina con `BUILD FAILURE` en lugar de
`BUILD SUCCESS`, o `bash scripts/comparar-escenarios.sh` se detiene con
`[FALLA] El escenario Java no compila` (`scripts/comparar-escenarios.sh:190`) y termina con
código 2 (`scripts/comparar-escenarios.sh:10`).

### Diagnóstico

1. Comprobar que el JDK y Maven están en el PATH y que el JDK es al menos el 21 que pide el
   proyecto (`escenario/java/pom.xml:20-21`).

   ```bash
   java -version
   mvn -v
   ```

   **Resultado esperado.** Una versión de Java igual o superior a 21 y una versión de Maven.
   En la verificación: `openjdk version "25.0.4.1" 2026-08-18 LTS` y
   `Apache Maven 3.9.16`.
   **Si muestra otra cosa.** «command not found» indica que la máquina no tiene el JDK o
   Maven en el PATH; una versión de Java menor que 21 no compila con
   `maven.compiler.source` 21. En ambos casos es un problema de la imagen de la máquina,
   no del código.

2. Comprobar que la única dependencia del proyecto, JUnit 5.12.2 con alcance de prueba
   (`escenario/java/pom.xml:23` y `escenario/java/pom.xml:28-31`), está en el repositorio
   local de Maven. En clase no hay descargas.

   ```bash
   ls ~/.m2/repository/org/junit/jupiter/junit-jupiter/
   ```

   **Resultado esperado.** Un directorio `5.12.2`. En la verificación apareció
   exactamente `5.12.2`.
   **Si muestra otra cosa.** Si el directorio no existe, Maven intenta descargar y falla
   sin red. La imagen de la máquina no trae las dependencias precargadas.

3. Comprobar si alguien cambió el código del escenario. Desde la raíz del repositorio:

   ```bash
   git status --short -- escenario/
   git diff --stat -- escenario/
   ```

   **Resultado esperado.** Ninguna línea en ninguno de los dos comandos. En la verificación,
   `git status --short -- escenario/` devolvió cero líneas y `git diff --stat` no mostró
   nada.
   **Si muestra otra cosa.** El escenario fue modificado, normalmente por un laboratorio
   anterior o por un agente que «arregló» algo. La falla de compilación viene de ese
   cambio, no del escenario publicado.

### Acciones

1. Compilar sin acceder a la red, con la caché local de Maven.

   ```bash
   mvn -o clean package
   ```

   **Verificado.** 2026-10-07. `mvn -o -q clean package -DskipTests` terminó con código 0 y
   dejó `target/liquidacion-comercios.jar` (40015 bytes). `mvn clean package`, el comando
   de `escenario/README.md:62`, también terminó en `BUILD SUCCESS` sin red, con
   `Tests run: 21, Failures: 0, Errors: 0, Skipped: 0`.

2. Ejecutar solo las pruebas, para separar una falla de compilación de una falla de prueba.

   ```bash
   mvn test
   ```

   **Verificado.** 2026-10-07. `Tests run: 1` en `UtilidadesFechaTest`, `6` en
   `TransaccionTest`, `6` en `ComercioTest`, `8` en `ValidadorFormatoTest`, total
   `Tests run: 21, Failures: 0, Errors: 0, Skipped: 0` y `BUILD SUCCESS`. Que las pruebas
   pasen no dice nada sobre el cálculo: cubren el modelo, el validador de formato y el fin
   del periodo, no la liquidación.

3. Si el diagnóstico 3 mostró cambios en el escenario, devolver el código Java al estado
   publicado. Desde la raíz:

   ```bash
   git restore -- escenario/java
   ```

   **No verificada.** Restaura archivos y por lo tanto los modifica; el runbook no ejecuta
   acciones que cambien archivos. Además descarta el trabajo del participante sobre ese
   directorio, así que se confirma con él antes. No usar en su lugar
   `bash scripts/reiniciar-lab.sh lab-4-4`: para este laboratorio también borra
   `labs/cap4/lab-4-4-documentacion/entregables`, donde vive este runbook
   (`scripts/reiniciar-lab.sh:79`).

### Escalamiento

Si con el diagnóstico 1 y 2 correctos y el diagnóstico 3 limpio la compilación sigue
fallando, escalar al responsable de la imagen de las máquinas virtuales con la salida de
`java -version`, `mvn -v`, las últimas 20 líneas de `mvn -o clean package` y el resultado de
`git status --short`.

## Síntoma 2: las salidas de Java y .NET no coinciden

**Cómo se ve.** `bash scripts/comparar-escenarios.sh` informa
`[FALLA] Las salidas difieren en N linea(s)` (`scripts/comparar-escenarios.sh:299`), muestra
las primeras diferencias y termina con código 1 (`scripts/comparar-escenarios.sh:10`).

### Diagnóstico

1. Repetir la comparación completa, con compilación, desde la raíz del repositorio.

   ```bash
   bash scripts/comparar-escenarios.sh
   echo $?
   ```

   **Resultado esperado.** Código 0 y el resumen
   `Escenarios equivalentes. Java y .NET producen la misma salida para 2026-06.` En la
   verificación: los dos escenarios compilaron, cada uno produjo 554 líneas, `[ OK ] Las
   salidas son identicas`, `554 lineas, 20457 bytes`, código 0.
   **Si muestra otra cosa.** Código 1 es una diferencia real de salida. Código 2 significa
   que no se pudo comparar: falta un requisito o uno de los escenarios no compila; en ese
   caso se sigue el síntoma 1.

2. Comprobar que la salida Java es la del escenario publicado, con su huella.

   ```bash
   java -jar target/liquidacion-comercios.jar | sha256sum
   ```

   **Resultado esperado.** Una huella que empieza con `61f2c13f`, el mismo valor que
   registra `escenario/java/src/main/java/pe/pasarelaandina/util/ConfiguracionRegional.java:18`
   para la salida por defecto. En la verificación:
   `61f2c13fed35a2ea2f0189dcc30e78227325bee57765baa9b1c31cff94e432eb`.
   **Si muestra otra cosa.** La salida Java cambió respecto del escenario publicado. Si la
   huella empieza con `cffb6271`, se imprimió con coma decimal
   (`escenario/java/src/main/java/pe/pasarelaandina/util/ConfiguracionRegional.java:19`):
   alguien quitó la configuración regional fija de una llamada de formateo. Cualquier otra
   huella apunta a un cambio de código o de datos; seguir con el diagnóstico 4.

3. Descartar que el idioma de la máquina afecte la salida Java.

   ```bash
   java -Duser.language=es -Duser.country=ES -jar target/liquidacion-comercios.jar | sha256sum
   ```

   **Resultado esperado.** La misma huella `61f2c13f…` del diagnóstico 2. El formateo usa
   `Locale.ROOT`
   (`escenario/java/src/main/java/pe/pasarelaandina/util/ConfiguracionRegional.java:42`).
   En la verificación la huella fue idéntica.
   **Si muestra otra cosa.** Algún formateo dejó de pasar por
   `ConfiguracionRegional.REGION_DE_SALIDA`.

4. Comprobar si alguno de los dos escenarios fue modificado. Desde la raíz:

   ```bash
   git status --short -- escenario/
   ```

   **Resultado esperado.** Ninguna línea. En la verificación, cero líneas.
   **Si muestra otra cosa.** El escenario que aparece modificado es el que se alejó del
   otro. Es el uso para el que existe el script (`escenario/README.md:111-113`).

5. Si el entorno define `JAVA_TOOL_OPTIONS`, `_JAVA_OPTIONS` o `JDK_JAVA_OPTIONS`,
   comprobar que el aviso de la JVM no es la diferencia.

   ```bash
   JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8 bash scripts/comparar-escenarios.sh --sin-compilar
   ```

   **Resultado esperado.** Código 0. El script descarta solo las líneas que empiezan con el
   aviso exacto de la JVM (`scripts/comparar-escenarios.sh:269`). En la verificación, la
   JVM escribió `Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8` y el script terminó
   igual con `[ OK ] Las salidas son identicas` y código 0.
   **Si muestra otra cosa.** Si la diferencia es una línea de aviso con otro texto, viene
   del entorno y no del cálculo.

### Acciones

1. Comparar otro periodo, para saber si la diferencia es de un periodo o general.

   ```bash
   bash scripts/comparar-escenarios.sh --periodo 2026-05
   ```

   **Verificado.** 2026-10-07. Código 0, `[ OK ] Las salidas son identicas` y
   `Escenarios equivalentes. Java y .NET producen la misma salida para 2026-05.`

2. Si la diferencia persiste con el código sin cambios, revisar los puntos que el propio
   script señala como causas habituales: redondeo, formateo de puntos medios, cultura y
   orden de iteración. Los tres primeros están resueltos en
   `escenario/dotnet/LiquidacionComercios/Util/CompatibilidadJava.cs`
   (`scripts/comparar-escenarios.sh:316`).

   **No verificada.** Es una inspección de código, no un comando, y en la verificación no
   hubo ninguna diferencia que inspeccionar.

3. Si el diagnóstico 4 mostró un escenario modificado, devolverlo al estado publicado con
   `git restore -- escenario/java` o `git restore -- escenario/dotnet` y repetir la
   comparación.

   **No verificada.** Modifica archivos. Mismas advertencias que la acción 3 del síntoma 1.

### Escalamiento

Si las salidas difieren con `git status --short -- escenario/` limpio, escalar al
responsable del escenario con la salida completa de `comparar-escenarios.sh`, el periodo, la
huella `sha256sum` de la salida Java y el sistema operativo de la máquina. Esa diferencia
contradice la decisión `docs/arquitectura/decisiones/0001-dos-implementaciones-con-salida-identica.md`
y no se resuelve en sala.

## Síntoma 3: la liquidación de un comercio no se puede explicar con las reglas de negocio

**Cómo se ve.** Un comercio no aparece en la salida, aparece con menos transacciones de las
esperadas, el total de comisiones no coincide con el que se obtiene aplicando las reglas de
`escenario/README.md:39-53`, o aparece liquidado un comercio que no debería estarlo.

### Diagnóstico

1. Comprobar qué se cargó. El programa imprime al inicio cuántos registros leyó
   (`escenario/java/src/main/java/pe/pasarelaandina/AplicacionLiquidacion.java:53-56`).
   Compararlo con las líneas de datos, sin encabezado:

   ```bash
   java -jar target/liquidacion-comercios.jar 2026-06 ../datos | head -6
   for f in comercios transacciones contracargos; do echo "$f $(tail -n +2 ../datos/$f.txt | grep -c .)"; done
   ```

   **Resultado esperado.** Los mismos números en ambos. En la verificación: el programa
   informó `Comercios    : 40`, `Transacciones: 2037`, `Contracargos : 30`, y el conteo
   sobre los archivos dio `comercios 40`, `transacciones 2037`, `contracargos 30`.
   **Si muestra otra cosa.** Si el programa cargó menos registros que líneas tiene el
   archivo, hay líneas que no se pudieron interpretar. El cargador las descarta sin
   avisar: cada lectura de línea está en un `try` con `catch` vacío
   (`escenario/java/src/main/java/pe/pasarelaandina/repositorio/CargadorDatos.java:127-128`
   para transacciones, `escenario/java/src/main/java/pe/pasarelaandina/repositorio/CargadorDatos.java:95-96`
   para comercios). El contador «Transacciones descartadas» del final no las incluye,
   porque solo cuenta las que rechaza la validación
   (`escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java:57-73`).
   Si todos los conteos son cero, ver el diagnóstico 2.

2. Comprobar que la ruta de datos es la correcta. Con una ruta inexistente el programa no
   se detiene: imprime un aviso por archivo
   (`escenario/java/src/main/java/pe/pasarelaandina/repositorio/CargadorDatos.java:131`) y
   sigue con cero registros.

   ```bash
   java -jar target/liquidacion-comercios.jar 2026-06 ../noexiste | head -10
   echo $?
   ```

   **Resultado esperado.** Este comando muestra la falla a propósito, para reconocerla. En
   la verificación imprimió
   `No se pudo leer el archivo de planes: ../noexiste/planes.txt` y los otros tres avisos,
   luego `Comercios    : 0`, `Transacciones: 0`, `Contracargos : 0`, y terminó con código
   0. El código de salida no sirve para detectar este caso; hay que leer la cabecera.
   **Si muestra otra cosa.** Si con la ruta real aparecen estos avisos, el programa se está
   ejecutando desde otro directorio. La ruta por omisión es relativa, `../datos`
   (`escenario/java/src/main/java/pe/pasarelaandina/AplicacionLiquidacion.java:29`), y
   solo funciona desde `escenario/java/`.

3. Comprobar el periodo liquidado. Sin argumentos el programa liquida 2026-06
   (`escenario/java/src/main/java/pe/pasarelaandina/AplicacionLiquidacion.java:26`) y
   muestra la ventana usada
   (`escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java:100-102`).

   ```bash
   java -jar target/liquidacion-comercios.jar 2026-06 ../datos | grep -E "Periodo:|Desde:|Hasta:"
   ```

   **Resultado esperado.** `Periodo: 2026-06`, `Desde: 01/06/2026 00:00`,
   `Hasta: 30/06/2026 23:59`, que es la ventana de la regla 8
   (`escenario/README.md:51-52`). En la verificación se obtuvo exactamente eso.
   **Si muestra otra cosa.** Un periodo distinto del que se quería revisar. Hay que tener
   en cuenta que la ventana se calcula en la zona horaria del sistema, no en la de Lima: el
   calendario se crea solo con la configuración regional
   (`escenario/java/src/main/java/pe/pasarelaandina/calculo/UtilidadesFecha.java:36-37`).
   En la verificación, ejecutar con `TZ=UTC` dio una salida idéntica a la de
   `America/Lima` para 2026-06, porque fechas y ventana se interpretan en la misma zona;
   eso no garantiza el mismo resultado con otros datos.

4. Recalcular a mano la comisión del comercio desde los datos, con las reglas 1 a 4, y
   compararla con la salida. Ejemplo con `CM0011`, que tiene el plan `PL02`
   (`escenario/datos/comercios.txt`) con tramos `0:300:4.2|300:1500:3.6|1500:8000:3.0` y
   0,25 fijo por transacción (`escenario/datos/planes.txt`):

   ```bash
   grep "^CM0011" ../datos/comercios.txt
   awk -F";" '$2=="CM0011" && $5 ~ /^2026-06/ && $8=="APROBADA" { m=$3; p=(m<300)?4.2:(m<1500?3.6:3.0); s+=m*p/100+0.25; n++ } END { printf "n=%d suma=%.6f\n", n, s }' ../datos/transacciones.txt
   java -jar target/liquidacion-comercios.jar 2026-06 ../datos | grep -A 7 "Comercio CM0011"
   ```

   **Resultado esperado.** La suma recalculada, redondeada a dos decimales medio hacia
   arriba (regla 9, `escenario/README.md:53`), igual al «Total comisiones» del programa.
   En la verificación no coincidió: el recálculo dio `n=8 suma=137.825000`, que por la
   regla 9 es S/ 137,83, y el programa informó `Transacciones liquidadas : 8` y
   `Total comisiones         : S/ 137.82`. Las ocho transacciones coinciden: el comercio
   tiene nueve en junio y una es `ANULADA`, que la regla 4 excluye.
   **Si muestra otra cosa.** Una diferencia de un centavo como esta no es un error de
   datos. Los montos se acumulan en `double` y se redondean con
   `Math.round(totalComisiones * 100.0) / 100.0`
   (`escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java:247`),
   y un acumulado que en decimal es exactamente un punto medio puede quedar apenas por
   debajo en binario y redondear hacia abajo. Se escala; no se corrige en operación.

5. Si la duda es sobre el tramo aplicado, recordar que los tramos no son acumulativos: el
   monto completo se multiplica por el porcentaje de un solo tramo (regla 2,
   `escenario/README.md:41-42`). El código hace eso: busca el primer tramo que contiene el
   monto y aplica su porcentaje al monto completo
   (`escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java:144-164`).
   El comentario de la clase `PlanComisiones` dice lo contrario
   (`escenario/java/src/main/java/pe/pasarelaandina/modelo/PlanComisiones.java:9-10`) y no
   se toma como especificación. Para montos exactamente sobre un borde de tramo:

   ```bash
   awk -F";" 'NR>1 && ($3=="500.00"||$3=="2000.00") {print $1,$2,$3,$8}' ../datos/transacciones.txt
   ```

   **Resultado esperado.** Lista las transacciones que caen justo en un borde. En la
   verificación: `TX002001 CM0001 500.00`, `TX002002 CM0001 2000.00`,
   `TX002003 CM0007 500.00` y `TX002004 CM0007 2000.00`, todas `APROBADA`.
   **Si muestra otra cosa.** Para estas transacciones el resultado depende de qué copia de
   la búsqueda de tramo se mire. La liquidación excluye el límite superior, con
   `montoTransaccion < tramo.getMontoHasta()`
   (`escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java:149`),
   así que 500,00 cae en el tramo `500:2000`. `CalculadoraComision.determinarTramo` lo
   incluye, con `monto <= tramo.getMontoHasta()`
   (`escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraComision.java:23`),
   y para el mismo monto elegiría el tramo `0:500`. Las reglas de negocio no dicen a qué
   tramo pertenece un borde. Se escala.

6. Si el comercio no debería estar liquidado por su estado, comprobar su estado en los
   datos y si aparece en la salida.

   ```bash
   cut -d";" -f6 ../datos/comercios.txt | sort | uniq -c
   grep "^CM0031" ../datos/comercios.txt
   java -jar target/liquidacion-comercios.jar 2026-06 ../datos | grep -c "Comercio CM0031"
   ```

   **Resultado esperado.** Saber qué comercios no están `ACTIVO` y si se liquidaron. En la
   verificación: 38 `ACTIVO`, 1 `DE_BAJA` y 1 `SUSPENDIDO`; `CM0031` está `SUSPENDIDO` y
   aparece una vez en la salida, liquidado.
   **Si muestra otra cosa.** El cálculo solo excluye a los comercios `DE_BAJA`
   (`escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java:110`).
   El método `buscarComerciosActivos` devuelve todos los comercios sin filtrar
   (`escenario/java/src/main/java/pe/pasarelaandina/repositorio/RepositorioMemoria.java:56-61`).
   Las reglas de negocio no dicen qué hacer con un comercio suspendido, así que la
   liquidación de `CM0031` no se puede justificar con ellas. Se escala.

### Acciones

1. Liquidar explícitamente el periodo y la ruta de datos que se quieren revisar, en lugar de
   depender de los valores por omisión.

   ```bash
   java -jar target/liquidacion-comercios.jar 2026-05 ../datos
   ```

   **Verificado.** 2026-10-07. Código 0. La cabecera mostró `Periodo: 2026-05`, el cierre
   `Comercios liquidados     : 39` y el resumen `Transacciones liquidadas  : 543`. Con
   2026-06 los mismos indicadores fueron 39 comercios y 713 transacciones, y
   `Transacciones descartadas: 0`.

2. Si la cabecera muestra cero registros o los avisos «No se pudo leer», volver a ejecutar
   desde `escenario/java/` o pasar la ruta correcta como segundo argumento.

   **Verificado.** 2026-10-07. Desde `escenario/java/` con `../datos`, la cabecera mostró 40
   comercios, 2037 transacciones y 30 contracargos. Con `../noexiste`, los cuatro avisos y
   cero registros, como en el diagnóstico 2.

3. Aislar en la salida el bloque de un comercio para adjuntarlo al escalamiento.

   ```bash
   java -jar target/liquidacion-comercios.jar 2026-06 ../datos | grep -A 8 "Comercio CM0011"
   ```

   **Verificado.** 2026-10-07. Mostró `Comercio CM0011 - Importaciones Jesus Maria S.A.C.`,
   `Transacciones liquidadas : 8`, `Total transado           : S/ 3704.73`,
   `Total comisiones         : S/ 137.82`, `Contracargos             : S/ 0.00`,
   `Retenciones              : S/ 0.00` y `Monto neto a pagar       : S/ 3566.91`.

4. No se corrige el resultado editando los datos ni el código. Si un valor parece
   incorrecto, se documenta con el diagnóstico y se escala.

   **No verificada.** No es un comando: es una restricción. Editar
   `escenario/datos/` cambiaría la salida de los dos escenarios a la vez.

### Escalamiento

Escalar al responsable del cálculo, con el periodo, el identificador del comercio, el bloque
de salida de la acción 3 y el recálculo del diagnóstico 4, en estos casos:

- Una diferencia de centavos entre el recálculo con las reglas y la salida del programa,
  como `CM0011` en 2026-06.
- Una transacción con monto exactamente en un borde de tramo, como `TX002001` a `TX002004`.
- Un comercio `SUSPENDIDO` liquidado, como `CM0031`.
- Menos registros cargados que líneas en los archivos de datos.

Ninguno de estos casos se resuelve en operación.

## Lo que este runbook no cubre

- La compilación y ejecución del escenario .NET. Tiene sus propios comandos en
  `escenario/README.md` y necesita su propio runbook.
- La simulación de comisión que se imprime al final de la salida
  (`escenario/java/src/main/java/pe/pasarelaandina/AplicacionLiquidacion.java:69-76`). Usa
  `CalculadoraComision`, cuyo tope de recargo por cuotas es 3,5
  (`escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraComision.java:53-54`),
  mientras la liquidación usa 3,0
  (`escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java:173-174`).
  Una cotización que no coincide con la liquidación se escala directamente.
- Cualquier cambio en `escenario/datos/`, incluida la regeneración de los datos. Se escala
  directamente.
- Ejecuciones en máquinas cuya zona horaria no es la de Lima. El código toma la zona del
  sistema; esta verificación solo se hizo con `America/Lima` y con `UTC`.
- La corrección de cualquiera de los comportamientos descritos en el síntoma 3. Este
  runbook diagnostica y escala; no modifica el escenario.
