// Hook PreToolUse de Visual Studio Code y de Copilot CLI. Impide que el agente cree,
// modifique o borre archivos dentro de escenario/datos/. Decide por el destino: un documento
// fuera de esa carpeta que cita su ruta, o un comando que solo la lee, pasan sin cambios.
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

const MENSAJE = 'Los datos del escenario están protegidos y no se pueden modificar. ' +
    'Ningún laboratorio requiere cambiar los archivos de escenario/datos/.';

// Herramientas que escriben en disco, por su nombre. Se evalua por patron porque los
// nombres cambian entre versiones y entornos: editFiles, createFile, apply_patch,
// replace_string_in_file, create, edit, str_replace, write, delete y otros.
const ESCRITURA = /(edit|write|creat|delet|remov|renam|move|replace|insert|patch|mkdir|notebook)/i;
// Herramientas que ejecutan comandos en una terminal.
const TERMINAL = /(terminal|shell|bash|powershell|execute|run_in|runcommand|command)/i;
// Ruta protegida, con barra normal o invertida.
const DATOS = /escenario[\\/]+datos([\\/]|$)/i;
// Argumentos que nombran el archivo de destino. El contenido del archivo no se revisa: un
// documento fuera de escenario/datos/ puede citar esa ruta.
const CLAVE_RUTA = /^(path|paths|file|files|filepath|file_path|filename|file_name|uri|target|destination|dest|newpath|new_path|oldpath|old_path|source|from|to|dir|directory)$/i;
// Dentro de un parche, las lineas que nombran archivos.
const RUTA_EN_PARCHE = /^(?:\*\*\* (?:Add|Update|Delete) File:|\*\*\* Move to:|\+\+\+ |--- |diff --git )\s*(.+)$/gm;
// Comandos de terminal que modifican archivos cuando nombran la ruta protegida en el mismo
// tramo del comando.
const COMANDO_QUE_ESCRIBE = new RegExp([
    '\\brm\\b', '\\brmdir\\b', '\\bdel\\b', '\\berase\\b', '\\bmv\\b', '\\bmove\\b', '\\bren(ame)?\\b',
    '\\btee\\b', '\\btruncate\\b', '\\bunlink\\b', '\\btouch\\b', '\\bdd\\b', 'sed\\s+(-\\w*\\s+)*-i',
    'perl\\s+-\\w*i', 'Remove-Item', 'Set-Content', 'Add-Content', 'Out-File', 'Clear-Content',
    'Move-Item', 'Rename-Item', 'New-Item', 'writeFile', 'appendFile', 'rmSync', 'unlinkSync',
].join('|'), 'i');
// Redireccion cuyo destino esta dentro de la ruta protegida.
const REDIRECCION_A_DATOS = /(^|[^<\d&])\d?>>?\s*["']?[^\s"'|;&]*escenario[\\/]+datos/i;
// Copia cuyo ultimo argumento, el destino, esta dentro de la ruta protegida.
const COPIA_A_DATOS = /\b(cp|copy|Copy-Item|rsync|install)\b[^|;&]*\s["']?[^\s"'|;&]*escenario[\\/]+datos[^\s"'|;&]*["']?\s*$/i;

// Reune los textos de un valor, con o sin filtrar por el nombre del argumento.
function textos(valor, acumulado, soloRutas, clave) {
    if (typeof valor === 'string') {
        if (!soloRutas || CLAVE_RUTA.test(clave || '')) acumulado.push(valor);
        if (soloRutas) {
            let m;
            RUTA_EN_PARCHE.lastIndex = 0;
            while ((m = RUTA_EN_PARCHE.exec(valor)) !== null) acumulado.push(m[1]);
        }
    } else if (Array.isArray(valor)) {
        valor.forEach((v) => textos(v, acumulado, soloRutas, clave));
    } else if (valor && typeof valor === 'object') {
        Object.entries(valor).forEach(([k, v]) => textos(v, acumulado, soloRutas, k));
    }
    return acumulado;
}

// Separa un comando en tramos por ;, &&, ||, | y saltos de linea, fuera de comillas.
function tramos(comando) {
    const partes = [];
    let actual = '';
    let comilla = '';
    for (let i = 0; i < comando.length; i++) {
        const c = comando[i];
        if (comilla) {
            actual += c;
            if (c === comilla) comilla = '';
        } else if (c === '"' || c === "'") {
            comilla = c;
            actual += c;
        } else if (c === ';' || c === '\n' || c === '|' || c === '&') {
            if (actual.trim()) partes.push(actual.trim());
            actual = '';
            while (comando[i + 1] === '|' || comando[i + 1] === '&') i++;
        } else {
            actual += c;
        }
    }
    if (actual.trim()) partes.push(actual.trim());
    return partes;
}

function decidir(evento) {
    const herramienta = String(evento.tool_name || evento.toolName || '');
    let argumentos = evento.tool_input !== undefined ? evento.tool_input : evento.toolArgs;
    if (typeof argumentos === 'string') {
        try { argumentos = JSON.parse(argumentos); } catch { /* se revisa como texto */ }
    }
    if (TERMINAL.test(herramienta)) {
        const comando = textos(argumentos, [], false).join('\n');
        const escribe = tramos(comando).some((t) => DATOS.test(t)
            && (COMANDO_QUE_ESCRIBE.test(t) || REDIRECCION_A_DATOS.test(t) || COPIA_A_DATOS.test(t)));
        return escribe ? 'deny' : 'allow';
    }
    if (ESCRITURA.test(herramienta)) {
        // Si la herramienta no trae argumentos con nombre, se revisa todo como antes.
        const rutas = typeof argumentos === 'string' ? [argumentos] : textos(argumentos, [], true);
        if (rutas.some((t) => DATOS.test(t))) return 'deny';
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
