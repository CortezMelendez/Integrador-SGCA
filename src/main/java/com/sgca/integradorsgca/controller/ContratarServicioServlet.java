package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.ClientesBean;
import com.sgca.integradorsgca.model.bean.DetalleVentaServiciosBean;
import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.VentasBean;
import com.sgca.integradorsgca.model.dao.AgentesDao;
import com.sgca.integradorsgca.model.dao.ClientesDao;
import com.sgca.integradorsgca.model.dao.DetalleVentaServiciosDao;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
import com.sgca.integradorsgca.model.dao.VentasDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

// Contratación de servicios adicionales para un vehículo ya adquirido
// (DFR módulo 5.2), independiente de la venta original: el Cliente dueño
// del vehículo o el Agente responsable de ese cliente pueden agregar
// servicios activos del catálogo a una venta que ya existe.
@WebServlet("/contratarServicio")
public class ContratarServicioServlet extends HttpServlet {

    private final VentasDao ventasDao = new VentasDao();
    private final ServiciosDao serviciosDao = new ServiciosDao();
    private final DetalleVentaServiciosDao detalleDao = new DetalleVentaServiciosDao();
    private final AgentesDao agentesDao = new AgentesDao();
    private final ClientesDao clientesDao = new ClientesDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        HttpSession session = request.getSession(false);
        UsuarioBean usuario = session != null
                ? (UsuarioBean) session.getAttribute("usuarioLogueado")
                : null;

        if (usuario == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("Tu sesión expiró. Vuelve a iniciar sesión.");
            return;
        }

        int idVenta;
        String[] idsServiciosParam = request.getParameterValues("idsServicios");

        try {
            idVenta = Integer.parseInt(request.getParameter("idVenta"));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("Selecciona un vehículo válido.");
            return;
        }

        if (idsServiciosParam == null || idsServiciosParam.length == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("Selecciona al menos un servicio a contratar.");
            return;
        }

        try {
            VentasBean venta = ventasDao.buscarPorId(idVenta);
            if (venta == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("Ese vehículo no tiene una compra registrada.");
                return;
            }

            if (!clienteAutorizado(usuario, venta)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().print("Ese vehículo no te pertenece.");
                return;
            }

            for (String idServicioStr : idsServiciosParam) {
                int idServicio;
                try {
                    idServicio = Integer.parseInt(idServicioStr);
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().print("Selecciona servicios válidos.");
                    return;
                }

                ServiciosBean servicio = serviciosDao.buscarPorId(idServicio);
                if (servicio == null || servicio.getEstado() != 1) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().print("Uno de los servicios seleccionados ya no está disponible.");
                    return;
                }

                DetalleVentaServiciosBean detalle =
                        new DetalleVentaServiciosBean(0, idVenta, servicio, servicio.getPrecio());
                detalleDao.insertar(idVenta, detalle);
            }

            response.getWriter().print("Servicio contratado exitosamente");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("Ocurrió un error en el servidor. Intenta más tarde.");
        }
    }

    // El vehículo debe pertenecer al cliente que contrata el servicio
    // (regla de negocio del DFR 5.2): si es el propio Cliente, que la venta
    // sea suya; si es un Agente, que el cliente de esa venta esté en su cartera.
    private boolean clienteAutorizado(UsuarioBean usuario, VentasBean venta) throws Exception {
        String rol = usuario.getRol() != null && usuario.getRol().getRol() != null
                ? usuario.getRol().getRol().trim().toUpperCase()
                : "";

        if ("CLIENTE".equals(rol)) {
            ClientesBean cliente = clientesDao.buscarPorIdUsuario(usuario.getId_usuario());
            return cliente != null && cliente.getIdCliente() == venta.getCliente().getIdCliente();
        }

        if ("AGENTE".equals(rol)) {
            List<ClientesBean> misClientes = agentesDao.listarClientesAsignados(usuario.getId_usuario());
            return misClientes.stream().anyMatch(c -> c.getIdCliente() == venta.getCliente().getIdCliente());
        }

        return false;
    }
}
