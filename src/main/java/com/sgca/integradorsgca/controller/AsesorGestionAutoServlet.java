package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.AgentesBean;
import com.sgca.integradorsgca.model.bean.MarcaBean;
import com.sgca.integradorsgca.model.bean.ModelosBean;
import com.sgca.integradorsgca.model.bean.TiposVehiculoBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.VehImgBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.dao.AgentesDao;
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
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Tabla "Gestión de autos" del asesor (pages/asesorPages/gestionarAuto.jsp).
 * Mismo patrón que GestionAutosServlet + GestionBtnServlet (accion=gestionAutos)
 * del dueño, pero adaptado a lo que el DFR permite al Agente (RF 2.2 / 2.1):
 * puede registrar y editar vehículos, pero NUNCA marca/modelo en texto libre
 * (elige entre las marcas/modelos ya dados de alta por el dueño), y el
 * ID_AGENTE responsable se resuelve del lado del servidor a partir de su
 * sesión, nunca de un campo del formulario.
 */
@WebServlet(name = "AsesorGestionAutoServlet", value = "/gestionAutoAsesor")
@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 40 * 1024 * 1024,
        fileSizeThreshold = 1024 * 1024
)
public class AsesorGestionAutoServlet extends HttpServlet {

    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final MarcaDao marcaDao = new MarcaDao();
    private final ModelosDao modelosDao = new ModelosDao();
    private final TiposVehiculoDao tiposVehiculoDao = new TiposVehiculoDao();
    private final VehImgDao vehImgDao = new VehImgDao();
    private final AgentesDao agentesDao = new AgentesDao();

    private static final String RUTA_LISTA = "/gestionAutoAsesor";
    private static final String CARPETA_IMAGENES = "Images/imagesAutos";
    private static final String CAMPO_FOTOS_EXTRA = "fotosExtra";
    private static final int MAX_IMAGENES_EXTRA = 5;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");

        if ("eliminar".equals(accion)) {
            int id = Integer.parseInt(req.getParameter("id"));
            vehiculosDao.eliminar(id);
            resp.sendRedirect(req.getContextPath() + RUTA_LISTA + "?exito=eliminado");
            return;
        }

        if ("cambiarEstado".equals(accion)) {
            int id = Integer.parseInt(req.getParameter("id"));
            int disponible = Integer.parseInt(req.getParameter("disponible"));
            vehiculosDao.cambiarEstado(id, disponible);
            resp.sendRedirect(req.getContextPath() + RUTA_LISTA);
            return;
        }

        mostrarListado(req, resp, null);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");
        String error = null;
        String exito = null;

        HttpSession session = req.getSession(false);
        UsuarioBean asesor = session != null ? (UsuarioBean) session.getAttribute("usuarioLogueado") : null;
        Integer idAgente = asesor != null ? agentesDao.obtenerIdAgentePorUsuario(asesor.getId_usuario()) : null;

        if (idAgente == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=sesion_requerida");
            return;
        }

        try {
            if ("registrar".equals(accion)) {
                error = registrar(req, idAgente);
                if (error == null) exito = "agregado";
            } else if ("actualizar".equals(accion)) {
                error = actualizar(req);
                if (error == null) exito = "editado";
            }
        } catch (Exception e) {
            System.err.println("Error al procesar auto (asesor): " + e.getMessage());
            e.printStackTrace();
            error = "error_servidor";
        }

        if (error != null) {
            mostrarListado(req, resp, error);
        } else {
            resp.sendRedirect(req.getContextPath() + RUTA_LISTA + "?exito=" + exito);
        }
    }

    // Arma la lista de vehículos + catálogos de apoyo (marcas, modelos por marca,
    // tipos) y forward a la vista. Se usa tanto en GET normal como cuando un POST
    // falla y hay que volver a pintar la tabla con el error.
    private void mostrarListado(HttpServletRequest req, HttpServletResponse resp, String error)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        UsuarioBean asesor = session != null ? (UsuarioBean) session.getAttribute("usuarioLogueado") : null;
        Integer idAgenteActual = asesor != null ? agentesDao.obtenerIdAgentePorUsuario(asesor.getId_usuario()) : null;

        List<VehiculosBean> listaVehiculos = vehiculosDao.listar();
        List<MarcaBean> listaMarcas = marcaDao.listar();
        List<TiposVehiculoBean> listaTipos = tiposVehiculoDao.listar();
        List<ModelosBean> listaModelos = modelosDao.listar();

        Map<Integer, List<VehImgBean>> imagenesPorVehiculo = new HashMap<>();
        Map<Integer, String> descripcionPorVehiculo = new HashMap<>();
        for (VehiculosBean v : listaVehiculos) {
            imagenesPorVehiculo.put(v.getId_Vehiculo(), vehImgDao.listarPorVehiculo(v.getId_Vehiculo()));
            descripcionPorVehiculo.put(v.getId_Vehiculo(), v.getDescripcion());
        }

        req.setAttribute("listaVehiculos", listaVehiculos);
        req.setAttribute("listaMarcas", listaMarcas);
        req.setAttribute("listaTipos", listaTipos);
        req.setAttribute("idAgenteActual", idAgenteActual);
        req.setAttribute("imagenesJsonPorVehiculo", aJsonImagenes(imagenesPorVehiculo));
        req.setAttribute("descripcionJsonPorVehiculo", aJsonTextos(descripcionPorVehiculo));
        req.setAttribute("modelosJsonPorMarca", aJsonModelosPorMarca(listaModelos));

        if (req.getParameter("exito") != null) req.setAttribute("exitoParam", req.getParameter("exito"));
        if (error != null) req.setAttribute("errorParam", error);

        req.getRequestDispatcher("/pages/asesorPages/gestionarAuto.jsp").forward(req, resp);
    }

    private String registrar(HttpServletRequest req, int idAgente) throws IOException, ServletException {
        String placa = req.getParameter("placa");
        if (placa != null && vehiculosDao.existePlaca(placa.trim(), null)) {
            return "duplicado_placa";
        }

        VehiculosBean veh = construirDesdeRequest(req, 0, idAgente);
        if (veh == null) return "marca_modelo_invalido";

        int idVehiculoNuevo = vehiculosDao.registrar(veh);
        if (idVehiculoNuevo > 0) {
            guardarImagenesExtra(req, idVehiculoNuevo, MAX_IMAGENES_EXTRA);
        }
        return null;
    }

    private String actualizar(HttpServletRequest req) throws IOException, ServletException {
        int idVehiculo = Integer.parseInt(req.getParameter("id_Vehiculo"));

        VehiculosBean actual = vehiculosDao.buscarPorID(idVehiculo);
        if (actual == null) return "no_encontrado";

        String placa = req.getParameter("placa");
        if (placa != null && vehiculosDao.existePlaca(placa.trim(), idVehiculo)) {
            return "duplicado_placa";
        }

        // El agente responsable original del vehículo se conserva: el asesor
        // no puede reasignar la responsabilidad de un vehículo a través de este
        // formulario (solo el dueño podría hacerlo desde su propia pantalla).
        VehiculosBean veh = construirDesdeRequest(req, idVehiculo, actual.getId_Agente());
        if (veh == null) return "marca_modelo_invalido";

        vehiculosDao.actualizar(veh);

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

    // Arma el bean a partir del formulario. A diferencia del dueño, marca y
    // modelo llegan como IDs de un <select> (nunca texto libre): si no
    // corresponden a un catálogo ya existente, se rechaza la operación.
    private VehiculosBean construirDesdeRequest(HttpServletRequest req, int idVehiculo, int idAgente)
            throws IOException, ServletException {

        int idMarca;
        int idModelo;
        try {
            idMarca = Integer.parseInt(req.getParameter("idMarca"));
            idModelo = Integer.parseInt(req.getParameter("idModelo"));
        } catch (NumberFormatException e) {
            return null;
        }

        if (marcaDao.buscarPorId(idMarca) == null) return null;
        ModelosBean modelo = modelosDao.buscarPorId(idModelo);
        if (modelo == null || modelo.getId_Marca() != idMarca) return null;

        String categoria = req.getParameter("categoria");
        String placa = req.getParameter("placa");
        String color = req.getParameter("color");
        int anio = Integer.parseInt(req.getParameter("anio"));
        BigDecimal precio = new BigDecimal(req.getParameter("precio"));
        String estado = req.getParameter("estado");
        String descripcion = req.getParameter("descripcion");

        String fotoExistente = req.getParameter("foto_actual");
        String fotoPortada = guardarFotoSiViene(req, fotoExistente);

        int disponible = "Activo".equalsIgnoreCase(estado) ? 1 : 0;
        int idTipo = tiposVehiculoDao.obtenerOCrearId(categoria.trim());

        VehiculosBean veh = idVehiculo > 0
                ? new VehiculosBean(idVehiculo, idModelo, idTipo, idAgente, placa, color, anio, precio, disponible, fotoPortada)
                : new VehiculosBean(idModelo, idTipo, idAgente, placa, color, anio, precio, disponible, fotoPortada);
        veh.setDescripcion(descripcion != null ? descripcion.trim() : "");
        return veh;
    }

    private String guardarFotoSiViene(HttpServletRequest req, String fotoExistente) throws IOException, ServletException {
        Part parte = req.getPart("foto");
        if (parte == null || parte.getSize() == 0) {
            return fotoExistente != null ? fotoExistente : "";
        }
        return guardarArchivoEnCarpeta(parte);
    }

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

    // id de marca -> [{idModelo, nombre}], para que el <select> de Modelo se
    // filtre en el cliente según la marca elegida sin pedirlo al servidor.
    private String aJsonModelosPorMarca(List<ModelosBean> modelos) {
        Map<Integer, List<ModelosBean>> porMarca = new HashMap<>();
        for (ModelosBean m : modelos) {
            porMarca.computeIfAbsent(m.getId_Marca(), k -> new ArrayList<>()).add(m);
        }

        StringBuilder json = new StringBuilder("{");
        boolean primeraMarca = true;
        for (Map.Entry<Integer, List<ModelosBean>> entrada : porMarca.entrySet()) {
            if (!primeraMarca) json.append(",");
            primeraMarca = false;
            json.append("\"").append(entrada.getKey()).append("\":[");

            boolean primerModelo = true;
            for (ModelosBean m : entrada.getValue()) {
                if (!primerModelo) json.append(",");
                primerModelo = false;
                json.append("{\"idModelo\":").append(m.getId_Modelo())
                        .append(",\"nombre\":\"").append(escapeJson(m.getNombre())).append("\"}");
            }
            json.append("]");
        }
        json.append("}");
        return json.toString();
    }

    private String aJsonImagenes(Map<Integer, List<VehImgBean>> imagenesPorVehiculo) {
        StringBuilder json = new StringBuilder("{");
        boolean primerVehiculo = true;
        for (Map.Entry<Integer, List<VehImgBean>> entrada : imagenesPorVehiculo.entrySet()) {
            if (!primerVehiculo) json.append(",");
            primerVehiculo = false;
            json.append("\"").append(entrada.getKey()).append("\":[");

            boolean primeraImagen = true;
            for (VehImgBean img : entrada.getValue()) {
                if (!primeraImagen) json.append(",");
                primeraImagen = false;
                json.append("{\"idImagen\":").append(img.getIdImagen())
                        .append(",\"ruta\":\"").append(escapeJson(img.getRutaImagen())).append("\"}");
            }
            json.append("]");
        }
        json.append("}");
        return json.toString();
    }

    private String aJsonTextos(Map<Integer, String> textoPorId) {
        StringBuilder json = new StringBuilder("{");
        boolean primero = true;
        for (Map.Entry<Integer, String> entrada : textoPorId.entrySet()) {
            if (!primero) json.append(",");
            primero = false;
            json.append("\"").append(entrada.getKey()).append("\":\"")
                    .append(escapeJsonConSaltos(entrada.getValue())).append("\"");
        }
        json.append("}");
        return json.toString();
    }

    private String escapeJsonConSaltos(String valor) {
        if (valor == null) return "";
        return valor.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r\n", "\\n")
                .replace("\n", "\\n")
                .replace("\r", "\\n")
                .replace("<", "\\u003c")
                .replace(">", "\\u003e");
    }

    private String escapeJson(String valor) {
        if (valor == null) return "";
        return valor.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", " ")
                .replace("<", "\\u003c")
                .replace(">", "\\u003e");
    }
}
