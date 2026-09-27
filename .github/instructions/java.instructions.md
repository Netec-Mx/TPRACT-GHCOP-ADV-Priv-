---
name: 'Escenario Java'
description: 'Convenciones para trabajar sobre el escenario Java: versión, pruebas, compilación y alcance de los cambios'
applyTo: 'escenario/java/**/*.java,escenario/java/pom.xml'
---

# Escenario Java

## Versión y compilación

- El proyecto compila con nivel de lenguaje Java 21, definido en `escenario/java/pom.xml`.
  No uses características de versiones posteriores aunque el JDK instalado las admita.
- No agregues dependencias al `pom.xml`. La única dependencia es JUnit 5 para pruebas.
- Compila y prueba desde `escenario/java/`:

  ```bash
  mvn -q clean package
  mvn test
  ```

## Estilo del código existente

- Paquete raíz `pe.pasarelaandina`, con subpaquetes `modelo`, `repositorio`, `calculo`,
  `reporte` y `util`.
- Nombres de clases, métodos y variables en español, en camelCase.
- El formateo de números para la salida pasa por `util/ConfiguracionRegional`. Todo
  `String.format` que produzca salida visible usa esa configuración regional. Si la quitas,
  la salida cambia según el idioma de la máquina.

## Pruebas

- JUnit 5 (`org.junit.jupiter.api`). Las clases de prueba terminan en `Test` y viven en
  `src/test/java` con el mismo paquete que la clase probada.
- Los nombres de los métodos de prueba describen en español lo que se espera, en camelCase,
  por ejemplo `rechazaRegistrosTributariosMalFormados`.
- Una prueba nueva va en un archivo nuevo salvo que la tarea diga otra cosa.

## Alcance

- Las mismas reglas de `.github/copilot-instructions.md` aplican aquí. En particular, no
  cambies tipos, no extraigas literales, no unifiques código entre clases ni renombres
  nada que la tarea no nombre.
- El escenario .NET tiene un archivo equivalente para cada archivo Java. Si la tarea es
  sobre un solo escenario, no toques el otro.
