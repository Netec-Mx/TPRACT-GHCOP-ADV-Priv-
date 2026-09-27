---
título: Plantilla de caso de uso para un servidor MCP, para aprobación de seguridad
uso: |
  Copia este archivo y complétalo para cada servidor MCP que tu equipo quiera habilitar
  en el editor. Sirve como el documento que un área de seguridad revisa para aprobar o
  rechazar el uso del servidor.
---

# Caso de uso: COMPLETAR nombre del servidor MCP

## 1. Datos que expone

Qué archivos, tablas o servicios lee. Qué campos devuelve cada herramienta. Marca cuáles
campos son sensibles (datos personales, montos, credenciales, secretos) y si alguno
debería enmascararse antes de llegar al contexto del chat.

| Fuente de datos | Ruta o servicio | Campos que expone | ¿Sensible? |
|---|---|---|---|
| COMPLETAR | COMPLETAR | COMPLETAR | COMPLETAR |

## 2. Herramientas que registra

| Herramienta | Qué devuelve | Parámetros | ¿Escribe o ejecuta algo? |
|---|---|---|---|
| COMPLETAR | COMPLETAR | COMPLETAR | COMPLETAR |

Si alguna herramienta escribe, borra o ejecuta algo, esta plantilla no alcanza: ese caso
necesita una revisión de seguridad más profunda que la de un servidor de solo lectura.

## 3. Riesgos

Evalúa al menos estos tres. Cada uno con su mitigación, o con la declaración explícita de
que no está mitigado y por qué se acepta así.

- **Inyección indirecta de instrucciones.** El texto que devuelve una herramienta puede
  contener instrucciones dirigidas al agente, no al usuario (por ejemplo, dentro de una
  nota de soporte o un comentario de código). ¿Qué le impide al agente ejecutarlas como si
  vinieran de la persona que preguntó?
- **Ejecución de herramientas sin revisión humana.** ¿Cada llamada a una herramienta pasa
  por una aprobación de quien usa el chat, o el editor las ejecuta en silencio?
- **Contenido que no debería llegar al contexto del modelo.** ¿Alguna de las fuentes que
  lee el servidor podría traer datos que la política de la empresa prohíbe enviar a un
  proveedor de modelos externo?

## 4. Por qué es defendible

Qué controles técnicos sostienen el caso de uso: alcance de solo lectura, restricciones
del sistema operativo o del runtime sobre qué puede leer el proceso, ausencia de acceso a
red, aprobación de cada llamada por parte de quien usa el chat. Qué tendría que cambiar en
el servidor para que este caso de uso deje de ser defendible con los mismos controles.

<!--
Origen: generalización de
.github/skills/lab-3-4-paso-4-documentar-caso-de-uso/SKILL.md y de mcp/README.md del
taller de GitHub Copilot, que documentaban un servidor MCP local de solo lectura sobre los
datos de Pasarela Andina. La estructura en cuatro secciones (datos, herramientas, riesgos,
por qué es defendible) no depende de ese dominio: es la misma pregunta que le hará
cualquier área de seguridad a cualquier servidor MCP nuevo.
-->
