package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.TiposServicioBean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TiposServicioDao {

    public List<TiposServicioBean> listar() throws Exception {
        List<TiposServicioBean> lista = new ArrayList<>();
        String sql = "SELECT id_tipo_servicio, nombre FROM ADMIN.TIPOS_SERVICIO ORDER BY id_tipo_servicio ASC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(new TiposServicioBean(
                        rs.getInt("id_tipo_servicio"),
                        rs.getString("nombre")
                ));
            }
        }
        return lista;
    }

    public boolean insertar(TiposServicioBean tipo) throws Exception {
        String sql = "INSERT INTO ADMIN.TIPOS_SERVICIO (nombre) VALUES (?)";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tipo.getNombre());
            return ps.executeUpdate() > 0;
        }
    }
}