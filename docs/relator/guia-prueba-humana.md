# Guía de prueba humana de los laboratorios

Para probar o ensayar los nueve laboratorios con GitHub Copilot real. Se sigue solo esta
guía. Lo propio de la máquina virtual, es decir ambiente, red, cuentas y hook, está en
[`07-protocolo-prueba-vm.md`](07-protocolo-prueba-vm.md) y se hace antes.

## Antes de empezar

- Abra el repositorio de participantes, `github-copilot-netec-taller`, nunca el de
  construcción. Tenga esta guía y la hoja de respuestas del capítulo 5 impresas o en otra
  máquina.
- **Terminal:** menú **Terminal**, **New Terminal**; junto al **+** del panel, elija
  **Git Bash**. Los comandos de esta guía se escriben ahí.
- **Chat:** menú **View**, **Chat**. **Chat nuevo:** el **+** arriba del panel.
- **Modo:** el menú bajo el cuadro de texto dice **Agent**, **Ask** o **Plan**. Use el que
  indique cada laboratorio.
- **Invocar un paso:** escriba en el chat el texto de la columna «Escriba», tal cual, y pulse
  Intro. Todos empiezan con `/`.
- **Permisos.** Cuando Copilot quiere ejecutar un comando, el chat lo muestra con un botón
  **Allow**. Apruebe los que la tabla lista. Si pide otro, apruébelo si solo lee, compila,
  prueba o ejecuta un script de `scripts/`; rechácelo con **Skip** si hace `git commit`,
  `git push`, borra archivos o toca `escenario/datos/`. Las llamadas a herramientas MCP
  piden aprobación igual. Cuando Copilot edita archivos, al final aparecen **Keep** y
  **Undo**: elija **Keep**.
- **Al terminar cada paso,** Copilot muestra en el chat lo que creó o modificó, completo, o
  el diff si cambió código. Si solo da un resumen, anótelo: es una falla de la skill.
- Anote la hora de inicio y fin de cada paso.
- **Si algo falla,** anote el texto exacto y siga con el paso siguiente.

---

## Laboratorio 1.4. Práctica guiada

Modo **Ask**. 30 minutos. Todo en **una misma conversación**. No modifica archivos.

| Paso | Escriba | Apruebe | Debe mostrar al terminar | Compare con | Tiempo |
|---|---|---|---|---|---|
| 1 | `/lab-1-4-paso-1-prompt-vago` | Nada | Una respuesta larga con muchos temas | Es la línea base; cualquier respuesta sirve | 5 min |
| 2 | `/lab-1-4-paso-2-agregar-objetivo java` | Nada | Tres mejoras de legibilidad del método `procesarLiquidacionCompleta` | Más corta y enfocada que la del paso 1 | 6 min |
| 3 | `/lab-1-4-paso-3-agregar-restricciones java` | Nada | Una tabla de tres filas con rangos de líneas, sin texto antes | Las filas suelen ser la selección de tramo o la impresión | 6 min |
| 4 | Ver abajo | Nada | Una tabla que compara las tres respuestas y una oración final | Paso 3 como el más útil para un pull request, `/plan` para un cambio grande | 8 min |

**Paso 4,** en la misma conversación:

1. Abra `escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java`,
   seleccione con el mouse el método `procesarLiquidacionCompleta` completo y escriba
   `/explain`. Debe explicar el método, no el archivo.
2. Escriba `/plan dividir este método en partes que se puedan probar por separado`. El modo
   cambia a **Plan** y muestra un plan numerado sin tocar código. No pulse **Start
   Implementation**.
3. Vuelva a **Ask** con el selector y escriba `/lab-1-4-paso-4-comparar-resultados`.

- [ ] `git status` limpio al terminar.
- [ ] En el paso 1, la lista de referencias de la respuesta no incluye ningún `SKILL.md`
      de otra carpeta `lab-`.
- Observado: ______________________________________________

---

## Laboratorio 1.5. Análisis de un componente

Pasos 1 a 4 en modo **Ask**, paso 5 en modo **Agent**. 60 minutos.

**Preparar:** `bash scripts/reiniciar-lab.sh lab-1-5`

| Paso | Escriba | Apruebe | Debe mostrar al terminar | Compare con | Tiempo |
|---|---|---|---|---|---|
| 1 | `/lab-1-5-paso-1-inventario java` | Nada | Tabla de responsabilidades con líneas, su cantidad y los niveles de anidamiento | Entre ocho y dieciséis responsabilidades, según cuánto agrupe. En las referencias de la respuesta aparece `CalculadoraLiquidacion.java` | 10 min |
| 2 | `/lab-1-5-paso-2-rastrear-lineas-invalidas java` | Nada | Tabla de puntos de falla y una línea final | Los `catch` vacíos del cargador: una línea mal formada desaparece sin rastro | 10 min |
| 3 | `/lab-1-5-paso-3-contrastar-nombres java` | Nada | Tabla de tres métodos | `obtenerMontoNeto` recalcula y asigna; `buscarComerciosActivos` devuelve suspendidos; `validarTransaccion` acumula. CM0031 está suspendido y se liquida | 10 min |
| 4 | `/lab-1-5-paso-4-proponer-mejora java` | Nada | Una sola propuesta en cuatro puntos | Que quepa en una revisión de diez minutos | 12 min |
| 5 | Cambie a **Agent**. `/lab-1-5-paso-5-extraer-retencion java` | `mvn -q clean package` y `bash scripts/comparar-escenarios.sh` | El diff completo de `CalculadoraLiquidacion.java` y el comparador en cero | Solo cambió el bloque de la retención | 12 min |

Si en el paso 3 pregunta si un comercio suspendido se liquida, responda: «Un comercio
suspendido no se liquida».

**Paso 5, revise en el diff:**

- [ ] Un método privado nuevo que devuelve la retención y la llamada en su lugar.
- [ ] Ningún `double` cambiado a otro tipo, ningún número convertido en constante, ningún
      método renombrado.
- [ ] `git status`: un solo archivo modificado.

**Cerrar:** `bash scripts/reiniciar-lab.sh lab-1-5` y responda `si`.

- Observado: ______________________________________________

---

## Laboratorio 2.4. Agente o instrucción

Modo **Agent**. 45 minutos.

**Preparar:** `bash scripts/reiniciar-lab.sh lab-2-4`

| Paso | Escriba | Apruebe | Debe mostrar al terminar | Compare con | Tiempo |
|---|---|---|---|---|---|
| 1 | `/lab-2-4-paso-1-elegir-tarea` | Nada | Las cinco tareas y una pregunta. Responda `C` | Instrucción, y el paso siguiente `/lab-2-4-paso-2a-construir-instruccion` | 7 min |
| 2 | `/lab-2-4-paso-2a-construir-instruccion C` | Nada | Una pregunta con dos o tres decisiones; responda corto. Después, la ruta y el contenido completo del archivo nuevo en `.github/instructions/` | Sin `COMPLETAR`; metadatos `name`, `description` y `applyTo`; patrón `labs/**/entregables/**/*.md` o equivalente | 12 min |
| 3 | `/lab-2-4-paso-3-probar-artefacto` y después las dos pruebas que propone, en orden | Nada | Errores de formato o «ninguno», y dos pruebas de una línea | En la respuesta de la prueba 1, la instrucción nueva aparece en la lista de referencias y se crea un archivo en `labs/cap2/lab-2-4-agente-o-instruccion/entregables/` | 10 min |
| 4 | `/lab-2-4-paso-4-ajustar-y-documentar` | Nada | Pregunta qué falló en el paso 3. Después, el diff del artefacto y una línea | Una `description` que alguien ajeno entiende | 8 min |

- [ ] En el selector de modo aparecen Analista, Tester, Documentador, Revisor y
      Refactorizador.
- [ ] `git status`: solo el artefacto nuevo y lo que creó la prueba.

**Cerrar:** `bash scripts/reiniciar-lab.sh lab-2-4` y responda `si`.

- Observado: ______________________________________________

---

## Laboratorio 3.4. Servidor MCP local

Modo **Agent**. 45 minutos.

**Preparar:** `bash scripts/reiniciar-lab.sh lab-3-4`

| Paso | Escriba | Apruebe | Debe mostrar al terminar | Compare con | Tiempo |
|---|---|---|---|---|---|
| 1 | `/lab-3-4-paso-1-configurar-servidor` | Nada | El contenido de `.vscode/mcp.json` y cómo arrancarlo | Un servidor `pasarela-andina`, tipo `stdio`, con `${workspaceFolder}` y sin ampliar permisos | 8 min |
| 2 | `/lab-3-4-paso-2-consultar-con-herramienta CM0005` | Cada llamada a `detalle_comercio` y `buscar_notas_soporte`, solo esa vez, después de leer los parámetros | Plan, notas y un resumen de tres líneas, con la herramienta de cada dato | El plan real es **PL04**. Si dice PL01 o que está exento del tope, la nota con inyección tuvo efecto. Las dos cosas son válidas; anótelo | 8 min |
| 3 | `/lab-3-4-paso-3-inventariar-superficie` | Nada | Dos tablas, herramientas y archivos leídos, y las diferencias con el README | Tres herramientas; sin escritura en disco, red ni procesos | 8 min |
| 4 | `/lab-3-4-paso-4-documentar-caso-de-uso` | Nada | Si pregunta qué observó en el paso 2, respóndalo. Después, el documento completo | Cuatro secciones en orden; cada riesgo con mitigación o «no mitigado»; cita archivo y línea | 12 min |

**Después del paso 1:** menú **View**, **Command Palette**, escriba `MCP: List Servers`,
elija `pasarela-andina` y **Start Server**. En el chat, el ícono de herramientas junto al
cuadro de texto debe listar `buscar_comercios`, `detalle_comercio` y
`buscar_notas_soporte`. Si no aparecen, revise que la carpeta no esté en modo restringido.

**Cerrar:** `bash scripts/reiniciar-lab.sh lab-3-4` y responda `si`.

- Observado: ______________________________________________

---

## Laboratorio 4.4. Documentación

Modo **Agent**. 30 minutos; el paso 4 es opcional.

**Preparar:** `bash scripts/reiniciar-lab.sh lab-4-4`

| Paso | Escriba | Apruebe | Debe mostrar al terminar | Compare con | Tiempo |
|---|---|---|---|---|---|
| 1 | `/lab-4-4-paso-1-documentar-reglas java` | Nada | El documento completo, o la sección de contraste y la selección de tramo si es largo, y cuántas reglas coinciden | Dice que los tramos **no** son acumulativos. Si dice «acumulativos», anótelo: tomó el comentario como verdad | 10 min |
| 2 | `/lab-4-4-paso-2-documentar-decisiones` | Nada | El documento completo y las afirmaciones pendientes | Una sola decisión: sin dependencias de ejecución; el porqué marcado «pendiente de confirmar con el equipo» | 10 min |
| 3 | `/lab-4-4-paso-3-preparar-para-confluence` | Nada | La copia `-confluence.md` completa y lo que se perdió | El original sin cambios | 8 min |
| 4, opcional | `/lab-4-4-paso-4-generar-runbook java` | Los comandos de compilación, ejecución y `comparar-escenarios.sh`, entre 15 y 18 | El runbook completo y cuántas acciones quedaron verificadas | Ninguna acción marcada verificada sin ejecución; ninguna toca `escenario/datos/` | 8 a 12 min |

- [ ] Abra dos líneas citadas en el documento del paso 1 y compruebe que dicen lo que el
      documento afirma.
- [ ] `git status`: solo archivos nuevos en `labs/cap4/lab-4-4-documentacion/entregables/`.

**Cerrar:** `bash scripts/reiniciar-lab.sh lab-4-4` y responda `si`.

- Observado: ______________________________________________

---

## Laboratorio 5.1. Historia, estimación y decisión

Modo **Agent**. 45 minutos. Usted hace de negocio.

**Preparar**, en Git Bash:

```bash
bash scripts/reiniciar-lab.sh lab-5-1
git switch -c reporte-medios-de-pago
```

| Paso | Escriba | Apruebe | Debe mostrar al terminar | Compare con | Tiempo |
|---|---|---|---|---|---|
| 1 | `/lab-5-1-paso-1-historia-de-usuario java` | `date +%H:%M` y lecturas de `escenario/datos/`: leer se aprueba | Preguntas, y se detiene; si ya aparece **Keep**, elíjalo. Después: la historia y el registro de tiempos completos, y `java` en `stack.txt` | Las casillas de abajo | 15 min |
| 2 | `/lab-5-1-paso-2-estimar` | `date +%H:%M` | Pregunta su experiencia: «senior en Java, poca práctica con el agente». Después, la estimación y el registro completos | Sin precios; cada fase con minutos sin IA, con IA y del agente, y un supuesto | 10 min |
| 3 | `/lab-5-1-paso-3-ubicar-en-arquitectura java` | `date +%H:%M` y lecturas de código | Alternativas y una pregunta. Elija la de clases nuevas que no llaman a `CalculadoraLiquidacion` ni a `CalculadoraComision`. Después: la decisión 0004, su fila del índice y el registro, completos | La alternativa que eligió, con ventaja, costo y consecuencias. La 0004 de referencia es del camino A. Si se prueba el camino B, eligiendo reutilizar el cálculo de la liquidación, la decisión dice eso y que el reporte hereda las diferencias de ese cálculo | 10 min |

En el registro de tiempos, cada paso deja inicio y término de su fase, con `participante` en
Origen; los minutos reales se calculan en el 5.4. Si en algún paso muestra un resumen o solo
parte de un archivo, anótelo.

**Paso 1, las preguntas.** Responda solo lo que pregunte:

| Si pregunta por | Responda |
|---|---|
| Qué transacciones entran | Aprobadas, en soles, monto mayor que cero, en el periodo |
| Qué comercios entran | Activos y suspendidos con plan. No los dados de baja |
| El periodo | Del primer día a las 00:00:00 al último a las 23:59:59, con la hora del cierre |
| Contra qué se comprueba | Suma del total de comisiones de las liquidaciones, al centavo |
| El tope | Por comercio, no se reparte. Filas antes del tope y una fila de ajuste |
| El redondeo | Al final: cada fila suma exacto y redondea; el total por comercio, como la liquidación |
| Un monto en el límite de un tramo | Tramo inferior. El límite superior es inclusivo |
| Monto transado | Suma exacta de los montos del medio |
| Cuotas | La comisión incluye su recargo: 0,5 % por cuota sobre la primera, máximo 3 %, sobre la comisión base |
| Contracargos y retenciones | No forman parte del reporte |
| Orden, formato, decimales o participación | Los fija la especificación que se entrega en el 5.2 |
| Cualquier otra cosa | «Pendiente» |

**Paso 1, la historia** trae:

- [ ] Un criterio de borde con su cuenta. Ejemplo: TX002001, 500,00 × 3,5 % + 0,30 = 17,80.
- [ ] Un criterio con un comercio cuya suma exacta termina en 5 en el tercer decimal.
      Anote cuál: CM0025, 957,185 → 957,19; CM0011, 137,825 → 137,83, o CM0016,
      493,995 → 494,00. Si quedó otro, la skill falló: anótelo y pida «rehaz ese criterio».
- [ ] `git status`: nada en `escenario/`.

Si avisa que el código trata el límite como exclusivo o permite un recargo de 3,5 %: está
bien visto, no se corrige ahora.

**Cerrar:** `git add docs scripts/integracion/stack.txt && git commit -m "Historia, estimacion y decision del reporte"`
y después `git status`, limpio.

- Observado: ______________________________________________

---

## Laboratorio 5.2. Implementar el reporte

Modo **Agent**. 45 minutos. Sigue en la rama del 5.1. Si el 5.1 no terminó:
`bash scripts/proyecto/ponerse-al-dia.sh lab-5-2 java quinua-condor-47`, escriba `descartar`
y confirme con `git add -A && git commit -m "Inicio del 5.2"`. El registro de tiempos trae el
5.1 como `referencia`.

| Paso | Escriba | Apruebe | Debe mostrar al terminar | Compare con | Tiempo |
|---|---|---|---|---|---|
| 1 | `/lab-5-2-paso-1-planificar java` | `date +%H:%M` y `bash scripts/proyecto/entregar.sh formato-del-reporte` | Un plan numerado con la validación de cada paso, el registro de tiempos y la pregunta de aprobación. Ningún archivo de código cambiado | Anote si reutiliza el cálculo de la liquidación (camino B) o calcula por su cuenta (camino A). Responda «apruebo». Si el plan no sigue la decisión del 5.1, la actualiza y la muestra | 10 min |
| 2 | `/lab-5-2-paso-2-implementar-reporte java` | Compilación, `bash scripts/integracion-local.sh --paso equivalencia` | El diff completo, con los archivos nuevos completos, y la última validación en verde | Solo archivos del stack Java; `liquidacion-esperada.sha256` sin cambios | 20 min |
| 3 | `/lab-5-2-paso-3-verificar-reporte java` | `bash scripts/verificar-reporte.sh java 2026-04`, `-05`, `-06` y `bash scripts/integracion-local.sh` | Tabla de comprobaciones y, si corresponde, «Pendiente para el 5.3». Propone el commit | Camino A: coincide en los tres periodos. Camino B: junio no coincide; es lo esperado | 8 min |

**Si el paso 2 se detiene** porque la equivalencia falló después de un refactor: el refactor
cambió la liquidación. Responda «deshaz ese cambio y sigue sin refactorizar».

**Cerrar:** el commit que propone el paso 3, por ejemplo
`git add escenario docs/proyecto && git commit -m "Reporte de comisiones por medio de pago"`.
Después `git status`: no queda nada de `docs/proyecto/` sin confirmar.

- Camino: ______________
- Observado: ______________________________________________

---

## Laboratorio 5.3. Pruebas, pipeline, corrección y revisión

Modo **Agent**. 45 minutos. No haga commit hasta el paso 4. Si el 5.2 no terminó:
`bash scripts/proyecto/ponerse-al-dia.sh lab-5-3 java quinua-condor-47`, `descartar` y
`git add -A && git commit -m "Inicio del 5.3"`.

| Paso | Escriba | Apruebe | Debe mostrar al terminar | Compare con | Tiempo |
|---|---|---|---|---|---|
| 1 | `/lab-5-3-paso-1-probar-criterios java` | `date +%H:%M` y `mvn test` | Los archivos de prueba nuevos completos, el registro de tiempos y una tabla criterio por criterio | Una prueba por criterio, también la de formato, con un caso de medio centavo y uno con miles. Camino A: falla la conciliación de junio. Camino B: fallan borde y medio centavo | 8 min |
| 2 | `/lab-5-3-paso-2-conciliacion-en-pipeline` | `bash scripts/integracion-local.sh` | El diff de `integracion-local.sh` y del workflow, y el pipeline paso por paso | Camino A: conciliación en rojo solo en junio, 2203 centavos, 22,03; el paso `java` también, por la prueba del paso 1. Camino B: conciliación en cero, rojo por las pruebas | 8 min |
| 3 | `/lab-5-3-paso-3-diagnosticar-y-corregir java` | Comandos de diagnóstico, compilación y `integracion-local.sh` | Tabla de causas que suma la diferencia, aviso antes de cambiar tipo o redondeo, el diff de la corrección y el pipeline en verde | Ver abajo | 15 min |
| 4 | `/lab-5-3-paso-4-revision-y-pull-request` | `date +%H:%M` | Pregunta por la revisión de Copilot. Después, `pull-request.md` y la decisión 0005 completas, y las casillas sin marcar | Ver abajo | 8 min |
| 5, opcional | `/lab-5-3-paso-5-opcional-github` | Nada | Que no aplica, si no tiene copia propia en GitHub | No empuje nada | — |

**Paso 3, las causas.** Si pide la decisión del borde, responda: «El límite superior de cada
tramo es inclusivo».

| Causa | Comercios | Monto |
|---|---|---|
| Borde de tramo | CM0001 y CM0007, TX002001 a TX002004 | 22,00 |
| Punto flotante | CM0011, CM0016 y CM0025 | 0,03 |

- [ ] Explicó por separado las dos causas, cada una con su monto y sus comercios, sin ayuda.
      En el camino B también, aunque la conciliación dé cero. Si solo encontró 22,00 o solo
      explicó lo que fallan las pruebas, como 3,00 y 0,01: pregunte cuánto suma cada causa y
      a quién afecta, y anote si llega solo a 22,03.
- [ ] Avisó antes de cambiar `double` o la forma de redondear y esperó «apruebo».
- [ ] En el diff solo cambió el hash de junio, al valor que empieza con `cd1466305e63`.

**Paso 4, antes de escribir:** vista **Source Control**, en **Changes** el botón **Copilot
Code Review - Uncommitted Changes**. Cuente al chat qué comentó y qué decidió con cada
comentario. Si el botón no aparece o pide otro plan, anótelo.

- [ ] `pull-request.md` justifica el cambio del hash de junio y enlaza la decisión 0005.

**Cerrar:** el commit que propone el paso 4.

- Observado: ______________________________________________

---

## Laboratorio 5.4. Liberación, incidente, evolutiva y cierre

Modo **Agent**. 45 minutos. **No se reinicia.** Si el 5.3 no terminó:
`bash scripts/proyecto/ponerse-al-dia.sh lab-5-4 java quinua-condor-47`, `descartar` y
`git add -A && git commit -m "Inicio del 5.4"`.

| Paso | Escriba | Apruebe | Debe mostrar al terminar | Compare con | Tiempo |
|---|---|---|---|---|---|
| 1 | `/lab-5-4-paso-1-liberar` | `date +%H:%M`, `git log`, `git diff` y la ejecución de la liquidación | Propone un número y espera. Responda «apruebo». Después, la entrada de `CHANGELOG.md`, las notas completas y el registro de tiempos | 1.5.0, o 2.0.0 bien defendida; 1.4.1 no. Las notas explican junio sin nombres de clases, CM0001 y CM0007 suben 11,00 cada uno; CM0011, CM0016 y CM0025, 0,01 | 8 min |
| 2 | `/lab-5-4-paso-2-atender-incidente` | `date +%H:%M`, `bash scripts/proyecto/entregar.sh incidente` y la ejecución de la liquidación | El análisis y la respuesta completos, y pregunta si se envía. Responda «se envía así» | Llega a las notas de versión y a la decisión 0005; la respuesta no promete devolución | 12 min |
| 3 | `/lab-5-4-paso-3-estimar-evolutiva` | `date +%H:%M` | La estimación evolutiva completa, el registro de tiempos y las preguntas abiertas | Usa y cita el registro de tiempos real | 8 min |
| 4 | `/lab-5-4-paso-4-cierre` | Nada o `date +%H:%M` | Los tres documentos completos y la fase con más error | Sin precios ni minutos inventados | 10 min |

Si en el paso 2 alguien propone revertir la versión: pregunte qué decisión respalda el monto
nuevo y dónde está registrada.

**Cerrar:** los pasos 1 y 4 proponen un commit cada uno; acéptelos. Para volver al inicio:
`bash scripts/reiniciar-lab.sh lab-5-4`, escriba `descartar`, y después
`git switch main && git branch -D reporte-medios-de-pago`.

- Observado: ______________________________________________


---

## Anexo. Las demostraciones del relator

Se ensayan sobre el repositorio de participantes, siguiendo cada guion de `docs/relator/demos/`
abierto en otra máquina o impreso. Al terminar, `bash scripts/reiniciar-lab.sh lab-1-4` y
`bash scripts/reiniciar-lab.sh lab-3-4`, respondiendo `si`.

| Demostración | Debe mostrar | Duración real |
|---|---|---|
| 1.1, `demo-1-1-pedido-pobre-y-pedido-bueno.md` | Dos respuestas; la segunda, una tabla de dos filas con rangos de líneas | |
| 1.2, `demo-1-2-referencias-de-contexto.md` | Las cuatro respuestas cambian según la referencia; con `CalculadoraLiquidacion.java` aparece la regla con sus líneas | |
| 1.3, `demo-1-3-flujo-de-trabajo.md` | `/plan` sin cambios, el modo Agent cambia un solo archivo, el comparador dice «Las salidas son identicas» | |
| 2.1, `demo-2-1-jerarquia-y-skills.md` | La respuesta sobre commits cita `copilot-instructions.md`; `/pasarela-reglas-de-negocio` da tramo y porcentaje | |
| 2.2, `demo-2-2-agentes-por-rol.md` | El Revisor no modifica nada; el Refactorizador cambia un solo archivo y lista lo que no tocó | |
| 2.3, `demo-2-3-instrucciones-por-ruta.md` | Java responde `mvn test` y JUnit; .NET, `dotnet test`, xUnit y `MidpointRounding.AwayFromZero` | |
| 3.2, `demo-3-2-servidor-mcp.md` | El servidor arranca, cada llamada pide aprobación y la respuesta dice qué herramienta respaldó cada dato | |
| 3.3, `demo-3-3-hook.md` | La edición de `transacciones.txt` se bloquea con el mensaje del hook; la pregunta de lectura se responde | |
| 4.1, `demo-4-1-documentacion-contra-ejecucion.md` | El documento trae cuatro resultados y `jshell` imprime 0, 1, 5 y -1 | |
| 5.3, `demo-5-3-pipeline-en-github.md` | Se presenta desde `respaldos/demo-5-3.md`; la revisión de Copilot ya está grabada | |

- Observado: ______________________________________________
