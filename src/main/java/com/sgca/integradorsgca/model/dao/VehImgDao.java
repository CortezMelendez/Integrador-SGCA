package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.VehImgBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VehImgDao {

    // Listar todas las imágenes correspondientes a un vehículo específico
    public List<VehImgBean> listarPorVehiculo(int idVehiculo) {
        List<VehImgBean> lista = new ArrayList<>();
        String sql = "SELECT ID_IMAGEN, ID_VEHICULO, RUTA_IMAGEN "
                + "FROM ADMIN.VEHICULO_IMAGENES WHERE ID_VEHICULO = ? ORDER BY ID_IMAGEN ASC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idVehiculo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    VehImgBean img = new VehImgBean();
                    img.setIdImagen(rs.getInt("ID_IMAGEN"));
                    img.setIdVehiculo(rs.getInt("ID_VEHICULO"));
                    img.setRutaImagen(rs.getString("RUTA_IMAGEN"));
                    lista.add(img);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al listar imágenes del vehículo: " + e.getMessage());
        }
        return lista;
    }

    // Metodo para registrar o guardar la ruta de la imagen se asocia por ID
    public void registrar(VehImgBean img) {
        String sql = "INSERT INTO ADMIN.VEHICULO_IMAGENES (ID_VEHICULO, RUTA_IMAGEN) VALUES (?, ?)";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, img.getIdVehiculo());
            ps.setString(2, img.getRutaImagen());
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error al guardar imagen de vehículo: " + e.getMessage());
        }
    }

    // Metodo para que podamos eliminar una imagen
    public void eliminar(int idImagen) {
        String sql = "DELETE FROM ADMIN.VEHICULO_IMAGENES WHERE ID_IMAGEN = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idImagen);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error al eliminar imagen: " + e.getMessage());
        }
    }
}