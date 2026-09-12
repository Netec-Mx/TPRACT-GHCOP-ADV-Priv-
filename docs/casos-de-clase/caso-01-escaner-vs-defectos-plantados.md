# Caso 1. Un escáner de seguridad revisa este repositorio

> Capítulo 5, revisión asistida de pull requests.
> Material para proyectar. La resolución está al final, en las notas del relator.

---

## Lo que pasó

Se publicó un commit. Nadie pidió una revisión. Una revisión de seguridad automática se
ejecutó igual y reportó esto:

```
Commit security review found 3 issues:

  authorization-bypass
    escenario/java/src/main/java/pe/pasarelaandina/repositorio/RepositorioMemoria.java

  parser-differential
    escenario/java/src/main/java/pe/pasarelaandina/calculo/SimuladorComision.java

  +1 more
```

---

## El primer hallazgo

`authorization-bypass` en `RepositorioMemoria.java`:

```java
    /**
     * Devuelve los comercios que estan en condiciones de ser liquidados.
     */
    public List<Comercio> buscarComerciosActivos() {
        List<Comercio> resultado = new ArrayList<>();
        for (Comercio comercio : comercios) {
            resultado.add(comercio);
        }
        return resultado;
    }
```

En los datos hay un comercio suspendido:

```
CM0031;Distribuidora Jesus Maria E.I.R.L.;20332336878;SERVICIOS;2024-03-29;SUSPENDIDO;PL04
```

Y aparece liquidado:

```
Comercio CM0031 - Distribuidora Jesus Maria E.I.R.L.
  Transacciones liquidadas : 15
  Total transado           : S/ 49510.60
  Total comisiones         : S/ 1031.19
```

---

## El segundo hallazgo

`parser-differential`. La misma decisión, implementada dos veces:

```java
// CalculadoraComision.java, linea 18
if (monto >= tramo.getMontoDesde() && monto <= tramo.getMontoHasta()) {
```

```java
// CalculadoraLiquidacion.java, linea 146
if (montoTransaccion >= tramo.getMontoDesde()
        && montoTransaccion < tramo.getMontoHasta()) {
```

Un carácter de diferencia. Resultado sobre el plan PL01:

```
       MONTO    CalculadoraComision (<=)    metodo monstruo (<)
      499.99                        3.5%                   3.5%
      500.00                        3.5%                   2.9%   <-- DIVERGEN
     1999.99                        2.9%                   2.9%
     2000.00                        2.9%                   2.5%   <-- DIVERGEN
    10000.00                        2.5%                   2.1%   <-- DIVERGEN
```

Al comercio se le cotiza una comisión y se le cobra otra.

---

## Superficie de ataque del código revisado

```
-- Entrada de red / sockets / HTTP --          ninguna
-- SQL / JDBC --                               ninguna
-- Deserializacion --                          ninguna
-- Ejecucion de procesos --                    ninguna
-- Reflexion / carga dinamica --               ninguna
-- Autenticacion / autorizacion / sesiones --  ninguna
```

---

## La pregunta

**Este hallazgo llega a tu pull request. ¿Lo aceptas o lo descartas?**

---
---

# Notas del relator

> **No proyectar.** Desde aquí en adelante es la conducción del caso.

## Cómo se conduce

Se proyecta hasta «La pregunta» y se detiene ahí. Se dejan tres o cuatro minutos de
discusión antes de mostrar nada más. Conviene pedir que voten a mano alzada aceptar o
descartar antes de argumentar, porque después de escuchar al primero que habla la sala se
alinea.

El resultado habitual es que la mayoría acepta el hallazgo. Es la respuesta razonable con
la información proyectada.

## Las preguntas para la sala

1. **Si este hallazgo llegara a tu pull request, ¿lo aceptas o lo descartas?**
2. **¿Qué información necesitas que el escáner no tiene?**
3. **¿Quién de tu equipo tiene esa información?**

La segunda es la que abre el caso. La tercera es la que incomoda, y es la que importa.

## La resolución

Los dos hallazgos son **correctos como observación técnica** y **equivocados como acción a
tomar**.

Este repositorio es material de un taller. Los defectos son el producto, están plantados a
propósito y documentados con archivo y línea antes de que el escáner corriera. `DEF-09` es
el primer hallazgo y `DEF-08` el segundo. Corregirlos destruye dos laboratorios del
capítulo 5.

Sobre el `authorization-bypass` en particular, conviene separar dos afirmaciones que el
escáner mezcló:

- **Correcto:** el método no hace lo que su nombre promete, y eso tiene consecuencia
  observable. `CM0031` se liquida estando suspendido.
- **Incorrecto:** aquí no hay control de acceso. No hay usuarios, sesiones, roles ni
  privilegios. El escáner infirió un dominio de seguridad desde el nombre del método.

Detectó bien una discrepancia entre nombre y comportamiento, y la clasificó en una
categoría que no aplica a este sistema.

## Lo que hay que dejar dicho

**El escáner no tenía cómo saberlo.** La información que falta no está en el código. Está
en `AGENTS.md`, que el escáner no lee, y en la cabeza de quien encargó el trabajo. No es un
defecto de la herramienta ni se arregla con una herramienta mejor.

**La validez técnica y la pertinencia son preguntas distintas.** Responder bien la primera
no dice nada sobre la segunda. Casi todo el valor de una revisión humana está en la
segunda.

**El criterio no es delegable a quien reporta.** Un agente que hubiera actuado sobre estos
tres hallazgos habría roto el material con la mejor de las intenciones y un informe
impecable. Quien decide aplicar o descartar necesita el contexto, y el contexto es humano.

## El cierre que conviene

La pregunta 3 es el cierre. Cuando alguien de la sala responde quién tiene esa información
en su equipo, casi siempre aparece que es una persona, no un documento, y con frecuencia
que es una sola persona.

Ahí es donde el capítulo 2 deja de ser teórico: los artefactos de repositorio existen
justamente para que ese contexto deje de vivir en una cabeza y pase a estar donde las
herramientas y las personas nuevas lo puedan leer.

Si la sala llega sola a esa conclusión, el caso funcionó. Si no, se plantea directo.

## Advertencia

Este caso ocurrió de verdad durante la construcción del repositorio, en el commit
`171478c`. No es un ejemplo inventado. Vale decirlo en sala, porque cambia cómo se recibe.

El registro completo está en [`../03-hallazgos.md`](../03-hallazgos.md), HALLAZGO-02.
