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
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("Ingresa el código de 6 dígitos.");
            return;
        }

        TokRecDao tokRecDao = new TokRecDao();
        // Solo se acepta un token no usado y todavía vigente (no vencido)
        TokRecBean tokenBean = tokRecDao.validarTokenActivo(codigo.trim());

        if (tokenBean == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("El código es incorrecto, ya fue utilizado o ha expirado.");
            return;
        }

        // Guardamos en sesión el ID de usuario autenticado para el siguiente paso
        HttpSession session = request.getSession();
        session.setAttribute("idUsuarioRecuperacion", tokenBean.getIdUsuario());
        session.setAttribute("idTokenRecuperacion", tokenBean.getIdToken());

        response.getWriter().println("Código verificado correctamente.");
    }
}