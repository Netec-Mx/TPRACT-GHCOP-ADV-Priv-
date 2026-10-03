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

## SPEC-011. Guía del relator, demostraciones y material del participante

1 de octubre de 2026, con la enmienda B del mismo día.

- `01-guia-del-relator.md` completa, con el plan minuto a minuto de las cuatro sesiones,
  la conducción de laboratorios, las trampas y las preguntas difíciles. El `README.md`
  incorpora la tabla de subtemas del temario contratado.
- Nueve demostraciones en `demos/`, salidas grabadas en `respaldos/` y el bloque G del
  protocolo de la máquina virtual.
- `GUIA-DE-INICIO.md` y `DESPUES-DEL-TALLER.md` para la raíz del repositorio de
  participantes.
- Las demostraciones 1.3 y 2.2 quedaron sin ejecutar por el control de permisos del entorno
  de verificación. SPEC-011-B las ejecutó con autorización dentro de la imagen de gates.
- SPEC-011-B corrigió ocho inconsistencias. El 5.4 no se reinicia sin escribir `descartar`.
  El comercio suspendido no se liquida, como decisión de las notas del 1.5. La regla 8
  clasificada distinto quedó como HALLAZGO-07. `entrega_spec24.zip` quedó en `.gitignore`,
  sin borrarlo.

## SPEC-012. Material de teoría

2 de octubre de 2026.

- `docs/relator/teoria/` con índice y un documento por subtema de teoría, de 1.1 a 4.3, más
  el encuadre del capítulo 5. Seis partes por documento y extensión de una página de 500
  palabras por cada diez minutos.
- Toda afirmación técnica con fuente oficial, URL y fecha. Las fuentes del capítulo 1 se
  volvieron a consultar para que todo quede con la misma fecha.
- `10-mantenimiento.md` registra una ruta de cobro que daba 404 como ejemplo de por qué las
  fuentes se revisan antes de cada dictado.
- Inconsistencias reportadas y no corregidas: la skill del paso 3 del 4.4 hablaba de
  importar Markdown en Confluence, cosa que la importación nativa no hace. También se
  reportó que nada confirmaba el efecto de `readOnlyHint` que cita la demostración 3.2. Fue
  un error del informe: la guía de MCP para extensiones de Visual Studio Code lo confirma.
  SPEC-015 lo verificó y precisó el pasaje.

## SPEC-013. Paquete de entrega

Pendiente. Por decisión del Product Owner va después de SPEC-016, reducido al paquete de
entrega del relator.

## SPEC-014. Arquitectura de referencia, gobierno de la IA y ciclo de vida

3 de octubre de 2026.

- `docs/arquitectura/bian-mapeo.md` con los dominios de servicio BIAN 14.0.0 Merchant
  Relations, Merchant Acquiring Facility, Card Transaction Capture y Card Case, tomados de
  las Semantic APIs publicadas bajo Apache-2.0. Instrucción BIAN con alcance solo sobre
  `docs/arquitectura/**`, para no cambiar los laboratorios verificados.
- `docs/arquitectura/decisiones/` con plantilla y tres decisiones. El formato es el de
  Nygard con agregados de MADR, como complemento de TOGAF. El texto oficial de TOGAF exige
  registro y se verificó por lo que exponen sus páginas oficiales.
- Política de uso de IA de Pasarela Andina con ocho reglas, guía de uso responsable de
  tokens y plantilla de runbook. Las reglas que dependen de instrucciones quedaron en la
  sección «Gobierno» de las instrucciones generales.
- Tarea E del 2.4, paso 4 opcional del 4.4, apertura del 1.1, las once fases del ciclo de
  vida en el 1.3 y la guía del relator con el nuevo marco.
- Los laboratorios 1.5, 2.4, 3.4 y 4.4 se volvieron a ejecutar como agente. Ninguna regla de
  gobierno produjo regresiones. El capítulo 5 queda para verificar en SPEC-016.
- Hallazgo no planificado: el ejemplo de `escenario/README.md`, línea 69, carga cero
  comercios.

## SPEC-015. Funcionalidad nueva y pipeline

3 de octubre de 2026, con la enmienda SPEC-015-A.

### Medición de la construcción con agente

La solución de referencia y la mantención correctiva se construyeron con un agente, un stack
después del otro, sobre una copia del punto de partida. El agente no es Copilot: es el mismo
tipo de agente de las verificaciones anteriores, con compilación y pruebas dentro de la imagen
de gates. «Comandos» cuenta los comandos de terminal, que en Visual Studio Code pedirían
aprobación uno por uno. «Correcciones» cuenta las veces que el agente tuvo que rehacer algo
porque una verificación falló.

| Trabajo | Stack | Segundos de agente | Comandos | Correcciones | Resultado |
|---|---|---|---|---|---|
| Reporte, funcionalidad nueva | Java | 184 | 9 | 2, en la prueba de formato | 3 clases, 8 pruebas, salida del reporte esperada |
| Reporte, funcionalidad nueva | .NET | 126 | 7 | 1, en las rutas de salida | 3 clases, 8 pruebas, idéntico byte a byte a Java |
| Mantención correctiva | Java | 64 | 7 | 1, en el filtro de verificación | Un archivo, concilia en los tres periodos |
| Mantención correctiva | .NET | 80 | 8 | 3, en los comandos de verificación | Un archivo, idéntico a Java, concilia |

El segundo stack tardó menos en los dos trabajos porque tuvo el primero como referencia.
Ninguna corrección fue en el código de producción. Todas fueron en pruebas o en comandos de
verificación.
