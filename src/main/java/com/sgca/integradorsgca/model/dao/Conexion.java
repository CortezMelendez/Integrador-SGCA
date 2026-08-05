package com.sgca.integradorsgca.model.dao;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    public static Connection getConexion() {
        // 1) Primero intenta leer la ruta desde una variable de entorno (recomendado en despliegue)
        String rutaWallet = System.getenv("TNS_ADMIN_PATH");

        // 2) Si no existe la variable de entorno, resuelve la ruta vía el classloader
        //    (funciona tanto en local como dentro del WAR/target/classes)
        if (rutaWallet == null || rutaWallet.isBlank()) {
            java.net.URL walletUrl = Conexion.class.getClassLoader().getResource("Wallet");
            if (walletUrl != null) {
                rutaWallet = new File(walletUrl.getFile()).getAbsolutePath().replace('\\', '/');
            }
        }

        // 3) Último recurso: ruta relativa (solo funcionará si el working dir es el proyecto)
        if (rutaWallet == null || rutaWallet.isBlank()) {
            rutaWallet = new File("src/main/resources/Wallet")
                    .getAbsolutePath()
                    .replace('\\', '/');
        }

        System.out.println("Ruta Wallet: " + rutaWallet);

        File wallet = new File(rutaWallet);
        System.out.println("Existe Wallet: " + wallet.exists());
        System.out.println("Es directorio: " + wallet.isDirectory());
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
            throw new RuntimeException("Driver Oracle JDBC no encontrado en el classpath.", e);
        } catch (SQLException e) {
            System.err.println("Error SQL al conectar:");
            e.printStackTrace();
            throw new RuntimeException("No se pudo conectar a la base de datos. Verifica la ruta del Wallet ("
                    + rutaWallet + "), las credenciales y la conectividad de red.", e);
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