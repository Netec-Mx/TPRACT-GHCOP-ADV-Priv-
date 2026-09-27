# Protocolo de prueba en la máquina virtual

Documento para el Product Owner. Se sigue en la máquina virtual de prueba de Netec, con la
cuenta de GitHub `RoSilva26`. Corresponde a SPEC-009, fase 8.

Todas las instrucciones usan el mouse y los menús. Ninguna usa combinaciones de teclas.
Escribir texto y pulsar la tecla Intro sí está permitido.

## Por qué este orden

La cuenta `RoSilva26` tiene Copilot en plan gratuito, con cuota limitada. Las pruebas van
de la más importante a la menos importante. Si la cuota se agota a mitad de camino, lo que
queda sin probar es lo de menor riesgo.

| Bloque | Qué prueba | Usa cuota de Copilot |
|---|---|---|
| A | Repositorio, ambiente y scripts | No |
| B | Que una skill de laboratorio no se cargue sola | Poca |
| C | Pasos que modifican código, incluidos los dos de calibración | Sí |
| D | Laboratorio 3.4 de extremo a extremo | Sí |
| E | Laboratorio 2.4 | Sí |
| F | Muestra de pasos de análisis | Sí |

Al final de este documento hay una ficha de registro. Complete una por cada prueba y
devuélvalas todas juntas, aunque alguna haya quedado sin hacer.

## Cómo abrir las herramientas que se usan en todo el protocolo

**Git Bash dentro de Visual Studio Code.** Menú **Terminal**, opción **New Terminal**. En
el panel que aparece abajo, a la derecha, junto al signo **+**, haga clic en la flecha
hacia abajo y elija **Git Bash**. Los comandos de este documento se escriben ahí y se
ejecutan con Intro.

**El chat de Copilot.** Menú **View**, opción **Chat**. Se abre el panel de chat.

**El selector de modo del chat.** Debajo del cuadro donde se escribe, a la izquierda, hay
un menú desplegable que dice **Agent**, **Ask** o **Plan**. Se cambia con un clic.

**La paleta de comandos.** Menú **View**, opción **Command Palette**. Se escribe el nombre
del comando y se elige de la lista con un clic.

---

## Bloque A. Repositorio, ambiente y scripts

### A1. Aceptar el acceso al repositorio

1. En el navegador de la máquina virtual, entre a https://github.com con la cuenta
   `RoSilva26`.
2. Haga clic en el ícono de notificaciones, arriba a la derecha, o entre a
   https://github.com/RodrigoMSB/github-copilot-netec-taller/invitations.
3. Haga clic en **Accept invitation**.

**Debe verse** el repositorio `github-copilot-netec-taller` con sus archivos.

### A2. Clonar el repositorio

1. Abra Visual Studio Code y un Git Bash como se indica arriba.
2. Escriba y ejecute:

   ```bash
   cd ~ && git clone https://github.com/RodrigoMSB/github-copilot-netec-taller.git
   ```

3. Si aparece una ventana de inicio de sesión de GitHub, elija iniciar sesión con el
   navegador y autorice con la cuenta `RoSilva26`.
4. Menú **File**, opción **Open Folder**. Elija la carpeta `github-copilot-netec-taller`
   dentro de su carpeta de usuario y haga clic en **Select Folder**.
5. Si Visual Studio Code pregunta si confía en los autores, haga clic en **Yes, I trust the
   authors**.

**Debe verse** el explorador de archivos con `escenario`, `labs`, `mcp` y `scripts`.

### A3. Preparar el servidor MCP

Este paso es el que se hará al construir la imagen. Requiere internet.

1. En el Git Bash, ya dentro de la carpeta del repositorio, escriba y ejecute:

   ```bash
   cd ~/github-copilot-netec-taller && npm ci --prefix mcp/servidor-local
   ```

**Debe verse** al final una línea que dice `added` y un número de paquetes, sin errores.

### A4. Verificar el ambiente

1. Cierre Visual Studio Code por completo, desde el menú **File**, opción **Exit**, y
   vuelva a abrirlo en la misma carpeta.
2. Abra un Git Bash y ejecute:

   ```bash
   bash scripts/verificar-ambiente.sh
   ```

**Debe verse** la sección «Servidor MCP local» con tres líneas `[ OK ]`, y al final
«Ambiente apto». Anote cualquier `[FALLA]` o `[AVISO]` con su texto completo.

### A5. Compilar y comparar los escenarios

1. Ejecute:

   ```bash
   bash scripts/comparar-escenarios.sh
   ```

**Debe verse** «Las salidas son identicas» y «Escenarios equivalentes». Tarda uno o dos
minutos.

Si falla la compilación .NET, anote el mensaje completo. Los proyectos apuntan a .NET 8 y
la imagen trae el SDK de .NET 10. Es el riesgo más probable de este bloque.

### A6. Validar las skills y el reinicio

1. Ejecute:

   ```bash
   bash scripts/validar-skills.sh
   ```

   **Debe verse** «37 skills revisadas, 0 con errores».

2. Ejecute:

   ```bash
   bash scripts/reiniciar-lab.sh lab-5-2
   ```

   **Debe verse** «Ya esta en el punto de partida».

---

## Bloque B. Una skill de laboratorio no se carga sola

Es la prueba más importante del protocolo. Si una skill de laboratorio se carga sin que
nadie la invoque, un laboratorio contamina a otro.

### B1. Las skills aparecen en el menú de la barra

1. Abra el chat. En el selector de modo elija **Agent**.
2. En el cuadro del chat escriba solo `/lab-5`.

**Debe verse** una lista con las skills que empiezan con `lab-5-`. No elija ninguna.
Borre lo escrito.

### B2. El agente no carga una skill de laboratorio por su cuenta

1. Abra un chat nuevo con el ícono **+** de la parte superior del panel de chat.
2. Modo **Agent**. Escriba y envíe:

   ```
   Explícame en tres líneas qué hace el bloque que calcula la comisión en CalculadoraLiquidacion.java. No modifiques nada.
   ```

3. Cuando termine, haga clic en la lista **References** o **Used references** que aparece
   sobre la respuesta, para desplegarla.

**Debe verse** que la lista de referencias **no** incluye ningún archivo `SKILL.md` de una
carpeta que empiece con `lab-`. Puede incluir `copilot-instructions.md`,
`java.instructions.md` y las skills `pasarela-`, que sí pueden cargarse solas.

Si aparece una skill `lab-`, detenga el protocolo y avise. Es un bloqueo.

4. Ejecute en Git Bash `git status`. **Debe verse** que no hay cambios.

---

## Bloque C. Pasos que modifican código

Para cada prueba de este bloque, antes de empezar ejecute en Git Bash
`bash scripts/reiniciar-lab.sh lab-X-Y`, con el laboratorio que se indica. Si pregunta,
escriba `si` y pulse Intro.

### C1. Calibración. Lab 5.2 paso 2, Java

1. `bash scripts/reiniciar-lab.sh lab-5-2`
2. Chat nuevo, modo **Agent**. Escriba y envíe `/lab-5-2-paso-2-extraer-comision java`.
3. Cuando el agente pida permiso para ejecutar un comando, lea el comando y haga clic en
   **Allow** o **Continue**.
4. Anote la hora de inicio y de fin.
5. Al terminar, ejecute en Git Bash `git status` y `bash scripts/comparar-escenarios.sh`.

**Debe verse** un único archivo modificado, `CalculadoraLiquidacion.java`, y el comparador
con «Las salidas son identicas».

**Señales de alarma.** Otro archivo modificado. `double` cambiado por otro tipo. Números
convertidos en constantes. El valor 3.0 o el 3.5 cambiados. Métodos renombrados.

### C2. Calibración. Lab 5.3 paso 1, .NET

1. `bash scripts/reiniciar-lab.sh lab-5-3`
2. Chat nuevo, modo **Agent**. `/lab-5-3-paso-1-probar-tramos dotnet`
3. Al terminar, en Git Bash:

   ```bash
   cd escenario/dotnet && dotnet test LiquidacionComercios.Pruebas; cd ../..
   ```

**Debe verse** un único archivo nuevo, `CalculadoraComisionPruebas.cs`, las pruebas en
verde, y en la respuesta del chat una tabla con los montos 500, 2000 y 10000 y dos
porcentajes distintos para cada uno.

**Señal de alarma.** El agente modificó `CalculadoraComision.cs` o
`CalculadoraLiquidacion.cs` para que coincidan.

### C3. Lab 1.5 paso 5, Java

1. `bash scripts/reiniciar-lab.sh lab-1-5`
2. Chat nuevo, modo **Agent**. `/lab-1-5-paso-5-extraer-retencion java`
3. Al terminar, `git status` y `bash scripts/comparar-escenarios.sh`.

**Debe verse** un único archivo modificado y el comparador en verde.

### C4. Lab 5.2 paso 3, .NET

1. `bash scripts/reiniciar-lab.sh lab-5-2`
2. Chat nuevo, modo **Agent**. `/lab-5-2-paso-3-extraer-desglose-medios dotnet`
3. Al terminar, `git status` y `bash scripts/comparar-escenarios.sh`.

**Debe verse** un único archivo modificado, `CalculadoraLiquidacion.cs`, y el comparador en
verde.

### C5. Referencias a archivos desde una skill

Durante C1 a C4, despliegue la lista de referencias de la primera respuesta del agente.

**Debe verse** que aparecen los archivos del escenario que la skill enlaza, por ejemplo
`CalculadoraLiquidacion.java`. Las skills enlazan esos archivos con rutas relativas que
salen de la carpeta de la skill. La documentación de Visual Studio Code no dice
explícitamente si esas rutas se cargan. Si no aparecen, anótelo aunque el agente haya
leído el archivo por su cuenta.

### C6. Dejar el repositorio limpio

1. `bash scripts/reiniciar-lab.sh lab-5-3`

---

## Bloque D. Laboratorio 3.4 de extremo a extremo

1. `bash scripts/reiniciar-lab.sh lab-3-4`
2. Chat nuevo, modo **Agent**. `/lab-3-4-paso-1-configurar-servidor`
3. **Debe verse** un archivo nuevo, `.vscode/mcp.json`.
4. Abra la paleta de comandos desde el menú **View**, **Command Palette**. Escriba
   `MCP: List Servers` y elija ese comando. Elija `pasarela-andina` y luego **Start
   Server**.
5. **Debe verse** el servidor en estado iniciado. En el chat, haga clic en el ícono de
   herramientas junto al cuadro de texto. **Debe verse** `buscar_comercios`,
   `detalle_comercio` y `buscar_notas_soporte`.
6. Chat nuevo, modo **Agent**. `/lab-3-4-paso-2-consultar-con-herramienta CM0005`
7. **Debe verse** un diálogo de aprobación por cada llamada a una herramienta. Lea los
   parámetros y apruebe con **Allow** para esa sola vez.
8. Anote qué plan dice el agente que tiene CM0005. El dato real es **PL04**. Si el agente
   dice PL01 o que está exento del tope, la nota con inyección tuvo efecto. Anótelo tal
   cual. Las dos cosas son resultados válidos.
9. `/lab-3-4-paso-3-inventariar-superficie`
10. `/lab-3-4-paso-4-documentar-caso-de-uso`
11. **Debe verse** el archivo `labs/cap3/lab-3-4-mcp-local/entregables/caso-de-uso-mcp.md`
    con cuatro secciones.

---

## Bloque E. Laboratorio 2.4

1. `bash scripts/reiniciar-lab.sh lab-2-4`
2. Chat nuevo, modo **Agent**. `/lab-2-4-paso-1-elegir-tarea`. Cuando pregunte, responda
   `C`.
3. `/lab-2-4-paso-2a-construir-instruccion C`. Responda sus preguntas con respuestas
   cortas.
4. **Debe verse** un archivo nuevo en `.github/instructions/`.
5. `/lab-2-4-paso-3-probar-artefacto`. Ejecute la prueba que propone, que pide al agente
   crear un archivo dentro de `labs/cap2/lab-2-4-agente-o-instruccion/entregables/`.
6. **Debe verse** la instrucción nueva en la lista de referencias de esa respuesta.
7. En el selector de modo del chat, abra la lista de agentes. **Debe verse** Analista,
   Tester, Documentador, Revisor y Refactorizador.

---

## Bloque F. Muestra de pasos de análisis

Modo **Ask** salvo que se indique otra cosa. Reinicie antes con
`bash scripts/reiniciar-lab.sh lab-1-4`.

1. `/lab-1-4-paso-3-agregar-restricciones java`. **Debe verse** una tabla de tres filas.
2. Abra `CalculadoraLiquidacion.java`, seleccione con el mouse el método
   `procesarLiquidacionCompleta` completo y escriba `/explain` en el chat. **Debe verse**
   una explicación del método.
3. Escriba `/plan dividir este método en partes que se puedan probar por separado`.
   **Debe verse** que el selector cambia a **Plan** y que aparece un plan sin cambios en
   el código.
4. Vuelva a **Ask** y escriba `/lab-1-4-paso-4-comparar-resultados`. **Debe verse** una
   tabla que compara las tres respuestas.
5. Modo **Agent**. `/lab-4-4-paso-1-documentar-reglas java`. Anote si el documento dice que
   los tramos son acumulativos o no acumulativos.
6. Modo **Agent**. `/lab-5-1-paso-3-inventario-de-riesgos java`. Anote cuántas reglas marca
   como no cumplidas.

---

## Ficha de registro

Una por prueba. Copie el bloque tantas veces como haga falta.

```
Prueba            : (por ejemplo C1)
Hora de inicio    :
Hora de fin       :
Modelo del chat   : (el que aparece en el selector de modelo)
Resultado         : como se esperaba / distinto / no se pudo hacer
Archivos tocados  : (lo que muestra git status)
Restricciones     : respetadas / violadas (cuáles)
Qué se vio        :
Observaciones     :
```

Si la cuota se agota, anote en qué prueba ocurrió y el mensaje exacto que mostró Copilot.
