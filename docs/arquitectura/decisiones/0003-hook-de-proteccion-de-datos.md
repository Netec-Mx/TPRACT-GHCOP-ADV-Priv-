# 0003. Proteger los datos del escenario con un hook

| Campo | Valor |
|---|---|
| Estado | Aceptada |
| Fecha | 2026-10-03 |
| Responsable | Equipo del taller |

## Contexto

Los archivos de `escenario/datos/` son la entrada de todos los laboratorios. Las salidas
esperadas, la comparación entre escenarios y los resultados que la sala compara dependen de
que esos datos no cambien.

Un agente al que se le pide, por ejemplo, agregar datos de prueba puede modificarlos sin
mala intención. Las instrucciones del repositorio le piden que no lo haga, pero una
instrucción se le pide al modelo y no impide la acción.

## Alternativas consideradas

- **Solo instrucciones.** Sin costo. No impide nada si el modelo no la sigue.
- **Permisos de solo lectura en el sistema de archivos.** Git no los conserva de forma
  confiable entre sistemas, y cualquier usuario los revierte.
- **Sin protección, con restauración posterior.** El script de reinicio de laboratorios
  recupera los datos. El daño se ve tarde, cuando un resultado ya no coincide.
- **Aislamiento del agente en Visual Studio Code.** Restringe los comandos de terminal. No
  cubre las herramientas de archivos integradas del editor.
- **Un hook antes de cada herramienta.** Bloquea la escritura antes de que ocurra, con un
  mensaje explicativo, y deja pasar la lectura.

## Decisión

Se agrega un hook `PreToolUse` en `.github/hooks/proteger-datos-escenario.json`, que ejecuta
`.github/hooks/proteger-datos-escenario.js` antes de cada herramienta del agente. Si la
herramienta escribe, o es un comando de terminal que modifica archivos, y apunta a
`escenario/datos/`, el hook rechaza la llamada con un mensaje. Todo lo demás pasa.

## Consecuencias

- La regla de no modificar los datos se impone, no solo se pide.
- El control es un archivo del repositorio, versionado y revisable en pull request.
- Los hooks están en vista previa en Visual Studio Code. El comportamiento se verifica en
  cada ambiente y la demostración tiene un plan alternativo.
- El hook reconoce herramientas y comandos por patrón. Una forma de escribir que no esté en
  su lista pasaría. Es un control razonable, no un perímetro.
- Si `chat.useHooks` está deshabilitado, el hook no corre.

## Verificación

`bash scripts/verificar-ambiente.sh` prueba el script del hook en los dos sentidos, una
escritura bloqueada y otra permitida, y reprueba si `chat.useHooks` está deshabilitado. La
demostración del subtema 3.3 lo muestra en Visual Studio Code.
