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
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);

        // Verificamos que exista la sesión de recuperación (viene de ValidarCodigoServlet)
        if (session == null || session.getAttribute("idUsuarioRecuperacion") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().println("Tu sesión de recuperación expiró. Vuelve a solicitar el código.");
            return;
        }

        int idUsuario = (Integer) session.getAttribute("idUsuarioRecuperacion");
        int idToken = (Integer) session.getAttribute("idTokenRecuperacion");

        String nuevaPassword = request.getParameter("nuevaPassword");
        String confirmarPassword = request.getParameter("confirmarPassword");

        if (nuevaPassword == null || nuevaPassword.length() < 8) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("La contraseña debe tener al menos 8 caracteres.");
            return;
        }

        if (!nuevaPassword.equals(confirmarPassword)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("Las contraseñas no coinciden.");
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

                response.getWriter().println("Contraseña actualizada correctamente.");

            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().println("No se pudo actualizar la contraseña. Intenta de nuevo.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Ocurrió un error en el servidor. Intenta más tarde.");
        }
    }
}