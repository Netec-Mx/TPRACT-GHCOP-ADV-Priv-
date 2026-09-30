// Hook PreToolUse de Visual Studio Code. Impide que el agente cree, modifique o borre
// archivos dentro de escenario/datos/. Todo lo demas pasa sin cambios.
//
// Recibe por la entrada estandar el JSON de la llamada a la herramienta. Los campos
// cambian segun el entorno que ejecute al agente, asi que se leen las dos formas
// conocidas: tool_name y tool_input, o toolName y toolArgs.
//
// Para bloquear responde con permissionDecision deny, escribe el motivo en la salida de
// error y termina con codigo 2, que Visual Studio Code trata como bloqueo. Para permitir
// termina con codigo 0 sin escribir nada.
//
// Fuente del formato: https://code.visualstudio.com/docs/agent-customization/hooks y
// https://code.visualstudio.com/docs/agents/reference/hooks-reference, consultadas el
// 30 de septiembre de 2026.

'use strict';

const MENSAJE = 'Los datos del escenario estan protegidos y no se pueden modificar. ' +
    'Ningun laboratorio requiere cambiar los archivos de escenario/datos/.';

// Herramientas que escriben en disco, por su nombre. Se evalua por patron porque los
// nombres cambian entre versiones y entornos: editFiles, createFile, apply_patch,
// replace_string_in_file, create, edit, write, delete y otros.
const ESCRITURA = /(edit|write|creat|delet|remov|renam|move|replace|insert|patch|mkdir|notebook)/i;

// Herramientas que ejecutan comandos en una terminal.
const TERMINAL = /(terminal|shell|bash|powershell|execute|run_in|runcommand|command)/i;

// Ruta protegida, con barra normal o invertida.
const DATOS = /escenario[\\/]+datos([\\/]|$)/i;

// Comandos de terminal que modifican archivos cuando nombran la ruta protegida.
const COMANDO_QUE_ESCRIBE = new RegExp([
    '\\brm\\b', '\\bdel\\b', '\\berase\\b', '\\bmv\\b', '\\bmove\\b', '\\bren(ame)?\\b',
    '\\btee\\b', '\\btruncate\\b', '\\bunlink\\b', 'sed\\s+(-\\w*\\s+)*-i', 'perl\\s+-\\w*i',
    'Remove-Item', 'Set-Content', 'Add-Content', 'Out-File', 'Clear-Content', 'Move-Item',
    'Rename-Item', 'writeFile', 'appendFile', 'rmSync', 'unlinkSync',
].join('|'), 'i');

// Redireccion o copia cuyo destino esta dentro de la ruta protegida.
const DESTINO_EN_DATOS = /(>>?|\bcp\b[^|;&]*\s|\bcopy\b[^|;&]*\s|Copy-Item[^|;&]*\s)\s*["']?[^\s"'|;&]*escenario[\\/]+datos/i;

function textos(valor, acumulado) {
    if (typeof valor === 'string') acumulado.push(valor);
    else if (Array.isArray(valor)) valor.forEach((v) => textos(v, acumulado));
    else if (valor && typeof valor === 'object') Object.values(valor).forEach((v) => textos(v, acumulado));
    return acumulado;
}

function decidir(evento) {
    const herramienta = String(evento.tool_name || evento.toolName || '');
    let argumentos = evento.tool_input !== undefined ? evento.tool_input : evento.toolArgs;
    if (typeof argumentos === 'string') {
        try { argumentos = JSON.parse(argumentos); } catch { /* se revisa como texto */ }
    }
    const contenido = textos(argumentos, []);

    if (TERMINAL.test(herramienta)) {
        const comando = contenido.join(' ');
        if (DATOS.test(comando) && (COMANDO_QUE_ESCRIBE.test(comando) || DESTINO_EN_DATOS.test(comando))) {
            return 'deny';
        }
        return 'allow';
    }

    if (ESCRITURA.test(herramienta) && contenido.some((t) => DATOS.test(t))) {
        return 'deny';
    }
    return 'allow';
}

let entrada = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', (parte) => { entrada += parte; });
process.stdin.on('end', () => {
    let evento;
    try {
        evento = JSON.parse(entrada || '{}');
    } catch {
        // Una entrada ilegible no bloquea el trabajo del participante. Se deja rastro.
        process.stderr.write('proteger-datos-escenario: entrada ilegible, se permite la accion\n');
        process.exit(0);
    }

    if (decidir(evento) === 'deny') {
        process.stdout.write(JSON.stringify({
            hookSpecificOutput: {
                hookEventName: 'PreToolUse',
                permissionDecision: 'deny',
                permissionDecisionReason: MENSAJE,
            },
            permissionDecision: 'deny',
            permissionDecisionReason: MENSAJE,
        }) + '\n');
        process.stderr.write(MENSAJE + '\n');
        process.exit(2);
    }
    process.exit(0);
});
