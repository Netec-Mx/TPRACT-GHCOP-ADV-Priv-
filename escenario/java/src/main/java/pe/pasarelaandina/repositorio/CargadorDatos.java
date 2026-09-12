package pe.pasarelaandina.repositorio;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import pe.pasarelaandina.calculo.UtilidadesFecha;
import pe.pasarelaandina.modelo.CategoriaNegocio;
import pe.pasarelaandina.modelo.Comercio;
import pe.pasarelaandina.modelo.Contracargo;
import pe.pasarelaandina.modelo.EstadoComercio;
import pe.pasarelaandina.modelo.EstadoContracargo;
import pe.pasarelaandina.modelo.EstadoTransaccion;
import pe.pasarelaandina.modelo.MedioPago;
import pe.pasarelaandina.modelo.MotivoContracargo;
import pe.pasarelaandina.modelo.PlanComisiones;
import pe.pasarelaandina.modelo.TramoComision;
import pe.pasarelaandina.modelo.Transaccion;

/**
 * Carga los archivos de datos de ejemplo al repositorio en memoria.
 *
 * Los archivos son de texto plano, con campos separados por punto y coma y
 * una linea de encabezado que se descarta.
 */
public class CargadorDatos {

    private final UtilidadesFecha utilidadesFecha = new UtilidadesFecha();

    public void cargarTodo(RepositorioMemoria repositorio, String rutaDirectorio) {
        cargarPlanes(repositorio, rutaDirectorio + File.separator + "planes.txt");
        cargarComercios(repositorio, rutaDirectorio + File.separator + "comercios.txt");
        cargarTransacciones(repositorio, rutaDirectorio + File.separator + "transacciones.txt");
        cargarContracargos(repositorio, rutaDirectorio + File.separator + "contracargos.txt");
    }

    public void cargarPlanes(RepositorioMemoria repositorio, String ruta) {
        BufferedReader lector = null;
        try {
            lector = new BufferedReader(new FileReader(ruta));
            String linea = lector.readLine();
            while ((linea = lector.readLine()) != null) {
                if (linea.trim().isEmpty()) {
                    continue;
                }
                try {
                    String[] campos = linea.split(";");
                    PlanComisiones plan = new PlanComisiones();
                    plan.setId(campos[0]);
                    plan.setNombre(campos[1]);
                    plan.setMontoFijoPorTransaccion(Double.parseDouble(campos[2]));
                    plan.setTopeMensual(Double.parseDouble(campos[3]));

                    String[] tramos = campos[4].split("\\|");
                    for (String tramoTexto : tramos) {
                        String[] partes = tramoTexto.split(":");
                        TramoComision tramo = new TramoComision(
                                Double.parseDouble(partes[0]),
                                Double.parseDouble(partes[1]),
                                Double.parseDouble(partes[2]));
                        plan.agregarTramo(tramo);
                    }
                    repositorio.agregarPlan(plan);
                } catch (Exception e) {
                }
            }
        } catch (IOException e) {
            System.out.println("No se pudo leer el archivo de planes: " + ruta);
        } finally {
            cerrar(lector);
        }
    }

    public void cargarComercios(RepositorioMemoria repositorio, String ruta) {
        BufferedReader lector = null;
        try {
            lector = new BufferedReader(new FileReader(ruta));
            String linea = lector.readLine();
            while ((linea = lector.readLine()) != null) {
                if (linea.trim().isEmpty()) {
                    continue;
                }
                try {
                    String[] campos = linea.split(";");
                    Comercio comercio = new Comercio();
                    comercio.setId(campos[0]);
                    comercio.setRazonSocial(campos[1]);
                    comercio.setRegistroTributario(campos[2]);
                    comercio.setCategoria(CategoriaNegocio.valueOf(campos[3]));
                    comercio.setFechaAfiliacion(utilidadesFecha.parsearFecha(campos[4]));
                    comercio.setEstado(EstadoComercio.valueOf(campos[5]));
                    comercio.setIdPlanComisiones(campos[6]);
                    repositorio.agregarComercio(comercio);
                } catch (Exception e) {
                }
            }
        } catch (IOException e) {
            System.out.println("No se pudo leer el archivo de comercios: " + ruta);
        } finally {
            cerrar(lector);
        }
    }

    public void cargarTransacciones(RepositorioMemoria repositorio, String ruta) {
        BufferedReader lector = null;
        try {
            lector = new BufferedReader(new FileReader(ruta));
            String linea = lector.readLine();
            while ((linea = lector.readLine()) != null) {
                if (linea.trim().isEmpty()) {
                    continue;
                }
                try {
                    String[] campos = linea.split(";");
                    Transaccion transaccion = new Transaccion();
                    transaccion.setId(campos[0]);
                    transaccion.setIdComercio(campos[1]);
                    transaccion.setMonto(Double.parseDouble(campos[2]));
                    transaccion.setMoneda(campos[3]);
                    transaccion.setFechaHora(utilidadesFecha.parsearFechaHora(campos[4]));
                    transaccion.setMedioPago(MedioPago.valueOf(campos[5]));
                    transaccion.setCuotas(Integer.parseInt(campos[6]));
                    transaccion.setEstado(EstadoTransaccion.valueOf(campos[7]));
                    transaccion.setCodigoAutorizacion(campos[8]);
                    repositorio.agregarTransaccion(transaccion);
                } catch (Exception e) {
                }
            }
        } catch (IOException e) {
            System.out.println("No se pudo leer el archivo de transacciones: " + ruta);
        } finally {
            cerrar(lector);
        }
    }

    public void cargarContracargos(RepositorioMemoria repositorio, String ruta) {
        BufferedReader lector = null;
        try {
            lector = new BufferedReader(new FileReader(ruta));
            String linea = lector.readLine();
            while ((linea = lector.readLine()) != null) {
                if (linea.trim().isEmpty()) {
                    continue;
                }
                try {
                    String[] campos = linea.split(";");
                    Contracargo contracargo = new Contracargo();
                    contracargo.setId(campos[0]);
                    contracargo.setIdTransaccion(campos[1]);
                    contracargo.setMonto(Double.parseDouble(campos[2]));
                    contracargo.setFecha(utilidadesFecha.parsearFecha(campos[3]));
                    contracargo.setMotivo(MotivoContracargo.valueOf(campos[4]));
                    contracargo.setEstado(EstadoContracargo.valueOf(campos[5]));
                    repositorio.agregarContracargo(contracargo);
                } catch (Exception e) {
                }
            }
        } catch (IOException e) {
            System.out.println("No se pudo leer el archivo de contracargos: " + ruta);
        } finally {
            cerrar(lector);
        }
    }

    private void cerrar(BufferedReader lector) {
        if (lector != null) {
            try {
                lector.close();
            } catch (IOException e) {
            }
        }
    }
}
