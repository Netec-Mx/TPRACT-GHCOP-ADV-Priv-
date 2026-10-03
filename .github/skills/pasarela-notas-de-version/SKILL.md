---
name: pasarela-notas-de-version
description: 'Prepara una versión con versionado semántico: entrada del registro de cambios y notas de versión en lenguaje de negocio. Úsala cuando alguien pida versionar un cambio, escribir el changelog o las notas de una versión.'
---

# Versión, registro de cambios y notas de versión

La plantilla de notas está en [notas-de-version.md](../../../docs/proyecto/plantillas/notas-de-version.md)
y el registro de cambios en `CHANGELOG.md`, en la raíz del repositorio.

## Procedimiento

1. Lee el registro de cambios para conocer la versión vigente y el diff de lo que se libera
   desde la versión anterior, con sus decisiones y su descripción de pull request si existen.
2. Decide el número con versionado semántico: mayor si algo deja de funcionar como antes para
   quien lo usa, menor si se agrega una funcionalidad compatible, parche si solo se corrige.
   Un cambio que modifica montos que ya se cobraban se declara aunque sea una corrección.
   Explica el número que propones y espera la confirmación.
3. Agrega la entrada al registro de cambios, arriba, con las secciones «Agregado»,
   «Cambiado» y «Corregido» que correspondan.
4. Escribe las notas de versión con la plantilla. La sección de montos dice qué cambia, de
   cuánto a cuánto, para quién y por qué, sin nombres de clases ni términos técnicos.

## Límites

- No inventes cifras. Cada monto sale de una ejecución o de un documento del repositorio.
- No liberes nada: no creas etiquetas ni empujas. Eso lo decide una persona.
