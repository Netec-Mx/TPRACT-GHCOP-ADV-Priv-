# Protocolo de prueba en la máquina virtual

Documento para el Product Owner. Se sigue en la máquina virtual de prueba de Netec, con la
cuenta de GitHub `RoSilva26`. Corresponde a SPEC-010. Desde SPEC-017 cubre solo lo propio de
la máquina virtual: ambiente, red, cuentas y hook. Los laboratorios se prueban después con
[`guia-prueba-humana.md`](guia-prueba-humana.md).

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

## Cómo se registra

Cada paso tiene una casilla, el resultado esperado y una línea para anotar lo observado. Si
un paso no se puede hacer, anote por qué y siga con el siguiente. Si algo marcado como
bloqueo falla, detenga la prueba y avise.

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

## Bloque A. Copilot, sesión, repositorio, ambiente, red y hook

### A1. Copilot Chat está habilitado

1. Abra Visual Studio Code.
2. Pase el puntero sobre el ícono de Copilot de la barra de estado, abajo a la derecha.
3. Si aparece **Use AI Features**, elíjalo. Después inicie sesión con **Sign in to use
   Copilot**. Si Visual Studio Code pide recargar, acepte con **Reload**.

- [ ] **Esperado:** el menú del ícono de Copilot ya no ofrece **Use AI Features** y el ajuste
      `chat.disableAIFeatures` no está en `true`.
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

### A6. Las herramientas del capítulo 5 funcionan en Git Bash

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

4. `openssl version`.

- [ ] **Esperado:** una versión 3.x. Anótela: ______________

5. `bash scripts/proyecto/ponerse-al-dia.sh lab-5-3 java clave-equivocada`.

- [ ] **Esperado:** «La clave no es correcta. No se modifico nada.»

6. `bash scripts/proyecto/ponerse-al-dia.sh lab-5-3 java <clave de la hoja de respuestas>` y
   escriba `descartar`. Después `bash scripts/verificar-reporte.sh java 2026-06`.

- [ ] **Esperado:** «Listo para empezar el lab-5-3 con java» y el reporte coincide.

7. `bash scripts/reiniciar-lab.sh lab-5-1` y responda `si`.

- Observado: ______________________________________________

---

## Al terminar

1. Ejecute `git status`.

- [ ] **Esperado:** «nothing to commit, working tree clean».
- Observado: ______________________________________________

2. Anote el modelo que muestra el selector de modelo del chat: ______________
3. Siga con [`guia-prueba-humana.md`](guia-prueba-humana.md) para los laboratorios.
