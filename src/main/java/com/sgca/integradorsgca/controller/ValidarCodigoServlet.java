package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.TokRecBean;
import com.sgca.integradorsgca.model.dao.TokRecDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ValidarCodigoServlet", value = "/ValidarCodigoServlet")
public class ValidarCodigoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String codigo = request.getParameter("codigo");

        if (codigo == null || codigo.trim().isEmpty()) {
            response.getWriter().println("Error: Ingresa el código de 6 dígitos.");
            return;
        }

        TokRecDao tokRecDao = new TokRecDao();
        //Usamos el metodo de obtener token para verioficar si el codigo de 6 digitos existe
        TokRecBean tokenBean = tokRecDao.obtenerToken(codigo.trim());

        if (tokenBean == null || tokenBean.getUsado() == 1) {
            response.getWriter().println("El código es incorrecto o ya fue utilizado.");
            return;
        }

        // Guardamos en sesión el ID de usuario autenticado para el siguiente paso
        HttpSession session = request.getSession();
        session.setAttribute("idUsuarioRecuperacion", tokenBean.getIdUsuario());
        session.setAttribute("idTokenRecuperacion", tokenBean.getIdToken());

        // Redirigimos al siguiente modal para que el usuario ingrese su nueva credencial
        response.sendRedirect("cambiar-password.jsp");
    }
}