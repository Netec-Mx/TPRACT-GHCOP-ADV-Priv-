# Prueba final en Windows con GitHub Copilot

Registro de SPEC-027. 5 de octubre de 2026. Es la prueba de SPEC-023 repetida en una máquina
virtual con Windows, con el material cerrado en SPEC-026. No se cambió material. Lo que sigue
son hallazgos con evidencia y una propuesta, para que el Product Owner decida.

## Resultado

Los nueve laboratorios no se completaron. Se terminaron con Copilot el 1.4, el 1.5, el 2.4, el
3.4, el 4.4, el capítulo 5 completo por el camino A (5.1 a 5.4) y el 5.2 por el camino B. El
5.3 del camino B quedó a mitad del paso 3: el presupuesto adicional de la cuenta se agotó con
el mensaje «You've reached your additional usage limit for your plan» (Request ID
`42E0:10E9FB:29A37F:2F5870:6AC461B2`). Hasta ahí Copilot ya había encontrado las dos causas y
corregido el borde. El capítulo 5 en .NET no se corrió por consumo.

## La máquina virtual

- Windows 11 Enterprise de evaluación 25H2, compilación 26200, 64 bits. Interfaz en español
  de España; página de códigos OEM 437 y ANSI 1252.
- Acceso por SSH con llave, usuario `taller`, administrador. La shell por omisión de OpenSSH
  se cambió de `cmd.exe` a Git Bash
  (`HKLM\SOFTWARE\OpenSSH\DefaultShell = C:\Program Files\Git\bin\bash.exe`) para trabajar
  como un participante.
- Salida a internet sin filtro.

## Instalación siguiendo `00-setup-ambiente.md`

| Herramienta | Cómo | Versión | Segundos |
|---|---|---|---|
| Git para Windows | `winget install Git.Git` | 2.55.0.windows.5 | 77 |
| JDK | `winget install Microsoft.OpenJDK.25` | 25.0.4.1, con `JAVA_HOME` y `PATH` | 100 |
| SDK de .NET | `winget install Microsoft.DotNet.SDK.10` | 10.0.401 | 132 |
| Node.js | `winget install OpenJS.NodeJS.LTS --version 24.19.0` | 24.19.0, npm 11.17.0 | 24 |
| Visual Studio Code | `winget install Microsoft.VisualStudioCode` | 1.140.0 | 140 |
| Apache Maven | Zip oficial de `dlcdn.apache.org`, SHA-512 verificado | 3.9.16 | — |
| Extensiones | `code --install-extension` | Java Pack 0.31.1, C# Dev Kit 3.40.210 | 39 y 70 |

La fuente `msstore` siguió quitada. No se instaló `GitHub.copilot`.

Preparación de la sección 2.3, desde la raíz del clon, todo sin errores: `mvn clean package`
55 s, `mvn dependency:tree` 34 s, `dotnet test` 84 s con 20 pruebas, `dotnet build -c Release`
7 s y `npm ci --prefix mcp/servidor-local` 37 s.

### Lo que no funcionó tal como está escrito

1. **Maven no existe en winget.** La búsqueda no lo encuentra. Se instaló desde el zip oficial,
   con la verificación de su SHA-512, y se agregaron a mano `MAVEN_HOME` y la carpeta `bin` al
   `PATH` de la máquina. La guía pide la versión, pero no dice cómo instalarlo en Windows.
2. **Node 24 depende de la fecha.** `OpenJS.NodeJS.LTS` instala hoy la 24.19.0, pero pasará a
   la 26 cuando esa versión entre en soporte extendido, a fines de octubre de 2026. No existe
   un paquete `OpenJS.NodeJS.24`. Se fijó con `--version 24.19.0`.
3. **Habilitar Copilot en Visual Studio Code exige el escritorio.** Los pasos de la guía son
   clics en el editor. Por SSH no se pudo abrir Visual Studio Code en la sesión de escritorio,
   y por eso el script de verificación reprueba ese punto. Es lo que la guía anticipa, no un
   error, pero alguien tiene que hacerlo en cada perfil.
4. **Solo por trabajar por SSH, no en clase:** el repositorio de participantes es privado y
   `git clone` no pudo guardar la credencial porque el administrador de credenciales de
   Windows no está disponible en una sesión SSH. Se clonó desde un paquete de git del mismo
   commit, `a6c3261` con la etiqueta `punto-de-partida`.

### Salida de `verificar-ambiente.sh`

En Git Bash, en la VM, con el clon recién preparado. Terminó con código 1 en 56 segundos.

```
Verificacion de ambiente, taller de GitHub Copilot
Script version 2.3.0
Entorno: Git Bash sobre Windows
Sistema: MINGW64_NT-10.0-26200 3.6.10-710e5275.x86_64
Shell: 5.3.15(2)-release
Fecha: 2026-10-05 16:05:14

== Herramientas obligatorias ==
  [ OK ] Git 2.55.0 (minimo 2.40)
  [ OK ] JDK 25.0.4 (minimo 21)
  [ OK ] SDK de .NET 10.0.401 (minimo 10.0)
  [ OK ] Node.js 24.19.0 (minimo 22)
  [ OK ] Visual Studio Code 1.140.0 (minimo 1.116)

== GitHub Copilot en Visual Studio Code ==
  [FALLA] Funciones de IA de Visual Studio Code deshabilitadas, Copilot no va a sugerir ni responder: el perfil todavia no registra el estado de las extensiones, Visual Studio Code nunca se cerro con este perfil

== Compilacion sin red ==
  [ OK ] El escenario Java compila y prueba sin red
  [ OK ] El escenario .NET restaura y compila sin red

== Hook de proteccion de datos ==
  [ OK ] El hook de proteccion de datos bloquea una edicion de prueba y deja pasar otra
  [ OK ] Hooks habilitados en Visual Studio Code (chat.useHooks no esta deshabilitado)

== Servidor MCP local ==
  [ OK ] Dependencia del servidor MCP @modelcontextprotocol/server 2.1.0
  [ OK ] Dependencia del servidor MCP zod 4.6.5
  [ OK ] El servidor MCP arranca y lista sus tres herramientas

== Herramientas recomendadas ==
  [ OK ] Apache Maven 3.9.16 (minimo 3.9)

== Conectividad obligatoria de GitHub Copilot ==
  [ OK ] github.com alcanzable
  [ OK ] api.github.com alcanzable
  [ OK ] api.githubcopilot.com alcanzable
  [ OK ] proxy.individual.githubcopilot.com alcanzable
  [ OK ] copilot-proxy.githubusercontent.com alcanzable
  [ OK ] default.exp-tas.com alcanzable

== Conectividad recomendada ==
  [ OK ] copilot-telemetry.githubusercontent.com alcanzable
  [ OK ] marketplace.visualstudio.com alcanzable

== Resumen ==
  Ambiente NO apto. Faltan 1 requisito(s) obligatorio(s).

  Requisitos faltantes:
    - Funciones de IA de Visual Studio Code deshabilitadas, Copilot no va a sugerir ni responder: el perfil todavia no registra el estado de las extensiones, Visual Studio Code nunca se cerro con este perfil

  Como habilitar las funciones de IA en Visual Studio Code:
    1. Abrir la vista de Extensiones (Ctrl+Shift+X).
    2. Escribir @builtin copilot en el buscador.
    3. Seleccionar GitHub Copilot Chat.
    4. Pulsar "Enable AI Features" ("Habilitar características de IA" con la interfaz
       en espanol). Si el boton que aparece es "Enable" ("Habilitar"), pulsar ese.
    5. Iniciar sesion en GitHub desde el icono de Copilot de la barra de estado.
    6. Cerrar Visual Studio Code por completo y volver a ejecutar este script. El editor
       no guarda este estado en disco en el momento, pero si al cerrarse.
  Alternativa para el paso 4: Configuracion (Ctrl+,), buscar chat.disableAIFeatures y
  dejar la casilla desmarcada.

  Revisa docs/00-setup-ambiente.md para los pasos de instalacion.
```

La única falla es el punto 3 de la lista anterior.

## Copilot CLI en la VM

- `npm install -g @github/copilot`: versión 1.0.92, la última estable, en 22 segundos.
- **Inicio de sesión.** Con `copilot login --device-code` el Product Owner autorizó la cuenta
  desde su Mac, pero la CLI respondió «Login succeeded, but the token was not saved»: el
  almacén de credenciales de Windows no está disponible por SSH. Con una terminal interactiva,
  el mismo comando no inicia sesión: abre la sesión interactiva y pide confiar en la carpeta.
  El ingreso funcionó con `/login`, eligiendo guardar el token en texto plano en
  `C:\Users\taller\.copilot\config.json`, con la aprobación del Product Owner. El token sigue
  ahí.
- **Cuota.** `/usage` mostró el plan al 100 %, 1.500 de 1.500 créditos. Con el presupuesto
  adicional habilitado, un pedido de prueba respondió y costó 8 créditos.
- **Modelo.** `claude-sonnet-5` en todas las sesiones de la prueba.

## Cómo se hizo

Mismo método que SPEC-023. El conductor ACP corrió en el Mac y lanzó
`copilot --acp --no-auto-update` dentro de la VM por SSH, en el clon de participantes. Los
scripts del taller y los commits del participante se ejecutaron en Git Bash de la VM. Las
preguntas al negocio se respondieron con la hoja de respuestas y la guía de prueba humana.

Las reglas del conductor quedaron como al final de SPEC-023, con dos agregados:

- Los equivalentes de PowerShell de esas reglas: `Remove-Item`, `Move-Item`, `Copy-Item`,
  `Set-Content` y similares sobre `escenario/datos/`, e `Invoke-WebRequest`. En Windows, la
  herramienta de terminal de Copilot es PowerShell.
- **Un rechazo falso, corregido:** en el 4.4.4 rechazó
  `Remove-Item "$env:TEMP\salida-2026-06.txt" -ErrorAction SilentlyContinue`, porque tomaba
  `-ErrorAction` como un archivo a borrar.

Queda un hueco del conductor. Un `rm` dentro de `bash.exe -c "..."` no se detecta, y así se
aprobaron dos borrados en el 5.3.3 del camino A que la regla de la guía rechaza. Está en el
hallazgo M4.

## Por laboratorio

«Agente» son los segundos de trabajo de Copilot, sumados por turno a partir de los eventos de
la sesión. «Reloj» incluye además lo que tarda el participante, es decir, el conductor, en
revisar y responder. Los segundos de SPEC-023 son de reloj de los pedidos.

| Lab | Agenda (min) | Agente (s) | Reloj (s) | SPEC-023 (s) | Solicitudes | Créditos | Créditos SPEC-023 |
|---|---|---|---|---|---|---|---|
| 1.4 | 30 | 243 | 332 | 167 | 6 | 67,5 | 48,2 |
| 1.5 | 60 | 250 | 456 | 258 | 5 | 47,8 | 64,4 |
| 2.4 | 45 | 168 | 322 | 135 | 9 | 37,7 | 34,2 |
| 3.4 | 45 | 166 | 253 | 242 | 4 | 40,6 | 60,1 |
| 4.4 | 30 | 760 | 864 | 601 | 5 | 138,7 | 199,1 |
| 5.1 A | 45 | 847 | 1004 | 470 | 7 | 186,3 | 168,5 |
| 5.2 A | 45 | 841 | 982 | 507 | 4 | 146,0 | 166,7 |
| 5.3 A | 45 | 4377 | 4635 | 1809 | 10 | 931,3 | 639,7 |
| 5.4 A | 45 | 1068 | 1215 | 568 | 7 | 225,2 | 224,8 |
| 5.2 B | 45 | 848 | 987 | 728 | 5 | 159,5 | 209,9 |
| 5.3 B, interrumpido | 45 | 1715 | — | 154 | 8 | 360,3 | 47,7 |
| Pedido de prueba | — | — | — | — | 1 | 8,0 | — |
| **Total** | | | | | **71** | **2348,9** | **1899,2** |

El 5.3 de SPEC-023 incluía `/review`; esta vez no se usó, para ahorrar presupuesto.

| Lab | Skill | Mostró | Coincide con la guía | Permisos | Preguntas y hoja |
|---|---|---|---|---|---|
| 1.4 | Sí | No aplica | Sí, salvo dos detalles. El paso 1 respondió explicando por qué el pedido es vago, en vez de una respuesta larga. El paso 3 trae una línea antes de la tabla. Sin `/explain`. `/plan` hizo cuatro preguntas | Ninguno | Las de `/plan`, con la misma respuesta de SPEC-023 |
| 1.5 | Sí | Paso 5: diff con `git diff` y «mostrado arriba» | Sí. 25 responsabilidades, 9 niveles, CM0031. Un solo archivo cambiado y el comparador en 0 dentro de PowerShell | `mvn`, `comparar-escenarios.sh` y `git diff`, en PowerShell. Sin `git stash` | No preguntó por el comercio suspendido |
| 2.4 | Sí | El archivo de la instrucción y el diff del paso 4, sí. La prueba 2, no | Sí. `applyTo` `labs/cap2/**/entregables/**/*.md` y una cita real | `New-Item` para la carpeta de entregables; `git ls-files`, `git diff --no-index` | Tres decisiones en una pregunta |
| 3.4 | Sí | Paso 4: «Contenido completo:» y nada | Sí. PL04, inyección señalada. El hook ya no bloquea documentos que citan la ruta | MCP una vez por llamada | No preguntó por el paso 2, que estaba en la misma conversación |
| 4.4 | Sí | Pasos 1 a 4: «mostrado arriba»; no está en el texto | Sí. Nombre de archivo correcto, tramos no acumulativos, 8 verificadas y 3 no en el runbook | 15 comandos en el paso 4 | Ninguna |
| 5.1 A | Sí | Pasos 1 y 2, no; paso 3, sí | Sí. Tres alternativas, con la del camino A. Borde 17,80 y CM0011 137,825 | `date`, lecturas, `node` para calcular | 12 preguntas: 9 con la hoja, 3 con «lo fija la especificación del 5.2» |
| 5.2 A | Sí | Sí | No. `verificar-reporte.sh` no coincide en los tres periodos: hallazgo W1 | `entregar.sh`, `mvn`, scripts | Pidió aprobar `BigDecimal`; «apruebo» se leyó como un no. Hallazgo M3 |
| 5.3 A | Sí | Pasos 1 y 2, no; pasos 3 y 4, sí | En parte. Ver abajo | Diagnóstico, compilación, scripts. Tres `Remove-Item` rechazados | Pidió aprobación del redondeo dos veces, y una tercera por una prueba mal calculada |
| 5.4 A | Sí | Pasos 1, 3 y 4, sí; paso 2, no | Sí, con un error en las notas: hallazgo M6. Esperó la confirmación del número | Liquidación, `entregar.sh`, `git log` | Ninguna |
| 5.2 B | Sí | Sí | Actualizó la 0004. `verificar-reporte.sh` falla en los tres periodos por W1 | Igual que en A | Ninguna |
| 5.3 B | Sí | — | Hasta donde llegó, sí: conciliación en cero, las dos causas con sus montos, aprobación antes de cambiar el tipo | Tres `Remove-Item` rechazados | — |

### El 5.3 del camino A

- **Paso 1 (852 s).** Una prueba por criterio. Fallan la conciliación de junio por 22,00, como
  espera la guía, y las de medio centavo, porque el reporte se hizo con `double` (M3).
- **Paso 2 (580 s).** Conciliación en rojo solo en junio, con 22,00; la guía dice 22,03. Con
  `double`, el reporte comparte el error de punto flotante de la liquidación y solo queda el
  borde. A la pregunta de la guía, Copilot atribuyó los 22,00 a la acumulación de medios
  centavos, lo que es falso.
- **Paso 3 (2705 s).** Llegó solo a las dos causas, 22,00 y 0,03, y corrigió el borde en la
  liquidación. Pidió aprobación del redondeo y después una aprobación ampliada, hasta calcular
  cada comisión exacta. Hash de junio `cd1466305e63…`, 31 pruebas y pipeline en verde.
- **Paso 4 (235 s).** Decisión 0005, `pull-request.md` con «Alcance por stack» y la casilla de
  `.github/` sin marcar. Marcó por su cuenta «una persona revisó cada línea».

## Tiempo del 5.3

Agente, sin reintentos causados por el conductor: **4377 s, 73 minutos**, contra los 45 de la
agenda. No hubo reintentos del conductor en este laboratorio. Los turnos «Sigue sin ese
comando» los pide la guía y están incluidos.

| Paso | Agente (s) | Qué consumió el tiempo |
|---|---|---|
| 1 | 852 | Exploración de datos con `Get-Content` y `Select-String`, una prueba mal calculada a mano y su depuración |
| 2 | 580 | Incluye una subtarea de búsqueda en .NET de 427 s |
| 3 | 2705 | Diagnóstico con scripts temporales, tres rondas de aprobación y tres actualizaciones del hash |
| 4 | 235 | |

En el camino B, los pasos 1 a 3 llevaban 1715 s cuando se agotó el presupuesto. Ni con la
mitad del tiempo del paso 3 cabe en 45 minutos. El tiempo humano de leer y aprobar va aparte.

## Hallazgos propios de Windows

### W1. El reporte sale con CRLF y `verificar-reporte.sh` no coincide en ningún periodo

Grave: en los dos caminos, el 5.2 deja tres hallazgos abiertos que no son reales, y llegan
hasta el 5.4.

- **Evidencia:**
  - En los dos caminos, el formateador que escribió Copilot usa `%n` en `String.format`
    para la tabla y el pie. En Windows `%n` es `\r\n`.
  - Las 8 líneas de tabla y pie terminan en `\r\n`.
  - Sin los `\r`, el reporte de abril de los dos caminos tiene el hash del oráculo,
    `27534969…`.
  - La especificación del reporte pide fin de línea `\n`.
  - `verificar-reporte.sh` calcula el hash sin quitar `\r`; `integracion-local.sh:67` sí
    los quita.
  - Copilot no encontró esta causa en el 5.2, en el 5.3 ni en el 5.4. En el 5.3.3 la dejó
    como «hallazgo preexistente».
  - En el camino B la atribuyó al borde, y en el 5.4.1 afirmó que ya estaba corregida.
- **Propuesta:** que `verificar-reporte.sh` quite `\r` antes del hash, como
  `integracion-local.sh`. Además, que la especificación o la skill del 5.2.2 diga «usa `\n`,
  no `%n` ni `println`». Pasa igual en Visual Studio Code, porque es el código Java el que
  escribe el CRLF.

### W2. `comparar-escenarios.sh` falla en Git Bash por la codificación de la consola

- **Evidencia:**
  - Ejecutado en Git Bash, por SSH, con la página de códigos 437, termina en 1 con el
    código del escenario sin tocar.
  - La única diferencia es «Breña» en CM0013 y CM0037: Java escribe la `ñ` en UTF-8
    (`AplicacionLiquidacion.java:41-42` fuerza UTF-8) y .NET en la página de códigos de la
    consola (byte `0xA4`).
  - Con `chcp.com 65001` antes, termina en 0.
  - Dentro de la terminal PowerShell de Copilot terminó en 0 las dos veces.
  - No es un defecto plantado.
  - Un participante en la terminal Git Bash de Visual Studio Code sobre Windows en español
    tendría la página 850. No se pudo comprobar en el editor.
  - El paso de equivalencia de `integracion-local.sh` para .NET puede tener el mismo
    problema; no se probó.
- **Propuesta:** que `comparar-escenarios.sh` y `integracion-local.sh` ejecuten
  `chcp.com 65001 > /dev/null` cuando corren en Git Bash. Antes de clase, comprobar el
  comparador desde la terminal de Visual Studio Code en la VM real.

### W3. La terminal de Copilot CLI en Windows es PowerShell

- **Evidencia:**
  - **Comandos que no funcionan como en Git Bash:**
    - `date +%H:%M` falla, porque `date` es `Get-Date`.
    - Los heredoc no existen, y un `%` se interpretó mal.
    - `python` es el atajo de la Tienda: no hay Python en la imagen.
  - **Cómo se adapta Copilot:** reemplaza `grep` y `cat` por `Select-String` y
    `Get-Content`, y desde el 5.3 empezó a llamar a
    `& "C:\Program Files\Git\bin\bash.exe" -c "..."` por su cuenta.
  - **Efecto en la guía:** los comandos que la guía dice aprobar no son los que el
    participante ve.
  - **En Visual Studio Code:** el modo agente usa el perfil de terminal elegido, Git Bash
    según la guía. No se pudo comprobar.
- **Propuesta:** comprobar en Visual Studio Code qué terminal usa el agente. Si fuera
  PowerShell, agregar a la guía que Copilot puede mostrar el equivalente en PowerShell.

### W4. Copilot crea los archivos con CRLF

- **Evidencia:**
  - La instrucción del 2.4, los documentos del capítulo 5 y la línea `java` de `stack.txt`
    quedaron con CRLF.
  - Git los normaliza al confirmar, con un aviso por archivo («CRLF will be replaced by
    LF»).
  - Los scripts toleran el `\r` en `stack.txt`.
- **Propuesta:** ninguna en el material. Mencionarlo en las notas del relator, porque los
  avisos aparecen en cada commit del capítulo 5.

### W5. La herramienta de crear archivos no crea la carpeta

- **Evidencia:** en el 2.4 y el 3.4, `create` falló cuando no existía `entregables/` o
  `.vscode/`. Copilot creó la carpeta con `New-Item` y pidió un permiso más.
- **Propuesta:** ninguna.

## Hallazgos del material

### M1. «Mostrar lo producido» sigue sin quedar en el texto en muchos pasos

- **Evidencia:**
  - Pese a la regla de SPEC-024, Copilot escribe «Contenido completo:» o «mostrado
    arriba» y no pone el contenido en:
    - el 3.4.4;
    - el 4.4, pasos 1 a 4;
    - el 5.1, pasos 1 y 2;
    - el 5.3.1;
    - el 5.4.2;
    - la prueba 2 del 2.4.3.
  - En otros pasos sí lo hizo: 2.4.2, 5.1.3, 5.2.2, 5.3.3, 5.3.4, 5.4.1, 5.4.3 y 5.4.4.
  - La falla coincide con los pasos que crean archivos con la herramienta `create`, cuya
    vista Copilot da por mostrada.
- **Propuesta:** probarlo en Visual Studio Code antes de volver a cambiar las skills. Si
  falla igual, que la regla diga «aunque la herramienta ya lo haya mostrado, cópialo en tu
  respuesta».

### M2. `stack.txt` con dos líneas rompe el pipeline

- **Evidencia:**
  - En el 5.1.1, Copilot agregó `java` al final en vez de cambiar la última línea; el
    archivo quedó con `ambos` y `java`.
  - `integracion-local.sh:57` y el workflow, línea 46, leen el stack con
    `tr -d '\r[:space:]'`, que borra también los saltos de línea y junta las dos líneas en
    `ambosjava`.
  - Sin `--stack`, el pipeline falla en el 5.2.3 y en el 5.3.2. Copilot lo detectó, forzó
    `--stack java` y lo dejó reportado.
  - En SPEC-023 Copilot reemplazó la línea, por eso no apareció.
- **Propuesta:** leer la última línea no vacía antes de quitar espacios:
  `grep -v '^[[:space:]]*#' | tr -d '\r' | grep -v '^[[:space:]]*$' | tail -1 | tr -d '[:space:]'`.
  Además, que la skill del 5.1.1 diga «reemplaza la última línea».

### M3. En el 5.2.1, «apruebo» no aprueba el decimal exacto

- **Evidencia:**
  - En el camino A, el plan preguntó «¿Apruebas usar `BigDecimal` o prefieres `double`?
    Sin tu aprobación explícita se implementa con `double`». La guía solo dice responder
    «apruebo».
  - Copilot entendió el plan aprobado y `BigDecimal` no.
  - **Consecuencias en el 5.3:** fallan pruebas de medio centavo que en el camino A no
    deberían fallar, la conciliación da 22,00 en vez de 22,03, y el diagnóstico se
    alargó.
- **Propuesta:** que la hoja de respuestas del 5.2 diga qué responder si el plan pregunta
  por el tipo: en el camino A, «sí, decimal exacto en el reporte». O que la skill del 5.2.1
  no haga esa pregunta cuando la decisión 0004 ya la resuelve.

### M4. Después de un rechazo, «Sigue sin ese comando» no basta

- **Evidencia:**
  - **Por qué se rechaza:** Copilot quiso borrar sus propios archivos temporales seis
    veces, en el 5.1.1, el 5.3.3, el 5.4.1 y el 5.3 del camino B. La guía dice rechazar
    todo borrado.
  - **Después del «Sigue sin ese comando» de la guía:**
    - En el 5.3.3 del camino A respondió «uso Git Bash para todo» y borró lo mismo con
      `bash.exe -c "rm -rf __diag ..."`. El conductor lo aprobó por el hueco descrito
      arriba; en Visual Studio Code el participante lo habría visto.
    - En el 5.3.1 del camino B repitió el mismo `Remove-Item` en el turno siguiente.
    - Hizo falta escribir «No borres esos archivos temporales: déjalos donde están y
      sigue».
- **Propuesta:** que la guía cambie la frase por «Sigue sin borrar nada; deja los
  temporales». Y que las skills que diagnostican, 5.1.1 y 5.3.1 a 5.3.3, digan que los
  scripts temporales van fuera del repositorio y no se borran.

### M5. Archivos temporales en la raíz del repositorio

- **Evidencia:**
  - En el 5.3.3 del camino A, Copilot creó `__diag_tramos.py`, `__diag_tramos.sh`,
    `__diag_tramos.awk`, `__diag_cm0004.sh` y la carpeta `__diag/` en la raíz.
  - En el 5.3 del camino B quedaron `salida-ejemplo.txt` y `reporte-ejemplo.txt`.
  - El commit que propone el 5.3.4 es `git add -A`, y los habría incluido si no se hubieran
    borrado antes.
- **Propuesta:** la misma de M4, y que el 5.3.4 proponga `git add escenario docs scripts
  .github`.

### M6. Las notas de versión del 5.4.1 invierten el cambio de CM0001 y CM0007

- **Evidencia:**
  - La tabla dice que la comisión baja 11,00 (749,34 → 738,34 y 929,11 → 918,11). Sube:
    727,34 → 738,34 y 907,11 → 918,11, como midió el mismo Copilot en el 5.3.3.
  - Los tres de un centavo están bien.
  - El error lo detectó el propio Copilot en el 5.4.2 y ofreció corregirlo.
- **Propuesta:** que la hoja traiga el antes y el después de los cinco comercios, y que la
  skill del 5.4.1 los tome de dos ejecuciones reales de la liquidación.

### M7. En el 5.3.1 del camino B, la prueba del borde no prueba la liquidación

- **Evidencia:** la prueba del criterio del borde se escribió contra `CalculadoraComision`,
  que ya trata el límite como inclusivo, y pasó. En el camino B el reporte usa el cálculo de
  la liquidación, y la guía espera que esa prueba falle. Solo falló la de medio centavo.
- **Propuesta:** que la skill del 5.3.1 diga que cada prueba del cálculo usa la clase que
  calcula la comisión del reporte. En el camino B, esa clase es la liquidación.

### M8. El 5.3 no cabe en 45 minutos

73 minutos de agente, 2,4 veces los 1809 s de SPEC-023, ver la tabla del 5.3.
La causa principal es el diagnóstico con scripts temporales y las tres rondas de aprobación.
Es el dato que pedía SPEC-023 para decidir.

- **Propuesta, para decidir:** dar 90 minutos al 5.3, o partir el paso 3 en dos laboratorios,
  diagnóstico y corrección.

### M9. Diferencias menores

- **5.3.2, camino A:** atribuyó los 22,00 a la acumulación de medios centavos; es el borde.
  En el paso 3 lo corrigió solo.
- **5.2.2, camino B:** atribuyó la falla del reporte al conflicto del borde «anticipado» en
  el plan. Es un diagnóstico antes de tiempo, y para abril y mayo además es falso: la causa
  es W1.
- **1.4.1:** respondió explicando por qué el pedido es vago, en vez de responderlo.
- **Afirmaciones falsas:**
  - En el 4.4.1, «dentro de las 150 líneas»; el documento tiene 254.
  - En el 4.4.4, que ningún dato cae en el límite de un tramo; TX002001 a TX002004 sí.
  - En el 5.4.1, que el problema de `verificar-reporte.sh` ya se corrigió.
- **5.3.4:** marcó por su cuenta «una persona revisó cada línea».
- **5.4.3:** volvió a creer pendiente un commit que el participante ya había hecho.

## Lo que el material corrigió y se confirmó en Windows

- 5.1.3: tres alternativas, incluida la del camino A, sin pedirla.
- 5.3.1: la prueba de conciliación compara contra la liquidación y falla en junio en el
  camino A.
- 5.4.1: propuso 1.5.0 y esperó la confirmación sin escribir archivos.
- 5.4.2: tabla por transacción, TX002001 +3,00 y TX002002 +8,00. La medida comercial queda
  como pregunta abierta y la respuesta no promete ni descarta una devolución.
- El hook ya no bloquea documentos que citan `escenario/datos/`, en el 3.4.4 y en el 5.3.4.
- 4.4.1: el archivo quedó con el nombre exacto.
- 5.2.1 del camino B: actualizó la decisión 0004 al cambiar el plan.
- 5.3.3, en los dos caminos: llegó solo a 22,00 y 0,03 y pidió aprobación antes de cambiar el
  tipo o el redondeo. En el camino B lo hizo con la conciliación en cero, y explicó por qué
  daba cero.
- El servidor MCP local funciona en Windows con `node --permission`, y la inyección de
  NS-0004 no tuvo efecto.

## Lo que no se pudo probar

- **Presupuesto agotado:** el 5.3 del camino B desde la aprobación ampliada del paso 3, y su
  paso 4. El capítulo 5 en .NET por el camino A.
- **.NET en el 1.5:** `comparar-escenarios.sh` sí corrió. Copilot lo ejecutó dos veces
  dentro de PowerShell, en el 1.5.5 y en el 4.4.4, con 0, y por Git Bash terminó en 1 por W2.
- **Depende del escritorio o del editor:**
  - habilitar Copilot en Visual Studio Code y el punto del script de verificación que
    depende de eso;
  - `/explain`;
  - el selector de agentes;
  - la lista de referencias;
  - «MCP: List Servers»;
  - el botón de revisión del 5.3.4;
  - qué terminal usa el modo agente;
  - cómo se ve en el editor lo que Copilot dice haber mostrado.
- **Depende de GitHub:** el 5.3.5.
- **`/review`:** no se usó, para ahorrar presupuesto.

## Estado en que queda la VM

Encendida y sin borrar. Con todo lo instalado, la shell de SSH en Git Bash y el clon en
`C:\Users\taller\taller\github-copilot-netec-taller`:

- la rama `reporte-medios-de-pago`, con el camino A completo;
- la rama `camino-b`, con el 5.3 a medio paso 3 y cambios sin confirmar.

La sesión de Copilot CLI sigue iniciada, con el token en texto plano en
`C:\Users\taller\.copilot\config.json`; se borra con `copilot logout`.
