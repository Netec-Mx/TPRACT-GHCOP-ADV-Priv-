# Troubleshooting

> **Archivo marcador.** Este documento contiene solo el índice de secciones previsto.
> Su contenido se redacta en **SPEC-007**.

Problemas conocidos durante el taller y su solución. Está escrito para que un participante
lo resuelva solo, sin detener a todo el grupo.

## Índice previsto

1. **Copilot no responde o no sugiere.** Licencia sin asignar, sesión caída en el IDE,
   política de organización que bloquea el chat o el modo agente.
2. **Problemas de red corporativa.** Dominios bloqueados, proxy autenticado, inspección
   TLS con certificado propio y el caso particular de Node.js con `NODE_EXTRA_CA_CERTS`.
3. **Exclusión de contenido.** Síntomas de un archivo o repositorio excluido por política
   y cómo confirmarlo.
4. **Escenario Java que no compila.** JDK equivocado en el PATH, versión de Maven,
   repositorio local sin las dependencias precargadas.
5. **Escenario .NET que no compila.** SDK equivocado, `global.json` apuntando a una versión
   ausente, restauración de paquetes sin acceso a la fuente.
6. **Servidor MCP que no levanta.** Configuración mal ubicada, Node ausente del PATH,
   herramientas que no aparecen en el registro del cliente.
7. **Rendimiento en la máquina virtual.** Latencia del escritorio remoto, indexación del
   workspace y qué cerrar cuando la máquina se satura.
8. **Artefactos de personalización que no se aplican.** Ubicación incorrecta del archivo,
   patrón de `applyTo` que no coincide, precedencia entre instrucciones de repositorio y
   por ruta.

## Pendiente

- [ ] Redactar cada entrada con síntoma, causa y solución verificada (SPEC-007)
- [ ] Incorporar los problemas que aparezcan durante el ensayo previo a la primera sesión
