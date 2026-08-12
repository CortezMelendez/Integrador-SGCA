package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.AgentesBean;
import com.sgca.integradorsgca.model.bean.ClientesBean;
import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.TiposServicioBean;
import com.sgca.integradorsgca.model.bean.TiposVehiculoBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.dao.AgentesDao;
import com.sgca.integradorsgca.model.dao.ClientesDao;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
import com.sgca.integradorsgca.model.dao.TiposServicioDao;
import com.sgca.integradorsgca.model.dao.TiposVehiculoDao;
import com.sgca.integradorsgca.model.dao.UsuarioDao;
import com.sgca.integradorsgca.model.dao.VehiculosDao;
import com.sgca.integradorsgca.utils.SessionRegistry;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/btn")
public class GestionBtnServlet extends HttpServlet {

    private static final String BASE_DUENIO = "/pages/duenioPages/";
    private static final int ID_ROL_AGENTE = 2;
    private static final int ID_ROL_CLIENTE = 3;

    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final TiposVehiculoDao tiposVehiculoDao = new TiposVehiculoDao();
    private final AgentesDao agentesDao = new AgentesDao();
    private final ClientesDao clientesDao = new ClientesDao();
    private final ServiciosDao serviciosDao = new ServiciosDao();
    private final TiposServicioDao tiposServicioDao = new TiposServicioDao();
    private final UsuarioDao usuarioDao = new UsuarioDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UsuarioBean usuario = (session != null)
                ? (UsuarioBean) session.getAttribute("usuarioLogueado")
                : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=sesion_requerida");
            return;
        }

        String rol = obtenerNombreRol(usuario);
        if (!"ADMIN".equals(rol)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=no_autorizado");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "inicio";

        try {
            switch (action) {

                case "actualizarPerfil":
                    actualizarPerfil(request, response, usuario);
                    return;

                case "cerrarSesionTodos":
                    SessionRegistry.invalidarTodas(usuario.getId_usuario());
                    response.sendRedirect(request.getContextPath() + "/login.jsp?exito=sesion_cerrada");
                    return;

                case "gestionServicio":
                    List<ServiciosBean> listaServicios = serviciosDao.listar();
                    List<TiposServicioBean> listaTiposServicio = tiposServicioDao.listar();

                    request.setAttribute("listaServicios", listaServicios);
                    request.setAttribute("listaTipos", listaTiposServicio);

                    request.getRequestDispatcher(BASE_DUENIO + "gestionServicios.jsp").forward(request, response);
                    break;

                case "gestionEmpleados":
                    List<UsuarioBean> listaEmpleados = usuarioDao.listarPorRol(ID_ROL_AGENTE);

                    // Cuántos clientes activos tiene cada agente, para saber si al darlo
                    // de baja hace falta pedir un agente receptor (modal "Transferir clientes"),
                    // y el detalle (nombre/correo) para el modal "Ver clientes" de la columna Clientes.
                    Map<Integer, Integer> clientesPorAgente = new HashMap<>();
                    Map<Integer, List<ClientesBean>> detalleClientesPorAgente = new HashMap<>();
                    for (UsuarioBean empleado : listaEmpleados) {
                        List<ClientesBean> clientesDelAgente =
                                agentesDao.listarClientesAsignados(empleado.getId_usuario());
                        clientesPorAgente.put(empleado.getId_usuario(), clientesDelAgente.size());
                        detalleClientesPorAgente.put(empleado.getId_usuario(), clientesDelAgente);
                    }

                    request.setAttribute("listaUsuarios", listaEmpleados);
                    request.setAttribute("clientesPorAgente", clientesPorAgente);
                    request.setAttribute("clientesJsonPorAgente", aJson(detalleClientesPorAgente));
                    request.getRequestDispatcher(BASE_DUENIO + "gestionEmpleados.jsp").forward(request, response);
                    break;

                case "gestionClientes":
                    List<UsuarioBean> listaClientes = usuarioDao.listarPorRol(ID_ROL_CLIENTE);

                    // Nombre del agente asesor asignado a cada cliente, su ID_CLIENTE y su
                    // ID_AGENTE actual (todos indexados por ID_USUARIO del cliente), para poder
                    // mostrar y reasignar el asesor desde el modal de la columna "Asesor".
                    Map<Integer, String> asesorPorCliente = new HashMap<>();
                    Map<Integer, Integer> idClientePorUsuario = new HashMap<>();
                    Map<Integer, Integer> idAgentePorUsuario = new HashMap<>();
                    for (ClientesBean c : clientesDao.listar()) {
                        asesorPorCliente.put(c.getIdUsuario(), c.getNombreAgente());
                        idClientePorUsuario.put(c.getIdUsuario(), c.getIdCliente());
                        if (c.getIdAgente() != null) {
                            idAgentePorUsuario.put(c.getIdUsuario(), c.getIdAgente());
                        }
                    }

                    request.setAttribute("listaUsuarios", listaClientes);
                    request.setAttribute("asesorPorCliente", asesorPorCliente);
                    request.setAttribute("idClientePorUsuario", idClientePorUsuario);
                    request.setAttribute("idAgentePorUsuario", idAgentePorUsuario);
                    request.setAttribute("listaAgentes", agentesDao.listar());
                    request.getRequestDispatcher(BASE_DUENIO + "gestionClientes.jsp").forward(request, response);
                    break;

                case "gestionAutos":
                    List<VehiculosBean> listaVehiculos = vehiculosDao.listar();
                    List<TiposVehiculoBean> listaTipos = tiposVehiculoDao.listar();
                    List<AgentesBean> listaAgentes = agentesDao.listar();

                    request.setAttribute("listaVehiculos", listaVehiculos);
                    request.setAttribute("listaTipos", listaTipos);
                    request.setAttribute("listaAgentes", listaAgentes);

                    request.getRequestDispatcher(BASE_DUENIO + "gestionAutos.jsp").forward(request, response);
                    break;

                default:
                    List<VehiculosBean> listaVehiculosInicio = vehiculosDao.listarDisponibles();
                    List<TiposVehiculoBean> listaTiposInicio = tiposVehiculoDao.listar();

                    request.setAttribute("vehiculos", listaVehiculosInicio);
                    request.setAttribute("listaTipos", listaTiposInicio);

                    request.getRequestDispatcher(BASE_DUENIO + "indexDuenio.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/btn?action=inicio&error=carga");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // Actualiza correo/teléfono del usuario en sesión (modal "Editar Perfil").
    // Responde texto plano: 200 = éxito, 4xx/5xx = mensaje de error para mostrar en el modal.
    private void actualizarPerfil(HttpServletRequest request, HttpServletResponse response, UsuarioBean usuario)
            throws IOException {

        response.setContentType("text/html; charset=UTF-8");

        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");

        if (correo == null || correo.trim().isEmpty() || !correo.contains("@")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("Ingresa un correo electrónico válido.");
            return;
        }

        if (telefono == null || telefono.trim().length() < 10) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("Ingresa un teléfono válido (mínimo 10 dígitos).");
            return;
        }

        try {
            boolean actualizado = usuarioDao.actualizarPerfil(
                    usuario.getId_usuario(), correo.trim(), telefono.trim());

            if (actualizado) {
                // Refrescamos los datos en la sesión para que se reflejen de inmediato
                usuario.setCorreo(correo.trim());
                usuario.setTelefono(telefono.trim());
                request.getSession().setAttribute("usuarioLogueado", usuario);

                response.getWriter().println("Perfil actualizado correctamente.");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().println("No se pudo actualizar el perfil. Intenta de nuevo.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Ocurrió un error en el servidor. Intenta más tarde.");
        }
    }

    // Serializa el detalle de clientes por agente a JSON plano, para que el modal
    // "Ver clientes" (gestionEmpleados.jsp) lo consuma en el cliente sin peticiones extra.
    private String aJson(Map<Integer, List<ClientesBean>> detallePorAgente) {
        StringBuilder json = new StringBuilder("{");
        boolean primerAgente = true;
        for (Map.Entry<Integer, List<ClientesBean>> entrada : detallePorAgente.entrySet()) {
            if (!primerAgente) json.append(",");
            primerAgente = false;
            json.append("\"").append(entrada.getKey()).append("\":[");

            boolean primerCliente = true;
            for (ClientesBean cliente : entrada.getValue()) {
                if (!primerCliente) json.append(",");
                primerCliente = false;
                json.append("{\"nombre\":\"").append(escapeJson(cliente.getNombreCliente()))
                        .append("\",\"correo\":\"").append(escapeJson(cliente.getCorreoCliente()))
                        .append("\"}");
            }
            json.append("]");
        }
        json.append("}");
        return json.toString();
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

    private String obtenerNombreRol(UsuarioBean usuario) {
        if (usuario != null && usuario.getRol() != null && usuario.getRol().getRol() != null) {
            String nombreRol = usuario.getRol().getRol().trim().toUpperCase();
            if (!nombreRol.isEmpty()) return nombreRol;
        }
        if (usuario != null && usuario.getRol() != null) {
            switch (usuario.getRol().getId_Rol()) {
                case 1: return "ADMIN";
                case 2: return "AGENTE";
                case 3: return "CLIENTE";
            }
        }
        return "INVITADO";
    }
}