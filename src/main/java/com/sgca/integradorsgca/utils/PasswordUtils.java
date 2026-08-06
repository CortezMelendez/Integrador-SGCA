package com.sgca.integradorsgca.utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtils {

    // Aqui se genera el hash para encriptar y guardarla en la DB
    public static String hashPassword(String passwordPlain) {
        return BCrypt.hashpw(passwordPlain, BCrypt.gensalt(12));
    }

    //Verificamos si la contraseña coincide con el hash de la contraseña guardada en la DB
    public static boolean checkPassword(String passwordPlain, String hashedPassword) {
        if (hashedPassword == null || !hashedPassword.startsWith("$2a$")) {
            return false;
        }
        return BCrypt.checkpw(passwordPlain, hashedPassword);
    }

}