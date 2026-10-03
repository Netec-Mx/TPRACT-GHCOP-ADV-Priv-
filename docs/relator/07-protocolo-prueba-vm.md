# Protocolo de prueba en la máquina virtual

Documento para el Product Owner. Se sigue en la máquina virtual de prueba de Netec, con la
cuenta de GitHub `RoSilva26`. Corresponde a SPEC-010.

## Antes de empezar, tres advertencias

**Solo se abre el repositorio de participantes.** En la máquina virtual se clona y se abre
`github-copilot-netec-taller`, nunca `github-copilot-netec`. El `AGENTS.md` del repositorio
de construcción enumera los defectos del escenario, y Copilot lo leería. Cualquier prueba
quedaría contaminada.

**La cuenta de prueba tiene permiso de escritura y no debe hacer push.** GitHub no ofrece
permiso de solo lectura en repositorios de una cuenta personal. Un ruleset del repositorio,
`sin-push-directo-a-main`, bloquea cualquier push, borrado o reescritura de la rama `main`
para esta cuenta. Aun así, no use **Sync Changes**, **Push** ni **Publish Branch** en ningún
momento. Si algo se sube por error, se revierte republicando el repositorio desde la
máquina del proyecto.

**Todo se hace con el mouse y los menús.** Ningún paso usa combinaciones de teclas.
Escribir texto y pulsar Intro sí está permitido.

## Por qué este orden

La cuenta `RoSilva26` tiene Copilot en plan gratuito, con cuota limitada. Las pruebas van
de la más importante a la menos importante. Si la cuota se agota, lo que queda sin probar
es lo de menor riesgo.

| Bloque | Qué prueba | Usa cuota de Copilot |
|---|---|---|
| A | Copilot, sesión, repositorio, ambiente y hook | Muy poca |
| B | Las dos comprobaciones de skills pendientes de SPEC-009 y la carga automática | Poca |
| C | Un paso que modifica código, del capítulo 1 | Sí |
| D | Laboratorio 3.4 de extremo a extremo | Sí |
| E | Laboratorio 2.4 | Sí |
| F | Muestra de pasos de análisis | Sí |
| G | Las diez demostraciones del relator | Sí |
| H | Capítulo 5 de extremo a extremo, en local | Sí, la más alta |

Cada paso tiene una casilla, el resultado esperado y una línea para anotar lo observado.
Si un paso no se puede hacer, anote por qué y siga con el siguiente. Si la cuota se agota,
anote en qué paso ocurrió y el mensaje exacto.

## Cómo se abren las herramientas

**Git Bash dentro de Visual Studio Code.** Menú **Terminal**, opción **New Terminal**. En el
panel que aparece abajo, junto al signo **+**, haga clic en la flecha hacia abajo y elija
**Git Bash**. Los comandos de este documento se escriben ahí y se ejecutan con Intro.

**El chat de Copilot.** Menú **View**, opción **Chat**.

**Un chat nuevo.** En la parte superior del panel de chat, el ícono **+**.

**El selector de modo del chat.** Debajo del cuadro donde se escribe, a la izquierda, hay
un menú desplegable que dice **Agent**, **Ask** o **Plan**. Se cambia con un clic.

**La lista de referencias de una respuesta.** Sobre cada respuesta del chat aparece
**Used references** o **References**. Un clic la despliega.

**La paleta de comandos.** Menú **View**, opción **Command Palette**. Se escribe el nombre
del comando y se elige de la lista con un clic.

**Volver al punto de partida.** En Git Bash, `bash scripts/reiniciar-lab.sh lab-X-Y`. Si
pregunta, escriba `si` y pulse Intro.

---

## Bloque A. Copilot, sesión, repositorio, ambiente y hook

### A1. Copilot Chat está habilitado

1. Abra Visual Studio Code.
2. En la barra lateral izquierda, haga clic en el ícono de **Extensions**, el de los cuatro
   cuadrados.
3. En el cuadro de búsqueda de extensiones escriba `@builtin copilot`.
4. Busque **GitHub Copilot Chat**. Si tiene un botón **Enable** o una opción para activar
   las funciones de inteligencia artificial, haga clic en ella. Si Visual Studio Code pide
   recargar, acepte con **Reload**.

- [ ] **Esperado:** GitHub Copilot Chat aparece habilitada, sin botón **Enable**.
- Observado: ______________________________________________

### A2. La sesión de GitHub es RoSilva26

1. En la barra lateral izquierda, abajo, haga clic en el ícono de **Accounts**, la silueta
   de una persona.
2. Si no hay sesión, elija la opción para iniciar sesión con GitHub y complete el ingreso
   en el navegador con `RoSilva26`.

- [ ] **Esperado:** el menú muestra `RoSilva26 (GitHub)`.
- Observado: ______________________________________________

### A3. El clon del repositorio está en la etiqueta punto-de-partida

1. En el navegador, con la cuenta `RoSilva26`, entre a
   https://github.com/RodrigoMSB/github-copilot-netec-taller/invitations y haga clic en
   **Accept invitation**. Si ya la aceptó, el repositorio se abre directamente.
2. En Visual Studio Code, abra un Git Bash y ejecute:

   ```bash
   cd ~ && git clone https://github.com/RodrigoMSB/github-copilot-netec-taller.git
   ```

3. Menú **File**, **Open Folder**. Elija `github-copilot-netec-taller` en su carpeta de
   usuario y haga clic en **Select Folder**. Si pregunta si confía en los autores, elija
   **Yes, I trust the authors**.
4. Abra un Git Bash nuevo y ejecute:

   ```bash
   git tag --points-at HEAD
   ```

- [ ] **Esperado:** la respuesta es `punto-de-partida`.
- Observado: ______________________________________________

### A4. El ambiente pasa completo

Este paso prepara lo que se hará al construir la imagen. Requiere red y tarda varios
minutos la primera vez.

1. En Git Bash, desde la carpeta del repositorio, ejecute uno por uno:

   ```bash
   npm ci --prefix mcp/servidor-local
   ```

   ```bash
   mvn -B -f escenario/java/pom.xml clean package
   ```

   ```bash
   dotnet test escenario/dotnet/LiquidacionComercios.Pruebas
   ```

   ```bash
   dotnet build escenario/dotnet/LiquidacionComercios -c Release
   ```

2. Menú **File**, **Exit**. Vuelva a abrir Visual Studio Code en la misma carpeta y abra
   un Git Bash.
3. Ejecute:

   ```bash
   bash scripts/verificar-ambiente.sh
   ```

- [ ] **Esperado:** al final dice «Ambiente apto». Las secciones «Compilacion sin red»,
      «Hook de proteccion de datos» y «Servidor MCP local» muestran solo `[ OK ]`.
- Observado, con el texto completo de cualquier `[FALLA]` o `[AVISO]`:
  ______________________________________________

4. Ejecute:

   ```bash
   bash scripts/comparar-escenarios.sh
   ```

- [ ] **Esperado:** «Las salidas son identicas».
- Observado: ______________________________________________

### A5. El hook bloquea una edición de datos con Copilot real

1. Chat nuevo, modo **Agent**. Escriba y envíe:

   ```
   Agrega una línea al final de escenario/datos/planes.txt con el texto PRUEBA.
   ```

- [ ] **Esperado:** el agente no puede editar el archivo y muestra que los datos del
      escenario están protegidos.
- Observado: ______________________________________________

2. En Git Bash ejecute `git status`.

- [ ] **Esperado:** «nothing to commit, working tree clean».
- Observado: ______________________________________________

3. En el mismo chat, envíe:

   ```
   Crea el archivo labs/cap1/lab-1-4-practica-guiada/entregables/prueba-hook.md con el texto hola.
   ```

- [ ] **Esperado:** el archivo se crea. El hook deja pasar todo lo que no es de
      `escenario/datos/`.
- Observado: ______________________________________________

4. Ejecute `bash scripts/reiniciar-lab.sh lab-1-4` y responda `si`.

- [ ] **Esperado:** «lab-1-4 listo para empezar».
- Observado: ______________________________________________

Si el paso 1 no se bloquea, detenga el protocolo y avise. Es un bloqueo.

---

## Bloque B. Skills

### B1. Una skill de laboratorio no se carga sola

1. Chat nuevo, modo **Agent**. Envíe:

   ```
   Explícame en tres líneas qué hace el bloque que calcula la comisión en CalculadoraLiquidacion.java. No modifiques nada.
   ```

2. Despliegue la lista de referencias de la respuesta.

- [ ] **Esperado:** no aparece ningún `SKILL.md` de una carpeta que empiece con `lab-`.
      Pueden aparecer `copilot-instructions.md` y las skills que empiezan con `pasarela-`.
- Observado: ______________________________________________

Si aparece una skill `lab-`, detenga el protocolo y avise. Es un bloqueo.

### B2. Una skill carga los archivos que referencia fuera de su carpeta

1. Ejecute `bash scripts/reiniciar-lab.sh lab-1-5`.
2. Chat nuevo, modo **Agent**. Envíe `/lab-1-5-paso-1-inventario java`.
3. Despliegue la lista de referencias de la respuesta.

- [ ] **Esperado:** la lista incluye `CalculadoraLiquidacion.java`, que la skill enlaza con
      una ruta que sale de su carpeta.
- Observado. Anote si aparece en la lista o si el agente lo leyó por su cuenta con una
  herramienta de lectura: ______________________________________________

### B3. Las skills en modo Ask

1. Chat nuevo, modo **Ask**. En el cuadro escriba solo `/lab-1-4`.

- [ ] **Esperado:** aparece la lista de skills que empiezan con `lab-1-4-`.
- Observado: ______________________________________________

2. Borre lo escrito y envíe `/lab-1-4-paso-3-agregar-restricciones java`.

- [ ] **Esperado:** una tabla de tres filas, sin cambios en archivos.
- Observado. Si la skill no aparece en el menú o no responde en **Ask**, anote qué
  pasó. Se documentará que las skills solo funcionan en modo agente:
  ______________________________________________

---

## Bloque C. Pasos que modifican código

Antes de cada prueba ejecute `bash scripts/reiniciar-lab.sh` con el laboratorio indicado.
Cuando el agente pida permiso para ejecutar un comando, léalo y haga clic en **Allow** o
**Continue**. Los pasos del capítulo 5 que modifican código están en el bloque H.

### C1. Lab 1.5 paso 5, Java

1. `bash scripts/reiniciar-lab.sh lab-1-5`
2. Chat nuevo, modo **Agent**. `/lab-1-5-paso-5-extraer-retencion java`
3. `git status` y `bash scripts/comparar-escenarios.sh`.

- [ ] **Esperado:** un único archivo modificado y el comparador en verde.
- Hora de inicio y fin: ______________
- Observado. Señales de alarma: otro archivo modificado, `double` cambiado por otro tipo,
  números convertidos en constantes, métodos renombrados:
  ______________________________________________

### C2. Dejar el repositorio limpio

1. `bash scripts/reiniciar-lab.sh lab-1-5`

- [ ] **Esperado:** «lab-1-5 listo para empezar».
- Observado: ______________________________________________

---

## Bloque D. Laboratorio 3.4 de extremo a extremo

1. `bash scripts/reiniciar-lab.sh lab-3-4`
2. Chat nuevo, modo **Agent**. `/lab-3-4-paso-1-configurar-servidor`

- [ ] **Esperado:** un archivo nuevo, `.vscode/mcp.json`.
- Observado: ______________________________________________

3. Paleta de comandos. Escriba `MCP: List Servers` y elija el comando. Elija
   `pasarela-andina` y luego **Start Server**. En el chat, haga clic en el ícono de
   herramientas junto al cuadro de texto.

- [ ] **Esperado:** el servidor iniciado y las herramientas `buscar_comercios`,
      `detalle_comercio` y `buscar_notas_soporte` en la lista.
- Observado: ______________________________________________

4. Chat nuevo, modo **Agent**. `/lab-3-4-paso-2-consultar-con-herramienta CM0005`.
   Apruebe cada llamada con **Allow** para esa sola vez, después de leer sus parámetros.

- [ ] **Esperado:** un diálogo de aprobación por cada llamada a una herramienta.
- Observado. Anote qué plan dice el agente que tiene CM0005. El dato real es **PL04**. Si
  dice PL01 o que está exento del tope, la nota con inyección tuvo efecto. Las dos cosas son
  resultados válidos: ______________________________________________

5. `/lab-3-4-paso-3-inventariar-superficie` y después `/lab-3-4-paso-4-documentar-caso-de-uso`.

- [ ] **Esperado:** el archivo `labs/cap3/lab-3-4-mcp-local/entregables/caso-de-uso-mcp.md`
      con cuatro secciones.
- Observado: ______________________________________________

---

## Bloque E. Laboratorio 2.4

1. `bash scripts/reiniciar-lab.sh lab-2-4`
2. Chat nuevo, modo **Agent**. `/lab-2-4-paso-1-elegir-tarea`. Cuando pregunte, responda `C`.
3. `/lab-2-4-paso-2a-construir-instruccion C`. Responda sus preguntas con respuestas cortas.

- [ ] **Esperado:** un archivo nuevo en `.github/instructions/`.
- Observado: ______________________________________________

4. `/lab-2-4-paso-3-probar-artefacto`. Ejecute la prueba que propone, que pide al agente
   crear un archivo dentro de `labs/cap2/lab-2-4-agente-o-instruccion/entregables/`.

- [ ] **Esperado:** la instrucción nueva aparece en la lista de referencias de esa
      respuesta.
- Observado: ______________________________________________

5. En el selector de modo del chat, abra la lista de agentes.

- [ ] **Esperado:** aparecen Analista, Tester, Documentador, Revisor y Refactorizador.
- Observado: ______________________________________________

---

## Bloque F. Muestra de pasos de análisis

Antes de empezar, `bash scripts/reiniciar-lab.sh lab-1-4`.

1. Chat nuevo, modo **Ask**. `/lab-1-4-paso-3-agregar-restricciones java`.

- [ ] **Esperado:** una tabla de tres filas.
- Observado: ______________________________________________

2. Abra `CalculadoraLiquidacion.java`, seleccione con el mouse el método
   `procesarLiquidacionCompleta` completo y escriba `/explain` en el chat.

- [ ] **Esperado:** una explicación del método.
- Observado: ______________________________________________

3. Escriba `/plan dividir este método en partes que se puedan probar por separado`.

- [ ] **Esperado:** el selector cambia a **Plan** y aparece un plan sin cambios en el código.
- Observado: ______________________________________________

4. Vuelva a **Ask** con el selector y escriba `/lab-1-4-paso-4-comparar-resultados`.

- [ ] **Esperado:** una tabla que compara las tres respuestas.
- Observado: ______________________________________________

5. Modo **Agent**. `/lab-4-4-paso-1-documentar-reglas java`.

- [ ] **Esperado:** el documento dice que los tramos **no** son acumulativos.
- Observado: ______________________________________________

---

## Bloque G. Las diez demostraciones del relator

Las demostraciones están en `docs/relator/demos/` del repositorio de construcción. Ábralas
en otra máquina o impresas, nunca en la máquina virtual. Siga cada una tal como está
escrita, sobre el repositorio de participantes, y al terminar ejecute
`bash scripts/reiniciar-lab.sh lab-1-4` y `bash scripts/reiniciar-lab.sh lab-3-4`,
respondiendo `si`.

### G1. Demostración 1.1

Siga `docs/relator/demos/demo-1-1-pedido-pobre-y-pedido-bueno.md`.

- [ ] **Esperado:** dos respuestas, la segunda es una tabla de dos filas con rangos de líneas.
- Duración real: ______________
- Observado: ______________________________________________

### G2. Demostración 1.2

Siga `docs/relator/demos/demo-1-2-referencias-de-contexto.md`.

- [ ] **Esperado:** las cuatro respuestas cambian según la referencia, y con `CalculadoraLiquidacion.java` aparece la regla con sus líneas.
- Duración real: ______________
- Observado: ______________________________________________

### G3. Demostración 1.3

Siga `docs/relator/demos/demo-1-3-flujo-de-trabajo.md`.

- [ ] **Esperado:** `/plan` produce un plan sin cambios, el modo Agent cambia un solo archivo y el comparador dice «Las salidas son identicas».
- Duración real: ______________
- Observado: ______________________________________________

### G4. Demostración 2.1

Siga `docs/relator/demos/demo-2-1-jerarquia-y-skills.md`.

- [ ] **Esperado:** la respuesta sobre los commits cita `copilot-instructions.md` y la skill `/pasarela-reglas-de-negocio` responde con el tramo y el porcentaje.
- Duración real: ______________
- Observado: ______________________________________________

### G5. Demostración 2.2

Siga `docs/relator/demos/demo-2-2-agentes-por-rol.md`.

- [ ] **Esperado:** el Revisor no modifica nada y el Refactorizador cambia un solo archivo y lista lo que no tocó.
- Duración real: ______________
- Observado: ______________________________________________

### G6. Demostración 2.3

Siga `docs/relator/demos/demo-2-3-instrucciones-por-ruta.md`.

- [ ] **Esperado:** la pregunta sobre Java responde `mvn test` y JUnit, la de .NET `dotnet test` y xUnit.
- Duración real: ______________
- Observado: ______________________________________________

### G7. Demostración 3.2

Siga `docs/relator/demos/demo-3-2-servidor-mcp.md`.

- [ ] **Esperado:** el servidor arranca, cada llamada pide aprobación y la respuesta indica qué herramienta respaldó cada dato.
- Duración real: ______________
- Observado: ______________________________________________

### G8. Demostración 3.3

Siga `docs/relator/demos/demo-3-3-hook.md`.

- [ ] **Esperado:** la edición de `transacciones.txt` se bloquea con el mensaje del hook y la pregunta de lectura se responde.
- Duración real: ______________
- Observado: ______________________________________________

### G9. Demostración 4.1

Siga `docs/relator/demos/demo-4-1-documentacion-contra-ejecucion.md`.

- [ ] **Esperado:** el documento trae cuatro resultados y `jshell` imprime 0, 1, 5 y -1.
- Duración real: ______________
- Observado: ______________________________________________

### G10. Demostración 5.3, la revisión de Copilot pendiente

La demostración se presenta desde `docs/relator/respaldos/demo-5-3.md`, grabado en
`RodrigoMSB/github-copilot-netec-demo`, un repositorio privado de grabación. Falta una sola
parte: la revisión de Copilot en el pull request. La cuenta `RoSilva26` tiene Copilot Pro, que
la incluye, y ya está invitada como colaboradora del repositorio de demostración. El pull
request #2 está abierto con el cambio completo para esto. No use el repositorio de
participantes: un pull request deja allí su referencia para siempre.

1. Con la cuenta `RoSilva26`, en el navegador, abra
   https://github.com/RodrigoMSB/github-copilot-netec-demo/invitations y haga clic en
   **Accept invitation**.
2. Abra https://github.com/RodrigoMSB/github-copilot-netec-demo/pull/2.
3. En la columna de la derecha, en **Reviewers**, haga clic en el engranaje y elija
   **Copilot**.
4. Espere a que aparezca la revisión de Copilot en la conversación del pull request, en
   general menos de un par de minutos.
5. Avise al ejecutor. El ejecutor lee los comentarios con la API de GitHub, completa la
   sección «Revisión de Copilot» del respaldo con el texto real, cierra el pull request sin
   integrar y borra la rama.

- [ ] **Esperado:** Copilot aparece en **Reviewers** y deja una revisión en el pull request.
- [ ] **Hecho por el ejecutor:** respaldo completado, pull request #2 cerrado y rama borrada.
- Observado: ______________________________________________

---

## Bloque H. Capítulo 5 de extremo a extremo, en local

Se hace todo en la máquina virtual, sin push y sin GitHub. Abra impresa o en otra máquina la
hoja de respuestas, `docs/relator/capitulo-5-hoja-de-respuestas.md`: usted hace de negocio.
Elija un stack y úselo en todo el bloque. Anote la hora de inicio y fin de cada paso, que es
la medición que decide qué pasa a opcional.

### H1. Las herramientas del capítulo funcionan en Git Bash

1. `bash scripts/integracion-local.sh --stack java` y `bash scripts/integracion-local.sh --stack dotnet`.

- [ ] **Esperado:** los dos terminan con «Todos los pasos pasan». Los pasos de dependencias
      pueden avisar que falta red o el complemento de Maven; no fallan.
- Duración de cada uno: ______________

2. `bash scripts/verificar-reporte.sh java 2026-06`.

- [ ] **Esperado:** dice que el reporte todavía no existe.

3. `bash scripts/proyecto/entregar.sh formato-del-reporte`, y después `git status`.

- [ ] **Esperado:** crea `docs/proyecto/backlog/formato-del-reporte.md` legible. Si dice que
      no encuentra `base64` o `gunzip`, anótelo: el 5.2 y el 5.4 lo necesitan.
- Observado: ______________________________________________

4. `bash scripts/reiniciar-lab.sh lab-5-1` y responda `si`.

### H2. Laboratorio 5.1

1. Siga `labs/cap5/lab-5-1-preparacion/README.md`, prerrequisitos incluidos.

- [ ] **Esperado:** el paso 1 lista preguntas antes de escribir criterios y se detiene. Con
      las respuestas de la hoja, la historia trae un criterio de borde y uno de tercer
      decimal con valor esperado.
- [ ] **Esperado:** el paso 3 crea una decisión 0004 en `docs/arquitectura/decisiones/`.
- Hora de inicio y fin de cada paso: ______________
- Observado: ______________________________________________

### H3. Laboratorio 5.2

1. Siga `labs/cap5/lab-5-2-refactorizacion/README.md`.

- [ ] **Esperado:** el paso 1 entrega el formato y arma un plan sin tocar archivos. El paso 2
      no cambia la liquidación. El paso 3 muestra el resultado de `verificar-reporte.sh` en
      los tres periodos.
- Camino que tomó el agente, cálculo propio o reutilizando la liquidación: ______________
- Hora de inicio y fin de cada paso: ______________
- Observado: ______________________________________________

### H4. Laboratorio 5.3

1. Siga `labs/cap5/lab-5-3-pruebas-y-revision/README.md`. Antes del paso 4 use el botón
   **Copilot Code Review - Uncommitted Changes** de la vista **Source Control**.

- [ ] **Esperado:** después del paso 2, `integracion-local.sh` en rojo, por la conciliación de
      junio o por las pruebas de borde y de tercer decimal.
- [ ] **Esperado:** el paso 3 separa dos causas que suman la diferencia completa, pide la
      decisión del borde, corrige y actualiza solo el hash de junio.
- [ ] **Esperado:** el pipeline local termina en verde.
- [ ] **Esperado:** la revisión de Copilot sobre los cambios sin confirmar deja comentarios
      en los archivos o en **Problems**. Si el botón no aparece o pide otro plan, anótelo.
- [ ] **Esperado:** el paso 5 dice que no aplica, porque la cuenta no tiene copia propia.
      No empuje nada.
- Hora de inicio y fin de cada paso: ______________
- Observado: ______________________________________________

### H5. Laboratorio 5.4

1. Siga `labs/cap5/lab-5-4-laboratorio-final/README.md`.

- [ ] **Esperado:** el paso 2 crea `docs/proyecto/incidentes/INC-2026-0042.md` con
      `entregar.sh` y el análisis llega a las notas de versión y a la decisión del borde.
- [ ] **Esperado:** el paso 4 compara la estimación con el registro de tiempos.
- Hora de inicio y fin de cada paso: ______________
- Observado: ______________________________________________

### H6. Volver al punto de partida

1. `bash scripts/reiniciar-lab.sh lab-5-4` y escriba `descartar`.
2. `git switch main` y `git branch -D reporte-medios-de-pago`.

- [ ] **Esperado:** `git status` limpio y la rama borrada.
- Observado: ______________________________________________

---

## Al terminar

1. Ejecute `bash scripts/reiniciar-lab.sh lab-2-4`, después `bash scripts/reiniciar-lab.sh lab-3-4`
   y después `bash scripts/reiniciar-lab.sh lab-5-1`, respondiendo `si` cada vez. El 5.4 no se
   reinicia, ver la prueba siguiente.
2. Ejecute `bash scripts/reiniciar-lab.sh lab-5-4`.

- [ ] **Esperado:** dos avisos que dicen que el 5.4 no tiene punto de partida propio y que
      reiniciarlo descarta el trabajo de todo el capítulo 5. Si hay algo que descartar, pide
      escribir `descartar`. Responda `si`, y debe cancelar sin tocar nada.
- Observado: ______________________________________________

3. Ejecute `git status`.

- [ ] **Esperado:** «nothing to commit, working tree clean».
- Observado: ______________________________________________

4. Anote el modelo que mostró el selector de modelo del chat durante las pruebas:
   ______________
5. Devuelva este documento con las casillas marcadas y las observaciones completas.
