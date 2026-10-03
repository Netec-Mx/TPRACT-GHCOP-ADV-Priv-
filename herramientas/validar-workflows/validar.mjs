// Valida workflows de GitHub Actions con @actions/workflow-parser, el parser oficial que
// GitHub publica en github.com/actions/languageservices. Recibe las rutas de los archivos.
// Termina con codigo 0 si todos son validos y 1 si alguno tiene errores.

import { readFileSync } from 'node:fs';
import { register } from 'node:module';

register('./json-hook.mjs', import.meta.url);
const { parseWorkflow, convertWorkflowTemplate, NoOperationTraceWriter } = await import('@actions/workflow-parser');

const archivos = process.argv.slice(2);
if (archivos.length === 0) {
    console.error('Uso: node validar.mjs <workflow.yml> [...]');
    process.exit(2);
}

let fallas = 0;
for (const ruta of archivos) {
    const traza = new NoOperationTraceWriter();
    const resultado = parseWorkflow({ name: ruta, content: readFileSync(ruta, 'utf8') }, traza);
    let errores = resultado.context.errors.getErrors();
    if (errores.length === 0 && resultado.value) {
        const plantilla = await convertWorkflowTemplate(resultado.context, resultado.value);
        errores = (plantilla.errors || []).concat(resultado.context.errors.getErrors());
    }
    if (errores.length === 0) {
        console.log(`  [ OK ] ${ruta}`);
    } else {
        fallas++;
        console.log(`  [FALLA] ${ruta}`);
        for (const e of errores) console.log(`      ${e.Message || e.message || JSON.stringify(e)}`);
    }
}
process.exit(fallas === 0 ? 0 : 1);
