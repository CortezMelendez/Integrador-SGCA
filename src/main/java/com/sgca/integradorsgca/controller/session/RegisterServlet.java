package com.sgca.integradorsgca.controller.session;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.rolBean;
import com.sgca.integradorsgca.model.dao.UsuarioDao;
import com.sgca.integradorsgca.utils.PasswordUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();

    // Cambia este ID por el que tenga el rol CLIENTE en tu BD
    private static final int ID_ROL_CLIENTE = 3;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        System.out.println("=======================================");
        System.out.println("REGISTER SERVLET EJECUTÁNDOSE...");
        System.out.println("=======================================");

        try {

            String nombre = request.getParameter("nombre");
            String apellidoPaterno = request.getParameter("apellidoPaterno");
            String apellidoMaterno = request.getParameter("apellidoMaterno");
            String rfc = request.getParameter("rfc");
            String curp = request.getParameter("curp");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            String passwordPlano = request.getParameter("password");

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

            UsuarioBean usuario = new UsuarioBean(
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

            // ==========================
            // REGISTRAR EN LA BD
            // ==========================

            boolean registrado = usuarioDao.registrar(usuario);

            if (registrado) {

                System.out.println("=======================================");
                System.out.println("USUARIO REGISTRADO CORRECTAMENTE");
                System.out.println("=======================================");

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
}