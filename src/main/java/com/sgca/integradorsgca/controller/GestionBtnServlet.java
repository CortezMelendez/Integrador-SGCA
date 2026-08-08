package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.AgentesBean;
import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.TiposServicioBean;
import com.sgca.integradorsgca.model.bean.TiposVehiculoBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.dao.AgentesDao;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
import com.sgca.integradorsgca.model.dao.TiposServicioDao;
import com.sgca.integradorsgca.model.dao.TiposVehiculoDao;
import com.sgca.integradorsgca.model.dao.VehiculosDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/btn")
public class GestionBtnServlet extends HttpServlet {

    private static final String BASE_DUENIO = "/pages/duenioPages/";

    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final TiposVehiculoDao tiposVehiculoDao = new TiposVehiculoDao();
    private final AgentesDao agentesDao = new AgentesDao();
    private final ServiciosDao serviciosDao = new ServiciosDao();
    private final TiposServicioDao tiposServicioDao = new TiposServicioDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UsuarioBean usuario = (session != null)
                ? (UsuarioBean) session.getAttribute("usuarioLogueado")
                : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=sesion_requerida");
            return;
        }

        String rol = obtenerNombreRol(usuario);
        if (!"ADMIN".equals(rol)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=no_autorizado");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "inicio";

        try {
            switch (action) {
                case "gestionServicio":
                    List<ServiciosBean> listaServicios = serviciosDao.listar();
                    List<TiposServicioBean> listaTiposServicio = tiposServicioDao.listar();

                    request.setAttribute("listaServicios", listaServicios);
                    request.setAttribute("listaTipos", listaTiposServicio);

                    request.getRequestDispatcher(BASE_DUENIO + "gestionServicios.jsp").forward(request, response);
                    break;

                case "gestionEmpleados":
                    request.getRequestDispatcher(BASE_DUENIO + "gestionEmpleados.jsp").forward(request, response);
                    break;

                case "gestionClientes":
                    request.getRequestDispatcher(BASE_DUENIO + "gestionClientes.jsp").forward(request, response);
                    break;

                case "gestionAutos":
                    List<VehiculosBean> listaVehiculos = vehiculosDao.listar();
                    List<TiposVehiculoBean> listaTipos = tiposVehiculoDao.listar();
                    List<AgentesBean> listaAgentes = agentesDao.listar();

                    request.setAttribute("listaVehiculos", listaVehiculos);
                    request.setAttribute("listaTipos", listaTipos);
                    request.setAttribute("listaAgentes", listaAgentes);

                    request.getRequestDispatcher(BASE_DUENIO + "gestionAutos.jsp").forward(request, response);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + BASE_DUENIO + "indexDuenio.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/btn?action=inicio&error=carga");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String obtenerNombreRol(UsuarioBean usuario) {
        if (usuario != null && usuario.getRol() != null && usuario.getRol().getRol() != null) {
            String nombreRol = usuario.getRol().getRol().trim().toUpperCase();
            if (!nombreRol.isEmpty()) return nombreRol;
        }
        if (usuario != null && usuario.getRol() != null) {
            switch (usuario.getRol().getId_Rol()) {
                case 1: return "ADMIN";
                case 2: return "AGENTE";
                case 3: return "CLIENTE";
            }
        }
        return "INVITADO";
    }
}