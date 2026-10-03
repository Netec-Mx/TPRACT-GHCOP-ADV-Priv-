# 0001. Dos implementaciones del escenario con salida idéntica

| Campo | Valor |
|---|---|
| Estado | Aceptada |
| Fecha | 2026-10-03 |
| Responsable | Equipo del taller |

## Contexto

Los participantes trabajan en Java o en .NET. Cada uno tiene que hacer los mismos
ejercicios en su propio lenguaje, y la sala tiene que poder comparar resultados entre
stacks.

Java y .NET no redondean ni formatean números de la misma forma por omisión, y el formato
de los números depende además del idioma de la máquina. Dos implementaciones escritas por
separado darían salidas parecidas pero no iguales, y una diferencia entre ellas no se
distinguiría de un cambio introducido durante un ejercicio.

## Alternativas consideradas

- **Un solo lenguaje.** Más simple de mantener. Deja a la mitad de la sala trabajando en un
  stack que no es el suyo.
- **Dos implementaciones sin verificar la salida.** Menos esfuerzo inicial. No permite saber
  si un cambio rompió algo ni comparar resultados entre participantes.
- **Dos implementaciones con salida idéntica verificada por comparación.** Más trabajo de
  mantenimiento. Da una referencia objetiva para cualquier cambio.

## Decisión

Se implementa el escenario dos veces, en `escenario/java` y en `escenario/dotnet`, sobre los
mismos datos de `escenario/datos`. Las dos implementaciones producen la misma salida byte a
byte. En .NET, los montos `double` se redondean y se formatean con
`Util/CompatibilidadJava.cs`, que reproduce el comportamiento de Java, y todo `Math.Round`
indica `MidpointRounding.AwayFromZero`. En Java, el formateo de salida usa una configuración
regional fija, `util/ConfiguracionRegional.java`. El script `scripts/comparar-escenarios.sh`
ejecuta las dos y compara sus salidas.

## Consecuencias

- Cualquier cambio de comportamiento se hace dos veces. Un cambio en un solo escenario se
  detecta al compararlos.
- La comparación sirve como prueba de regresión para refactorizaciones: si la salida no
  cambió, el comportamiento observable tampoco.
- Un desarrollador .NET no puede usar el redondeo por omisión de su lenguaje, que va al par,
  ni formatear los montos `double` por su cuenta. Las instrucciones por ruta lo dicen.
- La salida no depende del idioma de la máquina en que se ejecuta.

## Verificación

`bash scripts/comparar-escenarios.sh` termina en cero cuando las salidas son idénticas. Los
gates del repositorio lo ejecutan para tres periodos.
