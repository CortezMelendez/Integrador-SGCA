package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.TiposVehiculoBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

    public class TiposVehiculoDao {

        // Listar todos los tipos de vehículos para el menu
        public List<TiposVehiculoBean> listar() {
            List<TiposVehiculoBean> lista = new ArrayList<>();
            String sql = "SELECT ID_TIPO, NOMBRE FROM ADMIN.TIPOS_VEHICULO ORDER BY ID_TIPO DESC";

            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    TiposVehiculoBean tipo = new TiposVehiculoBean();
                    tipo.setIdTipo(rs.getInt("ID_TIPO"));
                    tipo.setNombre(rs.getString("NOMBRE"));
                    lista.add(tipo);
                }
            } catch (SQLException e) {
                System.err.println("Error al listar tipos de vehículo: " + e.getMessage());
            }
            return lista;
        }

        // Buscar tipo por ID
        public TiposVehiculoBean obtenerPorId(int idTipo) {
            String sql = "SELECT ID_TIPO, NOMBRE FROM ADMIN.TIPOS_VEHICULO WHERE ID_TIPO = ?";
            TiposVehiculoBean tipo = null;

            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, idTipo);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        tipo = new TiposVehiculoBean();
                        tipo.setIdTipo(rs.getInt("ID_TIPO"));
                        tipo.setNombre(rs.getString("NOMBRE"));
                    }
                }
            } catch (SQLException e) {
                System.err.println("Error al buscar tipo de vehículo: " + e.getMessage());
            }
            return tipo;
        }

        // Registrar nuevo tipo
        public void registrar(TiposVehiculoBean tipo) {
            String sql = "INSERT INTO ADMIN.TIPOS_VEHICULO (NOMBRE) VALUES (?)";

            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, tipo.getNombre());
                ps.executeUpdate();
            } catch (SQLException e) {
                System.err.println("Error al registrar tipo de vehículo: " + e.getMessage());
            }
        }

        // Actualizar tipo existente
        public void actualizar(TiposVehiculoBean tipo) {
            String sql = "UPDATE ADMIN.TIPOS_VEHICULO SET NOMBRE = ? WHERE ID_TIPO = ?";

            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, tipo.getNombre());
                ps.setInt(2, tipo.getIdTipo());
                ps.executeUpdate();
            } catch (SQLException e) {
                System.err.println("Error al actualizar tipo de vehículo: " + e.getMessage());
            }
        }

        // Eliminar tipo
        public void eliminar(int idTipo) {
            String sql = "DELETE FROM ADMIN.TIPOS_VEHICULO WHERE ID_TIPO = ?";

            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, idTipo);
                ps.executeUpdate();
            } catch (SQLException e) {
                System.err.println("Error al eliminar tipo de vehículo: " + e.getMessage());
            }
        }
    }
