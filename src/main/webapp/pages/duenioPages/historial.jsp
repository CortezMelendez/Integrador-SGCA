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
                <a href="${pageContext.request.contextPath}/nav?action=perfil">Perfil</a>
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
</body>
</html>