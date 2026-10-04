# Contexto del proyecto para agentes de IA

Este archivo describe qué es este repositorio y cómo debe comportarse cualquier agente de
IA que trabaje en él, sea GitHub Copilot en cualquiera de sus modos u otra herramienta.

## Qué es este repositorio

Material de trabajo de un taller práctico de GitHub Copilot para desarrolladores senior.
No es un producto en producción.

Contiene dos escenarios equivalentes bajo `escenario/`, uno en Java y otro en .NET, que
resuelven el mismo dominio con las mismas reglas y leen los mismos datos. El dominio es
**Pasarela Andina**, una procesadora de pagos ficticia que liquida comisiones a sus
comercios afiliados. Las reglas de negocio están en `escenario/README.md`.

Los enunciados de los laboratorios están en `labs/`.

## El código del escenario no se corrige por iniciativa propia

El código bajo `escenario/` tiene características elegidas a propósito para que haya
trabajo que hacer en los laboratorios. Algunas pueden parecer errores o malas prácticas.
**No se corrigen salvo que la tarea lo pida de forma explícita.**

Esto significa:

- Haz exactamente lo que la tarea pide y deja todo lo demás como está.
- No corrijas algo porque te parezca obvio o trivial.
- No corrijas nada de paso mientras haces otra tarea en el mismo archivo.
- No extraigas literales a constantes, no unifiques código entre clases, no renombres, no
  agregues manejo de errores y no cambies APIs, salvo que la tarea lo pida.
- No cambies tipos de datos ni la forma de redondear sin la aprobación explícita del
  participante. Si una corrección lo exige, dilo, muestra qué regla toca y espera.
- No hagas commits por tu cuenta. Propón el commit; el participante lo ejecuta o lo aprueba.
- No agregues pruebas salvo que la tarea lo pida.
- No silencies advertencias de análisis estático con anotaciones, supresiones ni archivos
  de configuración.

Si ves algo que te parece un problema y no forma parte de la tarea, menciónalo en tu
respuesta y no lo toques.

El repositorio tiene un hook en `.github/hooks/` que puede bloquear algunas acciones. Si
bloquea una, informa el motivo y no intentes rodearlo.

Para comparar el antes y el después de un cambio, guarda la salida de antes en un archivo
temporal fuera del repositorio, antes de cambiar nada, o compila una copia en una carpeta
temporal. Nunca uses `git stash`, `git reset`, `git checkout` ni `git restore` para eso.

## Convenciones del repositorio

Todo el contenido va en español neutro. Los identificadores del código siguen la
convención de su lenguaje. Los comentarios y la documentación van en español.

## Ambiente de clase

Los laboratorios se ejecutan en máquinas virtuales por escritorio remoto, sin descargas
durante la clase. Las dependencias ya están instaladas en la imagen de la máquina. No
propongas pasos que exijan descargar algo.
