#!/usr/bin/env bash
#
# Gate del capitulo 5. Lo invoca scripts/gates.sh dentro de la imagen de
# herramientas/Dockerfile, sin red, despues del gate de la funcionalidad del reporte.
#
# Uso: bash herramientas/gate-capitulo-5.sh <copia de construccion> <publicacion>
#
# Comprueba:
#   1. scripts/proyecto/entregar.sh corresponde a docs/relator/entregas/.
#   2. La solicitud del area comercial no trae decisiones del relator y la hoja de respuestas
#      cabe en una pagina.
#   3. Los hashes esperados publicados son los de la liquidacion actual.
#   4. El pipeline base esta en verde en el punto de partida con ambos stacks y con cada uno.
#   5. El recorrido de referencia aplicado en orden queda en rojo solo por la conciliacion de
#      junio, y con la correccion y el hash nuevo termina en verde con la conciliacion en cero.
#   6. ponerse-al-dia.sh corresponde a sus fuentes, no revela nada sin la clave y cada estado,
#      en los dos stacks, compila y pasa lo que debe pasar al inicio de su laboratorio.
#
# Codigo de salida: 0 si todo pasa, 1 si algo falla.

set -u

construccion="$1"
publicacion="$2"
sol="$construccion/docs/relator/soluciones"

fallas=0
resultado() {
    if [ "$1" -eq 0 ]; then echo "  [ OK ] $2"; else echo "  [FALLA] $2"; fallas=$((fallas + 1)); fi
}

# 1. Entregas codificadas al dia
(cd "$construccion" && bash herramientas/generar-entregas.sh --verificar > /tmp/entregas.log 2>&1)
resultado $? "scripts/proyecto/entregar.sh corresponde a sus fuentes"

# 2. La solicitud no decide nada que decide el relator
solicitud="$publicacion/docs/proyecto/backlog/solicitud-area-comercial.md"
! grep -i -E "pendiente|rechazad|de baja|suspendid|tope|inclusiv|l[ií]mite|redonde|centavo|liquidaci" "$solicitud" > /tmp/solicitud.log
resultado $? "La solicitud del area comercial no trae decisiones del relator"
palabras=$(wc -w < "$construccion/docs/relator/capitulo-5-hoja-de-respuestas.md")
[ "$palabras" -le 500 ]; resultado $? "La hoja de respuestas cabe en una pagina ($palabras palabras de 500)"

# 3. Hashes publicados contra el oraculo de la liquidacion
diff <(grep -v '^#' "$publicacion/scripts/integracion/liquidacion-esperada.sha256" | awk '{print $1, $2}') \
     <(awk '{print $1, $2}' "$sol/funcionalidad-reporte/oraculo/liquidacion.sha256") > /dev/null
resultado $? "Los hashes esperados publicados son los de la liquidacion actual"

# 4. Pipeline base sobre el punto de partida
base=/tmp/capitulo5-base
rm -rf "$base" && cp -R "$publicacion" "$base"
for stack in ambos java dotnet; do
    (cd "$base" && bash scripts/integracion-local.sh --stack "$stack" > "/tmp/base-$stack.log" 2>&1)
    resultado $? "Pipeline base en verde en el punto de partida, stack $stack"
done

# 5. Recorrido de referencia en orden
rec=/tmp/capitulo5-recorrido
rm -rf "$rec" && cp -R "$publicacion" "$rec"
(cd "$rec" && git init -q && git add -A && git -c user.name=g -c user.email=g@g commit -qm base)
bash "$sol/funcionalidad-reporte/aplicar.sh" ambos "$rec" > /tmp/rec-aplicar.log 2>&1 \
    && git -C "$rec" apply "$sol/lab-5-3/conciliacion-en-pipeline.patch"
resultado $? "El reporte y la conciliacion en el pipeline se aplican en orden"
(cd "$rec" && bash scripts/integracion-local.sh > /tmp/rec-rojo.log 2>&1); rc=$?
rojos=$(grep -c "^  \[FALLA\] .* no concilia" /tmp/rec-rojo.log)
[ "$rc" -ne 0 ] && [ "$rojos" -eq 2 ] \
    && grep -q "java 2026-06 no concilia: reporte menos liquidaciones = 2203 centavos" /tmp/rec-rojo.log \
    && grep -q "dotnet 2026-06 no concilia: reporte menos liquidaciones = 2203 centavos" /tmp/rec-rojo.log \
    && [ "$(grep -c '^  \[FALLA\]' /tmp/rec-rojo.log)" -eq 3 ]
resultado $? "Sin correccion, el pipeline queda en rojo solo por la conciliacion de junio, 22.03"
git -C "$rec" apply "$sol/funcionalidad-reporte/correccion-java.patch" "$sol/funcionalidad-reporte/correccion-dotnet.patch" \
    "$sol/lab-5-3/hash-junio.patch"
resultado $? "La correccion y el hash de junio se aplican en orden"
(cd "$rec" && bash scripts/integracion-local.sh > /tmp/rec-verde.log 2>&1); rc=$?
[ "$rc" -eq 0 ] && [ "$(grep -c '^  \[ OK \] .* concilia$' /tmp/rec-verde.log)" -eq 6 ]
resultado $? "Con la correccion, el pipeline termina en verde y concilia en los tres periodos y los dos stacks"

# 6. Ponerse al dia
(cd "$construccion" && bash herramientas/generar-ponerse-al-dia.sh --verificar > /tmp/pad.log 2>&1)
resultado $? "ponerse-al-dia.sh corresponde a sus fuentes"
clave="$(grep -o 'Clave de ponerse al día: `[^`]*`' "$construccion/docs/relator/capitulo-5-hoja-de-respuestas.md" | sed 's/.*`\(.*\)`/\1/')"
nuevo_estado() {
    rm -rf "$1" && cp -R "$publicacion" "$1"
    (cd "$1" && git init -q && git add -A && git -c user.name=g -c user.email=g@g commit -qm base && git tag punto-de-partida)
}
pad=/tmp/capitulo5-pad
nuevo_estado "$pad"
(cd "$pad" && bash scripts/proyecto/ponerse-al-dia.sh lab-5-4 java clave-equivocada --confirmo-descartar > /tmp/pad-mala.log 2>&1)
[ $? -eq 1 ] && [ -z "$(git -C "$pad" status --short)" ]
resultado $? "Sin la clave, ponerse-al-dia.sh no aplica nada"
for stack in java dotnet; do
    for lab in lab-5-2 lab-5-3 lab-5-4; do
        nuevo_estado "$pad"
        (
            cd "$pad" || exit 1
            bash scripts/proyecto/ponerse-al-dia.sh "$lab" "$stack" "$clave" --confirmo-descartar > /tmp/pad.log 2>&1 || exit 1
            [ "$(grep -v '^[[:space:]]*#' scripts/integracion/stack.txt | tail -1)" = "$stack" ] || exit 1
            case "$lab" in
                lab-5-2) [ -f docs/proyecto/historia-reporte-medios-de-pago.md ] \
                         && bash scripts/integracion-local.sh --paso equivalencia > /tmp/pad-p.log 2>&1 ;;
                lab-5-3) bash scripts/verificar-reporte.sh "$stack" 2026-06 > /tmp/pad-p.log 2>&1 \
                         && bash scripts/integracion-local.sh --paso equivalencia >> /tmp/pad-p.log 2>&1 ;;
                lab-5-4) bash scripts/integracion-local.sh > /tmp/pad-p.log 2>&1 \
                         && [ "$(grep -c '^  \[ OK \] .* concilia$' /tmp/pad-p.log)" -eq 3 ] ;;
            esac
        )
        resultado $? "ponerse-al-dia.sh deja el inicio del $lab con $stack y pasa lo que debe pasar"
    done
done

[ "$fallas" -eq 0 ]
