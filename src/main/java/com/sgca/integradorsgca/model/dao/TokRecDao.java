package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.TokRecBean;

import java.sql.*;

public class TokRecDao {

    // Guardar un nuevo token generado
    public boolean guardarToken(TokRecBean tokenBean) {
        String sql = "INSERT INTO ADMIN.TOKENS_RECUPERACION (ID_USUARIO, TOKEN, EXPIRACION, USADO) VALUES (?, ?, ?, ?)";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, tokenBean.getIdUsuario());
            ps.setString(2, tokenBean.getToken());

            // Convertimos java.util.Date a java.sql.Timestamp para incluir horas y minutos
            ps.setTimestamp(3, new java.sql.Timestamp(tokenBean.getExpiracion().getTime()));
            ps.setInt(4, tokenBean.getUsado());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Buscar token activo por la cadena
    public TokRecBean obtenerToken(String token) {
        String sql = "SELECT * FROM ADMIN.TOKENS_RECUPERACION WHERE TOKEN = ?";
        TokRecBean tokenBean = null;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tokenBean = new TokRecBean();
                    tokenBean.setIdToken(rs.getInt("ID_TOKEN"));
                    tokenBean.setIdUsuario(rs.getInt("ID_USUARIO"));
                    tokenBean.setToken(rs.getString("TOKEN"));
                    tokenBean.setExpiracion(rs.getDate("EXPIRACION"));
                    tokenBean.setUsado(rs.getInt("USADO"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tokenBean;
    }

    //Se valida si el token se encuentra activo
    public TokRecBean validarTokenActivo(String token) {
        String sql = "SELECT * FROM ADMIN.TOKENS_RECUPERACION WHERE TOKEN = ? AND USADO = 0 AND EXPIRACION > SYSDATE";
        TokRecBean tokenBean = null;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tokenBean = new TokRecBean();
                    tokenBean.setIdToken(rs.getInt("ID_TOKEN"));
                    tokenBean.setIdUsuario(rs.getInt("ID_USUARIO"));
                    tokenBean.setToken(rs.getString("TOKEN"));
                    tokenBean.setExpiracion(rs.getTimestamp("EXPIRACION"));
                    tokenBean.setUsado(rs.getInt("USADO"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tokenBean;
    }

    // Marcamos token como usado después de cambiar la contraseña
    public boolean marcarComoUsado(int idToken) {
        String sql = "UPDATE ADMIN.TOKENS_RECUPERACION SET USADO = 1 WHERE ID_TOKEN = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idToken);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
