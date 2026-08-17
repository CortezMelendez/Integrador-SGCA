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
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

// Modal "Cotización" del navbar del asesor: convierte la cotización armada en
// una venta real (ADMIN.VENTAS + ADMIN.DETALLE_VENTA_SERVICIOS), reutilizando
// VentasDao.registrarVentaCompleta. El total se recalcula en el servidor con los precios
// reales de BD. Si la venta se registra con éxito, responde con el comprobante
// informativo (folio, cliente, vehículo, servicios y total) en JSON, tal como
// lo pide el DFR del módulo 5 ("genera un comprobante informativo").
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
            ClientesBean clienteCartera = misClientes.stream()
                    .filter(c -> c.getIdCliente() == idCliente)
                    .findFirst()
                    .orElse(null);
            if (clienteCartera == null) {
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

            int idVentaGenerado = ventasDao.registrarVentaCompleta(venta);
            if (idVentaGenerado <= 0) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().println("No se pudo registrar la venta. Intenta de nuevo.");
                return;
            }

            String nombreAsesor = (asesor.getNombre() + " " + asesor.getApellidoPaterno()).trim();
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().println(
                    aJsonComprobante(idVentaGenerado, clienteCartera, nombreAsesor, vehiculo, detalles, total));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Ocurrió un error en el servidor. Intenta más tarde.");
        }
    }

    // Comprobante informativo de la venta (Módulo 5 del DFR): folio, fecha,
    // cliente, asesor, vehículo, servicios contratados y total. No es un
    // comprobante fiscal ni de cobro (eso se hace fuera de la plataforma),
    // solo confirma en pantalla los datos de la operación.
    private String aJsonComprobante(int idVenta, ClientesBean cliente, String nombreAsesor,
                                     VehiculosBean vehiculo, List<DetalleVentaServiciosBean> detalles,
                                     double total) {
        SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        String nombreVehiculo = vehiculo.getMarca().getNombre() + " " + vehiculo.getModelos().getNombre()
                + " " + vehiculo.getAnio();

        StringBuilder json = new StringBuilder("{");
        json.append("\"folio\":").append(idVenta).append(",");
        json.append("\"fecha\":\"").append(escapeJson(formato.format(new Date()))).append("\",");
        json.append("\"cliente\":\"").append(escapeJson(cliente.getNombreCliente())).append("\",");
        json.append("\"asesor\":\"").append(escapeJson(nombreAsesor)).append("\",");
        json.append("\"vehiculo\":\"").append(escapeJson(nombreVehiculo)).append("\",");
        json.append("\"placa\":\"").append(escapeJson(vehiculo.getPlaca())).append("\",");
        json.append("\"precioVehiculo\":").append(vehiculo.getPrecio()).append(",");

        json.append("\"servicios\":[");
        boolean primero = true;
        for (DetalleVentaServiciosBean det : detalles) {
            if (!primero) json.append(",");
            primero = false;
            json.append("{\"nombre\":\"").append(escapeJson(det.getServicio().getNombre()))
                    .append("\",\"precio\":").append(det.getPrecio()).append("}");
        }
        json.append("],");
        json.append("\"total\":").append(total);
        json.append("}");
        return json.toString();
    }

    private String escapeJson(String valor) {
        if (valor == null) return "";
        return valor.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", " ")
                .replace("<", "\\u003c")
                .replace(">", "\\u003e");
    }
}
