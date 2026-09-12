namespace Pe.PasarelaAndina.Modelo
{
    /// <summary>
    /// Rubro comercial del afiliado. Define el tarifario base que se le ofrece
    /// al momento de la afiliacion.
    /// </summary>
    public enum CategoriaNegocio
    {
        RETAIL,
        RESTAURANTE,
        SERVICIOS,
        TURISMO,
        SALUD,
        EDUCACION,
        TECNOLOGIA,
        TRANSPORTE
    }

    /// <summary>
    /// Situacion del comercio frente a la pasarela.
    /// </summary>
    public enum EstadoComercio
    {
        ACTIVO,
        SUSPENDIDO,
        DE_BAJA
    }

    /// <summary>
    /// Situacion de una venta dentro del ciclo de autorizacion y captura.
    /// </summary>
    public enum EstadoTransaccion
    {
        APROBADA,
        ANULADA,
        RECHAZADA,
        PENDIENTE
    }

    /// <summary>
    /// Instrumento con el que el tarjetahabiente paga.
    /// </summary>
    public enum MedioPago
    {
        TARJETA_CREDITO,
        TARJETA_DEBITO,
        BILLETERA_MOVIL,
        TRANSFERENCIA
    }

    /// <summary>
    /// Situacion de un contracargo dentro del proceso de disputa.
    /// </summary>
    public enum EstadoContracargo
    {
        INGRESADO,
        EN_REVISION,
        APROBADO,
        RECHAZADO
    }

    /// <summary>
    /// Razon por la que el tarjetahabiente desconoce el cargo.
    /// </summary>
    public enum MotivoContracargo
    {
        FRAUDE,
        PRODUCTO_NO_RECIBIDO,
        PRODUCTO_DEFECTUOSO,
        DUPLICADO,
        MONTO_INCORRECTO,
        SUSCRIPCION_CANCELADA
    }
}
