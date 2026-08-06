package com.sgca.integradorsgca.utils;
public class GenerarHash {
    public static void main(String[] args) {
        String hash = PasswordUtils.hashPassword("Admin123!");
        System.out.println(hash);
    }
}