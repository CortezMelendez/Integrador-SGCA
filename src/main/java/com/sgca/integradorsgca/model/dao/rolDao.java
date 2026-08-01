package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.rolBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class rolDao {

    //Metodo para registrar un rol

    public boolean registrar(rolBean rol) throws Exception {
        String sql = "INSERT INTO roles (nombre, descripcion, estado) VALUES (?, ?, ?)";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rol.getRol());
            ps.setString(2, rol.getDescripcion());
            ps.setInt(3, rol.getEstado() != 0 ? rol.getEstado() : 1);

            return ps.executeUpdate() > 0;
        }
    }

    //Metodo para listar los roles
    public List<rolBean> listar() throws Exception {
        List<rolBean> lista = new ArrayList<>();
        String sql = "SELECT id_rol, nombre, descripcion, estado FROM roles ORDER BY id_rol ASC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                rolBean rol = new rolBean();
                rol.setId_Rol(rs.getInt("id_rol"));
                rol.setRol(rs.getString("nombre"));
                rol.setDescripcion(rs.getString("descripcion"));
                rol.setEstado(rs.getInt("estado")); // Importante: usar getInt por el tipo numérico

                lista.add(rol);
            }
        }
        return lista;
    }
}
