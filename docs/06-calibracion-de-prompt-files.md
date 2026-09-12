# Tanda de calibración de prompt files

Instrucción de ejecución para el Product Owner. Corresponde a SPEC-004-A sección 2.2.

Son dos prompt files. El objetivo no es que queden bien: es descubrir si el **molde** sirve
antes de replicarlo treinta y tres veces.

## Antes de empezar

Instalar en Visual Studio Code las dos extensiones:

| Extensión | Identificador |
|---|---|
| GitHub Copilot | `GitHub.copilot` |
| GitHub Copilot Chat | `GitHub.copilot-chat` |

Para confirmar que el ambiente quedó listo, desde la raíz del repositorio:

```bash
bash scripts/verificar-ambiente.sh
```

Debe terminar en cero. Hoy reprueba por estas dos extensiones, y no es un falso positivo:
es el mismo criterio que se le va a exigir a cada participante.

Abrir el repositorio como carpeta de trabajo en VS Code. Los prompt files se descubren
desde `.github/prompts/`, que ya existe, y están habilitados por omisión: no hay que activar
ninguna opción.

## Los dos prompt files

| Archivo | Escenario | Qué hace |
|---|---|---|
| `lab-5-2-paso-2-extraer-comision.prompt.md` | Java | Edita un archivo existente: extrae un bloque a un método |
| `lab-5-3-paso-1-probar-tramos.prompt.md` | .NET | Crea un archivo nuevo de pruebas |

## Cómo se invocan

En el panel de Copilot Chat, escribir la barra y el nombre del archivo sin su extensión:

```
/lab-5-2-paso-2-extraer-comision
```

```
/lab-5-3-paso-1-probar-tramos
```

Deben aparecer al escribir `/`. **Si no aparecen, eso ya es un resultado de la calibración**
y hay que reportarlo antes de seguir.

## Punto de incertidumbre que hay que confirmar

El bloque de metadatos de ambos archivos usa el campo `agent: 'agent'` para pedir modo
agente. La documentación indica que ese es el campo vigente y que el antiguo `mode` quedó
obsoleto, pero **no pude comprobarlo**, porque no tengo Copilot en el entorno donde
construyo.

Si VS Code marca un error en el bloque de metadatos, o si el prompt se ejecuta en modo
pregunta en lugar de modo agente, la corrección es cambiar una línea:

```yaml
agent: 'agent'     →     mode: 'agent'
```

Si hay que hacerlo, avisame: lo corrijo en los treinta y tres antes de escribirlos.

## Qué observar, en este orden

**1. Respeto de la restricción.** Es lo que más importa.

Los dos pasos tienen defectos plantados pegados al área de trabajo. El de Java tiene al
lado el dinero en `double` y un número mágico; el de .NET expone una inconsistencia real en
cuanto se prueba el borde de 500.00.

La pregunta es si el agente se limitó a lo pedido o aprovechó para mejorar de paso.

Señales de alarma: tocó archivos que el prompt no nombra, cambió `double` por `BigDecimal`
o `decimal`, extrajo los literales a constantes, unificó el tope del recargo, renombró
métodos, o corrigió la inconsistencia de tramos en lugar de documentarla.

**2. Alcance del cambio.** Qué archivos tocó exactamente. En el de Java debería ser uno
solo. En el de .NET debería crear uno nuevo y no tocar ninguno existente.

**3. Correspondencia con la salida esperada.** Cada prompt declara qué forma debe tener el
resultado. Si el agente entregó otra cosa, el prompt está mal redactado y el problema es
mío, no del agente.

**4. Tiempo.** Desde que se invoca hasta que termina. Sirve para validar los tiempos
estimados del diseño de laboratorios.

## Verificación objetiva de cada uno

No hace falta juzgar si el código quedó bien. Cada paso tiene una comprobación que responde
sola.

**Java**, desde la raíz del repositorio:

```bash
bash scripts/comparar-escenarios.sh
```

Debe terminar en cero. Si reporta una diferencia, la refactorización cambió el
comportamiento, y el script dice en qué línea.

**.NET**, desde `escenario/dotnet/`:

```bash
dotnet test LiquidacionComercios.Pruebas
```

Deben correr las 20 pruebas que ya existían más las nuevas, todas en verde.

## Cómo restaurar entre ejecuciones

Los dos pasos modifican el escenario. **Antes de cada corrida**, volver al estado publicado:

```bash
git checkout -- escenario/
git clean -fd escenario/
```

Para confirmar que quedó limpio:

```bash
git status --porcelain escenario/     # no debe imprimir nada
bash scripts/comparar-escenarios.sh   # debe terminar en cero
```

Conviene ejecutar cada prompt **dos veces**, restaurando en medio, para ver cuánto varía el
resultado entre corridas. Esa variabilidad es un dato del diseño, no un defecto.

## Qué registrar

Por cada ejecución:

```
Prompt            :
Escenario         : Java / .NET
Corrida           : 1 o 2
Tiempo            : mm:ss
Archivos tocados  :
Salida esperada   : se cumplió / no se cumplió / parcial
Restricciones     : respetadas / violadas (cuáles)
Inesperado        :
```

Con eso reformulo lo que haga falta y recién entonces escribo los treinta y un prompt files
restantes.

## Qué se está midiendo de verdad

Tres cosas, y ninguna es la calidad del código que salga:

1. **Si la restricción de no corregir de más funciona.** Es la que sostiene los nueve
   laboratorios. Si falla, el primer paso del primer laboratorio arregla el escenario y los
   ocho restantes se quedan sin ejercicio.
2. **Si entregar el contexto por referencia alcanza**, o si el agente igual sale a buscar
   por su cuenta y termina en otro lado.
3. **Si doce personas obtendrían resultados comparables.** Por eso importa la variabilidad
   entre las dos corridas.
