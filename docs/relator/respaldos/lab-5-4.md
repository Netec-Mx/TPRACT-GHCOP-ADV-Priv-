> Los tiempos de este respaldo son de reloj del agente de verificación y no incluyen la
> lectura de la sala.

# Lab 5.4 - Laboratorio final de activos reutilizables (Java)

Reinicio previo: `bash scripts/reiniciar-lab.sh lab-5-4 --si`. Salida real:

```

== Punto de partida de lab-5-4 ==
  Referencia: punto-de-partida
  Rutas: escenario labs/cap5/lab-5-4-laboratorio-final/entregables

== Esto se va a perder ==
  Cambios en archivos del repositorio, que vuelven a su version original:
    modificado   escenario/java/src/main/java/pe/pasarelaandina/calculo/CalculadoraLiquidacion.java
  Archivos nuevos, que se borran:
    escenario/java/src/test/java/pe/pasarelaandina/calculo/CalculadoraComisionTest.java

== Restauracion ==
  [ OK ] lab-5-4 listo para empezar
```

Importante: el reinicio del 5.4 restaura `escenario/` completo, así que descartó los cambios de código del 5.2 (la refactorización de `CalculadoraLiquidacion.java`) y el archivo `CalculadoraComisionTest.java` del 5.3. Los entregables Markdown del 5.3 se conservaron porque viven en la ruta del lab 5.3, que el 5.4 no restaura. Antes del reinicio se guardó una copia del estado. El README del 5.4 dice que el reinicio es opcional.

## Paso 1 - `/lab-5-4-paso-1-consolidar-activos` (modo Agent)

Segundos: 47 (equivalente enfocado a 30 minutos: sin exploración exhaustiva, un conjunto acotado de cinco activos y una prueba del script)

### Respuesta del chat (verbatim)

Revisé `.github/` (instrucciones, cinco agentes, skills, hook), los entregables del 5.3 y el escenario, y decidí consolidar **cinco activos genéricos** en `labs/cap5/lab-5-4-laboratorio-final/entregables/activos/`, con un `README.md` que explica cada uno y cómo instalarlo en otro repositorio.

Qué decidí y por qué:
- **Empecé por la verificación de salida idéntica**, porque es lo que más se reutiliza: sirve en cualquier lenguaje y es lo que hizo seguro el lab 5.2. La hice independiente de Pasarela Andina: un script que captura la salida de cualquier comando y la compara después.
- Generalicé el **Revisor** y el **Refactorizador** (quitando las referencias al escenario), la **plantilla de instrucciones** de repositorio (con campos entre corchetes) y el **checklist** de revisión humana del 5.3.
- **Dejé fuera** los agentes Analista, Documentador y Tester, la skill de reglas de negocio de Pasarela Andina y el hook que protege `escenario/datos/`, porque dependen del dominio y de la estructura de este repositorio. Tampoco cambié el tipo de dato de los montos: altera la salida de ambos escenarios y requiere una decisión de negocio, no un activo.
- **No modifiqué el escenario ni los artefactos existentes de `.github/`.** No hay cambio de salida que explicar.
- No instalé ni descargué nada.

Archivos creados (7), todos bajo `entregables/activos/`:
`README.md`, `checklist-de-revision.md`, `instrucciones/copilot-instructions.plantilla.md`, `agentes/revisor.agent.md`, `agentes/refactorizador.agent.md`, `skills/verificar-salida-identica/SKILL.md`, `skills/verificar-salida-identica/verificar-salida.sh`.

Verificación: probé `verificar-salida.sh` con un programa de dos líneas: captura (2 líneas), comparación idéntica (código 0) y comparación con una línea cambiada (código 1, con diff). Los agentes y la skill no se probaron en otro repositorio.

Otros problemas que vi y no toqué:
- El reinicio del lab 5.4 descartó el estado del 5.2 y 5.3 en `escenario/`, pero dejó los entregables del 5.3, que describen pruebas (`CalculadoraComisionTest`) que ya no existen en el árbol de trabajo.
- Los entregables del 5.1 (`criterios-de-evaluacion.md`) no existen, aunque el skill del 5.3 paso 4 los menciona.
- Montos en `double`, borde de tramo distinto entre `CalculadoraComision` y `CalculadoraLiquidacion`, máximo del recargo 3,0 frente a 3,5, zona horaria del sistema frente a la hora de Lima exigida por la regla 8.

### Salida de la prueba del script

```
Referencia guardada: 2 lineas
Salida identica
exit 0
--- /var/folders/0z/73g9y0yx66756c51kxtbx_fm0000gn/T//salida-de-referencia.txt	2026-10-01 22:33:05
+++ /var/folders/0z/73g9y0yx66756c51kxtbx_fm0000gn/T/tmp.uZU5Nqb4jQ	2026-10-01 22:33:06
@@ -1,2 +1,2 @@
 hola
-mundo
+otro
exit 1
```

### Contenido completo de los archivos nuevos

#### activos/README.md

`````
# Activos reutilizables del taller

Cinco activos que no dependen del dominio de Pasarela Andina. Todos se copian a otro
repositorio sin descargar nada. Donde hay un dato propio del equipo, el archivo lo marca
entre corchetes.

| Activo | Para qué sirve |
|---|---|
| `instrucciones/copilot-instructions.plantilla.md` | Reglas de alcance, fuente de verdad y verificación que Copilot aplica en todo el repositorio. |
| `agentes/revisor.agent.md` | Agente de solo lectura que revisa un diff y clasifica cada hallazgo en aplicar, descartar o decidir. |
| `agentes/refactorizador.agent.md` | Agente que aplica una refactorización acotada y la valida con una comparación de salida. |
| `skills/verificar-salida-identica/` | Skill y script que capturan la salida de un programa antes de un cambio y comprueban después que sigue idéntica. |
| `checklist-de-revision.md` | Checklist de 15 puntos para el revisor humano de un cambio hecho con ayuda de un agente. |

## Por dónde empezar

El activo que más conviene llevarse mañana es `skills/verificar-salida-identica/`: sirve
en cualquier refactorización de cualquier lenguaje y es la verificación que convierte
«creo que no cambió nada» en una comprobación.

## Cómo instalar cada activo en otro repositorio

Desde la raíz del repositorio de destino, en Git Bash. `ORIGEN` es la ruta de esta carpeta.

1. **Instrucciones.**
   ```bash
   mkdir -p .github
   cp ORIGEN/instrucciones/copilot-instructions.plantilla.md .github/copilot-instructions.md
   ```
   Abre el archivo y completa los textos entre corchetes: idioma, ruta de las reglas de
   negocio, comandos de compilación y de comparación, terminal. Sin eso, la plantilla no
   está lista.
2. **Agentes.**
   ```bash
   mkdir -p .github/agents
   cp ORIGEN/agentes/*.agent.md .github/agents/
   ```
   Aparecen en el selector de agentes del chat de VS Code. Si el equipo ya tiene un agente
   con el mismo nombre, conserva el suyo y compara.
3. **Skill.**
   ```bash
   mkdir -p .github/skills
   cp -r ORIGEN/skills/verificar-salida-identica .github/skills/
   ```
   Se invoca con `/verificar-salida-identica` en el chat. Los comandos del script reciben
   el comando que ejecuta el programa del repositorio entre comillas.
4. **Checklist.**
   ```bash
   mkdir -p docs
   cp ORIGEN/checklist-de-revision.md docs/
   ```
   Enlázalo desde la plantilla de pull request del equipo.

## Qué se probó y qué no

- Se probó el script `verificar-salida.sh` con un programa de dos líneas: captura, comparación
  idéntica (código 0) y comparación con una línea distinta (código 1).
- Los agentes y la skill no se ejecutaron en otro repositorio. Hay que probarlos allí.
- No se modificó el escenario. Los tipos de los montos, el código y su salida quedan como estaban,
  y por eso no hay cambio de salida que explicar.

## Qué quedó fuera

- Un cambio al tipo de dato de los montos. Cambia la salida de los dos escenarios y exige
  una decisión de negocio sobre el redondeo, que no corresponde a un activo reutilizable.
- Versiones de los agentes Analista, Documentador y Tester del repositorio. Son específicas
  de Pasarela Andina y de `escenario/README.md`. Generalizarlas es el siguiente paso.
`````

#### activos/checklist-de-revision.md

`````
# Checklist de revisión humana de un cambio hecho con ayuda de un agente

Para aplicar a un pull request. Cada punto se responde con sí o no. Un «no» en cualquier
punto de Alcance o Comportamiento detiene la aceptación hasta que se aclare.

## 1. Alcance

1. **¿El diff toca solo los archivos que la tarea nombraba?**
   Verificación: `git diff --stat` y comparar la lista con el enunciado de la tarea.
2. **¿Cada cambio del diff responde a algo que se pidió?** (sin renombres, sin reformateo, sin literales extraídos, sin tipos cambiados por iniciativa del agente)
   Verificación: leer el diff completo, no el resumen del agente; buscar líneas cambiadas que no estén dentro del bloque pedido.
3. **¿Los problemas que el agente vio y no pertenecían a la tarea están anotados y no corregidos?**
   Verificación: la respuesta del agente tiene su lista de «otros problemas» y el diff no los toca.

## 2. Comportamiento

4. **¿La salida del programa es idéntica antes y después en un cambio que no debía alterarla?**
   Verificación: el comando de comparación de salida del repositorio (por ejemplo la skill `verificar-salida-identica`) termina en 0.
5. **¿El proyecto compila y todas las pruebas pasan?**
   Verificación: [comando de compilación y pruebas del repositorio]; contar las pruebas y comparar con las esperadas.
6. **¿Se probó con un periodo distinto del periodo por omisión?**
   Verificación: repetir la comparación con otros datos de entrada o periodos que el repositorio tenga.

## 3. Pruebas

7. **¿Cada prueba nueva declara en su nombre qué espera, y se sabe si documenta el comportamiento actual o el deseado?**
   Verificación: leer los nombres y los comentarios del archivo; el agente debe haberlo dicho en su respuesta.
8. **¿Alguien con autoridad sobre la regla decidió que lo que las pruebas congelan es lo correcto?**
   Verificación: preguntar quién lo decidió y dónde consta. Si una prueba afirma un valor que las reglas del documento de reglas de negocio no definen, la respuesta es no.
9. **¿Las pruebas fallarían si el comportamiento cambiara?** (no solo ejercen el código)
   Verificación: cambiar a mano un valor de borde en el código bajo prueba, correr las pruebas y comprobar que alguna prueba falla; revertir el cambio.

## 4. Decisiones de negocio

10. **¿Cada discrepancia entre dos partes del sistema o entre el código y las reglas está listada con su dueño?**
    Verificación: el cambio o su descripción nombra las discrepancias y a quién corresponde decidirlas.
11. **¿Se verificó la regla en el documento de reglas de negocio y no en un comentario del código?**
    Verificación: para cada afirmación del agente sobre comportamiento correcto, localizar el número de regla; si solo hay un comentario como respaldo, la respuesta es no.
12. **¿Ninguna discrepancia abierta se resolvió en silencio dentro de este cambio?**
    Verificación: buscar en el diff modificaciones de comparadores, de topes o de porcentajes.

## 5. Lo que el agente no ve

13. **¿Alguien del equipo confirmó el impacto en el dinero de los comercios reales?** (el agente solo ve los datos del repositorio)
    Verificación: una persona de negocio o de finanzas firma que los montos cambiados, si los hay, son aceptables.
14. **¿Se consideraron las restricciones del entorno que no están en el repositorio?** (zona horaria, cultura de la máquina, versiones de runtime de producción)
    Verificación: comparar con la configuración del ambiente donde corre el proceso de cierre.
15. **¿El cambio respeta los criterios de evaluación acordados por el equipo?**
    Verificación: revisar el documento de criterios de evaluación del equipo; si todavía no lo tiene, acordarlo antes de aceptar.
`````

#### activos/instrucciones/copilot-instructions.plantilla.md

`````
# Instrucciones de repositorio

<!-- Plantilla. Reemplaza lo que está entre corchetes por los datos de tu repositorio. -->

Estas reglas aplican a todo el repositorio, en cualquier modo de chat y con cualquier agente.

## Idioma

- Responde en [idioma del equipo].
- Los comentarios, los mensajes de commit y la documentación van en [idioma del equipo].
- Los identificadores siguen la convención del lenguaje del archivo que se edita.

## Alcance de los cambios

- Haz exactamente lo que se pide. El alcance de la tarea es el alcance del cambio.
- Antes de modificar un archivo que la tarea no nombra, pregunta.
- Si ves un problema que no forma parte de la tarea, menciónalo al final de tu respuesta y
  no lo toques.
- No cambies tipos de datos, no renombres, no extraigas literales a constantes y no agregues
  dependencias salvo que la tarea lo pida.

## Fuente de verdad funcional

- Las reglas de negocio están en [ruta del documento de reglas].
- Cuando el código, un comentario y las reglas no coinciden, manda la regla. Dilo en tu
  respuesta, cita la regla y no cambies nada que no se haya pedido.

## Verificación

Después de cualquier cambio que no deba alterar el comportamiento:

```bash
[comando que compila y prueba]
[comando que compara la salida antes y después]
```

## Ambiente

- Los scripts se ejecutan en [terminal que usa el equipo].
- No propongas pasos que descarguen dependencias si el ambiente no tiene red.
`````

#### activos/agentes/revisor.agent.md

`````
---
name: 'Revisor'
description: 'Revisa un diff con criterio de revisor senior y clasifica cada hallazgo en aplicar, descartar o decidir, sin aplicar cambios'
argument-hint: 'Qué cambio revisar'
tools: ['read', 'search']
---

# Revisor

Tu trabajo es revisar cambios como lo haría un revisor senior del equipo. No aplicas
cambios.

## Cómo trabajas

1. Identifica qué pidió la tarea y qué cambió de verdad. Un archivo tocado que la tarea no
   nombra es el primer hallazgo.
2. Revisa el cambio en su contexto, no solo las líneas modificadas.
3. Clasifica cada hallazgo:
   - **Aplicar.** Es parte del alcance del cambio y tiene que corregirse antes de aceptar.
   - **Descartar.** No aplica al cambio, o ya existía en código que el cambio no tocó.
   - **Decidir.** Requiere una decisión humana que tú no puedes tomar.
4. Un problema anterior al cambio, en código que el cambio no tocó, va a **Descartar** con
   la nota «fuera del alcance del cambio», aunque sea un problema real.

## Formato

Una tabla con archivo, línea, hallazgo, clasificación y justificación. Al final, la
recomendación: aceptar, aceptar con cambios o rechazar.

## Límites

- No editas archivos ni ejecutas comandos.
`````

#### activos/agentes/refactorizador.agent.md

`````
---
name: 'Refactorizador'
description: 'Aplica una refactorización acotada que no cambia el comportamiento y la valida comparando la salida antes y después'
argument-hint: 'Qué refactorización aplicar y en qué archivo'
tools: ['read', 'search', 'edit', 'execute']
---

# Refactorizador

Tu trabajo es aplicar una refactorización pequeña y verificable. Una refactorización no
cambia el comportamiento.

## Cómo trabajas

1. Antes de editar, captura la salida de referencia con la skill `verificar-salida-identica`.
2. Haz un solo incremento: extraer un bloque a un método, sin cambiar tipos, nombres ni
   literales fuera del bloque.
3. Compila, corre las pruebas y compara la salida con la de referencia.
4. Si la salida cambió, no la corrijas a ciegas: informa la primera línea distinta y qué
   parte del cambio la explica.

## Límites

- Un solo archivo por incremento, el que la tarea nombra.
- No agregas dependencias ni descargas nada.
- Lo que veas y no pertenezca a la tarea va al final de tu respuesta, sin tocarlo.
`````

#### activos/skills/verificar-salida-identica/SKILL.md

`````
---
name: verificar-salida-identica
description: 'Captura la salida de un programa antes de un cambio y comprueba después que sigue siendo idéntica. Úsala en refactorizaciones que no deben cambiar el comportamiento.'
---

# Verificar que la salida sigue idéntica

Usa [verificar-salida.sh](verificar-salida.sh). Recibe el comando que ejecuta el programa
entre comillas.

## Procedimiento

1. Antes de cambiar nada, captura la referencia:

   ```bash
   bash verificar-salida.sh capturar "[comando que ejecuta el programa]"
   ```

2. Haz el cambio.
3. Compara:

   ```bash
   bash verificar-salida.sh comparar "[comando que ejecuta el programa]"
   ```

4. Interpreta el código de salida:
   - `0`, la salida es idéntica.
   - `1`, difiere. El script muestra las primeras líneas distintas.
   - `2`, no hay referencia capturada o el programa falló.

## Límites

- Solo compara. No corrige ni revierte nada.
- El programa debe producir la misma salida en dos ejecuciones sin cambios. Si incluye
  marcas de tiempo, quítalas o normalízalas antes.
`````

#### activos/skills/verificar-salida-identica/verificar-salida.sh

`````
#!/usr/bin/env bash
#
# Captura la salida de un programa y la compara despues de un cambio.
# Uso: bash verificar-salida.sh capturar|comparar "comando"
# Codigo de salida: 0 identica, 1 difiere, 2 no se pudo comparar.

set -u

modo="${1:-}"
comando="${2:-}"
referencia="${TMPDIR:-/tmp}/salida-de-referencia.txt"

if [ -z "$modo" ] || [ -z "$comando" ]; then
    echo "Uso: bash verificar-salida.sh capturar|comparar \"comando\"" >&2
    exit 2
fi

case "$modo" in
    capturar)
        if bash -c "$comando" > "$referencia" 2>&1; then
            echo "Referencia guardada: $(wc -l < "$referencia" | tr -d ' ') lineas"
            exit 0
        fi
        echo "El programa termino con error al capturar la referencia" >&2
        exit 2
        ;;
    comparar)
        if [ ! -f "$referencia" ]; then
            echo "No hay referencia. Ejecuta primero el modo capturar" >&2
            exit 2
        fi
        actual="$(mktemp)"
        if ! bash -c "$comando" > "$actual" 2>&1; then
            echo "El programa termino con error" >&2
            rm -f "$actual"
            exit 2
        fi
        if diff -u "$referencia" "$actual" > "$actual.diff"; then
            echo "Salida identica"
            rm -f "$actual" "$actual.diff"
            exit 0
        fi
        head -40 "$actual.diff"
        rm -f "$actual" "$actual.diff"
        exit 1
        ;;
    *)
        echo "Modo desconocido: $modo" >&2
        exit 2
        ;;
esac
`````

### Verificación del «Salida esperada» / criterios
activos/ con README.md que explica cada activo y cómo se instala: sí. Activo utilizable mañana: sí (verificar-salida-identica). Escenario sin cambios: sí, por lo que no hay cambio de salida que explicar. Artefactos de .github/ existentes sin modificar: sí.

## Paso 2 - `/lab-5-4-paso-2-medicion-y-presupuesto` (modo Agent)

Segundos: 25 (redacción del documento; verificación de que el repositorio no contiene material de créditos del capítulo 1)

### Respuesta del chat (verbatim)

Creé `labs/cap5/lab-5-4-laboratorio-final/entregables/medicion-y-presupuesto.md` (unas 750 palabras, dentro de las dos páginas). No modifiqué código.

Qué contiene:
1. **Línea base de medición**, con tres tablas (uso, resultado y calidad). Cada métrica tiene valor actual, fuente y responsable, y todos los valores quedan como `[completar]`. No inventé números. Incluye las métricas mínimas pedidas: personas por semana y por modo, tiempo de revisión de pull requests, cambios devueltos, cobertura de pruebas de la lógica de negocio y defectos posteriores a la integración de cambios hechos con el agente. Dejé dicho que hace falta una etiqueta o casilla en el pull request para distinguir esos cambios.
2. **Propuesta de presupuesto** por cuatro perfiles de uso, con los modos que usa cada uno, cuáles consumen más créditos y el presupuesto mensual por persona como campo a completar. Indica dónde consultar los valores: la documentación oficial de GitHub Copilot y la configuración de la organización.
3. **Qué se hace al llegar al 80 %**: cinco pasos, desde avisar al líder técnico hasta registrar quién aprueba una ampliación.

Una limitación: la tarea pide indicar qué modos consumen más créditos «según lo visto en el capítulo 1», pero ese material no está en este repositorio. Dejé la columna marcada «confirmar con la documentación del plan», con una orientación general (agente y agente con MCP suelen consumir más que sugerencias o preguntas) y la aclaración de que el factor exacto depende del modelo y del plan. No escribí ningún precio, cuota ni límite.

Otros problemas que vi y no toqué: el capítulo 1 no tiene material sobre créditos en el repositorio; el resto, igual que en el paso anterior.

### Archivo nuevo (contenido completo)

`````markdown
# Medición de adopción y presupuesto de créditos de GitHub Copilot

Documento para que el equipo mida si la adopción funciona y acuerde cuántos créditos gasta
cada persona. Todos los valores son campos a completar. No hay cifras de ejemplo.

## 1. Línea base de medición

Se mide dos veces: antes de extender el uso (línea base) y después, con la misma definición.
Frecuencia sugerida: semanal para uso, mensual para resultado y calidad.

### Uso

| Métrica | Valor actual | Fuente | Responsable |
|---|---|---|---|
| Personas que usan Copilot cada semana | [completar] | Panel de uso de Copilot de la organización (configuración de la organización en GitHub) | [completar] |
| Personas por modo: sugerencias en línea | [completar] | Panel de uso de Copilot | [completar] |
| Personas por modo: chat en modo pregunta | [completar] | Panel de uso de Copilot | [completar] |
| Personas por modo: agente | [completar] | Panel de uso de Copilot | [completar] |
| Personas por modo: agente con herramientas MCP | [completar] | Panel de uso de Copilot o encuesta interna si el panel no lo separa | [completar] |

### Resultado

| Métrica | Valor actual | Fuente | Responsable |
|---|---|---|---|
| Tiempo de revisión de pull requests (de abierto a aprobado) | [completar] | Repositorio de código: tiempos de los pull requests | [completar] |
| Cambios devueltos en revisión por pull request | [completar] | Repositorio de código: revisiones con cambios solicitados | [completar] |
| Cobertura de pruebas de la lógica de negocio | [completar] | Informe de cobertura del pipeline de integración | [completar] |

### Calidad

| Métrica | Valor actual | Fuente | Responsable |
|---|---|---|---|
| Defectos encontrados después de integrar un cambio hecho con ayuda del agente | [completar] | Sistema de seguimiento de incidencias, con etiqueta de «hecho con agente» en el pull request | [completar] |
| Pull requests con agente que cumplieron el checklist de revisión | [completar] | Checklist de revisión adjunto a cada pull request | [completar] |

Condición para que la medición sirva: el equipo acuerda una etiqueta o una casilla en la
plantilla del pull request que marque los cambios hechos con ayuda del agente. Sin esa marca,
las métricas de resultado y de calidad no distinguen el efecto de Copilot.

## 2. Propuesta de presupuesto de créditos

Los precios, cuotas y límites los fija el plan vigente de la organización. Consúltalos en la
documentación oficial de GitHub Copilot y en la configuración de la organización (facturación y
políticas de Copilot). Este documento no los asume.

| Perfil | Modos que usa | Modos que consumen más créditos | Presupuesto mensual por persona |
|---|---|---|---|
| Consulta y revisión | Sugerencias en línea, chat en modo pregunta | [confirmar con la documentación del plan] | [completar con el plan vigente] |
| Desarrollo diario | Sugerencias en línea, chat en modo pregunta, agente en tareas acotadas | Agente [confirmar] | [completar con el plan vigente] |
| Desarrollo intensivo | Todos los anteriores y agente con herramientas MCP | Agente y agente con MCP [confirmar] | [completar con el plan vigente] |
| Líder técnico o arquitecto | Chat en modo pregunta, agente en refactorizaciones y revisiones | Agente [confirmar] | [completar con el plan vigente] |

Sobre el consumo relativo: este repositorio no incluye el material del capítulo 1, así que la
columna «Modos que consumen más créditos» queda marcada para confirmar. Como orientación general,
los modos con más pasos autónomos (agente, y más aún con herramientas MCP) suelen consumir más que
una sugerencia en línea o una pregunta puntual, pero el factor exacto depende del modelo elegido y
del plan. Debe confirmarse en la documentación vigente.

### Qué se hace al llegar al 80 % del presupuesto

1. La persona lo informa a su líder técnico y revisa en el panel de uso qué modos gastaron más.
2. Pasa las tareas de exploración al modo pregunta y deja el modo agente para cambios acotados con
   un criterio de aceptación claro.
3. Revisa con el líder si el gasto produjo resultados medibles (sección 1) antes de pedir más presupuesto.
4. Si el equipo decide ampliar el presupuesto, queda registrado quién lo aprobó y por cuánto tiempo:
   [completar].
5. Qué ocurre al llegar al 100 % depende de la política de la organización: [consultar en la
   configuración de la organización].

Fecha de la primera revisión de este documento: [completar]. Responsable: [completar].
`````

### Verificación del «Salida esperada»
Documento creado, de no más de dos páginas: sí. Métricas de uso, resultado y calidad con valor actual, fuente y responsable, y valores como campos a completar: sí. Presupuesto sin precios ni límites inventados, con dónde consultarlos: sí. Qué hacer al 80 %: sí.
