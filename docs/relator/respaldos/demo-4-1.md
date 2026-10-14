> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes. Se grabó en la CLI, no en Visual Studio Code: el modo Ask se reprodujo con una
> sesión sin permiso de edición, y el texto con `#file:` se envió tal cual. La compilación y
> `jshell` se ejecutaron en Git Bash de la misma máquina.

# Demo 4.1. La documentación contra la ejecución (escenario Java)

Antes de empezar: `mvn -q -f escenario/java/pom.xml compile`, sin salida, código de salida 0.

## Paso 1

Escrito: `#file:escenario/java/src/main/java/pe/pasarelaandina/calculo/UtilidadesFecha.java Documenta en Markdown el método mesesEntre y da el resultado esperado para estos casos: del 2026-01-31 al 2026-02-28, del 2026-01-15 al 2026-02-15, del 2025-12-31 al 2026-06-01 y del 2026-03-10 al 2026-03-09.`

Copilot leyó `UtilidadesFecha.java` y respondió:

> # `UtilidadesFecha.mesesEntre`
>
> **Firma:** `public int mesesEntre(Date desde, Date hasta)`
>
> ## Qué hace
> Calcula los meses completos transcurridos entre dos fechas.
>
> ## Algoritmo
> 1. Si `desde` o `hasta` es `null`, devuelve `0`.
> 2. Convierte ambas fechas a `Calendar` con `calendarioDeTrabajo()`. Usa la región fija `ConfiguracionRegional.REGION_DE_SALIDA` y la zona horaria del sistema.
> 3. Calcula `total = (añoHasta − añoDesde) × 12 + (mesHasta − mesDesde)`.
> 4. Si el día del mes de `hasta` es menor que el de `desde`, resta 1 a `total`.
> 5. Devuelve `total`.
>
> ## Comportamiento a tener en cuenta
> - Solo compara año, mes y día del mes. Ignora la hora.
> - No hay regla de fin de mes. Un 31 que llega a un mes más corto no cuenta como mes completo.
> - Si `hasta` es anterior a `desde`, el resultado puede ser negativo. No se valida el orden.
> - Como usa la zona horaria del sistema, el día calendario depende de ella.
>
> ## Resultados esperados
>
> | Desde | Hasta | Cálculo | Resultado |
> |---|---|---|---|
> | 2026-01-31 | 2026-02-28 | 0×12 + 1 = 1; día 28 < 31 → 1 − 1 | **0** |
> | 2026-01-15 | 2026-02-15 | 0×12 + 1 = 1; día 15 no es menor que 15 | **1** |
> | 2025-12-31 | 2026-06-01 | 1×12 + (6 − 12) = 6; día 1 < 31 → 6 − 1 | **5** |
> | 2026-03-10 | 2026-03-09 | 0×12 + 0 = 0; día 9 < 10 → 0 − 1 | **−1** |
>
> ## Observaciones
> - **Caso 1:** el 28 de febrero es el último día del mes. Según una convención de fin de mes sería 1 mes, pero el código devuelve 0.
> - **Caso 4:** devuelve `-1` porque las fechas están invertidas.
>
> No modifiqué ningún archivo. Esta documentación es solo la respuesta; no la guardé en el repositorio.

## Paso 2

Salida de `jshell`, copiada tal cual. El eco de `jshell` queda pegado a la primera línea de
resultado:

{% raw %}
```
jshell> var u = new pe.pasarelaandina.calculo.UtilidadesFecha();jshell> for (String[] c : new String[][]{{"2026-01-31","2026-02-28"},{"2026-01-15","2026-02-15"},{"2025-12-31",2026-01-31 -> 2026-02-28 = 0
2026-01-15 -> 2026-02-15 = 1
2025-12-31 -> 2026-06-01 = 5
2026-03-10 -> 2026-03-09 = -1
jshell>
```
{% endraw %}

Las cuatro líneas de resultado: 0, 1, 5 y -1.

## Paso 3

Documento: 0, 1, 5 y -1. Ejecución: 0, 1, 5 y -1. Coinciden los cuatro.

## Esperado contra observado

- Paso 1: coincide. Una descripción del método y una tabla de cuatro resultados. Acertó los
  cuatro casos, que el guion prevé como posible.
- Paso 2: coincide, 0, 1, 5 y -1.
- Paso 3: no hay discrepancia. Use la pregunta del guion: cómo lo sabrían sin haber ejecutado
  nada.
