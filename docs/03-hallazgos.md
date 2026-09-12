# Hallazgos

Registro de defectos encontrados durante la construcción de este repositorio y de las
reglas que se derivan de ellos.

Esto no es una bitácora de cambios. Solo entra aquí lo que enseñó algo que conviene no
volver a aprender por las malas. Cada entrada termina con una regla, porque un hallazgo
sin regla derivada se lee una vez y no cambia nada.

---

## HALLAZGO-01. Un gate de conectividad que aprobaba dominios inexistentes

| Campo | Valor |
|---|---|
| Detectado en | SPEC-001, prueba de falla deliberada |
| Componente | Script de verificación de ambiente, comprobación de conectividad |
| Severidad | Alta. El script certificaba como aptos ambientes sin acceso a GitHub Copilot |
| Estado | Corregido en SPEC-001. El componente afectado se eliminó en SPEC-001-B |

### Qué pasaba

La comprobación de conectividad daba por alcanzable **cualquier** dominio, incluido uno
inexistente. Al reemplazar `api.githubcopilot.com` por un nombre inventado, el script
respondía:

```
[ OK ] api.githubcopilot-DOMINIO-ALTERADO.com alcanzable
== Resumen ==
  Ambiente apto. Todos los requisitos obligatorios y recomendados estan cubiertos.
```

Código de salida 0. Es decir, un puesto con el firewall corporativo bloqueando Copilot
por completo habría pasado la verificación sin una sola advertencia.

El defecto vivía en la implementación en PowerShell. La implementación en shell, que hacía
lo mismo con `curl`, nunca lo tuvo.

### Causa raíz

La comprobación se apoyaba en `Invoke-WebRequest` y tenía que distinguir dos situaciones
que llegan como excepción:

- El servidor respondió con un código de error HTTP. La red deja pasar, cuenta como éxito.
- La conexión nunca se estableció. La red bloquea, cuenta como fallo.

Para separarlas se usaba `FullyQualifiedErrorId`. El diagnóstico mostró por qué eso no
funciona:

```
=== api.githubcopilot-DOMINIO-ALTERADO.com ===   (el nombre no resuelve)
  Tipo excepcion : System.Net.Http.HttpRequestException
  FQErrorId      : WebCmdletWebResponseException,...InvokeWebRequestCommand
  Tiene .Response: False

=== httpbin.org/status/404 ===                    (el servidor respondió 404)
  Tipo excepcion : Microsoft.PowerShell.Commands.HttpResponseException
  FQErrorId      : WebCmdletWebResponseException,...InvokeWebRequestCommand
  Tiene .Response: True
```

El identificador de error es **idéntico** en ambos casos. PowerShell lo reutiliza para un
fallo de DNS y para una respuesta HTTP de error. La condición resultaba siempre verdadera
y todo dominio se reportaba como alcanzable.

La señal que sí discrimina es otra: si la excepción trae una respuesta adjunta. Un 404 la
trae poblada; un nombre que no resuelve la deja nula.

### Corrección aplicada

Se eliminó la inferencia por `FullyQualifiedErrorId` y se dejó como única condición la
presencia de una respuesta adjunta. Se verificó en ambos sentidos, para no cambiar un
falso positivo por un falso negativo:

```
  ok    github.com                                 -> alcanzable    responde 200
  ok    httpbin.org/status/404                     -> alcanzable    servidor responde
  ok    httpbin.org/status/500                     -> alcanzable    servidor responde
  ok    api.githubcopilot-DOMINIO-ALTERADO.com     -> inalcanzable  DNS falla
  ok    no-existe-este-dominio-del-taller.invalid  -> inalcanzable  TLD invalido
```

En SPEC-001-B el proyecto estandarizó en un script único y la implementación en PowerShell
se eliminó. El hallazgo se conserva igual, porque la lección no depende del lenguaje.

### Reglas derivadas

**Una condición de error no se infiere de un identificador que el sistema reutiliza para
casos distintos.** Antes de usar un código, un identificador o un mensaje para decidir una
bifurcación, hay que comprobar que toma valores distintos en los casos que se quieren
separar. Si no los toma, no sirve como señal por más razonable que suene su nombre.

**Un gate que no se probó fallando no es un gate.** Verde de entrada no prueba nada. Toda
verificación tiene que romperse a propósito una vez, y hay que ver que detecta el problema
y que termina con código distinto de cero. Este defecto era invisible en la ejecución
normal: el script daba verde y el verde era correcto, porque el ambiente estaba bien. Solo
apareció al forzar la falla.

**Probar el caso inverso es parte de la corrección.** Un gate se puede arreglar de modo que
ahora rechace todo, lo que es igual de inútil. La corrección no está terminada hasta que se
demuestra que acepta lo que debe aceptar y rechaza lo que debe rechazar.

### Dónde aplica esto en el taller

Es material directo para el capítulo 5, cuando se discute revisión asistida y checklist de
revisión humana. Un asistente propone con naturalidad la versión defectuosa de este código:
es plausible, compila y pasa en el camino feliz. Lo que la descarta no es leerla, es
probarla al revés.

---

## HALLAZGO-02. Un escáner de seguridad denunció los defectos plantados

| Campo | Valor |
|---|---|
| Detectado en | SPEC-002, revisión automática posterior al commit `171478c` |
| Componente | Escenario Java completo |
| Severidad | Ninguna en cuanto a seguridad. Alta en cuanto a riesgo de proceso |
| Estado | Sin corrección. Los hallazgos son intencionales y el código quedó intacto |

### Qué ocurrió

Una revisión de seguridad automática se ejecutó sobre el commit del escenario **sin que
nadie la solicitara**, y reportó tres hallazgos.

Dos de ellos corresponden a defectos plantados a propósito, documentados con archivo y
número de línea en `04-defectos-plantados.md` desde antes de que el escáner corriera.

No se modificó ningún archivo.

### Qué reportó

Salida literal:

```
Commit security review found 3 issues:
  authorization-bypass in escenario/java/src/main/java/pe/pasarelaandina/repositorio/RepositorioMemoria.java;
  parser-differential in escenario/java/src/main/java/pe/pasarelaandina/calculo/SimuladorComision.java;
  +1 more
```

El tercer hallazgo llegó contabilizado pero sin detalle, de modo que no se puede afirmar
cuál era. Por descarte corresponde a DEF-07 o a DEF-01, pero eso es inferencia y no consta.

### Qué eran en realidad

| Hallazgo | Archivo señalado | Defecto plantado |
|---|---|---|
| `authorization-bypass` | `RepositorioMemoria.java` | **DEF-09.** `buscarComerciosActivos()` devuelve todos los comercios sin filtrar por estado |
| `parser-differential` | `SimuladorComision.java` | **DEF-08.** Dos implementaciones del tramo que divergen en el borde superior, `<=` contra `<` |
| tercero, sin detalle | — | No consta |

### Por qué no son vulnerabilidades

Verificación de la superficie de ataque del escenario completo:

```
-- Entrada de red / sockets / HTTP --          ninguna
-- SQL / JDBC --                               ninguna
-- Deserializacion --                          ninguna
-- Ejecucion de procesos --                    ninguna
-- Reflexion / carga dinamica --               ninguna
-- Autenticacion / autorizacion / sesiones --  ninguna
```

El escenario es un proceso por lotes que lee cuatro archivos de texto del propio
repositorio y escribe por consola. No recibe entrada de terceros, no abre puertos, no
consulta bases de datos y no ejecuta nada externo.

### Por qué el escáner se equivocó sin equivocarse

El hallazgo de `authorization-bypass` es **correcto en un sentido e incorrecto en otro**, y
la distinción es la lección de este registro.

Es correcto en que el método no hace lo que su nombre promete. `buscarComerciosActivos()`
se llama así y devuelve todos los comercios, incluidos los suspendidos. Eso es un defecto
real, con consecuencia funcional observable: `CM0031` está suspendido y aparece liquidado.

Es incorrecto en que **no existe control de acceso en este sistema**. No hay usuarios, ni
sesiones, ni roles, ni privilegios que eludir. El escáner infirió un dominio de seguridad a
partir del nombre del método, porque «activo» y «filtrar» se parecen a lo que en otros
sistemas sería una comprobación de permisos.

O sea: detectó correctamente una discrepancia entre nombre y comportamiento, y la clasificó
en una categoría que aquí no aplica.

### Reglas derivadas

**Un hallazgo técnicamente correcto puede ser contextualmente equivocado.** La validez
técnica de un hallazgo y su pertinencia son dos preguntas distintas, y responder bien la
primera no dice nada sobre la segunda.

**Ninguna herramienta de análisis conoce el propósito del código que revisa.** El escáner
no podía saber que este repositorio es material de capacitación y que los defectos son el
producto. Esa información no está en el código: está en `AGENTS.md`, que el escáner no lee,
y en la cabeza de quien encargó el trabajo.

**La decisión de aplicar o descartar un hallazgo no es delegable a quien lo reporta.**
Requiere criterio humano sobre el contexto. Un agente que hubiera actuado sobre estos tres
hallazgos habría destruido dos laboratorios del capítulo 5 con la mejor de las intenciones
y un informe impecable.

### Dónde aplica esto en el taller

Es el caso central del capítulo 5, en la parte de revisión asistida de pull requests y
checklist de revisión humana. La evidencia cruda, preparada para proyectar, está en
[`casos-de-clase/caso-01-escaner-vs-defectos-plantados.md`](casos-de-clase/caso-01-escaner-vs-defectos-plantados.md).

También se menciona en el capítulo 3, al tratar lo que un agente hace por iniciativa propia
sin que nadie se lo pida.

---

## HALLAZGO-03. Java y .NET no formatean igual los mismos números

| Campo | Valor |
|---|---|
| Detectado en | SPEC-003, antes de escribir el escenario .NET |
| Componente | Equivalencia entre los dos escenarios |
| Severidad | Alta si no se controla. Rompe la comparación sin que nada falle |
| Estado | Resuelto en `Util/CompatibilidadJava.cs` del escenario .NET |

### Qué pasaba

SPEC-003 advertía sobre una divergencia conocida: `Math.Round` de .NET usa redondeo
bancario y `Math.round` de Java no. Al medirlo apareció una **segunda** divergencia que no
estaba prevista y que es más difícil de ver, porque no está en el cálculo sino en la
impresión.

`String.format("%.2f", v)` de Java y `v.ToString("F2")` de .NET **no producen el mismo
texto para el mismo double**:

| Valor | Java `%.2f` | .NET `F2` |
|---|---|---|
| 137.825 | `137.83` | `137.82` |
| 957.185 | `957.19` | `957.18` |
| 2.675 | `2.68` | `2.67` |
| 0.125 | `0.13` | `0.12` |

Sobre un barrido de 6016 valores, `ToString("F2")` difería de Java en **497 casos**.

### Causa raíz

Los dos formateadores parten de números distintos.

Java formatea sobre la **representación decimal más corta** que reconstruye el double, la
misma que produce `Double.toString`. Para 137.825 esa representación es exactamente
`137.825`, y al redondear medio hacia arriba da `137.83`.

.NET, desde .NET Core 3.0, formatea sobre el **valor IEEE exacto**. El double más cercano a
137.825 es 137.824999999999988631316227838397, que redondeado da `137.82`.

Ninguno de los dos está mal. Responden preguntas distintas: Java formatea el número que el
programador escribió, .NET formatea el número que la máquina guardó.

Lo mismo ocurre con el redondeo aritmético, por el motivo que el spec ya anticipaba:
`Math.Round(v, 2)` redondea al par más cercano en los puntos medios.

### Corrección aplicada

`Util/CompatibilidadJava.cs` del escenario .NET replica las dos semánticas de Java:

```csharp
// Redondeo: equivalente de Math.round(valor * 100.0) / 100.0
return Math.Floor(valor * 100.0 + 0.5) / 100.0;

// Formateo: equivalente de String.format("%.2f", valor)
decimal representacionCorta = decimal.Parse(
    valor.ToString("R", Invariante), NumberStyles.Float, Invariante);
return Math.Round(representacionCorta, 2, MidpointRounding.AwayFromZero)
           .ToString("F2", Invariante);
```

El paso por `"R"` obtiene la representación corta, que es el punto de partida de Java.
Sobre esa cadena se aplica el redondeo medio hacia arriba.

Verificado sobre los mismos 6016 valores: **0 diferencias** en ambas funciones.

### Alcance real, medido y no supuesto

Con los datos actuales del escenario, esta protección **no cambia ningún resultado
observable**. Sobre los 382 valores que el programa formatea de verdad en una ejecución
completa, las tres variantes coinciden y los dos redondeos también.

La razón es que los valores que se imprimen son acumulados de punto flotante, y un
acumulado casi nunca cae sobre el double cuya representación corta es un punto medio
exacto. Los casos que divergen aparecen con literales como `137.825`, no con sumas.

Esto se dice de forma explícita para no incurrir en cobertura falsa: la comparación de
escenarios pasa igual sin la clase. Se mantiene porque el riesgo está medido, porque los
laboratorios modifican ese cálculo y porque los datos pueden regenerarse.

### Reglas derivadas

**Redondear y formatear son operaciones distintas y divergen por separado.** Alinear el
redondeo entre dos plataformas no alinea la impresión. Hay que verificar las dos.

**Una equivalencia entre plataformas se mide antes de escribir el código, no después.**
Medir las divergencias primero permitió que las dos implementaciones coincidieran byte a
byte en el primer intento. Descubrirlas depurando una diferencia de un centavo habría
costado mucho más.

**Una protección que hoy no cambia nada no es prueba de que sobre.** Tampoco es prueba de
que sirva. Hay que decir cuál de las dos cosas se verificó.

### Dónde aplica esto en el taller

Sirve en el capítulo 5 para discutir qué significa que dos implementaciones sean
equivalentes y por qué "produce lo mismo" necesita una definición verificable. También es
un buen ejemplo de algo que un asistente resuelve mal si se le pide traducir código de un
lenguaje a otro sin decirle que la salida tiene que coincidir exactamente.

---

## HALLAZGO-04. El escenario Java cambia sus números según el idioma de la máquina

| Campo | Valor |
|---|---|
| Detectado en | SPEC-003, al probar el comportamiento bajo distintas culturas |
| Componente | Escenario Java, impresión de montos |
| Severidad | Alta para el dictado. Rompe la comparación en clase |
| Estado | **Sin corregir.** Reportado para decisión del Product Owner |

### Qué pasa

El escenario Java usa `String.format("%.2f", monto)` sin indicar `Locale`, de modo que toma
el idioma configurado en la máquina virtual. Con un idioma que usa coma decimal, los montos
salen con coma:

```
$ java -Duser.language=es -Duser.country=ES -jar target/liquidacion-comercios.jar
  Total transado           : S/ 26074,08
  Total comisiones         : S/ 727,34
```

El checksum de la salida cambia de `61f2c13f` a `cffb6271`.

Lo mismo ocurre con `-Duser.language=de`. En macOS la variable `LC_ALL` no alcanza para
provocarlo, pero la propiedad de la JVM sí, y una imagen de Windows en español lo produce
sin que nadie fuerce nada.

### La asimetría es el problema

El escenario **.NET está protegido**: fija `CultureInfo.InvariantCulture` de forma explícita
al arrancar, declara `InvariantGlobalization` en el proyecto y pasa la cultura invariante en
cada formateo. Verificado bajo `es_ES`, `de_DE`, `fr_FR` y `ru_RU`: el checksum no se mueve.

El escenario **Java no tiene ninguna de esas tres protecciones**.

O sea que en una máquina virtual en español el participante Java vería `S/ 26074,08` y el
participante .NET `S/ 26074.08`, sobre los mismos datos. Es exactamente el escenario que
SPEC-003 quiere evitar: la clase se desvía a depurar la diferencia.

### Por qué no se corrigió

No es un defecto plantado: no está en el catálogo de `04-defectos-plantados.md`.

Y SPEC-003 prohíbe modificar el escenario Java salvo la reubicación de datos. La regla del
proyecto para un defecto no intencional es reportarlo y no tocarlo, así que queda aquí
registrado para que el Product Owner decida.

`comparar-escenarios.sh` **sí detecta la situación** cuando ocurre: probado bajo `es_ES`
contra un escenario sin protección, reporta 724 líneas distintas y retorna 1.

### Opciones para resolverlo

1. **Corregir Java**, pasando `Locale.ROOT` a cada `String.format`. Es lo correcto, y
   requiere un spec que autorice tocar el escenario.
2. **Fijar el idioma al ejecutar**, con `-Duser.language=en` en el script y en las
   instrucciones de laboratorio. No arregla el código, y falla si alguien lo ejecuta a mano.
3. **Dejarlo y usarlo en clase.** Es un defecto realista y didáctico, pero entonces hay que
   plantarlo también en .NET, porque hoy la asimetría es involuntaria.

La tercera tiene mérito pedagógico, pero decidirlo es del Product Owner.

### Regla derivada

**El formateo de números depende del idioma de la máquina, y eso es un defecto de
portabilidad aunque el cálculo esté perfecto.** Todo programa que imprima montos para ser
comparados, exportados o parseados por otro sistema debe fijar su cultura de forma
explícita. No alcanza con que funcione en la máquina del que lo escribió.
