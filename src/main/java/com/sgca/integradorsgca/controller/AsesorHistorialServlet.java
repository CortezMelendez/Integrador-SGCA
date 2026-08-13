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

// Historial de ventas del asesor. Por ahora solo alimenta el mismo navbar
// funcional que el panel principal (Vehículos/Servicios/Registrar Cliente/
// Cotización/Perfil); la tabla de ventas del propio asesor queda pendiente.
@WebServlet("/historialAsesor")
public class AsesorHistorialServlet extends HttpServlet {

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
                "/pages/asesorPages/historial.jsp"
        ).forward(request, response);
    }
}
