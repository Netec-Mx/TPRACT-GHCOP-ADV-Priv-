segundos: 6

# Demo 2.1 - Jerarquia de personalizacion y skills

## Paso 1 - Mostrar .github/ en el explorador
Texto escrito: (ninguno, solo explorador)
Referencias: ninguna.
Salida observada (`ls -a .github`): agents, copilot-instructions.md, hooks, instructions, skills.
- agents/: analista, documentador, refactorizador, revisor, tester (.agent.md)
- hooks/: proteger-datos-escenario.js y .json
- instructions/: arquitectura-bian.instructions.md, dotnet.instructions.md, java.instructions.md
- skills/: 44 carpetas (37 de laboratorio lab-*, 7 de dominio pasarela-*: analizar-incidente, estimar, historia-de-usuario, notas-de-version, registrar-decision, reglas-de-negocio y verificar-equivalencia). Contadas con `ls -d .github/skills/*/ | wc -l` y `ls -d .github/skills/lab-*/ | wc -l`.

## Paso 2 - Chat nuevo (Ask)
Texto escrito:
```
¿En qué idioma tengo que escribir los mensajes de commit en este repositorio?
```
Referencias: AGENTS.md, .github/copilot-instructions.md

Respuesta:
> En español neutro. Las instrucciones del repositorio indican que los comentarios, los mensajes de commit y la documentación van en español (`.github/copilot-instructions.md`, sección «Idioma»). `AGENTS.md` dice lo mismo: todo el contenido va en español neutro.

## Paso 3 - Abrir .github/skills/pasarela-reglas-de-negocio/SKILL.md
Texto escrito: (ninguno)
Contenido mostrado: encabezado con `name: pasarela-reglas-de-negocio` y
`description: 'Reglas de negocio de Pasarela Andina y formato de sus archivos de datos. Úsala cuando haya que calcular a mano la comisión o la liquidación de un comercio, contrastar el código con las reglas o interpretar una línea de los archivos de datos.'`
Cuerpo con enlaces a escenario/README.md, comercios.txt, planes.txt y contracargos.txt, y secciones "Cómo calcular a mano la comisión", "...la liquidación", "Formato de los archivos de datos", "Límites".
Referencias: ninguna.

## Paso 4 - Agent, chat nuevo
Texto escrito:
```
/pasarela-reglas-de-negocio ¿qué tramo y qué porcentaje le corresponden a una venta de 750 soles del comercio CM0001?
```
Referencias: .github/skills/pasarela-reglas-de-negocio/SKILL.md, escenario/README.md, escenario/datos/comercios.txt, escenario/datos/planes.txt, AGENTS.md, .github/copilot-instructions.md

Herramientas usadas por el agente: lectura de README.md, comercios.txt (grep CM0001), planes.txt.

Respuesta:
> **Comercio.** CM0001 es Consorcio Barranco S.A.C. (RESTAURANTE, ACTIVO) y tiene el plan **PL01 (Basico)**.
>
> **Plan PL01.** Monto fijo por transacción 0.30, tope mensual 8000.00, tramos `0:500:3.5 | 500:2000:2.9 | 2000:10000:2.5 | 10000:999999:2.1`.
>
> **Tramo.** 750 cae en el tramo **500 a 2000**, con porcentaje **2.9 %**.
>
> Según las reglas 1 y 2 de `escenario/README.md`, los tramos no son acumulativos: el porcentaje se aplica al monto completo.
> - 750 × 2.9 % = 21.75
> - Más el monto fijo 0.30 = **22.05 soles** de comisión base.
>
> Esto supone una venta al contado y no anulada. Si fuera en cuotas habría que sumar el recargo de la regla 3 (0,5 % por cada cuota sobre la primera, máximo 3 %), y si estuviera anulada no habría comisión (regla 4). El enunciado no lo indica.

## Paso 5 - Skill de laboratorio
Texto escrito: (ninguno)
Contenido mostrado de .github/skills/lab-1-4-paso-1-prompt-vago/SKILL.md: encabezado con `name`, `description` y la línea `disable-model-invocation: true`; cuerpo "Pedido: Mejora este código" con enlaces a CalculadoraLiquidacion.java/.cs y restricciones.
Verificación: `grep -L "disable-model-invocation: true"` sobre todas las skills solo devuelve las siete de dominio, es decir las 37 de laboratorio la tienen.

## Paso 6 - Narrativa
Sin acción en el chat.

## Esperado contra observado
| Paso | Resultado | Nota |
|---|---|---|
| 1 | Coincide | |
| 2 | Coincide | copilot-instructions.md figura en referencias (junto con AGENTS.md). |
| 3 | Coincide | |
| 4 | Coincide | Plan PL01, tramo 500-2000, 2.9 %, leído de los datos. |
| 5 | Coincide | |
| 6 | Coincide | Hoy hay 37 skills de laboratorio. Los «treinta y cinco pasos» del guion son los que se rehicieron en la migración, una cifra de ese momento. |
