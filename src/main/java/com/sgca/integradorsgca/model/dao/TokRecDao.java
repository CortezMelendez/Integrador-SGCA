package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.TokRecBean;

import java.sql.*;

public class TokRecDao {

    // Guardar un nuevo token generado
    public boolean guardarToken(TokRecBean tokenBean) throws SQLException {
        // La expiración se calcula con la hora del propio servidor de Oracle (SYSDATE),
        // no con la hora local de la app, para que coincida con el SYSDATE que se usa
        // después en validarTokenActivo() y no expire de inmediato por diferencia de huso horario.
        String sql = "INSERT INTO ADMIN.TOKENS_RECUPERACION (ID_USUARIO, TOKEN, EXPIRACION, USADO) "
                + "VALUES (?, ?, SYSDATE + INTERVAL '5' MINUTE, ?)";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, tokenBean.getIdUsuario());
            ps.setString(2, tokenBean.getToken());
            ps.setInt(3, tokenBean.getUsado());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Se deja subir la excepción real para poder mostrarla en EmailService
            // en vez de esconderla detrás de un simple "false"
            e.printStackTrace();
            throw e;
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
