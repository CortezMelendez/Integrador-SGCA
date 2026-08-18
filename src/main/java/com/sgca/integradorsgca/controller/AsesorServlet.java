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

// Panel principal del agente/asesor. Reutiliza el mismo catálogo de vehículos
// y el mismo modal de servicios que ya usa el cliente (misma arquitectura).
@WebServlet("/asesor")
public class AsesorServlet extends HttpServlet {

    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final TiposVehiculoDao tiposVehiculoDao = new TiposVehiculoDao();
    private final ServiciosDao serviciosDao = new ServiciosDao();
    private final AgentesDao agentesDao = new AgentesDao();

    private static final int LIMITE_CARRUSEL = 12;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<VehiculosBean> vehiculos = vehiculosDao.listarDisponibles();

        request.setAttribute("vehiculos", vehiculos);
        request.setAttribute("vehiculosNuevos", vehiculosDao.listarMasNuevos(LIMITE_CARRUSEL));
        request.setAttribute("vehiculosAccesibles", vehiculosDao.listarMasAccesibles(LIMITE_CARRUSEL));
        request.setAttribute("vehiculosRecientes", vehiculosDao.listarRecienAgregados(LIMITE_CARRUSEL));
        request.setAttribute("vehiculosDestacados", vehiculosDao.listarDestacados(LIMITE_CARRUSEL));
        request.setAttribute("listaTipos", tiposVehiculoDao.listar());

        HttpSession session = request.getSession(false);
        UsuarioBean usuario = session != null ? (UsuarioBean) session.getAttribute("usuarioLogueado") : null;

        List<ClientesBean> clientesAsesor = usuario != null
                ? agentesDao.listarClientesAsignados(usuario.getId_usuario())
                : new ArrayList<>();
        request.setAttribute("clientesAsesor", clientesAsesor);

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
