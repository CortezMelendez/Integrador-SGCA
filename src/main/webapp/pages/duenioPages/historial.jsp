<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Historial de ventas — Concesionaria Automotriz</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/gestiones.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vendor/bootstrap-scoped.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/perfilModal.css">
</head>
<body class="bs">

<!-- NAVBAR -->
<header class="dash-navbar">
    <div class="dash-navbar-left">
        <div class="dash-logo-placeholder" aria-hidden="true">
            <img src="${pageContext.request.contextPath}/Images/logo2-SGCA.svg" class="logo-img" width="108" />
        </div>
        <span class="dash-brand">Concesionaria Automotriz</span>
    </div>
    <nav class="dash-nav-center">
        <a href="${pageContext.request.contextPath}/nav?action=inicio" class="dash-nav-link">Inicio</a>
        <a href="${pageContext.request.contextPath}/nav?action=dashboard" class="dash-nav-link">Dashboard</a>
        <a href="${pageContext.request.contextPath}/nav?action=historial" class="dash-nav-link active">Historial</a>
        <div class="dropdown">
            <button type="button" class="dash-nav-link dropdown-btn">Configuración ▾</button>
            <div class="dropdown-menu">
                <a href="#" id="btnAbrirPerfil">Perfil</a>
                <a href="${pageContext.request.contextPath}/btn?action=cerrarSesionTodos">Cerrar sesión</a>
            </div>
        </div>
    </nav>
    <div class="dash-navbar-right">
        <div class="dash-user">
            <div class="dash-user-info">
                <span class="dash-user-name" id="userName"></span>
                <span class="dash-user-role" id="userRole"></span>
            </div>
        </div>
    </div>
</header>

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

<!-- CONTENIDO PRINCIPAL -->
<main class="dash-main">

    <div class="gest-header">
        <div class="gest-header-left">
            <h1>Historial de ventas y servicios</h1>
            <p>Trazabilidad completa de las operaciones de la concesionaria.</p>
        </div>
    </div>

    <div class="gest-search-inline">
        <input class="gest-input" type="text" id="inputFiltroPlaca"
               placeholder="Filtrar por placa..." oninput="filtrarPorPlaca(this.value)" />
        <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
    </div>

    <!-- TABLA DE HISTORIAL -->
    <div class="table-card">
        <div class="table-wrapper">
            <table class="gest-table" id="tablaHistorial">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Placa</th>
                    <th>Fecha</th>
                    <th>Cliente</th>
                    <th>Agente</th>
                    <th>Servicios contratados</th>
                    <th>Total</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="v" items="${listaVentas}" varStatus="fila">
                    <tr data-placa="${fn:toUpperCase(v.vehiculo.placa)}">
                        <td>${fila.count}</td>
                        <td>${v.vehiculo.placa}</td>
                        <td><fmt:formatDate value="${v.fechaVenta}" pattern="dd/MM/yyyy"/></td>
                        <td>${v.cliente.nombreCliente}</td>
                        <td>${v.agente.nombreCompletoUsuario}</td>
                        <td>
                            <c:if test="${empty v.detalles}">—</c:if>
                            <c:forEach var="d" items="${v.detalles}" varStatus="detFila">${d.servicio.nombre}<c:if test="${!detFila.last}">, </c:if></c:forEach>
                        </td>
                        <td class="precio">$<fmt:formatNumber value="${v.total}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <p id="sinResultados" class="tabla-vacio" style="display:none; text-align:center; padding: 24px;">
                No se encontraron registros para este filtro.
            </p>
            <c:if test="${empty listaVentas}">
                <p class="tabla-vacio" style="text-align:center; padding: 24px;">Todavía no hay ventas registradas.</p>
            </c:if>
        </div>
    </div>
</main>

<!-- FOOTER -->
<footer class="footer">
    <span style="color: rgb(8, 8, 8); font-size: 0.85rem;">© 2026 SGCA · Todos los derechos reservados</span>
    <a href="javascript:history.back()" class="btn-back">
        <img src="${pageContext.request.contextPath}/Images/back.svg" alt="atras" />
        Atras
    </a>
</footer>

<script>
    function filtrarPorPlaca(valor) {
        const filtro = valor.trim().toUpperCase();
        const filas = document.querySelectorAll('#tablaHistorial tbody tr');
        let visibles = 0;

        filas.forEach(function (fila) {
            const placa = fila.getAttribute('data-placa') || '';
            const coincide = placa.indexOf(filtro) !== -1;
            fila.style.display = coincide ? '' : 'none';
            if (coincide) visibles++;
        });

        document.getElementById('sinResultados').style.display =
            (filtro !== '' && visibles === 0) ? '' : 'none';
    }
</script>

<script>
    // Dropdown "Configuración"
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

<script>
    window.PERFIL_CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/clienteJS/perfilModal.js"></script>
</body>
</html>