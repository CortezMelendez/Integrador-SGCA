package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.ClientesBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.rolBean;
import com.sgca.integradorsgca.model.dao.AgentesDao;
import com.sgca.integradorsgca.model.dao.ClientesDao;
import com.sgca.integradorsgca.model.dao.UsuarioDao;
import com.sgca.integradorsgca.utils.PasswordUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Tabla "Gestión de clientes" del asesor (pages/asesorPages/gestionClientes.jsp).
 * Mismo diseño/patrón que gestionUsuarios del dueño (agregar/editar/eliminar +
 * confirmación), pero acotado a lo que el DFR permite al Agente: solo ve y
 * administra los clientes de su propia cartera (RF Módulo 3), nunca a todos
 * los clientes del sistema ni la reasignación de asesor (eso sigue siendo
 * exclusivo del Dueño en gestionClientes.jsp).
 */
@WebServlet(name = "AsesorGestionClienteServlet", value = "/gestionClienteAsesor")
public class AsesorGestionClienteServlet extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();
    private final ClientesDao clientesDao = new ClientesDao();
    private final AgentesDao agentesDao = new AgentesDao();

    private static final int ID_ROL_CLIENTE = 3;
    private static final String RUTA_LISTA = "/gestionClienteAsesor";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");

        HttpSession session = req.getSession(false);
        UsuarioBean asesor = session != null ? (UsuarioBean) session.getAttribute("usuarioLogueado") : null;
        if (asesor == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=sesion_requerida");
            return;
        }

        try {
            if ("eliminar".equals(accion)) {
                int idUsuario = Integer.parseInt(req.getParameter("id"));
                if (!esClientePropio(asesor.getId_usuario(), idUsuario)) {
                    resp.sendRedirect(req.getContextPath() + RUTA_LISTA + "?error=no_autorizado");
                    return;
                }
                boolean ok = usuarioDao.eliminar(idUsuario);
                resp.sendRedirect(req.getContextPath() + RUTA_LISTA + (ok ? "?exito=eliminado" : "?error=no_se_pudo_eliminar"));
                return;
            }

            if ("cambiarEstado".equals(accion)) {
                int idUsuario = Integer.parseInt(req.getParameter("id"));
                int estado = Integer.parseInt(req.getParameter("estado"));
                if (esClientePropio(asesor.getId_usuario(), idUsuario)) {
                    usuarioDao.cambiarEstado(idUsuario, estado);
                }
                resp.sendRedirect(req.getContextPath() + RUTA_LISTA);
                return;
            }

            if ("asignarAsesor".equals(accion)) {
                int idCliente = Integer.parseInt(req.getParameter("idCliente"));

                // Solo se puede "tomar" un cliente que todavía no tiene asesor
                // asignado (autorregistrado o liberado por el dueño); reasignar
                // un cliente que ya pertenece a otro asesor sigue siendo
                // exclusivo del dueño.
                boolean esDisponible = clientesDao.listarClientesDisponibles().stream()
                        .anyMatch(c -> c.getIdCliente() == idCliente);

                if (esDisponible) {
                    Integer idAgente = agentesDao.obtenerIdAgentePorUsuario(asesor.getId_usuario());
                    if (idAgente != null) {
                        clientesDao.asignarAgente(idCliente, idAgente);
                    }
                    resp.sendRedirect(req.getContextPath() + RUTA_LISTA + "?exito=asignado");
                } else {
                    resp.sendRedirect(req.getContextPath() + RUTA_LISTA + "?error=no_autorizado");
                }
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + RUTA_LISTA + "?error=error_servidor");
            return;
        }

        mostrarListado(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");

        HttpSession session = req.getSession(false);
        UsuarioBean asesor = session != null ? (UsuarioBean) session.getAttribute("usuarioLogueado") : null;
        if (asesor == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=sesion_requerida");
            return;
        }

        String error = null;
        try {
            if ("registrar".equals(accion)) {
                error = registrar(req, asesor);
            } else if ("actualizar".equals(accion)) {
                error = actualizar(req, asesor);
            }
        } catch (Exception e) {
            System.err.println("Error al procesar cliente (asesor): " + e.getMessage());
            e.printStackTrace();
            error = "error_servidor";
        }

        if (error != null) {
            resp.sendRedirect(req.getContextPath() + RUTA_LISTA + "?error=" + error);
        } else {
            resp.sendRedirect(req.getContextPath() + RUTA_LISTA + "?exito=" + ("registrar".equals(accion) ? "agregado" : "editado"));
        }
    }

    private void mostrarListado(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UsuarioBean asesor = (UsuarioBean) session.getAttribute("usuarioLogueado");

        List<ClientesBean> misClientes = agentesDao.listarClientesAsignados(asesor.getId_usuario());
        List<ClientesBean> disponibles = clientesDao.listarClientesDisponibles();

        // idUsuario -> idCliente (lo necesita el botón "Asignar asesor") e
        // idUsuario -> ¿está disponible? (para mostrar el botón solo en esos)
        Map<Integer, Integer> idClientePorUsuario = new HashMap<>();
        Set<Integer> idsDisponibles = new HashSet<>();
        Set<Integer> idsVisibles = new HashSet<>();

        for (ClientesBean c : misClientes) {
            idClientePorUsuario.put(c.getIdUsuario(), c.getIdCliente());
            idsVisibles.add(c.getIdUsuario());
        }
        for (ClientesBean c : disponibles) {
            idClientePorUsuario.put(c.getIdUsuario(), c.getIdCliente());
            idsDisponibles.add(c.getIdUsuario());
            idsVisibles.add(c.getIdUsuario());
        }

        try {
            List<UsuarioBean> todosClientes = usuarioDao.listarPorRol(ID_ROL_CLIENTE);
            todosClientes.removeIf(u -> !idsVisibles.contains(u.getId_usuario()));
            req.setAttribute("listaClientes", todosClientes);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("listaClientes", new java.util.ArrayList<UsuarioBean>());
        }

        req.setAttribute("idClientePorUsuario", idClientePorUsuario);
        req.setAttribute("idsDisponibles", idsDisponibles);

        req.getRequestDispatcher("/pages/asesorPages/gestionClientes.jsp").forward(req, resp);
    }

    // Confirma que el ID_USUARIO pertenece a un cliente de la cartera del
    // asesor logueado, antes de dejarlo editar/eliminar/cambiar su estado.
    private boolean esClientePropio(int idUsuarioAsesor, int idUsuarioCliente) {
        List<ClientesBean> misClientes = agentesDao.listarClientesAsignados(idUsuarioAsesor);
        for (ClientesBean c : misClientes) {
            if (c.getIdUsuario() == idUsuarioCliente) return true;
        }
        return false;
    }

    private String registrar(HttpServletRequest req, UsuarioBean asesor) throws Exception {
        UsuarioBean usuario = construirDesdeRequest(req);

        String duplicado = usuarioDao.validarDuplicados(usuario);
        if (duplicado != null) return "duplicado_" + duplicado.toLowerCase();

        String passwordPlano = req.getParameter("password");
        if (passwordPlano == null || passwordPlano.trim().length() < 8) {
            return "password_invalido";
        }
        usuario.setPassword(PasswordUtils.hashPassword(passwordPlano.trim()));

        boolean ok = usuarioDao.registrar(usuario);
        if (!ok) return "error_registro";

        UsuarioBean creado = usuarioDao.obtenerPorCorreo(usuario.getCorreo());
        if (creado == null) return "error_vinculo_cliente";

        Integer idAgente = agentesDao.obtenerIdAgentePorUsuario(asesor.getId_usuario());

        ClientesBean cliente = new ClientesBean();
        cliente.setIdUsuario(creado.getId_usuario());
        cliente.setIdAgente(idAgente);

        boolean vinculado = clientesDao.registrar(cliente);
        return vinculado ? null : "error_vinculo_cliente";
    }

    private String actualizar(HttpServletRequest req, UsuarioBean asesor) throws Exception {
        int idUsuario = Integer.parseInt(req.getParameter("id_usuario"));

        if (!esClientePropio(asesor.getId_usuario(), idUsuario)) {
            return "no_autorizado";
        }

        UsuarioBean usuario = construirDesdeRequest(req);
        usuario.setId_usuario(idUsuario);

        String duplicado = usuarioDao.validarDuplicadosExcluyendo(usuario, idUsuario);
        if (duplicado != null) return "duplicado_" + duplicado.toLowerCase();

        boolean ok = usuarioDao.actualizar(usuario);
        return ok ? null : "error_actualizacion";
    }

    private UsuarioBean construirDesdeRequest(HttpServletRequest req) {
        rolBean rol = new rolBean();
        rol.setId_Rol(ID_ROL_CLIENTE);

        String estadoParam = req.getParameter("estado");
        int estado = "Activo".equalsIgnoreCase(estadoParam) ? 1 : 0;

        UsuarioBean usuario = new UsuarioBean();
        usuario.setRol(rol);
        usuario.setNombre(req.getParameter("nombre").trim());
        usuario.setApellidoPaterno(req.getParameter("apellidoPaterno").trim());
        String materno = req.getParameter("apellidoMaterno");
        usuario.setApellidoMaterno(materno != null ? materno.trim() : "");
        usuario.setRfc(req.getParameter("rfc").trim().toUpperCase());
        usuario.setCurp(req.getParameter("curp").trim().toUpperCase());
        usuario.setCorreo(req.getParameter("correo").trim());
        usuario.setTelefono(req.getParameter("telefono").trim());
        usuario.setEstado(estado);
        return usuario;
    }
}
