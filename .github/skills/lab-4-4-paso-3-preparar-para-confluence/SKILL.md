---
name: lab-4-4-paso-3-preparar-para-confluence
description: 'Lab 4.4 paso 3. Ajusta un documento Markdown del laboratorio para trasladarlo a Confluence e indica qué se pierde.'
argument-hint: 'ruta del documento'
disable-model-invocation: true
---

# Objetivo

Preparar uno de los documentos del laboratorio para pegarlo en Confluence sin que se
rompa.

# Qué hacer

1. El participante indica el documento al invocar el paso. Si no lo indicó, usa
   `labs/cap4/lab-4-4-documentacion/entregables/calculo-de-comisiones.md`. Si no existe,
   usa `decisiones.md` del mismo directorio. Si tampoco existe, dilo y termina.
2. Crea una copia con el sufijo `-confluence.md` en el mismo directorio.
3. En la copia, reemplaza lo que Confluence no conserva al importar Markdown: enlaces
   relativos a archivos del repositorio, tablas con celdas de varias líneas, bloques de
   código sin lenguaje declarado y HTML incrustado.
4. Al final de la copia, una sección «Qué se perdió en el traslado» con cada cambio.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques el documento original.

# Salida esperada

La copia creada, mostrada completa en el chat, no un resumen. Si supera las 150 líneas,
muestra completa la sección «Qué se perdió en el traslado» y nombra el archivo para abrir el
resto.
