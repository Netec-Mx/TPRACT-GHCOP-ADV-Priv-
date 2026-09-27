# Servidor MCP local

Servidor de Model Context Protocol que corre como proceso local y se comunica por entrada
y salida estándar. Es el material del laboratorio 3.4.

## Qué hace

Expone tres herramientas de consulta sobre los comercios de Pasarela Andina.

| Herramienta | Qué devuelve | Parámetros |
|---|---|---|
| `buscar_comercios` | Hasta 20 comercios con su identificador, razón social, categoría y estado | `texto`, `estado`, `categoria`, todos opcionales |
| `detalle_comercio` | Los datos de un comercio y los de su plan de comisiones | `idComercio`, con formato `CM` y cuatro dígitos |
| `buscar_notas_soporte` | Notas de las áreas de soporte, afiliaciones y riesgos | `idComercio` y `texto`, opcionales |

Ninguna herramienta escribe, borra ni ejecuta nada.

## De dónde lee

| Datos | Archivo |
|---|---|
| Comercios | `escenario/datos/comercios.txt` |
| Planes de comisiones | `escenario/datos/planes.txt` |
| Notas de soporte | `mcp/datos/notas-soporte.json` |

Los archivos se leen en cada consulta y nunca se modifican.

## Cómo se ejecuta

Desde la raíz del repositorio:

```bash
node --permission --allow-fs-read=. mcp/servidor-local/servidor.js
```

`--permission` activa el modelo de permisos de Node. Con `--allow-fs-read=.` el proceso
solo puede leer archivos del repositorio. No puede escribir en disco, lanzar otros
procesos ni cargar complementos nativos. El servidor no usa red y no abre conexiones.

Lanzado a mano, el proceso queda esperando mensajes del protocolo en su entrada
estándar. Es lo esperado: quien lo usa es el cliente, en este caso Visual Studio Code.

## Dependencias

`@modelcontextprotocol/server` y `zod`, con versión exacta en `servidor-local/package.json`
y `servidor-local/package-lock.json`. Vienen instaladas en la máquina virtual. Si
`bash scripts/verificar-ambiente.sh` reporta que faltan, revisa
[`docs/00-setup-ambiente.md`](../docs/00-setup-ambiente.md), sección 2.3.
