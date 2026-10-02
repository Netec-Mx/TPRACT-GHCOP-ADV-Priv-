# 4.3 Buenas prácticas para preparar documentación compatible con Confluence

| Campo | Valor |
|---|---|
| Capítulo y sesión | Capítulo 4, sesión 4 |
| Duración | 20 minutos de exposición |
| Demostración | No tiene |
| Artefactos que se proyectan | `.github/agents/documentador.agent.md`, sección «Formato» |

## La idea en una frase

Confluence no es un visor de Markdown, así que el documento que sobrevive al traslado es el
que usa solo lo que el editor reconoce, y lo que no sobrevive se dice por escrito.

## Contenido

### El problema

El equipo escribe la documentación técnica en Markdown, en el repositorio, porque se versiona
y se revisa con el código. Pero la documentación que lee el resto del banco vive en
Confluence. En algún momento hay que pasar de un lado al otro, y ese traslado es donde la
documentación generada se rompe sin que nadie lo note: una tabla que se desarma, un enlace
que apunta a un archivo que en Confluence no existe, un bloque que pierde el formato.

### Lo que dice la documentación de Confluence, hoy

Antes de dar recomendaciones conviene saber qué hace el editor, según la documentación de
Atlassian para Confluence Cloud consultada para este material. Son tres hechos, y los tres
sorprenden a quien da por sentado que Confluence lee Markdown.

**El editor reconoce atajos de Markdown mientras se escribe.** Negrita, cursiva, tachado,
código en línea, encabezados del uno al seis, listas numeradas y con viñetas, citas, bloques
de código, separadores y enlaces. Al escribir esos marcadores, el editor los convierte en el
formato correspondiente. Las tablas, el HTML, las notas al pie y las imágenes no están en esa
lista.

**La inserción de Markdown como bloque es del editor anterior.** La opción de insertar
contenido en Markdown existe en el editor heredado de Confluence. La documentación indica que
el editor nuevo no admite lenguaje de marcado, y que el contenido insertado se convierte y
después ya no se puede editar como Markdown.

**La importación nativa no incluye archivos Markdown.** La documentación de importación
lista documentos de Word, de Google Docs y de OneDrive. Para otros formatos remite a
aplicaciones del Marketplace, y menciona que el texto con formato básico se puede pegar
directamente en el editor.

Dos advertencias para la sala. La primera, que esto es de Confluence Cloud. Si el banco usa
Confluence Data Center, el comportamiento puede ser distinto y hay que verificarlo en su
versión. La segunda, que estas páginas cambian, como todo lo de este taller. La
recomendación es probar con una página real del espacio del equipo antes de adoptar un
formato.

### Markdown que sobrevive

Con lo anterior, la regla práctica es escribir en el repositorio usando solo lo que el
editor reconoce de forma nativa, y tratar todo lo demás como algo que se va a perder o que
hay que rehacer a mano.

- **Encabezados, listas, negrita, cursiva y código en línea.** Están en los atajos. Son la
  base segura.
- **Bloques de código con el lenguaje declarado.** El bloque está en los atajos. Declarar el
  lenguaje en el repositorio no cuesta nada y facilita elegirlo en Confluence.
- **Tablas simples.** No están entre los atajos, así que conviene tratarlas como un riesgo.
  Si se usan, que sean simples: una línea por celda, sin tablas dentro de tablas. Después del
  traslado, se revisan.
- **Enlaces absolutos.** Un enlace relativo a otro archivo del repositorio funciona en
  GitHub y no apunta a nada en Confluence. Si el destino importa, se enlaza con la URL
  completa.
- **Nada de HTML incrustado, notas al pie ni diagramas que dependan de extensiones.** No
  están en la lista de lo que el editor reconoce. Un diagrama se exporta como imagen o se
  rehace con las herramientas del espacio.

El agente Documentador del repositorio ya tiene esta regla escrita en su sección de formato:
Markdown con encabezados, tablas y bloques de código, sin HTML incrustado, y si el documento
va a Confluence, sin notas al pie, tablas anidadas ni diagramas que dependan de extensiones.
Es un ejemplo de lo que el capítulo 2 llamó criterio del equipo versionado.

### Dónde vive la versión maestra

Esta es la decisión que más evita problemas, y conviene que la sala la discuta.

Si la documentación se edita en los dos lados, en pocas semanas hay dos versiones distintas
y ninguna es confiable. Lo recomendable es elegir una como maestra. Para documentación que
describe código, la maestra es la del repositorio, porque se revisa junto con el cambio que
la hace necesaria. Confluence recibe una copia publicada, con una línea al inicio que dice
dónde está la fuente y de qué versión salió.

Para documentación que no depende del código, como un procedimiento operativo o una página
para un área de negocio, puede ser al revés. Lo importante es que el equipo lo decida y lo
escriba.

### Lo que se pierde, por escrito

El paso 3 del laboratorio 4.4 pide preparar una copia del documento para Confluence y
terminarla con una sección que liste qué se perdió en el traslado. Esa lista es la buena
práctica más útil del subtema.

Un documento trasladado sin esa lista parece completo. Con la lista, quien lo lee sabe que
la tabla de la sección tres se simplificó o que los enlaces a archivos del repositorio se
reemplazaron. Y quien mantiene el documento sabe qué revisar en el próximo traslado.

### Cómo se pide al agente

Un pedido que funciona tiene cuatro partes, en la línea del capítulo 1. El objetivo, que es
preparar una copia para Confluence. El contexto, que es el documento de origen. Las
restricciones, que son no modificar el original y usar solo el Markdown que el editor
reconoce. Y la salida esperada, que es la copia más la lista de lo que se perdió.

Lo que no conviene pedir es «conviértelo a formato de Confluence». El agente va a producir
algo con aspecto de Confluence, por ejemplo lenguaje de marcado wiki, que el editor nuevo no
admite. Se pide Markdown simple y se verifica pegándolo.

## Cómo se conecta

- **Demostración.** No tiene.
- **Laboratorio.** En el [4.4](../../../labs/cap4/lab-4-4-documentacion/README.md), el paso 3
  prepara la copia para Confluence de uno de los documentos y lista lo que se perdió.
- **Hilo del taller.** El agente produce el documento; la persona decide dónde vive, qué
  formato sobrevive y qué se perdió.

## Preguntas probables

**«¿Hay alguna forma de sincronizar el repositorio con Confluence?»**
La documentación de Atlassian remite a aplicaciones del Marketplace para formatos que la
importación nativa no cubre. Evaluarlas es una decisión del banco, y no se recomienda una en
el taller.

**«¿Y si pego el Markdown tal cual?»**
Según la documentación, el texto con formato básico se puede pegar directamente. Lo que no
está en la lista de atajos hay que revisarlo a mano después de pegar. La prueba con una
página real es la que manda.

## Fuentes

| Afirmación | Fuente | Consultada |
|---|---|---|
| Atajos de Markdown que reconoce el editor y su lista | https://support.atlassian.com/confluence-cloud/docs/available-markdown-commands/ | 2 de octubre de 2026 |
| Inserción de Markdown solo en el editor heredado, el editor nuevo no admite marcado, el contenido se convierte y no se edita como Markdown | https://support.atlassian.com/confluence-cloud/docs/insert-confluence-wiki-markup/ | 2 de octubre de 2026 |
| Importación nativa de Word, Google Docs y OneDrive, aplicaciones del Marketplace, pegar texto con formato básico | https://support.atlassian.com/confluence-cloud/docs/import-content-into-confluence-cloud/ | 2 de octubre de 2026 |
