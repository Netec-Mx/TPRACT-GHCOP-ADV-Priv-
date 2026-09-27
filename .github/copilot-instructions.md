# Instrucciones de repositorio

Estas reglas aplican a todo el repositorio, en cualquier modo de chat y con cualquier
agente. Las reglas propias de cada lenguaje están en `.github/instructions/`.

## Idioma

- Responde en español neutro.
- Los comentarios, los mensajes de commit y la documentación van en español.
- Los identificadores siguen la convención del lenguaje del archivo que se edita.

## Alcance de los cambios

- Haz exactamente lo que se pide. El alcance de la tarea es el alcance del cambio.
- Antes de modificar un archivo que la tarea no nombra, pregunta.
- Si ves un problema que no forma parte de la tarea, menciónalo al final de tu respuesta
  y no lo toques.

## El código de `escenario/`

El código de `escenario/` es material de laboratorio. Tiene características elegidas a
propósito que pueden parecer errores o malas prácticas.

- No las corrijas salvo que la tarea lo pida de forma explícita.
- No cambies tipos de datos, no extraigas literales a constantes, no unifiques código
  entre clases, no renombres y no agregues manejo de errores por iniciativa propia.
- No agregues ni modifiques pruebas salvo que la tarea lo pida.
- No silencies advertencias con anotaciones ni supresiones.

Las reglas de negocio del dominio están en `escenario/README.md`. Cuando el código y esas
reglas no coinciden, dilo en tu respuesta, cita la regla y no cambies nada que no se haya
pedido.

## Verificación

Los dos escenarios, Java y .NET, deben producir exactamente la misma salida. Después de
cualquier cambio en `escenario/` que no deba alterar el comportamiento, la verificación es:

```bash
bash scripts/comparar-escenarios.sh
```

Termina en cero si las salidas son idénticas. Si modificas un solo escenario, este script
te dice si te alejaste del otro.

## Ambiente

- Los scripts se ejecutan en Git Bash. No propongas PowerShell.
- No propongas pasos que descarguen dependencias. Todo está instalado en la máquina.
- El único editor es Visual Studio Code.
