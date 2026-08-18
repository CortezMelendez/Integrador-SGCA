package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.MarcaBean;
import com.sgca.integradorsgca.model.bean.ModelosBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.dao.MarcaDao;
import com.sgca.integradorsgca.model.dao.ModelosDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// Modal "Registrar marca/modelo" del panel del dueño (gestionAutos.jsp).
// Solo el dueño puede dar de alta marcas y modelos nuevos; el asesor (y el
// propio dueño al registrar un vehículo) siempre elige de esta lista ya
// existente, nunca escribe una marca/modelo libre. Reemplaza a los antiguos
// MarcaServlet/ModelosServlet/MarcaModeloDueño (legacy, sin JSP real detrás,
// sin control de rol correcto).
@WebServlet(name = "MarcaModeloServlet", value = "/marcaModelo")
public class MarcaModeloServlet extends HttpServlet {

    private final MarcaDao marcaDao = new MarcaDao();
    private final ModelosDao modelosDao = new ModelosDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!esAdmin(req, resp)) return;

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String accion = req.getParameter("accion");

        try {
            if ("registrarMarca".equals(accion)) {
                registrarMarca(req, resp);
            } else if ("registrarModelo".equals(accion)) {
                registrarModelo(req, resp);
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().println("Acción no reconocida.");
            }
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().println("Selecciona una marca válida.");
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().println("Ocurrió un error en el servidor. Intenta más tarde.");
        }
    }

    private void registrarMarca(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String nombre = req.getParameter("nombreMarca");
        if (nombre == null || nombre.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().println("Escribe el nombre de la marca.");
            return;
        }
        nombre = nombre.trim();

        if (marcaDao.buscarPorNombre(nombre) != null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().println("Esa marca ya está registrada.");
            return;
        }

        boolean ok = marcaDao.registrar(new MarcaBean(0, nombre, 1));
        if (!ok) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().println("No se pudo registrar la marca. Intenta de nuevo.");
            return;
        }

        resp.getWriter().println("Marca registrada correctamente.");
    }

    private void registrarModelo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String nombre = req.getParameter("nombreModelo");
        int idMarca = Integer.parseInt(req.getParameter("idMarca"));

        if (nombre == null || nombre.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().println("Escribe el nombre del modelo.");
            return;
        }
        nombre = nombre.trim();

        MarcaBean marca = marcaDao.buscarPorId(idMarca);
        if (marca == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().println("Selecciona una marca válida.");
            return;
        }

        if (modelosDao.buscarPorNombreYMarca(nombre, idMarca) != null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().println("Ese modelo ya está registrado para esa marca.");
            return;
        }

        modelosDao.registrar(new ModelosBean(idMarca, nombre, 1));

        resp.getWriter().println("Modelo registrado correctamente.");
    }

    private boolean esAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        UsuarioBean usuario = (session != null)
                ? (UsuarioBean) session.getAttribute("usuarioLogueado")
                : null;

        if (usuario == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().println("Tu sesión expiró. Vuelve a iniciar sesión.");
            return false;
        }

        if (!"ADMIN".equals(obtenerNombreRol(usuario))) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.getWriter().println("Solo el dueño puede registrar marcas y modelos.");
            return false;
        }

        return true;
    }

    private String obtenerNombreRol(UsuarioBean usuario) {
        if (usuario != null && usuario.getRol() != null && usuario.getRol().getRol() != null) {
            String nombreRol = usuario.getRol().getRol().trim().toUpperCase();
            if (!nombreRol.isEmpty()) return nombreRol;
        }
        if (usuario != null && usuario.getRol() != null) {
            switch (usuario.getRol().getId_Rol()) {
                case 1: return "ADMIN";
                case 2: return "AGENTE";
                case 3: return "CLIENTE";
            }
        }
        return "INVITADO";
    }
}
