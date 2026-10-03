---
name: 'Arquitectura BIAN'
description: 'Vocabulario de dominios de servicio BIAN para diseñar o documentar la arquitectura de Pasarela Andina'
applyTo: 'docs/arquitectura/**'
---

# Arquitectura con vocabulario BIAN

Estas reglas aplican a los documentos de arquitectura. No aplican al código del escenario.

## Vocabulario

- Al explicar, diseñar o documentar la arquitectura de Pasarela Andina, nombra cada
  responsabilidad por su dominio de servicio BIAN, según
  [`docs/arquitectura/bian-mapeo.md`](../../docs/arquitectura/bian-mapeo.md).
- Usa los nombres de los dominios en inglés, tal como aparecen en el mapeo. No los
  traduzcas ni inventes nombres que no estén en él.
- Si una responsabilidad no figura en el mapeo, dilo y sugiere revisar el panorama de
  servicios de BIAN. No le asignes un dominio por tu cuenta.

## Límites de responsabilidad

- Cuando un diseño mueva una responsabilidad de un componente a otro, di de qué dominio
  sale y a qué dominio llega.
- Si un componente reúne responsabilidades de varios dominios, descríbelo de forma neutral,
  como lo hace el mapeo.

## Alcance

- Esta instrucción no pide cambiar código. Las reglas de `.github/copilot-instructions.md`
  siguen aplicando.
- No copies descripciones de los dominios desde las fuentes de BIAN. Enlaza al mapeo.
