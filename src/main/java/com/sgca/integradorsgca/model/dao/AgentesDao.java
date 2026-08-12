package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.AgentesBean;
import com.sgca.integradorsgca.model.bean.ClientesBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AgentesDao {

    public List<AgentesBean> listar() {
        List<AgentesBean> lista = new ArrayList<>();
        String sql = "SELECT a.ID_AGENTE, a.ID_USUARIO, a.FECHA_INGRESO, a.ESTADO, "
                + "(u.NOMBRE || ' ' || u.APELLIDO_PATERNO || ' ' || NVL(u.APELLIDO_MATERNO, '')) AS NOMBRE_COMPLETO, "
                + "u.CORREO "
                + "FROM ADMIN.AGENTES a "
                + "INNER JOIN ADMIN.USUARIOS u ON a.ID_USUARIO = u.ID_USUARIO "
                + "ORDER BY a.ID_AGENTE ASC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AgentesBean agente = new AgentesBean(
                        rs.getInt("ID_AGENTE"),
                        rs.getInt("ID_USUARIO"),
                        rs.getTimestamp("FECHA_INGRESO"),
                        rs.getInt("ESTADO"),
                        rs.getString("NOMBRE_COMPLETO"),
                        rs.getString("CORREO")
                );
                lista.add(agente);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar agentes: " + e.getMessage());
        }
        return lista;
    }

    public boolean registrar(AgentesBean agente) throws SQLException {
        String sql = "INSERT INTO ADMIN.AGENTES (ID_USUARIO, FECHA_INGRESO, ESTADO) VALUES (?, SYSDATE, ?)";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, agente.getIdUsuario());
            ps.setInt(2, agente.getEstado() != 0 ? agente.getEstado() : 1);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            // Se deja subir la excepción real para que el caller pueda distinguir
            // este fallo del resto (en vez de esconderla detrás de un simple "false")
            System.err.println("Error al registrar agente: " + e.getMessage());
            throw e;
        }
    }


    /*  Reasignación manual por el Dueño/Admin:
     El dueño selecciona un cliente (o usuario) y le asigna un agente en específico.  */

    public boolean reasignarAgenteACliente(int idCliente, int idNuevoAgente) {
        String sql = "UPDATE ADMIN.CLIENTES SET ID_AGENTE = ? WHERE ID_CLIENTE = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idNuevoAgente);
            ps.setInt(2, idCliente);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al reasignar el agente al cliente: " + e.getMessage());
            return false;
        }
    }

    // Quita el agente asignado a un cliente (queda libre para todos los agentes activos)
    public boolean liberarCliente(int idCliente) {
        String sql = "UPDATE ADMIN.CLIENTES SET ID_AGENTE = NULL WHERE ID_CLIENTE = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCliente);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al liberar al cliente: " + e.getMessage());
            return false;
        }
    }

    // Cuenta cuántos clientes tiene asignados un agente, dado su ID_USUARIO
    public int contarClientesAsignados(int idUsuarioAgente) {
        String sql = "SELECT COUNT(*) AS total FROM ADMIN.CLIENTES c " +
                "INNER JOIN ADMIN.AGENTES a ON c.ID_AGENTE = a.ID_AGENTE " +
                "WHERE a.ID_USUARIO = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuarioAgente);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Error al contar clientes del agente: " + e.getMessage());
        }
        return 0;
    }

    // Lista con el detalle (nombre y correo) de los clientes asignados a un agente,
    // dado su ID_USUARIO. Se usa en el modal "Ver clientes" de gestionEmpleados.jsp.
    public List<ClientesBean> listarClientesAsignados(int idUsuarioAgente) {
        List<ClientesBean> lista = new ArrayList<>();
        String sql = "SELECT c.ID_CLIENTE, c.ID_USUARIO, " +
                "(u.NOMBRE || ' ' || u.APELLIDO_PATERNO || ' ' || NVL(u.APELLIDO_MATERNO, '')) AS NOMBRE_CLIENTE, " +
                "u.CORREO AS CORREO_CLIENTE " +
                "FROM ADMIN.CLIENTES c " +
                "INNER JOIN ADMIN.AGENTES a ON c.ID_AGENTE = a.ID_AGENTE " +
                "INNER JOIN ADMIN.USUARIOS u ON c.ID_USUARIO = u.ID_USUARIO " +
                "WHERE a.ID_USUARIO = ? " +
                "ORDER BY NOMBRE_CLIENTE ASC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuarioAgente);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ClientesBean cliente = new ClientesBean();
                    cliente.setIdCliente(rs.getInt("ID_CLIENTE"));
                    cliente.setIdUsuario(rs.getInt("ID_USUARIO"));
                    cliente.setNombreCliente(rs.getString("NOMBRE_CLIENTE"));
                    cliente.setCorreoCliente(rs.getString("CORREO_CLIENTE"));
                    lista.add(cliente);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al listar clientes del agente: " + e.getMessage());
        }
        return lista;
    }

    /*
      Da de baja a un agente que NO tiene clientes asignados: desactiva su
      cuenta (ADMIN.USUARIOS) y su registro de agente (ADMIN.AGENTES) en una
      sola transacción. No debe usarse si el agente tiene clientes activos;
      para ese caso usar darDeBajaConTransferencia.
     */
    public boolean bajaAgente(int idUsuarioAgente) {
        String sqlAgente = "UPDATE ADMIN.AGENTES SET ESTADO = 0 WHERE ID_USUARIO = ?";
        String sqlUsuario = "UPDATE ADMIN.USUARIOS SET ESTADO = 0 WHERE ID_USUARIO = ?";

        Connection con = null;
        try {
            con = Conexion.getConexion();
            con.setAutoCommit(false);

            try (PreparedStatement ps1 = con.prepareStatement(sqlAgente)) {
                ps1.setInt(1, idUsuarioAgente);
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = con.prepareStatement(sqlUsuario)) {
                ps2.setInt(1, idUsuarioAgente);
                ps2.executeUpdate();
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            System.err.println("Error al dar de baja al agente: " + e.getMessage());
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    /*
      Transfiere todos los clientes de un agente a otro agente activo y, solo
      si la transferencia se aplica correctamente, da de baja al agente de
      origen (ADMIN.AGENTES y ADMIN.USUARIOS). Ambos agentes se identifican
      por su ID_USUARIO. Todo ocurre en una sola transacción: si algo falla,
      no queda ni la transferencia ni la baja a medias.
     */
    public boolean darDeBajaConTransferencia(int idUsuarioAgente, int idUsuarioReceptor) {
        String sqlTransferir =
                "UPDATE ADMIN.CLIENTES SET ID_AGENTE = (SELECT ID_AGENTE FROM ADMIN.AGENTES WHERE ID_USUARIO = ?) " +
                        "WHERE ID_AGENTE = (SELECT ID_AGENTE FROM ADMIN.AGENTES WHERE ID_USUARIO = ?)";
        String sqlAgente = "UPDATE ADMIN.AGENTES SET ESTADO = 0 WHERE ID_USUARIO = ?";
        String sqlUsuario = "UPDATE ADMIN.USUARIOS SET ESTADO = 0 WHERE ID_USUARIO = ?";

        Connection con = null;
        try {
            con = Conexion.getConexion();
            con.setAutoCommit(false);

            try (PreparedStatement ps1 = con.prepareStatement(sqlTransferir)) {
                ps1.setInt(1, idUsuarioReceptor);
                ps1.setInt(2, idUsuarioAgente);
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = con.prepareStatement(sqlAgente)) {
                ps2.setInt(1, idUsuarioAgente);
                ps2.executeUpdate();
            }
            try (PreparedStatement ps3 = con.prepareStatement(sqlUsuario)) {
                ps3.setInt(1, idUsuarioAgente);
                ps3.executeUpdate();
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            System.err.println("Error al transferir clientes y dar de baja al agente: " + e.getMessage());
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    /*
      Al cambiar el estado a 0, liberamos a sus clientes asignados para que
      queden disponibles ante todos los demás agentes activos del sistema (ID_AGENTE = NULL).
     */
    public boolean darDeBajaAgente(int idAgente) {
        String sqlLiberarClientes = "UPDATE ADMIN.CLIENTES SET ID_AGENTE = NULL WHERE ID_AGENTE = ?";
        String sqlBajaAgente = "UPDATE ADMIN.AGENTES SET ESTADO = 0 WHERE ID_AGENTE = ?";

        Connection con = null;
        try {
            con = Conexion.getConexion();
            con.setAutoCommit(false);

            //Desvinculamos a sus clientes para que queden abiertos a todos los agentes activos
            try (PreparedStatement ps1 = con.prepareStatement(sqlLiberarClientes)) {
                ps1.setInt(1, idAgente);
                ps1.executeUpdate();
            }

            //Cambiamos el estado del agente a 0 (Inactivo)
            try (PreparedStatement ps2 = con.prepareStatement(sqlBajaAgente)) {
                ps2.setInt(1, idAgente);
                ps2.executeUpdate();
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            System.err.println("Error al dar de baja al agente: " + e.getMessage());
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }
}