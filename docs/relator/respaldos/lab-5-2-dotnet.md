> Salida real de GitHub Copilot CLI 1.0.96 con Claude Sonnet 5.5, grabada el 12 de octubre
> de 2026 en la máquina virtual Windows del taller, sobre una copia limpia del repositorio de
> participantes. Capítulo 5 completo por el camino A, escenario .NET, en una sola rama. Se
> grabó en la CLI, no en Visual Studio Code. Los comandos que pidió el agente se aprobaron
> según la guía de prueba humana, y el relator respondió con la hoja de respuestas. Los
> commits los hizo el participante en Git Bash. La ruta del repositorio en la máquina se
> abrevia `<repo>`. Los segundos son de trabajo del agente, sin la lectura del participante.

# Lab 5-2 salida grabada de respaldo (escenario .NET, camino A)

Sigue en la rama del 5.1.

## 5.2 paso 1: `/lab-5-2-paso-1-planificar dotnet`

Escrito: `/lab-5-2-paso-1-planificar dotnet`

Modo: Agent. Segundos de trabajo del agente: 30.

Archivos leídos: `escenario/dotnet/LiquidacionComercios/Calculo/CalculadoraLiquidacion.cs`.
Archivos escritos: `docs/proyecto/registro-de-tiempos.md`.
Comandos, todos con aprobación: `Get-Date -Format HH:mm; Get-Content docs\proyecto\registro-de-tiempos.md -Raw; Get-ChildItem docs\arquitectura\decisiones, docs\proyecto | S`; `bash scripts/proyecto/entregar.sh formato-del-reporte; Get-Content docs\proyecto\backlog\formato-del-reporte.md -Raw; Get-Content docs\proye`; `cd escenario\dotnet\LiquidacionComercios; Get-ChildItem -Recurse -Filter *.cs | ?{$_.FullName -notmatch '\\(obj|bin)\\'} | %{ "$($_.FullName`; `cd escenario\dotnet\LiquidacionComercios; Get-Content AplicacionLiquidacion.cs -Raw; Get-Content Reporte\FormateadorReporte.cs | Select -Fir`.

Mensaje durante el trabajo: «Editar la fila y entregar la especificación.»

Respuesta del chat:

Registré el inicio de Desarrollo (18:41) y entregué la especificación técnica del reporte. El plan sigue la alternativa C de la decisión 0004, así que no reescribí esa decisión ni su fila del índice. No edité ningún otro archivo.

#### Plan (.NET, sin editar nada aún)

No hay refactor, porque el plan no reutiliza código existente. Por eso ningún paso necesita `--paso equivalencia` como validación propia. Ese script se usa al final para comprobar que la liquidación no cambió.

El código nuevo del reporte usa `decimal`, con sumas exactas y un solo redondeo al final (`MidpointRounding.AwayFromZero`). El código existente no cambia de tipo.

1. **`Reporte/CalculadoraReporteMedios.cs`** (nuevo): calcula la comisión por su cuenta.
   - Filtra las transacciones: APROBADA, PEN, monto > 0, dentro del periodo.
   - Filtra los comercios: excluye los DE_BAJA y los que no tienen plan.
   - Aplica el tramo con límite superior inclusivo.
   - Calcula el recargo de 0,5 % por cuota sobre la primera, con máximo 3 %.
   - Suma exacto por medio de pago y por comercio.
   - Calcula el tope por comercio, el ajuste por tope, el total por comercio redondeado y el ajuste por redondeo.
   - *Validación:* compila con `dotnet build -c Release`. Con 2026-06, CM0011 da 137.825 y 137.83, y TX002001 da 17.80.
2. **`Reporte/FormateadorReporteMedios.cs`** (nuevo): da formato a la salida según la especificación.
   - Encabezado de 6 líneas, una línea en blanco y tabla con anchos 15, 16, 18, 16 y 16.
   - 81 guiones y pie con etiqueta de 49 y monto de 16.
   - Filas en orden alfabético del código.
   - Montos `S/ -x.xx` y participación `x.xx %`, con cultura invariante.
   - *Validación:* comparación visual con el ejemplo de forma de la especificación.
3. **`AplicacionLiquidacion.cs`** (modificar `Main`): si `args[0]` es `--reporte-medios`, desplaza los argumentos, imprime solo el reporte y retorna. Sin esa bandera, la ruta existente queda igual.
   - *Validación:* `bash scripts/integracion-local.sh --paso equivalencia` termina en 0, lo que confirma que la liquidación no cambió.
4. **Verificación final:**
   - `bash scripts/verificar-reporte.sh` para 2026-04, 2026-05 y 2026-06.
   - `bash scripts/comparar-escenarios.sh`.
   - Conciliación del total con la suma de las liquidaciones (criterio 8).

#### Para la aprobación

- La decisión 0004 ya prevé que el reporte puede diferir de la liquidación al centavo, porque la liquidación usa `double` y el tramo superior en el límite. El paso 4 lo mostrará.
- Java queda sin reporte. `comparar-escenarios.sh` solo compara la liquidación, así que debería seguir en cero. La versión Java sigue pendiente de decidir.

¿Apruebas el plan o qué cambias?

#### `docs/proyecto/registro-de-tiempos.md`

```markdown
# Registro de tiempos

Hora real de inicio y de término de cada fase, anotadas en el momento con `date +%H:%M`. Los
minutos reales son el término menos el inicio. «Origen» dice `participante` cuando las horas
las anotó quien hizo el laboratorio, y `referencia` cuando las dejó
`scripts/proyecto/ponerse-al-dia.sh` porque ese laboratorio no se hizo. Un tiempo de
referencia no es del participante y no se compara como propio.

| Fase | Laboratorio | Inicio (HH:MM) | Término (HH:MM) | Minutos reales | Estimado con IA (min) | Diferencia | Origen |
|---|---|---|---|---|---|---|---|
| Requerimientos | 5.1, paso 1 | 18:36 | 18:38 | | 5 | | participante |
| Estimación | 5.1, paso 2 | 18:38 | 18:39 | | 10 | | participante |
| Análisis y diseño | 5.1, paso 3 | 18:39 | 18:40 | | 30 | | participante |
| Desarrollo | 5.2, pasos 1 a 3 | 18:41 | | | 90 | | participante |
| Pruebas | 5.3, paso 1 | | | | 45 | | |
| Integración continua | 5.3, paso 2 | | | | 15 | | |
| Mantención | 5.3, paso 3 | | | | 20 | | |
| Revisión de código | 5.3, paso 4 | | | | 30 | | |
| Seguridad | 5.3, paso 4 | | | | 15 | | |
| Liberación | 5.4, paso 1 | | | | 20 | | |
| Operación y soporte | 5.4, paso 2 | | | | 20 | | |
| Mantención evolutiva | 5.4, paso 3 | | | | 40 | | |

## Hallazgos abiertos

Lo que un paso encontró y queda para un laboratorio posterior, una línea por hallazgo, con
el laboratorio y el comando que lo muestra. Sin causa: se diagnostica cuando corresponde.
```

La especificación entregada por el script, que no escribí yo, está en `docs/proyecto/backlog/formato-del-reporte.md`.

#### Observaciones fuera de alcance (no toqué nada)

- `CalculadoraLiquidacion` usa `<` en el límite del tramo y tope de recargo 3,0. `CalculadoraComision` usa `<=` y 3,5.
- Los valores monetarios del escenario son `double`.

## 5.2 paso 1: respuesta del participante

Escrito: `apruebo`

Modo: Agent. Segundos de trabajo del agente: 3.

Respuesta del chat:

Plan aprobado. Este paso (planificar) termina aquí y no implementé nada.

- La decisión 0004 ya describe lo que se va a construir, así que sigue sin cambios, en estado «Propuesta». Su fila en el índice tampoco cambió.
- Lo que sigue es el paso 2 del laboratorio 5.2, la implementación. Desarrollo sigue abierto en el registro de tiempos (inicio 18:41, término vacío). El término lo anota el paso 3.

¿Continúo con la implementación, o prefieres invocar la skill del paso siguiente tú?

## 5.2 paso 2: `/lab-5-2-paso-2-implementar-reporte dotnet`

Escrito: `/lab-5-2-paso-2-implementar-reporte dotnet`

Modo: Agent. Segundos de trabajo del agente: 89.

Archivos escritos: `escenario/dotnet/LiquidacionComercios/Reporte/CalculadoraReporteMedios.cs`, `escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporteMedios.cs`, `escenario/dotnet/LiquidacionComercios/AplicacionLiquidacion.cs`.
Comandos, todos con aprobación: `cd escenario\dotnet; Get-Content ..\..\.github\instructions\dotnet.instructions.md -Raw; cd LiquidacionComercios; Get-Content Modelo\Transac`; `bash scripts/integracion-local.sh --paso equivalencia 2>&1 | tail -15; "EXIT $LASTEXITCODE"; foreach($p in '2026-04','2026-05','2026-06'){ b`; `git --no-pager diff; git status --short; dotnet escenario/dotnet/LiquidacionComercios/bin/Release/net10.0/LiquidacionComercios.dll --reporte`.

Mensaje durante el trabajo: «Info: <repo>\escenario\dotnet\LiquidacionComercios\Reporte\CalculadoraReporteMedios.cs»

Mensaje durante el trabajo: «Info: <repo>\escenario\dotnet\LiquidacionComercios\Reporte\FormateadorReporteMedios.cs»

Respuesta del chat:

Implementé `--reporte-medios` en .NET. La liquidación no cambió: `bash scripts/integracion-local.sh --paso equivalencia` coincide con los hashes de 2026-04, 2026-05 y 2026-06. `bash scripts/verificar-reporte.sh dotnet <periodo>` también coincide con la salida esperada en los tres periodos.

Las clases nuevas calculan la comisión por su cuenta, en `decimal`, como pide la decisión 0004. Cada línea termina con `\n` escrito de forma explícita.

#### `git diff`

```diff
diff --git a/escenario/dotnet/LiquidacionComercios/AplicacionLiquidacion.cs b/escenario/dotnet/LiquidacionComercios/AplicacionLiquidacion.cs
@@ -38,6 +38,14 @@
             Thread.CurrentThread.CurrentUICulture = CultureInfo.InvariantCulture;
 
+            if (args.Length > 0 && args[0] == "--reporte-medios")
+            {
+                string[] restantes = new string[args.Length - 1];
+                Array.Copy(args, 1, restantes, 0, restantes.Length);
+                EjecutarReporteMedios(restantes);
+                return;
+            }
+
             string periodo = args.Length > 0 ? args[0] : PeriodoPorDefecto;
@@ -76,6 +84,19 @@
             Console.WriteLine();
         }
 
+        private static void EjecutarReporteMedios(string[] args)
+        {
+            string periodo = args.Length > 0 ? args[0] : PeriodoPorDefecto;
+            string rutaDatos = args.Length > 1 ? args[1] : DirectorioPorDefecto;
+
+            CalculadoraLiquidacion calculadora = new CalculadoraLiquidacion();
+            calculadora.PrepararDatos(rutaDatos);
+
+            ResultadoReporteMedios resultado =
+                    new CalculadoraReporteMedios(calculadora.Repositorio).Calcular(periodo);
+            Console.Out.Write(new FormateadorReporteMedios().Formatear(resultado));
+        }
+
         private static List<Liquidacion> Primeras(
```

`git diff` también muestra el cambio del registro de tiempos del paso 1 (fila Desarrollo, inicio 18:41). No lo toqué en este paso.

#### Archivo nuevo: `escenario/dotnet/LiquidacionComercios/Reporte/CalculadoraReporteMedios.cs`

```csharp
using System;
using System.Collections.Generic;

using Pe.PasarelaAndina.Calculo;
using Pe.PasarelaAndina.Modelo;
using Pe.PasarelaAndina.Repositorio;

namespace Pe.PasarelaAndina.Reporte
{
    /// <summary>
    /// Fila del reporte: un medio de pago con sus totales ya redondeados.
    /// </summary>
    public class FilaMedioPago
    {
        public string Medio { get; set; }
        public int Transacciones { get; set; }
        public decimal MontoTransado { get; set; }
        public decimal Comision { get; set; }
        public decimal Participacion { get; set; }
    }

    /// <summary>
    /// Resultado del reporte de comisiones por medio de pago de un periodo.
    /// </summary>
    public class ResultadoReporteMedios
    {
        public string Periodo { get; set; }
        public DateTime Desde { get; set; }
        public DateTime Hasta { get; set; }
        public List<FilaMedioPago> Filas { get; set; } = new List<FilaMedioPago>();
        public decimal AjustePorTope { get; set; }
        public decimal AjustePorRedondeo { get; set; }
        public decimal Total { get; set; }
    }

    /// <summary>
    /// Calcula las comisiones por medio de pago con aritmetica decimal exacta. Suma sin
    /// redondear y redondea una sola vez al final. No usa el calculo de la liquidacion
    /// (decision 0004).
    /// </summary>
    public class CalculadoraReporteMedios
    {
        private readonly RepositorioMemoria repositorio;
        private readonly UtilidadesFecha utilidadesFecha = new UtilidadesFecha();

        public CalculadoraReporteMedios(RepositorioMemoria repositorio)
        {
            this.repositorio = repositorio;
        }

        public ResultadoReporteMedios Calcular(string periodo)
        {
            DateTime inicio = utilidadesFecha.InicioDePeriodo(periodo);
            DateTime fin = utilidadesFecha.FinDePeriodo(periodo);

            SortedDictionary<string, decimal> comisionPorMedio =
                    new SortedDictionary<string, decimal>(StringComparer.Ordinal);
            Dictionary<string, decimal> montoPorMedio = new Dictionary<string, decimal>();
            Dictionary<string, int> cantidadPorMedio = new Dictionary<string, int>();

            decimal excesoTope = 0m;
            decimal total = 0m;

            foreach (Comercio comercio in repositorio.Comercios)
            {
                if (comercio.Estado == EstadoComercio.DE_BAJA)
                {
                    continue;
                }

                PlanComisiones plan = repositorio.BuscarPlanPorId(comercio.IdPlanComisiones);
                if (plan == null)
                {
                    continue;
                }

                decimal comisionComercio = 0m;

                foreach (Transaccion transaccion in repositorio.BuscarTransaccionesDeComercio(comercio.Id))
                {
                    if (transaccion.Estado != EstadoTransaccion.APROBADA
                            || transaccion.Moneda != "PEN"
                            || transaccion.Monto <= 0
                            || transaccion.FechaHora < inicio
                            || transaccion.FechaHora > fin)
                    {
                        continue;
                    }

                    decimal monto = (decimal)transaccion.Monto;
                    decimal comision = CalcularComision(plan, monto, transaccion.Cuotas);
                    string medio = transaccion.MedioPago.ToString();

                    comisionComercio += comision;
                    Acumular(comisionPorMedio, medio, comision);
                    Acumular(montoPorMedio, medio, monto);
                    cantidadPorMedio[medio] = (cantidadPorMedio.ContainsKey(medio) ? cantidadPorMedio[medio] : 0) + 1;
                }

                decimal tope = (decimal)plan.TopeMensual;
                if (comisionComercio > tope)
                {
                    excesoTope += comisionComercio - tope;
                    comisionComercio = tope;
                }
                total += Redondear(comisionComercio);
            }

            ResultadoReporteMedios resultado = new ResultadoReporteMedios();
            resultado.Periodo = periodo;
            resultado.Desde = inicio;
            resultado.Hasta = fin;

            decimal sumaExactaFilas = 0m;
            foreach (decimal comision in comisionPorMedio.Values)
            {
                sumaExactaFilas += comision;
            }

            decimal sumaFilas = 0m;
            foreach (KeyValuePair<string, decimal> par in comisionPorMedio)
            {
                FilaMedioPago fila = new FilaMedioPago();
                fila.Medio = par.Key;
                fila.Transacciones = cantidadPorMedio[par.Key];
                fila.MontoTransado = Redondear(montoPorMedio[par.Key]);
                fila.Comision = Redondear(par.Value);
                fila.Participacion = sumaExactaFilas == 0m
                        ? 0m
                        : Redondear(par.Value / sumaExactaFilas * 100m);
                resultado.Filas.Add(fila);
                sumaFilas += fila.Comision;
            }

            resultado.AjustePorTope = -Redondear(excesoTope);
            resultado.Total = total;
            resultado.AjustePorRedondeo = total - sumaFilas - resultado.AjustePorTope;

            return resultado;
        }

        /// <summary>
        /// Comision exacta de una transaccion: el monto en el limite de un tramo cae en el
        /// tramo inferior y el recargo por cuotas es 0,5 % por cuota sobre la primera,
        /// con maximo 3 %.
        /// </summary>
        private static decimal CalcularComision(PlanComisiones plan, decimal monto, int cuotas)
        {
            decimal porcentaje = 0m;
            bool encontrado = false;

            foreach (TramoComision tramo in plan.Tramos)
            {
                if (monto > (decimal)tramo.MontoDesde && monto <= (decimal)tramo.MontoHasta)
                {
                    porcentaje = (decimal)tramo.Porcentaje;
                    encontrado = true;
                    break;
                }
            }

            if (!encontrado && plan.Tramos.Count > 0)
            {
                porcentaje = (decimal)plan.Tramos[plan.Tramos.Count - 1].Porcentaje;
            }

            decimal comisionBase = monto * porcentaje / 100m + (decimal)plan.MontoFijoPorTransaccion;

            decimal recargo = 0m;
            if (cuotas > 1)
            {
                decimal porcentajeRecargo = (cuotas - 1) * 0.5m;
                if (porcentajeRecargo > 3m)
                {
                    porcentajeRecargo = 3m;
                }
                recargo = comisionBase * porcentajeRecargo / 100m;
            }

            return comisionBase + recargo;
        }

        private static void Acumular(IDictionary<string, decimal> acumulado, string clave, decimal valor)
        {
            decimal actual;
            acumulado.TryGetValue(clave, out actual);
            acumulado[clave] = actual + valor;
        }

        private static decimal Redondear(decimal valor)
        {
            return Math.Round(valor, 2, MidpointRounding.AwayFromZero);
        }
    }
}
```

#### Archivo nuevo: `escenario/dotnet/LiquidacionComercios/Reporte/FormateadorReporteMedios.cs`

```csharp
using System;
using System.Globalization;
using System.Text;

namespace Pe.PasarelaAndina.Reporte
{
    /// <summary>
    /// Da formato de texto al reporte de comisiones por medio de pago. Cada linea termina
    /// en \n explicito, sin depender del sistema operativo.
    /// </summary>
    public class FormateadorReporteMedios
    {
        private const string Marco = "==========================================================";

        public string Formatear(ResultadoReporteMedios resultado)
        {
            StringBuilder texto = new StringBuilder();

            texto.Append(Marco).Append('\n');
            texto.Append("  PASARELA ANDINA - COMISIONES POR MEDIO DE PAGO").Append('\n');
            texto.Append("  Periodo: ").Append(resultado.Periodo).Append('\n');
            texto.Append("  Desde: ").Append(resultado.Desde.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture)).Append('\n');
            texto.Append("  Hasta: ").Append(resultado.Hasta.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture)).Append('\n');
            texto.Append(Marco).Append('\n');
            texto.Append('\n');

            texto.Append("Medio de pago".PadRight(15))
                 .Append("Transacciones".PadLeft(16))
                 .Append("Monto transado".PadLeft(18))
                 .Append("Comision".PadLeft(16))
                 .Append("Participacion".PadLeft(16))
                 .Append('\n');

            foreach (FilaMedioPago fila in resultado.Filas)
            {
                texto.Append(fila.Medio.PadRight(15))
                     .Append(fila.Transacciones.ToString(CultureInfo.InvariantCulture).PadLeft(16))
                     .Append(Monto(fila.MontoTransado).PadLeft(18))
                     .Append(Monto(fila.Comision).PadLeft(16))
                     .Append((Numero(fila.Participacion) + " %").PadLeft(16))
                     .Append('\n');
            }

            texto.Append(new string('-', 81)).Append('\n');
            Pie(texto, "Ajuste por tope", resultado.AjustePorTope);
            Pie(texto, "Ajuste por redondeo", resultado.AjustePorRedondeo);
            Pie(texto, "Total", resultado.Total);

            return texto.ToString();
        }

        private static void Pie(StringBuilder texto, string etiqueta, decimal valor)
        {
            texto.Append(etiqueta.PadRight(49)).Append(Monto(valor).PadLeft(16)).Append('\n');
        }

        private static string Monto(decimal valor)
        {
            return "S/ " + Numero(valor);
        }

        private static string Numero(decimal valor)
        {
            return Math.Round(valor, 2, MidpointRounding.AwayFromZero)
                       .ToString("F2", CultureInfo.InvariantCulture);
        }
    }
}
```

#### Última validación

La salida de `--reporte-medios 2026-06`:

```
==========================================================
  PASARELA ANDINA - COMISIONES POR MEDIO DE PAGO
  Periodo: 2026-06
  Desde: 01/06/2026 00:00
  Hasta: 30/06/2026 23:59
==========================================================

Medio de pago     Transacciones    Monto transado        Comision   Participacion
BILLETERA_MOVIL             181      S/ 552504.92     S/ 14326.75         23.75 %
TARJETA_CREDITO             159      S/ 557033.77     S/ 14395.78         23.86 %
TARJETA_DEBITO              203      S/ 760564.01     S/ 19169.92         31.77 %
TRANSFERENCIA               170      S/ 492042.49     S/ 12443.22         20.62 %
---------------------------------------------------------------------------------
Ajuste por tope                                      S/ -23698.32
Ajuste por redondeo                                      S/ -0.01
Total                                                 S/ 36637.34
```

- **Equivalencia:** `[ OK ]` en los tres periodos, con código de salida 0.
- **Reporte:** `verificar-reporte.sh` coincide en 2026-04, 2026-05 y 2026-06. No hay diferencias que dejar para el paso 3.

No escribí pruebas del reporte. Tampoco toqué el escenario Java, los hashes esperados ni los datos. Dejé abiertos el registro de tiempos (el término lo anota el paso 3) y el estado de la decisión 0004.

#### Fuera de alcance

- `CalculadoraLiquidacion` y `CalculadoraComision` siguen sin coincidir entre sí: límite del tramo con `<` frente a `<=`, y tope de recargo de 3,0 frente a 3,5.

## 5.2 paso 3: `/lab-5-2-paso-3-verificar-reporte dotnet`

Escrito: `/lab-5-2-paso-3-verificar-reporte dotnet`

Modo: Agent. Segundos de trabajo del agente: 50.

Archivos escritos: `docs/proyecto/registro-de-tiempos.md`.
Comandos, todos con aprobación: `foreach($p in '2026-04','2026-05','2026-06'){ bash scripts/verificar-reporte.sh dotnet $p 2>&1 | tail -3; "EXIT $LASTEXITCODE" }; bash scrip`.

Respuesta del chat:

#### Comprobaciones

| Comprobación | Resultado |
|---|---|
| `verificar-reporte.sh dotnet 2026-04` | Coincide (código de salida 0) |
| `verificar-reporte.sh dotnet 2026-05` | Coincide (código de salida 0) |
| `verificar-reporte.sh dotnet 2026-06` | Coincide (código de salida 0) |
| `integracion-local.sh` | Todos los pasos pasan (código de salida 0). Equivalencia de la liquidación: `[ OK ]` en 2026-04, 2026-05 y 2026-06 |

Todos los periodos coincidieron, así que no hay nada pendiente para el 5.3 y no agregué hallazgos.

#### `docs/proyecto/registro-de-tiempos.md`

```markdown
# Registro de tiempos

Hora real de inicio y de término de cada fase, anotadas en el momento con `date +%H:%M`. Los
minutos reales son el término menos el inicio. «Origen» dice `participante` cuando las horas
las anotó quien hizo el laboratorio, y `referencia` cuando las dejó
`scripts/proyecto/ponerse-al-dia.sh` porque ese laboratorio no se hizo. Un tiempo de
referencia no es del participante y no se compara como propio.

| Fase | Laboratorio | Inicio (HH:MM) | Término (HH:MM) | Minutos reales | Estimado con IA (min) | Diferencia | Origen |
|---|---|---|---|---|---|---|---|
| Requerimientos | 5.1, paso 1 | 18:36 | 18:38 | | 5 | | participante |
| Estimación | 5.1, paso 2 | 18:38 | 18:39 | | 10 | | participante |
| Análisis y diseño | 5.1, paso 3 | 18:39 | 18:40 | | 30 | | participante |
| Desarrollo | 5.2, pasos 1 a 3 | 18:41 | 18:44 | | 90 | | participante |
| Pruebas | 5.3, paso 1 | | | | 45 | | |
| Integración continua | 5.3, paso 2 | | | | 15 | | |
| Mantención | 5.3, paso 3 | | | | 20 | | |
| Revisión de código | 5.3, paso 4 | | | | 30 | | |
| Seguridad | 5.3, paso 4 | | | | 15 | | |
| Liberación | 5.4, paso 1 | | | | 20 | | |
| Operación y soporte | 5.4, paso 2 | | | | 20 | | |
| Mantención evolutiva | 5.4, paso 3 | | | | 40 | | |

## Hallazgos abiertos

Lo que un paso encontró y queda para un laboratorio posterior, una línea por hallazgo, con
el laboratorio y el comando que lo muestra. Sin causa: se diagnostica cuando corresponde.
```

#### Commit propuesto

Revisa los cambios y ejecuta el commit tú (yo no lo hago). Incluye el escenario .NET, el registro de tiempos y la especificación entregada. La decisión 0004 no se modificó.

```bash
git add escenario docs && git commit -m "Reporte de comisiones por medio de pago"
```

¿Lo confirmas?

#### Fuera de alcance

- `CalculadoraLiquidacion` y `CalculadoraComision` siguen sin coincidir entre sí: límite del tramo con `<` frente a `<=`, y tope de recargo de 3,0 frente a 3,5.

## Participante: commit del laboratorio

```bash
git add escenario docs && git commit -m "Reporte de comisiones por medio de pago"
```

`git status --short` posterior: vacío.

## Esperado contra observado

- Paso 1: un plan numerado con la validación de cada paso y la pregunta de aprobación, sin
  código cambiado. Observado igual. Calcula por su cuenta en `decimal`, camino A, como dice la
  decisión 0004, que no tuvo que actualizar. Se respondió «apruebo».
- Paso 2: el reporte con los archivos nuevos y la equivalencia en verde. Observado igual,
  solo archivos del stack .NET y `liquidacion-esperada.sha256` sin cambios.
- Paso 3: camino A, el reporte coincide en los tres periodos. Observado igual. Propuso el
  commit.
