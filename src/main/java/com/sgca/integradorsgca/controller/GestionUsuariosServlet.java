package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.rolBean;
import com.sgca.integradorsgca.model.dao.UsuarioDao;
import com.sgca.integradorsgca.utils.PasswordUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * CRUD de usuarios (ADMIN.USUARIOS) usado por gestionEmpleados.jsp y
 * gestionClientes.jsp. Ambas pantallas son la misma tabla filtrada por
 * ID_ROL (2 = Agente/Empleado, 3 = Cliente), así que comparten este servlet.
 */
@WebServlet(name = "GestionUsuariosServlet", value = "/gestionUsuarios")
public class GestionUsuariosServlet extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();

    private static final int ID_ROL_AGENTE = 2;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");
        String error = null;

        try {
            if ("cambiarEstado".equals(accion)) {
                int idUsuario = Integer.parseInt(req.getParameter("id"));
                int estado = Integer.parseInt(req.getParameter("estado"));
                usuarioDao.cambiarEstado(idUsuario, estado);

            } else if ("eliminar".equals(accion)) {
                int idUsuario = Integer.parseInt(req.getParameter("id"));
                boolean ok = usuarioDao.eliminar(idUsuario);
                if (!ok) error = "no_se_pudo_eliminar";
            }
        } catch (Exception e) {
            e.printStackTrace();
            error = "error_servidor";
        }

        resp.sendRedirect(req.getContextPath() + destino(req, error));
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
            System.err.println("Error al procesar usuario: " + e.getMessage());
            e.printStackTrace();
            error = "error_servidor";
        }

        resp.sendRedirect(req.getContextPath() + destino(req, error));
    }

    private String destino(HttpServletRequest req, String error) {
        int idRol = Integer.parseInt(req.getParameter("idRol"));
        String base = idRol == ID_ROL_AGENTE ? "/btn?action=gestionEmpleados" : "/btn?action=gestionClientes";
        return error != null ? base + "&error=" + error : base;
    }

    private String registrar(HttpServletRequest req) throws Exception {
        UsuarioBean usuario = construirDesdeRequest(req);

        String duplicado = usuarioDao.validarDuplicados(usuario);
        if (duplicado != null) return "duplicado_" + duplicado.toLowerCase();

        String passwordPlano = req.getParameter("password");
        if (passwordPlano == null || passwordPlano.trim().length() < 8) {
            return "password_invalido";
        }
        usuario.setPassword(PasswordUtils.hashPassword(passwordPlano.trim()));

        boolean ok = usuarioDao.registrar(usuario);
        return ok ? null : "error_registro";
    }

    private String actualizar(HttpServletRequest req) throws Exception {
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
}
