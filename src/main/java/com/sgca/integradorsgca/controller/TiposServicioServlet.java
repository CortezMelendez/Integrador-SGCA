package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.TiposServicioBean;
import com.sgca.integradorsgca.model.dao.TiposServicioDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "TiposServicioServlet", value = "/tipos-servicio")
public class TiposServicioServlet extends HttpServlet {

    private final TiposServicioDao dao = new TiposServicioDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("listaTipos", dao.listar());
            req.getRequestDispatcher("tipos-servicio.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/panel?error=error_carga");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String nombre = req.getParameter("nombre");

        try {
            TiposServicioBean tipo = new TiposServicioBean(0, nombre);
            dao.insertar(tipo);
            resp.sendRedirect(req.getContextPath() + "/tipos-servicio?exito=guardado");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/tipos-servicio?error=error_guardar");
        }
    }
}