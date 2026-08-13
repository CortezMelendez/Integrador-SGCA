package com.sgca.integradorsgca.controller;

import com.sgca.integradorsgca.model.bean.AgentesBean;
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.dao.AgentesDao;
import com.sgca.integradorsgca.model.dao.UsuarioDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AgentesServlet", value = "/agentes")
public class AgentesServlet extends HttpServlet {

    private final AgentesDao agentesDao = new AgentesDao();
    private final UsuarioDao usuarioDao = new UsuarioDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");

        // Permite realizar la baja del agente desde una URL/enlace tipo GET (opcional)
        if ("baja".equals(accion)) {
            try {
                int idAgente = Integer.parseInt(req.getParameter("id"));
                boolean exito = agentesDao.darDeBajaAgente(idAgente);

                if (exito) {
                    resp.sendRedirect(req.getContextPath() + "/agentes?exito=agente_desactivado");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/agentes?error=error_baja");
                }
                return;
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/agentes?error=parametro_invalido");
                return;
            }
        }

        try {
            //Obtener la lista de todos los agentes
            List<AgentesBean> listaAgentes = agentesDao.listar();
            req.setAttribute("listaAgentes", listaAgentes);

            // btener usuarios para el desplegable de registro de nuevos agentes
            List<UsuarioBean> listaUsuarios = usuarioDao.listar();
            req.setAttribute("listaUsuarios", listaUsuarios);

            // Redireccionar al JSP
            req.getRequestDispatcher("agentes.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/agentes?error=cargando_datos");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");

        try {
            if ("reasignarManual".equals(accion)) {
                // El dueño asigna o cambia manualmente el agente de un cliente
                // (o lo deja libre si no se selecciona ningún agente, ej. modal de gestionClientes.jsp)
                int idCliente = Integer.parseInt(req.getParameter("idCliente"));
                String idAgenteParam = req.getParameter("idAgente");

                boolean exito = (idAgenteParam == null || idAgenteParam.trim().isEmpty())
                        ? agentesDao.liberarCliente(idCliente)
                        : agentesDao.reasignarAgenteACliente(idCliente, Integer.parseInt(idAgenteParam));

                // El modal "Asignar asesor" de gestionClientes.jsp llama por fetch (AJAX)
                // y espera una respuesta corta en texto plano en vez de un redirect de página completa.
                boolean esAjax = "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));
                if (esAjax) {
                    resp.setContentType("text/plain; charset=UTF-8");
                    if (exito) {
                        resp.getWriter().print("OK");
                    } else {
                        resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        resp.getWriter().print("No se pudo asignar el asesor. Intenta de nuevo.");
                    }
                    return;
                }

                if (exito) {
                    resp.sendRedirect(req.getContextPath() + "/agentes?exito=reasignado");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/agentes?error=error_reasignacion");
                }
                return;

            } else if ("bajaAgente".equals(accion)) {
                //El agente cambia su ESTADO a 0 y sus clientes quedan compartidos/libres (ID_AGENTE = NULL)
                int idAgente = Integer.parseInt(req.getParameter("idAgente"));

                boolean exito = agentesDao.darDeBajaAgente(idAgente);

                if (exito) {
                    resp.sendRedirect(req.getContextPath() + "/agentes?exito=agente_desactivado");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/agentes?error=error_baja");
                }
                return;

            } else {
                // Registro estándar de un nuevo Agente
                int idUsuario = Integer.parseInt(req.getParameter("idUsuario"));
                int estado = (req.getParameter("estado") != null && !req.getParameter("estado").isEmpty())
                        ? Integer.parseInt(req.getParameter("estado")) : 1;

                AgentesBean agente = new AgentesBean();
                agente.setIdUsuario(idUsuario);
                agente.setEstado(estado);

                boolean exito = agentesDao.registrar(agente);

                if (exito) {
                    resp.sendRedirect(req.getContextPath() + "/agentes?exito=agente_registrado");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/agentes?error=error_registro");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/agentes?error=server_error");
        }
    }
}