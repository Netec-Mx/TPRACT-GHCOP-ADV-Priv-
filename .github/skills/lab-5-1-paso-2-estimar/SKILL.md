---
name: lab-5-1-paso-2-estimar
description: 'Lab 5.1 paso 2, fase de Estimación. Estima la historia del reporte por fase, con IA y sin IA.'
disable-model-invocation: true
---

# Objetivo

Estimar cuánto va a tomar construir la historia del reporte, fase por fase, con IA y sin IA.
Es la fase de Estimación de [CICLO-DE-VIDA.md](../../../CICLO-DE-VIDA.md).

Material de partida:

- `docs/proyecto/historia-reporte-medios-de-pago.md`. Si no existe, dilo y termina: el
  participante necesita el paso 1.
- [La plantilla de estimación](../../../docs/proyecto/plantillas/estimacion.md)

# Qué hacer

1. Anota en `docs/proyecto/registro-de-tiempos.md` la hora de inicio de Estimación, con `date +%H:%M`, y
   `participante` en Origen.
2. Sigue la skill `pasarela-estimar` para una funcionalidad nueva y crea
   `docs/proyecto/estimacion.md`. Pregunta al participante, en una sola pregunta, cuánta
   experiencia tiene con el stack y con el agente, porque cambia el «sin IA» y el «con IA».
3. Copia en la columna «Estimado con IA» del registro de tiempos el total de la persona de
   cada fase.
4. Al terminar, anota en el registro de tiempos la hora de término de Estimación.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Sin precios ni valores de ningún plan.
- No modifiques código.

# Salida esperada

Muestra en el chat el contenido completo de `docs/proyecto/estimacion.md` y de
`docs/proyecto/registro-de-tiempos.md`, no un resumen. Al final, las dos fases con más
incertidumbre y por qué.
