<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard — Concesionaria Automotriz</title>
    <!-- ENLACES A TUS ESTILOS CSS CORREGIDOS -->

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/gestiones.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/dashboard.css" />
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
        <a href="${pageContext.request.contextPath}/nav?action=dashboard" class="dash-nav-link active">Dashboard</a>
        <a href="${pageContext.request.contextPath}/nav?action=historial" class="dash-nav-link">Historial</a>
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
            <div class="dash-user-avatar" id="userAvatar" aria-hidden="true"></div>
            <div class="dash-user-info">
                <span class="dash-user-name" id="userName"></span>
                <span class="dash-user-role" id="userRole"></span>
            </div>
        </div>
    </div>
</header>

<!-- CONTENIDO PRINCIPAL -->
<main class="dash-main">
    <div class="dash-section-header">
        <div>
            <h1 class="dash-title">Dashboard</h1>
            <p class="dash-subtitle">Resumen general</p>
        </div>
        <div class="dash-gestion" id="dashGestion">
            <button class="btn-gestion" id="btnGestion" aria-haspopup="true" aria-expanded="false" aria-controls="gestionMenu"> Gestion

                <svg class="chevron" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <path d="M6 9l6 6 6-6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </button>
            <div class="gestion-menu" id="gestionMenu" role="menu">
                <a href="${pageContext.request.contextPath}/btn?action=gestionServicio" class="gestion-menu-item" role="menuitem">
                    <span class="gestion-menu-item-title">Gestionar servicios</span>
                    <span class="gestion-menu-item-desc">Catálogo de servicios únicos, mensuales y anuales registrados en el sistema.</span>
                </a>
                <a href="${pageContext.request.contextPath}/btn?action=gestionEmpleados" class="gestion-menu-item" role="menuitem">
                    <span class="gestion-menu-item-title">Gestionar empleados</span>
                    <span class="gestion-menu-item-desc">Alta, baja y edición del personal. Control de estado activo, permiso o baja definitiva.</span>
                </a>
                <a href="${pageContext.request.contextPath}/btn?action=gestionClientes" class="gestion-menu-item" role="menuitem">
                    <span class="gestion-menu-item-title">Gestionar clientes</span>
                    <span class="gestion-menu-item-desc">Puntos de contacto, asignación y transferencia de asesores entre sucursales.</span>
                </a>
                <a href="${pageContext.request.contextPath}/btn?action=gestionAutos" class="gestion-menu-item" role="menuitem">
                    <span class="gestion-menu-item-title">Gestionar autos</span>
                    <span class="gestion-menu-item-desc">Registro de marcas, modelos, precios, placas y disponibilidad del inventario.</span>
                </a>
            </div>
        </div>
    </div>

    <!-- Métricas -->
    <div class="dash-metrics">
        <div class="metric-card">
            <span class="metric-label">Vehículos registrados</span>
            <span class="metric-value">${metricVehiculos}</span>
            <span class="metric-delta positive">${metricVehiculosDisponibles} disponibles</span>
        </div>
        <div class="metric-card">
            <span class="metric-label">Servicios activos</span>
            <span class="metric-value">${metricServicios}</span>
            <span class="metric-delta neutral">${metricServiciosTotal} en catálogo</span>
        </div>
        <div class="metric-card">
            <span class="metric-label">Puntos de contacto</span>
            <span class="metric-value">${metricContactos}</span>
            <span class="metric-delta neutral">Asesores activos</span>
        </div>
        <div class="metric-card">
            <span class="metric-label">Clientes registrados</span>
            <span class="metric-value">${metricClientes}</span>
            <span class="metric-delta positive">+${metricClientesNuevosMes} este mes</span>
        </div>
    </div>

    <!-- Gráficas -->
    <div class="dash-charts">
        <div class="chart-card">
            <canvas id="chartVentas" aria-label="Ventas de los últimos 6 meses" role="img"></canvas>
        </div>
        <div class="chart-card">
            <canvas id="chartVehiculos" aria-label="Vehículos por categoría" role="img"></canvas>
        </div>
    </div>

    <!-- Registros recientes -->
    <div class="dash-recientes">
        <h2 class="dash-recientes-title">Ventas recientes</h2>
        <div class="table-card">
            <div class="table-wrapper">
                <table class="gest-table">
                    <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Cliente</th>
                        <th>Asesor</th>
                        <th>Vehículo</th>
                        <th>Total</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="v" items="${ventasRecientes}">
                        <tr>
                            <td><fmt:formatDate value="${v.fechaVenta}" pattern="dd/MM/yyyy"/></td>
                            <td>${v.cliente.nombreCliente}</td>
                            <td>${v.agente.nombreCompletoUsuario}</td>
                            <td>${v.vehiculo.placa}</td>
                            <td class="precio">$<fmt:formatNumber value="${v.total}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty ventasRecientes}">
                        <tr>
                            <td colspan="5" style="text-align:center; padding: 24px;">Todavía no hay ventas registradas.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Accesos rápidos -->
    <div class="dash-quick">
        <a href="${pageContext.request.contextPath}/btn?action=gestionAutos" class="quick-card">
            <span class="quick-icon"></span>
            <span class="quick-label">Disponibilidad en el inventario</span>
        </a>
        <a href="${pageContext.request.contextPath}/btn?action=gestionServicio" class="quick-card">
            <span class="quick-icon"></span>
            <span class="quick-label">Servicios recientes</span>
        </a>
        <a href="${pageContext.request.contextPath}/nav?action=historial" class="quick-card">
            <span class="quick-icon"></span>
            <span class="quick-label">Historial de ventas</span>
        </a>
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

<!-- Chart.js (CDN) para las gráficas de barras y circular -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
<script src="${pageContext.request.contextPath}/js/duenioJS/menuDesplegable.js"></script>
<script>
    const chartVentasLabels = ${chartVentasLabels};
    const chartVentasValues = ${chartVentasValues};
    const chartVehiculosLabels = ${chartVehiculosLabels};
    const chartVehiculosValues = ${chartVehiculosValues};

    if (window.Chart) {
        new Chart(document.getElementById('chartVentas'), {
            type: 'bar',
            data: {
                labels: chartVentasLabels,
                datasets: [{
                    label: 'Ventas',
                    data: chartVentasValues,
                    backgroundColor: '#1a2433',
                    borderRadius: 6,
                    maxBarThickness: 42
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false }, title: { display: true, text: 'Ventas por mes' } },
                scales: { y: { beginAtZero: true, ticks: { precision: 0 } } }
            }
        });

        new Chart(document.getElementById('chartVehiculos'), {
            type: 'doughnut',
            data: {
                labels: chartVehiculosLabels,
                datasets: [{
                    data: chartVehiculosValues,
                    backgroundColor: ['#1a2433', '#4a90e2', '#79aee6', '#b5e5a5', '#ffbaba', '#9e9e9e', '#c7cad0']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'bottom', labels: { boxWidth: 12, font: { size: 11 } } }, title: { display: true, text: 'Vehículos por categoría' } }
            }
        });
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
