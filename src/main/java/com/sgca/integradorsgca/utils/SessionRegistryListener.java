package com.sgca.integradorsgca.utils;

import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

// Quita del SessionRegistry cualquier sesión que termine, ya sea por logout
// explícito o por expirar sola (timeout), para que el mapa de
// SESIONES_POR_USUARIO no vaya acumulando referencias a sesiones muertas.
@WebListener
public class SessionRegistryListener implements HttpSessionListener {

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        SessionRegistry.remover(se.getSession());
    }
}
