<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html lang="es">

<head>

    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>${empty tipoSeleccionado ? 'Automóviles' : tipoSeleccionado} · Gestionaria Automotriz</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/serviciosModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/automovilesCliente.css">
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

                <a href="${pageContext.request.contextPath}/automoviles"
                   class="${empty tipoSeleccionado ? 'activo' : ''}">Ver todos</a>
                <c:forEach var="t" items="${listaTipos}">
                    <a href="${pageContext.request.contextPath}/automoviles?tipo=${t.nombre}"
                       class="${tipoSeleccionado == t.nombre ? 'activo' : ''}">${t.nombre}</a>
                </c:forEach>

            </div>

        </div>

        <button type="button" class="dash-nav-link" id="btnAbrirServicios">
            Servicios
        </button>

        <a href="${pageContext.request.contextPath}/comprasCliente" class="dash-nav-link">
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


<!-- CATALOGO DE AUTOMOVILES -->
<main class="automoviles-page">

    <section class="automoviles-header">
        <h1>${empty tipoSeleccionado ? 'Automóviles' : tipoSeleccionado}</h1>
        <p>Explora todos los modelos disponibles y consulta sus características</p>
    </section>

    <section class="automoviles-toolbar">

        <form class="automoviles-buscador" method="get" action="${pageContext.request.contextPath}/automoviles">

            <c:if test="${not empty tipoSeleccionado}">
                <input type="hidden" name="tipo" value="${tipoSeleccionado}">
            </c:if>
            <c:if test="${not empty ordenSeleccionado}">
                <input type="hidden" name="orden" value="${ordenSeleccionado}">
            </c:if>

            <input
                    type="text"
                    name="buscar"
                    value="${buscarValor}"
                    placeholder="Buscar por marca o modelo..."
                    aria-label="Buscar por marca o modelo">

            <button type="submit" aria-label="Buscar">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="7"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
            </button>

        </form>

        <div class="dropdown">

            <button type="button" class="btn-filtrar dropdown-btn">
                Filtrar
            </button>

            <div class="dropdown-menu dropdown-menu-filtro">

                <c:url var="urlPrecioDesc" value="/automoviles">
                    <c:if test="${not empty tipoSeleccionado}"><c:param name="tipo" value="${tipoSeleccionado}"/></c:if>
                    <c:if test="${not empty buscarValor}"><c:param name="buscar" value="${buscarValor}"/></c:if>
                    <c:param name="orden" value="precio_desc"/>
                </c:url>
                <c:url var="urlPrecioAsc" value="/automoviles">
                    <c:if test="${not empty tipoSeleccionado}"><c:param name="tipo" value="${tipoSeleccionado}"/></c:if>
                    <c:if test="${not empty buscarValor}"><c:param name="buscar" value="${buscarValor}"/></c:if>
                    <c:param name="orden" value="precio_asc"/>
                </c:url>
                <c:url var="urlAz" value="/automoviles">
                    <c:if test="${not empty tipoSeleccionado}"><c:param name="tipo" value="${tipoSeleccionado}"/></c:if>
                    <c:if test="${not empty buscarValor}"><c:param name="buscar" value="${buscarValor}"/></c:if>
                    <c:param name="orden" value="az"/>
                </c:url>
                <c:url var="urlRecientes" value="/automoviles">
                    <c:if test="${not empty tipoSeleccionado}"><c:param name="tipo" value="${tipoSeleccionado}"/></c:if>
                    <c:if test="${not empty buscarValor}"><c:param name="buscar" value="${buscarValor}"/></c:if>
                    <c:param name="orden" value="recientes"/>
                </c:url>

                <a href="${urlPrecioDesc}" class="${ordenSeleccionado == 'precio_desc' ? 'activo' : ''}">Mayor precio</a>
                <a href="${urlPrecioAsc}" class="${ordenSeleccionado == 'precio_asc' ? 'activo' : ''}">Menor precio</a>
                <a href="${urlAz}" class="${ordenSeleccionado == 'az' ? 'activo' : ''}">A-Z</a>
                <a href="${urlRecientes}" class="${ordenSeleccionado == 'recientes' ? 'activo' : ''}">Recién agregados</a>

            </div>

        </div>

    </section>

    <section class="cards-container">

        <c:forEach var="v" items="${automoviles}">
            <div class="card-auto">
                <img
                        class="card-imagen"
                        src="${pageContext.request.contextPath}/Images/imagesAutos/${v.foto_Portada}"
                        alt="Vehículo">

                <h3>
                        ${v.marca.nombre} ${v.modelos.nombre}
                </h3>

                <p>
                    Año: ${v.anio}
                </p>

                <h2>
                    $${v.precio}
                </h2>

                <a class="btn-detalles"
                   href="${pageContext.request.contextPath}/detalleVehiculo?id=${v.id_Vehiculo}">
                    Ver detalles
                </a>
            </div>
        </c:forEach>

        <c:if test="${empty automoviles}">
            <p class="automoviles-vacio">No se encontraron automóviles para esta búsqueda.</p>
        </c:if>

    </section>

</main>


<div class="automoviles-atras-wrap">
    <a href="${pageContext.request.contextPath}/cliente" class="btn-atras">
        <span class="btn-atras-icon">&#8617;</span> Regresar
    </a>
</div>


<footer class="footer">
    <p>
        © 2026 SGCA · Todos los derechos reservados
    </p>
</footer>


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
