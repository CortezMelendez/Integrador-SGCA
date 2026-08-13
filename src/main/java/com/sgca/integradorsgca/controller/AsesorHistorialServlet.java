package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.ClientesBean;
import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.bean.VentasBean;
import com.sgca.integradorsgca.model.dao.AgentesDao;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
import com.sgca.integradorsgca.model.dao.TiposVehiculoDao;
import com.sgca.integradorsgca.model.dao.VehiculosDao;
import com.sgca.integradorsgca.model.dao.VentasDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

// Historial de ventas del asesor: reutiliza VentasDao (misma arquitectura que
// ComprasClienteServlet del lado cliente), filtrando por el ID_AGENTE del
// usuario logueado.
@WebServlet("/historialAsesor")
public class AsesorHistorialServlet extends HttpServlet {

    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final TiposVehiculoDao tiposVehiculoDao = new TiposVehiculoDao();
    private final ServiciosDao serviciosDao = new ServiciosDao();
    private final AgentesDao agentesDao = new AgentesDao();
    private final VentasDao ventasDao = new VentasDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UsuarioBean usuario = (UsuarioBean) session.getAttribute("usuarioLogueado");

        List<VentasBean> ventas = new ArrayList<>();

        try {

            Integer idAgente = agentesDao.obtenerIdAgentePorUsuario(usuario.getId_usuario());

            if (idAgente != null) {
                ventas = ventasDao.listarPorAgente(idAgente);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("ventas", ventas);

        List<ClientesBean> clientesAsesor = agentesDao.listarClientesAsignados(usuario.getId_usuario());
        request.setAttribute("clientesAsesor", clientesAsesor);

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
