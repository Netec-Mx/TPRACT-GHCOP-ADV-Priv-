# Instrucciones de repositorio

Estas reglas aplican a todo el repositorio, en cualquier modo de chat y con cualquier
agente. Las reglas propias de cada lenguaje están en `.github/instructions/`.

## Idioma

- Responde en español neutro.
- Los comentarios, los mensajes de commit y la documentación van en español.
- Los identificadores siguen la convención del lenguaje del archivo que se edita.

## Alcance de los cambios

- Haz exactamente lo que se pide. El alcance de la tarea es el alcance del cambio.
- Antes de modificar un archivo que la tarea o el plan que el participante aprobó no
  incluyen, pregunta.
- Si ves un problema que no forma parte de la tarea, menciónalo al final de tu respuesta
  y no lo toques.

## El código de `escenario/`

El código de `escenario/` es material de laboratorio. Tiene características elegidas a
propósito que pueden parecer errores o malas prácticas.

- No las corrijas salvo que la tarea lo pida de forma explícita.
- No extraigas literales a constantes, no unifiques código entre clases, no renombres y no
  agregues manejo de errores por iniciativa propia.
- No cambies tipos de datos ni la forma de redondear sin la aprobación explícita del
  participante. Si una corrección lo exige, dilo, muestra qué regla toca y espera.
- No agregues ni modifiques pruebas salvo que la tarea lo pida.
- No silencies advertencias con anotaciones ni supresiones.

Las reglas de negocio del dominio están en `escenario/README.md`. Cuando el código y esas
reglas no coinciden, dilo en tu respuesta, cita la regla y no cambies nada que no se haya
pedido.

## Lo que produces

Cuando creas o modificas un archivo, escribe en el texto de tu respuesta su contenido
completo, o el diff si es código, como Markdown o en un bloque de código. Aunque la
herramienta que creó o editó el archivo ya muestre su contenido, cópialo igual. No basta con
ejecutar `cat` o `git diff` ni con escribir «mostrado arriba» o un encabezado sin el
contenido debajo.

## Archivos temporales

- Los archivos temporales de diagnóstico, como una salida guardada o un programa de prueba,
  van en la carpeta temporal del sistema, fuera del repositorio.
- No borres archivos del repositorio. Si dejaste un temporal dentro, dilo y déjalo.

## Verificación

Los dos escenarios, Java y .NET, deben producir exactamente la misma salida. Después de
cualquier cambio en `escenario/` que no deba alterar el comportamiento, la verificación es:

```bash
bash scripts/comparar-escenarios.sh
```

Termina en cero si las salidas son idénticas. Si modificas un solo escenario, este script
te dice si te alejaste del otro.

Para comparar el antes y el después de un cambio, guarda la salida de antes en un archivo
temporal fuera del repositorio, antes de cambiar nada, o compila una copia en una carpeta
temporal. Nunca uses `git stash`, `git reset`, `git checkout` ni `git restore` para eso.

## Gobierno

Estas reglas vienen de la política de uso de IA de Pasarela Andina,
`docs/gobierno/politica-uso-ia.md`.

- No escribas secretos, credenciales, datos personales ni datos reales de clientes en
  código, documentos ni respuestas. Si encuentras alguno en el contexto, no lo repitas y
  avisa. Los datos de `escenario/datos/` y `mcp/datos/` son ficticios y se pueden mostrar.
- No agregues ni propongas servidores MCP ni extensiones nuevos. Los aprueba el equipo. El
  servidor local de `mcp/` ya está aprobado y se configura en el laboratorio 3.4.
- No hagas commits por tu cuenta ni push. Propón el commit; el participante lo ejecuta o lo
  aprueba. Los cambios los revisa e integra una persona.

## Ambiente

- Los scripts se ejecutan en Git Bash. No propongas PowerShell.
- En Windows, los scripts del taller se ejecutan con Git Bash, `bash scripts/...`. Si tu
  terminal es PowerShell, llama a Git Bash para ellos.
- No uses Python: no es parte del ambiente.
- No propongas pasos que descarguen dependencias. Todo está instalado en la máquina.
- El único editor es Visual Studio Code.
