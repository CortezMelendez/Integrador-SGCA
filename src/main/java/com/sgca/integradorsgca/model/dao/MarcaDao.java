package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.MarcaBean;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MarcaDao {

    //Consultar o listar todas las marcas
    public List<MarcaBean> listar() {
        List<MarcaBean> lista = new ArrayList();
        String sql = "SELECT id_marca, nombre, estado FROM ADMIN.MARCAS ORDER BY id_marca DESC";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MarcaBean marc = new MarcaBean();
                marc.setId_Marca(rs.getInt("id_marca"));
                marc.setNombre(rs.getString("nombre"));
                marc.setEstado(rs.getInt("estado"));
                lista.add(marc);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar las marcas: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    //Registrar nueva marca
    public boolean registrar(MarcaBean marc) {
        String sql = "INSERT INTO ADMIN.MARCAS (nombre, estado) VALUES (?, 1)";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, marc.getNombre());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar marca: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    //Modificar marca existente
    public boolean actualizar(MarcaBean m) {
        String sql = "UPDATE ADMIN.MARCAS SET nombre =?, estado =? WHERE id_marca =?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, m.getNombre());
            ps.setInt(2, m.getEstado());
            ps.setInt(3, m.getId_Marca());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar marca: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Busca una marca por nombre (sin distinguir mayúsculas/minúsculas)
    public MarcaBean buscarPorNombre(String nombre) {
        MarcaBean marca = null;
        String sql = "SELECT id_marca, nombre, estado FROM ADMIN.MARCAS WHERE UPPER(nombre) = UPPER(?)";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nombre);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    marca = new MarcaBean();
                    marca.setId_Marca(rs.getInt("id_marca"));
                    marca.setNombre(rs.getString("nombre"));
                    marca.setEstado(rs.getInt("estado"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar marca por nombre: " + e.getMessage());
        }
        return marca;
    }

    // Devuelve el ID de la marca; si no existe, la crea y devuelve el nuevo ID
    public int obtenerOCrearId(String nombre) {
        MarcaBean existente = buscarPorNombre(nombre);
        if (existente != null) return existente.getId_Marca();

        registrar(new MarcaBean(0, nombre, 1));

        MarcaBean creada = buscarPorNombre(nombre);
        return creada != null ? creada.getId_Marca() : -1;
    }

    public MarcaBean buscarPorId(int id) {
        MarcaBean marca = null;
        String sql = "SELECT id_marca, nombre, estado FROM ADMIN.MARCAS WHERE id_marca = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    marca = new MarcaBean();
                    marca.setId_Marca(rs.getInt("id_marca"));
                    marca.setNombre(rs.getString("nombre"));
                    marca.setEstado(rs.getInt("estado"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar marca por ID: " + e.getMessage());
        }
        return marca;
    }
}