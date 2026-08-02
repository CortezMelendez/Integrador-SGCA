package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.dao.TokRecDao;
import com.sgca.integradorsgca.model.dao.UsuarioDao;
import com.sgca.integradorsgca.utils.PasswordUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "CambiarPasswordServlet", value = "/CambiarPasswordServlet")
public class NewPassServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // Verificamos que exista la sesión de recuperación
        if (session == null || session.getAttribute("idUsuarioRecuperacion") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=sesion_expirada");
            return;
        }

        int idUsuario = (Integer) session.getAttribute("idUsuarioRecuperacion");
        int idToken = (Integer) session.getAttribute("idTokenRecuperacion");

        String nuevaPassword = request.getParameter("nuevaPassword");
        String confirmarPassword = request.getParameter("confirmarPassword");

        if (nuevaPassword == null || nuevaPassword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cambiar-password.jsp?error=vacio");
            return;
        }

        if (!nuevaPassword.equals(confirmarPassword)) {
            response.sendRedirect(request.getContextPath() + "/cambiar-password.jsp?error=mismatch");
            return;
        }

        try {
            UsuarioDao usuarioDao = new UsuarioDao();

            // Encriptamos la nueva contraseña antes de actualizar
            String passwordEncriptada = PasswordUtils.hashPassword(nuevaPassword);

            //Enviamos la contraseña cifrada a la base de datos
            boolean pasoActualizacion = usuarioDao.actualizarPassword(idUsuario, passwordEncriptada);

            if (pasoActualizacion) {
                //Marcamos el token como Usado
                TokRecDao tokRecDao = new TokRecDao();
                tokRecDao.marcarComoUsado(idToken);

                //DESTRUCCIÓN COMPLETA DE LA SESIÓN POR SEGURIDAD
                session.invalidate();

                //Redirección al login para que vuelva a iniciar sesión
                response.sendRedirect(request.getContextPath() + "/login.jsp?exito=password_actualizada");

            } else {
                response.sendRedirect(request.getContextPath() + "/cambiar-password.jsp?error=db_error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cambiar-password.jsp?error=server_error");
        }
    }
}