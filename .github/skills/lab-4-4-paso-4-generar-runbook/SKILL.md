---
name: lab-4-4-paso-4-generar-runbook
description: 'Lab 4.4 paso 4, opcional. Genera el runbook de troubleshooting del cálculo de comisiones con la plantilla del repositorio y verifica cada acción ejecutándola.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Producir el runbook de troubleshooting del componente documentado en el paso 1, el cálculo
de comisiones y la liquidación, con la plantilla
[runbook-plantilla.md](../../../docs/operacion/runbook-plantilla.md), y dejar cada acción
verificada contra una ejecución real.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

# Qué hacer

1. Lee la plantilla, la sección «Cómo se ejecuta» de
   [escenario/README.md](../../../escenario/README.md) y, si existe,
   `labs/cap4/lab-4-4-documentacion/entregables/calculo-de-comisiones.md`.
2. Escribe tres síntomas que alguien que opera el cálculo podría ver. Por ejemplo, que la
   compilación falle, que las salidas de Java y .NET no coincidan, o que la liquidación de
   un comercio no se pueda explicar con las reglas de negocio.
3. Para cada diagnóstico y cada acción que sea un comando, ejecútalo en la terminal y anota
   en «Verificado» la fecha y lo que observaste. Los comandos se ejecutan desde el
   directorio que indica `escenario/README.md`.
4. Si una acción no se puede ejecutar sin cambiar archivos, no la ejecutes: márcala como
   «no verificada» y di por qué.
5. Crea `labs/cap4/lab-4-4-documentacion/entregables/runbook-calculo-de-comisiones.md`.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Crea un solo archivo. No modifiques código, datos ni otros documentos.
- Ninguna acción del runbook propone modificar `escenario/datos/`.
- Una acción sin ejecución real nunca se marca como verificada.

# Salida esperada

El runbook creado, mostrado completo en el chat, no un resumen. Si supera las 150 líneas,
muestra completo cada síntoma y, de cada acción, el comando y su párrafo «Verificado», y
nombra el archivo para abrir el resto. Después, en tu respuesta, cuántas acciones quedaron verificadas
y cuántas no.
