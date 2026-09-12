using System;
using System.IO;

using Pe.PasarelaAndina.Calculo;
using Pe.PasarelaAndina.Modelo;
using Pe.PasarelaAndina.Util;

namespace Pe.PasarelaAndina.Repositorio
{
    /// <summary>
    /// Carga los archivos de datos de ejemplo al repositorio en memoria.
    ///
    /// Los archivos son de texto plano, con campos separados por punto y coma y
    /// una linea de encabezado que se descarta.
    /// </summary>
    public class CargadorDatos
    {
        private readonly UtilidadesFecha utilidadesFecha = new UtilidadesFecha();

        public void CargarTodo(RepositorioMemoria repositorio, string rutaDirectorio)
        {
            CargarPlanes(repositorio, rutaDirectorio + Path.DirectorySeparatorChar + "planes.txt");
            CargarComercios(repositorio, rutaDirectorio + Path.DirectorySeparatorChar + "comercios.txt");
            CargarTransacciones(repositorio, rutaDirectorio + Path.DirectorySeparatorChar + "transacciones.txt");
            CargarContracargos(repositorio, rutaDirectorio + Path.DirectorySeparatorChar + "contracargos.txt");
        }

        public void CargarPlanes(RepositorioMemoria repositorio, string ruta)
        {
            StreamReader lector = null;
            try
            {
                lector = new StreamReader(ruta);
                string linea = lector.ReadLine();
                while ((linea = lector.ReadLine()) != null)
                {
                    if (linea.Trim().Length == 0)
                    {
                        continue;
                    }
                    try
                    {
                        string[] campos = linea.Split(';');
                        PlanComisiones plan = new PlanComisiones();
                        plan.Id = campos[0];
                        plan.Nombre = campos[1];
                        plan.MontoFijoPorTransaccion = CompatibilidadJava.LeerDecimal(campos[2]);
                        plan.TopeMensual = CompatibilidadJava.LeerDecimal(campos[3]);

                        string[] tramos = campos[4].Split('|');
                        foreach (string tramoTexto in tramos)
                        {
                            string[] partes = tramoTexto.Split(':');
                            TramoComision tramo = new TramoComision(
                                    CompatibilidadJava.LeerDecimal(partes[0]),
                                    CompatibilidadJava.LeerDecimal(partes[1]),
                                    CompatibilidadJava.LeerDecimal(partes[2]));
                            plan.AgregarTramo(tramo);
                        }
                        repositorio.AgregarPlan(plan);
                    }
                    catch (Exception)
                    {
                    }
                }
            }
            catch (IOException)
            {
                Console.WriteLine("No se pudo leer el archivo de planes: " + ruta);
            }
            finally
            {
                Cerrar(lector);
            }
        }

        public void CargarComercios(RepositorioMemoria repositorio, string ruta)
        {
            StreamReader lector = null;
            try
            {
                lector = new StreamReader(ruta);
                string linea = lector.ReadLine();
                while ((linea = lector.ReadLine()) != null)
                {
                    if (linea.Trim().Length == 0)
                    {
                        continue;
                    }
                    try
                    {
                        string[] campos = linea.Split(';');
                        Comercio comercio = new Comercio();
                        comercio.Id = campos[0];
                        comercio.RazonSocial = campos[1];
                        comercio.RegistroTributario = campos[2];
                        comercio.Categoria = (CategoriaNegocio)Enum.Parse(typeof(CategoriaNegocio), campos[3]);
                        comercio.FechaAfiliacion = utilidadesFecha.ParsearFecha(campos[4]);
                        comercio.Estado = (EstadoComercio)Enum.Parse(typeof(EstadoComercio), campos[5]);
                        comercio.IdPlanComisiones = campos[6];
                        repositorio.AgregarComercio(comercio);
                    }
                    catch (Exception)
                    {
                    }
                }
            }
            catch (IOException)
            {
                Console.WriteLine("No se pudo leer el archivo de comercios: " + ruta);
            }
            finally
            {
                Cerrar(lector);
            }
        }

        public void CargarTransacciones(RepositorioMemoria repositorio, string ruta)
        {
            StreamReader lector = null;
            try
            {
                lector = new StreamReader(ruta);
                string linea = lector.ReadLine();
                while ((linea = lector.ReadLine()) != null)
                {
                    if (linea.Trim().Length == 0)
                    {
                        continue;
                    }
                    try
                    {
                        string[] campos = linea.Split(';');
                        Transaccion transaccion = new Transaccion();
                        transaccion.Id = campos[0];
                        transaccion.IdComercio = campos[1];
                        transaccion.Monto = CompatibilidadJava.LeerDecimal(campos[2]);
                        transaccion.Moneda = campos[3];
                        transaccion.FechaHora = utilidadesFecha.ParsearFechaHora(campos[4]);
                        transaccion.MedioPago = (MedioPago)Enum.Parse(typeof(MedioPago), campos[5]);
                        transaccion.Cuotas = CompatibilidadJava.LeerEntero(campos[6]);
                        transaccion.Estado = (EstadoTransaccion)Enum.Parse(typeof(EstadoTransaccion), campos[7]);
                        transaccion.CodigoAutorizacion = campos[8];
                        repositorio.AgregarTransaccion(transaccion);
                    }
                    catch (Exception)
                    {
                    }
                }
            }
            catch (IOException)
            {
                Console.WriteLine("No se pudo leer el archivo de transacciones: " + ruta);
            }
            finally
            {
                Cerrar(lector);
            }
        }

        public void CargarContracargos(RepositorioMemoria repositorio, string ruta)
        {
            StreamReader lector = null;
            try
            {
                lector = new StreamReader(ruta);
                string linea = lector.ReadLine();
                while ((linea = lector.ReadLine()) != null)
                {
                    if (linea.Trim().Length == 0)
                    {
                        continue;
                    }
                    try
                    {
                        string[] campos = linea.Split(';');
                        Contracargo contracargo = new Contracargo();
                        contracargo.Id = campos[0];
                        contracargo.IdTransaccion = campos[1];
                        contracargo.Monto = CompatibilidadJava.LeerDecimal(campos[2]);
                        contracargo.Fecha = utilidadesFecha.ParsearFecha(campos[3]);
                        contracargo.Motivo = (MotivoContracargo)Enum.Parse(typeof(MotivoContracargo), campos[4]);
                        contracargo.Estado = (EstadoContracargo)Enum.Parse(typeof(EstadoContracargo), campos[5]);
                        repositorio.AgregarContracargo(contracargo);
                    }
                    catch (Exception)
                    {
                    }
                }
            }
            catch (IOException)
            {
                Console.WriteLine("No se pudo leer el archivo de contracargos: " + ruta);
            }
            finally
            {
                Cerrar(lector);
            }
        }

        private void Cerrar(StreamReader lector)
        {
            if (lector != null)
            {
                try
                {
                    lector.Close();
                }
                catch (IOException)
                {
                }
            }
        }
    }
}
