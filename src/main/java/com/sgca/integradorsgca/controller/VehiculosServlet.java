package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.ModelosBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.dao.ModelosDao;
import com.sgca.integradorsgca.model.dao.VehiculosDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name="VehiculosServlet", value="/vehiculos")
public class VehiculosServlet extends HttpServlet {

    private final VehiculosDao vehiculosDao = new VehiculosDao();
    private final ModelosDao modelosDao = new ModelosDao(); // 1. Inyectamos el DAO de Modelos

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String accion = req.getParameter("accion");

        if ("editar".equals(accion)) {
            int id = Integer.parseInt(req.getParameter("id"));
            VehiculosBean vehiculoAEditar = vehiculosDao.buscarPorID(id);
            req.setAttribute("VehiculoAEditar", vehiculoAEditar);
        } else if ("eliminar".equals(accion)) {
            int id = Integer.parseInt(req.getParameter("id"));
            vehiculosDao.eliminar(id);

            resp.sendRedirect(req.getContextPath()+"/vehiculos");
            return;
        }


        List<VehiculosBean> listaVehiculos = vehiculosDao.listar();
        req.setAttribute("listaVehiculos", listaVehiculos);

        List<ModelosBean> listaModelos = modelosDao.listar();
        req.setAttribute("listaModelos", listaModelos);

        req.getRequestDispatcher("vehiculos.jsp").forward(req, resp);
    }

    // Acción de registrar o actualizar un vehículo
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");

        int id_Modelo = Integer.parseInt(req.getParameter("id_Modelo"));
        int id_Tipo = Integer.parseInt(req.getParameter("id_Tipo"));
        int id_Agente = Integer.parseInt(req.getParameter("id_Agente"));
        String placa =  req.getParameter("placa");
        String color =  req.getParameter("color");
        int anio =  Integer.parseInt(req.getParameter("anio"));
        BigDecimal precio =  new BigDecimal(req.getParameter("precio"));
        int disponible = Integer.parseInt(req.getParameter("disponible"));
        String foto_Portada = req.getParameter("foto_Portada");

        if ("registrar".equals(accion)) {
            VehiculosBean vehiculo = new VehiculosBean(id_Modelo, id_Tipo, id_Agente, placa, color, anio, precio, disponible, foto_Portada);
            vehiculosDao.registrar(vehiculo);
        } else if ("actualizar".equals(accion)) {
            int id_Vehiculo = Integer.parseInt(req.getParameter("id_Vehiculo"));
            VehiculosBean v = new VehiculosBean(id_Vehiculo, id_Modelo, id_Tipo, id_Agente, placa, color, anio, precio, disponible, foto_Portada);

            vehiculosDao.actualizar(v);
        }
        resp.sendRedirect(req.getContextPath()+"/vehiculos");
    }
}