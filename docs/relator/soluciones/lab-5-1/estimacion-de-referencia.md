# Estimación de referencia: reporte de comisiones por medio de pago

Solo para el relator. Construida con las mediciones reales de SPEC-015, que están en la
bitácora: un agente construyó el reporte en 184 s en Java y 126 s en .NET, y la mantención
correctiva en 64 s y 80 s, con 7 a 9 comandos cada vez. Esos son minutos de agente. Los
minutos de persona son la referencia de los laboratorios del capítulo 5, que asignan el
tiempo a leer, decidir y revisar. Los minutos «sin IA» son un supuesto, marcado como tal.

Un solo stack.

| Fase | Sin IA, persona (min) | Con IA, persona (min) | Con IA, agente (min) | Supuesto principal |
|---|---|---|---|---|
| Requerimientos | 30 | 15 | 1 | Las preguntas al negocio toman lo mismo con o sin IA; la IA ahorra la redacción |
| Estimación | 20 | 10 | 1 | Supuesto: estimar a mano exige recorrer el código |
| Análisis y diseño | 30 | 10 | 1 | La IA lee el código y el mapeo; la persona decide |
| Desarrollo | 180 | 25 | 3 | Medido: 2 a 3 minutos de agente por stack. Supuesto: 3 horas a mano con pruebas |
| Pruebas | 60 | 10 | 1 | Supuesto: los criterios ya traen los valores esperados |
| Integración continua | 40 | 10 | 1 | Agregar un paso a un pipeline que ya existe |
| Mantención | 90 | 15 | 2 | Medido: 1 a 1,5 minutos de agente para la correctiva. El diagnóstico es lo que pesa |
| Revisión de código | 20 | 8 | 1 | La revisión humana no se acorta tanto: se lee igual |
| Seguridad | 10 | 4 | 0 | Lista de comprobación de la plantilla |
| Liberación | 20 | 8 | 1 | Registro de cambios y notas de versión |
| Operación y soporte | 45 | 12 | 1 | Un incidente con runbook y respuesta |
| Mantención evolutiva | 30 | 8 | 1 | Estimar el cambio siguiente con el registro real del ciclo |
| **Total** | **575** | **135** | **14** | |

Créditos y minutos de integración continua: cantidades a completar con el plan vigente. La
corrida real de SPEC-015 consumió 3 minutos de Actions por corrida del pipeline base.

La lección que vale la pena sacar en sala: la IA reduce mucho el desarrollo y la redacción,
poco la revisión, y nada las preguntas al negocio.
