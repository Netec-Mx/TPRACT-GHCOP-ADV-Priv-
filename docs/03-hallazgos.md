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
