package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.MarcaBean;
import com.sgca.integradorsgca.model.bean.ModelosBean;
import com.sgca.integradorsgca.model.bean.TiposVehiculoBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VehiculosDao {

    public List<VehiculosBean> listar() {
        List<VehiculosBean> lista = new ArrayList<>();
        String sql = "SELECT "
                + "V.ID_VEHICULO, V.ID_MODELO, V.ID_TIPO, V.ID_AGENTE, "
                + "V.PLACA, V.COLOR, V.ANIO, V.PRECIO, V.DISPONIBLE, "
                + "V.FECHA_REGISTRO, V.FOTO_PORTADA, "
                + "M.NOMBRE AS NOMBRE_MODELO, M.ESTADO AS ESTADO_MODELO, "
                + "MA.ID_MARCA, MA.NOMBRE AS NOMBRE_MARCA, MA.ESTADO AS ESTADO_MARCA, "
                + "TV.NOMBRE AS NOMBRE_TIPO "
                + "FROM ADMIN.VEHICULOS V "
                + "INNER JOIN ADMIN.MODELOS M ON V.ID_MODELO = M.ID_MODELO "
                + "INNER JOIN ADMIN.MARCAS MA ON M.ID_MARCA = MA.ID_MARCA "
                + "INNER JOIN ADMIN.TIPOS_VEHICULO TV ON V.ID_TIPO = TV.ID_TIPO "
                + "ORDER BY V.ID_VEHICULO DESC";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearVehiculo(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error al listar vehículos: " + e.getMessage());
        }
        return lista;
    }

    public VehiculosBean buscarPorID(int id) {
        VehiculosBean veh = null;

        String sql = "SELECT "
                + "V.ID_VEHICULO, V.ID_MODELO, V.ID_TIPO, V.ID_AGENTE, "
                + "V.PLACA, V.COLOR, V.ANIO, V.PRECIO, V.DISPONIBLE, "
                + "V.FECHA_REGISTRO, V.FOTO_PORTADA, "
                + "M.NOMBRE AS NOMBRE_MODELO, M.ESTADO AS ESTADO_MODELO, "
                + "MA.ID_MARCA, MA.NOMBRE AS NOMBRE_MARCA, MA.ESTADO AS ESTADO_MARCA, "
                + "TV.NOMBRE AS NOMBRE_TIPO "
                + "FROM ADMIN.VEHICULOS V "
                + "INNER JOIN ADMIN.MODELOS M ON V.ID_MODELO = M.ID_MODELO "
                + "INNER JOIN ADMIN.MARCAS MA ON M.ID_MARCA = MA.ID_MARCA "
                + "INNER JOIN ADMIN.TIPOS_VEHICULO TV ON V.ID_TIPO = TV.ID_TIPO "
                + "WHERE V.ID_VEHICULO = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    veh = mapearVehiculo(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar vehiculo: " + e.getMessage());
        }
        return veh;
    }

    public void registrar(VehiculosBean veh) {
        String sql = "INSERT INTO ADMIN.VEHICULOS (ID_MODELO, ID_TIPO, ID_AGENTE, PLACA, COLOR, "
                + "ANIO, PRECIO, DISPONIBLE, FECHA_REGISTRO, FOTO_PORTADA) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, ?)";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, veh.getId_Modelo());
            ps.setInt(2, veh.getId_Tipo());
            ps.setInt(3, veh.getId_Agente());
            ps.setString(4, veh.getPlaca());
            ps.setString(5, veh.getColor());
            ps.setInt(6, veh.getAnio());
            ps.setBigDecimal(7, veh.getPrecio());
            ps.setInt(8, veh.getDisponible());
            ps.setString(9, veh.getFoto_Portada());

            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al registrar vehiculo: " + e.getMessage());
        }
    }

    public void actualizar(VehiculosBean veh) {
        String sql = "UPDATE ADMIN.VEHICULOS SET ID_MODELO = ?, ID_TIPO = ?, ID_AGENTE = ?, "
                + "PLACA = ?, COLOR = ?, ANIO = ?, PRECIO = ?, DISPONIBLE = ?, FOTO_PORTADA = ? "
                + "WHERE ID_VEHICULO = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, veh.getId_Modelo());
            ps.setInt(2, veh.getId_Tipo());
            ps.setInt(3, veh.getId_Agente());
            ps.setString(4, veh.getPlaca());
            ps.setString(5, veh.getColor());
            ps.setInt(6, veh.getAnio());
            ps.setBigDecimal(7, veh.getPrecio());
            ps.setInt(8, veh.getDisponible());
            ps.setString(9, veh.getFoto_Portada());
            ps.setInt(10, veh.getId_Vehiculo());

            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al actualizar vehiculo: " + e.getMessage());
        }
    }

    public void eliminar(int id) {
        String sql = "DELETE FROM ADMIN.VEHICULOS WHERE ID_VEHICULO = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error al eliminar vehículo: " + e.getMessage());
        }
    }

    private VehiculosBean mapearVehiculo(ResultSet rs) throws SQLException {
        VehiculosBean v = new VehiculosBean();
        v.setId_Vehiculo(rs.getInt("ID_VEHICULO"));
        v.setId_Modelo(rs.getInt("ID_MODELO"));
        v.setId_Tipo(rs.getInt("ID_TIPO"));
        v.setId_Agente(rs.getInt("ID_AGENTE"));
        v.setPlaca(rs.getString("PLACA"));
        v.setColor(rs.getString("COLOR"));
        v.setAnio(rs.getInt("ANIO"));
        v.setPrecio(rs.getBigDecimal("PRECIO"));
        v.setDisponible(rs.getInt("DISPONIBLE"));
        v.setFecha_registro(rs.getDate("FECHA_REGISTRO"));
        v.setFoto_Portada(rs.getString("FOTO_PORTADA"));

        // Datos de Marcas
        MarcaBean marca = new MarcaBean();
        marca.setId_Marca(rs.getInt("ID_MARCA"));
        marca.setNombre(rs.getString("NOMBRE_MARCA"));
        marca.setEstado(rs.getInt("ESTADO_MARCA"));

        // Datos de Modelos
        ModelosBean modelo = new ModelosBean();
        modelo.setId_Modelo(rs.getInt("ID_MODELO"));
        modelo.setNombre(rs.getString("NOMBRE_MODELO"));
        modelo.setMarca(marca);
        modelo.setEstado(rs.getInt("ESTADO_MODELO"));

        // Datos de TiposVehiculo
        TiposVehiculoBean tipo = new TiposVehiculoBean();
        tipo.setIdTipo(rs.getInt("ID_TIPO"));
        tipo.setNombre(rs.getString("NOMBRE_TIPO"));

        // Inyección de objetos anidados
        v.setModelos(modelo);
        v.setMarca(marca);
        v.setTipoVehiculo(tipo);

        return v;
    }
}


