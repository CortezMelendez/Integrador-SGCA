package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.dao.MarcaDao;
import com.sgca.integradorsgca.model.dao.ModelosDao;
import com.sgca.integradorsgca.model.dao.TiposVehiculoDao;
import com.sgca.integradorsgca.model.dao.VehiculosDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 * Servlet encargado de las acciones del CRUD de autos que se muestra
 * en gestionAutos.jsp (registrar, actualizar, eliminar y cambiar estado).
 * El listado en sí se arma en GestionBtnServlet (accion=gestionAutos),
 * que es quien realmente renderiza la página.
 *
 * Acepta multipart/form-data para poder recibir el archivo de la foto
 * de portada (campo "foto"). Si no se sube una foto nueva, conserva la
 * que ya tenía el vehículo (campo oculto "foto_actual").
 */
@WebServlet(name = "GestionAutosServlet", value = "/gestionAutos")
@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,        // 5 MB por imagen
        maxRequestSize = 10 * 1024 * 1024,    // 10 MB por request
        fileSizeThreshold = 1024 * 1024
)
public class GestionAutosServlet extends HttpServlet {

    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final MarcaDao marcaDao = new MarcaDao();
    private final ModelosDao modelosDao = new ModelosDao();
    private final TiposVehiculoDao tiposVehiculoDao = new TiposVehiculoDao();

    private static final String REDIRECT_LISTA = "/btn?action=gestionAutos";
    // Carpeta dentro de webapp donde se guardan las fotos (ya existe en el proyecto: /Images/imagesAutos)
    private static final String CARPETA_IMAGENES = "Images/imagesAutos";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");

        if ("eliminar".equals(accion)) {
            int id = Integer.parseInt(req.getParameter("id"));
            vehiculosDao.eliminar(id);
        } else if ("cambiarEstado".equals(accion)) {
            int id = Integer.parseInt(req.getParameter("id"));
            int disponible = Integer.parseInt(req.getParameter("disponible"));
            vehiculosDao.cambiarEstado(id, disponible);
        }

        resp.sendRedirect(req.getContextPath() + REDIRECT_LISTA);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");

        try {
            if ("registrar".equals(accion)) {
                registrar(req);
            } else if ("actualizar".equals(accion)) {
                actualizar(req);
            }
        } catch (Exception e) {
            System.err.println("Error al procesar auto: " + e.getMessage());
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + REDIRECT_LISTA);
    }

    private void registrar(HttpServletRequest req) throws IOException, ServletException {
        VehiculosBean veh = construirDesdeRequest(req, 0);
        vehiculosDao.registrar(veh);
    }

    private void actualizar(HttpServletRequest req) throws IOException, ServletException {
        int idVehiculo = Integer.parseInt(req.getParameter("id_Vehiculo"));
        VehiculosBean veh = construirDesdeRequest(req, idVehiculo);
        vehiculosDao.actualizar(veh);
    }

    // Arma el bean a partir de los campos del formulario (marca/modelo/categoría en texto libre)
    private VehiculosBean construirDesdeRequest(HttpServletRequest req, int idVehiculo) throws IOException, ServletException {
        String marca = req.getParameter("marca");
        String modelo = req.getParameter("modelo");
        String categoria = req.getParameter("categoria");
        String placa = req.getParameter("placa");
        String color = req.getParameter("color");
        int anio = Integer.parseInt(req.getParameter("anio"));
        BigDecimal precio = new BigDecimal(req.getParameter("precio"));
        int idAgente = Integer.parseInt(req.getParameter("id_Agente"));
        String estado = req.getParameter("estado");

        String fotoExistente = req.getParameter("foto_actual"); // ruta que ya tenía (solo en edición)
        String fotoPortada = guardarFotoSiViene(req, fotoExistente);

        int disponible = "Activo".equalsIgnoreCase(estado) ? 1 : 0;

        // Busca o crea la marca, el modelo (ligado a la marca) y la categoría/tipo
        int idMarca = marcaDao.obtenerOCrearId(marca.trim());
        int idModelo = modelosDao.obtenerOCrearId(idMarca, modelo.trim());
        int idTipo = tiposVehiculoDao.obtenerOCrearId(categoria.trim());

        if (idVehiculo > 0) {
            return new VehiculosBean(idVehiculo, idModelo, idTipo, idAgente, placa, color, anio, precio, disponible, fotoPortada);
        }
        return new VehiculosBean(idModelo, idTipo, idAgente, placa, color, anio, precio, disponible, fotoPortada);
    }

    /**
     * Si el usuario adjuntó un archivo nuevo en el campo "foto", lo guarda en
     * /Images/imagesAutos y devuelve la ruta relativa a usar en FOTO_PORTADA.
     * Si no adjuntó nada, conserva la ruta que ya tenía el vehículo (o "" si es nuevo).
     */
    private String guardarFotoSiViene(HttpServletRequest req, String fotoExistente) throws IOException, ServletException {
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
}