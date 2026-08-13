package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.VehImgBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.dao.MarcaDao;
import com.sgca.integradorsgca.model.dao.ModelosDao;
import com.sgca.integradorsgca.model.dao.TiposVehiculoDao;
import com.sgca.integradorsgca.model.dao.VehImgDao;
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
import java.util.ArrayList;
import java.util.List;
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
        maxRequestSize = 40 * 1024 * 1024,    // hasta 6 imágenes (portada + 5 extra) por request
        fileSizeThreshold = 1024 * 1024
)
public class GestionAutosServlet extends HttpServlet {

    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final MarcaDao marcaDao = new MarcaDao();
    private final ModelosDao modelosDao = new ModelosDao();
    private final TiposVehiculoDao tiposVehiculoDao = new TiposVehiculoDao();
    private final VehImgDao vehImgDao = new VehImgDao();

    private static final String REDIRECT_LISTA = "/btn?action=gestionAutos";
    // Carpeta dentro de webapp donde se guardan las fotos (ya existe en el proyecto: /Images/imagesAutos)
    private static final String CARPETA_IMAGENES = "Images/imagesAutos";
    private static final String CAMPO_FOTOS_EXTRA = "fotosExtra";
    private static final int MAX_IMAGENES_EXTRA = 5;

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
        String error = null;

        try {
            if ("registrar".equals(accion)) {
                error = registrar(req);
            } else if ("actualizar".equals(accion)) {
                error = actualizar(req);
            }
        } catch (Exception e) {
            System.err.println("Error al procesar auto: " + e.getMessage());
            e.printStackTrace();
            error = "error_servidor";
        }

        String destino = REDIRECT_LISTA + (error != null ? "&error=" + error : "");
        resp.sendRedirect(req.getContextPath() + destino);
    }

    // Devuelve el código de error a mostrar en el modal (null si todo salió bien)
    private String registrar(HttpServletRequest req) throws IOException, ServletException {
        String placa = req.getParameter("placa");
        if (placa != null && vehiculosDao.existePlaca(placa.trim(), null)) {
            return "duplicado_placa";
        }

        VehiculosBean veh = construirDesdeRequest(req, 0);
        int idVehiculoNuevo = vehiculosDao.registrar(veh);
        if (idVehiculoNuevo > 0) {
            guardarImagenesExtra(req, idVehiculoNuevo, MAX_IMAGENES_EXTRA);
        }
        return null;
    }

    private String actualizar(HttpServletRequest req) throws IOException, ServletException {
        int idVehiculo = Integer.parseInt(req.getParameter("id_Vehiculo"));

        String placa = req.getParameter("placa");
        if (placa != null && vehiculosDao.existePlaca(placa.trim(), idVehiculo)) {
            return "duplicado_placa";
        }

        VehiculosBean veh = construirDesdeRequest(req, idVehiculo);
        vehiculosDao.actualizar(veh);

        // Imágenes extra que el dueño marcó para quitar desde la galería del modal Editar
        String idsAEliminar = req.getParameter("eliminarImagenes");
        if (idsAEliminar != null && !idsAEliminar.trim().isEmpty()) {
            for (String idTexto : idsAEliminar.split(",")) {
                if (idTexto.trim().isEmpty()) continue;
                vehImgDao.eliminar(Integer.parseInt(idTexto.trim()));
            }
        }

        int actuales = vehImgDao.listarPorVehiculo(idVehiculo).size();
        int espacioDisponible = Math.max(0, MAX_IMAGENES_EXTRA - actuales);
        guardarImagenesExtra(req, idVehiculo, espacioDisponible);
        return null;
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
        String descripcion = req.getParameter("descripcion");

        String fotoExistente = req.getParameter("foto_actual"); // ruta que ya tenía (solo en edición)
        String fotoPortada = guardarFotoSiViene(req, fotoExistente);

        int disponible = "Activo".equalsIgnoreCase(estado) ? 1 : 0;

        // Busca o crea la marca, el modelo (ligado a la marca) y la categoría/tipo
        int idMarca = marcaDao.obtenerOCrearId(marca.trim());
        int idModelo = modelosDao.obtenerOCrearId(idMarca, modelo.trim());
        int idTipo = tiposVehiculoDao.obtenerOCrearId(categoria.trim());

        VehiculosBean veh = idVehiculo > 0
                ? new VehiculosBean(idVehiculo, idModelo, idTipo, idAgente, placa, color, anio, precio, disponible, fotoPortada)
                : new VehiculosBean(idModelo, idTipo, idAgente, placa, color, anio, precio, disponible, fotoPortada);
        veh.setDescripcion(descripcion != null ? descripcion.trim() : "");
        return veh;
    }

    /**
     * Si el usuario adjuntó un archivo nuevo en el campo "foto", lo guarda en
     * /Images/imagesAutos y devuelve el nombre de archivo a usar en FOTO_PORTADA
     * (sin la carpeta: detalleVehiculo.jsp y las imágenes "seed" ya asumen esa
     * convención). Si no adjuntó nada, conserva la ruta que ya tenía el vehículo
     * (o "" si es nuevo).
     */
    private String guardarFotoSiViene(HttpServletRequest req, String fotoExistente) throws IOException, ServletException {
        Part parte = req.getPart("foto");
        if (parte == null || parte.getSize() == 0) {
            return fotoExistente != null ? fotoExistente : "";
        }
        return guardarArchivoEnCarpeta(parte);
    }

    // Guarda hasta "maxAGuardar" imágenes adicionales del campo "fotosExtra"
    // (input file "multiple") y las asocia al vehículo en ADMIN.VEHICULO_IMAGENES.
    private void guardarImagenesExtra(HttpServletRequest req, int idVehiculo, int maxAGuardar) throws IOException, ServletException {
        if (maxAGuardar <= 0) return;

        List<Part> partesFoto = new ArrayList<>();
        for (Part parte : req.getParts()) {
            if (CAMPO_FOTOS_EXTRA.equals(parte.getName()) && parte.getSize() > 0) {
                partesFoto.add(parte);
            }
        }

        int guardadas = 0;
        for (Part parte : partesFoto) {
            if (guardadas >= maxAGuardar) break;
            String nombreArchivo = guardarArchivoEnCarpeta(parte);
            vehImgDao.registrar(new VehImgBean(idVehiculo, nombreArchivo));
            guardadas++;
        }
    }

    // Copia el archivo de un Part a /Images/imagesAutos con un nombre único y
    // devuelve solo el nombre de archivo generado.
    private String guardarArchivoEnCarpeta(Part parte) throws IOException {
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

        return nombreNuevo;
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