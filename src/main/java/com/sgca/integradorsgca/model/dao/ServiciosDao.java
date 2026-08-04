package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.TiposServicioBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ServiciosDao {

    public List<ServiciosBean> listar() throws Exception {
        List<ServiciosBean> lista = new ArrayList<>();
        String sql = "SELECT s.id_servicio, s.id_tipo_servicio, ts.nombre AS nombre_tipo, " +
                "s.nombre, s.descripcion, s.precio, s.estado " +
                "FROM ADMIN.SERVICIOS s " +
                "INNER JOIN ADMIN.TIPOS_SERVICIO ts ON s.id_tipo_servicio = ts.id_tipo_servicio " +
                "ORDER BY s.id_servicio ASC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                TiposServicioBean tipo = new TiposServicioBean(
                        rs.getInt("id_tipo_servicio"),
                        rs.getString("nombre_tipo")
                );

                ServiciosBean servicio = new ServiciosBean(
                        rs.getInt("id_servicio"),
                        tipo,
                        rs.getString("nombre"),
                        rs.getString("descripcion"),
                        rs.getDouble("precio"),
                        rs.getInt("estado")
                );
                lista.add(servicio);
            }
        }
        return lista;
    }

    public boolean registrar(ServiciosBean servicio) throws Exception {
        String sql = "INSERT INTO ADMIN.SERVICIOS (id_tipo_servicio, nombre, descripcion, precio, estado) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, servicio.getTipoServicio().getId_tipo_servicio());
            ps.setString(2, servicio.getNombre());
            ps.setString(3, servicio.getDescripcion());
            ps.setDouble(4, servicio.getPrecio());
            ps.setInt(5, servicio.getEstado() != 0 ? servicio.getEstado() : 1);

            return ps.executeUpdate() > 0;
        }
    }

    public boolean actualizarEstado(int idServicio, int nuevoEstado) throws Exception {
        String sql = "UPDATE ADMIN.SERVICIOS SET estado = ? WHERE id_servicio = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, nuevoEstado);
            ps.setInt(2, idServicio);

            return ps.executeUpdate() > 0;
        }
    }
}