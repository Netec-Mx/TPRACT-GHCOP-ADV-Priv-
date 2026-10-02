# Verificación de las skills como agente

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
| 1.3 Analizar, planear, implementar y validar | Sin dato | **No ejecutada** | El control de permisos del entorno de verificación bloqueó los comandos de implementación y validación. No se intentó rodear el bloqueo |
| 2.1 Jerarquía y skills | 6 | Coincide | `copilot-instructions.md` en las referencias. La skill respondió PL01, tramo 500 a 2000, 2,9 % |
| 2.2 Agentes por rol | 110 | Parcial | El Revisor no modificó nada. El Refactorizador cambió un solo archivo. La compilación y el comparador fueron bloqueados por el mismo control de permisos |
| 2.3 Instrucciones por ruta | 29 | Coincide | `mvn test` y JUnit 5 para Java, `dotnet test` y xUnit para .NET, con su instrucción en las referencias |
| 3.2 Servidor MCP | 32 | Coincide | Dos llamadas aprobadas, `buscar_comercios` y `detalle_comercio` |
| 3.3 Hook | 23 | Parcial, corregido | El hook bloqueó la edición y una escritura por terminal, y dejó pasar la lectura. El guion citaba el mensaje con tildes y el script lo imprime sin tildes. Se corrigió el guion |
| 4.1 Documentación contra ejecución | 36 | Coincide | La documentación predijo 0, 1, 5 y -1, y la ejecución dio 0, 1, 5 y -1 |

### Correcciones a los guiones a partir de la verificación

- 3.3. El mensaje del hook se cita literal y se agrega la cantidad esperada de
  transacciones, 2037.
- 3.2. Se aclara que hay que crear la carpeta `.vscode` y qué comercio es «el primero».
- Todas. Donde se reinicia un laboratorio, se aclara que hay que responder `si`.

### Pendiente

La demostración 1.3 no tiene ejecución de verificación ni respaldo. La 2.2 tiene un respaldo
sin compilación ni comparador. Las dos se completan con el bloque G del protocolo de la
máquina virtual.
