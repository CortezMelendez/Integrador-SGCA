package com.sgca.integradorsgca.controller;


import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.rolBean;
import com.sgca.integradorsgca.model.dao.rolDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.rmi.ServerException;
import java.util.List;

@WebServlet (name="rolServlet", value="/rolServlet")
public class rolServlet extends HttpServlet {

    private final rolDao rolDao = new rolDao();

    private boolean Autorizado(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {
        HttpSession sesion = request.getSession();
        UsuarioBean usuario = (sesion != null) ? (UsuarioBean) sesion.getAttribute("usuario") : null;

        if (usuario == null || usuario.getRol() == null || !"DUENO".equalsIgnoreCase(usuario.getRol().getRol())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado: Se requieren permisos de DUEÑO.");
            return false;
        }
        return true;
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!Autorizado(request, response)) return;

        try {
            List<rolBean> listaRoles = rolDao.listar();
            request.setAttribute("listaRoles", listaRoles);
            request.getRequestDispatcher("/vistas/roles.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al obtener la lista de roles.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!Autorizado(request, response)) return;

        request.setCharacterEncoding("UTF-8");

        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String estadoStr = request.getParameter("estado");

        if (nombre != null && !nombre.trim().isEmpty()) {
            try {
                int estado = 1; // 1 = Activo por defecto
                if (estadoStr != null && !estadoStr.trim().isEmpty()) {
                    try {
                        estado = Integer.parseInt(estadoStr.trim());
                    } catch (NumberFormatException e) {
                        estado = 1;
                    }
                }

                rolBean nuevoRol = new rolBean();
                nuevoRol.setRol(nombre.trim().toUpperCase());
                nuevoRol.setDescripcion(descripcion != null ? descripcion.trim() : "");
                nuevoRol.setEstado(estado);

                rolDao.registrar(nuevoRol);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/RolesServlet");
    }
}


