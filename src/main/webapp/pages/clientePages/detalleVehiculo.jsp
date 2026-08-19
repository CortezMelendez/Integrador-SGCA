<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vendor/bootstrap-scoped.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/serviciosModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/detalleVehiculo.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/perfilModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/asesorStyles/cotizacionModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/comprobanteVenta.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>


<body class="bs">

<%-- Respaldo por id_Rol (1=ADMIN, 2=AGENTE), igual que AuthFilter: comparar
     solo el texto de ADMIN.ROLES falla si ese texto no es exactamente
     "ADMIN"/"AGENTE", y esta pantalla caía al navbar de cliente por defecto. --%>
<c:set var="esAsesor" value="${fn:toUpperCase(sessionScope.usuarioLogueado.rol.rol) == 'AGENTE' or sessionScope.usuarioLogueado.rol.id_Rol == 2}" />
<c:set var="esDueno" value="${fn:toUpperCase(sessionScope.usuarioLogueado.rol.rol) == 'ADMIN' or sessionScope.usuarioLogueado.rol.id_Rol == 1}" />
<c:choose>
    <c:when test="${esDueno}"><c:set var="inicioHref" value="/nav?action=inicio" /></c:when>
    <c:when test="${esAsesor}"><c:set var="inicioHref" value="/asesor" /></c:when>
    <c:otherwise><c:set var="inicioHref" value="/cliente" /></c:otherwise>
</c:choose>

<!-- NAVBAR -->
<header class="dash-navbar">

    <div class="dash-navbar-left">
        <div class="dash-logo-placeholder" aria-hidden="true">
            <img src="${pageContext.request.contextPath}/Images/logo2-SGCA.svg" class="logo-img" width="108" />
        </div>
        <a href="${pageContext.request.contextPath}${inicioHref}" class="dash-brand">
            Concesionaria Automotriz
        </a>
    </div>

    <nav class="dash-nav-center">

        <a href="${pageContext.request.contextPath}${inicioHref}" class="dash-nav-link">
            Inicio
        </a>

        <div class="dropdown">

            <button class="dash-nav-link dropdown-btn">
                ${esAsesor or esDueno ? 'Vehículos' : 'Automóviles'} ▾
            </button>

            <div class="dropdown-menu">

                <a href="${pageContext.request.contextPath}/automoviles">Ver todos</a>
                <c:forEach var="t" items="${listaTipos}">
                    <a href="${pageContext.request.contextPath}/automoviles?tipo=${t.nombre}">${t.nombre}</a>
                </c:forEach>

            </div>

        </div>

        <%-- El dueño gestiona servicios desde "Gestión > Gestionar servicios",
             no con este modal rápido (que sí usan asesor y cliente). --%>
        <c:if test="${!esDueno}">
            <button type="button" class="dash-nav-link" id="btnAbrirServicios">
                Servicios
            </button>
        </c:if>

        <c:choose>
            <c:when test="${esDueno}">

                <a href="${pageContext.request.contextPath}/nav?action=dashboard" class="dash-nav-link">
                    Dashboard
                </a>

                <a href="${pageContext.request.contextPath}/nav?action=historial" class="dash-nav-link">
                    Historial
                </a>

            </c:when>
            <c:when test="${esAsesor}">

                <div class="dropdown">
                    <button class="dash-nav-link dropdown-btn">
                        Gestionar ▾
                    </button>
                    <div class="dropdown-menu">
                        <a href="${pageContext.request.contextPath}/gestionClienteAsesor">Gestionar Clientes</a>
                        <a href="${pageContext.request.contextPath}/gestionAutoAsesor">Registrar auto</a>
                    </div>
                </div>

                <button type="button" class="dash-nav-link" id="btnAbrirCotizacion">
                    Cotización
                </button>

                <a href="${pageContext.request.contextPath}/historialAsesor" class="dash-nav-link">
                    Historial de ventas
                </a>

            </c:when>
            <c:otherwise>

                <a href="${pageContext.request.contextPath}/comprasCliente" class="dash-nav-link">
                    Mis compras
                </a>

            </c:otherwise>
        </c:choose>

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

<!-- MODAL DESCRIPCIÓN GENERAL -->
<div class="modal-overlay" id="modalDescripcion">

    <div class="modal-box modal-box-descripcion">

        <div class="modal-header-bar">
            <span>Descripción general</span>
            <button type="button" class="modal-cerrar" id="btnCerrarDescripcion" aria-label="Cerrar">&times;</button>
        </div>

        <div class="modal-descripcion-body">
            <c:choose>
                <c:when test="${not empty vehiculo.descripcion}">
                    <p class="descripcion-texto"><c:out value="${vehiculo.descripcion}"/></p>
                </c:when>
                <c:otherwise>
                    <p class="descripcion-texto descripcion-vacia">Este vehículo todavía no tiene una descripción registrada.</p>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

</div>

<c:if test="${esAsesor}">

    <!-- MODAL ARMAR COTIZACION -->
    <div class="modal-overlay" id="modalArmarCotizacion">

        <div class="modal-box modal-box-servicios">

            <div class="modal-header-bar">
                <span>Armar cotización</span>
                <button type="button" class="modal-cerrar" id="btnCerrarArmarCotizacion" aria-label="Cerrar">&times;</button>
            </div>

            <div class="cotizacion-body">

                <div class="cotizacion-seccion">
                    <h4>Cliente</h4>
                    <select class="perfil-input" id="cotizacionCliente">
                        <option value="0">-- Selecciona un cliente --</option>
                        <c:forEach var="cl" items="${clientesAsesor}">
                            <option value="${cl.idCliente}">${cl.nombreCliente}</option>
                        </c:forEach>
                    </select>
                    <c:if test="${empty clientesAsesor}">
                        <p class="servicios-vacio">Todavía no tienes clientes registrados en tu cartera.</p>
                    </c:if>
                </div>

                <div class="cotizacion-seccion">
                    <h4>Vehículo</h4>
                    <select class="perfil-input" id="cotizacionVehiculo">
                        <option value="0" data-precio="0">-- Selecciona un vehículo --</option>
                        <option value="${vehiculo.id_Vehiculo}" data-precio="${vehiculo.precio}">
                            ${vehiculo.marca.nombre} ${vehiculo.modelos.nombre} ${vehiculo.anio} — $${vehiculo.precio}
                        </option>
                        <c:forEach var="v" items="${relacionados}">
                            <option value="${v.id_Vehiculo}" data-precio="${v.precio}">
                                ${v.marca.nombre} ${v.modelos.nombre} ${v.anio} — $${v.precio}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="cotizacion-seccion">
                    <h4>Servicios adicionales</h4>
                    <div class="cotizacion-servicios-lista" id="cotizacionServiciosLista">
                        <c:forEach var="s" items="${servicios}">
                            <label class="cotizacion-servicio-item">
                                <input type="checkbox" class="cotizacion-servicio-checkbox" value="${s.id_servicio}" data-precio="${s.precio}">
                                <span class="cotizacion-servicio-nombre">${s.nombre}</span>
                                <span class="cotizacion-servicio-tipo">${s.tipoServicio.nombre}</span>
                                <span class="cotizacion-servicio-precio">$${s.precio}</span>
                            </label>
                        </c:forEach>
                        <c:if test="${empty servicios}">
                            <p class="servicios-vacio">No hay servicios disponibles.</p>
                        </c:if>
                    </div>
                </div>

                <div class="cotizacion-total">
                    <span>Total estimado</span>
                    <span id="cotizacionTotal">$0</span>
                </div>

                <p class="perfil-error" id="errorCotizacion"></p>
                <p class="perfil-exito" id="exitoCotizacion"></p>

                <div class="perfil-acciones">
                    <button type="button" class="btn-perfil-guardar" id="btnRegistrarVenta">Registrar venta</button>
                </div>

            </div>

        </div>

    </div>

</c:if>

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


<!-- DETALLE DEL VEHICULO -->
<main class="detalle-page">

    <p class="detalle-breadcrumb">
        <a href="${pageContext.request.contextPath}/automoviles?tipo=${vehiculo.tipoVehiculo.nombre}">${esAsesor or esDueno ? 'Vehículos' : 'Automóviles'}</a>
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
                     src="${not empty vehiculo.foto_Portada ? pageContext.request.contextPath.concat('/Images/imagesAutos/').concat(vehiculo.foto_Portada) : pageContext.request.contextPath.concat('/Images/car.svg')}"
                     alt="${vehiculo.marca.nombre} ${vehiculo.modelos.nombre}">

                <c:if test="${not empty galeria}">
                    <button type="button" class="galeria-flecha galeria-flecha-der" id="btnGaleriaSiguiente" aria-label="Imagen siguiente">&#8594;</button>
                </c:if>

            </div>

            <c:if test="${not empty galeria}">
                <div class="galeria-miniaturas" id="galeriaMiniaturas">

                    <img class="miniatura activa"
                         src="${not empty vehiculo.foto_Portada ? pageContext.request.contextPath.concat('/Images/imagesAutos/').concat(vehiculo.foto_Portada) : pageContext.request.contextPath.concat('/Images/car.svg')}"
                         data-src="${not empty vehiculo.foto_Portada ? pageContext.request.contextPath.concat('/Images/imagesAutos/').concat(vehiculo.foto_Portada) : pageContext.request.contextPath.concat('/Images/car.svg')}"
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
                                src="${not empty r.foto_Portada ? pageContext.request.contextPath.concat('/Images/imagesAutos/').concat(r.foto_Portada) : pageContext.request.contextPath.concat('/Images/car.svg')}"
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


    // MODAL SERVICIOS (el dueño no tiene el botón "Servicios" en el navbar,
    // así que btnAbrirServicios no existe en su caso)

    const modalServicios = document.getElementById("modalServicios");
    const btnAbrirServicios = document.getElementById("btnAbrirServicios");
    const btnCerrarServicios = document.getElementById("btnCerrarServicios");

    if (btnAbrirServicios) {
        btnAbrirServicios.addEventListener("click", function(e){
            e.stopPropagation();
            modalServicios.classList.add("active");
        });
    }

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

<c:if test="${esAsesor}">
<script>

    // MODAL ARMAR COTIZACION

    const modalArmarCotizacion = document.getElementById("modalArmarCotizacion");
    const btnAbrirCotizacion = document.getElementById("btnAbrirCotizacion");
    const btnCerrarArmarCotizacion = document.getElementById("btnCerrarArmarCotizacion");
    const cotizacionCliente = document.getElementById("cotizacionCliente");
    const cotizacionVehiculo = document.getElementById("cotizacionVehiculo");
    const cotizacionCheckboxes = document.querySelectorAll(".cotizacion-servicio-checkbox");
    const cotizacionTotal = document.getElementById("cotizacionTotal");
    const btnRegistrarVenta = document.getElementById("btnRegistrarVenta");
    const errorCotizacion = document.getElementById("errorCotizacion");
    const exitoCotizacion = document.getElementById("exitoCotizacion");

    function calcularTotalCotizacion(){
        const opcionVehiculo = cotizacionVehiculo.selectedOptions[0];
        let total = opcionVehiculo ? (parseFloat(opcionVehiculo.dataset.precio) || 0) : 0;

        cotizacionCheckboxes.forEach(function(cb){
            if (cb.checked) {
                total += parseFloat(cb.dataset.precio) || 0;
            }
        });

        cotizacionTotal.textContent = "$" + total.toLocaleString("es-MX");
    }

    btnAbrirCotizacion.addEventListener("click", function(e){
        e.stopPropagation();
        cotizacionCliente.value = "0";
        cotizacionVehiculo.value = "0";
        cotizacionCheckboxes.forEach(function(cb){ cb.checked = false; });
        errorCotizacion.textContent = "";
        exitoCotizacion.textContent = "";
        calcularTotalCotizacion();
        modalArmarCotizacion.classList.add("active");
    });

    btnCerrarArmarCotizacion.addEventListener("click", function(){
        modalArmarCotizacion.classList.remove("active");
    });

    modalArmarCotizacion.addEventListener("click", function(e){
        if(e.target === modalArmarCotizacion){
            modalArmarCotizacion.classList.remove("active");
        }
    });

    cotizacionVehiculo.addEventListener("change", calcularTotalCotizacion);
    cotizacionCheckboxes.forEach(function(cb){
        cb.addEventListener("change", calcularTotalCotizacion);
    });

    btnRegistrarVenta.addEventListener("click", async function(){
        errorCotizacion.textContent = "";
        exitoCotizacion.textContent = "";

        const idCliente = cotizacionCliente.value;
        const idVehiculo = cotizacionVehiculo.value;

        if (!idCliente || idCliente === "0") {
            errorCotizacion.textContent = "Selecciona un cliente.";
            return;
        }
        if (!idVehiculo || idVehiculo === "0") {
            errorCotizacion.textContent = "Selecciona un vehículo.";
            return;
        }

        const datos = new URLSearchParams();
        datos.append("idCliente", idCliente);
        datos.append("idVehiculo", idVehiculo);
        cotizacionCheckboxes.forEach(function(cb){
            if (cb.checked) {
                datos.append("idsServicios", cb.value);
            }
        });

        try {
            const respuesta = await fetch("${pageContext.request.contextPath}/registrarVentaAsesor", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: datos.toString()
            });

            if (respuesta.ok) {
                const comprobante = await respuesta.json();
                modalArmarCotizacion.classList.remove("active");
                mostrarComprobanteVenta(comprobante, function(){ window.location.reload(); });
            } else {
                errorCotizacion.textContent = (await respuesta.text()).trim();
            }
        } catch (err) {
            errorCotizacion.textContent = "No se pudo contactar al servidor. Intenta de nuevo.";
        }
    });

    document.addEventListener("keydown", function(e){
        if(e.key === "Escape"){
            modalArmarCotizacion.classList.remove("active");
        }
    });

</script>
</c:if>

<script>
    window.PERFIL_CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/comprobanteVenta.js"></script>
<script src="${pageContext.request.contextPath}/js/clienteJS/perfilModal.js"></script>
</body>
</html>
