
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Registrar usuarios — Concesionaria Automotriz</title>
    <!-- Asegúrate de que las rutas a tus CSS sean correctas -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&family=Google+Sans+Code:ital,wght@1,300..800&display=swap" rel="stylesheet">


    <link rel="stylesheet" href="content/styles/style.css">
    <link rel="stylesheet" href="content/styles/registrarUsuario.css">
    <link rel="stylesheet" href="content/styles/responsive.css">

</head>
<body>

<!-- =============================================
     NAVBAR (BARRA DE NAVEGACIÓN)
============================================= -->
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
                <a href="registrarUsuario.html" class="nav-link active">Usuario</a>
                <a href="gestionarAuto.html" class="nav-link">Auto</a>
                <button id="btn-cerrar" class="btn-x">X</button>
            </div>
        </div>
        <a href="#" class="nav-link">Cotización</a>
        <a href="#" class="nav-link">Historial</a>
        <a href="#" class="nav-link">Configuración</a>
    </nav>
</header>


<!-- =============================================
     CONTENIDO PRINCIPAL
============================================= -->
<main class="dash-main">

    <div class="gest-header">
        <div class="gest-header-left">
            <h1>Registrar nuevo usuario</h1>
            <p>Ingresa los datos del cliente para crear cuenta.</p>
        </div>

        <!-- Buscador -->
        <div class="gest-search-inline">
            <input class="gest-input" type="text" placeholder="Buscar usuario..." oninput="filtrar(this.value)" />
            <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
        </div>

        <button class="btn-agregar" onclick="abrirModal('modalAgregar')">+ Registrar usuario</button>
    </div>

    <!-- =============================================
         TABLA DE DATOS
    ============================================= -->
    <div class="table-card">
        <div class="table-wrapper">
            <table class="gest-table" id="tabla">
                <thead>
                <tr>
                    <th>Nombre(s)</th>
                    <th>Apellido(s)</th>
                    <th>RFC</th>
                    <th>Telefono</th>
                    <th>Correo</th>
                    <th>Fecha de registro</th>
                    <th>Estado</th>
                    <th>Acciones</th>

                </tr>
                </thead>
                <tbody>
                <!-- Fila 1 -->
                <tr>
                    <td>David Emmanuel</td>
                    <td>Flores Morales</td>
                    <td>FOMD980806EQ</td>
                    <td>7773677799</td>
                    <td>david@gmail.com</td>
                    <td>05/03/2026</td>
                    <td><span class="badge badge-inactive" onclick="toggleEstado(this)">Inactivo</span></td>
                    <td>
                        <div class="action-group">
                            <button class="btn-icon btn-edit" onclick="abrirEditar('David Emmanuel','Flores Morales','FOMD980806EQ','7773677799','david@gmail.com')" title="Editar">
                                <img src="content/images/edit.svg" alt="">
                            </button>
                            <button class="btn-icon btn-delete" title="Eliminar">
                                <img src="content/images/delete.svg" alt="" width="20">
                            </button>
                        </div>
                    </td>
                </tr>

                <!-- Fila 2 -->
                <tr>
                    <td>Carlos Alberto</td>
                    <td>Cortéz Meléndez</td>
                    <td>COMC101201AD</td>
                    <td>7356810255</td>
                    <td>20253rd041@utez.edu.mx</td>
                    <td>12/04/2026</td>
                    <td><span class="badge badge-active" onclick="toggleEstado(this)">Activo</span></td>
                    <td>
                        <div class="action-group">
                            <button class="btn-icon btn-edit" onclick="abrirEditar('Carlos Alberto','Cortéz Meléndez','COMC101201AD','7356810255','20253rd041@utez.edu.mx')" title="Editar">
                                <img src="content/images/edit.svg" alt="">
                            </button>
                            <button class="btn-icon btn-delete" title="Eliminar">
                                <img src="content/images/delete.svg" alt="" width="20">
                            </button>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

</main>

<!-- =============================================
     FOOTER
============================================= -->
<footer class="footer">
<span>© 2026 SGCA · Todos los derechos reservados</span>
<a href="index.html" class="btn-atras">
<img src="content/images/back.svg" alt="">
Atrás
</a>
</footer>

<!-- =============================================
     MODALES
============================================= -->
<!-- Modal Agregar -->
<div class="modal-overlay" id="modalAgregar" onclick="cerrarOverlay(event,'modalAgregar')">
    <div class="modal-box">
        <h2 class="modal-title">Agregar cliente</h2>
        <div class="modal-field">
            <label class="modal-label">Nombre completo</label>
            <input class="modal-input" type="text" id="mod-nombre" placeholder="Ej. Juan Pérez López" />
        </div>
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">RFC</label>
                <input class="modal-input" type="text" id="mod-rfc" placeholder="Ej. PELJ900101AB1" />
            </div>
            <div class="modal-field">
                <label class="modal-label">Teléfono</label>
                <input class="modal-input" type="text" id="mod-telefono" placeholder="Ej. 7771234567" />
            </div>
        </div>
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">CURP</label>
                <input class="modal-input" type="text" id="mod-curp" placeholder="Ej. PELJ900101HMLRPN01" />
            </div>
            <div class="modal-field">
                <label class="modal-label">Estado</label>
                <select class="modal-select" id="mod-estado">
                    <option>Activo</option>
                    <option>Inactivo</option>
                </select>
            </div>
        </div>
        <div class="modal-field">
            <label class="modal-label">Correo</label>
            <input class="modal-input" type="email" id="mod-correo" placeholder="Ej. correo@ejemplo.com" />
        </div>
        <div class="modal-field">

        </div>

        <div class="modal-actions">
            <button class="btn-modal-cancel" onclick="cerrarModal('modalAgregar')">Cancelar</button>
            <button class="btn-modal-save" onclick="agregarRegistro()">Guardar</button>
        </div>
    </div>
</div>


<script src="content/js/registrarUsuario.js"></script>
</body>
</html>