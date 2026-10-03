# Política de uso de IA en el desarrollo de Pasarela Andina

Pasarela Andina es una empresa ficticia del sector financiero. Esta es su política de uso
de asistentes de IA para el equipo de desarrollo. Es un ejemplo para adaptar, no la política
de ninguna organización real.

Cada regla dice por qué existe y qué mecanismo la aplica. Los mecanismos son de tres tipos.

- **Repositorio.** Un archivo de este repositorio la aplica: una instrucción que el agente
  sigue o un hook que lo bloquea.
- **Organización de GitHub.** La aplica la configuración de la organización. Este
  repositorio no puede imponerla; solo la documenta.
- **Equipo.** La aplica un procedimiento de las personas.

Una instrucción le pide algo al agente. Un hook o una configuración se lo impide. Lo que no
puede pasar nunca se controla con lo segundo.

## Reglas

### 1. Solo la cuenta de la organización

Se usa Copilot únicamente con la cuenta de GitHub de la organización, cubierta por su plan
Copilot Business o Copilot Enterprise. Nunca con una cuenta personal sobre código de la
empresa.

**Por qué.** Esos planes son los que dan gestión centralizada y control de políticas sobre
los miembros de la organización; una cuenta personal queda fuera de ese control.

**Mecanismo.** Organización de GitHub: asignación de licencias y políticas de Copilot.

### 2. Lo que nunca entra al contexto del agente

Secretos, credenciales, datos personales y datos reales de clientes no se escriben en
pedidos, archivos de personalización, código ni documentos que el agente pueda leer.

**Por qué.** El contenido de los archivos, la salida de la terminal y los diagnósticos del
espacio de trabajo se envían como contexto a los modelos y a las herramientas.

**Mecanismo.** Repositorio: regla en [`.github/copilot-instructions.md`](../../.github/copilot-instructions.md),
sección «Gobierno». Organización de GitHub: exclusión de contenido, con el límite de que
hoy no se aplica en los modos Edit y Agent, y el escaneo de secretos con protección de push,
que en repositorios privados requiere GitHub Secret Protection. Equipo: revisión del diff
antes de integrar y la casilla de la plantilla de pull request.

### 3. Los datos del escenario no se modifican

Ningún agente crea, modifica ni borra archivos de `escenario/datos/`.

**Por qué.** Son la entrada de todos los ejercicios y las salidas esperadas dependen de
ellos. La decisión está en [0003](../arquitectura/decisiones/0003-hook-de-proteccion-de-datos.md).

**Mecanismo.** Repositorio: el hook de [`.github/hooks/`](../../.github/hooks/proteger-datos-escenario.json)
rechaza la escritura antes de que ocurra. La lectura está permitida.

### 4. Fuentes externas solo aprobadas

Solo se conectan servidores MCP aprobados por el equipo. En este repositorio, el único es el
servidor local `pasarela-andina`, de solo lectura y sin red. Cada llamada se aprueba leyendo
sus parámetros. No se usa la aprobación permanente con herramientas que traen texto de
terceros.

**Por qué.** Un servidor MCP local puede ejecutar código en la máquina, y uno externo recibe
por la red lo que el agente le envía.

**Mecanismo.** Repositorio: la configuración vive en `.vscode/mcp.json`, versionada y
revisable, y la regla de no proponer servidores nuevos está en las instrucciones generales.
Organización de GitHub: política de servidores MCP en Copilot. Equipo: lectura de
parámetros en cada aprobación.

### 5. Todo cambio del agente pasa por revisión humana

Ningún cambio generado por el agente se integra sin que una persona lo revise. El agente no
hace commits ni push.

**Por qué.** El agente puede equivocarse con la misma seguridad con que acierta, y lo que
sugiere se valida siempre.

**Mecanismo.** Repositorio: regla en las instrucciones generales, el pipeline de integración
continua de `.github/workflows/` y la plantilla de pull request. Organización de GitHub:
reglas de protección de la rama principal que exigen pull request con revisión, y la
revisión de dependencias en pull requests, que en repositorios privados requiere GitHub Code
Security. Equipo: el checklist de revisión.

### 6. La personalización se revisa como código

Las instrucciones, los agentes, las skills, los hooks y la configuración MCP se cambian por
pull request, con la misma revisión que un script de despliegue.

**Por qué.** Cambian lo que el agente hace para todo el equipo, y un hook o un servidor MCP
ejecutan código.

**Mecanismo.** Repositorio: viven en `.github/` y `.vscode/`, versionados. Equipo: revisión
del pull request.

### 7. El uso se mide y tiene presupuesto

Se mide el uso de Copilot y cada persona tiene un presupuesto de créditos. El presupuesto y
la acción al acercarse al límite los fija el equipo con los valores del plan vigente.

**Por qué.** El chat y el agente consumen créditos según los tokens, y el consumo depende del
modo de trabajo y del contexto.

**Mecanismo.** Organización de GitHub: métricas de uso y presupuestos con detención al
alcanzar el límite. Guía para el equipo: [uso responsable de tokens](uso-responsable-de-tokens.md).

### 8. Ante un comportamiento sospechoso, detenerse y avisar

Si el agente propone algo que no se pidió, intenta tocar archivos fuera de la tarea, o una
respuesta suya contradice los datos que devolvieron sus herramientas, no se aprueba la
acción. Se detiene la sesión, se guarda la conversación y se avisa al responsable de
seguridad del equipo.

**Por qué.** Un dato que el agente lee puede traer texto escrito como una orden, y el
agente puede seguirlo.

**Mecanismo.** Equipo: procedimiento de las personas. Las aprobaciones guardadas se borran
con **Chat: Reset Tool Confirmations**.

## Fuentes

| Qué | Fuente | Consultada |
|---|---|---|
| Planes Copilot Business y Enterprise con gestión centralizada y políticas | https://docs.github.com/en/copilot/get-started/plans | 3 de octubre de 2026 |
| Contexto enviado a modelos y herramientas | https://code.visualstudio.com/docs/agents/security | 2 de octubre de 2026 |
| Exclusión de contenido y su límite en Edit y Agent | https://docs.github.com/en/copilot/concepts/context/content-exclusion | 2 de octubre de 2026 |
| Servidores MCP locales y código arbitrario | https://code.visualstudio.com/docs/agent-customization/mcp-servers | 2 de octubre de 2026 |
| Política de servidores MCP en Copilot | https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-organization/manage-policies | 2 de octubre de 2026 |
| Validar siempre lo que sugiere Copilot | https://docs.github.com/en/copilot/get-started/best-practices | 2 de octubre de 2026 |
| Créditos por tokens | https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing | 2 de octubre de 2026 |
| Presupuestos y detención al límite | https://docs.github.com/en/copilot/concepts/billing-and-usage/organizations-and-enterprises/budgets | 2 de octubre de 2026 |
| Escaneo de secretos en repositorios privados con GitHub Secret Protection | https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning | 3 de octubre de 2026 |
| Revisión de dependencias en repositorios privados con GitHub Code Security | https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/about-dependency-review | 3 de octubre de 2026 |
| **Chat: Reset Tool Confirmations** | https://code.visualstudio.com/docs/agents/approvals | 2 de octubre de 2026 |
