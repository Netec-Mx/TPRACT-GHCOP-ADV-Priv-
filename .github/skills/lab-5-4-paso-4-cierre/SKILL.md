---
name: lab-5-4-paso-4-cierre
description: 'Lab 5.4 paso 4, cierre del ciclo. Compara lo estimado con lo real, lista los activos reutilizables y deja la línea base de medición y el presupuesto de créditos.'
disable-model-invocation: true
---

# Objetivo

Cerrar el ciclo con tres cosas que el equipo se lleva: la comparación entre lo estimado y lo
real, los activos que puede reutilizar y la línea base para medir la adopción.

# Qué hacer

1. **Estimado contra real.** Completa en `docs/proyecto/registro-de-tiempos.md` los minutos
   reales, término menos inicio, y la diferencia de cada fase contra su «Estimado con IA».
   Si a una fase le falta el inicio o el término, déjala sin minutos y dilo. Una fase sin
   estimado no tiene diferencia. Las filas con
   `referencia` en Origen las dejó `ponerse-al-dia.sh`: no son del participante. Agrega al
   final las tres fases del participante con más diferencia, o las que haya si son menos, y
   una causa probable de cada una, y una línea aparte que diga qué fases son de referencia y que no se comparan.
2. **Activos reutilizables.** Crea `docs/proyecto/activos-del-equipo.md` con las skills, las
   plantillas, la instrucción y el pipeline que se usaron en el ciclo: para cada uno, para
   qué sirve, dónde está y qué habría que cambiar para usarlo en otro repositorio. Las
   skills de dominio son las de `.github/skills/` con prefijo `pasarela-`.
3. **Medición y presupuesto.** Crea `docs/proyecto/medicion-y-presupuesto.md` con dos partes.
   Una línea base de medición: qué se mide antes de extender el uso y después, de dónde sale
   el dato y quién es responsable, por ejemplo personas que usan Copilot cada semana, tiempo
   de revisión de pull requests y defectos encontrados después de integrar. Y una propuesta
   de presupuesto de créditos por perfil de uso, con los modos de trabajo que usa cada
   perfil y qué se hace al acercarse al límite.
4. Propón el commit final de la rama y espera la confirmación.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No inventes precios, cuotas ni límites de ningún plan. Quedan como campos a completar con
  la documentación oficial y la configuración de la organización.
- No inventes minutos reales: salen del registro de tiempos.

# Salida esperada

Muestra en el chat el contenido completo de los tres documentos, no un resumen. Si alguno
supera las 150 líneas, muestra completas la comparación de estimado contra real, la línea
base de medición y el presupuesto, y nombra el archivo para abrir el resto. Al final, la
fase donde la estimación más se equivocó.

Escribe ese contenido en el texto de tu respuesta, como Markdown o en un bloque de código.
No basta con ejecutar `cat` o `git diff` en la terminal ni con decir que ya se ve en la
vista de una herramienta: el participante lo tiene que poder leer en tu respuesta.
