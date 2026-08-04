package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.TiposServicioBean;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
import com.sgca.integradorsgca.model.dao.TiposServicioDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ServiciosServlet", value = "/servicios")
public class ServiciosServlet extends HttpServlet {

    private final ServiciosDao serviciosDao = new ServiciosDao();
    private final TiposServicioDao tiposServicioDao = new TiposServicioDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Cargar la lista de servicios y la lista de tipos para desplegar en select box
            req.setAttribute("listaServicios", serviciosDao.listar());
            req.setAttribute("listaTipos", tiposServicioDao.listar());

            req.getRequestDispatcher("servicios.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/panel?error=error_carga");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            int idTipoServicio = Integer.parseInt(req.getParameter("id_tipo_servicio"));
            String nombre = req.getParameter("nombre");
            String descripcion = req.getParameter("descripcion");
            double precio = Double.parseDouble(req.getParameter("precio"));

            TiposServicioBean tipo = new TiposServicioBean();
            tipo.setId_tipo_servicio(idTipoServicio);

            ServiciosBean servicio = new ServiciosBean(0, tipo, nombre, descripcion, precio, 1);

            serviciosDao.registrar(servicio);
            resp.sendRedirect(req.getContextPath() + "/servicios?exito=registrado");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/servicios?error=error_registro");
        }
    }
}