---
name: lab-4-4-paso-2-documentar-decisiones
description: 'Lab 4.4 paso 2. Registra una decisión técnica del escenario que todavía no está documentada, derivada del código, con el formato de decisiones del repositorio.'
disable-model-invocation: true
---

# Objetivo

Registrar una decisión técnica real del escenario que el repositorio todavía no tiene
documentada, en el formato que usa el equipo para dejar constancia de por qué el código es
como es.

La decisión es esta: **el escenario no usa frameworks ni dependencias de ejecución, solo
dependencias de prueba.**

Material de partida:

- [pom.xml](../../../escenario/java/pom.xml)
- [LiquidacionComercios.csproj](../../../escenario/dotnet/LiquidacionComercios/LiquidacionComercios.csproj)
- [LiquidacionComercios.Pruebas.csproj](../../../escenario/dotnet/LiquidacionComercios.Pruebas/LiquidacionComercios.Pruebas.csproj)
- [escenario/README.md](../../../escenario/README.md)
- [La plantilla de decisiones](../../../docs/arquitectura/decisiones/plantilla.md) y su
  [índice](../../../docs/arquitectura/decisiones/README.md)

# Qué hacer

1. Lee el índice de `docs/arquitectura/decisiones/` y confirma que ninguna de las decisiones
   registradas trata esta. Si alguna la cubre, dilo y termina.
2. Lee el material de partida y establece, citando archivo y línea, qué dependencias tiene
   cada proyecto y de qué tipo son.
3. Crea `labs/cap4/lab-4-4-documentacion/entregables/decisiones.md` con una sola decisión,
   siguiendo la plantilla: contexto, alternativas consideradas, decisión, consecuencias y
   verificación.
4. En el contexto y en las consecuencias, separa lo que se respalda con el código de lo que
   es una suposición sobre el porqué. Las suposiciones van marcadas como «pendiente de
   confirmar con el equipo».

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- Crea un solo archivo. No modifiques código ni `docs/arquitectura/decisiones/`.
- No uses la skill `pasarela-registrar-decision`: este paso escribe en `entregables/`.
- Solo afirmaciones que se puedan respaldar con el código o marcadas como pendientes.

# Salida esperada

El documento creado, mostrado completo en el chat, no un resumen, y en tu respuesta qué
afirmaciones quedaron como pendientes de confirmar.

Escribe ese contenido en el texto de tu respuesta, como Markdown o en un bloque de código.
No basta con ejecutar `cat` o `git diff` en la terminal ni con decir que ya se ve en la
vista de una herramienta: el participante lo tiene que poder leer en tu respuesta.
Aunque la herramienta que creó o editó el archivo ya muestre su contenido, cópialo igual en
tu respuesta. No escribas «mostrado arriba», «contenido completo:» ni un encabezado sin el
contenido debajo.
