package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
import com.sgca.integradorsgca.model.dao.VehiculosDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cliente")
public class clienteServlet extends HttpServlet {

    private final VehiculosDao dao = new VehiculosDao();
    private final ServiciosDao serviciosDao = new ServiciosDao();

@Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {


        List<VehiculosBean> lista = dao.listarDisponibles();

        request.setAttribute("vehiculos", lista);

        try {

            List<ServiciosBean> servicios = new ArrayList<>();

            for (ServiciosBean s : serviciosDao.listar()) {

                if (s.getEstado() == 1) {
                    servicios.add(s);
                }
            }

            request.setAttribute("servicios", servicios);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute("servicios", new ArrayList<ServiciosBean>());
        }


        request.getRequestDispatcher(
                "/pages/clientePages/index.jsp"
        ).forward(request,response);

    }
}