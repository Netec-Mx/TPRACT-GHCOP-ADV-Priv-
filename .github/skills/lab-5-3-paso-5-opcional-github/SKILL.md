---
name: lab-5-3-paso-5-opcional-github
description: 'Lab 5.3 paso 5, opcional. Si hay una copia del repositorio en GitHub, empuja la rama, abre el pull request y revisa el pipeline en Actions.'
disable-model-invocation: true
---

# Objetivo

Ver en GitHub lo mismo que ya se hizo en local: el pipeline en Actions y la revisión de
Copilot en el pull request. Es opcional. Ningún paso posterior depende de él.

# Qué hacer

1. Pregunta al participante si tiene una copia propia del repositorio en GitHub donde puede
   abrir pull requests. Si no la tiene, dile que este paso no aplica y termina.
2. Muestra el remoto configurado con `git remote -v`. Si no apunta a su copia, dile cómo
   agregarla y espera.
3. Propón el comando para empujar la rama, `git push -u origin reporte-medios-de-pago`, y
   espera a que el participante lo apruebe.
4. Indica cómo abrir el pull request en GitHub usando como descripción el contenido de
   `docs/proyecto/pull-request.md`, cómo ver el pipeline en la pestaña **Actions** y cómo
   pedir la revisión de Copilot en el pull request.

# Restricciones

- **No corrijas nada que no forme parte de este paso.** El código del escenario tiene
  características elegidas a propósito para el taller. Si ves algo que te parece un
  problema, menciónalo al final de tu respuesta y no lo toques.
- No empujes a `main` ni a una rama que no sea la del participante.
- No escribas secretos ni tokens en ningún archivo ni en el chat.

# Salida esperada

El enlace al pull request, si se abrió, o la confirmación de que el paso no aplica.
