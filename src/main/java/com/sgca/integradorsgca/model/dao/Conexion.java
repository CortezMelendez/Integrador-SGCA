package com.sgca.integradorsgca.model.dao;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    public static Connection getConexion() {
        // Ruta absoluta formateada para la Wallet
        String rutaWallet = new File("src/main/resources/Wallet")
                .getAbsolutePath()
                .replace('\\', '/');

        // Configurar la propiedad TNS para que encuentre los certificados SSL/TLS
        System.setProperty("oracle.net.tns_admin", rutaWallet);

        String tnsDescriptor = "(description= (retry_count=20)(retry_delay=3)(address=(protocol=tcps)(port=1522)(host=adb.us-phoenix-1.oraclecloud.com))(connect_data=(service_name=ge06bca1be51129_sgcabasesdedatos_high.adb.oraclecloud.com))(security=(ssl_server_dn_match=yes)))";

        // Formato URL directo que omite la búsqueda TNS por archivo
        String url = "jdbc:oracle:thin:@" + tnsDescriptor;

        String user = System.getenv("DB_USER");
        String password = System.getenv("DB_PASSWORD");

        Connection con = null;
        try {
            Class.forName("oracle.jdbc.OracleDriver");
            con = DriverManager.getConnection(url, user, password);
            System.out.println("¡Conexión exitosa a Oracle Autonomous Database!");

        } catch (ClassNotFoundException e) {
            System.err.println("Driver no encontrado.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error SQL al conectar:");
            e.printStackTrace();
        }
        return con;
    }

    public static void main(String[] args) {
        Connection c = getConexion();
        if (c != null) {
            try {
                c.close();
                System.out.println("Conexión cerrada correctamente.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
