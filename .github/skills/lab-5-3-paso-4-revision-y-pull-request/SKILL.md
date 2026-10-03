---
name: lab-5-3-paso-4-revision-y-pull-request
description: 'Lab 5.3 paso 4, fases de Revisión de código y Seguridad. Escribe la descripción del pull request, registra la decisión del borde y completa la revisión.'
disable-model-invocation: true
---

# Objetivo

Dejar el cambio listo para integrarse: descripción del pull request con la plantilla,
revisión de Copilot sobre los cambios locales, lista de comprobación de seguridad y la
decisión de negocio registrada. Son las fases de Revisión de código y Seguridad de
[CICLO-DE-VIDA.md](../../../CICLO-DE-VIDA.md).

# Qué hacer

1. Anota en `docs/proyecto/registro-de-tiempos.md` la hora actual en Revisión de código y en
   Seguridad.
2. Pregúntale al participante si ya pidió la revisión de Copilot sobre sus cambios sin
   confirmar, con el botón **Copilot Code Review - Uncommitted Changes** de la vista
   **Source Control**. Si no, pídele que lo haga ahora y que te diga qué comentarios dejó y
   qué decidió con cada uno: aplicar, descartar o decidir con el equipo.
3. Registra la decisión del negocio sobre el límite de los tramos con la skill
   `pasarela-registrar-decision`, citando la historia y la corrección.
4. Crea `docs/proyecto/pull-request.md` completando `.github/pull_request_template.md`.
   Incluye qué cambió y por qué, qué generó el agente, los comentarios de la revisión de
   Copilot con su decisión, el cambio de hash esperado con su justificación y el enlace a la
   decisión.
5. Revisa tú el diff completo contra la lista de comprobación de la plantilla: que no entren
   secretos ni datos reales, que no se haya modificado `escenario/datos/`, que el pipeline
   esté en verde y que cada hash esperado que cambió tenga su causa. Marca solo las casillas
   que se cumplen y di por qué en las que no.
6. Propón el commit y espera la confirmación del participante, por ejemplo
   `git add -A && git commit -m "Pruebas, conciliacion y correccion del borde de tramo"`.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No marques una casilla que no se cumple.
- Tú no haces el commit.

# Salida esperada

Muestra en el chat el contenido completo de `docs/proyecto/pull-request.md` y de la decisión
registrada, la fila que agregaste al índice de decisiones y
`docs/proyecto/registro-de-tiempos.md` completo, con la hora que anotaste, no un resumen.
Después, las casillas que no se cumplen, si hay alguna.
