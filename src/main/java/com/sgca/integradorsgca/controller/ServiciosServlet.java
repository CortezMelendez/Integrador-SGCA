package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.TiposServicioBean;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
import com.sgca.integradorsgca.model.dao.TiposServicioDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "ServiciosServlet", value = "/servicios")
public class ServiciosServlet extends HttpServlet {

    private final ServiciosDao serviciosDao = new ServiciosDao();
    private final TiposServicioDao tiposServicioDao = new TiposServicioDao();

    /*
     * ========================================
     * CARGAR LA PANTALLA
     * ========================================
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {

            req.setAttribute("listaServicios", serviciosDao.listar());
            req.setAttribute("listaTipos", tiposServicioDao.listar());

            req.getRequestDispatcher("/pages/duenioPages/gestionServicios.jsp").forward(req, resp);

        } catch (Exception e) {

            e.printStackTrace();

            resp.sendRedirect(req.getContextPath()
                    + "/panel?error=servicios");

        }

    }

    /*
     * ========================================
     * ACCIONES
     * ========================================
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String accion = req.getParameter("accion");

        try {

            switch (accion) {

                /*
                 * ===========================
                 * AGREGAR
                 * ===========================
                 */
                case "agregar":

                    agregarServicio(req);

                    break;

                /*
                 * ===========================
                 * EDITAR
                 * ===========================
                 */
                case "editar":

                    editarServicio(req);

                    break;

                /*
                 * ===========================
                 * CAMBIAR ESTADO
                 * ===========================
                 */
                case "estado":

                    cambiarEstado(req);

                    break;

                /*
                 * ===========================
                 * ELIMINAR
                 * ===========================
                 */
                case "eliminar":

                    eliminarServicio(req);

                    break;

            }

            resp.sendRedirect(req.getContextPath() + "/servicios");

        } catch (Exception e) {

            e.printStackTrace();

            resp.sendRedirect(req.getContextPath()
                    + "/servicios?error");

        }

    }

    /*
     * ========================================
     * REGISTRAR
     * ========================================
     */
    private void agregarServicio(HttpServletRequest req)
            throws Exception {

        int idTipo =
                Integer.parseInt(req.getParameter("id_tipo_servicio"));

        String nombre =
                req.getParameter("nombre");

        String descripcion =
                req.getParameter("descripcion");

        double precio =
                Double.parseDouble(req.getParameter("precio"));

        TiposServicioBean tipo =
                new TiposServicioBean();

        tipo.setId_tipo_servicio(idTipo);

        ServiciosBean servicio =
                new ServiciosBean();

        servicio.setTipoServicio(tipo);
        servicio.setNombre(nombre);
        servicio.setDescripcion(descripcion);
        servicio.setPrecio(precio);
        servicio.setEstado(1);

        serviciosDao.registrar(servicio);

    }

    /*
     * ========================================
     * EDITAR
     * ========================================
     */
    private void editarServicio(HttpServletRequest req)
            throws Exception {

        int idServicio =
                Integer.parseInt(req.getParameter("id_servicio"));

        int idTipo =
                Integer.parseInt(req.getParameter("id_tipo_servicio"));

        String nombre =
                req.getParameter("nombre");

        String descripcion =
                req.getParameter("descripcion");

        double precio =
                Double.parseDouble(req.getParameter("precio"));

        int estado =
                Integer.parseInt(req.getParameter("estado"));

        TiposServicioBean tipo =
                new TiposServicioBean();

        tipo.setId_tipo_servicio(idTipo);

        ServiciosBean servicio =
                new ServiciosBean();

        servicio.setId_servicio(idServicio);
        servicio.setTipoServicio(tipo);
        servicio.setNombre(nombre);
        servicio.setDescripcion(descripcion);
        servicio.setPrecio(precio);
        servicio.setEstado(estado);

        serviciosDao.actualizar(servicio);

    }

    /*
     * ========================================
     * ACTIVAR / DESACTIVAR
     * ========================================
     */
    private void cambiarEstado(HttpServletRequest req)
            throws Exception {

        int idServicio =
                Integer.parseInt(req.getParameter("id_servicio"));

        int estado =
                Integer.parseInt(req.getParameter("estado"));

        serviciosDao.actualizarEstado(idServicio, estado);

    }

    /*
     * ========================================
     * ELIMINAR
     * ========================================
     */
    private void eliminarServicio(HttpServletRequest req)
            throws Exception {

        int idServicio =
                Integer.parseInt(req.getParameter("id_servicio"));

        serviciosDao.eliminar(idServicio);

    }

}