package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.AgentesBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.rolBean;
import com.sgca.integradorsgca.model.dao.AgentesDao;
import com.sgca.integradorsgca.model.dao.UsuarioDao;
import com.sgca.integradorsgca.utils.PasswordUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

/**
 * CRUD de usuarios (ADMIN.USUARIOS) usado por gestionEmpleados.jsp y
 * gestionClientes.jsp. Ambas pantallas son la misma tabla filtrada por
 * ID_ROL (2 = Agente/Empleado, 3 = Cliente), así que comparten este servlet.
 * Solo el Dueño (ADMIN) puede gestionar empleados/clientes, y solo puede
 * crear/editar usuarios con ID_ROL 2 o 3 (nunca 1 = ADMIN).
 */
@WebServlet(name = "GestionUsuariosServlet", value = "/gestionUsuarios")
public class GestionUsuariosServlet extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();
    private final AgentesDao agentesDao = new AgentesDao();

    private static final int ID_ROL_AGENTE = 2;
    private static final int ID_ROL_CLIENTE = 3;

    private boolean esRolGestionable(int idRol) {
        return idRol == ID_ROL_AGENTE || idRol == ID_ROL_CLIENTE;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!esAdmin(req, resp)) return;

        String accion = req.getParameter("accion");
        String error = null;
        String exito = null;

        try {
            if ("cambiarEstado".equals(accion)) {
                int idUsuario = Integer.parseInt(req.getParameter("id"));
                int estado = Integer.parseInt(req.getParameter("estado"));
                int idRol = Integer.parseInt(req.getParameter("idRol"));

                if (!esRolGestionable(idRol)) {
                    error = "rol_invalido";
                } else if (idRol == ID_ROL_AGENTE && estado == 0 && agentesDao.contarClientesAsignados(idUsuario) > 0) {
                    // No se puede dar de baja a un agente con clientes activos sin transferirlos antes.
                    error = "clientes_activos";
                } else {
                    usuarioDao.cambiarEstado(idUsuario, estado);
                }

            } else if ("eliminar".equals(accion)) {
                int idRol = Integer.parseInt(req.getParameter("idRol"));

                if (!esRolGestionable(idRol)) {
                    error = "rol_invalido";
                } else if (idRol == ID_ROL_AGENTE) {
                    // Un agente nunca se borra físicamente: su fila en AGENTES (y el
                    // historial de ventas/vehículos ligado a él) sigue apuntando a
                    // USUARIOS, así que un DELETE directo siempre viola la llave
                    // foránea. "Eliminar" un agente equivale a darlo de baja.
                    error = darDeBaja(req);
                } else {
                    int idUsuario = Integer.parseInt(req.getParameter("id"));
                    boolean ok = usuarioDao.eliminar(idUsuario);
                    if (!ok) error = "no_se_pudo_eliminar";
                }
                if (error == null) exito = "eliminado";

            } else if ("darDeBaja".equals(accion)) {
                error = darDeBaja(req);
                if (error == null) exito = "eliminado";
            }
        } catch (Exception e) {
            e.printStackTrace();
            error = "error_servidor";
        }

        resp.sendRedirect(req.getContextPath() + destino(req, error, exito));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!esAdmin(req, resp)) return;

        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");
        String error = null;
        String exito = null;

        try {
            if ("registrar".equals(accion)) {
                error = registrar(req);
                if (error == null) exito = "agregado";
            } else if ("actualizar".equals(accion)) {
                error = actualizar(req);
                if (error == null) exito = "editado";
            }
        } catch (Exception e) {
            System.err.println("Error al procesar usuario: " + e.getMessage());
            e.printStackTrace();
            error = "error_servidor";
        }

        resp.sendRedirect(req.getContextPath() + destino(req, error, exito));
    }

    private String destino(HttpServletRequest req, String error, String exito) {
        int idRol = Integer.parseInt(req.getParameter("idRol"));
        String base = idRol == ID_ROL_AGENTE ? "/btn?action=gestionEmpleados" : "/btn?action=gestionClientes";
        if (error != null) return base + "&error=" + error;
        if (exito != null) return base + "&exito=" + exito;
        return base;
    }

    /**
     * Da de baja a un agente (idRol=2). Si tiene clientes activos, exige un
     * agente receptor y transfiere los clientes antes de desactivarlo; si no
     * tiene clientes, la baja se procesa directamente.
     */
    private String darDeBaja(HttpServletRequest req) throws Exception {
        int idAgente = Integer.parseInt(req.getParameter("id"));
        String idReceptorParam = req.getParameter("idReceptor");

        int clientesActivos = agentesDao.contarClientesAsignados(idAgente);

        if (clientesActivos == 0) {
            boolean ok = agentesDao.bajaAgente(idAgente);
            return ok ? null : "error_baja";
        }

        if (idReceptorParam == null || idReceptorParam.trim().isEmpty()) {
            return "receptor_requerido";
        }

        int idReceptor = Integer.parseInt(idReceptorParam.trim());
        if (idReceptor == idAgente) {
            return "receptor_invalido";
        }

        boolean ok = agentesDao.darDeBajaConTransferencia(idAgente, idReceptor);
        return ok ? null : "error_transferencia";
    }

    private String registrar(HttpServletRequest req) throws Exception {
        int idRol = Integer.parseInt(req.getParameter("idRol"));
        if (!esRolGestionable(idRol)) return "rol_invalido";

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

        // Si es empleado (idRol=2), también se crea su fila en ADMIN.AGENTES:
        // VENTAS y VEHICULOS referencian AGENTES, no USUARIOS directamente,
        // así que sin esta fila el empleado no puede operar como agente.
        if (usuario.getRol().getId_Rol() == ID_ROL_AGENTE) {

            UsuarioBean creado = usuarioDao.obtenerPorCorreo(usuario.getCorreo());
            if (creado == null) return "error_vinculo_agente";

            AgentesBean agente = new AgentesBean();
            agente.setIdUsuario(creado.getId_usuario());
            agente.setEstado(usuario.getEstado());

            try {
                boolean agenteOk = agentesDao.registrar(agente);
                if (!agenteOk) return "error_vinculo_agente";
            } catch (SQLException e) {
                e.printStackTrace();
                return "error_vinculo_agente";
            }
        }

        return null;
    }

    private String actualizar(HttpServletRequest req) throws Exception {
        int idRol = Integer.parseInt(req.getParameter("idRol"));
        if (!esRolGestionable(idRol)) return "rol_invalido";

        int idUsuario = Integer.parseInt(req.getParameter("id_usuario"));
        UsuarioBean usuario = construirDesdeRequest(req);
        usuario.setId_usuario(idUsuario);

        String duplicado = usuarioDao.validarDuplicadosExcluyendo(usuario, idUsuario);
        if (duplicado != null) return "duplicado_" + duplicado.toLowerCase();

        boolean ok = usuarioDao.actualizar(usuario);
        return ok ? null : "error_actualizacion";
    }

    private UsuarioBean construirDesdeRequest(HttpServletRequest req) {
        int idRol = Integer.parseInt(req.getParameter("idRol"));
        rolBean rol = new rolBean();
        rol.setId_Rol(idRol);

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

    // Solo el Dueño puede gestionar empleados/clientes desde este servlet.
    // Si no hay sesión o el rol no es ADMIN, redirige y regresa false para
    // que el caller no siga procesando la petición.
    private boolean esAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        UsuarioBean usuario = (session != null)
                ? (UsuarioBean) session.getAttribute("usuarioLogueado")
                : null;

        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=sesion_requerida");
            return false;
        }

        if (!"ADMIN".equals(obtenerNombreRol(usuario))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=no_autorizado");
            return false;
        }

        return true;
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