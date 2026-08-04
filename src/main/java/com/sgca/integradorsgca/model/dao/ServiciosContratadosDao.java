package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ServiciosContratadosDao {

    public boolean registrar(ServiciosContratadosBean sc) throws Exception {
        String sql = "INSERT INTO ADMIN.SERVICIOS_CONTRATADOS (id_cliente, id_vehiculo, id_servicio, fecha_contratacion, estado, precio_aplicado) " +
                "VALUES (?, ?, ?, SYSDATE, ?, ?)";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, sc.getCliente().getIdCliente());
            ps.setInt(2, sc.getVehiculo().getId_Vehiculo());
            ps.setInt(3, sc.getServicio().getId_servicio());
            ps.setString(4, sc.getEstado() != null ? sc.getEstado() : "PENDIENTE");
            ps.setDouble(5, sc.getPrecioAplicado());

            return ps.executeUpdate() > 0;
        }
    }

    public List<ServiciosContratadosBean> listarPorCliente(int idCliente) throws Exception {
        List<ServiciosContratadosBean> lista = new ArrayList<>();
        String sql = "SELECT sc.id_contratado, sc.fecha_contratacion, sc.estado, sc.precio_aplicado, " +
                "s.id_servicio, s.nombre AS nombre_servicio, " +
                "v.id_vehiculo, v.placa " +
                "FROM ADMIN.SERVICIOS_CONTRATADOS sc " +
                "INNER JOIN ADMIN.SERVICIOS s ON sc.id_servicio = s.id_servicio " +
                "INNER JOIN ADMIN.VEHICULOS v ON sc.id_vehiculo = v.id_vehiculo " +
                "WHERE sc.id_cliente = ? " +
                "ORDER BY sc.id_contratado DESC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCliente);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ServiciosBean s = new ServiciosBean();
                    s.setId_servicio(rs.getInt("id_servicio"));
                    s.setNombre(rs.getString("nombre_servicio"));

                    VehiculosBean v = new VehiculosBean();
                    v.setId_Vehiculo(rs.getInt("id_vehiculo"));
                    v.setPlaca(rs.getString("placa"));

                    ServiciosContratadosBean sc = new ServiciosContratadosBean(
                            rs.getInt("id_contratado"),
                            null,
                            v,
                            s,
                            rs.getTimestamp("fecha_contratacion"),
                            rs.getString("estado"),
                            rs.getDouble("precio_aplicado")
                    );
                    lista.add(sc);
                }
            }
        }
        return lista;
    }

    public boolean actualizarEstado(int idContratado, String nuevoEstado) throws Exception {
        String sql = "UPDATE ADMIN.SERVICIOS_CONTRATADOS SET estado = ? WHERE id_contratado = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nuevoEstado);
            ps.setInt(2, idContratado);

            return ps.executeUpdate() > 0;
        }
    }
}