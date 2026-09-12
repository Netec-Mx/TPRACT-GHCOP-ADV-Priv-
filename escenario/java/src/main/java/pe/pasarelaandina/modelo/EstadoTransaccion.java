package pe.pasarelaandina.modelo;

/**
 * Situacion de una venta dentro del ciclo de autorizacion y captura.
 */
public enum EstadoTransaccion {

    APROBADA,
    ANULADA,
    RECHAZADA,
    PENDIENTE
}
