package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.TiposServicioBean;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
import com.sgca.integradorsgca.model.dao.TiposServicioDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 * Acepta multipart/form-data para poder recibir el archivo de la foto del
 * servicio (campo "foto"). Si no se sube una foto nueva al editar, conserva
 * la que ya tenía el servicio (campo oculto "foto_actual").
 */
@WebServlet(name = "ServiciosServlet", value = "/servicios")
@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,        // 5 MB por imagen
        maxRequestSize = 10 * 1024 * 1024,    // 10 MB por request
        fileSizeThreshold = 1024 * 1024
)
public class ServiciosServlet extends HttpServlet {

    private final ServiciosDao serviciosDao = new ServiciosDao();
    private final TiposServicioDao tiposServicioDao = new TiposServicioDao();

    // Carpeta dentro de webapp donde se guardan las fotos de servicios
    private static final String CARPETA_IMAGENES = "Images/imagesServicios";

    /*
     * ========================================
     * CARGAR LA PANTALLA
     * ========================================
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {

            req.setAttribute("listaServicios", serviciosDao.listar());
            req.setAttribute("listaTipos", tiposServicioDao.listar());

            req.getRequestDispatcher("/pages/duenioPages/gestionServicios.jsp").forward(req, resp);

        } catch (Exception e) {

            e.printStackTrace();

            resp.sendRedirect(req.getContextPath()
                    + "/panel?error=servicios");

        }

    }

    /*
     * ========================================
     * ACCIONES
     * ========================================
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String accion = req.getParameter("accion");
        String error = null;

        try {

            switch (accion) {

                /*
                 * ===========================
                 * AGREGAR
                 * ===========================
                 */
                case "agregar":

                    error = agregarServicio(req);

                    break;

                /*
                 * ===========================
                 * EDITAR
                 * ===========================
                 */
                case "editar":

                    error = editarServicio(req);

                    break;

                /*
                 * ===========================
                 * CAMBIAR ESTADO
                 * ===========================
                 */
                case "estado":

                    cambiarEstado(req);

                    break;

                /*
                 * ===========================
                 * ELIMINAR
                 * ===========================
                 */
                case "eliminar":

                    eliminarServicio(req);

                    break;

            }

        } catch (Exception e) {

            e.printStackTrace();
            error = "error_servidor";

        }

        String destino = "/servicios" + (error != null ? "?error=" + error : "");
        resp.sendRedirect(req.getContextPath() + destino);

    }

    /*
     * ========================================
     * REGISTRAR
     * ========================================
     */
    private String agregarServicio(HttpServletRequest req)
            throws Exception {

        String nombre =
                req.getParameter("nombre");

        if (nombre != null && serviciosDao.existeNombre(nombre.trim(), null)) {
            return "duplicado_nombre";
        }

        int idTipo =
                Integer.parseInt(req.getParameter("id_tipo_servicio"));

        String descripcion =
                req.getParameter("descripcion");

        double precio =
                Double.parseDouble(req.getParameter("precio"));

        String foto = guardarFotoSiViene(req, "");

        TiposServicioBean tipo =
                new TiposServicioBean();

        tipo.setId_tipo_servicio(idTipo);

        ServiciosBean servicio =
                new ServiciosBean();

        servicio.setTipoServicio(tipo);
        servicio.setNombre(nombre);
        servicio.setDescripcion(descripcion);
        servicio.setPrecio(precio);
        servicio.setEstado(1);
        servicio.setFoto(foto);

        serviciosDao.registrar(servicio);
        return null;

    }

    /*
     * ========================================
     * EDITAR
     * ========================================
     */
    private String editarServicio(HttpServletRequest req)
            throws Exception {

        int idServicio =
                Integer.parseInt(req.getParameter("id_servicio"));

        String nombre =
                req.getParameter("nombre");

        if (nombre != null && serviciosDao.existeNombre(nombre.trim(), idServicio)) {
            return "duplicado_nombre";
        }

        int idTipo =
                Integer.parseInt(req.getParameter("id_tipo_servicio"));

        String descripcion =
                req.getParameter("descripcion");

        double precio =
                Double.parseDouble(req.getParameter("precio"));

        int estado =
                Integer.parseInt(req.getParameter("estado"));

        String fotoExistente = req.getParameter("foto_actual");
        String foto = guardarFotoSiViene(req, fotoExistente);

        TiposServicioBean tipo =
                new TiposServicioBean();

        tipo.setId_tipo_servicio(idTipo);

        ServiciosBean servicio =
                new ServiciosBean();

        servicio.setId_servicio(idServicio);
        servicio.setTipoServicio(tipo);
        servicio.setNombre(nombre);
        servicio.setDescripcion(descripcion);
        servicio.setPrecio(precio);
        servicio.setEstado(estado);
        servicio.setFoto(foto);

        serviciosDao.actualizar(servicio);
        return null;

    }

    /**
     * Si el usuario adjuntó un archivo nuevo en el campo "foto", lo guarda en
     * /Images/imagesServicios y devuelve la ruta relativa a usar en FOTO_PORTADA.
     * Si no adjuntó nada, conserva la ruta que ya tenía el servicio (o "" si es nuevo).
     */
    private String guardarFotoSiViene(HttpServletRequest req, String fotoExistente) throws Exception {
        Part parte = req.getPart("foto");
        if (parte == null || parte.getSize() == 0) {
            return fotoExistente != null ? fotoExistente : "";
        }

        String nombreOriginal = obtenerNombreArchivo(parte);
        String extension = "";
        int punto = nombreOriginal.lastIndexOf('.');
        if (punto >= 0) extension = nombreOriginal.substring(punto);

        String nombreNuevo = UUID.randomUUID() + extension;

        String rutaAbsoluta = getServletContext().getRealPath("/" + CARPETA_IMAGENES);
        File carpeta = new File(rutaAbsoluta);
        if (!carpeta.exists()) carpeta.mkdirs();

        try (InputStream is = parte.getInputStream()) {
            Files.copy(is, new File(carpeta, nombreNuevo).toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        return CARPETA_IMAGENES + "/" + nombreNuevo;
    }

    private String obtenerNombreArchivo(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            for (String token : contentDisp.split(";")) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return "imagen";
    }

    /*
     * ========================================
     * ACTIVAR / DESACTIVAR
     * ========================================
     */
    private void cambiarEstado(HttpServletRequest req)
            throws Exception {

        int idServicio =
                Integer.parseInt(req.getParameter("id_servicio"));

        int estado =
                Integer.parseInt(req.getParameter("estado"));

        serviciosDao.actualizarEstado(idServicio, estado);

    }

    /*
     * ========================================
     * ELIMINAR
     * ========================================
     */
    private void eliminarServicio(HttpServletRequest req)
            throws Exception {

        int idServicio =
                Integer.parseInt(req.getParameter("id_servicio"));

        serviciosDao.eliminar(idServicio);

    }

}