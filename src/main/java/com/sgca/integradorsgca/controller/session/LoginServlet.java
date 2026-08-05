package com.sgca.integradorsgca.controller.session;

import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.dao.UsuarioDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import oracle.jdbc.internal.XSCacheOutput;

import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Si el usuario ya tiene sesión activa y navega a /login, redirigir a su panel o pagina principal
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("usuarioLogueado") != null) {
            UsuarioBean usuario = (UsuarioBean) session.getAttribute("usuarioLogueado");
            redirigirSegunRol(req, resp, usuario);
            return;
        }

        // Si no tiene sesión, mostrar el formulario de login.jsp
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        System.out.println("==================================" +
                "ejecutando servlet" +
                "===================================");

        String correo = req.getParameter("correo");
        String password = req.getParameter("password");

        try {
            // Validar credenciales con jBCrypt mediante el UsuarioDao
            UsuarioBean usuario = usuarioDao.validarLogin(correo, password);

            if (usuario != null) {
                //Crear nueva sesión limpia
                HttpSession session = req.getSession(true);

                //Guardar el Bean con la clave exacta "usuarioLogueado" para el AuthFilter
                session.setAttribute("usuarioLogueado", usuario);

                //Redirigir según el rol del usuario
                redirigirSegunRol(req, resp, usuario);
            } else {
                // Credenciales incorrectas o usuario inactivo (estado = 0)
                resp.sendRedirect(req.getContextPath() + "/login.jsp?error=credenciales_invalidas");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=server_error");
        }
        System.out.println("=====================================" +
                "probando servlet" +
                "============================================");
    }

    private void redirigirSegunRol(HttpServletRequest req, HttpServletResponse resp, UsuarioBean usuario) throws IOException {
        String rol = "INVITADO";

        if (usuario.getRol() != null && usuario.getRol().getRol() != null) {
            rol = usuario.getRol().getRol().toUpperCase().trim();
        }

        switch (rol) {
            case "ADMIN":
                resp.sendRedirect(req.getContextPath() + "/panel");
                break;
            case "AGENTE":
                resp.sendRedirect(req.getContextPath() + "/clientes");
                break;
            case "CLIENTE":
                resp.sendRedirect(req.getContextPath() + "/mis-servicios");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                break;
        }
    }
}