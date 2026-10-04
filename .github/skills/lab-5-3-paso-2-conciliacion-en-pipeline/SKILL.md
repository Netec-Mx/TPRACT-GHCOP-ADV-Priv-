---
name: lab-5-3-paso-2-conciliacion-en-pipeline
description: 'Lab 5.3 paso 2, fase de Integración continua. Agrega al pipeline un paso que concilia el total del reporte con las liquidaciones.'
disable-model-invocation: true
---

# Objetivo

Que el pipeline compruebe automáticamente el criterio central de la historia: que el total
del reporte coincide con lo que se liquida. Es la fase de Integración continua de
[CICLO-DE-VIDA.md](../../../CICLO-DE-VIDA.md).

# Qué hacer

1. Anota en `docs/proyecto/registro-de-tiempos.md` la hora de inicio de Integración continua, con `date +%H:%M`, y
   `participante` en Origen.
2. Lee `scripts/integracion-local.sh` y `.github/workflows/integracion-continua.yml`. Los
   pasos viven en el script y el workflow los llama con `--paso`, en el mismo orden.
3. Agrega al script un paso nuevo, `conciliacion`, al final de la lista de pasos. Para cada
   stack declarado y para 2026-04, 2026-05 y 2026-06: ejecuta la liquidación y el reporte,
   suma el «Total comisiones» de cada comercio de la liquidación y compáralo con el «Total»
   del reporte. Haz las cuentas en centavos enteros, sin punto flotante. Muestra la
   diferencia de cada periodo y termina con error si alguna no es cero. Ten en cuenta que la
   liquidación imprime también una línea de resumen general con «Total comisiones», que no
   es de un comercio, y que algunas líneas siguen con texto después del monto.
4. Agrega al workflow un paso que llame a `bash scripts/integracion-local.sh --paso
   conciliacion`, en el trabajo de equivalencia, después del paso de equivalencia.
5. Ejecuta `bash scripts/integracion-local.sh` completo.
6. **Si el pipeline queda en rojo, no corrijas nada.** Muestra qué paso falló y con qué
   diferencia. Se diagnostica en el paso 3.
7. Al terminar, anota en el registro de tiempos la hora de término de Integración continua.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques el escenario ni los hashes esperados.
- No hagas commit.

# Salida esperada

El diff completo de los dos archivos, mostrado en el chat con `git diff --
scripts/integracion-local.sh .github/workflows/integracion-continua.yml`, no un resumen, y
`docs/proyecto/registro-de-tiempos.md` completo, con la hora que anotaste. Después, el
resultado del pipeline local, paso por paso.
