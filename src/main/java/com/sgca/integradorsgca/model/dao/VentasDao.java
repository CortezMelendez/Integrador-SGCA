package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VentasDao {

    private final DetalleVentaServiciosDao detalleDao = new DetalleVentaServiciosDao();

    public boolean registrarVentaCompleta(VentasBean venta) throws Exception {
        String sqlVenta = "INSERT INTO ADMIN.VENTAS (id_cliente, id_agente, id_vehiculo, fecha_venta, total) " +
                "VALUES (?, ?, ?, SYSDATE, ?)";
        String sqlUpdateVehiculo = "UPDATE ADMIN.VEHICULOS SET disponible = 0 WHERE id_vehiculo = ?";

        Connection con = null;
        PreparedStatement psVenta = null;
        PreparedStatement psVehiculo = null;
        ResultSet rsKeys = null;

        try {
            con = Conexion.getConexion();
            con.setAutoCommit(false); // Iniciar Transacción

            // 1. Insertar Cabecera de Venta
            psVenta = con.prepareStatement(sqlVenta, Statement.RETURN_GENERATED_KEYS);
            psVenta.setInt(1, venta.getCliente().getIdCliente());
            psVenta.setInt(2, venta.getAgente().getIdAgente());
            psVenta.setInt(3, venta.getVehiculo().getId_Vehiculo());
            psVenta.setDouble(4, venta.getTotal());

            int filasVenta = psVenta.executeUpdate();
            if (filasVenta == 0) {
                con.rollback();
                return false;
            }

            // Obtener el ID de la venta insertada
            rsKeys = psVenta.getGeneratedKeys();
            int idVentaGenerado = 0;
            if (rsKeys.next()) {
                idVentaGenerado = rsKeys.getInt(1);
            }

            // 2. Insertar Detalle de Servicios asociando la misma conexión
            if (venta.getDetalles() != null && !venta.getDetalles().isEmpty()) {
                for (DetalleVentaServiciosBean det : venta.getDetalles()) {
                    detalleDao.insertarConTransaccion(con, idVentaGenerado, det);
                }
            }

            // 3. Marcar el Vehículo como No Disponible
            psVehiculo = con.prepareStatement(sqlUpdateVehiculo);
            psVehiculo.setInt(1, venta.getVehiculo().getId_Vehiculo());
            psVehiculo.executeUpdate();

            con.commit(); // Confirmar cambios en BD Oracle
            return true;

        } catch (Exception e) {
            if (con != null) {
                con.rollback(); // Deshacer cambios en caso de fallo
            }
            throw e;
        } finally {
            if (rsKeys != null) rsKeys.close();
            if (psVenta != null) psVenta.close();
            if (psVehiculo != null) psVehiculo.close();
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

    public List<VentasBean> listar() throws Exception {
        List<VentasBean> lista = new ArrayList<>();
        String sql = "SELECT v.id_venta, v.fecha_venta, v.total, " +
                "c.id_cliente, u_c.nombre AS nombre_cliente, u_c.apellido_paterno AS ap_cliente, " +
                "a.id_agente, u_a.nombre AS nombre_agente, u_a.apellido_paterno AS ap_agente, " +
                "veh.id_vehiculo, veh.placa " +
                "FROM ADMIN.VENTAS v " +
                "INNER JOIN ADMIN.CLIENTES c ON v.id_cliente = c.id_cliente " +
                "INNER JOIN ADMIN.USUARIOS u_c ON c.id_usuario = u_c.id_usuario " +
                "INNER JOIN ADMIN.AGENTES a ON v.id_agente = a.id_agente " +
                "INNER JOIN ADMIN.USUARIOS u_a ON a.id_usuario = u_a.id_usuario " +
                "INNER JOIN ADMIN.VEHICULOS veh ON v.id_vehiculo = veh.id_vehiculo " +
                "ORDER BY v.id_venta DESC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                // Cliente
                ClientesBean cliente = new ClientesBean();
                cliente.setIdCliente(rs.getInt("id_cliente"));

                // Agente
                AgentesBean agente = new AgentesBean();
                agente.setIdAgente(rs.getInt("id_agente"));

                // Vehículo
                VehiculosBean vehiculo = new VehiculosBean();
                vehiculo.setId_Vehiculo(rs.getInt("id_vehiculo"));
                vehiculo.setPlaca(rs.getString("placa"));

                VentasBean venta = new VentasBean(
                        rs.getInt("id_venta"),
                        cliente,
                        agente,
                        vehiculo,
                        rs.getTimestamp("fecha_venta"),
                        rs.getDouble("total")
                );

                // Cargar servicios adicionales de esta venta
                venta.setDetalles(detalleDao.obtenerPorVenta(venta.getId_venta()));
                lista.add(venta);
            }
        }
        return lista;
    }
}