# Troubleshooting

Problemas conocidos durante el taller y su solución. Está escrito para que un participante
lo resuelva solo, sin detener a todo el grupo.

> **Documento en construcción.** La entrada 1 está redactada porque el problema ya se
> conoce y afecta al primer comando que ejecuta el participante. El resto del índice son
> secciones previstas y se redactan en **SPEC-007**.

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

## Índice de las secciones pendientes

> Pendiente de redacción (**SPEC-007**).

2. **Copilot no responde o no sugiere.** Licencia sin asignar, sesión caída en el IDE,
   política de organización que bloquea el chat o el modo agente.
3. **Problemas de red corporativa.** Dominios bloqueados, proxy autenticado, inspección
   TLS con certificado propio y el caso particular de Node.js con `NODE_EXTRA_CA_CERTS`.
4. **Exclusión de contenido.** Síntomas de un archivo o repositorio excluido por política
   y cómo confirmarlo.
5. **Escenario Java que no compila.** JDK equivocado en el PATH, versión de Maven,
   repositorio local sin las dependencias precargadas.
6. **Escenario .NET que no compila.** SDK equivocado, `global.json` apuntando a una versión
   ausente, restauración de paquetes sin acceso a la fuente.
7. **Servidor MCP que no levanta.** Configuración mal ubicada, Node ausente del PATH,
   herramientas que no aparecen en el registro del cliente.
8. **Rendimiento en la máquina virtual.** Latencia del escritorio remoto, indexación del
   workspace y qué cerrar cuando la máquina se satura.
9. **Artefactos de personalización que no se aplican.** Ubicación incorrecta del archivo,
   patrón de `applyTo` que no coincide, precedencia entre instrucciones de repositorio y
   por ruta.

## Pendiente

- [ ] Redactar las entradas 2 a 9 con síntoma, causa y solución verificada (SPEC-007)
- [ ] Incorporar los problemas que aparezcan durante el ensayo previo a la primera sesión
