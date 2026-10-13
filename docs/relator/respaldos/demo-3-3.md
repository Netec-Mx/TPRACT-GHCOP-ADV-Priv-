> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes. Se grabó en la CLI, no en Visual Studio Code. El hook es el mismo archivo del
> repositorio y la CLI lo ejecuta antes de cada herramienta. El paso 4 se ejecutó en Git Bash
> de la misma máquina.

# Demo 3.3. El hook que protege los datos (escenario Java)

Una sola conversación, en modo Agent, con permiso de edición.

## Paso 1

Escrito: `Agrega una transacción de prueba al final de escenario/datos/transacciones.txt.`

Copilot leyó las últimas líneas del archivo, cargó la skill `pasarela-reglas-de-negocio`,
revisó el encabezado y el final de línea, e intentó editar el archivo. El hook corrió antes de
la edición y la negó. La edición no llegó a pedir aprobación. Lo que registró la CLI:

```
Denied by preToolUse hook from ".github_hooks_proteger-datos-escenario.json" (hook errored)
Error: Hook command failed with code 1
Stderr: Los datos del escenario están protegidos y no se pueden modificar. Ningún laboratorio requiere cambiar los archivos de escenario/datos/.
```

Después corrió `git --no-pager diff --stat`, que salió vacío. Respuesta:

> No pude agregar la transacción. Un hook del repositorio, `.github/hooks/proteger-datos-escenario.json`, bloqueó la edición de `escenario/datos/transacciones.txt`. No intento rodearlo, así que el archivo quedó sin cambios.
>
> La skill de reglas de negocio también indica no modificar `escenario/datos/`, porque otros resultados dependen de esos datos.
>
> Esta es la línea que habría agregado, con el formato del archivo:
>
> ```
> TX002038;CM0011;100.00;PEN;2026-06-24 10:00:00;TARJETA_DEBITO;1;APROBADA;TEST01
> ```
>
> Si necesitas el cambio, desactiva o ajusta el hook tú mismo y dime que continúe. También puedo dejar la línea en un archivo fuera de `escenario/datos/`.

## Paso 2

Escrito: `¿Cuántas transacciones tiene escenario/datos/transacciones.txt?`

Respondió con lo que ya había leído en el paso 1, sin usar herramientas:

> El archivo tiene 2037 transacciones: 2038 líneas, de las cuales una es el encabezado. No agregué ninguna, así que el conteo no cambió.

## Paso 3

`.github/hooks/proteger-datos-escenario.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "type": "command",
        "command": "node .github/hooks/proteger-datos-escenario.js",
        "timeout": 10
      }
    ]
  }
}
```

## Paso 4

`git status`:

```
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

`wc -l escenario/datos/transacciones.txt`: `2038`.

## Esperado contra observado

- Paso 1: coincide. El agente intentó editar y recibió el bloqueo con el mensaje del hook. La
  CLI lo presenta como un hook que falló y agrega el texto del hook. El agente no intentó otra
  vía y ofreció la línea para que la agregue una persona.
- Paso 2: coincide, 2037 transacciones más el encabezado.
- Paso 3: coincide.
- Paso 4: coincide, árbol limpio. No fue necesario el plan alternativo.
