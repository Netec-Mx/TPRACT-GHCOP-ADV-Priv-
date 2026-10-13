# Contexto del proyecto

Documento de entrada para quien mantiene el material o lo dicta.

## Qué es el taller

El material de un taller práctico de GitHub Copilot de 13,5 horas, en cuatro sesiones,
para un equipo de desarrolladores senior Java y .NET de un banco en Perú. Lo contrató
Netec con el cliente. Los participantes ya usan Copilot a diario y notan cualquier
imprecisión técnica.

La sesión de apertura ya se realizó. El resto del taller lo dicta otro relator, y todo lo
que ese relator necesita saber está escrito en `docs/relator/`.

El temario es el contratado por Netec, con cinco capítulos y 810 minutos, de los cuales 390
son práctica en nueve laboratorios. La tabla está en el `README.md` de la raíz.

## Dos repositorios

| Repositorio | Para quién | Contenido |
|---|---|---|
| `RodrigoMSB/github-copilot-netec` | Construcción y relator | Todo, incluido `docs/relator/` y las herramientas |
| `RodrigoMSB/github-copilot-netec-taller` | Participantes | Instantánea de un solo commit generada con `scripts/publicar-taller.sh` |

Los dos son privados. El de participantes se genera desde una lista de inclusión,
`scripts/publicacion/incluir.txt`, y el script se niega a publicar si encuentra material
del relator. Tiene la etiqueta `punto-de-partida`, que usa `scripts/reiniciar-lab.sh`.
Se regenera completo con `--reemplazar`.

La cuenta de prueba `RoSilva26` tiene permiso de escritura en el repositorio de
participantes, porque GitHub no ofrece solo lectura en repositorios de cuenta personal. Un
ruleset, `sin-push-directo-a-main`, le bloquea push, borrado y reescritura de `main`. El
propietario lo puede saltar, y así funciona la republicación.

## Los gates

Los gates se corren con `bash scripts/gates.sh`, que usa la imagen de
`herramientas/Dockerfile` con las versiones de la máquina virtual y sin red. La máquina donde
se corren solo necesita Docker.

## El ambiente del taller

Máquinas virtuales Windows en Azure Lab Services, provistas por Netec, con JDK 25, SDK de
.NET 10, Node 24, Maven, Git para Windows y Visual Studio Code. Visual Studio Code es el
único editor. Git Bash es el único intérprete de scripts. No hay PowerShell en el proyecto.

La máquina virtual de prueba usa la cuenta `RoSilva26`, con Copilot en plan gratuito y
cuota limitada. La latencia es aceptable.

En clase no se descarga nada. La imagen de la máquina virtual se prepara con las
dependencias del servidor MCP y la caché de Maven y NuGet, según
`docs/00-setup-ambiente.md`, sección 2.3.

## Lo que hay en el repositorio

**El escenario.** Pasarela Andina, una procesadora de pagos ficticia que liquida comisiones
a comercios afiliados. Implementada dos veces, en `escenario/java`, con nivel de lenguaje
21, y en `escenario/dotnet`, con destino `net10.0`, sin frameworks y con datos compartidos
en `escenario/datos`. Las dos producen salidas idénticas byte a byte, verificadas por
`scripts/comparar-escenarios.sh`.

**Los diez defectos plantados.** DEF-01 a DEF-10, catalogados en
`docs/relator/04-defectos-plantados.md`. Son el ejercicio y no se corrigen salvo que un
laboratorio lo pida. El mismo archivo tiene una sección de comportamientos no planificados,
fuera del catálogo de diez.

**Los datos.** Generados con semilla fija 20260911. Las transacciones TX002035 a TX002037
se agregaron a mano para que el defecto de punto flotante sea visible. No se tocan. El hook
de `.github/hooks/` impide que un agente los modifique.

**Los laboratorios.** Nueve, en `labs/`. Cada paso es una skill de `.github/skills/` con
nombre `lab-`, restringida a invocación explícita. El diseño está en
`docs/relator/05-diseno-de-laboratorios.md` y las notas por laboratorio en
`docs/relator/notas/`.

**Los activos de referencia.** Instrucciones de repositorio y por ruta, agentes y skills
del dominio, con prefijo `pasarela-`, en `.github/`. `ls .github/agents .github/skills`
los lista.

**El servidor MCP.** `mcp/servidor-local/`, de solo lectura, sin conexiones de red en su
código, lanzado con el modelo de permisos de Node, que impide escribir y lanzar procesos
pero no restringe la red.

**Los scripts.**

| Script | Qué hace | Llega a participantes |
|---|---|---|
| `verificar-ambiente.sh` | Diagnostica el ambiente sin modificar nada | Sí |
| `comparar-escenarios.sh` | Verifica la equivalencia entre escenarios | Sí |
| `reiniciar-lab.sh` | Deja un laboratorio en su punto de partida | Sí |
| `validar-skills.sh` | Valida formato y restricciones de las skills | Sí |
| `publicar-taller.sh` | Genera y publica el repositorio de participantes | No |
| `gates.sh` | Corre todos los gates en Docker, sin red | No |

**La documentación del relator.** Todo `docs/relator/`. La guía de mantenimiento, en
`10-mantenimiento.md`, dice qué revisar antes de cada dictado.

## Errores ya cometidos que no hay que repetir

- Medir checksums con `printf '%s'` recorta el salto de línea final. Se mide redirigiendo a
  archivo.
- `Math.Round` de .NET redondea al par por omisión. `CompatibilidadJava.cs` replica el
  redondeo de Java y no se revierte.
- La configuración regional del sistema altera la salida si no está fijada en el código.
  Ambos escenarios la fijan.
- Los scripts con CRLF fallan en Git Bash. `.gitattributes` fuerza LF.
- La extensión `github.copilot` está descontinuada. Copilot viene integrado desde Visual
  Studio Code 1.116 y llega deshabilitado en un perfil nuevo.
- Con `JAVA_TOOL_OPTIONS` definida, la JVM escribe una línea en la salida de error. El
  comparador la filtra.
- El diseño de laboratorios se hizo sobre prompt files sin revisar su estado, y estaban en
  retiro. Antes de construir sobre un tipo de artefacto se verifica que no lo esté.
- El código del escenario tenía comentarios que citaban identificadores del catálogo. Todo
  lo que llega al participante pasa por el gate de fugas.
- Un agente de verificación lanzado desde el repositorio de construcción recibe su
  `AGENTS.md`, que enumera los defectos. Las pruebas con agentes se hacen sobre una copia
  del repositorio de participantes, y en la máquina virtual solo se abre ese repositorio.
