package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.MarcaBean;
import com.sgca.integradorsgca.model.dao.MarcaDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MarcaServlet", value = "/marcas")
public class MarcaServlet extends HttpServlet {

    private final MarcaDao marcaDao = new MarcaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("editar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            MarcaBean marcaAEditar = marcaDao.buscarPorId(id);
            request.setAttribute("marcaAEditar", marcaAEditar);
        }


        List<MarcaBean> lista = marcaDao.listar();
        request.setAttribute("listaMarcas", lista);

        request.getRequestDispatcher("/marcas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {
            String nombre = request.getParameter("nombre");
            MarcaBean marc = new MarcaBean();
            marc.setNombre(nombre);
            marcaDao.registrar(marc);
        } else if ("actualizar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("idMarca"));
            String nombre = request.getParameter("nombre");
            int estado = Integer.parseInt(request.getParameter("estado"));

            MarcaBean marc = new MarcaBean(id, nombre, estado);

            marcaDao.actualizar(marc);
        }

        response.sendRedirect(request.getContextPath() + "/marcas");
    }
}
