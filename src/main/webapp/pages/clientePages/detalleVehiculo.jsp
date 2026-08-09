<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html lang="es">

<head>

    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>${vehiculo.marca.nombre} ${vehiculo.modelos.nombre} · Gestionaria Automotriz</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/serviciosModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/detalleVehiculo.css">
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

<!-- MODAL DESCRIPCIÓN GENERAL (contenido pendiente) -->
<div class="modal-overlay" id="modalDescripcion">

    <div class="modal-box modal-box-descripcion">

        <div class="modal-header-bar">
            <span>Descripción general</span>
            <button type="button" class="modal-cerrar" id="btnCerrarDescripcion" aria-label="Cerrar">&times;</button>
        </div>

        <div class="modal-descripcion-body">
        </div>

    </div>

</div>


<!-- DETALLE DEL VEHICULO -->
<main class="detalle-page">

    <p class="detalle-breadcrumb">
        <a href="${pageContext.request.contextPath}/automoviles?tipo=${vehiculo.tipoVehiculo.nombre}">Automóviles</a>
        › ${vehiculo.marca.nombre} ${vehiculo.modelos.nombre} ${vehiculo.anio} · ${vehiculo.tipoVehiculo.nombre}
    </p>

    <div class="detalle-grid">

        <!-- GALERIA -->
        <div class="detalle-galeria">

            <div class="galeria-principal">

                <c:if test="${not empty galeria}">
                    <button type="button" class="galeria-flecha galeria-flecha-izq" id="btnGaleriaAnterior" aria-label="Imagen anterior">&#8592;</button>
                </c:if>

                <img id="imagenPrincipal"
                     src="${pageContext.request.contextPath}/Images/imagesAutos/${vehiculo.foto_Portada}"
                     alt="${vehiculo.marca.nombre} ${vehiculo.modelos.nombre}">

                <c:if test="${not empty galeria}">
                    <button type="button" class="galeria-flecha galeria-flecha-der" id="btnGaleriaSiguiente" aria-label="Imagen siguiente">&#8594;</button>
                </c:if>

            </div>

            <c:if test="${not empty galeria}">
                <div class="galeria-miniaturas" id="galeriaMiniaturas">

                    <img class="miniatura activa"
                         src="${pageContext.request.contextPath}/Images/imagesAutos/${vehiculo.foto_Portada}"
                         data-src="${pageContext.request.contextPath}/Images/imagesAutos/${vehiculo.foto_Portada}"
                         alt="Miniatura">

                    <c:forEach var="img" items="${galeria}">
                        <img class="miniatura"
                             src="${pageContext.request.contextPath}/Images/imagesAutos/${img.rutaImagen}"
                             data-src="${pageContext.request.contextPath}/Images/imagesAutos/${img.rutaImagen}"
                             alt="Miniatura">
                    </c:forEach>

                </div>
            </c:if>

        </div>

        <!-- INFO -->
        <div class="detalle-info">

            <span class="badge-disponibilidad ${vehiculo.disponible == 1 ? 'disponible' : 'no-disponible'}">
                ${vehiculo.disponible == 1 ? 'Disponible' : 'No disponible'}
            </span>

            <h1 class="detalle-titulo">
                ${vehiculo.marca.nombre} ${vehiculo.modelos.nombre} ${vehiculo.anio} · ${vehiculo.tipoVehiculo.nombre}
            </h1>

            <p class="detalle-precio">$${vehiculo.precio}</p>

            <c:if test="${not empty vehiculo.placa}">
                <span class="detalle-placa">Placa: ${vehiculo.placa}</span>
            </c:if>

            <div class="detalle-campos">

                <div class="detalle-campo">
                    <span class="detalle-campo-label">Marca</span>
                    <span class="detalle-campo-valor">${vehiculo.marca.nombre}</span>
                </div>

                <div class="detalle-campo">
                    <span class="detalle-campo-label">Modelo</span>
                    <span class="detalle-campo-valor">${vehiculo.modelos.nombre}</span>
                </div>

                <div class="detalle-campo">
                    <span class="detalle-campo-label">Color</span>
                    <span class="detalle-campo-valor">${vehiculo.color}</span>
                </div>

                <div class="detalle-campo">
                    <span class="detalle-campo-label">Año</span>
                    <span class="detalle-campo-valor">${vehiculo.anio}</span>
                </div>

                <div class="detalle-campo">
                    <span class="detalle-campo-label">Tipo</span>
                    <span class="detalle-campo-valor">${vehiculo.tipoVehiculo.nombre}</span>
                </div>

                <div class="detalle-campo">
                    <span class="detalle-campo-label">Estado</span>
                    <span class="detalle-campo-valor ${vehiculo.disponible == 1 ? 'texto-disponible' : 'texto-no-disponible'}">
                        ${vehiculo.disponible == 1 ? 'Disponible' : 'No disponible'}
                    </span>
                </div>

            </div>

            <button type="button" class="btn-descripcion" id="btnDescripcionGeneral">Descripción General</button>

        </div>

    </div>

    <!-- VEHICULOS RELACIONADOS -->
    <section class="relacionados">

        <h2 class="relacionados-titulo">Vehículos relacionados — ${vehiculo.tipoVehiculo.nombre}</h2>

        <div class="relacionados-wrap">

            <button type="button" class="relacionados-flecha relacionados-flecha-izq" id="btnRelacionadosAnterior" aria-label="Ver anteriores">&#8592;</button>

            <div class="relacionados-scroll" id="relacionadosScroll">

                <c:forEach var="r" items="${relacionados}">
                    <div class="card-auto">
                        <img
                                class="card-imagen"
                                src="${pageContext.request.contextPath}/Images/imagesAutos/${r.foto_Portada}"
                                alt="Vehículo">

                        <h3>
                                ${r.marca.nombre} ${r.modelos.nombre}
                        </h3>

                        <p>
                            Año: ${r.anio}
                        </p>

                        <h2>
                            $${r.precio}
                        </h2>

                        <a class="btn-detalles"
                           href="${pageContext.request.contextPath}/detalleVehiculo?id=${r.id_Vehiculo}">
                            Ver detalles
                        </a>
                    </div>
                </c:forEach>

                <c:if test="${empty relacionados}">
                    <p class="relacionados-vacio">No hay más vehículos de este tipo por ahora.</p>
                </c:if>

            </div>

            <button type="button" class="relacionados-flecha relacionados-flecha-der" id="btnRelacionadosSiguiente" aria-label="Ver siguientes">&#8594;</button>

        </div>

    </section>

</main>


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

    document.addEventListener("click", function(){
        document.querySelectorAll(".dropdown-menu")
            .forEach(menu => menu.classList.remove("show"));
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


    // MODAL DESCRIPCIÓN GENERAL

    const modalDescripcion = document.getElementById("modalDescripcion");
    const btnDescripcionGeneral = document.getElementById("btnDescripcionGeneral");
    const btnCerrarDescripcion = document.getElementById("btnCerrarDescripcion");

    btnDescripcionGeneral.addEventListener("click", function(){
        modalDescripcion.classList.add("active");
    });

    btnCerrarDescripcion.addEventListener("click", function(){
        modalDescripcion.classList.remove("active");
    });

    modalDescripcion.addEventListener("click", function(e){
        if(e.target === modalDescripcion){
            modalDescripcion.classList.remove("active");
        }
    });

    document.addEventListener("keydown", function(e){
        if(e.key === "Escape"){
            modalServicios.classList.remove("active");
            modalDescripcion.classList.remove("active");
        }
    });


    // GALERIA DE IMAGENES

    const imagenPrincipal = document.getElementById("imagenPrincipal");
    const miniaturas = document.querySelectorAll(".miniatura");

    let indiceActual = 0;

    function mostrarImagen(indice) {
        indiceActual = (indice + miniaturas.length) % miniaturas.length;
        imagenPrincipal.src = miniaturas[indiceActual].dataset.src;

        miniaturas.forEach((min, i) => {
            min.classList.toggle("activa", i === indiceActual);
        });
    }

    miniaturas.forEach((min, i) => {
        min.addEventListener("click", () => mostrarImagen(i));
    });

    const btnGaleriaAnterior = document.getElementById("btnGaleriaAnterior");
    const btnGaleriaSiguiente = document.getElementById("btnGaleriaSiguiente");

    if (btnGaleriaAnterior) {
        btnGaleriaAnterior.addEventListener("click", () => mostrarImagen(indiceActual - 1));
    }
    if (btnGaleriaSiguiente) {
        btnGaleriaSiguiente.addEventListener("click", () => mostrarImagen(indiceActual + 1));
    }


    // VEHICULOS RELACIONADOS: desplazamiento horizontal

    const relacionadosScroll = document.getElementById("relacionadosScroll");
    const btnRelacionadosAnterior = document.getElementById("btnRelacionadosAnterior");
    const btnRelacionadosSiguiente = document.getElementById("btnRelacionadosSiguiente");

    btnRelacionadosAnterior.addEventListener("click", function(){
        relacionadosScroll.scrollBy({ left: -320, behavior: "smooth" });
    });

    btnRelacionadosSiguiente.addEventListener("click", function(){
        relacionadosScroll.scrollBy({ left: 320, behavior: "smooth" });
    });

</script>
</body>
</html>
