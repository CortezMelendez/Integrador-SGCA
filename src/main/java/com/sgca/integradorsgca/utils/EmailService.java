package com.sgca.integradorsgca.utils;

import com.sgca.integradorsgca.model.bean.TokRecBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.dao.TokRecDao;
import com.sgca.integradorsgca.model.dao.UsuarioDao;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Properties;

@WebServlet(name = "TokRec", value="/RecuperarPasswordServlet")
public class EmailService extends HttpServlet {

    public EmailService() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // Obtenemos el correo destino a donde se enviara el token
        String destino = request.getParameter("destino");

        if (destino == null || destino.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("Debes ingresar un correo electrónico válido.");
            return;
        }

        UsuarioDao usuarioDao = new UsuarioDao();
        UsuarioBean usuario = null;

        // Validar existencia del correo en la BD
        try {
            usuario = usuarioDao.obtenerPorCorreo(destino);
            if (usuario == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().println("El correo no está registrado o la cuenta está inactiva.");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Error al consultar la base de datos.");
            return;
        }

        // Generar Código PIN de 6 dígitos
        String codigoSeguridad = generarCodigo6Digitos();
        int idUsuario = usuario.getId_usuario();

        // La expiración ya no se calcula aquí: TokRecDao la fija con SYSDATE + 5 minutos
        // directamente en Oracle, para no depender de la hora local de este servidor.
        TokRecBean tokenBean = new TokRecBean();
        tokenBean.setIdUsuario(idUsuario);
        tokenBean.setToken(codigoSeguridad);
        tokenBean.setUsado(0); // 0 = No usado

        TokRecDao tokenDao = new TokRecDao();

        try {
            boolean guardadoCorrecto = tokenDao.guardarToken(tokenBean);

            if (!guardadoCorrecto) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().println("Error al generar el código de seguridad en la base de datos.");
                return;
            }
        } catch (java.sql.SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Error al generar el código de seguridad: " + e.getMessage());
            return;
        }

        // Armar la plantilla del correo con el PIN numérico
        String asunto = "Código de Seguridad: " + codigoSeguridad ;

        String mensajeHtml = "<div style='font-family: Arial, sans-serif; max-width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;'>"
                + "<h2 style='color: #333333; text-align: center;'>Recuperación de Contraseña</h2>"
                + "<p>Hola <strong>" + usuario.getNombre() + "</strong>,</p>"
                + "<p>Hemos recibido una solicitud para restablecer la contraseña de tu cuenta en el sistema.</p>"
                + "<p>Tu código de seguridad de 6 dígitos es:</p>"
                + "<div style='background-color: #f4f6f9; color: #007bff; text-align: center; padding: 15px; font-size: 32px; font-weight: bold; letter-spacing: 6px; border-radius: 6px; margin: 20px 0; border: 1px dashed #007bff;'>"
                + codigoSeguridad
                + "</div>"
                + "<p>Ingresa este código en la pantalla de verificación para continuar con el cambio de contraseña.</p>"
                + "<p style='color: #888888; font-size: 12px; margin-top: 25px;'>Este código estará disponible durante 5 minutos. Si no solicitaste este cambio, puedes ignorar este mensaje.</p>"
                + "</div>";

        try {
            //Envío del correo electrónico
            enviarCorreo(destino, asunto, mensajeHtml);

            // Redireccionar o notificar al usuario
            response.getWriter().println("Se ha enviado el código de seguridad a tu correo electrónico.");

        } catch (MessagingException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Error al enviar el correo automático: " + e.getMessage());
            e.printStackTrace();
        }
    }

    //Genera un número aleatorio de 6 dígitos (100000 - 999999)

    private String generarCodigo6Digitos() {
        int numero = (int) (Math.random() * 900000) + 100000;
        return String.valueOf(numero);
    }

    private void enviarCorreo(String destino, String asunto, String cuerpoHtml) throws MessagingException {
        enviarCorreoConCredenciales(destino, asunto, cuerpoHtml,
                obtenerConfiguracion("GMAIL_USER"), obtenerConfiguracion("GMAIL_PASS"),
                obtenerConfiguracion("SMTP_HOST", "smtp.gmail.com"), obtenerConfiguracion("SMTP_PORT", "587"));
    }

    /**
     * Envía un correo HTML reutilizando la configuración SMTP de variables de
     * entorno (GMAIL_USER, GMAIL_PASS, SMTP_HOST, SMTP_PORT). Pensado para
     * usarse fuera de este servlet, por ejemplo al dar de alta un agente y
     * enviarle su contraseña temporal (módulo 3 del DFR).
     */
    public static void enviarCorreoGenerico(String destino, String asunto, String cuerpoHtml) throws MessagingException {
        String host = System.getenv("SMTP_HOST");
        if (host == null || host.trim().isEmpty()) host = "smtp.gmail.com";
        String port = System.getenv("SMTP_PORT");
        if (port == null || port.trim().isEmpty()) port = "587";

        enviarCorreoConCredenciales(destino, asunto, cuerpoHtml,
                System.getenv("GMAIL_USER"), System.getenv("GMAIL_PASS"), host, port);
    }

    private static void enviarCorreoConCredenciales(String destino, String asunto, String cuerpoHtml,
            String usuario, String clave, String host, String port) throws MessagingException {

        if (usuario == null || clave == null) {
            throw new MessagingException("No se encontraron las variables 'GMAIL_USER' o 'GMAIL_PASS' en el sistema.");
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);

        final String usuarioFinal = usuario;
        final String claveFinal = clave;

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(usuarioFinal, claveFinal);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(usuarioFinal));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destino));
        message.setSubject(asunto);
        message.setContent(cuerpoHtml, "text/html; charset=utf-8");

        Transport.send(message);
    }

    private String obtenerConfiguracion(String clave) {
        return obtenerConfiguracion(clave, null);
    }

    private String obtenerConfiguracion(String clave, String valorPorDefecto) {
        String valor = System.getenv(clave);

        if (valor == null || valor.trim().isEmpty()) {
            valor = getServletContext().getInitParameter(clave);
        }

        if (valor == null || valor.trim().isEmpty()) {
            valor = valorPorDefecto;
        }

        return valor;
    }
}