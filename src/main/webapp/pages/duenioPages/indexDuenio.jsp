<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Concesionaria Automotriz</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/carruselIndex.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/gestiones.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/perfilModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vendor/bootstrap-scoped.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>

<body class="bs">

<!-- NAVBAR -->
<header class="dash-navbar">

    <div class="dash-navbar-left">
        <span class="dash-brand">Concesionaria Automotriz</span>
    </div>

    <nav class="dash-nav-center">
        <a href="${pageContext.request.contextPath}/nav?action=inicio" class="dash-nav-link active">Inicio</a>
        <div class="dropdown">
            <button type="button" class="dash-nav-link dropdown-btn">Vehículos ▾</button>
            <div class="dropdown-menu">
                <a href="${pageContext.request.contextPath}/automoviles">Ver todos</a>
                <c:forEach var="t" items="${listaTiposVehiculo}">
                    <a href="${pageContext.request.contextPath}/automoviles?tipo=${t.nombre}">${t.nombre}</a>
                </c:forEach>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/nav?action=dashboard" class="dash-nav-link">Dashboard</a>
        <a href="${pageContext.request.contextPath}/nav?action=historial" class="dash-nav-link">Historial</a>

        <div class="dropdown" id="menuConfigDuenio">
            <button type="button" class="dash-nav-link dropdown-btn">Configuración ▾</button>
            <div class="dropdown-menu">
                <a href="#" id="btnAbrirPerfil">Perfil</a>
                <a href="${pageContext.request.contextPath}/btn?action=cerrarSesionTodos">Cerrar sesión</a>
            </div>
        </div>
    </nav>

</header>


<!-- Sección principal con presentación y logo -->
<main>

    <section class="hero">

        <div class="hero-content">

            <h1 class="hero-heading">
                El auto<br>
                que
                <em class="hero-accent">
                    mereces
                </em>
                <br>
                está aquí.
            </h1>

            <p class="hero-description">
                Accede al catálogo más completo, gestiona tus servicios y encuentra el vehículo ideal con la asesoría de nuestros expertos.
            </p>

        </div>

        <div class="hero-logo">

            <div class="logo-placeholder">

                <img src="${pageContext.request.contextPath}/Images/logo-SGCA.svg"
                     class="logo-img"
                     width="350">

            </div>

        </div>

    </section>

    <!-- Carrusel "Lo más nuevo" -->
    <section class="carrusel-section">

        <div class="carrusel-header">
            <h2>Lo más nuevo</h2>
            <div class="carrusel-controls">
                <button type="button" class="carrusel-btn carrusel-prev" aria-label="Anterior">&#8249;</button>
                <button type="button" class="carrusel-btn carrusel-next" aria-label="Siguiente">&#8250;</button>
            </div>
        </div>

        <div class="carrusel-track">
            <c:forEach var="v" items="${vehiculosNuevos}">
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
            <c:if test="${empty vehiculosNuevos}">
                <p>No hay vehículos disponibles por el momento.</p>
            </c:if>
        </div>

        <div class="carrusel-scrollbar">
            <div class="carrusel-scrollbar-thumb"></div>
        </div>

    </section>

</main>


<!-- Carrusel "Lo más accesible" -->
<section class="carrusel-section">

    <div class="carrusel-header">
        <h2>Lo más accesible</h2>
        <div class="carrusel-controls">
            <button type="button" class="carrusel-btn carrusel-prev" aria-label="Anterior">&#8249;</button>
            <button type="button" class="carrusel-btn carrusel-next" aria-label="Siguiente">&#8250;</button>
        </div>
    </div>

    <div class="carrusel-track">
        <c:forEach var="v" items="${vehiculosAccesibles}">
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
        <c:if test="${empty vehiculosAccesibles}">
            <p>No hay vehículos por debajo de este rango de precio por el momento.</p>
        </c:if>
    </div>

    <div class="carrusel-scrollbar">
        <div class="carrusel-scrollbar-thumb"></div>
    </div>

</section>


<!-- Carrusel "Recién agregado" -->
<section class="carrusel-section">

    <div class="carrusel-header">
        <h2>Recién agregado</h2>
        <div class="carrusel-controls">
            <button type="button" class="carrusel-btn carrusel-prev" aria-label="Anterior">&#8249;</button>
            <button type="button" class="carrusel-btn carrusel-next" aria-label="Siguiente">&#8250;</button>
        </div>
    </div>

    <div class="carrusel-track">
        <c:forEach var="v" items="${vehiculosRecientes}">
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
        <c:if test="${empty vehiculosRecientes}">
            <p>No hay vehículos disponibles por el momento.</p>
        </c:if>
    </div>

    <div class="carrusel-scrollbar">
        <div class="carrusel-scrollbar-thumb"></div>
    </div>

</section>


<!-- Carrusel "Destacado" -->
<section class="carrusel-section">

    <div class="carrusel-header">
        <h2>Destacado</h2>
        <div class="carrusel-controls">
            <button type="button" class="carrusel-btn carrusel-prev" aria-label="Anterior">&#8249;</button>
            <button type="button" class="carrusel-btn carrusel-next" aria-label="Siguiente">&#8250;</button>
        </div>
    </div>

    <div class="carrusel-track">
        <c:forEach var="v" items="${vehiculosDestacados}">
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
        <c:if test="${empty vehiculosDestacados}">
            <p>No hay vehículos disponibles por el momento.</p>
        </c:if>
    </div>

    <div class="carrusel-scrollbar">
        <div class="carrusel-scrollbar-thumb"></div>
    </div>

</section>


<!-- Pie de página -->
<footer class="footer">

    <p>
        © 2026 SGCA · Todos los derechos reservados
    </p>

</footer>


<!-- MODAL PERFIL (mismo componente que usan cliente y asesor: ver perfil,
     editar datos y cambiar contraseña con la contraseña actual, sin código) -->
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
                        <span class="perfil-label">Rol</span>
                        <span class="perfil-valor">${sessionScope.usuarioLogueado.rol.rol}</span>
                    </div>
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
                        <label class="perfil-form-label" for="perfilConfirmarPassword">Confirmar contraseña</label>
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


<script>

    // ===== DROPDOWN "CONFIGURACIÓN" =====

    document.querySelectorAll(".dropdown-btn").forEach(function (btn) {
        btn.addEventListener("click", function (e) {
            e.stopPropagation();
            this.nextElementSibling.classList.toggle("show");
        });
    });

    document.addEventListener("click", function () {
        document.querySelectorAll(".dropdown-menu").forEach(function (menu) {
            menu.classList.remove("show");
        });
    });


    // El modal de Perfil en sí (ver/editar datos y cambiar contraseña) lo
    // maneja js/clienteJS/perfilModal.js, compartido con cliente y asesor.

</script>

<script>
    // ===== CARRUSEL DE AUTOS DISPONIBLES =====
    (function () {
        const track = document.getElementById('carruselTrack');
        const btnPrev = document.getElementById('btnPrev');
        const btnNext = document.getElementById('btnNext');
        const thumb = document.getElementById('scrollThumb');
        if (!track || !thumb) return;

        const DISTANCIA_SCROLL = 260;

        if (btnPrev) btnPrev.addEventListener('click', () => track.scrollBy({ left: -DISTANCIA_SCROLL, behavior: 'smooth' }));
        if (btnNext) btnNext.addEventListener('click', () => track.scrollBy({ left: DISTANCIA_SCROLL, behavior: 'smooth' }));

        function actualizarBarra() {
            const scrollableWidth = track.scrollWidth - track.clientWidth;
            if (scrollableWidth <= 0) {
                thumb.style.width = '100%';
                thumb.style.left = '0';
                return;
            }
            const porcentajeVisible = (track.clientWidth / track.scrollWidth) * 100;
            const porcentajeScroll = (track.scrollLeft / scrollableWidth) * (100 - porcentajeVisible);
            thumb.style.width = porcentajeVisible + '%';
            thumb.style.left = porcentajeScroll + '%';
        }

        track.addEventListener('scroll', actualizarBarra);
        window.addEventListener('resize', actualizarBarra);
        actualizarBarra();

        let arrastrando = false;
        thumb.addEventListener('mousedown', (e) => { arrastrando = true; e.preventDefault(); });
        document.addEventListener('mouseup', () => arrastrando = false);
        document.addEventListener('mousemove', (e) => {
            if (!arrastrando) return;
            const barra = thumb.parentElement.getBoundingClientRect();
            const porcentaje = (e.clientX - barra.left) / barra.width;
            const scrollableWidth = track.scrollWidth - track.clientWidth;
            track.scrollLeft = porcentaje * scrollableWidth;
        });
    })();
</script>

<script>
    window.PERFIL_CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/clienteJS/perfilModal.js"></script>

<c:if test="${abrirPerfil}">
    <script>
        // "Configuración" desde cualquier otra pantalla del dueño llega aquí
        // con esta bandera, así que el modal de perfil se abre solo al cargar.
        document.getElementById("modalPerfil").classList.add("active");
    </script>
</c:if>

<script>
    // Si el navegador restaura esta página desde su caché (botón "atrás")
    // después de haber cerrado sesión, fuerza una recarga real para que
    // AuthFilter vuelva a validar la sesión en vez de mostrar la versión
    // guardada en caché.
    window.addEventListener("pageshow", function (e) {
        if (e.persisted) {
            window.location.reload();
        }
    });
</script>
<script src="${pageContext.request.contextPath}/js/duenioJS/carrusel.js"></script>

</body>
</html>