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

@WebServlet(name="MarcaModelo",  value="/MarcaModeloDueño")
public class MarcaModeloDueño extends HttpServlet {
    private MarcaDao marcaDao = new MarcaDao();
    private ModelosDao modelosDao = new ModelosDao();

    @Override
    protected void doPost(HttpServletRequest request,  HttpServletResponse response)
        throws ServletException, IOException{

        // Solo el DUEÑO puede ejecutar esta acción
        HttpSession session = request.getSession(false);
        UsuarioBean usuario = (session != null) ? (UsuarioBean) session.getAttribute("usuario") : null;

        if (usuario == null || usuario.getRol() == null || !"DUENO".equalsIgnoreCase(usuario.getRol().getRol())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso no autorizado.");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        try {
            if ("registrarMarca".equals(accion)) {
                String nombreMarca = request.getParameter("nombreMarca");
                if (nombreMarca != null && !nombreMarca.trim().isEmpty()) {
                    MarcaBean marca = new MarcaBean();
                    marca.setNombre(nombreMarca.trim());
                    marcaDao.registrar(marca);
                }
            } else if ("registrarModelo".equals(accion)) {
                String nombreModelo = request.getParameter("nombreModelo");
                int idMarca = Integer.parseInt(request.getParameter("idMarca"));

                if (nombreModelo != null && !nombreModelo.trim().isEmpty() && idMarca > 0) {
                    ModelosBean modelo = new ModelosBean();
                    modelo.setNombre(nombreModelo.trim());

                    MarcaBean marca = new MarcaBean();
                    marca.setId_Marca(idMarca);
                    modelo.setMarca(marca);

                    modelosDao.registrar(modelo);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/dueno.html");
    }
}
