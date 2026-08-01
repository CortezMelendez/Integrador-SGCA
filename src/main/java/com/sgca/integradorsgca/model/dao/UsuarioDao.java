package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.dao.Conexion;
import com.sgca.integradorsgca.model.bean.rolBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDao {

    public boolean registrar(UsuarioBean usuario) throws Exception {
        String sql = "INSERT INTO usuarios (id_rol, nombre, apellido_paterno, apellido_materno, " +
                "rfc, curp, correo, telefono, password, estado, fecha_registro) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE)";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuario.getRol().getId_Rol());
            ps.setString(2, usuario.getNombre());
            ps.setString(3, usuario.getApellidoPaterno());
            ps.setString(4, usuario.getApellidoMaterno());
            ps.setString(5, usuario.getRfc());
            ps.setString(6, usuario.getCurp());
            ps.setString(7, usuario.getCorreo());
            ps.setString(8, usuario.getTelefono());
            ps.setString(9, usuario.getPassword());
            ps.setInt(10, usuario.getEstado() != 0 ? usuario.getEstado() : 1);

            return ps.executeUpdate() > 0;
        }
    }

    public List<UsuarioBean> listar() throws Exception {
        List<UsuarioBean> lista = new ArrayList<>();
        String sql = "SELECT u.id_usuario, u.id_rol, r.nombre AS nombre_rol, u.nombre, " +
                "u.apellido_paterno, u.apellido_materno, u.rfc, u.curp, u.correo, " +
                "u.telefono, u.password, u.estado, u.fecha_registro " +
                "FROM usuarios u " +
                "INNER JOIN roles r ON u.id_rol = r.id_rol " +
                "ORDER BY u.id_usuario ASC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                rolBean rol = new rolBean();
                rol.setId_Rol(rs.getInt("id_rol"));
                rol.setRol(rs.getString("nombre_rol"));

                UsuarioBean usuario = new UsuarioBean(
                        rs.getInt("id_usuario"),
                        rol,
                        rs.getString("nombre"),
                        rs.getString("apellido_paterno"),
                        rs.getString("apellido_materno"),
                        rs.getString("rfc"),
                        rs.getString("curp"),
                        rs.getString("correo"),
                        rs.getString("telefono"),
                        rs.getString("password"),
                        rs.getInt("estado"),
                        rs.getTimestamp("fecha_registro"));
                lista.add(usuario);
            }
        }
        return lista;
    }

    public int contarUsuariosPorRol(String nombreRol) throws Exception {
        String sql = "SELECT COUNT(*) FROM usuarios u " +
                "INNER JOIN roles r ON u.id_rol = r.id_rol " +
                "WHERE UPPER(r.nombre) = UPPER(?) AND u.estado = 1";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nombreRol);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Comprueba si el correo existe y si la cuenta está activa.
     */
    public boolean existeCorreo(String correo) throws Exception {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE LOWER(correo) = LOWER(?) AND estado = 1";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Retorna el objeto completo del usuario activo para obtener su ID y Nombre.
     */
    public UsuarioBean obtenerPorCorreo(String correo) throws Exception {
        String sql = "SELECT u.id_usuario, u.id_rol, r.nombre AS nombre_rol, u.nombre, " +
                "u.apellido_paterno, u.apellido_materno, u.rfc, u.curp, u.correo, " +
                "u.telefono, u.password, u.estado, u.fecha_registro " +
                "FROM usuarios u " +
                "INNER JOIN roles r ON u.id_rol = r.id_rol " +
                "WHERE LOWER(u.correo) = LOWER(?) AND u.estado = 1";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    rolBean rol = new rolBean();
                    rol.setId_Rol(rs.getInt("id_rol"));
                    rol.setRol(rs.getString("nombre_rol"));

                    return new UsuarioBean(
                            rs.getInt("id_usuario"),
                            rol,
                            rs.getString("nombre"),
                            rs.getString("apellido_paterno"),
                            rs.getString("apellido_materno"),
                            rs.getString("rfc"),
                            rs.getString("curp"),
                            rs.getString("correo"),
                            rs.getString("telefono"),
                            rs.getString("password"),
                            rs.getInt("estado"),
                            rs.getTimestamp("fecha_registro"));
                }
            }
        }
        return null;
    }

    public boolean actualizarPassword(int idUsuario, String nuevoPassword) throws Exception {
        String sql = "UPDATE usuarios SET password = ? WHERE id_usuario = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nuevoPassword);
            ps.setInt(2, idUsuario);

            return ps.executeUpdate() > 0;
        }
    }
}