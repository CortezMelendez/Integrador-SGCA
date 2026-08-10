    package com.sgca.integradorsgca.model.dao;
    
    import com.sgca.integradorsgca.model.bean.rolBean;
    import com.sgca.integradorsgca.model.bean.UsuarioBean;
    import com.sgca.integradorsgca.utils.PasswordUtils;
    
    import java.sql.Connection;
    import java.sql.PreparedStatement;
    import java.sql.ResultSet;
    import java.sql.SQLException;
    import java.util.ArrayList;
    import java.util.List;
    
    public class UsuarioDao {


    
        public boolean registrar(UsuarioBean usuario) throws Exception {
            String sql = "INSERT INTO ADMIN.USUARIOS (id_rol, nombre, apellido_paterno, apellido_materno, " +
                    "rfc, curp, correo, telefono, password, estado, fecha_registro) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE)";
    
            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {
    
                ps.setInt(1, usuario.getRol().getId_Rol());
                ps.setString(2, usuario.getNombre());
                ps.setString(3, usuario.getApellidoPaterno());
                ps.setString(4, usuario.getApellidoMaterno());
                ps.setString(5, usuario.getRfc());
                ps.setString(6, usuario.getCurp());
                ps.setString(7, usuario.getCorreo());
                ps.setString(8, usuario.getTelefono());
                ps.setString(9, usuario.getPassword());
                ps.setInt(10, usuario.getEstado() != 0 ? usuario.getEstado() : 1);
    
                return ps.executeUpdate() > 0;
            }
        }
    
        public List<UsuarioBean> listar() throws Exception {
            List<UsuarioBean> lista = new ArrayList<>();
            String sql = "SELECT u.id_usuario, u.id_rol, r.nombre AS nombre_rol, u.nombre, " +
                    "u.apellido_paterno, u.apellido_materno, u.rfc, u.curp, u.correo, " +
                    "u.telefono, u.password, u.estado, u.fecha_registro " +
                    "FROM ADMIN.USUARIOS u " +
                    "INNER JOIN ADMIN.ROLES r ON u.id_rol = r.id_rol " +
                    "ORDER BY u.id_usuario ASC";

            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
    
                while (rs.next()) {
                    rolBean rol = new rolBean();
                    rol.setId_Rol(rs.getInt("id_rol"));
                    rol.setRol(rs.getString("nombre_rol"));
    
                    UsuarioBean usuario = new UsuarioBean(
                            rs.getInt("id_usuario"),
                            rol,
                            rs.getString("nombre"),
                            rs.getString("apellido_paterno"),
                            rs.getString("apellido_materno"),
                            rs.getString("rfc"),
                            rs.getString("curp"),
                            rs.getString("correo"),
                            rs.getString("telefono"),
                            rs.getString("password"),
                            rs.getInt("estado"),
                            rs.getTimestamp("fecha_registro"));
                    lista.add(usuario);
                }
            }
            return lista;
        }
    
        // Lista los usuarios de un rol especifico (ej. 2 = Agente/Empleado, 3 = Cliente)
        public List<UsuarioBean> listarPorRol(int idRol) throws Exception {
            List<UsuarioBean> lista = new ArrayList<>();
            String sql = "SELECT u.id_usuario, u.id_rol, r.nombre AS nombre_rol, u.nombre, " +
                    "u.apellido_paterno, u.apellido_materno, u.rfc, u.curp, u.correo, " +
                    "u.telefono, u.password, u.estado, u.fecha_registro " +
                    "FROM ADMIN.USUARIOS u " +
                    "INNER JOIN ADMIN.ROLES r ON u.id_rol = r.id_rol " +
                    "WHERE u.id_rol = ? " +
                    "ORDER BY u.id_usuario ASC";

            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, idRol);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        rolBean rol = new rolBean();
                        rol.setId_Rol(rs.getInt("id_rol"));
                        rol.setRol(rs.getString("nombre_rol"));

                        UsuarioBean usuario = new UsuarioBean(
                                rs.getInt("id_usuario"),
                                rol,
                                rs.getString("nombre"),
                                rs.getString("apellido_paterno"),
                                rs.getString("apellido_materno"),
                                rs.getString("rfc"),
                                rs.getString("curp"),
                                rs.getString("correo"),
                                rs.getString("telefono"),
                                rs.getString("password"),
                                rs.getInt("estado"),
                                rs.getTimestamp("fecha_registro"));
                        lista.add(usuario);
                    }
                }
            }
            return lista;
        }

        // Actualiza los datos editables de un usuario (no toca password ni fecha_registro)
        public boolean actualizar(UsuarioBean usuario) throws Exception {
            String sql = "UPDATE ADMIN.USUARIOS SET nombre = ?, apellido_paterno = ?, apellido_materno = ?, " +
                    "rfc = ?, curp = ?, correo = ?, telefono = ?, estado = ? WHERE id_usuario = ?";

            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, usuario.getNombre());
                ps.setString(2, usuario.getApellidoPaterno());
                ps.setString(3, usuario.getApellidoMaterno());
                ps.setString(4, usuario.getRfc());
                ps.setString(5, usuario.getCurp());
                ps.setString(6, usuario.getCorreo());
                ps.setString(7, usuario.getTelefono());
                ps.setInt(8, usuario.getEstado());
                ps.setInt(9, usuario.getId_usuario());

                return ps.executeUpdate() > 0;
            }
        }

        // Activa/Desactiva un usuario (botón de estado en las tablas de gestión)
        public boolean cambiarEstado(int idUsuario, int estado) throws Exception {
            String sql = "UPDATE ADMIN.USUARIOS SET estado = ? WHERE id_usuario = ?";

            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, estado);
                ps.setInt(2, idUsuario);

                return ps.executeUpdate() > 0;
            }
        }

        // Elimina un usuario. Si tiene registros relacionados (CLIENTES/AGENTES) que
        // impiden el borrado por llave foránea, devuelve false en vez de lanzar el error.
        public boolean eliminar(int idUsuario) throws Exception {
            String sql = "DELETE FROM ADMIN.USUARIOS WHERE id_usuario = ?";

            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, idUsuario);
                return ps.executeUpdate() > 0;

            } catch (SQLException e) {
                System.err.println("Error al eliminar usuario (posibles registros relacionados): " + e.getMessage());
                return false;
            }
        }

        // Igual que validarDuplicados, pero ignora al propio usuario (para edición)
        public String validarDuplicadosExcluyendo(UsuarioBean usuario, int idUsuario) throws SQLException {

            String sql = """
            SELECT
                CASE
                    WHEN CORREO = ? THEN 'CORREO'
                    WHEN RFC = ? THEN 'RFC'
                    WHEN CURP = ? THEN 'CURP'
                    WHEN TELEFONO = ? THEN 'TELEFONO'
                END AS DUPLICADO
            FROM ADMIN.USUARIOS
            WHERE (CORREO = ? OR RFC = ? OR CURP = ? OR TELEFONO = ?)
              AND ID_USUARIO != ?
            FETCH FIRST 1 ROWS ONLY
            """;

            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, usuario.getCorreo());
                ps.setString(2, usuario.getRfc());
                ps.setString(3, usuario.getCurp());
                ps.setString(4, usuario.getTelefono());

                ps.setString(5, usuario.getCorreo());
                ps.setString(6, usuario.getRfc());
                ps.setString(7, usuario.getCurp());
                ps.setString(8, usuario.getTelefono());

                ps.setInt(9, idUsuario);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getString("DUPLICADO");
                    }
                }
            }

            return null;
        }

        public int contarUsuariosPorRol(String nombreRol) throws Exception {
            String sql = "SELECT COUNT(*) FROM ADMIN.USUARIOS u " +
                    "INNER JOIN ADMIN.ROLES r ON u.id_rol = r.id_rol " +
                    "WHERE UPPER(r.nombre) = UPPER(?) AND u.estado = 1";
    
            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {
    
                ps.setString(1, nombreRol);
    
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
            return 0;
        }
    
        // Comprueba si el correo existe y si la cuenta está activa
        public boolean existeCorreo(String correo) throws Exception {
            String sql = "SELECT COUNT(*) FROM ADMIN.USUARIOS WHERE LOWER(correo) = LOWER(?) AND estado = 1";
            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, correo);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
            return false;
        }
    
        // Retorna el objeto completo del usuario activo para obtener su ID y Nombre
        public UsuarioBean obtenerPorCorreo(String correo) throws Exception {
            String sql = "SELECT u.id_usuario, u.id_rol, r.nombre AS nombre_rol, u.nombre, " +
                    "u.apellido_paterno, u.apellido_materno, u.rfc, u.curp, u.correo, " +
                    "u.telefono, u.password, u.estado, u.fecha_registro " +
                    "FROM ADMIN.USUARIOS u " +
                    "INNER JOIN ADMIN.ROLES r ON u.id_rol = r.id_rol " +
                    "WHERE LOWER(u.correo) = LOWER(?) AND u.estado = 1";
    
            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {
    
                ps.setString(1, correo);
    
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        System.out.println("Password obtenida de Oracle: " + rs.getString("password"));

                        rolBean rol = new rolBean();
                        rol.setId_Rol(rs.getInt("id_rol"));
                        rol.setRol(rs.getString("nombre_rol"));
    
                        return new UsuarioBean(
                                rs.getInt("id_usuario"),
                                rol,
                                rs.getString("nombre"),
                                rs.getString("apellido_paterno"),
                                rs.getString("apellido_materno"),
                                rs.getString("rfc"),
                                rs.getString("curp"),
                                rs.getString("correo"),
                                rs.getString("telefono"),
                                rs.getString("password"),
                                rs.getInt("estado"),
                                rs.getTimestamp("fecha_registro"));
                    }
                }
            }

            return null;
        }
    
        public boolean actualizarPassword(int idUsuario, String nuevoPassword) throws Exception {
            String sql = "UPDATE ADMIN.USUARIOS SET password = ? WHERE id_usuario = ?";
    
            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {
    
                ps.setString(1, nuevoPassword);
                ps.setInt(2, idUsuario);
    
                return ps.executeUpdate() > 0;
            }
        }
    
        // Metodo para autenticacion segura
        public UsuarioBean validarLogin(String correo, String passwordPlana) throws Exception {

            System.out.println("===== VALIDANDO LOGIN =====");

            UsuarioBean usuario = obtenerPorCorreo(correo);

            if (usuario == null) {
                System.out.println("Usuario NO encontrado.");
                return null;
            }

            System.out.println("Usuario encontrado: " + usuario.getCorreo());
            System.out.println("Hash BD: " + usuario.getPassword());

            boolean coincide = PasswordUtils.checkPassword(passwordPlana, usuario.getPassword());

            System.out.println("¿Coincide contraseña?: " + coincide);

            if (coincide) {
                return usuario;
            }

            return null;
        }

        public String validarDuplicados(UsuarioBean usuario) throws SQLException {

            String sql = """
            SELECT
                CASE
                    WHEN CORREO = ? THEN 'CORREO'
                    WHEN RFC = ? THEN 'RFC'
                    WHEN CURP = ? THEN 'CURP'
                    WHEN TELEFONO = ? THEN 'TELEFONO'
                END AS DUPLICADO
            FROM ADMIN.USUARIOS
            WHERE CORREO = ?
               OR RFC = ?
               OR CURP = ?
               OR TELEFONO = ?
            FETCH FIRST 1 ROWS ONLY
            """;

            try (Connection con = Conexion.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, usuario.getCorreo());
                ps.setString(2, usuario.getRfc());
                ps.setString(3, usuario.getCurp());
                ps.setString(4, usuario.getTelefono());

                ps.setString(5, usuario.getCorreo());
                ps.setString(6, usuario.getRfc());
                ps.setString(7, usuario.getCurp());
                ps.setString(8, usuario.getTelefono());

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        return rs.getString("DUPLICADO");
                    }

                }
            }

            return null;
        }
    }