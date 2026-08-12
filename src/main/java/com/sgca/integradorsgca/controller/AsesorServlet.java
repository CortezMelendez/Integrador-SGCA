package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
import com.sgca.integradorsgca.model.dao.TiposVehiculoDao;
import com.sgca.integradorsgca.model.dao.VehiculosDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

// Panel principal del agente/asesor. Reutiliza el mismo catálogo de vehículos
// y el mismo modal de servicios que ya usa el cliente (misma arquitectura).
@WebServlet("/asesor")
public class AsesorServlet extends HttpServlet {

    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final TiposVehiculoDao tiposVehiculoDao = new TiposVehiculoDao();
    private final ServiciosDao serviciosDao = new ServiciosDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<VehiculosBean> vehiculos = vehiculosDao.listarDisponibles();

        request.setAttribute("vehiculos", vehiculos);
        request.setAttribute("listaTipos", tiposVehiculoDao.listar());

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
                "/pages/asesorPages/index.jsp"
        ).forward(request, response);
    }
}
