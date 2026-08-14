package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.ClientesBean;
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

/**
 * Tabla "Mis cotizaciones" del asesor (pages/asesorPages/cotizaciones.jsp).
 * El sistema no maneja cotizaciones "pendientes" separadas de una venta: al
 * confirmar el modal "Nueva cotización" se registra de inmediato como venta
 * real (mismo /registrarVentaAsesor que ya existía), por eso esta pantalla
 * lista las ventas del propio agente (igual que historialAsesor), pero con
 * el flujo de creación con buscador de cliente/auto/servicios.
 */
@WebServlet("/cotizacionesAsesor")
public class AsesorCotizacionesServlet extends HttpServlet {

    private final VentasDao ventasDao = new VentasDao();
    private final AgentesDao agentesDao = new AgentesDao();
    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final ServiciosDao serviciosDao = new ServiciosDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UsuarioBean usuario = (UsuarioBean) session.getAttribute("usuarioLogueado");

        List<VentasBean> cotizaciones = new ArrayList<>();
        try {
            Integer idAgente = agentesDao.obtenerIdAgentePorUsuario(usuario.getId_usuario());
            if (idAgente != null) {
                cotizaciones = ventasDao.listarPorAgente(idAgente);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("cotizaciones", cotizaciones);

        List<ClientesBean> clientesAsesor = agentesDao.listarClientesAsignados(usuario.getId_usuario());
        request.setAttribute("clientesAsesor", clientesAsesor);
        request.setAttribute("clientesJson", aJsonClientes(clientesAsesor));

        List<VehiculosBean> vehiculosDisponibles = vehiculosDao.listarDisponibles();
        request.setAttribute("vehiculosJson", aJsonVehiculos(vehiculosDisponibles));

        List<ServiciosBean> servicios = new ArrayList<>();
        try {
            for (ServiciosBean s : serviciosDao.listar()) {
                if (s.getEstado() == 1) servicios.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("servicios", servicios);
        request.setAttribute("serviciosJson", aJsonServicios(servicios));

        request.getRequestDispatcher("/pages/asesorPages/cotizaciones.jsp").forward(request, response);
    }

    // {id, nombre} por cada cliente de la cartera, para el buscador del modal
    private String aJsonClientes(List<ClientesBean> clientes) {
        StringBuilder json = new StringBuilder("[");
        boolean primero = true;
        for (ClientesBean c : clientes) {
            if (!primero) json.append(",");
            primero = false;
            json.append("{\"id\":").append(c.getIdCliente())
                    .append(",\"nombre\":\"").append(escapeJson(c.getNombreCliente())).append("\"}");
        }
        json.append("]");
        return json.toString();
    }

    // {id, nombre, precio} por cada vehículo disponible, para el buscador del modal
    private String aJsonVehiculos(List<VehiculosBean> vehiculos) {
        StringBuilder json = new StringBuilder("[");
        boolean primero = true;
        for (VehiculosBean v : vehiculos) {
            if (!primero) json.append(",");
            primero = false;
            String nombre = v.getMarca().getNombre() + " " + v.getModelos().getNombre()
                    + " " + v.getAnio() + " — " + v.getPlaca();
            json.append("{\"id\":").append(v.getId_Vehiculo())
                    .append(",\"nombre\":\"").append(escapeJson(nombre))
                    .append("\",\"precio\":").append(v.getPrecio()).append("}");
        }
        json.append("]");
        return json.toString();
    }

    // {id, nombre, tipo, precio} por cada servicio activo, para el buscador del modal
    private String aJsonServicios(List<ServiciosBean> servicios) {
        StringBuilder json = new StringBuilder("[");
        boolean primero = true;
        for (ServiciosBean s : servicios) {
            if (!primero) json.append(",");
            primero = false;
            json.append("{\"id\":").append(s.getId_servicio())
                    .append(",\"nombre\":\"").append(escapeJson(s.getNombre()))
                    .append("\",\"tipo\":\"").append(escapeJson(s.getTipoServicio().getNombre()))
                    .append("\",\"precio\":").append(s.getPrecio()).append("}");
        }
        json.append("]");
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
