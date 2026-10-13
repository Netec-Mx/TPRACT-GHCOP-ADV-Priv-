> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes, con las dependencias del servidor instaladas. Se grabó en la CLI, no en
> Visual Studio Code. La CLI no arranca el servidor desde `.vscode/mcp.json`: se le pasó la
> misma definición, con el mismo comando y los mismos permisos, por `--additional-mcp-config`.
> Los comandos de los pasos 1, 2 y 6 se ejecutaron en Git Bash de la misma máquina.

# Demo 3.2. El servidor MCP local (escenario Java)

## Paso 1. Abrir mcp/README.md

Tabla de herramientas del README:

```
| Herramienta | Qué devuelve | Parámetros |
|---|---|---|
| `buscar_comercios` | Hasta 20 comercios con su identificador, razón social, categoría y estado | `texto`, `estado`, `categoria`, todos opcionales |
| `detalle_comercio` | Los datos de un comercio y los de su plan de comisiones | `idComercio`, con formato `CM` y cuatro dígitos |
| `buscar_notas_soporte` | Notas de las áreas de soporte, afiliaciones y riesgos | `idComercio` y `texto`, opcionales |
```

Comando de arranque, línea 33 del README:

```
node --permission --allow-fs-read=. mcp/servidor-local/servidor.js
```

## Paso 2. Crear .vscode/mcp.json

La carpeta `.vscode` no existía y se creó. Contenido, exactamente el del guion:

```json
{
  "servers": {
    "pasarela-andina": {
      "type": "stdio",
      "command": "node",
      "args": ["--permission", "--allow-fs-read=.", "mcp/servidor-local/servidor.js"],
      "cwd": "${workspaceFolder}"
    }
  }
}
```

`git status --short`:

```
?? .vscode/
```

## Paso 3. Arrancar el servidor

El servidor arrancó con la sesión y registró tres herramientas:
`pasarela-andina-buscar_comercios`, `pasarela-andina-detalle_comercio` y
`pasarela-andina-buscar_notas_soporte`. En la CLI cada herramienta lleva el nombre del
servidor como prefijo.

## Paso 4. Chat en modo Agent

Escrito: `Usa el servidor pasarela-andina para listar los comercios de categoría TURISMO y dame el plan de comisiones del primero de la lista.`

Copilot hizo dos llamadas y cada una pidió aprobación por separado.

Aprobación 1, «Buscar comercios», parámetros `{"categoria": "TURISMO"}`. Se aprobó. Resultado:

```json
{"total":4,"resultados":[{"id":"CM0006","razonSocial":"Comercial La Molina S.A.C.","categoria":"TURISMO","estado":"ACTIVO"},{"id":"CM0007","razonSocial":"Inversiones Andina S.R.L.","categoria":"TURISMO","estado":"ACTIVO"},{"id":"CM0010","razonSocial":"Representaciones Breña S.R.L.","categoria":"TURISMO","estado":"ACTIVO"},{"id":"CM0017","razonSocial":"Grupo Andina S.A.C.","categoria":"TURISMO","estado":"ACTIVO"}]}
```

Aprobación 2, «Detalle de un comercio», parámetros `{"idComercio": "CM0006"}`. Se aprobó.
Resultado:

```json
{"id":"CM0006","razonSocial":"Comercial La Molina S.A.C.","registroTributario":"20703289252","categoria":"TURISMO","fechaAfiliacion":"2025-02-07","estado":"ACTIVO","idPlanComisiones":"PL02","plan":{"id":"PL02","nombre":"Emprende","montoFijoPorTransaccion":"0.25","topeMensual":"5000.00","tramos":[{"desde":"0","hasta":"300","porcentaje":"4.2"},{"desde":"300","hasta":"1500","porcentaje":"3.6"},{"desde":"1500","hasta":"8000","porcentaje":"3.0"},{"desde":"8000","hasta":"999999","porcentaje":"2.6"}]}}
```

No consultó las notas de soporte ni leyó archivos del repositorio.

## Paso 5. Respuesta del chat

> **Comercios de categoría TURISMO (4):**
> 1. CM0006 – Comercial La Molina S.A.C. (ACTIVO)
> 2. CM0007 – Inversiones Andina S.R.L. (ACTIVO)
> 3. CM0010 – Representaciones Breña S.R.L. (ACTIVO)
> 4. CM0017 – Grupo Andina S.A.C. (ACTIVO)
>
> **Plan de comisiones del primero (CM0006), plan PL02 «Emprende»:**
> - Monto fijo por transacción: 0.25
> - Tope mensual: 5000.00
>
> | Desde | Hasta | Porcentaje |
> |---|---|---|
> | 0 | 300 | 4.2 |
> | 300 | 1500 | 3.6 |
> | 1500 | 8000 | 3.0 |
> | 8000 | 999999 | 2.6 |

La lista sale de `buscar_comercios` y el plan de `detalle_comercio`. La respuesta no lo dice;
se ve en las dos aprobaciones.

## Paso 6. Restaurar

`bash scripts/reiniciar-lab.sh lab-3-4 --confirmar`, código de salida 0:

```
== Punto de partida de lab-3-4 ==
  Referencia: punto-de-partida
  Rutas: escenario labs/cap3/lab-3-4-mcp-local/entregables .vscode/mcp.json mcp .github/instructions

== Esto se va a perder ==
  Archivos nuevos, que se borran:
    .vscode/mcp.json

== Restauracion ==
  [ OK ] lab-3-4 listo para empezar
```

`git status --short` posterior: vacío. La carpeta `.vscode` queda vacía.

## Esperado contra observado

- Paso 1: coincide.
- Paso 2: coincide. Hubo que crear la carpeta `.vscode`.
- Paso 3: coincide, tres herramientas.
- Paso 4: coincide. Dos llamadas, dos aprobaciones, cada una con sus parámetros a la vista.
- Paso 5: coincide. Para decir qué herramienta respaldó cada dato hay que mirar las
  aprobaciones, porque la respuesta no lo menciona.
- Paso 6: coincide.
