---
name: lab-5-3-paso-3-revision-asistida
description: 'Lab 5.3 paso 3. Revisa el diff acumulado con criterio de revisor senior y clasifica cada hallazgo en aplicar, descartar o decidir.'
disable-model-invocation: true
---

# Objetivo

Revisar los cambios acumulados en el repositorio como lo haría un revisor senior del
equipo, y clasificar cada hallazgo.

# Qué hacer

1. Obtén el diff acumulado con `git diff` y la lista de archivos nuevos con
   `git status --short`. Si no hay cambios, revisa el escenario tal como está y dilo.
2. Para cada hallazgo, clasifícalo:
   - **Aplicar.** Es parte del cambio y tiene que corregirse antes de aceptar.
   - **Descartar.** No aplica al cambio, o es una característica que ya existía en
     código que el cambio no tocó.
   - **Decidir.** Requiere una decisión humana que tú no puedes tomar.
3. Un problema que ya existía antes del cambio, en código que el cambio no tocó, va a
   **Descartar** con la nota «fuera del alcance del cambio», aunque sea un problema
   real.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No modifiques ningún archivo. Este paso revisa, no aplica.

# Salida esperada

| Archivo | Línea | Hallazgo | Clasificación | Justificación |
|---|---|---|---|---|

Al final, la recomendación: aceptar, aceptar con cambios o rechazar.
