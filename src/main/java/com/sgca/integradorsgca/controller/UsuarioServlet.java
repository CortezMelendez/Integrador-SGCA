package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.rolBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.dao.rolDao;
import com.sgca.integradorsgca.model.dao.UsuarioDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UsuariosServlet", urlPatterns = {"/UsuariosServlet"})
public class UsuarioServlet extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();
    private final rolDao rolDao = new rolDao();

    private boolean Autorizado(HttpServletRequest request, String[] rolesPermitidos) {
        HttpSession sesion = request.getSession(false);
        if (sesion == null) return false;

        UsuarioBean usuarioLogueado = (UsuarioBean) sesion.getAttribute("usuarioLogueado");
        if (usuarioLogueado == null || usuarioLogueado.getRol() == null) return false;

        String rolActual = usuarioLogueado.getRol().getRol();
        if (rolActual == null) return false;

        for (String rol : rolesPermitidos) {
            if (rolActual.equalsIgnoreCase(rol)) {
                return true;
            }
        }
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Validar Autorización pasando el arreglo explícito
        if (!Autorizado(request, new String[]{"DUENO", "ADMINISTRADOR"})) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso no autorizado.");
            return;
        }

        try {
            // Obtener la lista de usuarios para la tabla
            List<UsuarioBean> listaUsuarios = usuarioDao.listar();
            request.setAttribute("listaUsuarios", listaUsuarios);

            // Obtener la lista de roles para llenar el <select> en la vista
            List<rolBean> listaRoles = rolDao.listar();
            request.setAttribute("listaRoles", listaRoles);

            request.getRequestDispatcher("views/usuarios.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar los datos de usuarios: " + e.getMessage());
            request.getRequestDispatcher("views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Validar Autorización pasando el arreglo explícito
        if (!Autorizado(request, new String[]{"DUENO", "ADMINISTRADOR"})) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso no autorizado.");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if (accion != null && accion.equalsIgnoreCase("registrar")) {
            try {
                // Capturar parámetros del formulario
                int idRol = Integer.parseInt(request.getParameter("idRol"));
                String nombre = request.getParameter("nombre");
                String apellidoPaterno = request.getParameter("apellidoPaterno");
                String apellidoMaterno = request.getParameter("apellidoMaterno");
                String rfc = request.getParameter("rfc");
                String curp = request.getParameter("curp");
                String correo = request.getParameter("correo");
                String telefono = request.getParameter("telefono");
                String password = request.getParameter("password");
                int estado = Integer.parseInt(request.getParameter("estado"));

                // Crear el objeto Rol asociado
                rolBean rol = new rolBean();
                rol.setId_Rol(idRol);

                // Instanciar UsuarioBean usando el constructor de REGISTRO (Sin ID ni Fecha)
                UsuarioBean nuevoUsuario = new UsuarioBean(
                        rol, nombre, apellidoPaterno, apellidoMaterno,
                        rfc, curp, correo, telefono, password, estado
                );

                // Guardar en base de datos
                boolean registrado = usuarioDao.registrar(nuevoUsuario);

                if (registrado) {
                    response.sendRedirect("UsuariosServlet?msj=registrado");
                } else {
                    request.setAttribute("error", "No se pudo registrar el usuario.");
                    doGet(request, response);
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Error al procesar el registro: " + e.getMessage());
                doGet(request, response);
            }
        } else {
            response.sendRedirect("UsuariosServlet");
        }
    }
}
