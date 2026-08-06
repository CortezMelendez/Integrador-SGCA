<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestión de Autos — Concesionaria Automotriz</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&family=Google+Sans+Code:ital,wght@1,300..800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/gestiones.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/gestiones-extra.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/responsive.css">
</head>
<body>

<!-- BARRA DE NAVEGACIÓN -->
<header class="dash-navbar">
    <div class="dash-navbar-left">
        <div class="dash-logo-placeholder" aria-hidden="true">
            <img src="${pageContext.request.contextPath}/Images/logo2-SGCA.svg" class="logo-img" width="108" />
        </div>
        <span class="dash-brand">Concesionaria Automotriz</span>
    </div>
    <nav class="dash-nav-center">
        <a href="${pageContext.request.contextPath}/index" class="dash-nav-link">Inicio</a>
        <a href="${pageContext.request.contextPath}/nav?action=dashboard" class="dash-nav-link">Dashboard</a>
        <a href="${pageContext.request.contextPath}/nav?action=historial" class="dash-nav-link">Historial</a>
        <a href="${pageContext.request.contextPath}/nav?action=perfil" class="dash-nav-link">Perfil</a>
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

<!-- CONTENIDO PRINCIPAL-->
<main class="dash-main">

    <div class="gest-header">
        <div class="gest-header-left">
            <h1>Gestión de servicios</h1>
            <p>Administra el inventario de autos registrados.</p>
        </div>

        <!-- Buscador -->

        <button class="btn-agregar" onclick="abrirModal('modalAgregar')">+ Agregar auto</button>
    </div>
    <div class="gest-search-inline">
        <input class="gest-input" type="text" placeholder="Buscar auto..." oninput="filtrar(this.value)" />
        <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
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
                    <th>Fecha</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="v" items="${listaVehiculos}">
                    <tr>
                        <td>${v.marca.nombre}</td>
                        <td>${v.modelos.nombre}</td>
                        <td>${v.tipoVehiculo.nombre}</td>
                        <td>$<fmt:formatNumber value="${v.precio}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                        <td>${v.placa}</td>
                        <td>${v.anio}</td>
                        <td>
                  <span class="badge ${v.disponible == 1 ? 'badge-active' : 'badge-inactive'}"
                        onclick="toggleEstado(this, ${v.id_Vehiculo})">
                          ${v.disponible == 1 ? 'Activo' : 'Inactivo'}
                  </span>
                        </td>
                        <td><fmt:formatDate value="${v.fecha_registro}" pattern="dd/MM/yyyy"/></td>
                        <td class="acciones-cell">
                            <button class="btn-icon btn-editar"
                                    onclick="abrirEditar(${v.id_Vehiculo}, '${v.marca.nombre}', '${v.modelos.nombre}', '${v.tipoVehiculo.nombre}', ${v.precio}, '${v.color}', '${v.placa}', ${v.anio}, ${v.id_Agente}, '${v.disponible == 1 ? 'Activo' : 'Inactivo'}')">
                                Editar
                            </button>
                            <a class="btn-icon btn-eliminar"
                               href="${pageContext.request.contextPath}/gestionAutos?accion=eliminar&id=${v.id_Vehiculo}"
                               onclick="return confirm('¿Eliminar este auto? Esta acción no se puede deshacer.')">
                                Eliminar
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listaVehiculos}">
                    <tr>
                        <td colspan="9" style="text-align:center; padding: 24px;">No hay autos registrados todavía.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
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


<!-- Ventana emergente agregar-->
<div class="modal-overlay" id="modalAgregar" onclick="cerrarOverlay(event,'modalAgregar')">
    <div class="modal-box" onclick="event.stopPropagation()">
        <h2 class="modal-title">Agregar auto</h2>
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">Marca *</label>
                <input class="modal-input" id="mod-marca" type="text" placeholder="Ej. Toyota" />
                <span class="modal-error" id="err-marca"></span>
            </div>
            <div class="modal-field">
                <label class="modal-label">Modelo *</label>
                <input class="modal-input" id="mod-modelo" type="text" placeholder="Ej. Corolla" />
                <span class="modal-error" id="err-modelo"></span>
            </div>
        </div>
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">Categoría *</label>
                <select class="modal-select" id="mod-categoria">
                    <option value="">Selecciona...</option>
                    <c:forEach var="t" items="${listaTipos}">
                        <option value="${t.nombre}">${t.nombre}</option>
                    </c:forEach>
                    <c:if test="${empty listaTipos}">
                        <option>Sedán</option>
                        <option>SUV</option>
                        <option>Pickup</option>
                        <option>Hatchback</option>
                        <option>Deportivo</option>
                    </c:if>
                </select>
                <span class="modal-error" id="err-categoria"></span>
            </div>
            <div class="modal-field">
                <label class="modal-label">Precio ($) *</label>
                <input class="modal-input" id="mod-precio" type="number" min="0" step="0.01" placeholder="0.00" />
                <span class="modal-error" id="err-precio"></span>
            </div>
        </div>
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">Color *</label>
                <input class="modal-input" id="mod-color" type="text" placeholder="Ej. Rojo" />
                <span class="modal-error" id="err-color"></span>
            </div>
            <div class="modal-field">
                <label class="modal-label">Placa *</label>
                <input class="modal-input" id="mod-placa" type="text" placeholder="Ej. ABC-123-A" />
                <span class="modal-error" id="err-placa"></span>
            </div>
        </div>
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">Año *</label>
                <input class="modal-input" id="mod-anio" type="number" min="1980" max="2100" placeholder="Ej. 2024" />
                <span class="modal-error" id="err-anio"></span>
            </div>
            <div class="modal-field">
                <label class="modal-label">Agente responsable *</label>
                <select class="modal-select" id="mod-agente">
                    <option value="">Selecciona...</option>
                    <c:forEach var="a" items="${listaAgentes}">
                        <option value="${a.idAgente}">${a.nombreCompletoUsuario}</option>
                    </c:forEach>
                </select>
                <span class="modal-error" id="err-agente"></span>
            </div>
        </div>
        <div class="modal-field">
            <label class="modal-label">Estado</label>
            <select class="modal-select" id="mod-estado">
                <option>Activo</option>
                <option>Inactivo</option>
            </select>
        </div>
        <div class="modal-actions">
            <button class="btn-modal-cancel" onclick="cerrarModal('modalAgregar')">Cancelar</button>
            <button class="btn-modal-save" onclick="agregarRegistro()">Guardar</button>
        </div>
    </div>
</div>

<!-- ventana emergente Editar -->
<div class="modal-overlay" id="modalEditar" onclick="cerrarOverlay(event,'modalEditar')">
    <div class="modal-box" onclick="event.stopPropagation()">
        <h2 class="modal-title">Editar auto</h2>
        <input type="hidden" id="edit-id" />
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">Marca *</label>
                <input class="modal-input" id="edit-marca" type="text" />
                <span class="modal-error" id="edit-err-marca"></span>
            </div>
            <div class="modal-field">
                <label class="modal-label">Modelo *</label>
                <input class="modal-input" id="edit-modelo" type="text" />
                <span class="modal-error" id="edit-err-modelo"></span>
            </div>
        </div>
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">Categoría *</label>
                <select class="modal-select" id="edit-categoria">
                    <option value="">Selecciona...</option>
                    <c:forEach var="t" items="${listaTipos}">
                        <option value="${t.nombre}">${t.nombre}</option>
                    </c:forEach>
                    <c:if test="${empty listaTipos}">
                        <option>Sedán</option>
                        <option>SUV</option>
                        <option>Pickup</option>
                        <option>Hatchback</option>
                        <option>Deportivo</option>
                    </c:if>
                </select>
                <span class="modal-error" id="edit-err-categoria"></span>
            </div>
            <div class="modal-field">
                <label class="modal-label">Precio ($) *</label>
                <input class="modal-input" id="edit-precio" type="number" min="0" step="0.01" />
                <span class="modal-error" id="edit-err-precio"></span>
            </div>
        </div>
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">Color *</label>
                <input class="modal-input" id="edit-color" type="text" />
                <span class="modal-error" id="edit-err-color"></span>
            </div>
            <div class="modal-field">
                <label class="modal-label">Placa *</label>
                <input class="modal-input" id="edit-placa" type="text" />
                <span class="modal-error" id="edit-err-placa"></span>
            </div>
        </div>
        <div class="modal-row">
            <div class="modal-field">
                <label class="modal-label">Año *</label>
                <input class="modal-input" id="edit-anio" type="number" min="1980" max="2100" />
                <span class="modal-error" id="edit-err-anio"></span>
            </div>
            <div class="modal-field">
                <label class="modal-label">Agente responsable *</label>
                <select class="modal-select" id="edit-agente">
                    <option value="">Selecciona...</option>
                    <c:forEach var="a" items="${listaAgentes}">
                        <option value="${a.idAgente}">${a.nombreCompletoUsuario}</option>
                    </c:forEach>
                </select>
                <span class="modal-error" id="edit-err-agente"></span>
            </div>
        </div>
        <div class="modal-field">
            <label class="modal-label">Estado</label>
            <select class="modal-select" id="edit-estado">
                <option>Activo</option>
                <option>Inactivo</option>
            </select>
        </div>
        <div class="modal-actions">
            <button class="btn-modal-cancel" onclick="cerrarModal('modalEditar')">Cancelar</button>
            <button class="btn-modal-save" onclick="guardarEdicion()">Guardar cambios</button>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/duenioJS/gestionAutos.js"></script>
</body>
</html>