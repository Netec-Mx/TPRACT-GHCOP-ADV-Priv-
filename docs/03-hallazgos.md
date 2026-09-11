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
