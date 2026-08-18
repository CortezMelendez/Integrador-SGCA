
import com.sgca.integradorsgca.model.bean.UsuarioBean;
import com.sgca.integradorsgca.model.bean.VehiculosBean;
import com.sgca.integradorsgca.model.dao.VehiculosDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/index")
public class IndexServlet extends HttpServlet {

    private final VehiculosDao dao = new VehiculosDao();

    private static final int LIMITE_CARRUSEL = 12;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("===== ENTRANDO A Index =====");

        List<VehiculosBean> lista = dao.listarDisponibles();

        System.out.println("Vehículos encontrados: " + lista.size());

        for (VehiculosBean v : lista) {
            System.out.println("----------------------------");
            System.out.println("ID: " + v.getId_Vehiculo());
            System.out.println("Marca: " + v.getMarca().getNombre());
            System.out.println("Modelo: " + v.getModelos().getNombre());
            System.out.println("Precio: " + v.getPrecio());
            System.out.println("Foto: " + v.getFoto_Portada());
        }

        request.setAttribute("vehiculos", lista);
        request.setAttribute("vehiculosNuevos", dao.listarMasNuevos(LIMITE_CARRUSEL));
        request.setAttribute("vehiculosAccesibles", dao.listarMasAccesibles(LIMITE_CARRUSEL));
        request.setAttribute("vehiculosRecientes", dao.listarRecienAgregados(LIMITE_CARRUSEL));
        request.setAttribute("vehiculosDestacados", dao.listarDestacados(LIMITE_CARRUSEL));

        request.getRequestDispatcher("/index.jsp")
                .forward(request, response);

        HttpSession session = request.getSession(false);

        if(session != null){
            UsuarioBean usuario = (UsuarioBean) session.getAttribute("usuarioLogueado");

            if(usuario != null){
                request.setAttribute("usuario", usuario);
            }
        }
    }
}