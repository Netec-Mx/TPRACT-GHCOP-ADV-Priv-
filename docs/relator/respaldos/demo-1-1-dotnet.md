> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes. Se grabó en la CLI, no en Visual Studio Code: el modo Ask se reprodujo con una
> sesión sin permiso de edición, y el archivo abierto en el editor se adjuntó al pedido como
> contexto, que es lo que hace el editor. Es la versión .NET de la demostración: los pedidos
> son los del guion con la ruta del archivo `.cs` y el nombre del método en .NET.

# Demostración 1.1. El pedido pobre y el pedido bueno (escenario .NET)

Archivo abierto: `escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporte.cs`.

## Paso 1 (Ask, conversación 1, FormateadorReporte.cs abierto en el editor)

Texto escrito:

```
Mejora este código.
```

Copilot leyó el archivo y respondió:

> Tu pedido es demasiado amplio, y las reglas del repositorio me impiden modificar el código de `escenario/` por iniciativa propia. No he cambiado nada.
>
> Estas son las mejoras posibles que veo en `FormateadorReporte.cs`. Todas tocan el código del laboratorio:
>
> 1. **Constantes y duplicación:** el formato de columnas `"  {0,-12} {1,12}..."` aparece dos veces, y `"\n"` y `"S/ "` se repiten por todo el archivo.
> 2. **Tipos:** se usa `double` para dinero. Cambiarlo a `decimal` exige tu aprobación explícita, porque afecta el redondeo.
> 3. **Legibilidad:** se podría usar `AppendLine` o interpolación en lugar de tantos `Append` encadenados.
> 4. **Robustez:** no se valida `null` ni `maximoLineas` negativo.
> 5. **Paridad con Java:** cualquier cambio debe replicarse en el escenario Java y comprobarse con `bash scripts/comparar-escenarios.sh`.
>
> ¿Cuáles de estos puntos quieres que aplique? Si prefieres, puedo proponerte un plan antes de editar.

## Paso 2 (Ask, conversación 2)

Texto escrito:

```
Objetivo: identificar las dos mejoras de legibilidad más útiles en FormatearDetalle.
Contexto: #file:escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporte.cs
Restricciones: no cambies el comportamiento, no cambies tipos de datos, no propongas bibliotecas nuevas, no modifiques archivos.
Salida: una tabla con mejora, líneas afectadas y riesgo de cambiar la salida.
```

Copilot leyó el archivo y respondió:

> Líneas 50–83 de `FormatearDetalle`:
>
> | # | Mejora | Líneas | Riesgo de cambiar la salida |
> |---|--------|--------|-----------------------------|
> | 1 | Reemplazar la plantilla de formato duplicada (`"  {0,-12} {1,12} {2,10} {3,10} {4,8}\n"`) por una variable local (o constante privada) usada en el encabezado y en cada fila. Así el ancho de columnas queda en un solo lugar. | 59–60 y 74–79 | Bajo: el texto es idéntico. Hay que copiarlo exactamente, incluido el `\n` y los anchos. |
> | 2 | Reemplazar el contador manual `impresas` y el `break` por un recorrido más claro. Por ejemplo, un `for` con índice que compara `i >= maximoLineas`, y el resto sale de `Detalle.Count - i`. Se quita el `impresas++` al final del bucle. | 62–81 | Medio: hay que conservar el caso `maximoLineas <= 0` (imprime "... y N lineas mas" sin filas) y el caso en que `Detalle.Count == maximoLineas` (no imprime el aviso). Un error de uno cambiaría el conteo. |
>
> Observaciones fuera de alcance (no se tocaron):
> - Las cadenas encadenadas con `Append("\n")` repiten el separador. Es un patrón compartido con `FormatearResumenGeneral`, y unificarlo cruza métodos.
> - No modifiqué ningún archivo.

Los números de línea de la tabla no coinciden con el archivo. `FormatearDetalle` va de la
línea 60 a la 93. La plantilla de formato está en las líneas 69 y 82, y el bucle en las 72 a 89.

## Paso 3 (presentador)

Sin texto escrito. Se comparan las dos respuestas y se pregunta a la sala cuál usarían en un
pull request.

## Esperado contra observado

- Paso 1: el guion espera una respuesta larga y dispersa. Observado una lista de cinco
  mejoras de todo tipo, con el cambio de `double` a `decimal` entre ellas, y una pregunta de
  vuelta. Es más corta que lo esperado, porque las instrucciones del repositorio le impiden
  tocar el escenario. Úsela para preguntar si dos personas obtendrían lo mismo.
- Paso 2: coincide. Una tabla de dos filas con rangos de líneas y riesgo. Los rangos están
  corridos unas diez líneas. Si pasa en clase, muéstrelo abriendo el archivo: es la razón de
  verificar las citas.
- Paso 3: no aplica respuesta del modelo.
