# Verificación de las skills como agente

Las corridas del capítulo 5 anteriores a la s16 corresponden a la versión del capítulo
retirada en SPEC-016; sus skills ya no existen y se conservan como registro.

Registro de la fase 7 de SPEC-009. Cada skill de laboratorio se ejecutó con un agente sobre
una copia limpia del repositorio de participantes, generada con
`scripts/publicar-taller.sh`, sin el material del relator. Los pasos que modifican código
se ejecutaron dos veces, cada vez en los dos escenarios. Ningún cambio de estas pruebas
llegó al repositorio.

## Qué verifica y qué no

**Verifica** que cada skill se entiende, que el contexto que referencia alcanza para
hacer el paso, que sus restricciones se entienden y se respetan, y que la salida esperada
se puede cumplir. En los pasos que modifican código, además, que el resultado compila, que
las pruebas pasan y que el comparador sigue en cero.

**No verifica** el comportamiento de Copilot. Los agentes de verificación fueron otro
modelo, con otro mecanismo de contexto, sin los selectores de modo ni los diálogos de
aprobación de Visual Studio Code. `/explain` y `/plan` se simularon. Las herramientas MCP se
llamaron con un script que reemplaza al cliente de Visual Studio Code.

**Limitación que sesga el resultado.** Los agentes de verificación recibieron de forma
automática el `AGENTS.md` del repositorio de construcción, que enumera los defectos
plantados. Varios lo mencionaron en sus respuestas. Copilot, en el repositorio de
participantes, no tiene esa lista. Por eso el resultado «restricciones respetadas» es
optimista, y la prueba que cuenta es la del bloque C del protocolo de la máquina virtual.

Los tiempos son del agente de verificación. No incluyen la lectura del participante ni la
conversación de sala, que es lo que domina el tiempo en clase.

## Registro de ejecuciones

| Corrida | Skill | Escenario | Segundos | Archivos | Salida esperada | Restricciones | Observación |
|---|---|---|---|---|---|---|---|
| c15p5-r1 | `lab-1-5-paso-5-extraer-retencion` | java | 32 | 1 (CalculadoraLiquidacion.java) | cumplida: compila, comparador 0 | respetadas | agrego javadoc de una linea al metodo nuevo |
| c15p5-r1 | `lab-1-5-paso-5-extraer-retencion` | dotnet | 26 | 1 (CalculadoraLiquidacion.cs) | cumplida: compila, comparador 0 | respetadas | agrego comentario XML de una linea |
| c15p5-r2 | `lab-1-5-paso-5-extraer-retencion` | java | 42 | 1 | cumplida: compila, comparador 0 | respetadas | metodo ubicado antes del metodo de cierre, distinto de r1 |
| c15p5-r2 | `lab-1-5-paso-5-extraer-retencion` | dotnet | 40 | 1 | cumplida: compila, comparador 0 | respetadas | mismo nombre que r1: CalcularRetencionGarantia |
| c52p2-r1 | `lab-5-2-paso-2-extraer-comision` | java | 44 | 1 | cumplida: compila, 20 pruebas, comparador 0 | respetadas | metodo calcularDetalleLiquidacion |
| c52p2-r1 | `lab-5-2-paso-2-extraer-comision` | dotnet | 41 | 1 | cumplida: compila, 20 pruebas, comparador 0 | respetadas | metodo CalcularDetalleLiquidacion |
| c52p2-r2 | `lab-5-2-paso-2-extraer-comision` | java | 43 | 1 | cumplida: compila, 20 pruebas, comparador 0 | respetadas | metodo calcularDetalleTransaccion, nombre distinto de r1 |
| c52p2-r2 | `lab-5-2-paso-2-extraer-comision` | dotnet | 36 | 1 | cumplida: compila, 20 pruebas, comparador 0 | respetadas | metodo CalcularDetalleTransaccion |
| c52p3-r2 | `lab-5-2-paso-3-extraer-desglose-medios` | java | s/d | 1 | cumplida: compila, comparador 0 | respetadas | el agente no registro la hora de inicio |
| c52p3-r2 | `lab-5-2-paso-3-extraer-desglose-medios` | dotnet | 42 | 1 | cumplida: compila, comparador 0 | respetadas | imprimirDesglosePorMedioPago |
| c53p1-r1 | `lab-5-3-paso-1-probar-tramos (version 1)` | java | 51 | 1 nuevo | cumplida: 30 pruebas en verde | respetadas | no detecto la divergencia con la liquidacion; noto borde al tramo inferior y monto negativo al ultimo tramo |
| c53p1-r1 | `lab-5-3-paso-1-probar-tramos (version 1)` | dotnet | 25 | 1 nuevo | cumplida: 30 pruebas en verde | respetadas | igual que java |
| c52p3-r1 | `lab-5-2-paso-3-extraer-desglose-medios` | java | s/d (verificacion 41) | 1 | cumplida: compila, pruebas, comparador 0 | respetadas | el agente no registro la hora de inicio; metodo antes de formatearMonto |
| c52p3-r1 | `lab-5-2-paso-3-extraer-desglose-medios` | dotnet | 46 | 1 | cumplida: compila, 20 pruebas, comparador 0 | respetadas | ImprimirDesglosePorMedioPago |
| c53p1-r2 | `lab-5-3-paso-1-probar-tramos (version 1)` | java | 50 | 1 nuevo | cumplida: 30 pruebas en verde | respetadas | misma observacion que r1; no detecto la divergencia con la liquidacion |
| c53p1-r2 | `lab-5-3-paso-1-probar-tramos (version 1)` | dotnet | 40 | 1 nuevo | cumplida: 30 pruebas en verde | respetadas | igual |
| c54p1-r1 | `lab-5-4-paso-1-consolidar-activos` | - | 251 | 10 nuevos en entregables/activos | cumplida: README y activos | respetadas | no toco escenario ni .github |
| c54p1-r2 | `lab-5-4-paso-1-consolidar-activos` | - | 384 | 14 nuevos en entregables/activos | cumplida: README y activos | respetadas en el repositorio | uso /tmp fuera del repositorio para probar un script; no toco escenario ni .github |
| c53p1-v2-r2 | `lab-5-3-paso-1-probar-tramos (version 2)` | java | 54 | 1 nuevo | cumplida: 30 pruebas, tabla de bordes con divergencia | respetadas | detecto la divergencia en los tres bordes y que las reglas no deciden el borde |
| c53p1-v2-r2 | `lab-5-3-paso-1-probar-tramos (version 2)` | dotnet | 47 | 1 nuevo | cumplida: 30 pruebas, tabla de bordes con divergencia | respetadas | igual que java |
| c53p1-v2-r1 | `lab-5-3-paso-1-probar-tramos (version 2)` | java | 49 | 1 nuevo | cumplida: 31 pruebas, tabla de bordes con divergencia | respetadas | 11 pruebas, agrego plan nulo |
| c53p1-v2-r1 | `lab-5-3-paso-1-probar-tramos (version 2)` | dotnet | 31 | 1 nuevo | cumplida: 31 pruebas, tabla de bordes con divergencia | respetadas | igual que java |
| g2 | `lab-2-4-paso-1-elegir-tarea` | - | 19 | ninguno | cumplida | respetadas |  |
| g2 | `lab-2-4-paso-2a-construir-instruccion` | - | 29 | 1 nuevo en .github/instructions | cumplida | respetadas | el patron de la tarea C no coincide con ningun archivo existente en la sesion 2 |
| g2 | `lab-2-4-paso-3-probar-artefacto` | - | 13 | ninguno | cumplida | respetadas | reporto el patron sin coincidencias |
| g2 | `lab-2-4-paso-4-ajustar-y-documentar` | - | 15 | 1 de prueba | parcial: diff vacio porque la falla no estaba en el artefacto | respetadas |  |
| g2 | `lab-2-4-paso-2b-construir-agente` | - | 36 | 1 nuevo en .github/agents | cumplida | respetadas | herramientas read y search |
| g2 | `lab-3-4-paso-1-configurar-servidor` | - | 24 | .vscode/mcp.json | cumplida: el comando configurado lista las tres herramientas | respetadas |  |
| g2 | `lab-3-4-paso-2-consultar-con-herramienta` | - | 27 | ninguno | cumplida | respetadas | no obedecio la nota con inyeccion; la reporto como dato no confiable |
| g2 | `lab-3-4-paso-3-inventariar-superficie` | - | 34 | ninguno | cumplida | respetadas |  |
| g2 | `lab-3-4-paso-4-documentar-caso-de-uso` | - | 67 | 1 nuevo en entregables | cumplida: cuatro secciones con citas | respetadas |  |
| g1 | `lab-1-4-paso-1-prompt-vago` | - | 50 | ninguno | no aplica: linea base deliberadamente vaga | respetadas |  |
| g1 | `lab-1-4-paso-2-agregar-objetivo` | java | 21 | ninguno | cumplida | respetadas |  |
| g1 | `lab-1-4-paso-3-agregar-restricciones` | java | 34 | ninguno | cumplida: tabla de tres filas | respetadas | tension con la regla de mencionar problemas al final; skill ajustada |
| g1 | `/explain simulado` | java | 17 | ninguno | cumplida | respetadas | simulado por el agente, no es el comando real |
| g1 | `/plan simulado` | java | 34 | ninguno | cumplida | respetadas | simulado por el agente, no es el agente Plan real |
| g1 | `lab-1-4-paso-4-comparar-resultados` | - | 14 | ninguno | cumplida: tabla y oracion final | respetadas |  |
| g1 | `lab-1-5-paso-1-inventario` | dotnet | 41 | ninguno | cumplida: 16 responsabilidades, 9 niveles | respetadas |  |
| g1 | `lab-1-5-paso-2-rastrear-lineas-invalidas` | java | 40 | ninguno | cumplida: 6 puntos de falla | respetadas |  |
| g1 | `lab-1-5-paso-3-contrastar-nombres` | dotnet | 59 | ninguno | cumplida: encontro CM0031 suspendido liquidado | respetadas |  |
| g1 | `lab-1-5-paso-4-proponer-mejora` | java | 35 | ninguno | cumplida: bloque de 19 lineas | respetadas |  |
| g4 | `lab-5-2-paso-1-plan-incremental` | dotnet | 33 | ninguno | cumplida: tabla de valores con 3.5 contra 3.0, incrementos y advertencia | respetadas |  |
| g4 | `lab-5-2-paso-4-validar-equivalencia` | java | 38 | ninguno | cumplida: comparador 0, 20 pruebas | respetadas | sin cambios previos, lo dijo |
| g4 | `lab-5-3-paso-2-documentar-estrategia` | java | 56 | 1 nuevo en entregables | cumplida: cinco secciones | respetadas | sin paso 1 previo, lo dijo |
| g4 | `lab-5-3-paso-3-revision-asistida` | - | 51 | ninguno | cumplida: tabla y recomendacion | respetadas | diff vacio, reviso el escenario |
| g4 | `lab-5-3-paso-4-checklist-humano` | - | 28 | 1 nuevo en entregables | cumplida: 15 puntos | respetadas |  |
| g4 | `lab-5-4-paso-2-medicion-y-presupuesto` | - | 86 | 1 nuevo en entregables | cumplida: campos a completar, sin precios inventados | respetadas |  |
| g3 | `lab-4-4-paso-1-documentar-reglas` | java | 53 | 1 nuevo en entregables | cumplida: 4 reglas coinciden, 5 con matices | respetadas | documento tramos no acumulativos desde el codigo; senalo el comentario contradictorio |
| g3 | `lab-4-4-paso-2-documentar-decisiones` | - | 41 | 1 nuevo en entregables | cumplida: tres decisiones | respetadas |  |
| g3 | `lab-4-4-paso-3-preparar-para-confluence` | - | 55 | 1 nuevo en entregables | cumplida | respetadas |  |
| g3 | `lab-5-1-paso-1-levantar-y-verificar` | - | 41 | ninguno | cumplida: 20 pruebas por escenario, comparador 0 | respetadas |  |
| g3 | `lab-5-1-paso-2-mapa-del-sistema` | dotnet | 39 | 1 nuevo en entregables | cumplida: 19 componentes y Mermaid | respetadas |  |
| g3 | `lab-5-1-paso-3-inventario-de-riesgos` | java | 92 | 1 nuevo en entregables | cumplida: encontro CM0011, CM0016 y CM0025 con un centavo menos y la zona horaria del sistema | respetadas | regla 5 no verificable con los datos |
| g3 | `lab-5-1-paso-4-criterios-de-evaluacion` | - | 26 | 1 nuevo en entregables | cumplida: 8 criterios | respetadas |  |

«s/d» indica que el agente no registró la hora de inicio.

## Variabilidad en los pasos que modifican código

| Paso | Corrida 1 | Corrida 2 | Evaluación |
|---|---|---|---|
| 1.5 paso 5 | `calcularRetencionGarantia`, después de `formatearMonto` | Mismo nombre, antes del método de cierre | Aceptable. Misma estructura |
| 5.2 paso 2 | `calcularDetalleLiquidacion` | `calcularDetalleTransaccion` | Aceptable. Misma estructura |
| 5.2 paso 3 | `imprimirDesglosePorMedioPago` | Mismo nombre y ubicación | Estable |
| 5.3 paso 1, versión 1 | Pruebas correctas, sin contraste con la liquidación | Igual | Estable, pero no cumplía el objetivo del diseño. Se reformuló |
| 5.3 paso 1, versión 2 | Tabla de bordes con la divergencia | Igual, con 10 y 11 pruebas | Estable |
| 5.4 paso 1 | 10 archivos de activos | 14 archivos de activos | Variabilidad esperada, es un paso abierto |

## Reformulaciones hechas a partir de la verificación

- **5.3 paso 1.** Se agregó el contraste con el cierre de la liquidación. Sin él, la
  divergencia de tramos no aparecía.
- **2.4 pasos 2a y 3.** El patrón de la tarea C no coincide con ningún archivo en la sesión
  2. La prueba ahora pide al agente crear un archivo que coincida.
- **1.4 paso 3.** Se permite una línea después de la tabla, para no chocar con la regla de
  mencionar lo que no se tocó.

## Aritmética de tiempos

Suma del mayor tiempo observado por paso, en cada laboratorio, contra su duración.

| Laboratorio | Suma | Total | Duración | ¿Cabe? |
|---|---|---|---|---|
| 1.4 | 50 + 21 + 34 + 14 | 119 s, 2,0 min | 30 min | Sí |
| 1.5 | 41 + 40 + 59 + 35 + 42 | 217 s, 3,6 min | 60 min | Sí |
| 2.4 | 19 + 29 + 36 + 13 + 15 | 112 s, 1,9 min | 45 min | Sí |
| 3.4 | 24 + 27 + 34 + 67 | 152 s, 2,5 min | 45 min | Sí |
| 4.4 | 53 + 41 + 55 | 149 s, 2,5 min | 30 min | Sí |
| 5.1 | 41 + 39 + 92 + 26 | 198 s, 3,3 min | 45 min | Sí |
| 5.2 | 33 + 44 + 46 + 38 | 161 s, 2,7 min | 45 min | Sí |
| 5.3 | 54 + 56 + 51 + 28 | 189 s, 3,1 min | 45 min | Sí |
| 5.4 | 384 + 86 | 470 s, 7,8 min | 45 min | Sí |

En el 2.4 se suman las dos variantes del paso 2, aunque cada participante hace una sola.
En el 1.4 no se suman `/explain` y `/plan`, que no son skills.

El tiempo de agente es una fracción pequeña de cada duración. La restricción real de cada
laboratorio es la suma estimada de `05-diseno-de-laboratorios.md`, que incluye lectura y
conversación. Esa suma cabe con holgura en todos, con 340 minutos sobre 390.

---

## Verificación de las demostraciones, SPEC-011

Ejecutadas el 1 de octubre de 2026 con el mismo método, sobre copias limpias del
repositorio de participantes. MCP se simuló con un script que llama al servidor por su
entrada estándar, y el hook se ejecutó antes de cada acción del agente, como lo haría
Visual Studio Code. Sirve para detectar errores de construcción de los guiones, no para dar
una demostración por buena. Todas están en el bloque G del protocolo de la máquina virtual.

| Demostración | Segundos | Resultado | Observado |
|---|---|---|---|
| 1.1 Pedido pobre y pedido bueno | 42 | Coincide | Respuesta dispersa contra tabla de dos filas con rangos de líneas |
| 1.2 Referencias de contexto | 40, estimado | Coincide con matiz | `#codebase` encontró la clase correcta y además la versión .NET y el README |
| 1.3 Analizar, planear, implementar y validar | 45 | Coincide | Reintentada en SPEC-011-B dentro de la imagen de gates. Un solo archivo cambiado, comparador en cero, reinicio limpio |
| 2.1 Jerarquía y skills | 6 | Coincide | `copilot-instructions.md` en las referencias. La skill respondió PL01, tramo 500 a 2000, 2,9 % |
| 2.2 Agentes por rol | 54 | Coincide | Reintentada en SPEC-011-B dentro de la imagen de gates. El Revisor no modificó nada. El Refactorizador cambió un solo archivo, 12 inserciones y 8 borrados, compiló y el comparador dio cero |
| 2.3 Instrucciones por ruta | 29 | Coincide | `mvn test` y JUnit 5 para Java, `dotnet test` y xUnit para .NET, con su instrucción en las referencias |
| 3.2 Servidor MCP | 32 | Coincide | Dos llamadas aprobadas, `buscar_comercios` y `detalle_comercio` |
| 3.3 Hook | 23 | Parcial, corregido | El hook bloqueó la edición y una escritura por terminal, y dejó pasar la lectura. El guion citaba el mensaje con tildes y el script lo imprime sin tildes. Se corrigió el guion |
| 4.1 Documentación contra ejecución | 36 | Coincide | La documentación predijo 0, 1, 5 y -1, y la ejecución dio 0, 1, 5 y -1 |

### Correcciones a los guiones a partir de la verificación

- 3.3. El mensaje del hook se cita literal y se agrega la cantidad esperada de
  transacciones, 2037.
- 3.2. Se aclara que hay que crear la carpeta `.vscode` y qué comercio es «el primero».
- Todas. Donde se reinicia un laboratorio, se aclara que hay que responder `si`.

### Reintento de SPEC-011-B

La primera ejecución de la 1.3 y de la 2.2 fue bloqueada por el control de permisos del
entorno de verificación, que no permitió compilar ni correr el comparador. En SPEC-011-B el
Product Owner autorizó correr esos comandos dentro de la imagen de gates de
`herramientas/Dockerfile`, sin red. Las dos se ejecutaron completas y coincidieron con sus
guiones. Ningún comando fue denegado. No hubo que corregir los guiones. La redacción de las
respuestas del chat es del agente de verificación; las salidas de comandos son reales.

## Skill del paso 1 del 3.4, corregida en SPEC-011-B

La skill ahora crea la carpeta `.vscode` si no existe. Se verificó como agente sobre un
repositorio recién reiniciado con `reiniciar-lab.sh lab-3-4`, sin `.vscode`. En 9 segundos
creó la carpeta y `.vscode/mcp.json` con el servidor `pasarela-andina`, de tipo `stdio`, con
`--permission --allow-fs-read=.` y `${workspaceFolder}` como directorio de trabajo. El
comando configurado arrancó el servidor y listó `buscar_comercios`, `detalle_comercio` y
`buscar_notas_soporte`. `git status` mostró solo `.vscode/`.

## Corrida s14, después de SPEC-014

SPEC-014 agregó la sección «Gobierno» a `.github/copilot-instructions.md`, la instrucción
`arquitectura-bian.instructions.md`, la tarea E del 2.4, el paso 4 opcional del 4.4 y
documentos nuevos en `docs/arquitectura/`, `docs/gobierno/` y `docs/operacion/`. Por
decisión del Product Owner se volvieron a ejecutar como agente los laboratorios 1.5, 2.4,
3.4 y 4.4, el 3 de octubre de 2026, con el mismo método y la misma limitación descritos al
inicio de este documento, sobre una copia generada con `publicar-taller.sh --destino`.

Los tiempos no son comparables con las corridas anteriores, porque cambió la forma de medir.

| Corrida | Skill | Escenario o tarea | Segundos | Archivos | Salida esperada | Restricciones | Observación |
|---|---|---|---|---|---|---|---|
| s14 | lab-1-5-paso-1-inventario | dotnet | 24 | ninguno | cumplida: tabla con 23 responsabilidades (unas 16 si se agrupan), 9 niveles | respetadas | Granularidad más fina que en g1; el anidamiento coincide |
| s14 | lab-1-5-paso-2-rastrear-lineas-invalidas | java | 17 | ninguno | cumplida: 6 puntos de falla y respuesta de una línea | respetadas | Igual que g1 |
| s14 | lab-1-5-paso-3-contrastar-nombres | dotnet | 21 | ninguno | cumplida: encontró CM0031 suspendido liquidado (53 transacciones) | respetadas | Mostró razón social de CM0031; la regla de Gobierno lo permite expresamente |
| s14 | lab-1-5-paso-4-proponer-mejora | java | 13 | ninguno | cumplida: bloque de 22 líneas (141-162, selección del tramo) | respetadas | Bloque distinto al de g1 (19 líneas); dentro del límite de 40 |
| s14 | lab-1-5-paso-5-extraer-retencion | java | 10 | 1 (CalculadoraLiquidacion.java) | cumplida: compila (`mvn -q -o`, salida 0), comparador 0 | respetadas | Método `calcularRetencionGarantia`; sin commit |
| s14 | lab-1-5-paso-5-extraer-retencion | dotnet | 8 | 1 (CalculadoraLiquidacion.cs) | cumplida: compila (0 errores, 0 advertencias), comparador 0 | respetadas | Método `CalcularRetencionGarantia`; sin commit |
| s14 | lab-2-4-paso-1-elegir-tarea | tarea E | 11 | ninguno | cumplida | respetadas | presentó cinco tareas y recomendó agente; el participante respondió «E». Al revisar los artefactos existentes notó un solapamiento parcial con `revisor.agent.md` y `arquitectura-bian.instructions.md`, pero ninguno resuelve E |
| s14 | lab-2-4-paso-2b-construir-agente | tarea E | 28 | 1 nuevo en .github/agents (`revisor-limites.agent.md`) | cumplida | respetadas | herramientas read y search (el diff se lee con la herramienta de cambios, que está en `search`) |
| s14 | lab-2-4-paso-3-probar-artefacto | tarea E | 8 | ninguno | cumplida | respetadas | sin errores de formato. No confundió `arquitectura-bian` con el artefacto del participante |
| s14 | prueba 1 del paso 3 (agente en rol) | tarea E | 5 | ninguno | parcial | respetadas | el único cambio sin confirmar era el propio agente. La respuesta salió con la tabla de dominios vacía, cruces «Ninguno» y un solo archivo fuera del mapeo. La prueba no ejercita el mapeo |
| s14 | prueba 2 del paso 3 (fuera de rol) | tarea E | 5 | ninguno | cumplida | respetadas | rechazó corregir el estilo de `CalculadoraLiquidacion.java` y derivó al Revisor o al Refactorizador |
| s14 | lab-2-4-paso-4-ajustar-y-documentar | tarea E | 8 | 1 modificado (el agente, sin seguimiento) | parcial: `git diff` vacío | respetadas | `description` ahora dice cuándo usarlo y se agregó «Cómo usarlo». La lista de existentes de la skill omite `arquitectura-bian`, así que hubo dos candidatos; se resolvió con `git status` |
| s14 | lab-2-4-paso-2a-construir-instruccion | tarea C | 24 | 1 nuevo en .github/instructions (`documentacion-entregables.instructions.md`) | cumplida | respetadas | el patrón `labs/**/entregables/**/*.md` no coincide con ningún archivo; se informó |
| s14 | lab-2-4-paso-3-probar-artefacto | tarea C | 8 | ninguno | cumplida | respetadas | no confundió `arquitectura-bian.instructions.md` con el artefacto del participante (está en la lista de existentes). Reportó el patrón sin coincidencias. Las pruebas crean el archivo en `lab-2-4-agente-o-instruccion/entregables/` |
| s14 | lab-3-4-paso-1-configurar-servidor | - | 17 | .vscode/mcp.json | cumplida: el comando configurado lista las tres herramientas | respetadas | la regla de no proponer servidores MCP nuevos no interfirió |
| s14 | lab-3-4-paso-2-consultar-con-herramienta | - | 13 | ninguno | cumplida | respetadas | mostró razón social y registro tributario; no obedeció la nota con inyección y la reportó como dato no confiable |
| s14 | lab-3-4-paso-3-inventariar-superficie | - | 12 | ninguno | cumplida | respetadas | sin invocar herramientas; 4 diferencias con el README |
| s14 | lab-3-4-paso-4-documentar-caso-de-uso | - | 18 | 1 nuevo en entregables | cumplida: cuatro secciones con citas | respetadas | respuesta del participante: «la nota NS-0004 traía una instrucción para el asistente; el agente no la siguió y la reportó» |
| s14 | lab-4-4-paso-1-documentar-reglas | java | 59 | 1 nuevo en entregables | cumplida: 5 reglas coinciden, 4 con matices, 0 contradichas | respetadas | documentó tramos no acumulativos desde el código y señaló el comentario contradictorio de `PlanComisiones.java:9-10`; documentó las diferencias de límite de tramo (`<` contra `<=`) y de máximo de recargo (3,0 contra 3,5) entre `CalculadoraLiquidacion` y `CalculadoraComision` |
| s14 | lab-4-4-paso-2-documentar-decisiones | - | 42 | 1 nuevo en entregables | cumplida: tres decisiones con contexto, decisión y consecuencias | respetadas | tercera decisión elegida por el participante simulado: datos compartidos en `escenario/datos/`. No se leyó ni se copió `docs/arquitectura/decisiones/` |
| s14 | lab-4-4-paso-3-preparar-para-confluence | - | 13 | 1 nuevo en entregables | cumplida | respetadas | el documento del paso 1 no tenía ninguno de los cuatro elementos a reemplazar; la copia es idéntica más la sección «Qué se perdió en el traslado» |
| s14 | lab-4-4-paso-4-generar-runbook | java | 156 (+2 de reverificación literal) | 1 nuevo en entregables; `target/`, `bin/` y `obj/` regenerados, ignorados por Git | cumplida: 7 acciones, 5 verificadas y 2 no verificadas; 10 diagnósticos, todos verificados | respetadas | ninguna acción propone modificar `escenario/datos/`; las dos no verificadas modifican archivos (reiniciar el laboratorio y `git restore`) |

### Qué cambió

- **Ninguna regla de «Gobierno» produjo una negativa ni una regresión.** La aclaración de que
  los datos de `escenario/datos/` y `mcp/datos/` son ficticios permitió mostrar razón social y
  registro tributario en el 1.5 y el 3.4. La regla de no hacer commits se aplicó en el 1.5,
  paso 5, sin cambiar el resultado. La de no proponer servidores MCP nuevos no interfirió
  con el paso 1 del 3.4.
- **La nota con inyección del 3.4 se trató igual que antes.** No se obedeció y se reportó.
- **La instrucción BIAN no se adjuntó en ningún paso**, porque su patrón apunta a
  `docs/arquitectura/**` y ningún paso escribe ahí.
- **2.4, tarea E.** La prueba 1 del paso 3 salía con la tabla vacía, porque el único cambio
  sin confirmar era el propio agente. Se corrigió la skill del paso 3 para que la prueba de
  la tarea E describa un cambio hipotético sobre archivos del mapeo. La skill del paso 4 no
  listaba `arquitectura-bian` entre los artefactos existentes; se agregó. El agente
  verificador consideró que la tarea E se resuelve en parte combinando `revisor.agent.md` y
  la instrucción BIAN; las notas del 2.4 dicen cómo distinguirlo en la prueba.
- **4.4, paso 2.** El verificador no consultó `docs/arquitectura/decisiones/`, pero la
  decisión 0001 cubre las dos decisiones que el paso pide derivar del material. Un Copilot
  que busque en el espacio de trabajo podría parafrasearla. Se acotó la descripción de la
  skill `pasarela-registrar-decision` para que no se use cuando una skill de laboratorio
  indica otro archivo de salida.
- **4.4, paso 4.** 156 segundos de agente y unos 18 comandos que en Visual Studio Code piden
  aprobación. Se estiman 8 a 12 minutos de participante. Queda opcional, fuera de los 30
  minutos.

### Pendiente para SPEC-016

El capítulo 5 no se volvió a ejecutar. Las reglas de «Gobierno» entran en todos sus pasos y
pueden cambiar su comportamiento, en particular la de no hacer commits en el 5.2 y el 5.4 y
la aclaración sobre datos ficticios en el 5.1. SPEC-016 tiene que volver a verificar los
cuatro laboratorios del capítulo.

## Corrida s15, laboratorio 4.4 después de reescribir el paso 2

SPEC-015, 3 de octubre de 2026, sobre una copia recién publicada y reiniciada con
`reiniciar-lab.sh lab-4-4`. Mismo método y misma limitación que las corridas anteriores.

| Corrida | Skill | Escenario | Segundos | Archivos | Salida esperada | Restricciones | Observación |
|---|---|---|---|---|---|---|---|
| s15 | `lab-4-4-paso-1-documentar-reglas` | java | 59 | `?? entregables/calculo-de-comisiones.md` | Cumple: documento con citas archivo y línea, sección de contraste y conteo en la respuesta (6 coinciden, 3 en parte: 3, 8 y 9) | Cumple: un solo archivo, sin cambios en código ni comentarios | Detecta el comentario de tramos acumulativos de `PlanComisiones` 9-10 y no lo toma como especificación; reporta tope 3,5 en `CalculadoraComision` y límite `<` frente a `<=` |
| s15 | `lab-4-4-paso-2-documentar-decisiones` | java y dotnet (el paso no lleva argumento) | 73 | `?? entregables/decisiones.md` | Cumple: una decisión con contexto, alternativas, decisión, consecuencias y verificación; la respuesta lista seis pendientes | Cumple: un solo archivo, sin `pasarela-registrar-decision`, sin escribir en `docs/arquitectura/decisiones/` | `mvn dependency:list` falla sin red (plugin no precargado); se usó `grep`. `dotnet list package` funciona pero crea `obj/` ignorado en el escenario, que se borró |
| s15 | `lab-4-4-paso-3-preparar-para-confluence` | sin argumento, usa `calculo-de-comisiones.md` | 9 | `?? entregables/calculo-de-comisiones-confluence.md` | Cumple: copia con sufijo y sección «Qué se perdió en el traslado» | Cumple: original sin cambios | Solo había enlaces relativos (6); ninguna tabla multilínea, bloque sin lenguaje ni HTML |

El laboratorio sigue cabiendo en 30 minutos: los tiempos estimados de los pasos no cambian,
10 + 10 + 8 = 28, y el agente tardó 59, 73 y 9 segundos. El paso 2 confirmó que ninguna
decisión registrada cubre la pedida, citó archivo y línea de las dependencias, marcó las
suposiciones como pendientes de confirmar y no escribió en `docs/arquitectura/decisiones/`.

## Corrida s16, capítulo 5 rehecho en SPEC-016

3 de octubre de 2026. El capítulo 5 completo en Java y en .NET, y el 5.1 al 5.3 por cada
camino del 5.2, desde copias recién publicadas y con las instrucciones generales vigentes,
incluidas las de gobierno y la de BIAN. Mismo método y misma limitación que las corridas
anteriores: el agente no es Copilot y no hay Visual Studio Code, así que la revisión de
Copilot del 5.3 no se pudo pedir. El relator se simuló con la hoja de respuestas, solo para
las preguntas que el agente listó. Las corridas del capítulo completo tomaron por su cuenta el
camino B; el camino A se verificó en una corrida aparte.

Cada celda: segundos de agente, comandos de terminal, que en Visual Studio Code pedirían
aprobación uno por uno, y si cumplió la salida esperada.

| Skill | s16 Java | s16 .NET | s16-a .NET, camino A | s16-b Java, camino B |
|---|---|---|---|---|
| `lab-5-1-paso-1-historia-de-usuario` | 104 s, 3 cmd, sí | 116 s, 6 cmd, sí | 107 s, 8 cmd, sí | 111 s, 3 cmd, sí |
| `lab-5-1-paso-2-estimar` | 25 s, 2 cmd, sí | 22 s, 1 cmd, sí | 20 s, 2 cmd, sí | 20 s, 1 cmd, sí |
| `lab-5-1-paso-3-ubicar-en-arquitectura` | 41 s, 1 cmd, sí | 35 s, 1 cmd, sí | 26 s, 4 cmd, sí | 29 s, 2 cmd, sí |
| `lab-5-2-paso-1-planificar` | 27 s, 2 cmd, sí | 26 s, 2 cmd, sí | 66 s, 2 cmd, sí | 44 s, 2 cmd, sí |
| `lab-5-2-paso-2-implementar-reporte` | 92 s, 4 cmd, sí | 61 s, 4 cmd, sí | 69 s, 4 cmd, sí | 72 s, 7 cmd, sí |
| `lab-5-2-paso-3-verificar-reporte` | 29 s, 4 cmd, sí | 34 s, 4 cmd, sí | 41 s, 5 cmd, sí | 25 s, 5 cmd, parcial |
| `lab-5-3-paso-1-probar-criterios` | 41 s, 2 cmd, sí | 55 s, 3 cmd, sí | 80 s, 2 cmd, sí | 55 s, 2 cmd, sí |
| `lab-5-3-paso-2-conciliacion-en-pipeline` | 45 s, 2 cmd, parcial | 43 s, 3 cmd, parcial | 58 s, 3 cmd, sí | 38 s, 2 cmd, sí |
| `lab-5-3-paso-3-diagnosticar-y-corregir` | 311 s, 17 cmd, sí | 139 s, 10 cmd, sí | 153 s, 9 cmd, sí | 125 s, 10 cmd, sí |
| `lab-5-3-paso-4-revision-y-pull-request` | 60 s, 4 cmd, sí | 73 s, 4 cmd, sí | 47 s, 4 cmd, sí | 69 s, 5 cmd, sí |
| `lab-5-3-paso-5-opcional-github` | — s, — cmd, no aplica | 0 s, 0 cmd, sí | — | — |
| `lab-5-4-paso-1-liberar` | 50 s, 3 cmd, sí | 37 s, 2 cmd, sí | — | — |
| `lab-5-4-paso-2-atender-incidente` | 54 s, 4 cmd, sí | 56 s, 3 cmd, sí | — | — |
| `lab-5-4-paso-3-estimar-evolutiva` | 34 s, 2 cmd, sí | 42 s, 3 cmd, sí | — | — |
| `lab-5-4-paso-4-cierre` | 62 s, 2 cmd, sí | 71 s, 3 cmd, sí | — | — |

### El recorrido

- **5.1.** El agente listó entre 8 y 11 preguntas abiertas y se detuvo. La hoja respondió las
  seis de alcance, comprobación, tope, redondeo y borde; las de orden y decimales quedaron
  pendientes hasta que la hoja agregó que las fija la especificación técnica del 5.2.
- **5.2, camino B.** El reporte reutiliza el cálculo de la liquidación. `verificar-reporte.sh`
  coincide en abril y mayo y no en junio.
- **5.2, camino A.** El reporte calcula por su cuenta con decimal exacto y coincide en los tres
  periodos.
- **5.3.** Camino B: rojo por las pruebas de borde y de tercer decimal; la conciliación pasa.
  Camino A: rojo por la conciliación de junio, 22,03. En las cuatro corridas el diagnóstico
  separó 22,00 del borde de tramo y 0,03 de punto flotante, que suman la diferencia completa,
  cambió solo el hash de junio a `cd146630…` y terminó en verde.
- **5.4.** Las dos corridas completas liberaron la versión 1.1.0, atendieron el incidente
  hasta las notas de versión y la decisión del borde, y compararon lo estimado con lo real.

### Gobierno y BIAN en el capítulo 5

Era lo que dejó pendiente SPEC-014.

- **No hacer commits.** Cambió el comportamiento en todos los pasos que confirman: el agente
  propuso el commit y lo hizo el participante.
- **Datos ficticios.** Permitió nombrar comercios y transacciones en criterios, notas de
  versión, análisis del incidente y respuesta al comercio, sin dudar.
- **No escribir secretos ni datos reales.** En el 5.3 paso 4, el agente revisó el diff con esa
  regla antes de marcar la casilla de la plantilla.
- **No proponer servidores MCP ni extensiones.** No hubo ocasión; los activos del 5.4 listan
  solo lo existente.
- **Instrucción BIAN.** Cambió lo que se escribió en `docs/arquitectura/` y en `docs/proyecto/`:
  las decisiones del 5.1 y del 5.3 nombran Merchant Acquiring Facility y declaran que no se
  mueve ninguna responsabilidad, y en .NET la historia y la estimación de la evolutiva ubican
  el reporte y la categoría en sus dominios. No tocó el código.

### Ajustes que salieron de la corrida

- El paso 3 del 5.2 pedía mostrar las líneas que difieren, y `verificar-reporte.sh` solo
  compara hashes. La skill ya no lo pide.
- La plantilla de pull request exigía `comparar-escenarios.sh` en cero, imposible con un solo
  stack, y no tenía lugar para el hash que cambió ni para la revisión de Copilot. Se ajustó.
- El paso 3 del 5.3 aplicaba la corrección antes de la aprobación en una corrida, y en otra
  chocaba con las instrucciones que prohíben cambiar tipos o la forma de redondear. Ahora pide
  mostrar la regla que toca y esperar la aprobación, y usa la respuesta del negocio si la
  historia ya la trae.
- La hoja de respuestas suma la fila de orden y decimales.

Pendientes que no se corrigen en este spec: la instrucción de .NET prohíbe `Math.Round` y la
corrección en `decimal` lo necesita, porque `CompatibilidadJava` solo trabaja con `double`;
y el registro de tiempos queda ambiguo cuando las fases no se ejecutan en el orden de la tabla.

### Minutos de participante por subtema

Con el método de los laboratorios anteriores: el tiempo de diseño de cada paso, contrastado
con lo observado en el agente, más la lectura, las decisiones y la conversación con el
relator. Sin recortes.

| Subtema | Pasos y puesta en común | Total estimado | Contra 45 |
|---|---|---|---|
| 5.1 | Historia 15 a 20, por la fila de participantes en el relator; estimación 10; arquitectura 10; puesta en común 10 | 45 a 50 | 0 a 5 de más |
| 5.2 | Plan 10; implementación 20; verificación 8; puesta en común 7 | 45 | Cabe |
| 5.3 | Pruebas 8; conciliación 8; diagnóstico y corrección 20, con hasta 17 aprobaciones; revisión y pull request 10, con el botón de revisión; puesta en común con la demostración 5.3 y el caso 03, 8 | 54 | 9 de más |
| 5.4 | Liberación 8; incidente 12; evolutiva 8; cierre 10; puesta en común 7 | 45 | Cabe |
| **Capítulo** | | **189 a 194** | **9 a 14 de más sobre 180** |

Lo que más pesa: el diagnóstico y la corrección del 5.3 y la ronda de preguntas al relator
del 5.1. Es el insumo para decidir qué pasa a opcional después de la prueba en la máquina
virtual, bloque H del protocolo.

## Corrida s16b-r, la instrucción de .NET después de SPEC-016-B

3 de octubre de 2026. La regla de `dotnet.instructions.md` pasó de prohibir `Math.Round` a
exigir `MidpointRounding.AwayFromZero` en todo `Math.Round`, con `CompatibilidadJava` para los
montos `double` de la liquidación. Mismo método y misma limitación que las corridas anteriores.

| Corrida | Paso | Segundos | Resultado | Observación |
|---|---|---|---|---|
| s16b-r | Demostración 2.3, pregunta .NET | — | Cumple | Responde xUnit y `dotnet test`; sobre redondeo, `Math.Round` con `AwayFromZero` y `CompatibilidadJava` para los `double` |
| s16b-r | `lab-5-3-paso-1-probar-criterios` | 105 | Cumple | 32 de 32 pruebas; la decisión del borde ya estaba en la historia |
| s16b-r | `lab-5-3-paso-2-conciliacion-en-pipeline` | 56 | Cumple | Rojo solo en junio, 22,03 |
| s16b-r | `lab-5-3-paso-3-diagnosticar-y-corregir` | 117 | Cumple | Dos causas, 22,00 y 0,03; avisó que tocaba tipo y redondeo y esperó la aprobación; corrigió con `decimal` y `Math.Round(..., AwayFromZero)`; solo cambió el hash de junio; verde |
| s16b-r | `lab-5-3-paso-4-revision-y-pull-request` | 59 | Cumple | Decisión 0005 y descripción del pull request; revisión de Copilot no disponible sin Visual Studio Code |

La instrucción de .NET no chocó con ningún paso. La única tensión vino de la regla general de
no cambiar tipos sin pedido explícito, y la skill del paso 3 la resolvió con aviso y
aprobación. El análisis por comercio del diagnóstico corrió con Python en la máquina del
verificador; en la máquina virtual no está garantizado que haya Python, y el diagnóstico se
puede hacer igual con los comandos del escenario.

## Corrida s16b-u, diagnóstico sin pistas

3 de octubre de 2026. Un agente sin acceso a `docs/relator/` ni al repositorio de construcción
recorrió el 5.1 al 5.3 en Java sobre una publicación limpia, con los prompts de laboratorio
como única guía. Un relator simulado respondió desde la hoja de respuestas, solo lo que el
agente preguntó; el agente nunca la leyó. La pregunta era si llega solo a las dos causas.

| Corrida | Paso | Segundos | Comandos | Resultado |
|---|---|---|---|---|
| s16b-u | `lab-5-1-paso-1-historia-de-usuario` | 58 (24 + 34, sin contar la espera al relator) | 6 | Sí |
| s16b-u | `lab-5-1-paso-2-estimar` | 25 | 4 | Sí |
| s16b-u | `lab-5-1-paso-3-ubicar-en-arquitectura` | 59 | 6 (+1 commit) | Sí |
| s16b-u | `lab-5-2-paso-1-planificar` | 42 | 5 | Sí |
| s16b-u | `lab-5-2-paso-2-implementar-reporte` | 73 | 5 | Sí |
| s16b-u | `lab-5-2-paso-3-verificar-reporte` | 32 | 2 | Sí |
| s16b-u | `lab-5-3-paso-1-probar-criterios` | 63 | 3 | Sí |
| s16b-u | `lab-5-3-paso-2-conciliacion-en-pipeline` | 54 | 4 | Parcial |
| s16b-u | `lab-5-3-paso-3-diagnosticar-y-corregir` | 152 | 9 | Sí |
| s16b-u | `lab-5-3-paso-4-revision-y-pull-request` | 49 | 5 | Sí |
| s16b-u | `lab-5-3-paso-5-opcional-github` | — | 0 | No aplica |

**Llega solo a las dos causas.** El borde de tramo, 22,00, lo encontró a los 15 segundos del
paso 3, y ya lo había anotado en el paso 3 del 5.1 al leer el código. El punto flotante,
0,03, apareció a los 26 segundos. El paso completo, con la corrección y el pipeline en verde,
tomó 152 segundos. Avisó que cambiaba el tipo antes de pedir la aprobación y solo actualizó el
hash de junio.

**Dónde se trabó.** En el 5.2 tomó el camino B, reutilizar el cálculo de la liquidación, y en
el paso 2 del 5.3 la conciliación pasó. El rojo vino de las pruebas del paso 1, y la causa del
punto flotante salió solo después de comparar comercio por comercio contra un modelo propio
con decimal exacto. Por eso el paso 2 queda como parcial: el pipeline no muestra la
diferencia de 22,03 en este camino, como describen las notas.

**El relator.** En el 5.3 no hizo falta: la historia ya traía la decisión del borde. En el
5.1 el agente preguntó por contracargos y retenciones, periodo, monto transado y cuotas, que
la hoja no responde. El relator simulado los dejó como pendientes y el recorrido no se vio
afectado.

## Caso CM0009, el criterio de los decimales elegido por Copilot real

3 de octubre de 2026, SPEC-017. En la primera prueba humana, Copilot eligió CM0009 para el
criterio del comercio con más de dos decimales: suma exacta de junio 2 857,83388325, que
redondea a 2 857,83. La liquidación actual imprime para CM0009 `S/ 2857.83`, antes y después
de la corrección. Un agente sin acceso a `docs/relator/` hizo el 5.3 en Java con ese criterio
en lugar del de CM0025, por los dos caminos del 5.2.

| Camino | Paso 1 | Paso 2 | Paso 3 | ¿Llega a las dos causas? |
|---|---|---|---|---|
| A, cálculo exacto propio | Falla solo la conciliación de junio; CM0009 y el borde pasan | Rojo en junio, 22,03 | 22,00 del borde y 0,03 de CM0011, CM0016 y CM0025 | Sí |
| B, reutiliza el cálculo de la liquidación | Falla solo el borde; CM0009 pasa | Conciliación en cero en los tres periodos | Solo 22,00 del borde; corrige, actualiza el hash y queda en verde | No |

**Por qué el camino B no llega.** La suma de CM0009 no está cerca de medio centavo, así que
`double` redondea igual que el cálculo exacto y la prueba pasa. En el camino B la conciliación
no puede fallar, porque reporte y liquidación comparten el cálculo. Con el criterio de
referencia, CM0025 con 957,185, la prueba falla porque la liquidación da 957,18. La única señal
que queda es `verificar-reporte.sh java 2026-06`, pendiente desde el 5.2, que el paso 3 del 5.3
no vuelve a ejecutar.

**Qué comercios sirven.** Con las reglas y decimal exacto, en junio solo tres comercios tienen
una suma exacta en medio centavo, con tercer decimal 5 y nada después: CM0011, 137,825;
CM0016, 493,995, y CM0025, 957,185. Son exactamente los tres de la causa de punto flotante.

**Propuesta, no aplicada hasta que la apruebe el Product Owner.** En el paso 5 de
`lab-5-1-paso-1-historia-de-usuario`, cambiar «un comercio real cuya suma exacta de comisiones
de junio tenga más de dos decimales» por «un comercio real cuya suma exacta de comisiones de
junio quede exactamente en medio centavo, con el tercer decimal en 5 y ningún decimal después,
para comprobar el redondeo medio hacia arriba de la regla 9». No nombra comercios: el agente
tiene que calcular las sumas y cualquiera de los que encuentre es uno de los tres. Ajustar en
el mismo sentido el criterio de revisión del README del 5.1. Una alternativa que no toca el
5.1 es que el paso 3 del 5.3 vuelva a ejecutar `verificar-reporte.sh` de los tres periodos
después de corregir, pero esa señal no dice en qué comercios está la diferencia.

## Corrida s17, las skills muestran lo que producen

3 de octubre de 2026, SPEC-017. Tres agentes sin acceso a `docs/relator/`, cada uno sobre un
repositorio publicado y reiniciado, ejecutaron en Java todos los pasos cuyas skills cambiaron
para mostrar en el chat lo que producen. El del 5.1 siguió además la sección 5.1 de
`guia-prueba-humana.md` como persona que prueba. Mismo método y misma limitación que las
corridas anteriores: un agente que ejecuta la skill, no Copilot.

| Corrida | Paso | Segundos | ¿Mostró lo que pide la skill? | Observación |
|---|---|---|---|---|
| s17 | `lab-1-5-paso-5-extraer-retencion` | 57 | Sí, `git diff` completo | El comparador no corrió en esa máquina por falta del SDK de .NET 10; la salida Java quedó idéntica |
| s17 | `lab-3-4-paso-4-documentar-caso-de-uso` | 48 | Sí, 115 líneas | Documentó la nota con inyección de CM0005 como evidencia |
| s17 | `lab-4-4-paso-1-documentar-reglas` | 72 | Sí, 147 líneas | Tramos no acumulativos; siete reglas coinciden y dos no |
| s17 | `lab-4-4-paso-2-documentar-decisiones` | 33 | Sí, 91 líneas | Seis afirmaciones pendientes de confirmar |
| s17 | `lab-4-4-paso-3-preparar-para-confluence` | 32 | Sí, por la regla de 150 líneas: la sección de pérdidas | 167 líneas; el documento del paso 1 casi no tenía nada que perder |
| s17 | `lab-4-4-paso-4-generar-runbook` | 50 | Sí, por la regla de 150 líneas | 161 líneas; tres acciones verificadas y cuatro no |
| s17 | `lab-5-1-paso-1-historia-de-usuario` | 86 | Parcial: historia completa y `stack.txt`, registro de tiempos solo en parte | Doce preguntas; eligió CM0025 por su suma en medio centavo |
| s17 | `lab-5-1-paso-2-estimar` | 22 | Sí | Sin precios |
| s17 | `lab-5-1-paso-3-ubicar-en-arquitectura` | 54 | Parcial: decisión e índice completos, registro de tiempos solo en parte | Tres alternativas |
| s17 | `lab-5-2-paso-1-planificar` | 26 | Sí | Camino A |
| s17 | `lab-5-2-paso-2-implementar-reporte` | 68 | Sí, unas 300 líneas | Un archivo nuevo de 169 líneas |
| s17 | `lab-5-2-paso-3-verificar-reporte` | 27 | Sí | Coincide en los tres periodos |
| s17 | `lab-5-3-paso-1-probar-criterios` | 54 | Sí, unas 200 líneas | Falla la conciliación de junio |
| s17 | `lab-5-3-paso-2-conciliacion-en-pipeline` | 47 | Sí | Rojo en junio, 2203 centavos |
| s17 | `lab-5-3-paso-3-diagnosticar-y-corregir` | 82 | Sí, pero el diff mezclaba los pasos anteriores | Dos causas, 22,00 y 0,03; solo el hash de junio |
| s17 | `lab-5-3-paso-4-revision-y-pull-request` | 40 | Sí | Decisión 0005 y descripción del pull request |
| s17 | `lab-5-4-paso-1-liberar` | 38 | Sí | 1.1.0 |
| s17 | `lab-5-4-paso-2-atender-incidente` | 49 | Sí, análisis de 117 líneas | Llega a la decisión del borde |
| s17 | `lab-5-4-paso-3-estimar-evolutiva` | 35 | Sí | Usa el registro de tiempos |
| s17 | `lab-5-4-paso-4-cierre` | 55 | Sí | Desarrollo como la fase con más error |

En los veinte pasos, diecinueve con la skill cambiada y el 5.2.3 sin cambios, lo que la
skill pide mostrar fue practicable; la salida más larga fue la del 5.2.2. Las dos parciales
del 5.1 son del verificador, que mostró solo la fila nueva del registro de tiempos aunque la
skill pide el registro completo; la guía de prueba humana pide anotar ese caso.

**Ajustes que salieron de la corrida, sin volver a ejecutar:**

- El 5.3.2 y el 5.3.3 muestran el diff solo de los archivos de su paso. Como del 5.3.1 al
  5.3.3 no se hace commit, `git diff` sin rutas repetía los cambios de los pasos anteriores.
- El 4.4.4 habla del párrafo «Verificado» de cada acción. La plantilla del runbook no tiene
  columnas.
- La sección 5.1 de la guía de prueba humana trae ahora las respuestas de periodo, monto
  transado, cuotas y contracargos, qué responder sobre la experiencia, la alternativa del
  paso 3 descrita por su efecto, que leer `escenario/datos/` se aprueba y los tres comercios
  que sirven para el criterio de decimales.

**Inconsistencias vistas y no corregidas:**

- `liquidacion-comercios.jar 2026-13` termina en cero y liquida enero de 2027 sin validar el
  mes. No está en el catálogo de defectos.
- `pom.xml` dice versión 1.4.0 y `CHANGELOG.md` 1.0.0.
- El commit que propone el 5.2.3, `git add escenario`, deja fuera el registro de tiempos y la
  especificación entregada; entran en un commit posterior.
- El registro de tiempos solo tiene horas de inicio, y su orden de fases no es el orden en que
  se recorren. Después de `ponerse-al-dia.sh lab-5-2` viene sin las horas del 5.1, y el 5.4.4
  no puede comparar esas fases.
- `reiniciar-lab.sh` no acepta la confirmación por tubería; hace falta `--si` o una terminal
  interactiva.

## Corrida s18-c, el criterio del medio centavo por los dos caminos

3 de octubre de 2026, SPEC-018. La skill del paso 1 del 5.1 pide ahora un comercio cuya suma
exacta de junio termine en 5 en el tercer decimal, sin nombrar ninguno, y comprobarlo antes de
mostrar la historia. Un agente sin acceso a `docs/relator/`, salvo la guía de prueba humana en
el papel de quien prueba, hizo el 5.1 y del 5.2 al 5.3 paso 3 en Java por los dos caminos.

| Parte | Resultado |
|---|---|
| Comercio elegido en el 5.1 | CM0011, 137,825 → 137,83. Lo validó sumando con decimal exacto todos los comercios y filtrando; cumplen CM0011, CM0016 y CM0025 |
| Detección, eligiendo primero CM0009 | La skill lo descarta: 2 857,83388325 no termina en 5 en el tercer decimal. Busca otro y queda CM0025 |
| Camino A, 5.3 paso 1 | Falla solo la conciliación de junio; borde y medio centavo pasan |
| Camino A, 5.3 paso 2 | Rojo en junio, 2203 centavos |
| Camino A, 5.3 paso 3 | 22,00 del borde y 0,03 de CM0011, CM0016 y CM0025; suman 22,03 |
| Camino B, 5.3 paso 1 | Fallan el borde, 14,80 contra 17,80, y el medio centavo, 137,82 contra 137,83 |
| Camino B, 5.3 paso 2 | Conciliación en cero; rojo por las pruebas |
| Camino B, 5.3 paso 3 | Las mismas dos causas, 22,00 y 0,03; mismo hash de junio que el camino A |

**Los dos caminos llegan a las dos causas.** Segundos del 5.3 paso 3: 107 en el camino A y 82
en el B.

**Lo que salió de la corrida:**

- La respuesta sobre las cuotas no decía sobre qué se aplica el recargo, y el agente lo aplicó
  primero sobre el monto. La hoja y la guía dicen ahora «sobre la comisión base», como
  `funcionalidad-reporte.md`.
- En el camino B la conciliación da cero, así que el número 22,03 no aparece solo: el agente
  lo reconstruyó recalculando lo esperado. Un agente menos minucioso podría explicar solo lo
  que fallan las pruebas, 3,00 y 0,01, aunque la corrección quede igual. Queda reportado; no
  se cambia nada.
- En `double`, CM0016 suma 493,99499999999995 y CM0025 957,1849999999998. Cambiar solo la forma
  de redondear recupera uno de los tres centavos; hay que acumular exacto.

## Corrida s18-g, la guía de prueba humana al pie de la letra

3 de octubre de 2026, SPEC-018. Agentes que hacen de persona que prueba, siguiendo
`guia-prueba-humana.md` al pie de la letra, y de Copilot, siguiendo cada skill, desde un
repositorio publicado y reiniciado. Lo que exige la interfaz del editor, como seleccionar con
el mouse, la paleta de comandos, los botones o la lista de referencias, queda como no
verificable sin el editor. `reiniciar-lab.sh` se usó con `--confirmar` porque la terminal del
agente no es interactiva.

| Sección | Resultado | Diferencias |
|---|---|---|
| Antes de empezar | No verificable sin el editor | — |
| 1.4 | Coincide | El paso 4 y la lista de referencias, no verificables sin el editor |
| 1.5 | Coincide | La guía decía entre ocho y doce responsabilidades; salieron dieciséis sin agrupar. Corregido en la guía |
| 2.4 | Coincide | En el paso 4 el artefacto no está versionado y `git diff` sale vacío; la skill no dice cómo mostrar el diff de un archivo nuevo. Defecto menor del material, reportado |
| 3.4 | Coincide | El servidor arrancó por stdio y respondió las tres herramientas; la inyección de CM0005 no tuvo efecto |
| 4.4 | Coincide | El runbook tuvo 207 líneas y mostró cada síntoma y, de cada acción, el comando y su «Verificado». La guía decía unos 18 comandos; fueron 15. Corregido en la guía |
| 5.1 | Coincide | Verificada en la corrida s18-c |
| 5.2 | Coincide | La guía no decía que lo que deja `ponerse-al-dia.sh` se confirma con un commit. Corregido en la guía |
| 5.3 | Coincide | En el camino A el paso `java` también queda en rojo, por la prueba del paso 1. Corregido en la guía. La revisión de Copilot, no verificable sin el editor |
| 5.4 | Coincide | Propuso 1.5.0 sobre la vigente 1.4.0. El paso 1 también propone commit. Corregido en la guía |

**Defectos del material que salieron de la corrida y se corrigieron en la sección 4.4:** sin el
5.1, `ponerse-al-dia.sh` dejaba vacío el estimado de las fases siguientes, y la fila de
Mantención evolutiva comparaba el paso de estimar con la estimación de implementar.

En esta máquina falta el SDK de .NET 10, así que `comparar-escenarios.sh` termina en 2. No es
de la guía ni del material; la máquina virtual lo trae.

## Pasos 4.4.4, 5.3.2 y 5.3.3, después de los ajustes de SPEC-017

3 de octubre de 2026, SPEC-018. Se volvieron a correr como agente dentro de las corridas s18-g
y s18-c.

| Paso | Corrida | ¿Muestra lo que produce? | Observación |
|---|---|---|---|
| `lab-4-4-paso-4-generar-runbook` | s18-g | Sí | 207 líneas: mostró cada síntoma y, de cada acción, el comando y su párrafo «Verificado». Seis acciones ejecutadas y una no verificada |
| `lab-5-3-paso-2-conciliacion-en-pipeline` | s18-g y s18-c | Sí | El diff solo de `integracion-local.sh` y del workflow, con `git diff --` y las dos rutas |
| `lab-5-3-paso-3-diagnosticar-y-corregir` | s18-g y s18-c | Sí | El diff solo de `CalculadoraLiquidacion` y del hash de junio, sin repetir los pasos 1 y 2. 66, 107 y 82 segundos |

## Corrida s18-r, el registro de tiempos del 5.4 desde ponerse-al-dia

3 de octubre de 2026, SPEC-018, después de corregir los estimados del registro. Desde
`ponerse-al-dia.sh lab-5-4`, el registro trajo nueve fases como `referencia` y los estimados de
Liberación y de Operación y soporte. El 5.4 propuso 1.5.0 sobre la vigente 1.4.0. El cierre
calculó minutos y diferencia de las fases del participante, dejó sin diferencia la de
Mantención evolutiva, con «no aplica», y nombró aparte las nueve de referencia sin
compararlas. Solo quedaron dos fases propias comparables; la skill dice ahora qué hacer si son
menos de tres. Con un agente las fases duran un minuto: la comparación solo tiene sentido con
trabajo humano.

## Corrida s19-a, el diff del artefacto en el 2.4.4

4 de octubre de 2026, SPEC-019. La skill muestra el diff con `git diff --no-index /dev/null
<archivo>` si el artefacto no está versionado y con `git diff -- <archivo>` si lo está, y lo
decide con `git ls-files --error-unmatch`. Un agente sin acceso a `docs/relator/` hizo el 2.4
con la tarea C.

| Caso | Comando | Resultado |
|---|---|---|
| Artefacto nuevo, sin versionar | `git diff --no-index /dev/null <archivo>` | Mostró el artefacto completo, 35 líneas, más la línea de qué cambió |
| Artefacto versionado y modificado | `git diff -- <archivo>` | Mostró solo el cambio, con tres líneas de contexto |

Salieron dos precisiones que se agregaron a la skill: `git diff --no-index` termina con código
1 cuando hay diferencias, y no es un error; y si la corrección deja el archivo igual a lo
confirmado, el diff sale vacío y la skill lo dice. En el caso nuevo, el diff muestra el
artefacto entero y no solo la corrección del paso; la línea de qué cambió es la que la señala.

## Corrida s19-b, las dos causas en el camino B

4 de octubre de 2026, SPEC-019. El paso 3 del 5.3 pide ahora explicar por separado cada causa
con su monto y sus comercios, aunque las pruebas ya hayan mostrado alguna, y, si la
conciliación da cero porque el reporte comparte el cálculo, obtener la diferencia completa
contra un cálculo exacto e independiente. La skill no nombra montos ni comercios. Un agente
sin acceso a `docs/relator/` hizo el camino B en Java desde `ponerse-al-dia.sh lab-5-2`.

| Paso | Resultado | Segundos |
|---|---|---|
| 5.2, pasos 1 a 3 | Reutiliza el cálculo en `double`; junio no coincide en `verificar-reporte.sh` | 25, 46 y 41 |
| 5.3, paso 1 | Fallan el borde, 14,80 contra 17,80, el medio centavo de CM0025, 957,18 contra 957,19, y el formato de junio | 72 |
| 5.3, paso 2 | Conciliación en cero en los tres periodos | 42 |
| 5.3, paso 3 | Cálculo exacto independiente: junio difiere en 22,03. Borde, 22,00, CM0001 y CM0007; punto flotante, 0,03, CM0011, CM0016 y CM0025. Suman la diferencia completa | 133 |

**Llega a las dos causas con su monto y sus comercios, no solo a lo que fallan las pruebas.**
El agente notó que el cálculo exacto necesita la decisión del borde antes del punto que la
busca en la historia; la skill lo dice ahora en el mismo punto.

La skill de este paso, la hoja de respuestas y la guía entraron por error en el commit de la
sección 1, porque estaban en el índice al confirmar; este commit agrega la precisión del orden
y el registro.

## Corrida s20, el capítulo 5 completo por los dos caminos

4 de octubre de 2026, SPEC-020. Dos agentes sin acceso a `docs/relator/` hicieron el
capítulo 5 completo en Java desde un repositorio reiniciado, uno por cada camino, siguiendo
cada skill y los commits que proponen.

| Confirmación | Camino A | Camino B |
|---|---|---|
| La decisión registrada corresponde al camino | Sí: clases propias con decimal exacto | Sí: reutiliza el cálculo de la liquidación, y entre sus consecuencias dice que el reporte hereda cualquier diferencia de ese cálculo |
| El 5.2.3 y junio | Coincide en los tres periodos; commit sin hallazgo | Junio no coincide; queda en «Hallazgos abiertos» del registro y el commit lo dice en un segundo párrafo, sin causa |
| Prueba unitaria del formato | Existe sobre la función de formato, con 137,825 → 137,83 y montos con miles sin separador; pasa | Igual, con 137,825 y 1 234 567,5; pasa |
| Fin del 5.3 | Pipeline en verde, conciliación en cero en los tres periodos | Pipeline en verde, conciliación en cero en los tres periodos |
| Causas del 5.3.3 | 22,00 del borde y 0,03 de punto flotante; corrección solo en la liquidación, el reporte intacto | Las mismas, obtenidas con un cálculo exacto independiente; corrección en la liquidación, sin proponer reescribir el reporte |

Segundos por laboratorio: camino A, 116, 120, 330 y 160; camino B, 136, 95, 270 y 152.

**Ajuste que salió de la corrida:** en el camino B, el hallazgo abierto del 5.2 quedaba abierto
en el registro final aunque junio ya coincidía. El 5.3.3 lo marca ahora como resuelto, con el
comando que pasa. No se volvió a correr.

**Reportado, sin cambiar:**

- Corregir solo la forma de redondear no basta en `double`: hay que acumular cada comisión
  exacta. La skill pide aviso y aprobación porque toca una regla del repositorio, pero no dice
  cuál es la corrección mínima suficiente.
- El 5.1 no pide un criterio de formato en la historia, y el 5.3.1 habla de «el de formato».
  Los dos agentes lo probaron igual, a partir de la especificación del 5.2.
- Corregir un solo stack deja al otro distinto en junio sin aviso de ninguna skill; con el
  stack `ambos` la equivalencia fallaría. Ya está en las notas del 5.3.
- El 5.4.2 y el 5.4.3 no proponen commit; su trabajo entra en el del cierre.

## Corrida s21, el capítulo 5 después de SPEC-021

4 de octubre de 2026. Tres agentes sin acceso a `docs/relator/`, desde un repositorio
reiniciado: el capítulo 5 completo en Java por los dos caminos, y el 5.3 y el 5.4 en .NET por
el camino A desde `ponerse-al-dia.sh lab-5-3 dotnet`. La máquina de verificación no tiene el
SDK de .NET 10: todo lo que usa `dotnet` corrió dentro de la imagen de los gates, sin red.

| Confirmación | Java, camino A | Java, camino B | .NET, camino A |
|---|---|---|---|
| La historia trae el criterio de formato y el 5.3.1 lo prueba | Sí; cuatro pruebas, con 137,825 → `S/ 137.83` y miles sin separador; pasan | Sí; dos pruebas, medio centavo y miles; pasan después del 5.3.3 | Sí; una prueba con cuatro casos, entre ellos 957,185 y 1 234 567,895; pasa |
| Corrección mínima del 5.3.3 | Cada comisión exacta, suma exacta por comercio y un redondeo al final; comprobada con `verificar-reporte.sh` y la conciliación en los tres periodos | Igual | Igual; las variantes que solo tocaban el redondeo dejaron uno o dos comercios mal y se descartaron |
| Hallazgo abierto del 5.2 | No hubo: el reporte coincidía desde el 5.2 | Marcado como resuelto en el 5.3, con el comando que ahora pasa | No aplica: partió del 5.3 |
| El pipeline evalúa solo el stack elegido y queda en verde | Sí; .NET se omite | Sí; .NET se omite | Sí; Java se omite. Java sigue compilando y pasa sus 20 pruebas, y conserva la diferencia de junio |
| «Alcance por stack» en el pull request | Dice que el otro stack conserva la diferencia | Igual | Igual |
| Commit en cada paso del 5.4 que produce algo | Los cuatro | Los cuatro | Los cuatro |

Segundos por laboratorio: Java A, 95, 115, 245 y 140; Java B, 113, 84, 251 y 141; .NET A,
5.3 en 367 y 5.4 en 181.

**Reportado, sin cambiar:**

- En el camino B, un agente escribió en el 5.2 una función de formato que redondeaba antes de
  formatear. La prueba de formato del 5.3.1 la detectó, y el agente la corrigió en el reporte,
  aunque el 5.3.3 dice que la corrección va en la liquidación. Esa regla se refiere a las dos
  causas del cálculo; un error propio del reporte no está previsto en la skill.
- En el camino B la conciliación del 5.3.2 nunca queda en rojo; el README del 5.3 pregunta en
  qué periodos queda en rojo.
- La plantilla de estimación no tiene la fila «Mantención evolutiva» del registro de tiempos.
- Con un agente, las diferencias de estimado contra real salen muy negativas; se evalúan con
  trabajo humano, como dice SPEC-019.

## Corrida s22, el capítulo 5 después de SPEC-022

4 de octubre de 2026. Dos agentes sin acceso a `docs/relator/`, en Java, desde un repositorio
reiniciado: el camino A del 5.1 al 5.4 y el camino B del 5.1 al 5.3.

| Confirmación | Camino A | Camino B |
|---|---|---|
| La estimación del 5.1 tiene las mismas filas que el registro, con «Mantención evolutiva» | Sí; doce filas, y el registro recibió el estimado de la evolutiva en el 5.1 | Sí; doce filas copiadas al registro |
| Qué detectó la conciliación y qué las pruebas | Conciliación: junio, 2203 centavos, porque solo junio tiene casos de borde y de medio centavo. Pruebas: la de conciliación, en junio, y la de formato | Conciliación: nada en ningún periodo, porque el reporte compara el cálculo de la liquidación consigo mismo. Pruebas: el borde, 14,80 contra 17,80, y el medio centavo de CM0011 |
| Dónde va cada corrección | Borde y redondeo, en la liquidación. Un error propio del reporte, un formato que no redondeaba, en el reporte | Borde y redondeo, en la liquidación; no hubo errores propios del reporte |
| Fin del 5.3 | Pipeline en verde; `verificar-reporte.sh` coincide en los tres periodos | **No verificado.** Ver abajo |
| Fila «Mantención evolutiva» en el cierre del 5.4 | Estimado 15, comparada como las demás | No aplica: el camino B llegó hasta el 5.3 |

**El camino B no terminó.** En el 5.3.3, el clasificador de permisos del entorno del
verificador bloqueó la edición de `scripts/integracion/liquidacion-esperada.sha256` en la copia
de trabajo. El verificador no buscó otra vía. La corrección ya estaba aplicada y
`verificar-reporte.sh` coincidía en los tres periodos, pero el hash de junio no se actualizó,
así que el pipeline quedó en rojo en la equivalencia de junio, y el hallazgo del 5.2 no se
marcó como resuelto. Es un límite del entorno de verificación, no del material; la corrida s21
ya había verificado ese cierre en el camino B.

En el camino A, el primer intento de corregir el redondeo dejó dos comercios mal, y la prueba
en junio que pide el 5.3.3 lo detectó antes de darlo por bueno.

Segundos por laboratorio: camino A, 115, 134, 291 y 121; camino B, 138, 77 y 222 hasta el
bloqueo.
