package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.VehImgBean;
import com.sgca.integradorsgca.model.dao.VehImgDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "VehiculoImagenesServlet", value = "/vehiculo-imagenes")
public class VehImgServlet extends HttpServlet {

    private final VehImgDao imagenesDao = new VehImgDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");
        int idVehiculo = Integer.parseInt(req.getParameter("idVehiculo"));

        if ("eliminar".equals(accion)) {
            int idImagen = Integer.parseInt(req.getParameter("idImagen"));
            imagenesDao.eliminar(idImagen);
            resp.sendRedirect(req.getContextPath() + "/vehiculo-imagenes?idVehiculo=" + idVehiculo);
            return;
        }

        // Obtener la galería completa para renderizarla en la vista de detalle
        List<VehImgBean> galeria = imagenesDao.listarPorVehiculo(idVehiculo);
        req.setAttribute("galeria", galeria);
        req.setAttribute("idVehiculo", idVehiculo);

        req.getRequestDispatcher("vehiculo-galeria.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        int idVehiculo = Integer.parseInt(req.getParameter("idVehiculo"));
        String rutaImagen = req.getParameter("rutaImagen");

        if (rutaImagen != null && !rutaImagen.trim().isEmpty()) {
            VehImgBean nuevaImagen = new VehImgBean(idVehiculo, rutaImagen);
            imagenesDao.registrar(nuevaImagen);
        }

        resp.sendRedirect(req.getContextPath() + "/vehiculo-imagenes?idVehiculo=" + idVehiculo);
    }
}