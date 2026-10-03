# Decisiones de arquitectura

Este directorio registra las decisiones de arquitectura de Pasarela Andina, una por
archivo, numeradas en orden.

| Número | Decisión | Estado |
|---|---|---|
| [0001](0001-dos-implementaciones-con-salida-identica.md) | Implementar el escenario en Java y en .NET con salida idéntica | Aceptada |
| [0002](0002-servidor-mcp-local-de-solo-lectura.md) | Usar un servidor MCP local, de solo lectura y sin red | Aceptada |
| [0003](0003-hook-de-proteccion-de-datos.md) | Proteger los datos del escenario con un hook | Aceptada |

Para registrar una decisión nueva, copie [`plantilla.md`](plantilla.md) con el número
siguiente, o pídaselo al agente: la skill `pasarela-registrar-decision` la redacta a partir
del contexto que usted le entregue.

## Relación con TOGAF

El estándar TOGAF de The Open Group describe, dentro del repositorio de arquitectura, un
registro de gobierno que incluye un registro de decisiones: el lugar donde se conservan las
decisiones de arquitectura significativas de la organización, como selecciones de
producto, justificaciones de diseño y desviaciones de estándares. TOGAF no fija, en el
material consultado, un formato con campos para cada decisión individual.

El formato de este directorio no es parte de TOGAF. Es el registro de decisiones de
arquitectura propuesto por Michael Nygard en 2011, con contexto, decisión, estado y
consecuencias, al que se agregan las alternativas consideradas y la verificación del
formato MADR. Se usa como complemento de las prácticas de TOGAF: cada archivo de este
directorio sería una entrada de su registro de decisiones.

TOGAF es una marca registrada de The Open Group. Este material lo referencia y no
reproduce su contenido.

## Fuentes

| Qué | Fuente | Consultada |
|---|---|---|
| Registro de gobierno y registro de decisiones en el repositorio de arquitectura de TOGAF | https://pubs.opengroup.org/architecture/togaf9-doc/arch/chap37.html | 3 de octubre de 2026 |
| Edición vigente del estándar TOGAF | https://www.opengroup.org/togaf | 3 de octubre de 2026 |
| Formato de registro de decisiones de arquitectura | https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions | 3 de octubre de 2026 |
| Alternativas consideradas y verificación, MADR 4.0.0, licencia MIT o CC0 | https://adr.github.io/madr/ | 3 de octubre de 2026 |
