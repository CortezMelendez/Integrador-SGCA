package com.sgca.integradorsgca.utils;

import java.io.IOException;

/**
 * Se lanza cuando un archivo subido en un campo de foto de vehículo no es
 * una imagen (por Content-Type). Los servlets de gestión de autos la
 * atrapan y la traducen al código de error "formato_imagen_invalido" que
 * ya entienden gestionAutos.jsp / gestionarAuto.jsp.
 */
public class ImagenInvalidaException extends IOException {

    public ImagenInvalidaException(String mensaje) {
        super(mensaje);
    }
}
