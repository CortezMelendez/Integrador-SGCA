package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.AgentesBean;
import com.sgca.integradorsgca.model.bean.ClientesBean;
import com.sgca.integradorsgca.model.bean.DetalleVentaServiciosBean;
import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.bean.VentasBean;
import com.sgca.integradorsgca.model.dao.AgentesDao;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
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

// Modal "Cotización" del navbar del asesor: convierte la cotización armada en
// una venta real (ADMIN.VENTAS + ADMIN.DETALLE_VENTA_SERVICIOS), reutilizando
// VentasDao.registrarVentaCompleta. El total se recalcula en el servidor con los precios
// reales de BD.
@WebServlet("/registrarVentaAsesor")
public class AsesorRegistrarVentaServlet extends HttpServlet {

    private final AgentesDao agentesDao = new AgentesDao();
    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final ServiciosDao serviciosDao = new ServiciosDao();
    private final VentasDao ventasDao = new VentasDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);
        UsuarioBean asesor = session != null
                ? (UsuarioBean) session.getAttribute("usuarioLogueado")
                : null;

        if (asesor == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().println("Tu sesión expiró. Vuelve a iniciar sesión.");
            return;
        }

        int idCliente;
        int idVehiculo;
        try {
            idCliente = Integer.parseInt(request.getParameter("idCliente"));
            idVehiculo = Integer.parseInt(request.getParameter("idVehiculo"));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("Selecciona un cliente y un vehículo válidos.");
            return;
        }

        try {
            Integer idAgente = agentesDao.obtenerIdAgentePorUsuario(asesor.getId_usuario());
            if (idAgente == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().println("Tu cuenta no tiene un perfil de agente activo.");
                return;
            }

            List<ClientesBean> misClientes = agentesDao.listarClientesAsignados(asesor.getId_usuario());
            boolean esClientePropio = misClientes.stream().anyMatch(c -> c.getIdCliente() == idCliente);
            if (!esClientePropio) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().println("Ese cliente no pertenece a tu cartera.");
                return;
            }

            VehiculosBean vehiculo = vehiculosDao.buscarPorID(idVehiculo);
            if (vehiculo == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().println("El vehículo seleccionado ya no existe.");
                return;
            }
            if (vehiculo.getDisponible() != 1) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().println("Ese vehículo ya no está disponible.");
                return;
            }

            double total = vehiculo.getPrecio().doubleValue();
            List<DetalleVentaServiciosBean> detalles = new ArrayList<>();

            String[] idsServicios = request.getParameterValues("idsServicios");
            if (idsServicios != null) {
                for (String idServicioStr : idsServicios) {
                    ServiciosBean servicio = serviciosDao.buscarPorId(Integer.parseInt(idServicioStr));
                    if (servicio != null && servicio.getEstado() == 1) {
                        detalles.add(new DetalleVentaServiciosBean(0, 0, servicio, servicio.getPrecio()));
                        total += servicio.getPrecio();
                    }
                }
            }

            ClientesBean cliente = new ClientesBean();
            cliente.setIdCliente(idCliente);

            AgentesBean agente = new AgentesBean();
            agente.setIdAgente(idAgente);

            VentasBean venta = new VentasBean();
            venta.setCliente(cliente);
            venta.setAgente(agente);
            venta.setVehiculo(vehiculo);
            venta.setTotal(total);
            venta.setDetalles(detalles);

            boolean exito = ventasDao.registrarVentaCompleta(venta);
            if (!exito) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().println("No se pudo registrar la venta. Intenta de nuevo.");
                return;
            }

            response.getWriter().println("Venta registrada correctamente.");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Ocurrió un error en el servidor. Intenta más tarde.");
        }
    }
}
