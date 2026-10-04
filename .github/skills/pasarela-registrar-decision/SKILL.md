---
name: pasarela-registrar-decision
description: 'Redacta una decisión de arquitectura nueva de Pasarela Andina con la plantilla del repositorio, a partir del contexto que entrega el usuario. Úsala cuando alguien pida registrar una decisión de arquitectura en docs/arquitectura/decisiones. No la uses si una skill de laboratorio indica otro archivo de salida.'
---

# Registrar una decisión de arquitectura

Las decisiones viven en [docs/arquitectura/decisiones/](../../../docs/arquitectura/decisiones/README.md),
una por archivo, con la [plantilla](../../../docs/arquitectura/decisiones/plantilla.md).

## Procedimiento

1. Lee la plantilla y el índice del directorio. El número de la decisión nueva es el
   siguiente al mayor del índice, con cuatro dígitos.
2. Usa el contexto que entregó el usuario. Si falta el problema que obliga a decidir o la
   decisión misma, pregúntalo en una sola pregunta y no escribas nada hasta tener la
   respuesta.
3. Lista al menos dos alternativas además de la elegida, cada una con su ventaja y su costo.
   Si el usuario no las dio, propónlas y márcalas como «propuesta del agente» para que las
   revise.
4. Escribe las consecuencias buenas y malas. Si no hay ninguna mala, dilo como pregunta
   abierta: casi toda decisión tiene un costo.
5. En «Verificación», propone un comando, una prueba o una revisión concreta.
6. Crea el archivo `NNNN-titulo-en-minusculas-con-guiones.md` en el directorio, con estado
   «Propuesta», y agrega su fila al índice del README.
7. Si la decisión mueve responsabilidades entre componentes, usa los nombres de dominio de
   [bian-mapeo.md](../../../docs/arquitectura/bian-mapeo.md).
8. Al terminar, muestra en el chat el contenido completo de la decisión y la fila que
   agregaste al índice, no un resumen. Escríbelo en el texto de tu respuesta; no basta con
   ejecutar `cat` ni con remitir a la vista de una herramienta.

## Límites

- Una decisión por archivo. No modifiques decisiones existentes salvo para marcar una como
  «Reemplazada por NNNN» si el usuario lo pide.
- No inventes hechos del contexto. Lo que no esté en lo que dio el usuario o en el
  repositorio va como pregunta abierta.
- No cambies código. Registrar una decisión no es aplicarla.
- Si una skill de laboratorio pide documentar decisiones en otro archivo, por ejemplo en
  `labs/**/entregables/`, esa skill manda y esta no se usa.
