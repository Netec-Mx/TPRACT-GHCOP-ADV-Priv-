# Laboratorio 5.4. Laboratorio final: construcción de activos reutilizables

## Objetivo del laboratorio

Terminar el ciclo de vida: liberar la versión, atender el primer incidente en producción,
estimar el siguiente cambio que pide el negocio y cerrar comparando lo estimado con lo real.
Son las fases de Liberación, Operación y soporte y Mantención evolutiva de
[`CICLO-DE-VIDA.md`](../../../CICLO-DE-VIDA.md). Al final quedan los activos que el equipo se
lleva: las skills y plantillas del ciclo, y la línea base para medir la adopción.

## Duración

45 minutos.

## Prerrequisitos

- Los laboratorios 5.1 a 5.3 terminados y confirmados en tu rama. Este laboratorio continúa
  sobre ese trabajo y **no se reinicia**: reiniciarlo descartaría el ciclo completo.
- Todos los pasos se hacen en modo **Agent**.

## Pasos

| Paso | Qué escribir en el chat | Qué observar | Tiempo |
|---|---|---|---|
| 1 | `/lab-5-4-paso-1-liberar` | Qué número de versión propone y, en las notas que muestra el agente, cómo explica a un comercio por qué cambia su liquidación de junio | 8 min |
| 2 | `/lab-5-4-paso-2-atender-incidente` | En el análisis y la respuesta que muestra el agente, si llega a la causa por las notas de versión y la decisión registrada, y si la respuesta promete algo que no puede prometer | 12 min |
| 3 | `/lab-5-4-paso-3-estimar-evolutiva` | En la estimación que muestra el agente, si usa tu registro de tiempos real como dato, y qué preguntas le haría al negocio | 8 min |
| 4 | `/lab-5-4-paso-4-cierre` | En los documentos que muestra el agente, en qué fase tu estimación más se equivocó, y qué activos podrías llevar a tu repositorio | 10 min |

## Resultado esperado

- `CHANGELOG.md` con la versión nueva y `docs/proyecto/notas-de-version-<versión>.md`.
- El análisis y la respuesta del incidente en `docs/proyecto/incidentes/`.
- `docs/proyecto/estimacion-evolutiva.md`.
- `docs/proyecto/registro-de-tiempos.md` completo, `docs/proyecto/activos-del-equipo.md` y
  `docs/proyecto/medicion-y-presupuesto.md`.

## Criterios de revisión

- [ ] Las notas de versión explican el cambio de junio en lenguaje de negocio, con montos.
- [ ] El análisis del incidente cita la decisión que explica el cambio y lista a los otros
      comercios afectados.
- [ ] La respuesta al comercio no promete devoluciones ni compensaciones.
- [ ] La estimación de la evolutiva usa el registro de tiempos real como dato.
- [ ] El documento de presupuesto deja los valores del plan como campos a completar.
