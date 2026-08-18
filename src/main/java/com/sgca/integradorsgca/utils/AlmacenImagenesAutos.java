package com.sgca.integradorsgca.utils;

import java.io.File;

/**
 * Resuelve la carpeta persistente donde se guardan las fotos de vehículos
 * subidas por el dueño/asesor (portada + galería). A propósito vive FUERA de
 * la carpeta donde Tomcat despliega el .war (webapps/&lt;app&gt;/), usando
 * "catalina.base" (la carpeta propia de la instancia de Tomcat, que nunca se
 * borra al redesplegar) — así un "mvn clean package" + redeploy nunca vuelve
 * a borrar las fotos ya subidas, a diferencia de guardarlas con
 * getServletContext().getRealPath(...).
 * <p>
 * {@link com.sgca.integradorsgca.controller.ImagenesAutosServlet} es quien
 * sirve las fotos guardadas aquí de vuelta al navegador.
 */
public class AlmacenImagenesAutos {

    private static final String SUBCARPETA = "sgca-uploads/imagesAutos";

    public static File carpeta() {
        String catalinaBase = System.getProperty("catalina.base");
        File carpeta = (catalinaBase != null && !catalinaBase.isBlank())
                ? new File(catalinaBase, SUBCARPETA)
                : new File(System.getProperty("java.io.tmpdir"), SUBCARPETA);

        if (!carpeta.exists()) {
            carpeta.mkdirs();
        }
        return carpeta;
    }

    private AlmacenImagenesAutos() {
    }
}
