package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.MarcaBean;
import com.sgca.integradorsgca.model.bean.ModelosBean;
import com.sgca.integradorsgca.model.dao.MarcaDao;
import com.sgca.integradorsgca.model.dao.ModelosDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ModeloServlet", value = "/modelos")
public class ModelosServlet extends HttpServlet {

    private final ModelosDao modeloDao = new ModelosDao();
    private final MarcaDao marcaDao = new MarcaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("editar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            ModelosBean modeloAEditar = modeloDao.buscarPorId(id);
            request.setAttribute("modeloAEditar", modeloAEditar);

        } else if ("eliminar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            modeloDao.eliminar(id);

            response.sendRedirect(request.getContextPath() + "/modelos");
            return;
        }

        //Esto es para que solo los agentes seleccionen las marcas y modelos ya registrados
        // Cargamos la lista de modelos para la tabla
        List<ModelosBean> listaModelos = modeloDao.listar();
        request.setAttribute("listaModelos", listaModelos);

        // Cargamos la lista de marcas para llenar el desplegable <select> en la vista
        List<MarcaBean> listaMarcas = marcaDao.listar();
        request.setAttribute("listaMarcas", listaMarcas);

        request.getRequestDispatcher("/modelos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        int idMarca = Integer.parseInt(request.getParameter("idMarca"));
        String nombre = request.getParameter("nombre");
        int estado = Integer.parseInt(request.getParameter("estado"));

        if ("registrar".equals(accion)) {
            ModelosBean modelo = new ModelosBean(idMarca, nombre, estado);
            modeloDao.registrar(modelo);

        } else if ("actualizar".equals(accion)) {
            int idModelo = Integer.parseInt(request.getParameter("idModelo"));
            ModelosBean modelo = new ModelosBean(idModelo, idMarca, nombre, estado);
            modeloDao.actualizar(modelo);
        }

        response.sendRedirect(request.getContextPath() + "/modelos");
    }
}