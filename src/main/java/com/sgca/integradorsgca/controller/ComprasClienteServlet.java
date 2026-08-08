package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.ClientesBean;
import com.sgca.integradorsgca.model.bean.ServiciosBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.VentasBean;
import com.sgca.integradorsgca.model.dao.ClientesDao;
import com.sgca.integradorsgca.model.dao.ServiciosDao;
import com.sgca.integradorsgca.model.dao.VentasDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/comprasCliente")
public class ComprasClienteServlet extends HttpServlet {

    private final ClientesDao clientesDao = new ClientesDao();
    private final VentasDao ventasDao = new VentasDao();
    private final ServiciosDao serviciosDao = new ServiciosDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UsuarioBean usuario = (UsuarioBean) session.getAttribute("usuarioLogueado");

        List<VentasBean> compras = new ArrayList<>();

        try {

            ClientesBean cliente = clientesDao.buscarPorIdUsuario(usuario.getId_usuario());

            if (cliente != null) {
                compras = ventasDao.listarPorCliente(cliente.getIdCliente());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        double totalPagado = 0;
        for (VentasBean venta : compras) {
            totalPagado += venta.getTotal();
        }

        request.setAttribute("compras", compras);
        request.setAttribute("totalCompras", compras.size());
        request.setAttribute("totalPagado", totalPagado);
        request.setAttribute("ultimaCompra", compras.isEmpty() ? null : compras.get(0).getFechaVenta());

        try {

            List<ServiciosBean> servicios = new ArrayList<>();

            for (ServiciosBean s : serviciosDao.listar()) {

                if (s.getEstado() == 1) {
                    servicios.add(s);
                }
            }

            request.setAttribute("servicios", servicios);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute("servicios", new ArrayList<ServiciosBean>());
        }

        request.getRequestDispatcher(
                "/pages/clientePages/comprasCliente.jsp"
        ).forward(request, response);
    }
}
