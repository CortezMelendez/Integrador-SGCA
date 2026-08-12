package com.sgca.integradorsgca.model.dao;

import com.sgca.integradorsgca.model.bean.MarcaBean;
import com.sgca.integradorsgca.model.bean.ModelosBean;
import com.sgca.integradorsgca.model.bean.TiposVehiculoBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class VehiculosDao {

    public List<VehiculosBean> listar() {
        List<VehiculosBean> lista = new ArrayList<>();
        String sql = "SELECT "
                + "V.ID_VEHICULO, V.ID_MODELO, V.ID_TIPO, V.ID_AGENTE, "
                + "V.PLACA, V.COLOR, V.ANIO, V.PRECIO, V.DISPONIBLE, "
                + "V.FECHA_REGISTRO, V.FOTO_PORTADA, V.DESCRIPCION_GENERAL, "
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
                + "V.FECHA_REGISTRO, V.FOTO_PORTADA, V.DESCRIPCION_GENERAL, "
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

    // Devuelve el ID_VEHICULO generado (0 si falló), para poder asociarle
    // de inmediato las imágenes adicionales en ADMIN.VEHICULO_IMAGENES.
    public int registrar(VehiculosBean veh) {
        String sql = "INSERT INTO ADMIN.VEHICULOS (ID_MODELO, ID_TIPO, ID_AGENTE, PLACA, COLOR, "
                + "ANIO, PRECIO, DISPONIBLE, FECHA_REGISTRO, FOTO_PORTADA, DESCRIPCION_GENERAL) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, ?, ?)";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, veh.getId_Modelo());
            ps.setInt(2, veh.getId_Tipo());
            ps.setInt(3, veh.getId_Agente());
            ps.setString(4, veh.getPlaca());
            ps.setString(5, veh.getColor());
            ps.setInt(6, veh.getAnio());
            ps.setBigDecimal(7, veh.getPrecio());
            ps.setInt(8, veh.getDisponible());
            ps.setString(9, veh.getFoto_Portada());
            ps.setString(10, veh.getDescripcion());

            ps.executeUpdate();

            try (ResultSet rsKeys = ps.getGeneratedKeys()) {
                if (rsKeys.next()) {
                    return rsKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al registrar vehiculo: " + e.getMessage());
        }
        return 0;
    }

    public void actualizar(VehiculosBean veh) {
        String sql = "UPDATE ADMIN.VEHICULOS SET ID_MODELO = ?, ID_TIPO = ?, ID_AGENTE = ?, "
                + "PLACA = ?, COLOR = ?, ANIO = ?, PRECIO = ?, DISPONIBLE = ?, FOTO_PORTADA = ?, DESCRIPCION_GENERAL = ? "
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
            ps.setString(10, veh.getDescripcion());
            ps.setInt(11, veh.getId_Vehiculo());

            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al actualizar vehiculo: " + e.getMessage());
        }
    }

    // Cambia únicamente el estado Activo(1)/Inactivo(0) de un vehículo
    public void cambiarEstado(int idVehiculo, int disponible) {
        String sql = "UPDATE ADMIN.VEHICULOS SET DISPONIBLE = ? WHERE ID_VEHICULO = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, disponible);
            ps.setInt(2, idVehiculo);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al cambiar estado del vehículo: " + e.getMessage());
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
        v.setDescripcion(rs.getString("DESCRIPCION_GENERAL"));

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
    public List<VehiculosBean> listarDisponibles() {

        List<VehiculosBean> lista = new ArrayList<>();

        String sql =
                "SELECT "
                        + "V.ID_VEHICULO, V.ID_MODELO, V.ID_TIPO, V.ID_AGENTE,"
                        + "V.PLACA, V.COLOR, V.ANIO, V.PRECIO,"
                        + "V.DISPONIBLE, V.FECHA_REGISTRO,"
                        + "V.FOTO_PORTADA, V.DESCRIPCION_GENERAL,"
                        + "M.NOMBRE NOMBRE_MODELO,"
                        + "M.ESTADO ESTADO_MODELO,"
                        + "MA.ID_MARCA,"
                        + "MA.NOMBRE NOMBRE_MARCA,"
                        + "MA.ESTADO ESTADO_MARCA,"
                        + "TV.NOMBRE NOMBRE_TIPO "
                        + "FROM ADMIN.VEHICULOS V "
                        + "INNER JOIN ADMIN.MODELOS M ON V.ID_MODELO=M.ID_MODELO "
                        + "INNER JOIN ADMIN.MARCAS MA ON M.ID_MARCA=MA.ID_MARCA "
                        + "INNER JOIN ADMIN.TIPOS_VEHICULO TV ON V.ID_TIPO=TV.ID_TIPO "
                        + "WHERE V.DISPONIBLE=1 "
                        + "ORDER BY V.ID_VEHICULO DESC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            System.out.println("Ejecutando consulta de vehículos...");

            while (rs.next()) {
                System.out.println("Vehículo encontrado: " +
                        rs.getInt("ID_VEHICULO"));

                lista.add(mapearVehiculo(rs));
            }
            System.out.println("Total en DAO: " + lista.size());

        } catch (SQLException e) {
            System.err.println("Error al listar vehículos disponibles: " + e.getMessage());
        }

        return lista;

    }

    // Catálogo del cliente: trae los vehículos disponibles, permite filtrar por tipo
    // y por un texto de búsqueda libre (marca, modelo, año o precio), y ordena según
    // lo que pida el cliente. Tanto el tipo como el texto de búsqueda van siempre
    // parametrizados, nunca concatenados directo al SQL.
    public List<VehiculosBean> listarClientePorTipo(String tipo, String buscar, String orden) {
        List<VehiculosBean> lista = new ArrayList<>();
        List<String> parametros = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT "
                        + "V.ID_VEHICULO, V.ID_MODELO, V.ID_TIPO, V.ID_AGENTE, "
                        + "V.PLACA, V.COLOR, V.ANIO, V.PRECIO, V.DISPONIBLE, V.FECHA_REGISTRO, V.FOTO_PORTADA, V.DESCRIPCION_GENERAL, "
                        + "M.NOMBRE NOMBRE_MODELO, M.ESTADO ESTADO_MODELO, "
                        + "MA.ID_MARCA, MA.NOMBRE NOMBRE_MARCA, MA.ESTADO ESTADO_MARCA, "
                        + "TV.NOMBRE NOMBRE_TIPO "
                        + "FROM ADMIN.VEHICULOS V "
                        + "INNER JOIN ADMIN.MODELOS M ON V.ID_MODELO = M.ID_MODELO "
                        + "INNER JOIN ADMIN.MARCAS MA ON M.ID_MARCA = MA.ID_MARCA "
                        + "INNER JOIN ADMIN.TIPOS_VEHICULO TV ON V.ID_TIPO = TV.ID_TIPO "
                        + "WHERE V.DISPONIBLE = 1 "
        );

        if (tipo != null && !tipo.isBlank()) {
            sql.append("AND UPPER(TV.NOMBRE) = UPPER(?) ");
            parametros.add(tipo);
        }

        // El mismo texto se busca a la vez en marca, modelo, el nombre combinado, año y precio
        if (buscar != null && !buscar.isBlank()) {
            sql.append(
                    "AND (UPPER(MA.NOMBRE) LIKE UPPER(?) ESCAPE '\\' "
                            + "OR UPPER(M.NOMBRE) LIKE UPPER(?) ESCAPE '\\' "
                            + "OR UPPER(MA.NOMBRE || ' ' || M.NOMBRE) LIKE UPPER(?) ESCAPE '\\' "
                            + "OR TO_CHAR(V.ANIO) LIKE ? ESCAPE '\\' "
                            + "OR TO_CHAR(V.PRECIO) LIKE ? ESCAPE '\\') "
            );
            String comodin = "%" + escaparComodinesLike(buscar.trim()) + "%";
            for (int i = 0; i < 5; i++) {
                parametros.add(comodin);
            }
        }

        // "Recién agregados" no solo ordena, también limita a los últimos 7 días
        if ("recientes".equals(orden)) {
            sql.append("AND V.FECHA_REGISTRO >= (SYSDATE - 7) ");
        }

        sql.append(construirOrderBy(orden));

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < parametros.size(); i++) {
                ps.setString(i + 1, parametros.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearVehiculo(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al listar catálogo de cliente: " + e.getMessage());
        }

        return lista;
    }

    // El orden que se aplica siempre sale de esta lista fija de opciones, nunca de lo
    // que mande el usuario directo al SQL.
    private String construirOrderBy(String orden) {
        if (orden == null) {
            return "ORDER BY V.ID_VEHICULO DESC";
        }

        switch (orden) {
            case "precio_desc":
                return "ORDER BY V.PRECIO DESC";
            case "precio_asc":
                return "ORDER BY V.PRECIO ASC";
            case "az":
                return "ORDER BY MA.NOMBRE ASC, M.NOMBRE ASC";
            case "recientes":
                return "ORDER BY V.FECHA_REGISTRO DESC";
            default:
                return "ORDER BY V.ID_VEHICULO DESC";
        }
    }

    //sirve para evitar que ciertos caracteres que tienen un significado especial en SQL LIKE sean interpretados como comodines.
    //Es decir seran interpretados como caracteres normales
    private String escaparComodinesLike(String valor) {
        return valor
                .replace("\\", "\\\\")
                .replace("%", "\\%")
                .replace("_", "\\_");
    }
}