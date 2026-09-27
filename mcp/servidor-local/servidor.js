// Servidor MCP local de consulta sobre los comercios de Pasarela Andina.
//
// Transporte por entrada y salida estandar, sin ninguna conexion de red. Solo lectura:
// las tres herramientas consultan archivos y ninguna escribe, borra ni ejecuta nada.
//
// Los comercios y los planes se leen de escenario/datos sin modificarlos. Las notas de
// soporte viven en mcp/datos, fuera del escenario, porque cualquier cambio en los datos
// del escenario altera los resultados de los laboratorios.
//
// Se lanza con el modelo de permisos de Node, que solo autoriza lectura del directorio
// del repositorio. La configuracion del cliente se explica en mcp/README.md.

import { readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { McpServer } from '@modelcontextprotocol/server';
import { StdioServerTransport } from '@modelcontextprotocol/server/stdio';
import * as z from 'zod/v4';

const raiz = join(dirname(fileURLToPath(import.meta.url)), '..', '..');
const RUTA_COMERCIOS = join(raiz, 'escenario', 'datos', 'comercios.txt');
const RUTA_PLANES = join(raiz, 'escenario', 'datos', 'planes.txt');
const RUTA_NOTAS = join(raiz, 'mcp', 'datos', 'notas-soporte.json');

const MAXIMO_RESULTADOS = 20;

// ---------------------------------------------------------------------------
// Lectura de datos
// ---------------------------------------------------------------------------

// Lee un archivo de texto separado por punto y coma, con encabezado, y devuelve una
// lista de objetos cuyas claves son los nombres del encabezado.
function leerTabla(ruta) {
    const lineas = readFileSync(ruta, 'utf8').split(/\r?\n/).filter((l) => l.trim() !== '');
    const columnas = lineas[0].split(';');
    return lineas.slice(1).map((linea) => {
        const valores = linea.split(';');
        return Object.fromEntries(columnas.map((c, i) => [c, valores[i] ?? '']));
    });
}

function leerComercios() {
    return leerTabla(RUTA_COMERCIOS);
}

function leerPlanes() {
    return leerTabla(RUTA_PLANES).map((plan) => ({
        id: plan.id,
        nombre: plan.nombre,
        montoFijoPorTransaccion: plan.montoFijoPorTransaccion,
        topeMensual: plan.topeMensual,
        tramos: plan.tramos.split('|').map((tramo) => {
            const [desde, hasta, porcentaje] = tramo.split(':');
            return { desde, hasta, porcentaje };
        }),
    }));
}

function leerNotas() {
    return JSON.parse(readFileSync(RUTA_NOTAS, 'utf8'));
}

function contiene(texto, buscado) {
    return texto.toLowerCase().includes(buscado.toLowerCase());
}

function respuesta(datos) {
    return { content: [{ type: 'text', text: JSON.stringify(datos, null, 2) }] };
}

function error(mensaje) {
    return { content: [{ type: 'text', text: mensaje }], isError: true };
}

// ---------------------------------------------------------------------------
// Servidor y herramientas
// ---------------------------------------------------------------------------

const servidor = new McpServer({ name: 'pasarela-andina-consulta', version: '1.0.0' });

servidor.registerTool(
    'buscar_comercios',
    {
        title: 'Buscar comercios',
        description:
            'Busca comercios afiliados por texto en la razón social o el identificador, y ' +
            'opcionalmente por estado o categoría. Devuelve como máximo 20 resultados. Solo lectura.',
        inputSchema: z.object({
            texto: z.string().max(100).optional().describe('Texto a buscar en la razón social o el identificador'),
            estado: z.enum(['ACTIVO', 'SUSPENDIDO', 'DE_BAJA']).optional(),
            categoria: z.string().max(40).optional().describe('Categoría de negocio, por ejemplo RESTAURANTE'),
        }),
    },
    async ({ texto, estado, categoria }) => {
        const encontrados = leerComercios()
            .filter((c) => !texto || contiene(c.razonSocial, texto) || contiene(c.id, texto))
            .filter((c) => !estado || c.estado === estado)
            .filter((c) => !categoria || c.categoria === categoria.toUpperCase())
            .map((c) => ({ id: c.id, razonSocial: c.razonSocial, categoria: c.categoria, estado: c.estado }));
        return respuesta({
            total: encontrados.length,
            resultados: encontrados.slice(0, MAXIMO_RESULTADOS),
        });
    },
);

servidor.registerTool(
    'detalle_comercio',
    {
        title: 'Detalle de un comercio',
        description:
            'Devuelve los datos de un comercio y los de su plan de comisiones, con monto fijo, ' +
            'tope mensual y tramos. Solo lectura.',
        inputSchema: z.object({
            idComercio: z.string().regex(/^CM\d{4}$/).describe('Identificador del comercio, por ejemplo CM0005'),
        }),
    },
    async ({ idComercio }) => {
        const comercio = leerComercios().find((c) => c.id === idComercio);
        if (!comercio) {
            return error(`No existe el comercio ${idComercio}.`);
        }
        const plan = leerPlanes().find((p) => p.id === comercio.idPlanComisiones) ?? null;
        return respuesta({ ...comercio, plan });
    },
);

servidor.registerTool(
    'buscar_notas_soporte',
    {
        title: 'Buscar notas de soporte',
        description:
            'Busca notas de soporte por comercio o por texto. Las notas las escriben las áreas ' +
            'de soporte, afiliaciones y riesgos. Solo lectura.',
        inputSchema: z.object({
            idComercio: z.string().regex(/^CM\d{4}$/).optional(),
            texto: z.string().max(100).optional(),
        }),
    },
    async ({ idComercio, texto }) => {
        const notas = leerNotas()
            .filter((n) => !idComercio || n.idComercio === idComercio)
            .filter((n) => !texto || contiene(n.texto, texto));
        return respuesta({ total: notas.length, notas: notas.slice(0, MAXIMO_RESULTADOS) });
    },
);

await servidor.connect(new StdioServerTransport());
