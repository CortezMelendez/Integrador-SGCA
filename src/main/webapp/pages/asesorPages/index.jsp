<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<html lang="es">

<head>

    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Panel del Asesor · Gestionaria Automotriz</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/carruselIndex.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/serviciosModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/perfilModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/asesorStyles/cotizacionModal.css">
</head>


<body>


<!-- NAVBAR -->
<header class="dash-navbar">

    <div class="dash-navbar-left">
        <a href="${pageContext.request.contextPath}/asesor" class="dash-brand">
            Gestionaria Automotriz
        </a>
    </div>

    <nav class="dash-nav-center">

        <div class="dropdown">

            <button class="dash-nav-link dropdown-btn">
                Vehículos ▾
            </button>

            <div class="dropdown-menu">
                <a href="${pageContext.request.contextPath}/automoviles">Ver todos</a>
                <c:forEach var="t" items="${listaTipos}">
                    <a href="${pageContext.request.contextPath}/automoviles?tipo=${t.nombre}">${t.nombre}</a>
                </c:forEach>
                <a href="${pageContext.request.contextPath}/gestionAutoAsesor">Registrar vehículo</a>
            </div>

        </div>

        <button type="button" class="dash-nav-link" id="btnAbrirServicios">
            Servicios
        </button>

        <a href="${pageContext.request.contextPath}/gestionClienteAsesor" class="dash-nav-link">
            Clientes
        </a>

        <a href="${pageContext.request.contextPath}/cotizacionesAsesor" class="dash-nav-link">
            Cotizaciones
        </a>

        <a href="${pageContext.request.contextPath}/historialAsesor" class="dash-nav-link">
            Historial de ventas
        </a>

        <div class="dropdown">
            <button class="dash-nav-link dropdown-btn">
                Configuración ▾
            </button>
            <div class="dropdown-menu">

                <a href="#" id="btnAbrirPerfil">Perfil</a>

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


<!-- MODAL PERFIL -->
<div class="modal-overlay" id="modalPerfil">

    <div class="modal-box modal-box-perfil">

        <!-- VER PERFIL -->
        <div class="perfil-paso" id="perfilVista">

            <div class="perfil-header">
                <h2>Ver Perfil</h2>
                <button type="button" class="modal-cerrar" data-cerrar-perfil aria-label="Cerrar">&times;</button>
            </div>

            <div class="perfil-identidad">
                <div class="perfil-identidad-datos">
                    <h3 class="perfil-nombre">${sessionScope.usuarioLogueado.nombre} ${sessionScope.usuarioLogueado.apellidoPaterno} ${sessionScope.usuarioLogueado.apellidoMaterno}</h3>
                    <p class="perfil-folio">Folio #${sessionScope.usuarioLogueado.id_usuario}</p>
                    <p class="perfil-correo-chico">${sessionScope.usuarioLogueado.correo}</p>
                </div>
                <button type="button" class="perfil-btn-editar" id="btnEditarPerfil" aria-label="Editar perfil">&#9998;</button>
            </div>

            <div class="perfil-seccion">
                <h4>Información personal</h4>
                <div class="perfil-grid">
                    <div class="perfil-campo">
                        <span class="perfil-label">Miembro desde</span>
                        <span class="perfil-valor"><fmt:formatDate value="${sessionScope.usuarioLogueado.fechaRegistro}" pattern="dd/MM/yyyy"/></span>
                    </div>
                    <div class="perfil-campo">
                        <span class="perfil-label">Teléfono</span>
                        <span class="perfil-valor perfil-valor-telefono">${sessionScope.usuarioLogueado.telefono}</span>
                    </div>
                    <div class="perfil-campo">
                        <span class="perfil-label">RFC</span>
                        <span class="perfil-valor">${sessionScope.usuarioLogueado.rfc}</span>
                    </div>
                    <div class="perfil-campo">
                        <span class="perfil-label">CURP</span>
                        <span class="perfil-valor">${sessionScope.usuarioLogueado.curp}</span>
                    </div>
                </div>
            </div>

            <div class="perfil-seccion">
                <h4>Información de contacto</h4>
                <div class="perfil-grid perfil-grid-1">
                    <div class="perfil-campo">
                        <span class="perfil-label">Correo principal</span>
                        <span class="perfil-valor perfil-valor-correo">${sessionScope.usuarioLogueado.correo}</span>
                    </div>
                </div>
            </div>

            <button type="button" class="btn-atras-perfil" data-cerrar-perfil>
                &#8592; Atrás
            </button>

        </div>

        <!-- EDITAR PERFIL -->
        <div class="perfil-paso oculto" id="perfilEditar">

            <div class="perfil-header">
                <h2>Editar Perfil</h2>
                <button type="button" class="modal-cerrar" data-cerrar-perfil aria-label="Cerrar">&times;</button>
            </div>

            <form id="formEditarPerfil" novalidate>

                <div class="perfil-form-row">
                    <div class="perfil-campo-edit">
                        <label class="perfil-form-label" for="perfilNombre">Nombre</label>
                        <input class="perfil-input" type="text" id="perfilNombre" name="nombre" maxlength="50" value="${sessionScope.usuarioLogueado.nombre}">
                    </div>
                    <div class="perfil-campo-edit">
                        <label class="perfil-form-label" for="perfilApellidoPaterno">Apellido paterno</label>
                        <input class="perfil-input" type="text" id="perfilApellidoPaterno" name="apellidoPaterno" maxlength="30" value="${sessionScope.usuarioLogueado.apellidoPaterno}">
                    </div>
                </div>

                <div class="perfil-campo-edit">
                    <label class="perfil-form-label" for="perfilApellidoMaterno">Apellido materno</label>
                    <input class="perfil-input" type="text" id="perfilApellidoMaterno" name="apellidoMaterno" maxlength="30" value="${sessionScope.usuarioLogueado.apellidoMaterno}">
                </div>

                <div class="perfil-form-row">
                    <div class="perfil-campo-edit">
                        <label class="perfil-form-label">RFC</label>
                        <input class="perfil-input perfil-input-bloqueado" type="text" value="${sessionScope.usuarioLogueado.rfc}" disabled>
                    </div>
                    <div class="perfil-campo-edit">
                        <label class="perfil-form-label">CURP</label>
                        <input class="perfil-input perfil-input-bloqueado" type="text" value="${sessionScope.usuarioLogueado.curp}" disabled>
                    </div>
                </div>
                <p class="perfil-nota">El RFC y la CURP no se pueden modificar una vez registrados.</p>

                <div class="perfil-campo-edit">
                    <label class="perfil-form-label" for="perfilTelefono">Número de contacto</label>
                    <input class="perfil-input" type="tel" id="perfilTelefono" name="telefono" maxlength="10" value="${sessionScope.usuarioLogueado.telefono}">
                </div>

                <div class="perfil-campo-edit">
                    <label class="perfil-form-label" for="perfilCorreo">Correo electrónico</label>
                    <input class="perfil-input" type="email" id="perfilCorreo" name="correo" maxlength="100" value="${sessionScope.usuarioLogueado.correo}">
                </div>

                <hr class="perfil-divisor">

                <p class="perfil-subtitulo">Cambiar contraseña (opcional)</p>

                <div class="perfil-campo-edit">
                    <label class="perfil-form-label" for="perfilPasswordActual">Contraseña actual</label>
                    <input class="perfil-input" type="password" id="perfilPasswordActual" name="passwordActual" autocomplete="current-password">
                </div>

                <div class="perfil-form-row">
                    <div class="perfil-campo-edit">
                        <label class="perfil-form-label" for="perfilNuevaPassword">Nueva contraseña</label>
                        <input class="perfil-input" type="password" id="perfilNuevaPassword" name="nuevaPassword" autocomplete="new-password">
                    </div>
                    <div class="perfil-campo-edit">
                        <label class="perfil-form-label" for="perfilConfirmarPassword">Confirmar nueva contraseña</label>
                        <input class="perfil-input" type="password" id="perfilConfirmarPassword" name="confirmarPassword" autocomplete="new-password">
                    </div>
                </div>

                <p class="perfil-error" id="errorPerfil"></p>
                <p class="perfil-exito" id="exitoPerfil"></p>

                <div class="perfil-acciones">
                    <button type="button" class="btn-perfil-cancelar" id="btnCancelarEdicion">Cancelar</button>
                    <button type="submit" class="btn-perfil-guardar">Guardar cambios</button>
                </div>

            </form>

        </div>

    </div>

</div>


<!-- HERO -->

<main>

    <section class="hero">

        <div class="hero-content">

            <h1 class="hero-heading">
                Encuentra<br>
                el auto
                <em class="hero-accent">
                    ideal
                </em>
                <br>
                para tu cliente.
            </h1>

            <p class="hero-description">
                Consulta el catálogo de vehículos, revisa los servicios disponibles y da seguimiento a tus cotizaciones y ventas.
            </p>

        </div>

        <div class="hero-logo">
            <div class="logo-placeholder">
                <img
                        src="${pageContext.request.contextPath}/Images/logo-SGCA.svg"
                        class="logo-img"
                        width="350">
            </div>
        </div>

    </section>

    <section class="carrusel-section" id="carrusel">

        <div class="carrusel-header">
            <h2>Autos disponibles</h2>
            <div class="carrusel-controls">
                <button type="button" class="carrusel-btn" id="btnPrev" aria-label="Anterior">&#8249;</button>
                <button type="button" class="carrusel-btn" id="btnNext" aria-label="Siguiente">&#8250;</button>
            </div>
        </div>

        <div class="carrusel-track" id="carruselTrack">
            <c:forEach var="v" items="${vehiculos}">
                <a class="auto-card" href="${pageContext.request.contextPath}/detalleVehiculo?id=${v.id_Vehiculo}">
                    <c:choose>
                        <c:when test="${not empty v.foto_Portada}">
                            <img class="auto-card-img" src="${pageContext.request.contextPath}/Images/imagesAutos/${v.foto_Portada}" alt="${v.marca.nombre} ${v.modelos.nombre}" />
                        </c:when>
                        <c:otherwise>
                            <div class="auto-card-img"></div>
                        </c:otherwise>
                    </c:choose>
                    <div class="auto-card-info">
                        <span class="auto-card-marca">${v.marca.nombre} ${v.modelos.nombre}</span>
                        <span class="auto-card-modelo">Año ${v.anio}</span>
                        <span class="auto-card-precio">$<fmt:formatNumber value="${v.precio}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </div>
                </a>
            </c:forEach>
            <c:if test="${empty vehiculos}">
                <p>No hay vehículos disponibles por el momento.</p>
            </c:if>
        </div>

        <div class="carrusel-scrollbar">
            <div class="carrusel-scrollbar-thumb" id="scrollThumb"></div>
        </div>

    </section>

</main>


<!-- CATALOGO -->
<section class="catalogo">

    <div class="catalogo-header">
        <h2 class="catalogo-titulo">
            Vehículos recién agregados
        </h2>
    </div>

    <div class="cards-container">

        <c:forEach var="v" items="${vehiculos}">

            <div class="card-auto">

                <img
                        class="card-imagen"
                        src="${pageContext.request.contextPath}/Images/imagesAutos/${v.foto_Portada}"
                        alt="Vehículo">

                <h3>
                        ${v.marca.nombre}
                        ${v.modelos.nombre}
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

        <c:if test="${empty vehiculos}">
            <p class="servicios-vacio">Por el momento no hay vehículos disponibles.</p>
        </c:if>

    </div>

</section>

<footer class="footer">
    <p>
        © 2026 SGCA · Todos los derechos reservados
    </p>
</footer>

<script src="${pageContext.request.contextPath}/js/duenioJS/carrusel.js"></script>

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

    document.addEventListener("keydown", function(e){
        if(e.key === "Escape"){
            modalServicios.classList.remove("active");
        }
    });

</script>

<script>
    window.PERFIL_CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/clienteJS/perfilModal.js"></script>
</body>
</html>
