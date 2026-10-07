# Troubleshooting

Problemas conocidos durante el taller y su solución. Está escrito para que un participante
lo resuelva solo, sin detener a todo el grupo.

## 1. El script de verificación falla en Windows con un error que menciona `\r`

### Síntoma

Al ejecutar el script desde Git Bash en Windows, aparece alguno de estos mensajes:

```
$'\r': command not found
scripts/verificar-ambiente.sh: line 2: $'\r': command not found
syntax error near unexpected token `$'{\r''
/usr/bin/env: 'bash\r': No such file or directory
```

El mensaje no dice cuál es la causa real y suele mandar a buscar errores de sintaxis donde
no los hay. El script está bien; lo que está mal es cómo llegó al disco.

### Causa

Windows termina las líneas con retorno de carro y salto de línea (CRLF). Unix usa solo
salto de línea (LF). Cuando un script con CRLF se ejecuta en Git Bash, el `\r` sobrante
queda pegado al final de cada línea y pasa a formar parte de los comandos. `bash` se
convierte en `bash\r`, que no existe.

Pasa cuando la configuración de Git en la máquina tiene `core.autocrlf=true`, que es el
valor por omisión del instalador de Git para Windows, y el repositorio no le dice otra cosa.

### Solución

Este repositorio incluye un archivo `.gitattributes` que fuerza LF en todos los scripts,
así que un clon nuevo no debería presentar el problema.

Si igual aparece, es porque el clon se hizo antes de que existiera ese archivo, o porque
los archivos se copiaron a mano en vez de clonarlos. Se corrige forzando que git vuelva a
escribir los archivos en el disco:

```bash
git rm --cached -r .
git reset --hard
```

Para confirmar que quedó bien, este comando no debe imprimir nada:

```bash
grep -c $'\r' scripts/verificar-ambiente.sh
```

Si devuelve un número distinto de cero, el archivo sigue con CRLF.

### Cómo evitarlo de entrada

Al preparar la imagen de la máquina virtual, dejar configurado:

```bash
git config --global core.autocrlf input
```

Con `input`, git convierte CRLF a LF al guardar en el repositorio y no hace la conversión
inversa al escribir en el disco. Es el valor correcto para trabajar con repositorios que
se comparten entre Windows y Unix.

### Por qué esto está documentado primero

Es el primer comando que el participante ejecuta en el taller. Si falla con un mensaje
incomprensible antes de empezar, se pierden los primeros minutos de la sesión y la
confianza en el material.

---

## 2. Copilot no hace nada y todo parece estar bien

### Síntoma

Todo esto a la vez:

- Al escribir código no aparece ninguna sugerencia en línea.
- En el panel de salida (`Ctrl+Shift+U`) no existe el canal de GitHub Copilot Chat.
- La sesión de GitHub está iniciada y la licencia de Copilot está asignada.
- Las versiones son correctas y la conectividad a los dominios de Copilot está completa.
- El editor no muestra ningún error que explique lo que pasa.

Cuesta diagnosticarlo porque no hay nada roto que mirar.

### Causa

Las funciones de IA de Visual Studio Code están deshabilitadas.

Desde la versión 1.116, Copilot viene integrado en el editor como la extensión GitHub
Copilot Chat, que no se instala ni aparece en la lista normal de extensiones. La primera
vez que se abre el editor con un perfil de usuario nuevo, si Copilot todavía no está
configurado, el editor la deshabilita por su cuenta. En una máquina virtual pasa con cada
usuario que entra por primera vez.

También puede venir de un ajuste: `chat.disableAIFeatures` en `true`, en la configuración
de usuario o en la del espacio de trabajo.

### Solución

1. Pasar el puntero sobre el ícono de Copilot de la barra de estado.
2. Elegir **Use AI Features**.
3. Iniciar sesión con **Sign in to use Copilot**, con la cuenta de GitHub que tiene la
   licencia.

El ajuste `chat.disableAIFeatures` no debe quedar en `true`. Si sigue en `true` después del
paso 2, buscarlo en la configuración (`Ctrl+,`; en macOS, `Cmd+,`) y dejar la casilla
desmarcada. Si la desactivación viene del archivo `.vscode/settings.json` del repositorio,
que fija `"chat.disableAIFeatures": true`, ese ajuste del espacio de trabajo prevalece sobre
el de usuario: se borra la línea del archivo.

### Cómo confirmarlo

Cerrar Visual Studio Code por completo y ejecutar:

```bash
bash scripts/verificar-ambiente.sh --sin-red
```

La sección «GitHub Copilot en Visual Studio Code» debe decir que las funciones de IA
están habilitadas. Hay que cerrar el editor antes porque guarda este estado en disco con
retraso, y el script lo lee desde disco.

### Lo que no hay que hacer

No instalar la extensión `GitHub.copilot` desde el marketplace. Está descontinuada, su
función la cumple hoy Copilot Chat, y la instalación falla con un error que menciona que
`github.copilot-chat` es una extensión integrada que no se puede degradar. Ese error no
es el problema: es una pista falsa. El detalle está en
[00-setup-ambiente.md](00-setup-ambiente.md).

---

## 3. Copilot no responde, con las funciones de IA habilitadas

### Síntoma

Las funciones de IA están habilitadas, como pide la entrada 2, pero Copilot no sugiere ni
responde, responde con otra cuenta o pide iniciar sesión cada vez que se reinicia la
máquina virtual.

### Causa

- La sesión de GitHub del editor es de una cuenta sin licencia de Copilot, por ejemplo una
  personal.
- La sesión no persiste entre reinicios de la máquina virtual.
- La política de la organización deshabilita Copilot Chat o el modo agente.

### Solución

1. Abrir el ícono **Accounts** de la barra lateral, cerrar la sesión de GitHub e iniciarla
   con la cuenta que tiene la licencia.
2. Si la sesión se pierde en cada reinicio, iniciarla de nuevo y avisar al relator: se
   corrige en la imagen, no en clase.
3. Si la política lo impide, avisar al relator y trabajar en pareja con otro participante
   mientras el administrador lo revisa.

Para confirmar, abrir el chat y escribir `hola`. Si responde, la licencia, la sesión y la
red están bien.

---

## 4. Copilot dice que se alcanzó el límite de uso

### Síntoma

Copilot deja de responder a mitad de un paso con un mensaje de cuota o de límite de uso
agotado. No hay aviso previo.

### Causa

La cuenta consumió su cuota mensual y el presupuesto adicional que la organización le
asignó. Los pasos que escriben y corrigen código en el capítulo 5 son los que más consumen.

### Solución

1. Avisar al relator y seguir el paso en pareja con otro participante.
2. Cuando vuelva el acceso, el relator indica cómo ponerse al día con
   `bash scripts/proyecto/ponerse-al-dia.sh`, si el laboratorio es del capítulo 5.

Para no llegar al límite antes de tiempo, seguir la guía
[uso-responsable-de-tokens.md](gobierno/uso-responsable-de-tokens.md).

---

## 5. «Breña» aparece mal escrita o el comparador falla solo en esas líneas

### Síntoma

En Git Bash sobre Windows, la razón social «Breña» de CM0013 y CM0037 aparece como
`Bre�a` u otro carácter. Si pasa dentro de `bash scripts/comparar-escenarios.sh`, el
comparador termina en 1 y la única diferencia está en esas líneas.

### Causa

En Git Bash sobre Windows, .NET escribe en la página de códigos de la consola, 850 o 437
en una máquina en español, y Java escribe en UTF-8. No hay diferencia de cálculo.
`comparar-escenarios.sh` e `integracion-local.sh` cambian la consola a UTF-8 mientras
corren y la devuelven a su página al terminar, así que ejecutados con `bash scripts/...`
no deberían mostrar el problema.

### Solución

- Si se ve al ejecutar el escenario a mano, es solo la presentación en la consola. No hay
  que tocar el código ni los datos.
- Si el comparador falla solo por esas líneas, ejecutar en la misma terminal:

  ```bash
  chcp.com 65001
  bash scripts/comparar-escenarios.sh
  ```

  Si termina en cero, el escenario está bien. Avisar al relator cómo se lanzó el script.
- Si la diferencia está en otras líneas, es real y se trata como pide el laboratorio.

---

## 6. Copilot propone comandos de PowerShell

### Síntoma

En Windows, Copilot pide aprobar comandos distintos de los que dice el laboratorio:
`Select-String` en lugar de `grep`, `Get-Content` en lugar de `cat`, `Remove-Item` en
lugar de `rm`, `New-Item` para crear una carpeta. A veces falla `date +%H:%M`, un heredoc o
una llamada a `python`.

### Causa

En Windows, la terminal que usa Copilot puede ser PowerShell. Ahí `date` es `Get-Date`, no
existen los heredoc y `python` abre el atajo de la Tienda, porque Python no es parte del
ambiente.

### Solución

- Leer el comando y aprobarlo si solo lee, compila, prueba o ejecuta un script de
  `scripts/`, aunque esté escrito en PowerShell.
- Rechazar igual que en Git Bash los borrados, `git stash`, `git reset`, `git checkout`,
  `git restore`, `git commit`, `git push` y cualquier escritura en `escenario/datos/`.
- Los scripts del taller se ejecutan con Git Bash. Si Copilot intenta otra cosa, pedirle:
  «Ejecuta el script con Git Bash, `bash scripts/...`».
- Si intenta usar Python, rechazarlo y escribir «Sigue sin ese comando».

---

## 7. El hook bloquea una acción

### Síntoma

El agente informa que no pudo completar una edición con este mensaje:

```
Los datos del escenario están protegidos y no se pueden modificar. Ningún laboratorio requiere cambiar los archivos de escenario/datos/.
```

### Causa

El hook de `.github/hooks/` corre antes de cada herramienta del agente y bloquea lo que
crea, modifica, mueve o borra un archivo en `escenario/datos/`. Deja leer los datos y deja
escribir documentos que citan esa ruta. Es intencional: ningún laboratorio cambia los
datos.

### Solución

- Si el agente quería escribir en `escenario/datos/`, el bloqueo es correcto. Seguir con el
  paso.
- Si bloqueó algo que no escribe en `escenario/datos/`, anotar el comando exacto, avisar al
  relator y pedirle a Copilot que logre lo mismo sin tocar esa ruta.
- Si los datos quedaron modificados, restaurarlos con
  `bash scripts/reiniciar-lab.sh <laboratorio>`.

---

## 8. Las skills, el servidor MCP o el hook no aparecen

### Síntoma

Las skills no aparecen al escribir `/` en el chat. El servidor MCP del laboratorio 3.4 no
arranca o sus tres herramientas no se listan. El hook no corre. Visual Studio Code muestra
un aviso de modo restringido.

### Causa

La carpeta del repositorio se abrió sin marcarla como de confianza. En modo restringido,
Visual Studio Code no ejecuta los servidores MCP ni los hooks del espacio de trabajo.
También puede ser que `chat.useHooks` esté en `false` en la configuración.

### Solución

1. Hacer clic en el aviso de modo restringido y elegir confiar en la carpeta.
2. En el 3.4, abrir **View**, **Command Palette**, `MCP: List Servers`, elegir
   `pasarela-andina` y **Start Server**. El ícono de herramientas del chat debe listar
   `buscar_comercios`, `detalle_comercio` y `buscar_notas_soporte`.
3. Ejecutar `bash scripts/verificar-ambiente.sh --sin-red` y revisar las secciones «Hook de
   proteccion de datos» y «Servidor MCP local».

---

## 9. Copilot quiere borrar archivos o usar `git stash`

### Síntoma

Copilot pide aprobar un `rm`, un `Remove-Item` o un `bash.exe -c "rm ..."`, casi siempre
sobre archivos temporales que él mismo creó. O pide `git stash`, `git reset`,
`git checkout` o `git restore` para comparar el antes y el después de un cambio.

### Causa

Al diagnosticar, Copilot crea archivos temporales y quiere limpiarlos. Las instrucciones
del repositorio le piden dejar los temporales fuera del repositorio y no borrar archivos,
pero puede intentarlo igual.

### Solución

1. Rechazar con **Skip**.
2. Si era un borrado, escribir: «No borres archivos. Déjalos donde están y sigue con el
   paso.»
3. Si era `git stash` o un comando parecido, escribir: «Sigue sin ese comando».
4. Leer el comando siguiente completo: Copilot puede repetir el mismo borrado dentro de
   `bash.exe -c "..."`. Se rechaza igual.
5. Si quedan temporales en la raíz, no incluirlos en el commit. Agregar solo las carpetas
   del trabajo, sin `git add -A` ni `git add .`.

---

## 10. El pipeline dice que `stack.txt` tiene dos líneas activas

### Síntoma

`bash scripts/integracion-local.sh` se detiene antes de compilar, con código 2:

```
scripts/integracion/stack.txt tiene 2 lineas activas: ambos, java.
Deja una sola, la del stack que elegiste (ambos, java o dotnet), y confirma el cambio.
```

### Causa

En el laboratorio 5.1 hay que reemplazar la última línea de `scripts/integracion/stack.txt`
por el stack elegido. Si se agrega una línea nueva y queda la anterior, el pipeline local y
el workflow no saben cuál usar.

### Solución

Abrir `scripts/integracion/stack.txt`, borrar la línea que sobra y dejar solo la del stack
elegido, `java` o `dotnet`. Confirmar el cambio y volver a ejecutar:

```bash
bash scripts/integracion-local.sh
```

No usar `--stack` para saltarse el problema: el workflow lee el mismo archivo.
