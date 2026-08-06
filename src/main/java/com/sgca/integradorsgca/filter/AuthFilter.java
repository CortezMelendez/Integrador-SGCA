package com.sgca.integradorsgca.filter;

import com.sgca.integradorsgca.model.bean.UsuarioBean;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;

@WebFilter("/*")
public class AuthFilter implements Filter {

    // Mapa de Rutas vs Roles Permitidos (RBAC)
    private static final Map<String, Set<String>> PERMISOS = new HashMap<>();

    static {
        // --- ROL: ADMIN (Acceso total al sistema) ---
        PERMISOS.put("/panel",       roles("ADMIN"));
        PERMISOS.put("/usuarios",    roles("ADMIN"));
        PERMISOS.put("/agentes",     roles("ADMIN"));

        // --- ROL: AGENTE y ADMIN (Atención a clientes y catálogo) ---
        PERMISOS.put("/clientes",    roles("ADMIN", "AGENTE"));
        PERMISOS.put("/servicios",   roles("ADMIN", "AGENTE"));
        PERMISOS.put("/ventas",      roles("ADMIN", "AGENTE"));

        // --- ROL: CLIENTE (Consulta personal) ---
        PERMISOS.put("/mis-servicios", roles("CLIENTE"));

        // --- TODOS LOS ROLES AUTENTICADOS ---
        PERMISOS.put("/perfil",      roles("ADMIN", "AGENTE", "CLIENTE"));
    }

    private static Set<String> roles(String... r) {
        return new HashSet<>(Arrays.asList(r));
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // Prevenir que el navegador guarde en caché páginas protegidas
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        String path = req.getServletPath();
        System.out.println("PATH: " + path);

        // =======================================================
// RECURSOS PÚBLICOS
// Estas rutas pueden abrirse sin haber iniciado sesión.
// =======================================================
        boolean esRecursoPublico =

                // ===== CAMBIO =====
                // Permite que la aplicación inicie mostrando index.jsp
                // sin obligar al usuario a autenticarse.
                path.equals("/")

                        // ==================
                        || path.equals("/catalogo")
                        || path.equals("/login")
                        || path.equals("/login.jsp")
                        || path.equals("/logout")

                        || path.equals("/register.jsp")
                        || path.equals("/RegisterServlet")

                        // Recursos estáticos
                        || path.startsWith("/css/")
                        || path.startsWith("/js/")

                        // ===== CAMBIO =====
                        // Tu carpeta se llama "Images", no "images".
                        || path.startsWith("/Images/")
                        // ==================

                        || path.startsWith("/assets/");

        if (esRecursoPublico) {
            chain.doFilter(request, response);
            return;
        }

        // CONTROL DE SESIÓN: Si no hay sesión activa -> Redirigir al Login
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=sesion_requerida");
            return;
        }

        // OBTENER USUARIO LOGUEADO
        UsuarioBean usuario = (UsuarioBean) session.getAttribute("usuarioLogueado");
        String rolUsuario = obtenerNombreRol(usuario);
// ==========================
// PÁGINAS DEL DUEÑO
// ==========================
        if (path.startsWith("/pages/duenioPages/")) {

            if (!rolUsuario.equals("ADMIN")) {
                redirigirSegunRol(req, resp, rolUsuario);
                return;
            }
        }

// ==========================
// PÁGINAS DEL ASESOR
// ==========================
        if (path.startsWith("/pages/asesorPages/")) {

            if (!rolUsuario.equals("AGENTE")) {
                redirigirSegunRol(req, resp, rolUsuario);
                return;
            }
        }

// ==========================
// PÁGINAS DEL CLIENTE
// ==========================
        if (path.startsWith("/pages/clientePages/")) {

            if (!rolUsuario.equals("CLIENTE")) {
                redirigirSegunRol(req, resp, rolUsuario);
                return;
            }
        }

        // CONTROL DE ACCESO BASADO EN ROLES (RBAC)
        if (PERMISOS.containsKey(path)) {
            Set<String> rolesPermitidos = PERMISOS.get(path);

            if (!rolesPermitidos.contains(rolUsuario)) {
                // Si intenta entrar a una URL no permitida para su rol, lo enviamos a su pantalla principal
                redirigirSegunRol(req, resp, rolUsuario);
                return;
            }
        }

        // Si cumple todas las condiciones, continúa a la petición
        chain.doFilter(request, response);
    }

    /*Extrae de forma segura el nombre del Rol desde el objeto usuario.rol (rolBean)
     o mediante su ID como respaldo.
     */
    private String obtenerNombreRol(UsuarioBean usuario) {
        // 1. Intento por objeto rolBean y su getter getRol()
        if (usuario != null && usuario.getRol() != null && usuario.getRol().getRol() != null) {
            String nombreRol = usuario.getRol().getRol().trim().toUpperCase();
            if (!nombreRol.isEmpty()) {
                return nombreRol;
            }
        }

        //Respaldo por id_rol si por alguna razón el nombre viniera nulo
        if (usuario != null && usuario.getRol() != null) {
            switch (usuario.getRol().getId_Rol()) {
                case 1:  return "ADMIN";
                case 2:  return "AGENTE";
                case 3:  return "CLIENTE";
            }
        }

        return "INVITADO";
    }

    //Redirige al usuario a su panel correspondiente según su rol.

    private void redirigirSegunRol(HttpServletRequest req, HttpServletResponse resp, String rol) throws IOException {
        switch (rol) {
            case "ADMIN":
                resp.sendRedirect(req.getContextPath() + "/pages/duenioPages/indexDuenio.jsp");
                break;
            case "AGENTE":
                resp.sendRedirect(req.getContextPath() + "/clientes");
                break;
            case "CLIENTE":
                resp.sendRedirect(req.getContextPath() + "/mis-servicios");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                break;
        }
    }
}