package com.sgca.integradorsgca.controller.session;
import com.sgca.integradorsgca.model.bean.ClientesBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.rolBean;
import com.sgca.integradorsgca.model.dao.ClientesDao;
import com.sgca.integradorsgca.model.dao.UsuarioDao;
import com.sgca.integradorsgca.utils.PasswordUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Pattern;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();
    private final ClientesDao clientesDao = new ClientesDao();

    // Cambia este ID por el que tenga el rol CLIENTE en tu BD
    private static final int ID_ROL_CLIENTE = 3;

    // Reglas de negocio del DFR (módulo 1.2, registro de cuenta).
    private static final Pattern PATRON_NOMBRE = Pattern.compile("^[\\p{L}\\s]+$");
    private static final Pattern PATRON_CORREO = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    // 10 dígitos, sin espacios/guiones/especiales ni cero inicial.
    private static final Pattern PATRON_TELEFONO = Pattern.compile("^[1-9]\\d{9}$");
    // 4 letras + 6 dígitos (fecha de nacimiento) + 3 alfanuméricos de homoclave, solo mayúsculas.
    private static final Pattern PATRON_RFC = Pattern.compile("^[A-Z]{4}\\d{6}[A-Z0-9]{3}$");
    // 18 caracteres alfanuméricos, solo mayúsculas.
    private static final Pattern PATRON_CURP = Pattern.compile("^[A-Z0-9]{18}$");
    // Mínimo 8 caracteres, con mayúscula, minúscula y carácter especial.
    private static final Pattern PATRON_PASSWORD =
            Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9]).{8,}$");

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        System.out.println("=======================================");
        System.out.println("REGISTER SERVLET EJECUTÁNDOSE...");
        System.out.println("=======================================");

        UsuarioBean usuario = null;
        try {

            String nombre = request.getParameter("nombre");
            String apellidoPaterno = request.getParameter("apellidoPaterno");
            String apellidoMaterno = request.getParameter("apellidoMaterno");
            String rfc = request.getParameter("rfc");
            String curp = request.getParameter("curp");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            String passwordPlano = request.getParameter("password");
            String confirmarPassword = request.getParameter("confirmarPassword");

            // Mostrar lo que llegó del formulario
            System.out.println("Datos recibidos:");
            System.out.println("Nombre: " + nombre);
            System.out.println("Apellido Paterno: " + apellidoPaterno);
            System.out.println("Apellido Materno: " + apellidoMaterno);
            System.out.println("RFC: " + rfc);
            System.out.println("CURP: " + curp);
            System.out.println("Correo: " + correo);
            System.out.println("Telefono: " + telefono);
            System.out.println("Password recibida: SI");

            // RFC y CURP se normalizan a mayúsculas antes de validar y guardar
            // (regla de negocio del DFR: "solo en mayúsculas").
            rfc = rfc == null ? "" : rfc.trim().toUpperCase();
            curp = curp == null ? "" : curp.trim().toUpperCase();

            String errorFormato = validarFormato(
                    nombre, apellidoPaterno, apellidoMaterno, correo, telefono,
                    rfc, curp, passwordPlano, confirmarPassword);

            if (errorFormato != null) {
                request.setAttribute("error", errorFormato);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // Encriptar contraseña
            String password = PasswordUtils.hashPassword(passwordPlano);

            System.out.println("Contraseña encriptada correctamente.");

            // ==========================
            // DATOS AUTOMÁTICOS
            // ==========================

            rolBean rol = new rolBean();
            rol.setId_Rol(ID_ROL_CLIENTE);

            int estado = 1;

            System.out.println("Rol asignado: " + ID_ROL_CLIENTE);
            System.out.println("Estado asignado: " + estado);

            // ==========================
            // CREAR OBJETO
            // ==========================

            usuario = new UsuarioBean(
                    rol,
                    nombre,
                    apellidoPaterno,
                    apellidoMaterno,
                    rfc,
                    curp,
                    correo,
                    telefono,
                    password,
                    estado
            );

            System.out.println("UsuarioBean creado correctamente.");

            // Validar si ya existe un usuario con esos datos
            String duplicado = usuarioDao.validarDuplicados(usuario);

            if (duplicado != null) {

                String mensaje = switch (duplicado) {
                    case "CORREO" -> "El correo ya está registrado. Por favor inicia sesión.";
                    case "RFC" -> "El RFC ya está registrado. Por favor inicia sesión.";
                    case "CURP" -> "La CURP ya está registrada. Por favor inicia sesión.";
                    case "TELEFONO" -> "El teléfono ya está registrado. Por favor inicia sesión.";
                    default -> "Ya existe un usuario registrado.";
                };

                request.setAttribute("error", mensaje);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }


            // ==========================
            // REGISTRAR EN LA BD
            // ==========================

            boolean registrado = usuarioDao.registrar(usuario);

            if (registrado) {

                System.out.println("=======================================");
                System.out.println("USUARIO REGISTRADO CORRECTAMENTE");
                System.out.println("=======================================");

                // El usuario ya quedó en ADMIN.USUARIOS; falta vincularlo en
                // ADMIN.CLIENTES (sin agente asignado) para que pueda comprar,
                // ver "Mis compras", etc. Se busca por correo para obtener el
                // ID_USUARIO recién generado, ya que usuarioDao.registrar() no lo regresa.
                UsuarioBean creado = usuarioDao.obtenerPorCorreo(correo);

                if (creado == null) {
                    request.setAttribute(
                            "error",
                            "Tu cuenta se creó, pero no se pudo recuperar para vincularla como cliente. Contacta soporte.");
                    request.getRequestDispatcher("/register.jsp")
                            .forward(request, response);
                    return;
                }

                ClientesBean cliente = new ClientesBean();
                cliente.setIdUsuario(creado.getId_usuario());
                cliente.setIdAgente(null);

                try {
                    boolean clienteRegistrado = clientesDao.registrar(cliente);

                    if (!clienteRegistrado) {
                        request.setAttribute(
                                "error",
                                "Tu cuenta se creó, pero no se pudo vincular como cliente. Contacta soporte.");
                        request.getRequestDispatcher("/register.jsp")
                                .forward(request, response);
                        return;
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute(
                            "error",
                            "Tu cuenta se creó, pero no se pudo vincular como cliente. Contacta soporte.");
                    request.getRequestDispatcher("/register.jsp")
                            .forward(request, response);
                    return;
                }

                response.sendRedirect(request.getContextPath() + "/login.jsp");


            } else {

                System.out.println("ERROR: usuarioDao.registrar() devolvió FALSE");

                request.setAttribute(
                        "error",
                        "No fue posible registrar el usuario.");

                request.getRequestDispatcher("/register.jsp")
                        .forward(request, response);
            }

        } catch (Exception e) {

            System.out.println("=======================================");
            System.out.println("ERROR EN RegisterServlet");
            System.out.println("=======================================");

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Ocurrió un error durante el registro.");

            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);
        }



    }

    // Reglas de negocio del DFR, módulo 1.2 (registro de cuenta). Devuelve el
    // mensaje de error a mostrar, o null si todo el formato es válido.
    private String validarFormato(String nombre, String apellidoPaterno, String apellidoMaterno,
                                   String correo, String telefono, String rfc, String curp,
                                   String passwordPlano, String confirmarPassword) {

        if (nombre == null || !PATRON_NOMBRE.matcher(nombre.trim()).matches()
                || apellidoPaterno == null || !PATRON_NOMBRE.matcher(apellidoPaterno.trim()).matches()
                || (apellidoMaterno != null && !apellidoMaterno.isBlank()
                        && !PATRON_NOMBRE.matcher(apellidoMaterno.trim()).matches())) {
            return "El nombre completo solo puede contener letras y espacios.";
        }

        int longitudNombreCompleto = nombre.trim().length() + apellidoPaterno.trim().length()
                + (apellidoMaterno == null ? 0 : apellidoMaterno.trim().length());
        if (longitudNombreCompleto > 100) {
            return "El nombre completo no debe exceder los 100 caracteres.";
        }

        if (correo == null || !PATRON_CORREO.matcher(correo.trim()).matches()) {
            return "Ingresa un correo electrónico válido.";
        }

        if (telefono == null || !PATRON_TELEFONO.matcher(telefono.trim()).matches()) {
            return "El número de teléfono debe contener exactamente 10 dígitos numéricos.";
        }

        if (!PATRON_RFC.matcher(rfc).matches()) {
            return "El RFC ingresado no está validado";
        }

        if (!PATRON_CURP.matcher(curp).matches()) {
            return "El CURP ingresado no tiene un formato válido";
        }

        if (passwordPlano == null || !PATRON_PASSWORD.matcher(passwordPlano).matches()) {
            return "La contraseña debe tener mínimo 8 caracteres, incluyendo mayúsculas, minúsculas y un carácter especial.";
        }

        if (!passwordPlano.equals(confirmarPassword)) {
            return "las contraseñas no coinciden";
        }

        return null;
    }

}