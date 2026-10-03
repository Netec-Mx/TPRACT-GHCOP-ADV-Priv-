# Troubleshooting

Problemas conocidos durante el taller y su solución. Está escrito para que un participante
lo resuelva solo, sin detener a todo el grupo.

> **Documento en construcción.** Las entradas 1 y 2 están redactadas porque los problemas
> ya se conocen y afectan al participante antes de empezar a trabajar. El resto del índice
> son secciones previstas que se completan antes del taller.

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

1. Abrir la vista de Extensiones (`Ctrl+Shift+X`; en macOS, `Cmd+Shift+X`).
2. Escribir `@builtin copilot` en el buscador.
3. Seleccionar **GitHub Copilot Chat**.
4. Pulsar **Enable AI Features** (**Habilitar características de IA** con la interfaz en
   español). Si el botón que aparece es **Enable** (**Habilitar**), pulsar ese.
5. Si no hay sesión iniciada, iniciarla desde el icono de Copilot de la barra de estado.

Si en el paso 4 el botón que aparece es **Enable AI Features (Workspace)** (**Habilitar
características de IA (área de trabajo)**), la desactivación viene del archivo
`.vscode/settings.json` del repositorio, que fija `"chat.disableAIFeatures": true`. El
ajuste del espacio de trabajo prevalece sobre el de usuario. Ese botón lo cambia a
`false`; también se puede borrar la línea del archivo.

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

## Índice de las secciones pendientes

> Pendiente de redacción.

3. **Copilot no responde o no sugiere, con las funciones de IA habilitadas.** Licencia sin
   asignar, sesión caída en el IDE, política de organización que bloquea el chat o el
   modo agente. El caso de las funciones de IA deshabilitadas está en la entrada 2.
4. **Problemas de red corporativa.** Dominios bloqueados, proxy autenticado, inspección
   TLS con certificado propio y el caso particular de Node.js con `NODE_EXTRA_CA_CERTS`.
5. **Exclusión de contenido.** Síntomas de un archivo o repositorio excluido por política
   y cómo confirmarlo.
6. **Escenario Java que no compila.** JDK equivocado en el PATH, versión de Maven,
   repositorio local sin las dependencias precargadas.
7. **Escenario .NET que no compila.** SDK equivocado, `global.json` apuntando a una versión
   ausente, restauración de paquetes sin acceso a la fuente.
8. **Servidor MCP que no levanta.** Configuración mal ubicada, Node ausente del PATH,
   herramientas que no aparecen en el registro del cliente.
9. **Rendimiento en la máquina virtual.** Latencia del escritorio remoto, indexación del
   workspace y qué cerrar cuando la máquina se satura.
10. **Artefactos de personalización que no se aplican.** Ubicación incorrecta del archivo,
   patrón de `applyTo` que no coincide, precedencia entre instrucciones de repositorio y
   por ruta.

## Pendiente

- [ ] Redactar las entradas pendientes del índice, 3 a 10, con síntoma, causa y solución
      verificada
- [ ] Incorporar los problemas que aparezcan durante el ensayo previo a la primera sesión
