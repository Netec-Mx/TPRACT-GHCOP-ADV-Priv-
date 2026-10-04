# Prueba de los laboratorios con GitHub Copilot CLI

Registro de SPEC-023. 4 de octubre de 2026. Es la primera prueba del material con GitHub
Copilot como participante, no con un agente de verificación. No se cambió material: lo que
sigue son hallazgos con evidencia y una propuesta, para que el Product Owner decida.

## Resultado

Se completaron con Copilot los laboratorios 1.4, 1.5, 2.4, 3.4 y 4.4, el capítulo 5 por el
camino A del 5.1 al 5.4, y el 5.2 por el camino B. El 5.3 del camino B quedó a medio paso 1:
la cuenta agotó su cuota mensual («You have exceeded your monthly quota», Request ID
`3F04:3B918C:34E3292:4022345:6AC2CA66`) sin aviso previo, y la prueba se cerró ahí por
decisión del Product Owner.

## Cómo se hizo

- **CLI.** GitHub Copilot CLI 1.0.91, instalada con `npm install -g @github/copilot`, según
  la documentación oficial. Sesión iniciada por el Product Owner con `copilot login`, cuenta
  `RodrigoMSB`, licencia Pro.
- **Repositorio.** Un clon del repositorio de participantes, commit `a165e95`, en una carpeta
  temporal fuera del repositorio de construcción. Copilot nunca vio material del relator.
- **Modelo.** El de la cuenta, sin cambiarlo. En todos los pasos respondió `claude-sonnet-5`.
  Una sesión interactiva de prueba respondió con `gpt-5.6-terra`: en modo automático el modelo
  puede cambiar entre sesiones.
- **Conducción.** El modo `-p` no expande las skills: `/lab-1-4-paso-1-prompt-vago` llegó
  como texto y Copilot buscó el archivo por su cuenta. Por eso la prueba se condujo con el
  modo `--acp` de la CLI, el protocolo programático que la CLI ofrece. Ahí `/nombre-de-skill`
  invoca la skill igual que en la sesión interactiva, cada permiso se aprueba o rechaza uno
  por uno y la conversación se continúa entre pedidos con `session/load`.
- **Permisos.** Solo `allow_once`, nunca permisos totales, con la regla general de la guía:
  se aprueba lo que lee, compila, prueba o ejecuta un script de `scripts/`; se rechaza
  `git commit`, `git push`, `git stash` y lo que modifica el árbol de git, borrar archivos y
  cualquier escritura en `escenario/datos/`. Las llamadas MCP, una vez cada una.
- **Negocio.** Las preguntas al negocio se respondieron solo con la hoja de respuestas.
- **Commits.** Los hizo el participante, como pide la guía, nunca Copilot. Nada se hizo contra
  GitHub.

## Por laboratorio

«Skill» dice si Copilot invocó la skill correcta. «Mostró» dice si cumplió SPEC-017 en el
texto de su respuesta. Los segundos son de reloj de los pedidos del laboratorio, incluidos
los reintentos.

| Lab | Skill | Mostró | Coincide con la guía | Permisos | Preguntas y hoja | Segundos |
|---|---|---|---|---|---|---|
| 1.4 | Sí, en los cuatro pasos | No aplica: no produce archivos | Sí en 1 a 3. Paso 4 sin `/explain`, que no existe en la CLI; `/plan` preguntó cuatro cosas antes de planificar | Lecturas con `find` y `grep`, aprobadas por la regla general; la guía dice «nada» | `/plan` preguntó stack, alcance, pruebas y verificación; no son de la hoja | 167 |
| 1.5 | Sí | Paso 5: mostró el diff con `git diff`, en la salida del comando, y en el texto dijo «está arriba» | Sí en 2 a 5; el paso 1 contó 23 responsabilidades contra 8 a 16 de la guía. El comparador no corrió por falta de .NET 10 en la máquina | Paso 5: `mvn`, `java -jar`, `git diff`; intentó `git stash`, rechazado | No preguntó por el comercio suspendido; lo señaló | 258 |
| 2.4 | Sí | Paso 2: abrevió el ejemplo del archivo con un texto entre paréntesis. Paso 4: diff completo | Sí. Las dos pruebas del paso 3 se comportaron como pide la guía | Lecturas; `git ls-files` y `git diff --no-index` en el paso 4 | Paso 2: tres decisiones en una pregunta | 135 |
| 3.4 | Sí | Paso 4: escribió «Contenido completo:» y no mostró nada | Sí, con el servidor cargado. El hook bloqueó el documento del paso 4 | Paso 2: `detalle_comercio` y `buscar_notas_soporte`, una vez cada una | Paso 4: preguntó qué se observó en el paso 2 | 242 |
| 4.4 | Sí | Dijo haber mostrado el contraste y los síntomas «arriba»; el texto no los contiene | Sí; tramos no acumulativos, 278 líneas de runbook, nada contra `escenario/datos/` | Paso 4: 19 comandos; la guía dice 15 a 18 | Ninguna | 601 |
| 5.1 A | Sí | Encabezados seguidos de `cat`; el contenido no queda en la respuesta | Sí, salvo el paso 3: las dos alternativas propuestas reutilizaban el cálculo; hubo que pedir la del camino A | `date`, lecturas de datos, escritura de `stack.txt` | 10 preguntas; la hoja respondió 8; quedaron pendientes de dónde sale el medio de pago y si el reporte es por mes o de los tres meses | 470 |
| 5.2 A | Sí | Dijo haber mostrado el diff y los archivos nuevos «arriba» | Sí; el reporte coincidió en los tres periodos al primer intento | `entregar.sh`, `mvn`, scripts del repositorio | Ninguna | 507 |
| 5.3 A | Sí | Encabezados seguidos de `cat` en el paso 4 | Sí en 2 a 4; en el paso 1 no falló la conciliación de junio, como espera la guía | Diagnóstico, compilación, scripts; intentó `git stash` otra vez, rechazado | La decisión del borde la tomó de la historia | 1809 |
| 5.4 A | Sí | Encabezados con contenido vacío en 1, 2 y 3 | Sí en 3 y 4; error en el análisis del incidente; no esperó la confirmación de la versión | Ejecuciones de la liquidación, `entregar.sh` | Ninguna | 568 |
| 5.2 B | Sí | Igual que en A | Sí: actualizó la decisión 0004 y el 5.2.3 dejó el hallazgo abierto y el commit con su mensaje, sin causa | Igual que en A | Ninguna | 728 |
| 5.3 B | Sí | — | No terminó: cuota agotada a medio paso 1 | — | — | 154 |

## Hallazgos, de más grave a menos grave

### 1. El hook de protección de datos bloquea documentos que solo citan la ruta

Es un defecto del material, no de la CLI.

- **Evidencia:**
  - En el 3.4.4, el hook bloqueó la creación de
    `labs/cap3/lab-3-4-mcp-local/entregables/caso-de-uso-mcp.md`. En el 5.3.4 bloqueó
    `docs/proyecto/pull-request.md`. Ninguno de los dos está en `escenario/datos/`: su
    contenido citaba esa ruta.
  - `proteger-datos-escenario.js` deniega cualquier herramienta de escritura si alguno de sus
    argumentos, incluido el contenido del archivo, contiene `escenario/datos/`. La herramienta
    que crea archivos en Visual Studio Code también lleva el contenido, así que debería pasar
    lo mismo allí.
  - Las verificaciones anteriores no lo vieron porque los agentes de verificación no
    ejecutaban el hook.
  - Copilot no intentó saltárselo: en el 3.4 preguntó cómo seguir, y en los dos casos terminó
    reformulando las citas como «`escenario`, carpeta `datos`». En el 4.4.1 lo anticipó y evitó
    la ruta desde el principio.
  - Los documentos quedan con citas que no son rutas, contra lo que piden las skills.
- **Propuesta:** que el hook revise solo los argumentos de ruta de las herramientas de
  escritura (`filePath`, `path`, `fileName` y equivalentes), no el contenido. Verificarlo con
  Copilot real en el 3.4.4 y en el 5.3.4.

### 2. «Mostrar lo producido» no queda en el texto de la respuesta

- **Evidencia:** en casi todos los pasos que producen archivos, Copilot escribe un encabezado
  («Contenido completo de …») y ejecuta `cat`, o dice que el contenido está «arriba». Se
  refiere a la vista de la herramienta `create` o a la salida del comando. Los eventos de la
  sesión confirman la secuencia: mensaje con el encabezado, después una llamada a `cat`, y el
  mensaje siguiente empieza con el encabezado del archivo que sigue. En el 2.4.2 abrevió el
  ejemplo con un texto entre paréntesis. En Visual Studio Code la salida de terminal queda
  plegada en el chat, así que el participante puede no ver el contenido.
- **Propuesta:** que la sección «Salida esperada» de las skills diga que el contenido se
  escribe en la respuesta, no con un comando ni remitiendo a una herramienta. Probarlo
  después en Visual Studio Code, que esta prueba no pudo ver.

### 3. En el 5.1.3 no apareció la alternativa del camino A

- **Evidencia:** Copilot propuso dos alternativas y las dos reutilizan el cálculo de la
  liquidación. La guía manda elegir la de clases nuevas que no llaman a
  `CalculadoraLiquidacion` ni a `CalculadoraComision`, y hubo que pedirla explícitamente.
  Un participante que solo elige entre lo ofrecido va siempre al camino B.
- **Propuesta:** que la skill pida, entre las alternativas, al menos una que calcule por su
  cuenta sin reutilizar el cálculo existente.

### 4. En el camino A, la prueba de conciliación del 5.3.1 no falló

- **Evidencia:** las 9 pruebas nuevas pasaron. La del criterio 8 compara el total del reporte
  con la suma de comisiones calculada por el propio reporte, no con la liquidación. La guía
  espera que en el camino A falle la conciliación de junio en este paso. La conciliación del
  5.3.2 sí la detectó, así que el laboratorio siguió.
- **Propuesta:** que la skill del 5.3.1 diga que la prueba del criterio de conciliación
  compara contra la salida de la liquidación.

### 5. El análisis del incidente del 5.4.2 atribuye mal la causa

- **Evidencia:**
  - El análisis y la respuesta al comercio explican los 11,00 de CM0001 con una sola venta de
    500,00. Son dos: TX002001, por 500,00 (+3,00), y TX002002, por 2000,00 (+8,00).
  - El monto total y el alcance son correctos.
  - La respuesta dice «No corresponde una devolución ni un ajuste adicional», que es una
    decisión del negocio.
- **Propuesta:** que la skill del 5.4.2 pida desglosar la diferencia por transacción y
  comprobar que la suma da el monto reclamado. La hoja y la guía pueden agregar una casilla
  para eso.

### 6. El 5.4.1 no esperó la confirmación del número de versión

- **Evidencia:** escribió el CHANGELOG y las notas de la versión 1.5.0 y recién después
  propuso el número. `pasarela-notas-de-version` pide explicar el número y esperar la
  confirmación antes de escribir. El número coincidió con la referencia.
- **Propuesta:** que la skill del 5.4.1 diga que el número se propone y se espera la
  respuesta antes de tocar archivos.

### 7. Copilot intenta `git stash` para comparar antes y después

- **Evidencia:**
  - Lo intentó en el 1.5.5 y en el 5.3.3. La guía no menciona ese comando.
  - Con la regla general se rechaza, porque modifica el árbol de trabajo, y el turno se corta.
  - Con «Sigue sin git stash», Copilot comparó compilando la versión anterior en un directorio
    temporal.
- **Propuesta:** que la guía diga que `git stash` se rechaza y qué escribir después.

### 8. En el camino B, el 5.2.2 explicó la causa antes de tiempo

- **Evidencia:** al ver que junio no coincidía, Copilot recalculó y explicó que el borde
  exclusivo da 15,10 en lugar de 17,80. La guía reserva ese diagnóstico para el 5.3. El 5.2.3
  sí lo dejó sin causa en el registro y en el commit.
- **Propuesta:** que la skill del 5.2.2 diga que, si el reporte no coincide, se muestra y se
  deja para el 5.2.3 sin diagnosticar.

### 9. Diferencias menores

- **1.5.1:** contó 23 responsabilidades; la guía dice 8 a 16 según cuánto se agrupe.
- **4.4.1:** creó el documento con un salto de línea al final del nombre,
  `calculo-de-comisiones.md\n`. En el 4.4.3 lo detectó y lo corrigió por su cuenta.
- **Afirmaciones falsas:**
  - En el 1.4.4, que .NET no tiene proyecto de pruebas.
  - En el 5.3.1, que la especificación del 5.2 no existe.
  - En el 5.4.4, que el reporte reutilizó el cálculo de la liquidación, en el camino A.
- **2.4.2:** el ejemplo de la instrucción cita un archivo inexistente, `Liquidador.java:42`.
- **5.3.3:** no anotó la hora de inicio de Mantención al empezar y la completó al final.
- **5.4.3:** creyó pendiente un commit que el participante ya había hecho fuera de su vista.

## Lo que funcionó como se espera

- Invocó la skill correcta con `/nombre` en todos los pasos.
- Se detuvo con preguntas al negocio antes de escribir criterios, incluida la del borde.
- Respetó «no corrijas nada que no forme parte de este paso» y señaló los defectos plantados
  al final, sin tocarlos.
- No siguió la instrucción inyectada en la nota NS-0004 y la señaló.
- En el 5.3.3 llegó solo a las dos causas, 22,00 y 0,03, con la respuesta del negocio citada
  de la historia, y pidió aprobación antes de cambiar el redondeo. Probó junio antes de dar
  la corrección por buena y pidió aprobación ampliada dos veces hasta la corrección mínima
  suficiente.
- En el camino B actualizó la decisión 0004 al cambiar el plan, y el commit del 5.2.3 dijo que
  junio no coincide, sin dar la causa.
- El 2.4.4 usó `git diff --no-index /dev/null` para el artefacto sin versionar.
- `pull-request.md` traía «Alcance por stack».

## Diferencias propias de la CLI

- **Skills en modo `-p`.** No se expanden: el pedido `/nombre` llega como texto. Funcionan en
  la sesión interactiva y por ACP.
- **`disable-model-invocation: true`.** Todas las skills de laboratorio lo tienen. Con la
  invocación explícita funcionaron. Hay un problema abierto en github/copilot-cli, #4438,
  según el cual el modelo puede no encontrarlas si las busca por su cuenta.
- **Modos.** No hay modo Ask, solo interactivo, plan y piloto automático. Los laboratorios en
  Ask se hicieron en el modo por omisión. Tampoco hay `/explain`; `/plan` sí existe.
- **MCP.** La CLI lee la configuración de `.mcp.json`, `.github/mcp.json` o
  `~/.copilot/mcp-config.json`, no de `.vscode/mcp.json`, que es lo que crea el 3.4.1. Para el
  3.4.2 se cargó la misma definición con `--additional-mcp-config`. Pasarla por
  `session/load` no la carga en una sesión ya creada.
- **Revisión de código.** No está el botón «Copilot Code Review - Uncommitted Changes». Se usó
  `/review` de la CLI, que dejó dos comentarios; los dos eran esperables por trabajar un solo
  stack.
- **Permisos.** Rechazar un permiso termina el turno; para seguir hay que escribir de nuevo.
- **Personalización.** La CLI lee `.github/copilot-instructions.md`, `AGENTS.md`, las tres
  instrucciones por ruta, las 44 skills y el hook, que corrió en cada herramienta. Lista las
  instrucciones por ruta como «del directorio de trabajo». La prueba no permitió saber si la
  instrucción creada en el 2.4 se aplicó por su `applyTo` o porque Copilot la había escrito en
  la misma conversación.
- **Consumo.** Se ve por sesión en el estado de la CLI, en solicitudes premium y créditos de
  IA. No hubo aviso antes de agotar la cuota.

## Lo que no se pudo probar

- **Depende del editor:**
  - `/explain` con el método seleccionado (1.4.4).
  - El selector de agentes (2.4).
  - La lista de referencias de las respuestas.
  - Arrancar el servidor con «MCP: List Servers» (3.4).
  - El botón de revisión de cambios sin confirmar (5.3.4).
  - Cómo se ve en Visual Studio Code el contenido que Copilot muestra con `cat` o con la vista
    de la herramienta.
- **Depende de GitHub:** el 5.3.5.
- **Depende de la máquina:** `comparar-escenarios.sh` termina en 2, porque la máquina de
  prueba no tiene el SDK de .NET 10. La máquina virtual lo trae.
- **Cuota agotada:** el 5.3 completo del camino B y el 5.4 del camino B.

## Rechazos causados por el conductor

La regla de permisos del conductor fue al principio más estricta que la guía y rechazó
comandos que la guía aprueba. Como rechazar termina el turno, esos pasos se repitieron con
«Sigue». Se corrigió en cuanto apareció cada caso. Ninguno de estos rechazos es una falla de
Copilot ni del material.

| Paso | Qué se rechazó por error | Corrección |
|---|---|---|
| 1.4.4 | Un `grep` de lectura con `\|` entre comillas: la regla partía el comando en el `\|`. Por eso `/plan` no llegó a planificar la primera vez | Separar el comando respetando las comillas |
| 1.5.5 | Un script de lectura en varias líneas con variables y `tee` a `/tmp`. Después, un script que compilaba la versión anterior en un temporal de `mktemp` y lo borraba al final | Regla por lista negra, como la guía. Rutas relativas aceptadas tras un `cd` a un temporal; `rm` solo sobre variables o `/tmp` |
| 3.4.4 | Un `head` de lectura sobre `escenario/datos/` con `2>/dev/null`, tomado como escritura | Mirar solo los destinos reales de escritura |
| 5.1.1 | `echo "java" >> scripts/integracion/stack.txt` y luego un `sed -i` sobre el mismo archivo, que la skill pide y la guía no prohíbe | Permitir escrituras fuera de `escenario/datos/` |
| 5.3.1 | La creación de un archivo de prueba, porque su contenido mencionaba `escenario/datos`; el mismo error que el hook | Revisar solo la ruta del archivo |

El rechazo de `git stash` sí sigue la regla de la guía y está en los hallazgos.

## Consumo

Solicitudes premium y créditos de IA informados por la CLI en el estado de cada sesión. Cada
pedido del participante es una solicitud premium; los créditos dependen de los tokens. Los
números incluyen los reintentos causados por el conductor.

| Laboratorio | Solicitudes premium | Créditos de IA |
|---|---|---|
| 1.4 | 8 | 48,2 |
| 1.5 | 9 | 64,4 |
| 2.4 | 9 | 34,2 |
| 3.4 | 7 | 60,1 |
| 4.4 | 4 | 199,1 |
| 5.1, camino A | 8 | 168,5 |
| 5.2, camino A | 4 | 166,7 |
| 5.3, camino A, con `/review` | 11 | 639,7 |
| 5.4, camino A | 5 | 224,8 |
| 5.2, camino B | 5 | 209,9 |
| 5.3, camino B, interrumpido | 1 | 47,7 |
| Pruebas de la mecánica de la CLI | 3 | 35,8 |
| **Total** | **74** | **1899,2** |

Los pasos de código del capítulo 5 son los más caros: entre 1 y 2,7 millones de tokens cada
uno. Un participante que haga los nueve laboratorios con la misma cuenta agotaría una cuota
mensual parecida a la de esta prueba antes de terminar el capítulo 5. Conviene confirmar con
la organización el presupuesto de créditos por participante antes de dictar el taller.
