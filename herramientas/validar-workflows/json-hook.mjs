// El paquete importa su esquema JSON sin atributo de importacion, como esperan los
// empaquetadores. Node exige type: json. Este hook lo agrega solo a los archivos .json.
export async function load(url, context, nextLoad) {
    if (url.endsWith('.json')) {
        return nextLoad(url, { ...context, importAttributes: { ...context.importAttributes, type: 'json' } });
    }
    return nextLoad(url, context);
}
