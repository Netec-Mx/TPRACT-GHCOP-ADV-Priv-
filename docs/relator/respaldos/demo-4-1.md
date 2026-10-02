segundos: 28

# Demo 4.1 simulada (Ask, solo lectura)

Compilacion previa: mvn -q -f escenario/java/pom.xml compile -> sin salida, exit 0 (target/classes creado; no estaba compilado). Hook run_in_terminal: exit 0.

## Paso 1
Texto: #file:escenario/java/src/main/java/pe/pasarelaandina/calculo/UtilidadesFecha.java Documenta en Markdown el método mesesEntre y da el resultado esperado para estos casos: del 2026-01-31 al 2026-02-28, del 2026-01-15 al 2026-02-15, del 2025-12-31 al 2026-06-01 y del 2026-03-10 al 2026-03-09.

Respuesta del chat (derivada leyendo el codigo):

### mesesEntre(Date desde, Date hasta)

Devuelve el numero de meses completos transcurridos entre dos fechas.

**Parametros**
- desde: fecha inicial.
- hasta: fecha final.

**Retorno**: int. Si alguna fecha es null devuelve 0.

**Comportamiento**
1. Obtiene un Calendar para cada fecha (con la configuracion regional fija, zona horaria del sistema).
2. Calcula (anio_hasta - anio_desde) * 12 + (mes_hasta - mes_desde).
3. Si el dia del mes de hasta es menor que el de desde, resta 1, porque el ultimo mes no se completo.
4. Si hasta es anterior a desde el resultado puede ser negativo; el metodo no lo corrige.

**Resultados esperados**

| Desde | Hasta | Calculo | Resultado esperado |
|---|---|---|---|
| 2026-01-31 | 2026-02-28 | 1 mes; dia 28 < 31, resta 1 | 0 |
| 2026-01-15 | 2026-02-15 | 1 mes; dia 15 no es < 15 | 1 |
| 2025-12-31 | 2026-06-01 | 6 meses; dia 1 < 31, resta 1 | 5 |
| 2026-03-10 | 2026-03-09 | 0 meses; dia 9 < 10, resta 1 | -1 |

## Paso 2
Salida real (jshell -q, copiada literalmente; el eco de jshell queda pegado sin saltos de linea):
```
jshell> var u = new pe.pasarelaandina.calculo.UtilidadesFecha()jshell> for (String[] c : new String[][]{{"2026-01-31","2026-02-28"},{"2026-01-15","2026-02-15"},{"2025-12-31","2026-06-01"},{"2026-03-10","2026-03-09"}}) System.out.println(c[0] + " -> " + c[1] + " = " + u.mesesEntre(u.parsearFecha(c[0]), u.parsearFecha(c[1])))2026-01-31 -> 2026-02-28 = 0
2026-01-15 -> 2026-02-15 = 1
2025-12-31 -> 2026-06-01 = 5
2026-03-10 -> 2026-03-09 = -1
jshell> 
```
Las cuatro lineas de resultado: 0, 1, 5, -1.

## Paso 3
Valores predichos por la documentacion: 0, 1, 5, -1. Valores reales: 0, 1, 5, -1. Coinciden los cuatro.

## Esperado contra observado
- Paso 1: el guion preve una descripcion y una tabla de cuatro resultados; coincide. En mi simulacion el modelo acierta todos los casos (el guion lo preve como posible: "El documento puede acertar los cuatro casos").
- Paso 2: el guion dice que jshell repite las lineas recibidas; observado: eco con prompts "jshell>" mezclados, las lineas de resultado quedan en lineas propias (las dos primeras empiezan tras el eco del for, en la misma linea que el eco; la linea de caso 1 va tras el eco). Resultados 0, 1, 5, -1 como dice el guion. Antes hubo que compilar (target no existia), el guion lo supone hecho.
- Paso 3: no hay discrepancia entre documento y ejecucion; no se vive el "mejor momento" del guion.
