<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard — Concesionaria Automotriz</title>
    <!-- ENLACES A TUS ESTILOS CSS CORREGIDOS -->
    <link rel="stylesheet" href="../../css/duenioStyles/styles.css" />
    <link rel="stylesheet" href="../../css/duenioStyles/dashboard.css" />
    <link rel="stylesheet" href="../../css/duenioStyles/responsive.css" />
</head>
<body>

<!-- NAVBAR -->
<header class="dash-navbar">
    <div class="dash-navbar-left">
        <div class="dash-logo-placeholder" aria-hidden="true">
            <img src="../../Images/logo2-SGCA.svg" class="logo-img" width="108" />
        </div>
        <span class="dash-brand">Concesionaria Automotriz</span>
    </div>
    <nav class="dash-nav-center">
        <a href="index.jsp" class="dash-nav-link">Inicio</a>
        <a href="" class="dash-nav-link active">Dashboard</a>
        <a href="" class="dash-nav-link">Servicios</a>
        <a href="" class="dash-nav-link ">Perfil</a>
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
                <a href="gestionServicios.jsp" class="gestion-menu-item" role="menuitem">
                    <span class="gestion-menu-item-title">Gestionar servicios</span>
                    <span class="gestion-menu-item-desc">Catálogo de servicios únicos, mensuales y anuales registrados en el sistema.</span>
                </a>
                <a href="gestionEmpleados.jsp" class="gestion-menu-item" role="menuitem">
                    <span class="gestion-menu-item-title">Gestionar empleados</span>
                    <span class="gestion-menu-item-desc">Alta, baja y edición del personal. Control de estado activo, permiso o baja definitiva.</span>
                </a>
                <a href="gestionClientes.jsp" class="gestion-menu-item" role="menuitem">
                    <span class="gestion-menu-item-title">Gestionar clientes</span>
                    <span class="gestion-menu-item-desc">Puntos de contacto, asignación y transferencia de asesores entre sucursales.</span>
                </a>
                <a href="gestionAutos.jsp" class="gestion-menu-item" role="menuitem">
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
            <span class="metric-value" id="metric-vehiculos"></span>
            <span class="metric-delta" id="metric-vehiculos-delta"></span>
        </div>
        <div class="metric-card">
            <span class="metric-label">Servicios activos</span>
            <span class="metric-value" id="metric-servicios"></span>
            <span class="metric-delta" id="metric-servicios-delta"></span>
        </div>
        <div class="metric-card">
            <span class="metric-label">Puntos de contacto</span>
            <span class="metric-value" id="metric-contactos"></span>
            <span class="metric-delta" id="metric-contactos-delta"></span>
        </div>
        <div class="metric-card">
            <span class="metric-label">Clientes registrados</span>
            <span class="metric-value" id="metric-clientes"></span>
            <span class="metric-delta" id="metric-clientes-delta"></span>
        </div>
    </div>

    <!-- Gráficas placeholder -->
    <div class="dash-charts">
        <div class="chart-card">
            <div class="chart-placeholder">
                <span class="chart-placeholder-label">Gráfica de barras<br/>Cantidad por mes</span>
            </div>
        </div>
        <div class="chart-card">
            <div class="chart-placeholder">
                <span class="chart-placeholder-label">Distribución<br/>por categoría<br/>(Gráfica circular)</span>
            </div>
        </div>
    </div>

    <!-- Accesos rápidos -->
    <div class="dash-quick">
        <a href="#" class="quick-card">
            <span class="quick-icon"></span>
            <span class="quick-label">Disponibilidad en el inventario</span>
        </a>
        <a href="#" class="quick-card">
            <span class="quick-icon"></span>
            <span class="quick-label">Servicios recientes</span>
        </a>
        <a href="historial.jsp" class="quick-card">
            <span class="quick-icon"></span>
            <span class="quick-label">Historial de ventas</span>
        </a>
    </div>
</main>

<!-- FOOTER con botón Atrás -->
<footer class="footer">
    <a href="index.jsp" class="btn-back">
        <img src="../../Images/back.svg" alt="atras" />
        Atrás
    </a>
</footer>

<script src="../../js/duenioJS/menuDesplegable.js"></script>

</body>
</html>