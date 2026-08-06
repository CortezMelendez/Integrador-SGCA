package com.sgca.integradorsgca.controller;


import com.sgca.integradorsgca.model.bean.UsuarioBean;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/nav")
public class NavBarAdminServlet extends HttpServlet {

    private static final String BASE_DUENIO = "/pages/duenioPages/";

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

        String action = request.getParameter("action");
        if (action == null) action = "inicio";

        switch (action) {
            case "inicio":
                request.getRequestDispatcher(BASE_DUENIO + "indexDuenio.jsp").forward(request, response);
                break;

            case "dashboard":
                request.getRequestDispatcher(BASE_DUENIO + "dashboard.jsp").forward(request, response);
                break;

            case "historial":
                request.getRequestDispatcher(BASE_DUENIO + "historial.jsp").forward(request, response);
                break;

            case "perfil":
                request.setAttribute("mensaje", "Sección de Perfil en construcción");
                request.getRequestDispatcher(BASE_DUENIO + "indexDuenio.jsp").forward(request, response);
                break;

            case "logout":
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                break;

            default:
                response.sendRedirect(request.getContextPath() + BASE_DUENIO + "indexDuenio.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
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