package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.ClientesBean;
import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.dao.AgentesDao;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
import com.sgca.integradorsgca.model.dao.TiposVehiculoDao;
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

// Catálogo de vehículos del cliente: es una sola vista (automovilesCliente.jsp) que se
// reutiliza para cualquier tipo de vehículo que exista en la BD, sin importar cuál sea.
@WebServlet("/automoviles")
public class AutomovilesClienteServlet extends HttpServlet {

    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final TiposVehiculoDao tiposVehiculoDao = new TiposVehiculoDao();
    private final ServiciosDao serviciosDao = new ServiciosDao();
    private final AgentesDao agentesDao = new AgentesDao();

    private static final List<String> ORDENES_VALIDOS =
            List.of("precio_desc", "precio_asc", "az", "recientes");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tipo = request.getParameter("tipo");
        String buscar = request.getParameter("buscar");
        String orden = request.getParameter("orden");

        if (orden != null && !ORDENES_VALIDOS.contains(orden)) {
            orden = null;
        }

        List<VehiculosBean> automoviles =
                vehiculosDao.listarClientePorTipo(tipo, buscar, orden);

        request.setAttribute("automoviles", automoviles);
        request.setAttribute("tipoSeleccionado", tipo);
        request.setAttribute("ordenSeleccionado", orden);
        request.setAttribute("buscarValor", buscar);

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
                "/pages/clientePages/automovilesCliente.jsp"
        ).forward(request, response);
    }
}
