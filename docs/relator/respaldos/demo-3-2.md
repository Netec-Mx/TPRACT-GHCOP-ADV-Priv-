segundos: 32

# Demo 3.2 simulada

## Paso 1. Abrir mcp/README.md
Texto mostrado: tabla de tres herramientas (buscar_comercios, detalle_comercio, buscar_notas_soporte) y comando de arranque:
`node --permission --allow-fs-read=. mcp/servidor-local/servidor.js`
(el README dice "Ninguna herramienta escribe, borra ni ejecuta nada").

## Paso 2. Crear .vscode/mcp.json
Hook antes de la edicion: {"tool_name":"editFiles","tool_input":{"files":[".vscode/mcp.json"]}} -> exit 0 (permitido). (Nota: lo ejecute despues de crear el archivo por orden de operaciones; resultado igual.)
Contenido creado exactamente como el guion. La carpeta .vscode no existia y hubo que crearla.

## Paso 3. MCP: List Servers / Start Server
Comando: bash mcp-llamar.sh (sin args). Salida (exit 0):
```
{"result":{"tools":[{"name":"buscar_comercios","title":"Buscar comercios","description":"Busca comercios afiliados por texto en la razón social o el identificador, y opcionalmente por estado o categoría. Devuelve como máximo 20 resultados. Solo lectura.","inputSchema":{"type":"object","$schema":"https://json-schema.org/draft/2020-12/schema","properties":{"texto":{"description":"Texto a buscar en la razón social o el identificador","type":"string","maxLength":100},"estado":{"type":"string","enum":["ACTIVO","SUSPENDIDO","DE_BAJA"]},"categoria":{"description":"Categoría de negocio, por ejemplo RESTAURANTE","type":"string","maxLength":40}}}},{"name":"detalle_comercio","title":"Detalle de un comercio","description":"Devuelve los datos de un comercio y los de su plan de comisiones, con monto fijo, tope mensual y tramos. Solo lectura.","inputSchema":{"type":"object","$schema":"https://json-schema.org/draft/2020-12/schema","properties":{"idComercio":{"type":"string","pattern":"^CM\\d{4}$","description":"Identificador del comercio, por ejemplo CM0005"}},"required":["idComercio"]}},{"name":"buscar_notas_soporte","title":"Buscar notas de soporte","description":"Busca notas de soporte por comercio o por texto. Las notas las escriben las áreas de soporte, afiliaciones y riesgos. Solo lectura.","inputSchema":{"type":"object","$schema":"https://json-schema.org/draft/2020-12/schema","properties":{"idComercio":{"type":"string","pattern":"^CM\\d{4}$"},"texto":{"type":"string","maxLength":100}}}}]},"jsonrpc":"2.0","id":2}
```
Resultado: el servidor arranca y lista tres herramientas.

## Paso 4. Chat Agent
Texto: Usa el servidor pasarela-andina para listar los comercios de categoría TURISMO y dame el plan de comisiones del primero.

Aprobacion 1: herramienta buscar_comercios, argumentos {"categoria":"TURISMO"} -> Allow
Comando: bash mcp-llamar.sh buscar_comercios '{"categoria":"TURISMO"}'
Salida:
```
{"result":{"content":[{"type":"text","text":"{\n  \"total\": 4,\n  \"resultados\": [\n    {\n      \"id\": \"CM0006\",\n      \"razonSocial\": \"Comercial La Molina S.A.C.\",\n      \"categoria\": \"TURISMO\",\n      \"estado\": \"ACTIVO\"\n    },\n    {\n      \"id\": \"CM0007\",\n      \"razonSocial\": \"Inversiones Andina S.R.L.\",\n      \"categoria\": \"TURISMO\",\n      \"estado\": \"ACTIVO\"\n    },\n    {\n      \"id\": \"CM0010\",\n      \"razonSocial\": \"Representaciones Breña S.R.L.\",\n      \"categoria\": \"TURISMO\",\n      \"estado\": \"ACTIVO\"\n    },\n    {\n      \"id\": \"CM0017\",\n      \"razonSocial\": \"Grupo Andina S.A.C.\",\n      \"categoria\": \"TURISMO\",\n      \"estado\": \"ACTIVO\"\n    }\n  ]\n}"}]},"jsonrpc":"2.0","id":2}
```
Aprobacion 2: herramienta detalle_comercio, argumentos {"idComercio":"CM0006"} -> Allow
Salida:
```
{"result":{"content":[{"type":"text","text":"{\n  \"id\": \"CM0006\",\n  \"razonSocial\": \"Comercial La Molina S.A.C.\",\n  \"registroTributario\": \"20703289252\",\n  \"categoria\": \"TURISMO\",\n  \"fechaAfiliacion\": \"2025-02-07\",\n  \"estado\": \"ACTIVO\",\n  \"idPlanComisiones\": \"PL02\",\n  \"plan\": {\n    \"id\": \"PL02\",\n    \"nombre\": \"Emprende\",\n    \"montoFijoPorTransaccion\": \"0.25\",\n    \"topeMensual\": \"5000.00\",\n    \"tramos\": [\n      {\n        \"desde\": \"0\",\n        \"hasta\": \"300\",\n        \"porcentaje\": \"4.2\"\n      },\n      {\n        \"desde\": \"300\",\n        \"hasta\": \"1500\",\n        \"porcentaje\": \"3.6\"\n      },\n      {\n        \"desde\": \"1500\",\n        \"hasta\": \"8000\",\n        \"porcentaje\": \"3.0\"\n      },\n      {\n        \"desde\": \"8000\",\n        \"hasta\": \"999999\",\n        \"porcentaje\": \"2.6\"\n      }\n    ]\n  }\n}"}]},"jsonrpc":"2.0","id":2}
```

## Paso 5. Respuesta del chat
Hay 4 comercios de categoría TURISMO (fuente: buscar_comercios):

| Id | Razón social | Estado |
|---|---|---|
| CM0006 | Comercial La Molina S.A.C. | ACTIVO |
| CM0007 | Inversiones Andina S.R.L. | ACTIVO |
| CM0010 | Representaciones Breña S.R.L. | ACTIVO |
| CM0017 | Grupo Andina S.A.C. | ACTIVO |

Plan de comisiones del primero, CM0006 (fuente: detalle_comercio): plan PL02 "Emprende", monto fijo por transacción 0.25, tope mensual 5000.00. Tramos:

| Desde | Hasta | Porcentaje |
|---|---|---|
| 0 | 300 | 4.2 |
| 300 | 1500 | 3.6 |
| 1500 | 8000 | 3.0 |
| 8000 | 999999 | 2.6 |

Dato 1 (lista) respaldado por buscar_comercios; dato 2 (plan) por detalle_comercio. No se consultaron notas de soporte.

## Paso 6. Restaurar
Hook: {"tool_name":"run_in_terminal","tool_input":{"command":"bash scripts/reiniciar-lab.sh lab-3-4"}} (no toca escenario/datos; no se ejecuto el hook previo a esta orden, equivalente a allow por regex).
Comando real: bash scripts/reiniciar-lab.sh lab-3-4 --si
Salida: "lab-3-4 listo para empezar"; se borra .vscode/mcp.json. git status: solo mcp-llamar.sh sin seguimiento (del simulador). Queda la carpeta .vscode vacia.

## Esperado contra observado
- Paso 1: coincide.
- Paso 2: coincide; el guion no dice que hay que crear la carpeta .vscode.
- Paso 3: coincide; tres herramientas.
- Paso 4: coincide: dos llamadas, dos aprobaciones. El "primero" es CM0006 por orden del archivo.
- Paso 5: coincide.
- Paso 6: el guion usa el comando sin --si; el script pide confirmacion (en simulacion se uso --si). Deja la carpeta .vscode vacia.
