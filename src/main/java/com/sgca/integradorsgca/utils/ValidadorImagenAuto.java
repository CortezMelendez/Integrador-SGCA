package com.sgca.integradorsgca.utils;

import jakarta.servlet.http.Part;

import java.util.Locale;
import java.util.Map;

/**
 * Valida y resuelve la extensión con la que se guarda una foto de vehículo
 * subida desde gestionAutos.jsp / gestionarAuto.jsp.
 * <p>
 * Solo exige que el archivo sea una imagen (cualquier formato: jpg, png,
 * gif, webp, svg, bmp, avif, etc.) — no restringe a una lista cerrada de
 * formatos. La extensión con la que se guarda en disco se calcula a partir
 * del Content-Type real que reportó el navegador y no del nombre de archivo
 * original, porque ese nombre puede no traer extensión (por ejemplo fotos
 * pegadas desde el portapapeles) o traer una que no corresponde al
 * contenido real — causa de que algunas imágenes .webp quedaran guardadas
 * sin extensión y el navegador no las reconociera como imagen al mostrarlas.
 */
public final class ValidadorImagenAuto {

    private static final Map<String, String> EXTENSION_POR_CONTENT_TYPE = Map.of(
            "image/jpeg", ".jpg",
            "image/png", ".png",
            "image/gif", ".gif",
            "image/webp", ".webp",
            "image/svg+xml", ".svg",
            "image/bmp", ".bmp",
            "image/avif", ".avif"
    );

    public static boolean esImagen(Part parte) {
        String contentType = parte.getContentType();
        return contentType != null && contentType.toLowerCase(Locale.ROOT).startsWith("image/");
    }

    // Extensión a usar para guardar el archivo: primero por Content-Type
    // (confiable, lo calcula el navegador a partir del contenido real del
    // archivo), y si no se reconoce, cae de vuelta a la extensión del
    // nombre de archivo original que mandó el usuario.
    public static String extensionParaGuardar(Part parte, String nombreOriginal) {
        String contentType = parte.getContentType();
        if (contentType != null) {
            String tipo = contentType.toLowerCase(Locale.ROOT).trim();
            int puntoYComa = tipo.indexOf(';');
            if (puntoYComa >= 0) tipo = tipo.substring(0, puntoYComa).trim();

            String extensionConocida = EXTENSION_POR_CONTENT_TYPE.get(tipo);
            if (extensionConocida != null) return extensionConocida;
        }

        if (nombreOriginal != null) {
            int punto = nombreOriginal.lastIndexOf('.');
            if (punto >= 0) return nombreOriginal.substring(punto);
        }
        return "";
    }

    private ValidadorImagenAuto() {
    }
}
