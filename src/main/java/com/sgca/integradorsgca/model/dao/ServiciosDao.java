package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.TiposServicioBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ServiciosDao {

    /*
     * =====================================
     * LISTAR TODOS LOS SERVICIOS
     * =====================================
     */
    public List<ServiciosBean> listar() throws Exception {

        List<ServiciosBean> lista = new ArrayList<>();

        String sql = """
                SELECT
                    s.id_servicio,
                    s.id_tipo_servicio,
                    ts.nombre AS nombre_tipo,
                    s.nombre,
                    s.descripcion,
                    s.precio,
                    s.estado,
                    s.fecha_registro
                FROM ADMIN.SERVICIOS s
                INNER JOIN ADMIN.TIPOS_SERVICIO ts
                ON s.id_tipo_servicio = ts.id_tipo_servicio
                ORDER BY s.id_servicio
                """;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                TiposServicioBean tipo = new TiposServicioBean();

                tipo.setId_tipo_servicio(rs.getInt("id_tipo_servicio"));
                tipo.setNombre(rs.getString("nombre_tipo"));

                ServiciosBean servicio = new ServiciosBean();

                servicio.setId_servicio(rs.getInt("id_servicio"));
                servicio.setTipoServicio(tipo);
                servicio.setNombre(rs.getString("nombre"));
                servicio.setDescripcion(rs.getString("descripcion"));
                servicio.setPrecio(rs.getDouble("precio"));
                servicio.setEstado(rs.getInt("estado"));
                servicio.setFechaRegistro(rs.getTimestamp("fecha_registro"));

                lista.add(servicio);
            }
        }

        return lista;
    }

    /*
     * =====================================
     * REGISTRAR SERVICIO
     * =====================================
     */
    public boolean registrar(ServiciosBean servicio) throws Exception {

        String sql = """
                INSERT INTO ADMIN.SERVICIOS
                (
                    id_tipo_servicio,
                    nombre,
                    descripcion,
                    precio,
                    estado,
                    fecha_registro
                )
                VALUES
                (
                    ?,?,?,?,?,SYSDATE
                )
                """;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, servicio.getTipoServicio().getId_tipo_servicio());
            ps.setString(2, servicio.getNombre());
            ps.setString(3, servicio.getDescripcion());
            ps.setDouble(4, servicio.getPrecio());
            ps.setInt(5, servicio.getEstado());

            return ps.executeUpdate() > 0;
        }
    }

    /*
     * =====================================
     * BUSCAR POR ID
     * =====================================
     */
    public ServiciosBean buscarPorId(int idServicio) throws Exception {

        String sql = """
                SELECT
                    s.id_servicio,
                    s.id_tipo_servicio,
                    ts.nombre nombre_tipo,
                    s.nombre,
                    s.descripcion,
                    s.precio,
                    s.estado,
                    s.fecha_registro
                FROM ADMIN.SERVICIOS s
                INNER JOIN ADMIN.TIPOS_SERVICIO ts
                ON ts.id_tipo_servicio=s.id_tipo_servicio
                WHERE s.id_servicio=?
                """;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idServicio);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                TiposServicioBean tipo = new TiposServicioBean();

                tipo.setId_tipo_servicio(rs.getInt("id_tipo_servicio"));
                tipo.setNombre(rs.getString("nombre_tipo"));

                ServiciosBean servicio = new ServiciosBean();

                servicio.setId_servicio(rs.getInt("id_servicio"));
                servicio.setTipoServicio(tipo);
                servicio.setNombre(rs.getString("nombre"));
                servicio.setDescripcion(rs.getString("descripcion"));
                servicio.setPrecio(rs.getDouble("precio"));
                servicio.setEstado(rs.getInt("estado"));
                servicio.setFechaRegistro(rs.getTimestamp("fecha_registro"));

                return servicio;
            }
        }

        return null;
    }

    /*
     * =====================================
     * ACTUALIZAR SERVICIO
     * =====================================
     */
    public boolean actualizar(ServiciosBean servicio) throws Exception {

        String sql = """
                UPDATE ADMIN.SERVICIOS
                SET
                    id_tipo_servicio=?,
                    nombre=?,
                    descripcion=?,
                    precio=?,
                    estado=?
                WHERE id_servicio=?
                """;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, servicio.getTipoServicio().getId_tipo_servicio());
            ps.setString(2, servicio.getNombre());
            ps.setString(3, servicio.getDescripcion());
            ps.setDouble(4, servicio.getPrecio());
            ps.setInt(5, servicio.getEstado());
            ps.setInt(6, servicio.getId_servicio());

            return ps.executeUpdate() > 0;
        }
    }

    /*
     * =====================================
     * CAMBIAR ESTADO
     * =====================================
     */
    public boolean actualizarEstado(int idServicio, int nuevoEstado) throws Exception {

        String sql = """
                UPDATE ADMIN.SERVICIOS
                SET estado=?
                WHERE id_servicio=?
                """;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, nuevoEstado);
            ps.setInt(2, idServicio);

            return ps.executeUpdate() > 0;
        }
    }

    /*
     * =====================================
     * ELIMINAR DEFINITIVAMENTE
     * =====================================
     */
    public boolean eliminar(int idServicio) throws Exception {

        String sql = """
                DELETE FROM ADMIN.SERVICIOS
                WHERE id_servicio=?
                """;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idServicio);

            return ps.executeUpdate() > 0;
        }
    }

}