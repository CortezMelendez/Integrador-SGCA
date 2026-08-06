package com.sgca.integradorsgca.utils;

import org.mindrot.jbcrypt.BCrypt;

public class PruebaBCrypt {

    public static void main(String[] args) {

        String hash="$2a$12$R.BuIEJZMEYAma1NkqPayuFpdZQH072EL5gU.xTyqUPytYh07AEIW";

        System.out.println(BCrypt.checkpw("Admin123!", hash));

    }

}