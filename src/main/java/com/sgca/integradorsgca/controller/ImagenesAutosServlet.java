package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.utils.AlmacenImagenesAutos;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;

/**
 * Sirve las fotos de vehículos (portada y galería) para cualquier
 * &lt;img src="/Images/imagesAutos/archivo.jpg"&gt; del proyecto, sin que
 * ninguna JSP tenga que cambiar. Busca primero en la carpeta persistente
 * ({@link AlmacenImagenesAutos}, fuera del despliegue de Tomcat, sobrevive a
 * un redeploy) y, si no encuentra el archivo ahí, cae de vuelta a las fotos
 * "semilla" que sí vienen empaquetadas dentro del propio .war
 * (webapp/Images/imagesAutos/).
 */
@WebServlet("/Images/imagesAutos/*")
public class ImagenesAutosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.length() < 2) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String nombreArchivo = pathInfo.substring(1);
        if (nombreArchivo.contains("..") || nombreArchivo.contains("/") || nombreArchivo.contains("\\")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        File archivo = new File(AlmacenImagenesAutos.carpeta(), nombreArchivo);

        if (archivo.isFile()) {
            resp.setContentType(tipoContenido(nombreArchivo));
            resp.setContentLengthLong(archivo.length());
            try (InputStream is = Files.newInputStream(archivo.toPath())) {
                is.transferTo(resp.getOutputStream());
            }
            return;
        }

        // No está en la carpeta persistente: puede ser una de las fotos
        // "semilla" que sí viven empaquetadas dentro del .war.
        try (InputStream recurso = getServletContext().getResourceAsStream("/Images/imagesAutos/" + nombreArchivo)) {
            if (recurso == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            resp.setContentType(tipoContenido(nombreArchivo));
            recurso.transferTo(resp.getOutputStream());
        }
    }

    private String tipoContenido(String nombreArchivo) {
        String nombre = nombreArchivo.toLowerCase();
        if (nombre.endsWith(".png")) return "image/png";
        if (nombre.endsWith(".gif")) return "image/gif";
        if (nombre.endsWith(".webp")) return "image/webp";
        if (nombre.endsWith(".svg")) return "image/svg+xml";
        return "image/jpeg";
    }
}
