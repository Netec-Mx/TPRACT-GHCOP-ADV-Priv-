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
| Estado | **Corregido en SPEC-003-A.** Se aprobó la opción 1 |

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

### Alcance real, mayor de lo que parecía

Al corregirlo aparecieron **tres** aspectos distintos de la configuración regional, no uno.
Los dos últimos no estaban en el registro inicial.

**1. El separador decimal.** Es el que se había detectado. Con `es-ES` o `de-DE` los montos
salen con coma.

**2. Los dígitos.** Con `ar-SA` no cambia el separador: cambian las cifras.

```
  Total transado           : S/ ٢٦٠٧٤٫٠٨
```

La columna de cuotas del detalle también, porque `%8d` se ve afectado igual.

**3. El calendario, que altera el cálculo y no solo la impresión.** Con la máquina en
tailandés, `Calendar.getInstance()` no devuelve un calendario gregoriano:

```
Locale por defecto : th_TH
Clase de Calendar  : sun.util.BuddhistCalendar
getTime()          : Sun Jun 01 00:00:00 CLT 1483
```

Al establecer el año 2026 sobre un calendario budista, el programa calcula sobre el año
gregoriano **1483**, y el periodo de liquidación queda desplazado quinientos años:

```
  Desde: 01/06/1483 00:00
  Hasta: 30/06/1483 23:59
```

Esto no es un problema de formato. Cambia los datos que entran al cálculo.

Apareció además un cuarto aspecto, el juego de caracteres: bajo `th-TH` la JVM elige una
codificación de salida que no tiene la letra ñ, y `Representaciones Breña S.R.L.` sale
impreso como `Bre?a`.

### Corrección aplicada

Se aprobó la opción 1. La decisión vive en `util/ConfiguracionRegional.java`, que es el
espejo de `Util/CompatibilidadJava.cs` del escenario .NET y lleva la misma advertencia de
no revertir.

| Punto | Antes | Después |
|---|---|---|
| Montos y tablas | `String.format("%.2f", v)` | `String.format(REGION_DE_SALIDA, "%.2f", v)` |
| Fechas | `new SimpleDateFormat(patron)` | `new SimpleDateFormat(patron, REGION_DE_SALIDA)` |
| Calendario | `Calendar.getInstance()` | `Calendar.getInstance(REGION_DE_SALIDA)` |
| Codificación | heredada del sistema | `System.setOut(...)` con UTF-8 explícito |

`Locale.ROOT` es el neutro de Java, igual que la cultura invariante lo es de .NET.

**La zona horaria no se tocó.** Se usa el constructor de `Calendar` que solo recibe
configuración regional, de modo que la zona sigue siendo la del sistema y no aparece
mencionada en el código. DEF-04 queda textualmente igual, y se comprobó que su
comportamiento observable es idéntico antes y después del cambio.

### Evidencia

Checksum de la salida Java bajo diez configuraciones, medido por redirección a archivo:

| Configuración | Checksum | `Breña` |
|---|---|---|
| por defecto | `61f2c13f` | 3 |
| es-ES, de-DE, fr-FR | `61f2c13f` | 3 |
| ar-SA | `61f2c13f` | 3 |
| th-TH | `61f2c13f` | 3 |
| hi-IN, ja-JP, ru-RU, tr-TR, zh-CN | `61f2c13f` | 3 |

`comparar-escenarios.sh` retorna cero en las seis configuraciones probadas de extremo a
extremo, incluidas `ar-SA` y `th-TH`.

Quitando la protección en una copia y ejecutando bajo `es-ES`, el script vuelve a reportar
**724 líneas distintas** y retorna 1.

### Nota: una afirmación mía sobre DEF-04 que resultó incorrecta

Al verificar que el cambio no había tocado DEF-04 escribí que los checksums bajo distintas
zonas horarias debían ser distintos, y salieron iguales. La afirmación estaba mal.

Compilé el código anterior al cambio y comprobé que **ya se comportaba igual**: la zona
horaria no altera la salida de este escenario, ni antes ni después de SPEC-003-A.

La razón es que el parseo de las fechas de las transacciones y el cálculo de los límites
del periodo usan los dos la zona por defecto, de modo que se desplazan juntos y se
compensan. DEF-04 sigue siendo un defecto real de diseño —API obsoleta, sin zona explícita,
frágil ante cualquier cambio que rompa esa simetría— pero no produce diferencia observable
con estos datos.

Queda registrado porque una verificación que se apoya en una expectativa equivocada no
verifica nada, aunque el resultado final sea correcto.

### Por qué no se convirtió en defecto plantado

Se evaluó dejarlo como defecto didáctico y se descartó. Un defecto que hace que dos
participantes vean números distintos sobre los mismos datos no enseña nada: arruina la
comparación en sala y desvía la clase a depurar el entorno.

### Regla derivada

**Todo programa cuya salida se vaya a comparar entre implementaciones debe fijar su
configuración regional de forma explícita, porque el entorno de ejecución es una entrada
del programa aunque no aparezca en su firma.** No alcanza con que funcione en la máquina
del que lo escribió.

**La configuración regional no es solo el separador decimal.** Son al menos cuatro cosas:
el separador, los dígitos, el calendario y el juego de caracteres. Las dos últimas no se
detectan probando con español y alemán, que es lo que uno prueba primero. Hay que incluir
al menos un idioma con otros dígitos y uno con otro calendario.

**Una configuración regional puede cambiar el resultado del cálculo, no solo su
impresión.** El caso del calendario budista desplazó el periodo de liquidación quinientos
años. Un defecto de este tipo no se encuentra revisando el formateo.

**Una verificación de comportamiento frente al entorno debe elegir casos que ejerciten
dimensiones distintas del problema, no variantes de la misma dimensión.** Diez idiomas
europeos prueban una sola cosa: el separador decimal. Cuatro idiomas bien elegidos prueban
cuatro cosas distintas. Al pedir una verificación, la pregunta útil no es cuántos casos se
probaron sino cuántas dimensiones cubren.

El episodio completo, con las cuatro salidas literales, está preparado para clase en
[`casos-de-clase/caso-02-configuracion-regional.md`](casos-de-clase/caso-02-configuracion-regional.md).

---

## HALLAZGO-05. El verificador reprobaba cualquier ambiente, correcto o no

| Campo | Valor |
|---|---|
| Detectado en | Validación del Product Owner sobre la máquina virtual del cliente |
| Componente | Script de verificación de ambiente, comprobación de Copilot en Visual Studio Code |
| Severidad | Alta. Reprobaba toda máquina y no detectaba la única falla real que tenía la del cliente |
| Estado | Corregido en SPEC-001-C |

### Qué pasaba

La máquina virtual del cliente tenía todas las versiones por encima del mínimo y la
conectividad a Copilot completa. El verificador la reprobó igual:

```
== Extensiones de GitHub Copilot ==
  [FALLA] Extension github.copilot no esta instalada en Visual Studio Code
  [FALLA] Extension github.copilot-chat no esta instalada en Visual Studio Code
```

La comprobación buscaba las dos extensiones en la salida de `code --list-extensions`. Esa
salida no las iba a contener nunca, en ninguna máquina:

- **`GitHub.copilot` está descontinuada.** Era la extensión de las sugerencias en línea
  cuando Copilot estaba repartido en dos. Su función la entrega hoy Copilot Chat. En el
  marketplace sigue publicada, congelada en la versión 1.388.0 del 24 de octubre de 2025, e
  intentar instalarla falla con un error de dependencia.
- **`GitHub.copilot-chat` viene integrada en el editor** desde Visual Studio Code 1.116,
  publicado el 15 de abril de 2026. Una extensión integrada no aparece en
  `code --list-extensions`, ni siquiera cuando está habilitada.

Se comprobó sobre un perfil con Copilot Chat habilitada: la lista sale vacía.

Y la máquina sí tenía un problema, que el verificador no veía: Copilot Chat estaba
**deshabilitada**. Sin sugerencias, sin canal de salida y sin ninguna señal clara del
editor. Era lo único que había que detectar.

### Cómo llegó ahí

La comprobación nació en SPEC-001 como aviso, no como falla. SPEC-001-B la convirtió en
falla, con el argumento razonable de que un puesto con el editor y sin Copilot no sirve
para el taller. SPEC-001-B se escribió el 11 de septiembre de 2026, casi cinco meses
**después** de que Copilot pasara a venir integrado.

O sea que el criterio no quedó obsoleto con el tiempo: nació obsoleto. Se escribió con lo
que se sabía de Copilot, no con lo que Copilot era ese día, y nadie lo contrastó con la
documentación vigente.

Hubo una segunda oportunidad de verlo y también se perdió. En SPEC-004-A, la instrucción
de calibración para el Product Owner dice que el verificador «hoy reprueba por estas dos
extensiones, y no es un falso positivo». Era un falso positivo. Se afirmó sin comprobarlo.

### Por qué la máquina llegó con Copilot deshabilitado

No está en la documentación. Está en el código del editor, versión 1.138: la primera vez
que se abre Visual Studio Code con un perfil de usuario, si Copilot todavía no está
configurado, el editor **deshabilita por su cuenta** la extensión integrada. Deja una marca
en el perfil para no repetir esa decisión en los arranques siguientes.

En una máquina virtual, cada participante entra con su usuario, y su perfil nace así. Si
las doce máquinas llegan como llegó la validada, la primera sesión empieza con doce
personas sin Copilot y sin un mensaje que diga por qué.

No se pudo reproducir un primer arranque en limpio: el editor no levanta con interfaz
gráfica desde el entorno donde se construyó esta corrección. La conclusión se apoya en el
código fuente del editor instalado y en el estado real de un perfil deshabilitado, no en
una ejecución observada de principio a fin.

### La señal elegida

Visual Studio Code no ofrece una forma de consultar desde la línea de comandos si las
funciones de IA están activas. Se revisó la referencia de la línea de comandos y la de
ajustes de IA: no hay opción ni comando para eso.

El estado vive en dos lugares, y el editor los mantiene sincronizados:

| Lugar | Qué guarda | Dónde |
|---|---|---|
| Ajuste `chat.disableAIFeatures` | La decisión de apagar la IA. Por omisión `false`. Solo admite nivel de usuario y de espacio de trabajo, no política de empresa | `settings.json` de usuario y `.vscode/settings.json` |
| Lista de extensiones deshabilitadas | Si `github.copilot-chat` está apagada | Clave `extensionsIdentifiers/disabled` de `User/globalStorage/state.vscdb`, que es SQLite |

Los botones del panel de extensiones confirman el acoplamiento: **Enable AI Features** sobre
la extensión integrada cambia el ajuste a `false`, y el editor habilita la extensión en
respuesta. Al revés, habilitar la extensión deja el ajuste en `false`.

Revisar solo el ajuste habría dado verde en la máquina del cliente, porque ahí el ajuste no
estaba tocado: lo que estaba apagado era la extensión. Revisar solo la extensión no habría
visto un `.vscode/settings.json` que apague la IA en el repositorio. Se revisan los dos.

La base SQLite se lee con `node:sqlite`, incluido en Node.js desde la versión 22.5. Node ya
era requisito obligatorio del ambiente, y Git para Windows no trae cliente de SQLite.

### El riesgo de la señal elegida, y cómo se acotó

Leer el almacenamiento interno de un producto es frágil. Si una versión futura del editor
renombra la clave, el script no encontraría la lista de deshabilitadas y concluiría que no
hay ninguna. Aprobaría en silencio, que es justo el defecto que este hallazgo registra.

Para que ese cambio produzca rojo y no verde, el script exige un testigo: la marca
`builtinChatExtensionEnablementMigration`, que el editor escribe en todo perfil donde
evaluó la extensión integrada. Si falta, reprueba con un mensaje que dice que el formato
cambió y que el script debe revisarse.

La regla general del gate es la misma en todos los casos: si no puede leer algo, reprueba y
dice qué no pudo leer. No aprueba nunca a ciegas.

### Evidencia

Veintiún casos armados sobre copias de un perfil real, sin tocar el original, más una
copia del script en un repositorio temporal para probar la configuración del espacio de
trabajo:

| Debe aprobar | Resultado |
|---|---|
| Copilot habilitada, sin ajuste | 0 |
| Lista de deshabilitadas con otras extensiones | 0 |
| Ajuste en `false` con coma final | 0 |
| Ajuste solo comentado, una URL con `//` y una coma dentro de cadenas | 0 |
| Usuario en `true`, espacio de trabajo en `false`, que prevalece | 0 |
| Perfiles adicionales, con aviso | 0 |
| `settings.json` con marca BOM de Windows | 0 |

| Debe reprobar | Resultado |
|---|---|
| Copilot Chat en la lista de deshabilitadas, que es el estado de la máquina del cliente | 1 |
| Lo mismo con el identificador en mayúsculas | 1 |
| Ajuste de usuario en `true` | 1 |
| Ajuste en `true` y extensión deshabilitada | 1 |
| Espacio de trabajo en `true` | 1 |
| `settings.json` ilegible, de usuario o de espacio de trabajo | 1 |
| Ajuste con tipo equivocado, `"true"` como texto | 1 |
| Perfil inexistente | 1 |
| Perfil sin base de estado | 1 |
| Base de estado corrupta | 1 |
| Lista de deshabilitadas con formato inesperado | 1 |
| Perfil sin testigo de formato | 1 |
| Versión futura simulada: clave renombrada y Copilot deshabilitada | 1 |

Además, un perfil real con Copilot Chat deshabilitada, sin fabricar nada, reprueba con
código 1.

Para comprobar que la batería muerde, se rompió el gate tres veces a propósito:

| Defecto introducido | Casos que lo detectan |
|---|---|
| La rama de extensión deshabilitada deja de reprobar | Los dos casos de Copilot en la lista de deshabilitadas |
| El lector de `settings.json` deja de quitar comentarios | El ajuste solo comentado, que pasa a reprobar un ambiente correcto |
| Se quita el testigo de formato | Los dos casos de perfil sin testigo, que pasan a aprobar |

El segundo mutante falla al revés, y es el más fácil de pasar por alto: un ajuste comentado
en `settings.json`, como `// "chat.disableAIFeatures": true`, es habitual y no apaga nada.

No se ejecutó en Windows. Las rutas del perfil en Git Bash y la conversión de rutas al
pasarlas a Node se escribieron según la documentación y quedan por confirmar en la máquina
virtual.

### Reglas derivadas

**Una comprobación sobre un producto de evolución rápida se verifica contra la
documentación vigente el día que se escribe.** No contra lo que se sabía del producto. Este
criterio se escribió cinco meses después del cambio que lo invalidaba.

**Y se revisa cuando el producto cambia.** Una verificación desactualizada no falla en
silencio: falla al revés, reprobando lo que está bien. En este caso hizo las dos cosas a la
vez, porque reprobaba por una razón falsa y no veía la razón verdadera.

**Cuando un gate reprueba algo que parece correcto, se sospecha de las dos partes.** Del
ambiente y del gate. La afirmación «no es un falso positivo» se escribió sin comprobar el
gate, y la comprobación tomaba un minuto: listar las extensiones de un perfil con Copilot
funcionando.

**Si la señal es interna al producto, el gate tiene que reprobar cuando la señal cambia de
forma.** Leer un almacenamiento no documentado es aceptable solo si un cambio de formato
produce rojo. Si produce verde, el gate es peor que no tenerlo.

### Dónde aplica esto en el taller

Es el caso gemelo de HALLAZGO-02 en el capítulo 5. Allí una herramienta reportó problemas
donde no los había; aquí una herramienta reprobó algo que estaba bien. Las dos tratan lo
mismo desde lados opuestos: una verificación automática hereda las suposiciones de quien la
escribió y del momento en que la escribió.

La evidencia preparada para proyectar está en
[`casos-de-clase/caso-03-verificacion-obsoleta.md`](casos-de-clase/caso-03-verificacion-obsoleta.md).

---

## HALLAZGO-06. El diseño de laboratorios se construyó sobre un artefacto en retiro

| Campo | Valor |
|---|---|
| Detectado en | SPEC-008, verificación de los comandos del chat en la documentación vigente |
| Componente | Pasos invocables de los nueve laboratorios, diseñados como prompt files |
| Severidad | Alta. Treinta y cuatro pasos dependían de un mecanismo que Visual Studio Code anunció que va a quitar |
| Estado | Corregido en SPEC-009. Los pasos son skills y los prompt files de calibración se eliminaron |

### Qué pasaba

El diseño de laboratorios de SPEC-004 descomponía cada laboratorio en pasos invocables y
cada paso era un prompt file en `.github/prompts/`. Se escribieron dos como calibración y
el resto esperaba a que la calibración cerrara.

Al verificar en SPEC-008 qué comandos del chat existían, la página de prompt files de
Visual Studio Code, actualizada el 16 de septiembre de 2026, decía lo siguiente.

- Los prompt files están descontinuados para las sesiones Agent Host, que no los cargan.
- Siguen funcionando con el agente local, pero el agente local se va a eliminar en una
  versión futura.
- La recomendación oficial es migrarlos a skills.

Visual Studio Code se actualiza solo en las máquinas virtuales y el taller ocurre semanas
después de construir el material. Un paso que funciona el día de la prueba puede no
aparecer el día de la clase.

### Qué se hizo

Cada paso se construyó como skill en `.github/skills/`, invocable por su nombre con la
barra en el chat. Los dos prompt files de calibración se migraron conservando su
contenido, con dos ajustes.

- Aceptan los dos escenarios. Los originales eran uno de Java y otro de .NET.
- Se quitaron las frases que anticipaban el hallazgo del participante. El prompt de 5.3
  decía que probablemente aparecería una inconsistencia al probar los bordes, y el de 5.2
  pedía no unificar el tope del recargo con el de otra clase. Las skills llegan al
  repositorio de participantes y esas frases revelaban el ejercicio. La restricción se
  mantuvo en forma general.

Las skills traen un riesgo que los prompt files no tenían. Una skill puede cargarse sola
cuando el agente la considera relevante, y una skill del laboratorio 5.2 cargada durante
el 1.5 contamina el ejercicio. La documentación vigente ofrece el campo
`disable-model-invocation: true`, que impide la carga automática y conserva la invocación
con la barra. Todas las skills de laboratorio lo declaran, y `scripts/validar-skills.sh`
reprueba la que no lo haga.

Fuentes, consultadas el 27 de septiembre de 2026.

- https://code.visualstudio.com/docs/agent-customization/prompt-files
- https://code.visualstudio.com/docs/agent-customization/agent-skills

### Reglas derivadas

**Antes de construir sobre un tipo de artefacto, se verifica que no esté en retiro.** No
alcanza con que funcione hoy. En un producto que se actualiza solo, lo que importa es si
va a seguir existiendo el día en que se usa.

**Lo que se entrega al participante se lee como si el participante fuera un agente.** Una
restricción escrita para guiar al agente también la lee la persona, y si nombra el
problema que el ejercicio quiere que descubra, el ejercicio desaparece.

### Dónde aplica esto en el taller

En el capítulo 2, al presentar los tipos de artefactos. La elección entre prompt file y
skill no es de gusto: uno está en retiro y el otro no. Y en el capítulo 1, cuando se
discute que Copilot cambia más rápido que la documentación interna de cualquier equipo.

---

## HALLAZGO-07. El mismo agente clasificó distinto la misma regla según el contexto

| Campo | Valor |
|---|---|
| Detectado en | SPEC-011, grabación de las salidas de respaldo de los laboratorios |
| Componente | Regla 8 de `escenario/README.md`, periodo en hora de Lima |
| Severidad | Ninguna para el material. Es material de clase |
| Estado | Registrado. No se corrige |

### Qué pasó

En la misma corrida de verificación, el mismo agente evaluó la regla 8 dos veces sobre el
mismo código.

- **En el laboratorio 4.4, paso 1.** La clasificó como regla que **no coincide** con el
  código, porque `UtilidadesFecha` usa la zona horaria del sistema y no la de Lima.
- **En el laboratorio 5.1, paso 3.** La clasificó como **«cumple en la práctica, sin
  garantía»**, porque el código usa la zona del sistema de forma consistente y en una
  máquina configurada en Lima el resultado es correcto.

En SPEC-009 se había observado otra variante en el 4.4, con la regla 8 entre las que
coinciden con matices.

Las dos lecturas son defendibles. Cambió el contexto del pedido. En el 4.4 la pregunta era
qué hace el código frente a la regla. En el 5.1 la pregunta era bajo qué condiciones la regla
deja de cumplirse.

### Reglas derivadas

**Una clasificación hecha por un agente depende del pedido, no solo del código.** Dos
pedidos distintos sobre el mismo archivo pueden producir dos veredictos distintos, los dos
razonables. Para comparar entre participantes o entre corridas, el criterio de
clasificación tiene que estar escrito en el pedido.

### Dónde aplica esto en el taller

En el 4.4. Desde SPEC-016 el 5.1 ya no clasifica reglas: escribe una historia de usuario.
La observación de arriba sobre el 5.1 queda como registro de la versión anterior. Si dos
participantes clasifican distinto la regla 8 en el 4.4, no es un error de ninguno. Es la ocasión de
preguntar qué criterio usó cada uno y cuál pondría el equipo por escrito.

## HALLAZGO-08. Un ejemplo del README del escenario no cargaba datos

| Campo | Valor |
|---|---|
| Detectado en | SPEC-014, verificación como agente del laboratorio 4.4, paso 4 |
| Componente | `escenario/README.md`, sección «Cómo se ejecuta», ejemplo de Java con periodo y directorio |
| Severidad | Baja. Un participante que copiara el ejemplo vería una liquidación vacía |
| Estado | Corregido en SPEC-015, con autorización expresa como única excepción a no tocar `escenario/` |

### Qué pasó

El ejemplo indicaba el directorio de datos como `datos`. Los dos escenarios se ejecutan
desde su propio directorio y los datos están un nivel más arriba, en `escenario/datos`. Con
`datos`, el cierre no encuentra ningún archivo, lo dice en cuatro líneas, liquida cero
comercios y termina con código 0. El ejemplo de .NET ya usaba `../datos`.

No es un defecto plantado ni está en el catálogo.

### Corrección y verificación

El ejemplo pasa a `java -jar target/liquidacion-comercios.jar 2026-05 ../datos`. Ejecutado
desde `escenario/java`, carga 40 comercios, 2037 transacciones y 30 contracargos, y su
salida tiene el SHA-256 `b80d54152371f23f37b9dc7f6cfd46200520c41b6eb2ebaf46ee24025b22e82c`,
el mismo de la liquidación de 2026-05. El ejemplo de .NET con `../datos` da el mismo hash.
Ningún otro ejemplo del README tiene el problema. El código, las pruebas y los datos del
escenario no cambiaron.

## HALLAZGO-09. El catálogo prometía un efecto visible de DEF-04 que no ocurre

| Campo | Valor |
|---|---|
| Detectado en | SPEC-016, al publicar hashes esperados de la liquidación |
| Componente | `04-defectos-plantados.md`, DEF-04 |
| Severidad | Media. Un relator que contara el efecto en clase no podría mostrarlo |
| Estado | Corregido en SPEC-016-B. El código y los datos no cambiaron |

### Qué pasó

El catálogo decía que `TX002005`, del 30 de junio a las 23:59:00, quedaba fuera del periodo en
una máquina al este de Lima. La nota de SPEC-003-A de este mismo documento ya había mostrado
que la zona horaria no cambia la salida, pero el catálogo no se actualizó.

### Verificación

La liquidación de los tres periodos es idéntica byte a byte en Java y en .NET en seis zonas:
America/Lima, UTC, Asia/Tokyo, America/Los_Angeles, Asia/Kolkata, de media hora, y
Pacific/Kiritimati, a +14. El parseo y los límites del periodo se desplazan juntos.

### Corrección

El catálogo dice ahora que el defecto es de diseño y se lee en el código, que con estos datos
no cambia la salida en ninguna zona probada, y por qué. Se revisaron la teoría, las
demostraciones, las notas, los casos de clase, los respaldos y la hoja de respuestas: ningún
otro pasaje prometía el efecto. Las clasificaciones de la regla 8 como «no coincide» o
«depende de la máquina» en el 4.4 se refieren al código, que no fija la zona, y siguen siendo
correctas.

## HALLAZGO-10. verificar-ambiente.sh reprobaba con el editor abierto sin estar seguro

| Campo | Valor |
|---|---|
| Detectado en | Primera prueba humana con Copilot real, 3 de octubre de 2026, en macOS |
| Componente | `scripts/verificar-ambiente.sh`, comprobación de las funciones de IA |
| Severidad | Media. Un participante al que le dicen que algo está roto cuando funciona deja de confiar en el resto del diagnóstico |
| Estado | Corregido en SPEC-017 |

### Qué pasó

El script informó «GitHub Copilot Chat esta deshabilitada en el perfil del editor» mientras el
editor estaba abierto, con otra ventana de otro proyecto, y no se cerró entre las dos
corridas.

### Evidencia

- El historial de la terminal registra las dos corridas a las 18:49:57 y a las 18:55:23.
- `User/globalStorage/state.vscdb.backup`, del 18 de septiembre, tiene
  `extensionsIdentifiers/disabled` con `github.copilot-chat` y `chat.setupContext` con
  `"disabled":true`. Es el estado que el perfil tenía en disco antes de la prueba.
- Los registros del editor muestran la misma sesión abierta desde el 29 de septiembre. En
  ninguna ventana se había activado Copilot Chat hasta las 18:56:20 del 3 de octubre, cuando
  `ExtensionService` la activó en las dos ventanas a la vez. Hasta 18:56:19 el chat registra
  `no-model-at-toolbar-build`: no tenía modelo.
- `state.vscdb` actual ya no tiene la lista de deshabilitadas y su fecha es posterior.
- `storage.json` no tiene perfiles adicionales y todas las carpetas abiertas están asociadas
  a `__default__profile__`.

### Causa

De las tres candidatas, el perfil distinto y la cuenta de perfiles adicionales quedan
descartadas: hay un solo perfil, el que el script lee. La causa es el estado que el editor
todavía no había guardado en disco. Según los registros, en las dos corridas Copilot Chat
seguía deshabilitada en el perfil, y se habilitó un minuto después de la segunda. El script
no puede distinguir ese caso del que importa: con el editor abierto, el disco puede estar
atrasado respecto de lo que el editor ya aplicó, y la regla de reprobar ante cualquier
deshabilitación en disco convierte ese atraso en una falla. Se reprodujo con una copia del
perfil respaldado: el script anterior reprueba con el editor abierto.

### Corrección

El script reprueba solo cuando está seguro: el ajuste `chat.disableAIFeatures` en `true`, que
se escribe en el momento, o la extensión deshabilitada en disco con el editor cerrado y sin
perfiles adicionales. Con el editor abierto, con otros perfiles o sin poder leer el estado,
advierte y dice cómo confirmarlo en diez segundos: abrir el chat, escribir hola y ver si
Copilot responde. Los atajos del mensaje dependen del sistema: `Cmd+Shift+X`, `Cmd+,` y
`Ctrl+Cmd+I` en macOS, y `Ctrl+Shift+X`, `Ctrl+,` y `Ctrl+Alt+I` en Windows y Linux. Antes
decía `Ctrl` en todos.

## HALLAZGO-11. Copilot adelanta en el 5.1 defectos que el 5.3 hace descubrir

| Campo | Valor |
|---|---|
| Detectado en | Primera prueba humana con Copilot real, 3 de octubre de 2026, paso 1 del 5.1 |
| Componente | `lab-5-1-paso-1-historia-de-usuario`, restricción de mencionar al final lo que parezca un problema |
| Severidad | Baja. Adelanta una parte del diagnóstico del 5.3, no lo reemplaza |
| Estado | Aceptado. La skill no cambia; las notas del 5.1 y la hoja de respuestas dicen qué responder |

### Qué pasó

Al terminar la historia, Copilot avisó por su cuenta que `CalculadoraLiquidacion.java` trata
el límite superior del tramo como exclusivo y que `CalculadoraComision.java` permite un
recargo por cuotas de hasta 3,5 % cuando la regla dice 3 %. Son DEF-08 y DEF-03 del catálogo.
Lo hizo porque la restricción común de las skills de laboratorio le pide mencionar al final
lo que le parezca un problema, sin tocarlo.

### Por qué no se cambia la skill

Es un comportamiento realista y bueno de mostrar: el agente lee el código, ve la discrepancia
con las reglas y la informa sin corregirla, que es exactamente lo que la restricción pide. Lo
que el 5.3 agrega es la evidencia: cuánto suma cada causa, en qué comercios y con qué
transacciones, y la segunda causa, el punto flotante, que no se ve leyendo el código.

### Qué responde el relator

Que está bien visto, que no se corrige ahora y que el 5.3 lo va a confirmar con evidencia.
Está en las notas del 5.1 y en la hoja de respuestas del capítulo 5.
