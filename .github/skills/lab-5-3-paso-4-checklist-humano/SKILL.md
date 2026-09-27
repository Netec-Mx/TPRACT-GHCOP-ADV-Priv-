---
name: lab-5-3-paso-4-checklist-humano
description: 'Lab 5.3 paso 4. Produce el checklist de revisión humana que el equipo se lleva, con lo que un agente no puede decidir.'
disable-model-invocation: true
---

# Objetivo

Producir el checklist que un revisor humano del equipo aplica a un pull request hecho
con ayuda de un agente, con foco en lo que el agente no puede decidir solo.

# Qué hacer

Crea `labs/cap5/lab-5-3-pruebas-y-revision/entregables/checklist-de-revision.md` con
entre diez y quince puntos, agrupados en:

1. **Alcance.** El cambio hace lo pedido y nada más.
2. **Comportamiento.** Cómo se comprueba que la salida no cambió cuando no debía.
3. **Pruebas.** Si las pruebas documentan el comportamiento actual o el deseado, y
   quién decidió cuál.
4. **Decisiones de negocio.** Qué discrepancias con las reglas quedan abiertas y quién
   las resuelve.
5. **Lo que el agente no ve.** Contexto del equipo, del cliente o de producción que no
   está en el repositorio.

Cada punto se responde con sí o no, y dice cómo se verifica.

Si existe `labs/cap5/lab-5-1-preparacion/entregables/criterios-de-evaluacion.md`,
incorpora los criterios que apliquen.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Crea un solo archivo. No modifiques código.

# Salida esperada

El checklist creado.
