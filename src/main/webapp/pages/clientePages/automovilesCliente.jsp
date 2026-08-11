<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/perfilModal.css">
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

<script>
    window.PERFIL_CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/clienteJS/perfilModal.js"></script>
</body>
</html>
