package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.AgentesBean;
import com.sgca.integradorsgca.model.bean.ClientesBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.rolBean;
import com.sgca.integradorsgca.model.dao.AgentesDao;
import com.sgca.integradorsgca.model.dao.ClientesDao;
import com.sgca.integradorsgca.model.dao.UsuarioDao;
import com.sgca.integradorsgca.utils.EmailService;
import com.sgca.integradorsgca.utils.PasswordUtils;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * CRUD de usuarios (ADMIN.USUARIOS) usado por gestionEmpleados.jsp y
 * gestionClientes.jsp. Ambas pantallas son la misma tabla filtrada por
 * ID_ROL (2 = Agente/Empleado, 3 = Cliente), así que comparten este servlet.
 */
@WebServlet(name = "GestionUsuariosServlet", value = "/gestionUsuarios")
public class GestionUsuariosServlet extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();
    private final AgentesDao agentesDao = new AgentesDao();
    private final ClientesDao clientesDao = new ClientesDao();

    private static final int ID_ROL_AGENTE = 2;
    private static final int ID_ROL_CLIENTE = 3;
    private static final SecureRandom RANDOM = new SecureRandom();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");
        String error = null;
        String exito = null;

        try {
            if ("cambiarEstado".equals(accion)) {
                int idUsuario = Integer.parseInt(req.getParameter("id"));
                int estado = Integer.parseInt(req.getParameter("estado"));
                int idRol = Integer.parseInt(req.getParameter("idRol"));

                if (idRol == ID_ROL_AGENTE && estado == 0 && agentesDao.contarClientesAsignados(idUsuario) > 0) {
                    // No se puede dar de baja a un agente con clientes activos sin transferirlos antes.
                    error = "clientes_activos";
                } else {
                    usuarioDao.cambiarEstado(idUsuario, estado);
                }

            } else if ("eliminar".equals(accion)) {
                int idRol = Integer.parseInt(req.getParameter("idRol"));
                int idUsuario = Integer.parseInt(req.getParameter("id"));

                if (idRol == ID_ROL_AGENTE) {
                    error = eliminarAgente(req, idUsuario);
                } else {
                    // Borrado real (ADMIN.CLIENTES + ADMIN.USUARIOS), distinto
                    // del botón de estado. Si el cliente tiene compras o
                    // servicios contratados, la BD rechaza el borrado por llave
                    // foránea y avisamos en vez de dejarlo a medias.
                    boolean ok = clientesDao.eliminarPorIdUsuario(idUsuario);
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

    /**
     * Elimina definitivamente a un agente (idRol=2), a diferencia del botón
     * de estado y de darDeBaja(), que solo lo desactivan. Si tiene clientes
     * activos, exige un agente receptor y los transfiere antes de borrarlo;
     * si el agente tiene ventas o vehículos en su historial, la BD rechaza
     * el borrado por llave foránea y se avisa en vez de dejarlo a medias.
     */
    private String eliminarAgente(HttpServletRequest req, int idAgente) {
        int clientesActivos = agentesDao.contarClientesAsignados(idAgente);

        if (clientesActivos > 0) {
            String idReceptorParam = req.getParameter("idReceptor");
            if (idReceptorParam == null || idReceptorParam.trim().isEmpty()) {
                return "receptor_requerido";
            }

            int idReceptor = Integer.parseInt(idReceptorParam.trim());
            if (idReceptor == idAgente) {
                return "receptor_invalido";
            }

            if (!agentesDao.transferirClientes(idAgente, idReceptor)) {
                return "error_transferencia";
            }
        }

        boolean ok = agentesDao.eliminarPorIdUsuario(idAgente);
        return ok ? null : "no_se_pudo_eliminar";
    }

    private String registrar(HttpServletRequest req) throws Exception {
        UsuarioBean usuario = construirDesdeRequest(req);

        String duplicado = usuarioDao.validarDuplicados(usuario);
        if (duplicado != null) return "duplicado_" + duplicado.toLowerCase();

        boolean esAgente = usuario.getRol().getId_Rol() == ID_ROL_AGENTE;
        String passwordPlano;

        if (esAgente) {
            // Regla de negocio del DFR (módulo 3.1): la contraseña del agente la
            // genera el sistema, no la escribe el dueño en el formulario.
            passwordPlano = generarPasswordTemporal();
        } else {
            passwordPlano = req.getParameter("password");
            if (passwordPlano == null || passwordPlano.trim().length() < 8) {
                return "password_invalido";
            }
            passwordPlano = passwordPlano.trim();
        }
        usuario.setPassword(PasswordUtils.hashPassword(passwordPlano));

        boolean ok = usuarioDao.registrar(usuario);
        if (!ok) return "error_registro";

        // Si es empleado (idRol=2), también se crea su fila en ADMIN.AGENTES:
        // VENTAS y VEHICULOS referencian AGENTES, no USUARIOS directamente,
        // así que sin esta fila el empleado no puede operar como agente.
        if (esAgente) {

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

            try {
                enviarCorreoBienvenidaAgente(usuario, passwordPlano);
            } catch (MessagingException e) {
                e.printStackTrace();
                // La cuenta ya quedó creada y operativa; solo falló el aviso por
                // correo, así que se informa al dueño en vez de deshacer el alta.
                return "error_envio_correo";
            }
        } else if (usuario.getRol().getId_Rol() == ID_ROL_CLIENTE) {
            // Igual que con los agentes: VENTAS y la columna "Asesor" referencian
            // ADMIN.CLIENTES, no USUARIOS directamente. Sin esta fila el cliente
            // agregado desde este modal no puede recibir un asesor ni comprar.
            UsuarioBean creado = usuarioDao.obtenerPorCorreo(usuario.getCorreo());
            if (creado == null) return "error_vinculo_cliente";

            ClientesBean cliente = new ClientesBean();
            cliente.setIdUsuario(creado.getId_usuario());
            cliente.setIdAgente(null);

            try {
                boolean clienteOk = clientesDao.registrar(cliente);
                if (!clienteOk) return "error_vinculo_cliente";
            } catch (SQLException e) {
                e.printStackTrace();
                return "error_vinculo_cliente";
            }
        }

        return null;
    }

    // Contraseña temporal aleatoria que cumple las reglas de formato del DFR
    // (mínimo 8 caracteres, con mayúscula, minúscula, dígito y símbolo).
    private String generarPasswordTemporal() {
        String mayusculas = "ABCDEFGHJKLMNPQRSTUVWXYZ";
        String minusculas = "abcdefghijkmnpqrstuvwxyz";
        String digitos = "23456789";
        String especiales = "!@#$%";
        String todos = mayusculas + minusculas + digitos + especiales;

        List<Character> caracteres = new ArrayList<>();
        caracteres.add(mayusculas.charAt(RANDOM.nextInt(mayusculas.length())));
        caracteres.add(minusculas.charAt(RANDOM.nextInt(minusculas.length())));
        caracteres.add(digitos.charAt(RANDOM.nextInt(digitos.length())));
        caracteres.add(especiales.charAt(RANDOM.nextInt(especiales.length())));
        for (int i = 0; i < 6; i++) {
            caracteres.add(todos.charAt(RANDOM.nextInt(todos.length())));
        }
        Collections.shuffle(caracteres, RANDOM);

        StringBuilder resultado = new StringBuilder();
        caracteres.forEach(resultado::append);
        return resultado.toString();
    }

    // Envía al nuevo agente su correo y su contraseña temporal (módulo 3.1 del DFR).
    private void enviarCorreoBienvenidaAgente(UsuarioBean agente, String passwordTemporal) throws MessagingException {
        String asunto = "Tu cuenta de agente en SGCA";
        String mensajeHtml = "<div style='font-family: Arial, sans-serif; max-width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;'>"
                + "<h2 style='color: #333333; text-align: center;'>Bienvenido a SGCA</h2>"
                + "<p>Hola <strong>" + agente.getNombre() + "</strong>,</p>"
                + "<p>El dueño de la agencia creó tu cuenta como agente en el sistema. Estas son tus credenciales de acceso:</p>"
                + "<p><strong>Correo:</strong> " + agente.getCorreo() + "</p>"
                + "<div style='background-color: #f4f6f9; color: #007bff; text-align: center; padding: 15px; font-size: 22px; font-weight: bold; letter-spacing: 2px; border-radius: 6px; margin: 20px 0; border: 1px dashed #007bff;'>"
                + passwordTemporal
                + "</div>"
                + "<p>Te recomendamos cambiar esta contraseña temporal desde tu perfil en cuanto inicies sesión.</p>"
                + "</div>";
        EmailService.enviarCorreoGenerico(agente.getCorreo(), asunto, mensajeHtml);
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