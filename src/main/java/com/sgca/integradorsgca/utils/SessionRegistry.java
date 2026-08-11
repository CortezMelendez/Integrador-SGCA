package com.sgca.integradorsgca.utils;

import com.sgca.integradorsgca.model.bean.UsuarioBean;
import jakarta.servlet.http.HttpSession;

import java.util.Collections;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

// Lleva el registro de las sesiones HTTP activas de cada usuario (una por
// cada dispositivo/navegador donde inició sesión) para poder cerrarlas todas
// a la vez desde "Cerrar sesión" o al cambiar la contraseña.
public class SessionRegistry {

    private static final Map<Integer, Set<HttpSession>> SESIONES_POR_USUARIO = new ConcurrentHashMap<>();

    private SessionRegistry() {}

    public static void registrar(int idUsuario, HttpSession session) {
        SESIONES_POR_USUARIO
                .computeIfAbsent(idUsuario, k -> Collections.newSetFromMap(new ConcurrentHashMap<>()))
                .add(session);
    }

    public static void remover(HttpSession session) {
        Object usuarioObj;
        try {
            usuarioObj = session.getAttribute("usuarioLogueado");
        } catch (IllegalStateException e) {
            return;
        }

        if (!(usuarioObj instanceof UsuarioBean)) {
            return;
        }

        int idUsuario = ((UsuarioBean) usuarioObj).getId_usuario();
        Set<HttpSession> sesiones = SESIONES_POR_USUARIO.get(idUsuario);

        if (sesiones != null) {
            sesiones.remove(session);
            if (sesiones.isEmpty()) {
                SESIONES_POR_USUARIO.remove(idUsuario);
            }
        }
    }

    // Invalida todas las sesiones activas de un usuario (todos los dispositivos)
    public static void invalidarTodas(int idUsuario) {
        Set<HttpSession> sesiones = SESIONES_POR_USUARIO.remove(idUsuario);
        if (sesiones == null) {
            return;
        }

        for (HttpSession session : sesiones) {
            try {
                session.invalidate();
            } catch (IllegalStateException ignored) {
                // La sesión ya estaba invalidada
            }
        }
    }
}