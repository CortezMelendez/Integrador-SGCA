
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Historial — Concesionaria Automotriz</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&family=Google+Sans+Code:ital,wght@1,300..800&display=swap" rel="stylesheet">


    <link rel="stylesheet" href="content/styles/style.css" />
    <link rel="stylesheet" href="content/styles/historial.css" />
</head>
<body>

<!-- BARRA DE NAVEGACIÓN -->
<header class="dash-navbar">
    <div class="dash-navbar-left">
        <div class="dash-logo-placeholder" aria-hidden="true">
            <img src="content/images/logo2-SGCA.svg" class="logo-img" width="108" />
        </div>
        <span class="dash-brand">Concesionaria Automotriz</span>
    </div>
    <nav class="dash-nav-center">
        <a href="#" class="nav-link">Vehículos</a>
        <a href="#" class="nav-link">Servicios</a>
        <div class="nav-item" id="contenedor-registrar">
            <button id="btn-registrar" class="nav-link">Registrar</button>

            <div id="submenu-registrar" class="submenu oculto">
                <a href="registrarUsuario.html" class="nav-link">Usuario</a>
                <a href="#" class="nav-link">Auto</a>
                <button id="btn-cerrar" class="btn-x">X</button>
            </div>
        </div>
        <a href="#" class="nav-link">Cotización</a>
        <a href="#" class="nav-link active">Historial</a>
        <a href="#" class="nav-link">Configuración</a>
    </nav>
</header>

<!-- CONTENIDO PRINCIPAL-->

<main class="dash-main">
    <div class="gest-header-left">
        <h1>Historial</h1>
    </div>

    <div class="gest-header">
        <!-- Buscador -->
        <div class="gest-search-inline">
            <input class="gest-input" type="text" placeholder="Buscar en historial..." oninput="filtrar(this.value)" />
            <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
        </div>

    </div>

    <!--  TABLA DE DATOS -->
    <div class="table-card">
        <div class="table-wrapper">
            <table class="gest-table" id="tabla">
                <thead>
                <tr>
                    <th>NO. de historial</th>
                    <th>Id Cliente</th>
                    <th>Fecha</th>
                    <th>Costo</th>
                    <th>Vehiculo</th>
                    <th>Servicio</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <!-- Fila 1 -->
                <tr>
                    <td>01</td>
                    <td>10</td>
                    <td>03/05/2026</td>
                    <td>$485,000</td>
                    <td>Carro</td>
                    <td>Cambio de llanta</td>
                    <td>
                        <div class="action-group">
                            <button class="btn-icon btn-info">
                                <img src="content/images/info.svg" alt="" width="24px">
                                <p class="btn-text">Mostrar info</p>
                            </button>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

</main>

<!-- FOOTER -->
<footer class="footer">
<span>© 2026 SGCA · Todos los derechos reservados</span>
<a href="index.html" class="btn-atras">
<img src="content/images/back.svg" alt="">
Atrás
</a>
</footer>


<!-- ventana emergente Editar -->
<!-- VENTANA EMERGENTE DE COTIZACIÓN (Estructura Corregida) -->
<div class="modal-overlay" id="modalCotizacion">
    <div class="modal-box">
        <h2 class="modal-title">Cotización</h2>

        <div class="modal-cuerpo">

            <h3 class="modal-section-title">Cliente</h3>

            <div class="modal-row">
                <div class="modal-field">
                    <label class="modal-label">Nombre cliente:</label>
                    <input class="modal-input" type="text" id="modal-nombre" readonly>
                </div>
                <div class="modal-field">
                    <label class="modal-label">Dirección:</label>
                    <input class="modal-input" type="text" id="modal-direccion" readonly>
                </div>
            </div>

            <div class="modal-row">
                <div class="modal-field">
                    <label class="modal-label">ID:</label>
                    <input class="modal-input" type="text" id="modal-id" readonly>
                </div>
                <div class="modal-field">
                    <label class="modal-label">Teléfono:</label>
                    <input class="modal-input" type="text" id="modal-telefono" readonly>
                </div>
            </div>

            <h3 class="modal-section-title modal-section-title-spaced">Vehículo</h3>
            <div class="modal-field">
                <input class="modal-input" type="text" id="modal-vehiculo" readonly>
            </div>

            <h3 class="modal-section-title modal-section-title-spaced">Servicios</h3>
            <div class="modal-field">
                <input class="modal-input" type="text" id="modal-servicios" readonly>
            </div>

            <!-- Botones de acción del modal -->
            <div class="modal-actions">
                <button class="btn-modal-cancel" id="btn-cerrar-modal">Cerrar</button>
            </div>
        </div>

    </div>
</div>

<script src="content/js/historial.js"></script>
</body>
</html>