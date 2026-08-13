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
import java.sql.SQLException;

// Modal "Registrar" del navbar del asesor: crea un cliente nuevo y lo asigna
// automáticamente al asesor que lo está registrando (mismo patrón que
// RegisterServlet/ClientesDao, solo que aquí el ID_AGENTE no queda NULL).
@WebServlet("/registrarClienteAsesor")
public class AsesorRegistrarClienteServlet extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();
    private final ClientesDao clientesDao = new ClientesDao();
    private final AgentesDao agentesDao = new AgentesDao();

    private static final int ID_ROL_CLIENTE = 3;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);
        UsuarioBean asesor = session != null
                ? (UsuarioBean) session.getAttribute("usuarioLogueado")
                : null;

        if (asesor == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().println("Tu sesión expiró. Vuelve a iniciar sesión.");
            return;
        }

        String nombre = request.getParameter("nombre");
        String apellidoPaterno = request.getParameter("apellidoPaterno");
        String apellidoMaterno = request.getParameter("apellidoMaterno");
        String rfc = request.getParameter("rfc");
        String curp = request.getParameter("curp");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String passwordPlano = request.getParameter("password");

        if (nombre == null || nombre.trim().isEmpty()
                || apellidoPaterno == null || apellidoPaterno.trim().isEmpty()
                || rfc == null || rfc.trim().isEmpty()
                || curp == null || curp.trim().isEmpty()
                || correo == null || correo.trim().isEmpty()
                || telefono == null || telefono.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("Completa todos los campos obligatorios.");
            return;
        }

        if (passwordPlano == null || passwordPlano.trim().length() < 8) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("La contraseña temporal debe tener al menos 8 caracteres.");
            return;
        }

        rolBean rol = new rolBean();
        rol.setId_Rol(ID_ROL_CLIENTE);

        UsuarioBean nuevoUsuario = new UsuarioBean(
                rol,
                nombre.trim(),
                apellidoPaterno.trim(),
                apellidoMaterno == null ? "" : apellidoMaterno.trim(),
                rfc.trim().toUpperCase(),
                curp.trim().toUpperCase(),
                correo.trim(),
                telefono.trim(),
                PasswordUtils.hashPassword(passwordPlano.trim()),
                1
        );

        try {
            String duplicado = usuarioDao.validarDuplicados(nuevoUsuario);
            if (duplicado != null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().println(mensajeDuplicado(duplicado));
                return;
            }

            boolean creado = usuarioDao.registrar(nuevoUsuario);
            if (!creado) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().println("No se pudo registrar al cliente. Intenta de nuevo.");
                return;
            }

            UsuarioBean clienteCreado = usuarioDao.obtenerPorCorreo(correo.trim());
            if (clienteCreado == null) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().println("El cliente se creó, pero no se pudo vincular. Contacta soporte.");
                return;
            }

            Integer idAgente = agentesDao.obtenerIdAgentePorUsuario(asesor.getId_usuario());

            ClientesBean cliente = new ClientesBean();
            cliente.setIdUsuario(clienteCreado.getId_usuario());
            cliente.setIdAgente(idAgente);

            boolean vinculado = clientesDao.registrar(cliente);
            if (!vinculado) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().println("El cliente se creó, pero no se pudo vincular como cliente. Contacta soporte.");
                return;
            }

            response.getWriter().println("Cliente registrado y asignado correctamente.");

        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Ocurrió un error en el servidor. Intenta más tarde.");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Ocurrió un error en el servidor. Intenta más tarde.");
        }
    }

    private String mensajeDuplicado(String campo) {
        switch (campo) {
            case "CORREO": return "Ese correo ya está registrado.";
            case "RFC": return "Ese RFC ya está registrado.";
            case "CURP": return "Esa CURP ya está registrada.";
            case "TELEFONO": return "Ese teléfono ya está registrado.";
            default: return "Alguno de los datos ya está registrado.";
        }
    }
}
