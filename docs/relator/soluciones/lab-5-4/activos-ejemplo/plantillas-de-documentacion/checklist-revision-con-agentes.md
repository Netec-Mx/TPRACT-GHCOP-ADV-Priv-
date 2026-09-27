---
título: Checklist de revisión humana para cambios hechos con ayuda de un agente
uso: |
  Copia este archivo a tu repositorio (por ejemplo a docs/ o a la plantilla de
  pull request) y complétalo cambio por cambio. No reemplaza la revisión de código
  normal: es la parte adicional que un cambio hecho con un agente necesita, porque un
  agente no ve todo lo que un revisor humano del equipo sí ve.
---

# Checklist de revisión humana para cambios hechos con ayuda de un agente

Cada punto se responde con sí o no, y dice cómo se verificó. Un "no sé" no cuenta como
"sí".

## 1. Alcance

- [ ] El cambio hace exactamente lo que pidió la tarea o el ticket, y nada más.
- [ ] Todo archivo tocado que la tarea no nombra tiene una explicación explícita en la
      descripción del cambio.
- [ ] Ninguna corrección "de paso" se coló en el diff (formato, renombrado, limpieza) sin
      que se haya pedido.

## 2. Comportamiento

- [ ] Existe evidencia de que la salida no cambió cuando el cambio no debía alterar el
      comportamiento (pruebas, comparación de snapshots, salida antes/después).
- [ ] Si el cambio sí debía alterar el comportamiento, la diferencia esperada está descrita
      y se verificó que es exactamente esa y ninguna otra.

## 3. Pruebas

- [ ] Las pruebas nuevas o modificadas dicen, en su nombre o su comentario, si documentan
      el comportamiento **actual** del código o el comportamiento **deseado** según una
      especificación.
- [ ] Si documentan el comportamiento actual y este no coincide con lo deseado, hay una
      persona identificada que va a decidir cuál de los dos gana.
- [ ] Las pruebas cubren los bordes que importan para el dinero, la fecha o la regla de
      negocio en juego, no solo getters, setters o formato de entrada.

## 4. Decisiones de negocio

- [ ] Toda discrepancia entre el código y la especificación de negocio que el agente haya
      encontrado está listada, con la regla citada, no silenciada ni resuelta por el
      agente.
- [ ] Cada discrepancia tiene un dueño humano asignado para resolverla.

## 5. Lo que el agente no ve

- [ ] Contexto del cliente, del incidente anterior o de una decisión de producto que no
      está en el repositorio, y que podría contradecir lo que el agente decidió.
- [ ] Estado real de producción (datos, volumen, quién más consume esta función) que el
      repositorio no refleja.
- [ ] Cualquier instrucción o comentario que el agente pudo haber leído dentro del propio
      código o de datos externos y haber tratado, por error, como una instrucción en vez
      de como contenido a documentar u observar.

<!--
Origen: generalización de
.github/skills/lab-5-3-paso-4-checklist-humano/SKILL.md del taller de GitHub Copilot,
que producía este mismo checklist para el escenario Pasarela Andina. Las cinco secciones
se mantienen porque no dependen del dominio: alcance, comportamiento, pruebas, decisiones
de negocio y lo que el agente no puede ver son la misma lista en cualquier repositorio.
-->
