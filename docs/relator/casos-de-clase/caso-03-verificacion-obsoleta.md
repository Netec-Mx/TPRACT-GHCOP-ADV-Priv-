# Caso 3. El verificador dice que la máquina no sirve

> Capítulo 5, laboratorio 5.3, puesta en común: cuando lo obsoleto es la verificación.
> Material para proyectar. La resolución está al final, en las notas del relator.

---

## Lo que dijo el verificador

La máquina virtual del taller llega lista. Se ejecuta el script de verificación de
ambiente, que termina con código 1:

```
== Extensiones de GitHub Copilot ==
  [FALLA] Extension github.copilot no esta instalada en Visual Studio Code
  [FALLA] Extension github.copilot-chat no esta instalada en Visual Studio Code

== Resumen ==
  Ambiente NO apto. Faltan 2 requisito(s) obligatorio(s).

  Requisitos faltantes:
    - Extension github.copilot no esta instalada en Visual Studio Code
    - Extension github.copilot-chat no esta instalada en Visual Studio Code

  Revisa docs/00-setup-ambiente.md para los pasos de instalacion.
```

---

## Todo lo demás está bien

La misma ejecución, completa:

```
== Herramientas obligatorias ==
  [ OK ] Git 2.54.0 (minimo 2.40)
  [ OK ] JDK 21.0.1 (minimo 21)
  [ OK ] SDK de .NET 8.0.401 (minimo 8.0)
  [ OK ] Node.js 22.17.0 (minimo 22)
  [ OK ] Visual Studio Code 1.138.0 (minimo 1.95)

== Conectividad obligatoria de GitHub Copilot ==
  [ OK ] github.com alcanzable
  [ OK ] api.github.com alcanzable
  [ OK ] api.githubcopilot.com alcanzable
  [ OK ] proxy.individual.githubcopilot.com alcanzable
  [ OK ] copilot-proxy.githubusercontent.com alcanzable
  [ OK ] default.exp-tas.com alcanzable
```

La sesión de GitHub está iniciada. La licencia de Copilot está asignada.

Y Copilot no sugiere nada. No aparece su canal en el panel de salida. El editor no muestra
ningún error.

---

## Se hace lo que dice el verificador

Instalar la extensión que falta:

```
$ code --install-extension GitHub.copilot

Installing extensions...
Installing extension 'github.copilot'...
Error while installing extension github.copilot-chat: Extension 'github.copilot-chat' is a
built-in extension with version '0.66.0' and cannot be downgraded to version '0.48.1'.
Failed Installing Extensions: github.copilot-chat
```

---

## El marketplace

<!-- ESPACIO PARA LA CAPTURA DEL PRODUCT OWNER: la ficha de GitHub.copilot tal como se vio
     desde la máquina virtual. Ver las notas del relator antes de proyectar. -->

> *Captura de la ficha de `GitHub Copilot` en el marketplace, tomada durante la
> validación de la máquina virtual.*

Lo que dicen los datos del propio marketplace sobre esa extensión:

```
GitHub.copilot         última versión 1.388.0    publicada 2025-10-24
GitHub.copilot-chat    última versión 0.48.1     publicada 2026-05-15
```

Y lo que dice el editor cuando la encuentra instalada:

```
All GitHub Copilot functionality is now being served from the GitHub Copilot Chat
extension.
```

---

## La causa

Nada faltaba. Copilot estaba ahí, integrado en el editor desde la versión 1.116. Estaba
**deshabilitado**.

En el perfil del usuario:

```
extensionsIdentifiers/disabled => [{"id":"github.copilot-chat"}]
```

Y en el código del propio editor, los mensajes de depuración que emite al abrirse por
primera vez con un perfil nuevo:

```
Running builtin chat extension enablement migration
Disabling builtin chat extension as chat set up is not completed
```

Se resuelve en el panel de extensiones, con el filtro `@builtin copilot`, pulsando
**Enable AI Features** o **Enable** sobre GitHub Copilot Chat.

El verificador buscaba con `code --list-extensions`, que no lista las extensiones
integradas. Habría reprobado esta máquina con Copilot deshabilitado, y también con Copilot
funcionando.

---

## La pregunta

**¿Cuánto tiempo habrías perdido antes de dudar de la herramienta de verificación en lugar
del ambiente?**

---
---

# Notas del relator

> **No proyectar.** Desde aquí en adelante es la conducción del caso.

## Cómo se conduce

Se proyecta de a una lámina y se detiene en cada una.

Después de la primera conviene preguntar qué harían. La respuesta casi unánime es instalar
lo que falta, y es la respuesta correcta con esa información: el verificador fue escrito
para esto, dice exactamente qué falta y apunta a la documentación.

La tercera lámina es el punto de quiebre. El error de instalación no dice que la extensión
sobre. Dice que una versión no se puede degradar, lo que invita a buscar cómo forzarla. Vale
preguntar a la sala cuántos habrían buscado cómo forzar la instalación. Ese es el camino que
se toma cuando se confía en el verificador.

La quinta lámina cambia la pregunta. El problema existía, pero no era el que el verificador
señalaba, y el verificador no tenía cómo verlo.

## Lo que tiene que quedar claro de la causa

Son dos defectos, no uno, y conviene separarlos:

- **El verificador reprobaba por una razón falsa.** Buscaba componentes que el producto ya
  no tiene en esa forma. `GitHub.copilot` está descontinuada y `GitHub.copilot-chat` viene
  integrada, así que ninguna de las dos aparece en `code --list-extensions`. Habría
  reprobado cualquier máquina, incluida una perfecta.
- **Y no veía la razón verdadera.** La extensión estaba deshabilitada, y eso no se detecta
  preguntando si está instalada.

El primero es el más visible. El segundo es el que importa: un verificador que reprueba
todo por una razón falsa también esconde la razón verdadera, porque nadie mira más allá de
lo que ya dijo.

## Por qué nació así

El criterio se escribió el 11 de septiembre de 2026. Copilot venía integrado en el editor
desde el 15 de abril. No se desactualizó con el tiempo: se escribió con lo que se sabía de
Copilot, no con lo que Copilot era ese día.

Y hubo una segunda oportunidad. Un documento posterior del mismo proyecto dice, sobre esta
misma reprobación: «no es un falso positivo». Se escribió sin comprobarlo. Comprobarlo
tomaba un minuto: listar las extensiones de un editor con Copilot funcionando y ver que la
lista sale vacía.

Vale decirlo en sala tal cual. El error no fue de conocimiento, fue de proceso.

## La conclusión que cierra el caso

**Una verificación automática hereda las suposiciones de quien la escribió y del momento en
que la escribió.** No sabe más que su autor, y no sabe nada de lo que cambió después.

**Cuando reprueba algo que parece correcto, hay que sospechar de las dos partes.** Del
ambiente y de la verificación. La tendencia natural es confiar en la herramienta porque fue
escrita justamente para decidir esto, y esa confianza es lo que hace caro el error.

**Una verificación desactualizada no falla en silencio: falla al revés.** Reprueba lo que
está bien. Y mientras todos miran esa falla, la que de verdad existe pasa de largo.

## El par con el caso 1

Los dos casos se proyectan en la misma sesión y tratan lo mismo desde lados opuestos:

| | Caso 1 | Caso 3 |
|---|---|---|
| Herramienta | Escáner de seguridad | Verificador de ambiente |
| Lo que hizo | Reportó problemas donde no los había | Reprobó algo que estaba bien |
| Lo que le faltaba | El propósito del código | El estado actual del producto |
| Quién tenía esa información | Quien encargó el trabajo | La documentación del producto, ese día |

La pregunta que une a los dos: **¿qué sabe la herramienta, y desde cuándo?**

Para el checklist de revisión humana del laboratorio 5.3 se traduce en un punto concreto.
Cuando una verificación automática reprueba o reporta algo, antes de actuar se pregunta
cuándo se escribió el criterio y contra qué versión del producto se comprobó.

## Si alguien pregunta cómo quedó corregido

El verificador ahora lee el perfil del editor y comprueba dos cosas: el ajuste
`chat.disableAIFeatures` y la lista de extensiones deshabilitadas. Se probó con veintiún
casos, siete que deben aprobar y catorce que deben reprobar, y se rompió a propósito tres
veces para confirmar que los casos detectan la rotura. El detalle está en
[`../03-hallazgos.md`](../03-hallazgos.md), HALLAZGO-05.

Hay un punto que vale mencionar si la sala es técnica. Visual Studio Code no ofrece una
forma documentada de consultar este estado, así que la corrección lee un almacenamiento
interno del editor. Eso puede romperse en una versión futura. Por eso el script exige un
testigo del formato: si el editor cambia su forma de guardar el estado, el verificador
reprueba en vez de aprobar. Es la misma lección aplicada a la corrección.

## Sobre las capturas

La primera y la segunda lámina son una ejecución real del verificador anterior, pero en la
máquina donde se construyó la corrección, no en la máquina virtual del cliente. Allí el
resultado fue el mismo, porque la comprobación no podía dar otro. Las versiones que se
proyectan no son las de la máquina virtual. Si se tiene la captura de la máquina virtual,
conviene reemplazarlas.

La cuarta lámina está pendiente de la captura que se tomó durante la validación. Al
construir la corrección, la ficha de `GitHub.copilot` en el marketplace no mostraba una
marca de extensión descontinuada: seguía publicada y sin actualizaciones desde octubre de
2025. Si la captura muestra la marca, se proyecta. Si no, la lámina se sostiene con los
datos de versión y el mensaje del editor, que ya están en ella.

## Advertencia

Este caso ocurrió de verdad durante la preparación del taller. El error de instalación, la
lista de extensiones deshabilitadas y los mensajes del editor son salidas reales. Vale
decirlo, porque cambia cómo se recibe.
