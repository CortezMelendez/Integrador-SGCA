package com.sgca.integradorsgca.controller;


import com.sgca.integradorsgca.model.bean.AgentesBean;
import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.bean.VentasBean;
import com.sgca.integradorsgca.model.dao.AgentesDao;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
import com.sgca.integradorsgca.model.dao.TiposVehiculoDao;
import com.sgca.integradorsgca.model.dao.UsuarioDao;
import com.sgca.integradorsgca.model.dao.VehiculosDao;
import com.sgca.integradorsgca.model.dao.VentasDao;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/nav")
public class NavBarAdminServlet extends HttpServlet {

    private static final String BASE_DUENIO = "/pages/duenioPages/";
    private static final int ID_ROL_CLIENTE = 3;
    private static final int LIMITE_CARRUSEL = 12;
    private static final String[] MESES_ES = {"Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"};

    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final ServiciosDao serviciosDao = new ServiciosDao();
    private final AgentesDao agentesDao = new AgentesDao();
    private final UsuarioDao usuarioDao = new UsuarioDao();
    private final VentasDao ventasDao = new VentasDao();
    private final TiposVehiculoDao tiposVehiculoDao = new TiposVehiculoDao();

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

        // Catálogo de tipos de vehículo para el dropdown "Vehículos" del navbar
        // (mismo dropdown que ya tiene el asesor, apuntando a /automoviles).
        request.setAttribute("listaTiposVehiculo", tiposVehiculoDao.listar());

        switch (action) {
            case "inicio":
                cargarCarruseles(request);
                request.getRequestDispatcher(BASE_DUENIO + "indexDuenio.jsp").forward(request, response);
                break;

            case "dashboard":
                cargarDashboard(request);
                request.getRequestDispatcher(BASE_DUENIO + "dashboard.jsp").forward(request, response);
                break;

            case "historial":
                cargarHistorial(request);
                request.getRequestDispatcher(BASE_DUENIO + "historial.jsp").forward(request, response);
                break;

            case "perfil":
                // El modal de perfil vive en indexDuenio.jsp; "Configuración" desde
                // cualquier otra pantalla del dueño reenvía aquí y esta bandera hace
                // que la vista lo abra automáticamente al cargar.
                request.setAttribute("abrirPerfil", true);
                cargarCarruseles(request);
                request.getRequestDispatcher(BASE_DUENIO + "indexDuenio.jsp").forward(request, response);
                break;

            case "logout":
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/nav?action=inicio");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // Datos de los 4 carruseles del index del dueño (indexDuenio.jsp).
    private void cargarCarruseles(HttpServletRequest request) {
        request.setAttribute("vehiculos", vehiculosDao.listarDisponibles());
        request.setAttribute("vehiculosNuevos", vehiculosDao.listarMasNuevos(LIMITE_CARRUSEL));
        request.setAttribute("vehiculosAccesibles", vehiculosDao.listarMasAccesibles(LIMITE_CARRUSEL));
        request.setAttribute("vehiculosRecientes", vehiculosDao.listarRecienAgregados(LIMITE_CARRUSEL));
        request.setAttribute("vehiculosDestacados", vehiculosDao.listarDestacados(LIMITE_CARRUSEL));
    }

    /**
     * Calcula las métricas, los datos de las gráficas y los registros
     * recientes que necesita dashboard.jsp. Si alguna consulta falla, esa
     * sección del dashboard simplemente queda en 0 / vacía en vez de tumbar
     * toda la página.
     */
    private void cargarDashboard(HttpServletRequest request) {
        try {
            List<VehiculosBean> vehiculos = vehiculosDao.listar();
            List<ServiciosBean> servicios = serviciosDao.listar();
            List<AgentesBean> agentes = agentesDao.listar();
            List<UsuarioBean> clientes = usuarioDao.listarPorRol(ID_ROL_CLIENTE);
            List<VentasBean> ventas = ventasDao.listar();

            // --- Métricas ---
            int totalVehiculos = vehiculos.size();
            long vehiculosDisponibles = vehiculos.stream().filter(v -> v.getDisponible() == 1).count();

            int totalServicios = servicios.size();
            long serviciosActivos = servicios.stream().filter(s -> s.getEstado() == 1).count();

            long agentesActivos = agentes.stream().filter(a -> a.getEstado() == 1).count();

            int totalClientes = clientes.size();
            long clientesNuevosMes = clientes.stream().filter(this::esDeEsteMes).count();

            // DFR módulo 7.1: "Ventas totales" como métrica propia del dashboard,
            // no solo como gráfica mensual.
            int totalVentas = ventas.size();
            long ventasEsteMes = ventas.stream().filter(this::esVentaDeEsteMes).count();

            request.setAttribute("metricVehiculos", totalVehiculos);
            request.setAttribute("metricVehiculosDisponibles", vehiculosDisponibles);
            request.setAttribute("metricServicios", serviciosActivos);
            request.setAttribute("metricServiciosTotal", totalServicios);
            request.setAttribute("metricContactos", agentesActivos);
            request.setAttribute("metricClientes", totalClientes);
            request.setAttribute("metricClientesNuevosMes", clientesNuevosMes);
            request.setAttribute("metricVentas", totalVentas);
            request.setAttribute("metricVentasMes", ventasEsteMes);

            // --- Gráfica de barras: ventas de los últimos 6 meses ---
            Map<String, Long> ventasPorMes = new LinkedHashMap<>();
            Calendar hoy = Calendar.getInstance();
            for (int i = 5; i >= 0; i--) {
                Calendar c = (Calendar) hoy.clone();
                c.add(Calendar.MONTH, -i);
                ventasPorMes.put(claveMes(c), 0L);
            }
            for (VentasBean v : ventas) {
                if (v.getFechaVenta() == null) continue;
                Calendar c = Calendar.getInstance();
                c.setTimeInMillis(v.getFechaVenta().getTime());
                String clave = claveMes(c);
                if (ventasPorMes.containsKey(clave)) {
                    ventasPorMes.merge(clave, 1L, Long::sum);
                }
            }
            request.setAttribute("chartVentasLabels", toJsonArrayTexto(ventasPorMes.keySet()));
            request.setAttribute("chartVentasValues", toJsonArrayNumerico(ventasPorMes.values()));

            // --- Gráfica circular: vehículos por categoría ---
            Map<String, Long> porCategoria = new LinkedHashMap<>();
            for (VehiculosBean v : vehiculos) {
                String categoria = (v.getTipoVehiculo() != null && v.getTipoVehiculo().getNombre() != null)
                        ? v.getTipoVehiculo().getNombre() : "Sin categoría";
                porCategoria.merge(categoria, 1L, Long::sum);
            }
            request.setAttribute("chartVehiculosLabels", toJsonArrayTexto(porCategoria.keySet()));
            request.setAttribute("chartVehiculosValues", toJsonArrayNumerico(porCategoria.values()));

            // --- Registros recientes: últimas ventas ---
            List<VentasBean> recientes = ventas.size() > 6 ? ventas.subList(0, 6) : ventas;
            request.setAttribute("ventasRecientes", recientes);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ventasRecientes", new ArrayList<VentasBean>());
        }
    }

    /**
     * Historial completo de ventas y servicios (Módulo 6 del DFR): trae todas
     * las ventas con su cliente, agente, vehículo y servicios contratados
     * para que el dueño pueda consultarlas y filtrarlas por placa en
     * historial.jsp. Si la consulta falla, la tabla simplemente queda vacía
     * en vez de tumbar la página.
     */
    private void cargarHistorial(HttpServletRequest request) {
        try {
            List<VentasBean> ventas = ventasDao.listar();
            request.setAttribute("listaVentas", ventas);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("listaVentas", new ArrayList<VentasBean>());
        }
    }

    private boolean esDeEsteMes(UsuarioBean u) {
        if (u.getFechaRegistro() == null) return false;
        Calendar hoy = Calendar.getInstance();
        Calendar registro = Calendar.getInstance();
        registro.setTimeInMillis(u.getFechaRegistro().getTime());
        return registro.get(Calendar.MONTH) == hoy.get(Calendar.MONTH)
                && registro.get(Calendar.YEAR) == hoy.get(Calendar.YEAR);
    }

    private boolean esVentaDeEsteMes(VentasBean v) {
        if (v.getFechaVenta() == null) return false;
        Calendar hoy = Calendar.getInstance();
        Calendar venta = Calendar.getInstance();
        venta.setTimeInMillis(v.getFechaVenta().getTime());
        return venta.get(Calendar.MONTH) == hoy.get(Calendar.MONTH)
                && venta.get(Calendar.YEAR) == hoy.get(Calendar.YEAR);
    }

    private String claveMes(Calendar c) {
        return MESES_ES[c.get(Calendar.MONTH)];
    }

    private String toJsonArrayTexto(Iterable<String> valores) {
        StringBuilder sb = new StringBuilder("[");
        boolean primero = true;
        for (String v : valores) {
            if (!primero) sb.append(",");
            sb.append("\"").append(v == null ? "" : v.replace("\"", "'")).append("\"");
            primero = false;
        }
        return sb.append("]").toString();
    }

    private String toJsonArrayNumerico(Iterable<Long> valores) {
        StringBuilder sb = new StringBuilder("[");
        boolean primero = true;
        for (Long v : valores) {
            if (!primero) sb.append(",");
            sb.append(v);
            primero = false;
        }
        return sb.append("]").toString();
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