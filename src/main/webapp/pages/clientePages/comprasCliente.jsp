<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<fmt:setLocale value="es_MX" />

<html lang="es">

<head>

    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Mis compras · Gestionaria Automotriz</title>


    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&display=swap" rel="stylesheet">


    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/index.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/responsive.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/serviciosModal.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/comprasCliente.css">
</head>


<body>


<!-- NAVBAR -->
<header class="dash-navbar">


    <div class="dash-navbar-left">


        <a href="${pageContext.request.contextPath}/cliente" class="dash-brand">
            Gestionaria Automotriz
        </a>


    </div>



    <nav class="dash-nav-center">


        <a href="${pageContext.request.contextPath}/cliente" class="dash-nav-link">
            Inicio
        </a>

        <div class="dropdown">

            <button class="dash-nav-link dropdown-btn">
                Automóviles ▾
            </button>


            <div class="dropdown-menu">

                <a href="${pageContext.request.contextPath}/automoviles">Ver todos</a>
                <c:forEach var="t" items="${listaTipos}">
                    <a href="${pageContext.request.contextPath}/automoviles?tipo=${t.nombre}">${t.nombre}</a>
                </c:forEach>

            </div>

        </div>

        <button type="button" class="dash-nav-link" id="btnAbrirServicios">
            Servicios
        </button>


        <a href="${pageContext.request.contextPath}/comprasCliente" class="dash-nav-link active">
            Mis compras
        </a>



        <div class="dropdown">

            <button class="dash-nav-link dropdown-btn">
                Configuración ▾
            </button>


            <div class="dropdown-menu">

                <a href="${pageContext.request.contextPath}/perfil">Perfil</a>

                <a href="${pageContext.request.contextPath}/cambiarContrasena">
                    Cambiar contraseña
                </a>

                <a href="${pageContext.request.contextPath}/logout">
                    Cerrar sesión
                </a>

            </div>

        </div>

    </nav>

</header>



<!-- MODAL SERVICIOS -->
<div class="modal-overlay" id="modalServicios">

    <div class="modal-box modal-box-servicios">

        <div class="modal-header-bar">
            <span>Catálogo de servicios</span>
            <button type="button" class="modal-cerrar" id="btnCerrarServicios" aria-label="Cerrar">&times;</button>
        </div>

        <div class="modal-servicios-grid">

            <c:forEach var="s" items="${servicios}">

                <div class="card-servicio">

                    <div class="servicio-encabezado">
                        <h3>${s.nombre}</h3>
                        <span class="servicio-tipo">${s.tipoServicio.nombre}</span>
                    </div>

                    <p class="servicio-descripcion">${s.descripcion}</p>

                    <h2>$${s.precio}</h2>

                </div>

            </c:forEach>

            <c:if test="${empty servicios}">
                <p class="servicios-vacio">Por el momento no hay servicios disponibles.</p>
            </c:if>

        </div>

    </div>

</div>



<!-- MIS COMPRAS -->

<main class="compras-page">


    <section class="compras-header">
        <h1 class="compras-title">Mis compras</h1>
        <p class="compras-subtext">Historial de vehículos y servicios adquiridos</p>
    </section>


    <!-- RESUMEN -->
    <section class="compras-summary">

        <div class="summary-item">
            <span class="summary-label">Compras totales</span>
            <span class="summary-value">${totalCompras}</span>
        </div>

        <div class="summary-item">
            <span class="summary-label">Total pagado</span>
            <span class="summary-value">$<fmt:formatNumber value="${totalPagado}" pattern="#,##0"/></span>
        </div>

        <div class="summary-item">
            <span class="summary-label">Última compra</span>
            <span class="summary-value">
                <c:choose>
                    <c:when test="${not empty ultimaCompra}">
                        <fmt:formatDate value="${ultimaCompra}" pattern="d MMM yyyy"/>
                    </c:when>
                    <c:otherwise>—</c:otherwise>
                </c:choose>
            </span>
        </div>

    </section>


    <!-- HISTORIAL -->
    <section class="compras-history">

        <div class="history-toolbar">

            <h2 class="history-title">Historial de compras</h2>

            <div class="history-search">
                <input
                        type="text"
                        id="buscarCompra"
                        placeholder="Buscar por placa o modelo"
                        aria-label="Buscar por placa o modelo"
                />
                <button type="button" class="search-btn" aria-label="Buscar">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="7"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                </button>
            </div>

        </div>

        <div class="history-table-wrap">

            <table class="history-table" id="tablaCompras">

                <thead>
                <tr>
                    <th>Placa</th>
                    <th>Vehículo</th>
                    <th>Fecha</th>
                    <th>Asesor</th>
                    <th>Precio</th>
                    <th>Servicios adicionales</th>
                    <th>Estado</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="v" items="${compras}">

                    <tr data-placa="${v.vehiculo.placa}"
                        data-modelo="${v.vehiculo.marca.nombre} ${v.vehiculo.modelos.nombre}">

                        <td class="cell-placa">${v.vehiculo.placa}</td>

                        <td class="cell-vehiculo">
                            <span class="vehiculo-nombre">${v.vehiculo.marca.nombre} ${v.vehiculo.modelos.nombre}</span>
                            <span class="vehiculo-detalle">${v.vehiculo.anio} - ${v.vehiculo.tipoVehiculo.nombre}</span>
                        </td>

                        <td><fmt:formatDate value="${v.fechaVenta}" pattern="d MMM yyyy"/></td>

                        <td>${v.agente.nombreCompletoUsuario}</td>

                        <td class="cell-precio">$<fmt:formatNumber value="${v.total}" pattern="#,##0"/></td>

                        <td class="cell-servicios">
                            <c:choose>
                                <c:when test="${not empty v.detalles}">
                                    <c:forEach var="d" items="${v.detalles}" varStatus="st">${d.servicio.nombre}<c:if test="${!st.last}">, </c:if></c:forEach>
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>

                        <td><span class="badge badge-completada">✓ Completada</span></td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

            <p class="no-results" id="sinResultados" hidden>No se encontraron compras con esa búsqueda.</p>

            <c:if test="${empty compras}">
                <p class="no-results">Todavía no tienes compras registradas.</p>
            </c:if>

        </div>

    </section>

</main>


<div class="compras-atras-wrap">
    <a href="${pageContext.request.contextPath}/cliente" class="btn-atras">
        <span class="btn-atras-icon">&#8617;</span> Regresar
    </a>
</div>


<footer class="footer">
    <p>
        © 2026 SGCA · Todos los derechos reservados
    </p>
</footer>

<script src="${pageContext.request.contextPath}/js/clienteJS/comprasCliente.js"></script>

<script>

    document.querySelectorAll(".dropdown-btn")
        .forEach(button => {


            button.addEventListener("click", function(e){


                e.stopPropagation();


                let menu = this.nextElementSibling;


                menu.classList.toggle("show");


            });


        });


    // Cerrar menú al hacer click fuera

    document.addEventListener("click", function(){


        document.querySelectorAll(".dropdown-menu")
            .forEach(menu => {

                menu.classList.remove("show");

            });


    });


    // MODAL SERVICIOS

    const modalServicios = document.getElementById("modalServicios");
    const btnAbrirServicios = document.getElementById("btnAbrirServicios");
    const btnCerrarServicios = document.getElementById("btnCerrarServicios");

    btnAbrirServicios.addEventListener("click", function(e){

        e.stopPropagation();

        modalServicios.classList.add("active");

    });

    btnCerrarServicios.addEventListener("click", function(){

        modalServicios.classList.remove("active");

    });

    modalServicios.addEventListener("click", function(e){

        if(e.target === modalServicios){

            modalServicios.classList.remove("active");

        }

    });

    document.addEventListener("keydown", function(e){

        if(e.key === "Escape"){

            modalServicios.classList.remove("active");

        }

    });

</script>
</body>
</html>
