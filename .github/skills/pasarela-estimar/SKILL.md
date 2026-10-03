---
name: pasarela-estimar
description: 'Estima una funcionalidad nueva, una mantención correctiva o una evolutiva, por fase del ciclo de vida, con y sin IA, separando el tiempo de la persona del tiempo del agente. Úsala cuando alguien pida estimar costo o tiempo de un cambio.'
---

# Estimación por fase, con y sin IA

La plantilla está en [estimacion.md](../../../docs/proyecto/plantillas/estimacion.md) y las
fases en [CICLO-DE-VIDA.md](../../../CICLO-DE-VIDA.md).

## Procedimiento

1. Lee lo que se estima: la historia, la solicitud o la descripción del cambio. Si no está
   claro qué tipo de trabajo es, nueva, correctiva o evolutiva, pregúntalo.
2. Recorre las fases de la plantilla. Para cada una estima, en minutos, cuánto tomaría a una
   persona sin IA, cuánto le toma a la persona con IA y cuánto trabaja el agente. Los
   minutos de la persona incluyen leer, decidir y revisar lo que el agente produce.
3. Créditos de IA y minutos de integración continua como cantidades estimadas. Sin precios
   ni valores de ningún plan: quedan como campos a completar con los del plan vigente.
4. Escribe en cada fase el supuesto principal. Una estimación sin supuestos no se puede
   comparar después con lo real.
5. Si hay datos reales de trabajos parecidos en el repositorio, úsalos y cítalos. Si no
   los hay, dilo.
6. Al terminar, muestra en el chat el contenido completo de la estimación, no un resumen.

## Límites

- No presentes una estimación como un compromiso. Es un rango razonado.
- No inventes datos de productividad. Lo que no tenga respaldo va como supuesto.
