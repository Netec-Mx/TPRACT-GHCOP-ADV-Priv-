---
name: 'Lineamientos de calidad para código nuevo o modificado con agentes'
description: 'Reglas que un agente de codificación debe seguir por defecto al escribir o tocar código de producción, para no introducir la clase de defectos que el equipo ya conoce'
applyTo: 'COMPLETAR: patrón glob del código de producción de tu equipo, por ejemplo src/**/*.java o src/**/*.cs'
---

# Lineamientos de calidad para código nuevo o modificado con agentes

Este documento no es una lista de defectos a corregir. Es una lista de reglas para no
**introducir** esos defectos cuando un agente escribe código nuevo o toca código existente.
Se construyó a partir de un catálogo de defectos plantados a propósito en un taller de
capacitación, usado para enseñar a doce desarrolladores senior a reconocerlos. La lección
que se generalizó es: si un agente puede plantar estos defectos sin que nadie lo pida
para enseñarlos, también puede introducirlos sin que nadie lo pida cuando nadie los está
enseñando.

## Reglas

- **Dinero en tipo decimal exacto.** Todo monto, tasa o cálculo financiero usa un tipo
  decimal exacto (`BigDecimal` en Java, `decimal` en .NET), nunca `double` ni `float`. Si
  el código que estás tocando ya usa `double` para dinero, no lo migres de paso: es un
  cambio de comportamiento (cambia el redondeo) que se hace aparte, con su propia
  verificación, no como efecto secundario de otra tarea.
- **Métodos cortos y con poco anidamiento.** Un método de cálculo nuevo no supera unas
  cuarenta líneas ni cuatro niveles de anidamiento. Si una tarea distinta te hace pasar por
  un método existente que ya excede esto, no lo extraigas de paso: proponer la extracción
  es una tarea aparte, con su propia revisión, porque tocar un método de cálculo grande sin
  una prueba de regresión previa es donde más fácil se cambia el comportamiento sin darse
  cuenta.
- **Sin números mágicos nuevos.** Un valor numérico con significado de negocio (un tope,
  un porcentaje, un umbral de fecha) se declara como constante con nombre, en el nuevo
  código que escribas. No es licencia para tocar los números mágicos que ya existen en
  código que la tarea no nombra.
- **Fecha y hora con la API moderna del lenguaje.** Código nuevo usa `java.time` o
  `System.DateTime`/`DateOnly`/`TimeOnly` según corresponda, nunca las API antiguas
  (`Date`, `Calendar`). No migres el código existente de paso.
- **Sin bloques `catch` vacíos.** Todo `catch` nuevo registra el error o lo relanza. Si
  encuentras un `catch` vacío existente fuera del alcance de tu tarea, repórtalo; no lo
  llenes de paso.
- **Sin duplicar lógica de negocio.** Si vas a escribir una regla que ya existe en otro
  lugar del código, señálalo y pregunta si conviene reutilizarla en vez de duplicarla, en
  lugar de copiarla con una variación sutil.
- **Nombres que describen una sola responsabilidad.** Un método nuevo que consulta no
  muta, y uno que muta lo dice en el nombre. No le pongas a un método nuevo un nombre que
  describa solo una parte de lo que hace.
- **Pruebas de la lógica de negocio, no solo de getters y formato.** Si la tarea pide
  agregar pruebas, prioriza los casos de la regla de negocio (bordes de tramo, de cuotas,
  de periodo) sobre pruebas triviales de estructura.

## Qué no se hace nunca

- No apliques estas reglas retroactivamente a código que la tarea no nombra. Este
  documento gobierna lo que un agente **escribe nuevo o modifica a propósito**, no una
  licencia para limpiar el resto del archivo.
- No silencies un hallazgo de una herramienta de análisis estático con una supresión o
  anotación como forma de cumplir estas reglas. Si el hallazgo es real, se corrige el
  código; si es un defecto conocido y aceptado fuera de alcance, se reporta y se deja.

## Ejemplo

Un método nuevo que calcula un recargo por cuotas: recibe el monto como `BigDecimal`, el
número de cuotas como `int`, declara el porcentaje de recargo y su tope como constantes
con nombre, no anida más de tres niveles y su nombre (`calcularRecargoPorCuotas`) describe
exactamente lo que hace y nada más.

<!--
Origen: destilado de AGENTS.md y de la sección "Lo que vas a encontrar y no debes
arreglar" del repositorio del taller de GitHub Copilot (Pasarela Andina). Esa sección
describe defectos plantados a propósito para que los participantes los reconozcan y NO se
corrigen en el escenario. Este archivo toma el mismo catálogo y lo invierte: en un
repositorio real, sin ejercicio detrás, esas reglas se aplican hacia adelante en código
nuevo, no hacia atrás sobre lo que ya existe. Ajusta `applyTo` al patrón de tu proyecto
antes de instalarlo.
-->
