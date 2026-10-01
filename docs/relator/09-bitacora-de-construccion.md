# Bitácora de construcción

Una entrada por spec, de SPEC-001 a SPEC-010, con sus enmiendas. Explica por qué el
repositorio es como es. El detalle técnico de cada problema está en
[`03-hallazgos.md`](03-hallazgos.md) y el historial completo en git.

## SPEC-001. Estructura y verificador de ambiente

11 al 19 de septiembre de 2026, con las enmiendas A, B y C.

- Estructura del repositorio, `AGENTS.md` con la regla de no corregir defectos y
  `docs/00-setup-ambiente.md` con la especificación de la máquina virtual.
- El verificador nació en Bash y PowerShell. SPEC-001-B dejó un solo script en Git Bash y
  eliminó PowerShell del proyecto. El gate de conectividad en PowerShell aprobaba dominios
  inexistentes (HALLAZGO-01).
- `.gitattributes` fuerza LF, porque un script con CRLF falla en Git Bash sin decir por qué.
- SPEC-001-C rehízo la comprobación de Copilot. Desde Visual Studio Code 1.116 viene
  integrado y no se instala, y el verificador reprobaba todo ambiente (HALLAZGO-05).

## SPEC-002. Escenario Java

11 de septiembre de 2026, con la enmienda A.

- Pasarela Andina en Java 21, sin frameworks, con nueve reglas de negocio y diez defectos
  plantados catalogados en `04-defectos-plantados.md`.
- Datos con semilla fija 20260911. TX002035 a TX002037 se agregaron a mano para que el
  error de punto flotante sobreviva al redondeo. Sin ellas, el defecto principal no se ve.
- SPEC-002-A registró que un escáner de seguridad no pedido denunció dos defectos plantados
  (HALLAZGO-02). De ahí sale el caso de clase 01 y la advertencia de `AGENTS.md`.

## SPEC-003. Escenario .NET y equivalencia

11 y 12 de septiembre de 2026, con las enmiendas A y B.

- Escenario gemelo en .NET, equivalente byte a byte, y `comparar-escenarios.sh`.
- Java y .NET no redondean ni formatean igual. `CompatibilidadJava.cs` replica a Java a
  propósito (HALLAZGO-03).
- SPEC-003-A fijó la configuración regional en Java, porque el idioma de la máquina
  cambiaba separador, dígitos y hasta el calendario (HALLAZGO-04).
- SPEC-003-B hizo que el comparador ignore el aviso que la JVM escribe cuando está
  definida `JAVA_TOOL_OPTIONS`, y preparó el caso de clase 02 sobre configuración regional.

## SPEC-004. Diseño de laboratorios

12 de septiembre de 2026, con la enmienda A.

- Descompuso los nueve laboratorios en pasos invocables, independientes entre sí, en
  `05-diseno-de-laboratorios.md`.
- SPEC-004-A escribió dos prompt files de calibración. Después se supo que los prompt files
  estaban en retiro y SPEC-009 los migró a skills (HALLAZGO-06).

## SPEC-005. Activos de referencia

No se ejecutó por separado. Absorbido por SPEC-009, fase 2.

## SPEC-006. Servidor MCP local

No se ejecutó por separado. Absorbido por SPEC-009, fase 3.

## SPEC-007. Guía general del relator

Pendiente. `01-guia-del-relator.md` sigue siendo un índice.

## SPEC-008. Realineación al temario contratado

27 de septiembre de 2026.

- El repositorio se había armado sobre un temario corregido con seis capítulos. Se alineó
  al contratado por Netec, con cinco capítulos y 810 minutos.
- El laboratorio 2.5 pasó a 2.4 y a 45 minutos. El 3.4 subió a 45 con documentación del
  caso de uso. El 5.3 incorporó documentación Markdown y el 5.4 el entregable de medición.
- Se verificaron los comandos del chat vigentes. `/workspace` y `/analyze` no existen.
- El hallazgo que cambió todo lo siguiente fue que los prompt files estaban en retiro.

## SPEC-009. Construcción de los nueve laboratorios

27 de septiembre de 2026.

- Dos repositorios. El de participantes se genera con lista de inclusión y gate de fugas.
  Con autorización, se quitaron del escenario tres comentarios que citaban el catálogo.
- Cinco agentes, instrucciones por ruta, dos skills del dominio y 35 skills de laboratorio
  con `disable-model-invocation: true`, validadas por `validar-skills.sh`.
- Servidor MCP de solo lectura, con permisos de Node y una nota con inyección indirecta.
- `reiniciar-lab.sh`, READMEs, notas del relator, soluciones verificadas y protocolo de
  prueba en la máquina virtual.
- Las skills se ejecutaron como agente. Tres se reformularon por lo observado.

## SPEC-010. Cierre de SPEC-009

30 de septiembre de 2026, con la enmienda A del 1 de octubre.

- Decisiones del Product Owner. `RoSilva26` con escritura y ruleset. En los bordes, el
  monto pertenece al tramo inferior, solo en las notas del relator. El monto negativo
  queda como comportamiento no planificado. La fecha del contracargo es la de aprobación.
- Hook `PreToolUse` que impide al agente modificar `escenario/datos/`.
- Escenario .NET a `net10.0`, con checksums idénticos. Verificación de compilación sin red.
- Protocolo de prueba reescrito solo con mouse y con casillas.
- SPEC-010-A versionó la imagen de gates, `scripts/gates.sh`, este documento, el contexto
  del proyecto y la guía de mantenimiento.
