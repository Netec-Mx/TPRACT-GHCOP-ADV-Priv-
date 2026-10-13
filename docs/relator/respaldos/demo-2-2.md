> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes. Cada agente se eligió con `copilot --agent <nombre>`, que es lo que hace el
> selector de modo de Visual Studio Code. Los comandos de los pasos 2, 5 y 6 se ejecutaron en
> Git Bash de la misma máquina.

# Demostración 2.2. Los agentes por rol (escenario Java)

## Paso 1. Selector de modo

`ls .github/agents`:

```
analista.agent.md
documentador.agent.md
refactorizador.agent.md
revisor.agent.md
tester.agent.md
```

## Paso 2. Encabezado de revisor.agent.md

```
---
name: 'Revisor'
description: 'Revisa un diff con criterio de revisor senior y clasifica cada hallazgo, sin aplicar cambios'
argument-hint: 'Qué cambio revisar'
tools: ['read', 'search']
---
```

## Paso 3. Agente Revisor

Escrito: `Revisa FormateadorReporte.java y corrige lo que encuentres.`

El Revisor buscó el archivo, lo leyó y leyó `escenario/README.md`. No intentó editar ni
ejecutar nada. Respuesta:

> Revisé `escenario\java\src\main\java\pe\pasarelaandina\reporte\FormateadorReporte.java`. No apliqué cambios por dos razones: mi rol de revisor no edita, y `escenario/` no se corrige por iniciativa propia. Además, la tarea no nombra ningún defecto concreto.
>
> | Archivo | Línea | Hallazgo | Clasificación | Justificación |
> |---|---|---|---|---|
> | FormateadorReporte.java | 19-25, 28-35 | Los totales se acumulan en `double`. Se suman montos sin redondear y solo se redondean al imprimir (`%.2f`). La regla 9 pide redondeo a dos decimales, medio hacia arriba. `String.format` usa HALF_UP sobre el valor binario, que puede diferir en casos límite. | Decidir | Cambiar el tipo de dato o la forma de redondear exige aprobación explícita. Afecta la regla 9 y la equivalencia con .NET. |
> | FormateadorReporte.java | 66-68, 76 | `maximoLineas` no se valida y los literales (`"lineas mas"`, anchos de columna) están repetidos. | Descartar | Fuera del alcance del cambio. Es una característica del escenario, y extraer constantes o agregar manejo de errores está prohibido sin pedido. |
> | FormateadorReporte.java | 18-58 | Sin acentos en los textos de salida («lineas», «periodo»). | Descartar | Fuera del alcance del cambio. Alterar la salida rompería la equivalencia con .NET. |
> | FormateadorReporte.java | — | No hay un cambio concreto que contrastar con las reglas. No ejecuté `comparar-escenarios.sh`, porque no puedo ejecutar comandos. | Descartar | No hay cambio que verificar. |
>
> **Recomendación:** aceptar el archivo sin cambios. El único punto que requiere decisión humana es el redondeo con `double` (primera fila). Si quieres que lo corrija, indica el defecto y confirma el alcance. Después de cualquier cambio, hay que correr `bash scripts/comparar-escenarios.sh`.

`git status --short`: vacío.

Para comparar, el mismo pedido al agente general, sin elegir el Revisor, sí intentó corregir.
Corrió el comparador y propuso dos ediciones a `FormateadorReporte.java`, que se rechazaron.
Es la diferencia que muestra la demostración: el rol con herramientas acotadas no puede editar.

## Paso 4. Agente Refactorizador

Escrito: `En escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java extrae la cabecera de formatearDetalle a un método privado.`

El Refactorizador leyó el archivo y `.github/instructions/java.instructions.md`, hizo dos
ediciones, compiló con `mvn -q clean package` y corrió `bash scripts/comparar-escenarios.sh`.
Respuesta:

> **Qué se extrajo:** la cabecera de `formatearDetalle` (separador, título con comercio y razón social, periodo, separador y fila de columnas) pasó al método privado `agregarCabeceraDetalle(StringBuilder texto, Liquidacion liquidacion)`.
>
> **Archivo cambiado:** `escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java`
>
> ```diff
>      public String formatearDetalle(Liquidacion liquidacion, int maximoLineas) {
>          StringBuilder texto = new StringBuilder();
>
> -        texto.append(SEPARADOR).append("\n");
> -        texto.append("  DETALLE DE ").append(liquidacion.getIdComercio());
> -        texto.append(" - ").append(liquidacion.getRazonSocial()).append("\n");
> -        texto.append("  Periodo ").append(liquidacion.getPeriodo()).append("\n");
> -        texto.append(SEPARADOR).append("\n");
> -        texto.append(String.format(ConfiguracionRegional.REGION_DE_SALIDA,
> -                "  %-12s %12s %10s %10s %8s%n",
> -                "TRANSACCION", "MONTO", "COMISION", "RECARGO", "CUOTAS"));
> +        agregarCabeceraDetalle(texto, liquidacion);
>
>          int impresas = 0;
> ```
> ```diff
> +    private void agregarCabeceraDetalle(StringBuilder texto, Liquidacion liquidacion) {
> +        texto.append(SEPARADOR).append("\n");
> +        texto.append("  DETALLE DE ").append(liquidacion.getIdComercio());
> +        texto.append(" - ").append(liquidacion.getRazonSocial()).append("\n");
> +        texto.append("  Periodo ").append(liquidacion.getPeriodo()).append("\n");
> +        texto.append(SEPARADOR).append("\n");
> +        texto.append(String.format(ConfiguracionRegional.REGION_DE_SALIDA,
> +                "  %-12s %12s %10s %10s %8s%n",
> +                "TRANSACCION", "MONTO", "COMISION", "RECARGO", "CUOTAS"));
> +    }
> +
>      private String monto(double valor) {
> ```
>
> **Verificación:**
> - `mvn -q clean package` terminó con código 0.
> - `bash scripts/comparar-escenarios.sh` terminó con código 0: las salidas de Java y .NET son idénticas (554 líneas, 20457 bytes).
>
> Propuesta de commit: `Refactoriza: extrae la cabecera de formatearDetalle a un método privado`. No lo ejecuté.

Esta vez no anunció el archivo y el bloque antes de tocarlos, y no listó otros problemas que
vio y no tocó.

## Paso 5. git diff --stat

```
 .../pasarelaandina/reporte/FormateadorReporte.java   | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)
```

## Paso 6. Restauración

`bash scripts/reiniciar-lab.sh lab-1-4 --confirmar`, código de salida 0:

```
== Punto de partida de lab-1-4 ==
  Referencia: punto-de-partida
  Rutas: escenario labs/cap1/lab-1-4-practica-guiada/entregables

== Esto se va a perder ==
  Cambios en archivos del repositorio, que vuelven a su version original:
    modificado   escenario/java/src/main/java/pe/pasarelaandina/reporte/FormateadorReporte.java

== Restauracion ==
  [ OK ] lab-1-4 listo para empezar
```

`git status --short` posterior: vacío.

## Esperado contra observado

- Paso 1: esperado cinco agentes. Observado cinco archivos.
- Paso 2: esperado `tools: ['read', 'search']`. Observado idéntico.
- Paso 3: esperado una tabla de hallazgos y ningún cambio. Observado igual, y además dice que
  su rol no edita y que no puede ejecutar comandos.
- Paso 4: esperado que diga archivo y bloque, aplique, compile, corra el comparador y mencione
  lo que no tocó. Observado: aplicó, compiló y corrió el comparador, pero no anunció el bloque
  antes ni listó lo que vio y no tocó. Si pasa en clase, señálelo como lo que un revisor
  humano tendría que pedir.
- Paso 5: esperado un solo archivo. Observado 1 file changed.
- Paso 6: esperado la restauración. Observado igual.
