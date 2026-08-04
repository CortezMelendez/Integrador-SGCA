package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.DetalleVentaServiciosBean;
import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.TiposServicioBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DetalleVentaServiciosDao {

    /**
     * Inserta un detalle recibiendo una conexión activa para participar en la transacción.
     */
    public boolean insertarConTransaccion(Connection con, int idVenta, DetalleVentaServiciosBean detalle) throws Exception {
        String sql = "INSERT INTO ADMIN.DETALLE_VENTA_SERVICIOS (id_venta, id_servicio, precio) VALUES (?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idVenta);
            ps.setInt(2, detalle.getServicio().getId_servicio());
            ps.setDouble(3, detalle.getPrecio());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Obtiene los servicios contratados asociados a una venta específica.
     */
    public List<DetalleVentaServiciosBean> obtenerPorVenta(int idVenta) throws Exception {
        List<DetalleVentaServiciosBean> lista = new ArrayList<>();
        String sql = "SELECT d.id_detalle, d.id_venta, d.precio, s.id_servicio, s.nombre AS nombre_servicio, " +
                "ts.id_tipo_servicio, ts.nombre AS nombre_tipo " +
                "FROM ADMIN.DETALLE_VENTA_SERVICIOS d " +
                "INNER JOIN ADMIN.SERVICIOS s ON d.id_servicio = s.id_servicio " +
                "INNER JOIN ADMIN.TIPOS_SERVICIO ts ON s.id_tipo_servicio = ts.id_tipo_servicio " +
                "WHERE d.id_venta = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idVenta);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TiposServicioBean tipo = new TiposServicioBean(
                            rs.getInt("id_tipo_servicio"),
                            rs.getString("nombre_tipo")
                    );

                    ServiciosBean serv = new ServiciosBean();
                    serv.setId_servicio(rs.getInt("id_servicio"));
                    serv.setNombre(rs.getString("nombre_servicio"));
                    serv.setTipoServicio(tipo);

                    DetalleVentaServiciosBean det = new DetalleVentaServiciosBean(
                            rs.getInt("id_detalle"),
                            rs.getInt("id_venta"),
                            serv,
                            rs.getDouble("precio")
                    );
                    lista.add(det);
                }
            }
        }
        return lista;
    }
}