package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.MarcaBean;
import com.sgca.integradorsgca.model.bean.ModelosBean;
import com.sgca.integradorsgca.model.dao.Conexion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ModelosDao {

    public List<ModelosBean> listar() {
        List<ModelosBean> lista = new ArrayList<>();
        String sql = "SELECT M.ID_MODELO, M.ID_MARCA, M.NOMBRE AS NOMBRE_MODELO, M.ESTADO AS ESTADO_MODELO, "
                + "MA.NOMBRE AS NOMBRE_MARCA, MA.ESTADO AS ESTADO_MARCA "
                + "FROM ADMIN.MODELOS M "
                + "INNER JOIN ADMIN.MARCAS MA ON M.ID_MARCA = MA.ID_MARCA "
                + "ORDER BY M.ID_MODELO DESC";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearModelo(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error al listar modelos: " + e.getMessage());
        }

        return lista;
    }

    public ModelosBean buscarPorId(int id) {
        ModelosBean m = null;
        String sql = "SELECT M.ID_MODELO, M.ID_MARCA, M.NOMBRE AS NOMBRE_MODELO, M.ESTADO AS ESTADO_MODELO, "
                + "MA.NOMBRE AS NOMBRE_MARCA, MA.ESTADO AS ESTADO_MARCA "
                + "FROM ADMIN.MODELOS M "
                + "INNER JOIN ADMIN.MARCAS MA ON M.ID_MARCA = MA.ID_MARCA "
                + "WHERE M.ID_MODELO = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    m = mapearModelo(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar modelo por ID: " + e.getMessage());
        }

        return m;
    }

    // Busca un modelo por nombre dentro de una marca específica
    public ModelosBean buscarPorNombreYMarca(String nombre, int idMarca) {
        ModelosBean m = null;
        String sql = "SELECT M.ID_MODELO, M.ID_MARCA, M.NOMBRE AS NOMBRE_MODELO, M.ESTADO AS ESTADO_MODELO, "
                + "MA.NOMBRE AS NOMBRE_MARCA, MA.ESTADO AS ESTADO_MARCA "
                + "FROM ADMIN.MODELOS M "
                + "INNER JOIN ADMIN.MARCAS MA ON M.ID_MARCA = MA.ID_MARCA "
                + "WHERE UPPER(M.NOMBRE) = UPPER(?) AND M.ID_MARCA = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nombre);
            ps.setInt(2, idMarca);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    m = mapearModelo(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar modelo por nombre y marca: " + e.getMessage());
        }
        return m;
    }

    // Devuelve el ID del modelo; si no existe dentro de la marca, lo crea
    public int obtenerOCrearId(int idMarca, String nombre) {
        ModelosBean existente = buscarPorNombreYMarca(nombre, idMarca);
        if (existente != null) return existente.getId_Modelo();

        registrar(new ModelosBean(idMarca, nombre, 1));

        ModelosBean creado = buscarPorNombreYMarca(nombre, idMarca);
        return creado != null ? creado.getId_Modelo() : -1;
    }

    public void registrar(ModelosBean m) {
        String sql = "INSERT INTO ADMIN.MODELOS (ID_MARCA, NOMBRE, ESTADO) VALUES (?, ?, ?)";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, m.getId_Marca());
            ps.setString(2, m.getNombre());
            ps.setInt(3, m.getEstado());

            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error al registrar modelo: " + e.getMessage());
        }
    }

    public void actualizar(ModelosBean m) {
        String sql = "UPDATE ADMIN.MODELOS SET ID_MARCA = ?, NOMBRE = ?, ESTADO = ? "
                + "WHERE ID_MODELO = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, m.getId_Marca());
            ps.setString(2, m.getNombre());
            ps.setInt(3, m.getEstado());
            ps.setInt(4, m.getId_Modelo());

            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error al actualizar modelo: " + e.getMessage());
        }
    }

    public void eliminar(int id) {
        String sql = "DELETE FROM ADMIN.MODELOS WHERE ID_MODELO = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error al eliminar modelo: " + e.getMessage());
        }
    }

    private ModelosBean mapearModelo(ResultSet rs) throws SQLException {
        ModelosBean m = new ModelosBean();
        m.setId_Modelo(rs.getInt("ID_MODELO"));
        m.setId_Marca(rs.getInt("ID_MARCA"));
        m.setNombre(rs.getString("NOMBRE_MODELO"));
        m.setEstado(rs.getInt("ESTADO_MODELO"));

        // Se arma el objeto MarcaBean anidado
        MarcaBean marca = new MarcaBean();
        marca.setId_Marca(rs.getInt("ID_MARCA"));
        marca.setNombre(rs.getString("NOMBRE_MARCA"));
        marca.setEstado(rs.getInt("ESTADO_MARCA"));

        m.setMarca(marca);
        return m;
    }
}