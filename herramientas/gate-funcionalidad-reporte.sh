#!/usr/bin/env bash
#
# Gate de la funcionalidad del reporte y del pipeline. Lo invoca scripts/gates.sh dentro de
# la imagen de herramientas/Dockerfile, sin red, despues del gate de fugas.
#
# Uso: bash herramientas/gate-funcionalidad-reporte.sh <copia de construccion> <publicacion>
#   <copia de construccion>  repositorio de construccion ya compilado por los gates
#   <publicacion>            contenido generado por publicar-taller.sh, el punto de partida
#
# Comprueba:
#   1. Los workflows del repositorio de participantes y el de referencia son validos.
#   2. integracion-local.sh y el workflow base tienen los mismos pasos en el mismo orden.
#   3. verificar-reporte.sh dice que el reporte no existe sobre el punto de partida.
#   4. Los parches del reporte se aplican limpios, compilan y pasan sus pruebas.
#   5. La liquidacion conserva sus checksums y el reporte es identico entre stacks y al oraculo.
#   6. La conciliacion da exactamente el resultado registrado.
#   7. Con la correccion, la conciliacion da cero, los stacks siguen identicos y solo cambia
#      el checksum de la liquidacion de 2026-06, al valor registrado.
#
# Codigo de salida: 0 si todo pasa, 1 si algo falla.

set -u

construccion="$1"
publicacion="$2"
sol="$construccion/docs/relator/soluciones/funcionalidad-reporte"
oraculo="$sol/oraculo"
readonly PERIODOS="2026-04 2026-05 2026-06"

fallas=0
resultado() {
    if [ "$1" -eq 0 ]; then echo "  [ OK ] $2"; else echo "  [FALLA] $2"; fallas=$((fallas + 1)); fi
}
sha() { sha256sum "$1" | cut -d' ' -f1; }
esperado() { grep " $2\$" "$1" | cut -d' ' -f1; }

# 1. Workflows validos
cp -R /opt/validar-workflows/node_modules "$construccion/herramientas/validar-workflows/node_modules"
node "$construccion/herramientas/validar-workflows/validar.mjs" \
    "$construccion"/.github/workflows/*.yml "$sol/integracion-referencia.yml" > /tmp/workflows.log 2>&1
rc=$?; sed "s/^/  /" /tmp/workflows.log; resultado $rc "Workflows validos para @actions/workflow-parser"

# 2. Mismos pasos en el pipeline base y en el script local
pasos_workflow=$(grep -o "integracion-local.sh --paso [a-z-]*" "$construccion/.github/workflows/integracion-continua.yml" | awk '{print $3}')
pasos_script=$(bash "$construccion/scripts/integracion-local.sh" --listar)
[ "$pasos_workflow" = "$pasos_script" ]; resultado $? "integracion-local.sh y el workflow base tienen los mismos pasos en el mismo orden"

# 3. Sobre el punto de partida, el reporte no existe. La copia de construccion tiene el mismo
# escenario y ya esta compilada por comparar-escenarios.sh.
for stack in java dotnet; do
    (cd "$construccion" && bash scripts/verificar-reporte.sh "$stack" 2026-06 --sin-compilar > /tmp/vr.log 2>&1)
    [ $? -eq 3 ] && grep -q "todavía no existe" /tmp/vr.log
    resultado $? "verificar-reporte.sh $stack sobre el punto de partida dice que el reporte no existe"
done

# 4. Parches del reporte sobre una copia del punto de partida
copia=/tmp/solucion
rm -rf "$copia" && cp -R "$publicacion" "$copia"
(cd "$copia" && git init -q && git add -A && git -c user.name=g -c user.email=g@g commit -qm base)
bash "$sol/aplicar.sh" ambos "$copia" > /tmp/aplicar.log 2>&1
resultado $? "Los parches del reporte se aplican limpios sobre el punto de partida"
(cd "$copia/escenario/java" && mvn -o -B -q clean package > /tmp/sol-java.log 2>&1)
resultado $? "Java con el reporte compila y pasa sus pruebas"
(cd "$copia/escenario/dotnet" && dotnet build LiquidacionComercios -c Release > /tmp/sol-net.log 2>&1 \
    && dotnet test LiquidacionComercios.Pruebas >> /tmp/sol-net.log 2>&1)
resultado $? ".NET con el reporte compila y pasa sus pruebas"

ejecutar() {
    local stack="$1"; shift
    if [ "$stack" = "java" ]; then
        (cd "$copia/escenario/java" && java -jar target/liquidacion-comercios.jar "$@")
    else
        (cd "$copia/escenario/dotnet" && dotnet LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll "$@")
    fi
}

# 5. Liquidacion intacta, reporte identico entre stacks y al oraculo
for p in $PERIODOS; do
    for stack in java dotnet; do
        ejecutar "$stack" "$p" > "/tmp/liq-$stack-$p.txt" 2>/dev/null
        ejecutar "$stack" --reporte-medios "$p" > "/tmp/rep-$stack-$p.txt" 2>/dev/null
    done
    [ "$(sha /tmp/liq-java-$p.txt)" = "$(esperado "$oraculo/liquidacion.sha256" "$p")" ] \
        && [ "$(sha /tmp/liq-dotnet-$p.txt)" = "$(esperado "$oraculo/liquidacion.sha256" "$p")" ]
    resultado $? "Liquidacion de $p con el mismo checksum en los dos stacks"
    cmp -s "/tmp/rep-java-$p.txt" "/tmp/rep-dotnet-$p.txt" \
        && [ "$(sha /tmp/rep-java-$p.txt)" = "$(esperado "$oraculo/reporte.sha256" "reporte-$p.txt")" ]
    resultado $? "Reporte de $p identico entre stacks y al oraculo"
done
for stack in java dotnet; do
    (cd "$copia" && bash scripts/verificar-reporte.sh "$stack" 2026-06 --sin-compilar > /tmp/vr.log 2>&1)
    resultado $? "verificar-reporte.sh $stack sobre la solucion coincide"
done

# 6. Conciliacion con la liquidacion actual
conciliar() {
    (cd "$copia" && bash "$sol/conciliar.sh" "$1" --stack "$2" --sin-compilar)
}
while read -r periodo codigo diferencia; do
    case "$periodo" in ''|\#*) continue ;; esac
    for stack in java dotnet; do
        conciliar "$periodo" "$stack" > /tmp/conc.log 2>&1; rc=$?
        [ "$rc" -eq "$codigo" ] && grep -q "Diferencia *: S/ $diferencia\$" /tmp/conc.log
        resultado $? "Conciliacion $periodo $stack: codigo $codigo, diferencia $diferencia"
    done
done < "$oraculo/conciliacion-esperada.txt"

# 7. Mantencion correctiva aplicada despues del reporte
for stack in java dotnet; do
    git -C "$copia" apply "$sol/correccion-$stack.patch"; resultado $? "Correccion $stack se aplica limpia despues del reporte"
done
(cd "$copia/escenario/java" && mvn -o -B -q clean package > /tmp/cor-java.log 2>&1); resultado $? "Java corregido compila y pasa sus pruebas"
(cd "$copia/escenario/dotnet" && dotnet build LiquidacionComercios -c Release > /tmp/cor-net.log 2>&1 \
    && dotnet test LiquidacionComercios.Pruebas >> /tmp/cor-net.log 2>&1); resultado $? ".NET corregido compila y pasa sus pruebas"
for p in $PERIODOS; do
    for stack in java dotnet; do
        conciliar "$p" "$stack" > /tmp/conc.log 2>&1; resultado $? "Con la correccion, conciliacion $p $stack en cero"
        ejecutar "$stack" "$p" > "/tmp/cor-$stack-$p.txt" 2>/dev/null
    done
    cmp -s "/tmp/cor-java-$p.txt" "/tmp/cor-dotnet-$p.txt"; resultado $? "Con la correccion, liquidacion de $p identica entre stacks"
    [ "$(sha /tmp/cor-java-$p.txt)" = "$(esperado "$oraculo/liquidacion-corregida.sha256" "$p")" ]
    resultado $? "Con la correccion, checksum de la liquidacion de $p igual al registrado"
done

[ "$fallas" -eq 0 ]
