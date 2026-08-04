
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestión de Autos — Concesionaria Automotriz</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&family=Google+Sans+Code:ital,wght@1,300..800&display=swap" rel="stylesheet">


    <link rel="stylesheet" href="content/styles/style.css" />
    <link rel="stylesheet" href="content/styles/gestionarAuto.css" />
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
                <a href="#" class="nav-link active">Auto</a>
                <button id="btn-cerrar" class="btn-x">X</button>
            </div>
        </div>
        <a href="#" class="nav-link">Cotización</a>
        <a href="#" class="nav-link">Historial</a>
        <a href="#" class="nav-link">Configuración</a>
    </nav>
</header>

<!-- CONTENIDO PRINCIPAL-->
<main class="dash-main">

    <div class="gest-header">
        <div class="gest-header-left">
            <h1>Gestión de autos</h1>
            <p>Administra el inventario de autos registrados.</p>
        </div>

        <!-- Buscador -->
        <div class="gest-search-inline">
            <input class="gest-input" type="text" placeholder="Buscar auto..." oninput="filtrar(this.value)" />
            <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
        </div>

        <button class="btn-agregar" onclick="abrirModal('modalAgregar')">+ Agregar auto</button>
    </div>

    <!--  TABLA DE DATOS -->
    <div class="table-card">
        <div class="table-wrapper">
            <table class="gest-table" id="tabla">
                <thead>
                <tr>
                    <th>Marca</th>
                    <th>Modelo</th>
                    <th>Categoria</th>
                    <th>Precio</th>
                    <th>Placa</th>
                    <th>Año</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <!-- Fila 1 -->
                <tr>
                    <td>Mazda</td>
                    <td>CX-5 2024</td>
                    <td>SUV </td>
                    <td><div class="precio">$485,000</div></td>
                    <td>MOR-2024</td>
                    <td>2024</td>
                    <td><span class="badge badge-inactive" onclick="toggleEstado(this)">Inactivo</span></td>
                    <td>
                        <div class="action-group">
                            <button class="btn-icon btn-edit" onclick="abrirEditar('Cambio de aceite','Único','1500','1 hr','Inactivo')" title="Editar">
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
                    <td>Nissan</td>
                    <td>Versa</td>
                    <td>Sedán</td>
                    <td><div class="precio">$320,000</div></td>
                    <td>MOR-2551</td>
                    <td>2023</td>
                    <td><span class="badge badge-inactive" onclick="toggleEstado(this)">Inactivo</span></td>
                    <td>
                        <div class="action-group">
                            <button class="btn-icon btn-edit" onclick="abrirEditar('Cambio de aceite','Único','1500','1 hr','Inactivo')" title="Editar">
                                <img src="content/images/edit.svg" alt="">
                            </button>
                            <button class="btn-icon btn-delete" title="Eliminar">
                                <img src="content/images/delete.svg" alt="" width="20">
                            </button>
                        </div>
                    </td>
                </tr>

                <!-- Fila 3 -->
                <tr>
                    <td>Ford</td>
                    <td>Mustang</td>
                    <td>Deportivo</td>
                    <td><div class="precio">$850,000</div></td>
                    <td>MOR-0725</td>
                    <td>2025</td>
                    <td><span class="badge badge-active" onclick="toggleEstado(this)">Activo</span></td>
                    <td>
                        <div class="action-group">
                            <button class="btn-icon btn-edit" onclick="abrirEditar('Cambio de aceite','Único','1500','1 hr','Inactivo')" title="Editar">
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

<!-- FOOTER -->
<footer class="footer">
<span>© 2026 SGCA · Todos los derechos reservados</span>
<a href="index.html" class="btn-atras">
<img src="content/images/back.svg" alt="">
Atrás
</a>
</footer>


<!-- Ventana emergente agregar-->
<div class="modal-overlay" id="modalAgregar" onclick="cerrarOverlay(event,'modalAgregar')">
    <div class="modal-box">
        <h2 class="modal-title">Agregar servicio</h2>
        <div class="modal-field">
            <input type="image" placeholder="Subir imagen">
        </div>
        <div class="modal-field">
            <label class="modal-label">Nombre del servicio</label>
            <input class="modal-input" type="text" placeholder="Ej. Cambio de aceite" />
        </div>
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">Tipo</label>
                <select class="modal-select">
                    <option>Único</option>
                    <option>Mensual</option>
                    <option>Anual</option>
                </select>
            </div>
            <div class="modal-field">
                <label class="modal-label">Precio ($)</label>
                <input class="modal-input" type="number" placeholder="0.00" />
            </div>
        </div>
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">Duración</label>
                <input class="modal-input" type="text" placeholder="Ej. 2 hrs" />
            </div>
            <div class="modal-field">
                <label class="modal-label">Estado</label>
                <select class="modal-select">
                    <option>Activo</option>
                    <option>Inactivo</option>
                </select>
            </div>
        </div>
        <div class="modal-actions">
            <button class="btn-modal-cancel" onclick="cerrarModal('modalAgregar')">Cancelar</button>
            <button class="btn-modal-save">Guardar</button>
        </div>
    </div>
</div>


<!-- ventana emergente Editar -->
<div class="modal-overlay" id="modalEditar" onclick="cerrarOverlay(event,'modalEditar')">
    <div class="modal-box">
        <h2 class="modal-title">Editar servicio</h2>
        <div class="modal-field">
            <label class="modal-label">Nombre del servicio</label>
            <input class="modal-input" id="edit-nombre" type="text" />
        </div>
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">Tipo</label>
                <select class="modal-select" id="edit-tipo">
                    <option>Único</option>
                    <option>Mensual</option>
                    <option>Anual</option>
                </select>
            </div>
            <div class="modal-field">
                <label class="modal-label">Precio ($)</label>
                <input class="modal-input" id="edit-precio" type="number" />
            </div>
        </div>
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">Duración</label>
                <input class="modal-input" id="edit-dur" type="text" />
            </div>
            <div class="modal-field">
                <label class="modal-label">Estado</label>
                <select class="modal-select" id="edit-estado">
                    <option>Activo</option>
                    <option>Inactivo</option>
                </select>
            </div>
        </div>
        <div class="modal-actions">
            <button class="btn-modal-cancel" onclick="cerrarModal('modalEditar')">Cancelar</button>
            <button class="btn-modal-save">Guardar cambios</button>
        </div>
    </div>
</div>
<script src="content/js/gestionAuto.js"></script>
</body>
</html>