# Laboratorio 5.3. Estrategia de pruebas, documentación Markdown y checklist de revisión

## Objetivo del laboratorio

Probar el reporte contra sus criterios de aceptación, agregar al pipeline la comprobación
central de la historia, corregir lo que el pipeline encuentre entendiendo cada causa, y dejar
el cambio revisado y documentado para integrarse. Son las fases de Pruebas, Integración
continua, Mantención correctiva, Revisión de código y Seguridad de
[`CICLO-DE-VIDA.md`](../../../CICLO-DE-VIDA.md).

## Duración

45 minutos.

## Prerrequisitos

- Los laboratorios 5.1 y 5.2 terminados y confirmados en tu rama. Este laboratorio usa los
  criterios de aceptación del 5.1 y el reporte del 5.2.
- Todos los pasos se hacen en modo **Agent**.
- No hagas commit hasta el paso 4. La revisión de Copilot revisa los cambios sin confirmar.

## Pasos

| Paso | Qué escribir en el chat | Qué observar | Tiempo |
|---|---|---|---|
| 1 | `/lab-5-3-paso-1-probar-criterios java` | En las pruebas que muestra el agente, que usen el valor exacto de cada criterio. Qué criterios quedan cubiertos y cuáles fallan | 8 min |
| 2 | `/lab-5-3-paso-2-conciliacion-en-pipeline` | En el diff que muestra el agente, cómo agrega el paso nuevo al script y al workflow. En qué periodos queda en rojo | 8 min |
| 3 | `/lab-5-3-paso-3-diagnosticar-y-corregir java` | Si separa todas las causas hasta que sumen la diferencia completa. Cuando te pida una decisión de negocio, llévasela al relator. En el diff que muestra al final, que la corrección sea mínima y que solo cambie el hash de junio | 15 min |
| 4 | `/lab-5-3-paso-4-revision-y-pull-request` | Qué comenta la revisión de Copilot y, en la descripción del pull request que muestra el agente, qué casillas de la lista de comprobación quedan sin marcar | 8 min |
| 5, opcional | `/lab-5-3-paso-5-opcional-github` | Solo si tienes una copia del repositorio en GitHub. Nada depende de este paso | Fuera de los 45 min |

Reemplaza `java` por `dotnet` si trabajas con .NET.

Antes del paso 4, pide la revisión de Copilot: en la vista **Source Control** (menú
**View**, **Source Control**), pasa el puntero sobre **CHANGES** y haz clic en **Copilot
Code Review - Uncommitted Changes**. Los comentarios aparecen en los archivos y en la pestaña
**Problems**.

El pipeline que corres es el mismo que corre en GitHub:

```bash
bash scripts/integracion-local.sh
```

## Resultado esperado

- Pruebas nuevas del reporte, una por criterio comprobable.
- El paso `conciliacion` en `scripts/integracion-local.sh` y en el workflow.
- La corrección en tu stack y el hash esperado del periodo que cambió, con su causa.
- El pipeline local en verde.
- `docs/proyecto/pull-request.md` y una decisión nueva en `docs/arquitectura/decisiones/`.
- Un commit en tu rama con todo lo anterior.

## Criterios de revisión

- [ ] Ninguna prueba ni hash esperado se cambió para que algo pase sin una causa explicada.
- [ ] El diagnóstico separa las causas y su suma da la diferencia completa, al centavo.
- [ ] La regla que el README no decidía se consultó al negocio y quedó registrada.
- [ ] La descripción del pull request justifica cada hash esperado que cambió.
- [ ] La lista de comprobación tiene marcadas solo las casillas que se cumplen.
