package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.TiposVehiculoBean;
import com.sgca.integradorsgca.model.dao.TiposVehiculoDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

    @WebServlet(name = "TiposVehiculoServlet", value = "/tipos-vehiculo")
    public class TiposVehiculoServlet extends HttpServlet {

        private final TiposVehiculoDao tiposDao = new TiposVehiculoDao();

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String accion = req.getParameter("accion");

            if ("editar".equals(accion)) {
                int id = Integer.parseInt(req.getParameter("id"));
                TiposVehiculoBean tipoAEditar = tiposDao.obtenerPorId(id);
                req.setAttribute("tipoAEditar", tipoAEditar);
            } else if ("eliminar".equals(accion)) {
                int id = Integer.parseInt(req.getParameter("id"));
                tiposDao.eliminar(id);
                resp.sendRedirect(req.getContextPath() + "/tipos-vehiculo");
                return;
            }

            List<TiposVehiculoBean> listaTipos = tiposDao.listar();
            req.setAttribute("listaTipos", listaTipos);
            req.getRequestDispatcher("tipos-vehiculo.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.setCharacterEncoding("UTF-8");
            String accion = req.getParameter("accion");
            String nombre = req.getParameter("nombre");

            if ("registrar".equals(accion)) {
                TiposVehiculoBean nuevoTipo = new TiposVehiculoBean(nombre);
                tiposDao.registrar(nuevoTipo);
            } else if ("actualizar".equals(accion)) {
                int idTipo = Integer.parseInt(req.getParameter("idTipo"));
                TiposVehiculoBean tipoModificado = new TiposVehiculoBean(idTipo, nombre);
                tiposDao.actualizar(tipoModificado);
            }

            resp.sendRedirect(req.getContextPath() + "/tipos-vehiculo");
        }
    }
