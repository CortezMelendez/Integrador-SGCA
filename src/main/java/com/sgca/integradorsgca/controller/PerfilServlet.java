package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.dao.UsuarioDao;
import com.sgca.integradorsgca.utils.PasswordUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// El perfil se muestra y edita como modal dentro de cada vista del cliente
// (no existe una página propia); este servlet solo atiende el guardado (POST).
@WebServlet("/perfil")
public class PerfilServlet extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/cliente");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);
        UsuarioBean usuarioSesion = session != null
                ? (UsuarioBean) session.getAttribute("usuarioLogueado")
                : null;

        if (usuarioSesion == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().println("Tu sesión expiró. Vuelve a iniciar sesión.");
            return;
        }

        String nombre = request.getParameter("nombre");
        String apellidoPaterno = request.getParameter("apellidoPaterno");
        String apellidoMaterno = request.getParameter("apellidoMaterno");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String passwordActual = request.getParameter("passwordActual");
        String nuevaPassword = request.getParameter("nuevaPassword");
        String confirmarPassword = request.getParameter("confirmarPassword");

        if (nombre == null || nombre.trim().isEmpty()
                || apellidoPaterno == null || apellidoPaterno.trim().isEmpty()
                || correo == null || correo.trim().isEmpty()
                || telefono == null || telefono.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("Completa los campos obligatorios.");
            return;
        }

        boolean quiereCambiarPassword = nuevaPassword != null && !nuevaPassword.isEmpty();

        if (quiereCambiarPassword) {

            if (passwordActual == null || passwordActual.isEmpty()
                    || !PasswordUtils.checkPassword(passwordActual, usuarioSesion.getPassword())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().println("La contraseña actual no es correcta.");
                return;
            }

            if (nuevaPassword.length() < 8) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().println("La nueva contraseña debe tener al menos 8 caracteres.");
                return;
            }

            if (!nuevaPassword.equals(confirmarPassword)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().println("Las contraseñas no coinciden.");
                return;
            }
        }

        try {
            int idUsuario = usuarioSesion.getId_usuario();

            // El usuario solo edita su propio perfil: el id sale de la sesión, nunca del cliente.
            UsuarioBean datosActualizados = new UsuarioBean();
            datosActualizados.setId_usuario(idUsuario);
            datosActualizados.setRol(usuarioSesion.getRol());
            datosActualizados.setNombre(nombre.trim());
            datosActualizados.setApellidoPaterno(apellidoPaterno.trim());
            datosActualizados.setApellidoMaterno(apellidoMaterno == null ? "" : apellidoMaterno.trim());
            // RFC y CURP no son editables: se conservan tal cual estaban registrados.
            datosActualizados.setRfc(usuarioSesion.getRfc());
            datosActualizados.setCurp(usuarioSesion.getCurp());
            datosActualizados.setCorreo(correo.trim());
            datosActualizados.setTelefono(telefono.trim());
            datosActualizados.setEstado(usuarioSesion.getEstado());

            String duplicado = usuarioDao.validarDuplicadosExcluyendo(datosActualizados, idUsuario);
            if (duplicado != null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().println(mensajeDuplicado(duplicado));
                return;
            }

            boolean actualizado = usuarioDao.actualizar(datosActualizados);

            if (!actualizado) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().println("No se pudo actualizar el perfil. Intenta de nuevo.");
                return;
            }

            if (quiereCambiarPassword) {
                String hasheada = PasswordUtils.hashPassword(nuevaPassword);
                usuarioDao.actualizarPassword(idUsuario, hasheada);
                datosActualizados.setPassword(hasheada);
            } else {
                datosActualizados.setPassword(usuarioSesion.getPassword());
            }

            datosActualizados.setFechaRegistro(usuarioSesion.getFechaRegistro());

            // Refrescamos la sesión para que el resto de la app vea los datos nuevos de inmediato.
            session.setAttribute("usuarioLogueado", datosActualizados);

            response.getWriter().println("Perfil actualizado exitosamente");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Ocurrió un error en el servidor. Intenta más tarde.");
        }
    }

    private String mensajeDuplicado(String campo) {
        switch (campo) {
            case "CORREO": return "Ese correo ya está en uso por otra cuenta.";
            case "TELEFONO": return "Ese número de contacto ya está en uso por otra cuenta.";
            default: return "Alguno de los datos ya está en uso por otra cuenta.";
        }
    }
}
