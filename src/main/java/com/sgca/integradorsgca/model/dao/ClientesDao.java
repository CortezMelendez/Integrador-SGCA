package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.ClientesBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClientesDao {

    //lista general para mostrar al cliente
    public List<ClientesBean> listar() {
        List<ClientesBean> lista = new ArrayList<>();
        String sql = "SELECT c.ID_CLIENTE, c.ID_USUARIO, c.ID_AGENTE, c.FECHA_ALTA AS FECHA_REGISTRO, "
                + "(u.NOMBRE || ' ' || u.APELLIDO_PATERNO || ' ' || NVL(u.APELLIDO_MATERNO, '')) AS NOMBRE_CLIENTE, "
                + "u.CORREO AS CORREO_CLIENTE, "
                + "NVL((ua.NOMBRE || ' ' || ua.APELLIDO_PATERNO), 'Sin Agente Asignado') AS NOMBRE_AGENTE "
                + "FROM ADMIN.CLIENTES c "
                + "INNER JOIN ADMIN.USUARIOS u ON c.ID_USUARIO = u.ID_USUARIO "
                + "LEFT JOIN ADMIN.AGENTES a ON c.ID_AGENTE = a.ID_AGENTE "
                + "LEFT JOIN ADMIN.USUARIOS ua ON a.ID_USUARIO = ua.ID_USUARIO "
                + "ORDER BY c.ID_CLIENTE ASC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ClientesBean cliente = new ClientesBean();
                cliente.setIdCliente(rs.getInt("ID_CLIENTE"));
                cliente.setIdUsuario(rs.getInt("ID_USUARIO"));

                int idAgente = rs.getInt("ID_AGENTE");
                cliente.setIdAgente(rs.wasNull() ? null : idAgente);

                cliente.setFechaRegistro(rs.getTimestamp("FECHA_REGISTRO"));
                cliente.setNombreCliente(rs.getString("NOMBRE_CLIENTE"));
                cliente.setCorreoCliente(rs.getString("CORREO_CLIENTE"));
                cliente.setNombreAgente(rs.getString("NOMBRE_AGENTE"));

                lista.add(cliente);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar clientes: " + e.getMessage());
        }
        return lista;
    }


    // Resuelve el ID_CLIENTE a partir del ID_USUARIO de la sesión (usuario logueado con rol CLIENTE)
    public ClientesBean buscarPorIdUsuario(int idUsuario) {
        ClientesBean cliente = null;
        String sql = "SELECT c.ID_CLIENTE, c.ID_USUARIO, c.ID_AGENTE, c.FECHA_ALTA AS FECHA_REGISTRO "
                + "FROM ADMIN.CLIENTES c "
                + "WHERE c.ID_USUARIO = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cliente = new ClientesBean();
                    cliente.setIdCliente(rs.getInt("ID_CLIENTE"));
                    cliente.setIdUsuario(rs.getInt("ID_USUARIO"));

                    int idAgente = rs.getInt("ID_AGENTE");
                    cliente.setIdAgente(rs.wasNull() ? null : idAgente);

                    cliente.setFechaRegistro(rs.getTimestamp("FECHA_REGISTRO"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar cliente por id_usuario: " + e.getMessage());
        }
        return cliente;
    }

    public List<ClientesBean> listarClientesDisponibles() {
        List<ClientesBean> lista = new ArrayList<>();
        String sql = "SELECT c.ID_CLIENTE, c.ID_USUARIO, c.FECHA_ALTA AS FECHA_REGISTRO, "
                + "(u.NOMBRE || ' ' || u.APELLIDO_PATERNO || ' ' || NVL(u.APELLIDO_MATERNO, '')) AS NOMBRE_CLIENTE, "
                + "u.CORREO AS CORREO_CLIENTE "
                + "FROM ADMIN.CLIENTES c "
                + "INNER JOIN ADMIN.USUARIOS u ON c.ID_USUARIO = u.ID_USUARIO "
                + "WHERE c.ID_AGENTE IS NULL "
                + "ORDER BY c.ID_CLIENTE ASC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ClientesBean cliente = new ClientesBean();
                cliente.setIdCliente(rs.getInt("ID_CLIENTE"));
                cliente.setIdUsuario(rs.getInt("ID_USUARIO"));
                cliente.setIdAgente(null);
                cliente.setFechaRegistro(rs.getTimestamp("FECHA_REGISTRO"));
                cliente.setNombreCliente(rs.getString("NOMBRE_CLIENTE"));
                cliente.setCorreoCliente(rs.getString("CORREO_CLIENTE"));
                cliente.setNombreAgente("Sin Agente Asignado");

                lista.add(cliente);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar clientes disponibles: " + e.getMessage());
        }
        return lista;
    }

    /*
     Registra un nuevo cliente asociándolo a un ID_USUARIO.
     Puede recibir un ID_AGENTE o registrarse como nulo (disponible).
     */
    public boolean registrar(ClientesBean cliente) throws SQLException {
        String sql = "INSERT INTO ADMIN.CLIENTES (ID_USUARIO, ID_AGENTE, FECHA_ALTA) VALUES (?, ?, SYSDATE)";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cliente.getIdUsuario());

            if (cliente.getIdAgente() != null && cliente.getIdAgente() > 0) {
                ps.setInt(2, cliente.getIdAgente());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            // Se deja subir la excepción real para poder mostrarla en RegisterServlet
            // en vez de esconderla detrás de un simple "false"
            System.err.println("Error al registrar cliente: " + e.getMessage());
            throw e;
        }
    }

    /*
    Asigna o toma un cliente libre (actualiza su ID_AGENTE).
    */
    public boolean asignarAgente(int idCliente, int idAgente) {
        String sql = "UPDATE ADMIN.CLIENTES SET ID_AGENTE = ? WHERE ID_CLIENTE = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idAgente);
            ps.setInt(2, idCliente);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al asignar agente al cliente: " + e.getMessage());
            return false;
        }
    }
}