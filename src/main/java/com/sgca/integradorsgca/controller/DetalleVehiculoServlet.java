package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.ClientesBean;
import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.VehImgBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.dao.AgentesDao;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
import com.sgca.integradorsgca.model.dao.TiposVehiculoDao;
import com.sgca.integradorsgca.model.dao.VehImgDao;
import com.sgca.integradorsgca.model.dao.VehiculosDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

// Vista de detalle de un vehículo: una sola JSP reutilizable (detalleVehiculo.jsp)
// que muestra la información del ID_VEHICULO que llegue por parámetro.
@WebServlet("/detalleVehiculo")
public class DetalleVehiculoServlet extends HttpServlet {

    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final VehImgDao vehImgDao = new VehImgDao();
    private final TiposVehiculoDao tiposVehiculoDao = new TiposVehiculoDao();
    private final ServiciosDao serviciosDao = new ServiciosDao();
    private final AgentesDao agentesDao = new AgentesDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cliente");
            return;
        }

        VehiculosBean vehiculo = vehiculosDao.buscarPorID(id);

        if (vehiculo == null) {
            response.sendRedirect(request.getContextPath() + "/cliente");
            return;
        }

        List<VehImgBean> galeria = vehImgDao.listarPorVehiculo(id);

        // Mismo tipo de vehículo, sin contar el que ya se está mostrando
        List<VehiculosBean> relacionados = new ArrayList<>();
        for (VehiculosBean v : vehiculosDao.listarClientePorTipo(vehiculo.getTipoVehiculo().getNombre(), null, null)) {
            if (v.getId_Vehiculo() != id) {
                relacionados.add(v);
            }
        }

        request.setAttribute("vehiculo", vehiculo);
        request.setAttribute("galeria", galeria);
        request.setAttribute("relacionados", relacionados);
        request.setAttribute("listaTipos", tiposVehiculoDao.listar());

        HttpSession session = request.getSession(false);
        UsuarioBean usuario = session != null ? (UsuarioBean) session.getAttribute("usuarioLogueado") : null;

        if (usuario != null && "AGENTE".equalsIgnoreCase(usuario.getRol().getRol())) {
            List<ClientesBean> clientesAsesor = agentesDao.listarClientesAsignados(usuario.getId_usuario());
            request.setAttribute("clientesAsesor", clientesAsesor);
        }

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
                "/pages/clientePages/detalleVehiculo.jsp"
        ).forward(request, response);
    }
}
