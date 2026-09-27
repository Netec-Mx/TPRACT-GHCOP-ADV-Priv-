---
name: pasarela-verificar-equivalencia
description: 'Verifica que los escenarios Java y .NET de Pasarela Andina sigan produciendo la misma salida. Úsala después de modificar código en escenario/ que no debería cambiar el comportamiento, o cuando alguien pregunte si un cambio rompió la equivalencia.'
---

# Verificar la equivalencia entre escenarios

Los dos escenarios leen los mismos datos y deben producir exactamente la misma salida.
El script [comparar-escenarios.sh](../../../scripts/comparar-escenarios.sh) lo comprueba.

## Procedimiento

1. Desde la raíz del repositorio, en la terminal:

   ```bash
   bash scripts/comparar-escenarios.sh
   ```

2. Interpreta el código de salida:
   - `0`, las salidas son idénticas. El cambio no alteró el comportamiento.
   - `1`, las salidas difieren. El script muestra las primeras líneas distintas.
   - `2`, algo impidió comparar, casi siempre un error de compilación. El script indica
     qué registro revisar.
3. Si difieren, identifica qué comercio y qué monto cambió, y relaciónalo con el último
   cambio hecho. No cambies nada para que vuelvan a coincidir sin explicar primero por qué
   dejaron de hacerlo.

## Otros periodos

Los datos cubren 2026-04, 2026-05 y 2026-06. Para comparar otro periodo:

```bash
bash scripts/comparar-escenarios.sh --periodo 2026-05
```

## Límites

- El script solo compara. No corrige ni revierte nada.
- Una diferencia no dice cuál de los dos escenarios está mal. Eso se decide con las reglas
  de `escenario/README.md`.
