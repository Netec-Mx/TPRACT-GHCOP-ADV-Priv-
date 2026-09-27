---
name: lab-5-3-paso-2-documentar-estrategia
description: 'Lab 5.3 paso 2. Documenta en Markdown la estrategia de pruebas de la lógica de negocio del escenario.'
argument-hint: 'java o dotnet'
disable-model-invocation: true
---

# Objetivo

Documentar la estrategia de pruebas de la lógica de negocio, para que el equipo sepa
qué está cubierto, qué no y en qué orden conviene cubrirlo.

El participante indica su escenario al invocar este paso, con `java` o `dotnet`. Si no lo
indicó, pregúntale cuál usa y no hagas nada más hasta que responda.

- Reglas: [escenario/README.md](../../../escenario/README.md)
- Pruebas existentes: `escenario/java/src/test/` o `escenario/dotnet/LiquidacionComercios.Pruebas/`

# Qué hacer

Crea `labs/cap5/lab-5-3-pruebas-y-revision/entregables/estrategia-de-pruebas.md` con:

1. **Qué cubren hoy las pruebas.** Clase por clase, según lo que existe en el
   repositorio, incluidas las que haya creado el paso 1 si existen.
2. **Qué reglas de negocio no tienen ninguna prueba.** Regla por regla.
3. **Casos de borde que importan.** Para cada regla sin cubrir, los valores exactos que
   una prueba tendría que usar, incluidos los bordes de tramo, de cuotas y de periodo.
4. **Qué reveló el paso 1.** Si el paso 1 encontró una discrepancia, descríbela y
   explica qué decisión de negocio hace falta. Si no hay pruebas del paso 1, dilo.
5. **Orden recomendado.** Qué cubrir primero, según el riesgo para el dinero del
   comercio.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Crea un solo archivo. No escribas pruebas en este paso ni modifiques código.

# Salida esperada

El documento creado, de no más de dos páginas.
