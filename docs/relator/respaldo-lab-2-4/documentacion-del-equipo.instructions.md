---
name: 'Documentación del equipo'
description: 'Estructura, tono y forma de citar el código en los documentos Markdown que produce el equipo en los laboratorios'
applyTo: 'labs/**/entregables/**/*.md'
---

# Documentación del equipo

## Reglas

- Todo documento empieza con un título de nivel 1 y un párrafo de dos o tres oraciones que
  dice para qué sirve y quién lo lee.
- Cada afirmación sobre el código cita el archivo y la línea, con la forma
  `ruta/Archivo.java:123`.
- Las tablas llevan encabezado y no tienen celdas de más de una línea.
- Los bloques de código declaran su lenguaje.
- Español neutro, oraciones cortas, sin relleno.

## Qué no se hace nunca

- No se copia código completo al documento. Se cita la ubicación.
- No se documenta lo que dice un comentario del código sin comprobarlo en el código.
- No se usa HTML incrustado.

## Ejemplo

```markdown
# Cálculo del recargo por cuotas

Explica cómo se calcula el recargo por cuotas en la liquidación. Lo lee quien revisa
cambios en la clase de cálculo.

| Cuotas | Recargo | Ubicación |
|---|---|---|
| 1 | Sin recargo | `calculo/CalculadoraLiquidacion.java:169` |
```
