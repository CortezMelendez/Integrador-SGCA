<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestión de Servicios — Concesionaria Automotriz</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&family=Google+Sans+Code:ital,wght@1,300..800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/gestiones.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/gestiones-extra.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/responsive.css" />
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
        <a href="index.html" class="dash-nav-link">Inicio</a>
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

<!-- CONTENIDO PRINCIPAL -->
<main class="dash-main">

    <div class="gest-header">
        <div class="gest-header-left">
            <h1>Gestión de servicios</h1>
            <p>Administra el inventario de servicios registrados.</p>
        </div>
        <button class="btn-agregar" onclick="abrirModal('modalAgregar')">+ Agregar servicio</button>
    </div>

    <div class="gest-search-inline">
        <input class="gest-input" id="buscador-servicio" type="text" placeholder="Buscar servicio..." oninput="filtrar(this.value)" />
        <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
    </div>

    <!-- TABLA DE DATOS -->
    <div class="table-card">
        <div class="table-wrapper">
            <table class="gest-table" id="tabla">
                <thead>
                <tr>
                    <th>Fotografía</th>
                    <th>Nombre</th>
                    <th>Precio</th>
                    <th>Estado</th>
                    <th>Tipo de servicio</th>
                    <th>Fecha</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="s" items="${listaServicios}">
                    <tr>
                        <td>
                            <!-- No existe columna de imagen en ADMIN.SERVICIOS todavía, se muestra un placeholder -->
                            <div class="foto-placeholder"></div>
                        </td>
                        <td>${s.nombre}</td>
                        <td><div class="precio">$<fmt:formatNumber value="${s.precio}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div></td>
                        <td>
              <span class="badge ${s.estado == 1 ? 'badge-active' : 'badge-inactive'}"
                    onclick="toggleEstado(this, ${s.id_servicio})">
                      ${s.estado == 1 ? 'Activo' : 'Inactivo'}
              </span>
                        </td>
                        <td>${s.tipoServicio.nombre}</td>
                        <td><fmt:formatDate value="${s.fechaRegistro}" pattern="dd/MM/yyyy"/></td>
                        <td class="acciones-cell">
                            <div class="action-group">
                                <button type="button" class="btn-icon btn-edit" title="Editar"
                                        onclick="abrirEditar(${s.id_servicio}, '${s.nombre}', '${s.descripcion}', ${s.precio}, ${s.tipoServicio.id_tipo_servicio}, '${s.estado == 1 ? 'Activo' : 'Inactivo'}')">
                                    <img src="${pageContext.request.contextPath}/Images/edit.svg" alt="Editar" width="18" />
                                </button>
                                <button type="button" class="btn-icon btn-delete" title="Eliminar"
                                        onclick="eliminarServicio(${s.id_servicio}, '${s.nombre}')">
                                    <img src="${pageContext.request.contextPath}/Images/delete.svg" alt="Eliminar" width="18" />
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listaServicios}">
                    <tr class="fila-vacia">
                        <td colspan="7" style="text-align:center; padding: 24px;">No hay servicios registrados todavía.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
        <!-- Controles de paginación (generados dinámicamente por JS) -->
        <div class="paginacion" id="paginacion"></div>
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

<!-- ============================================================
     MODAL AGREGAR SERVICIO
     Diseño basado en la referencia "Añadir Nuevo Servicio de Auto"
============================================================ -->
<div class="modal-overlay" id="modalAgregar" onclick="cerrarOverlay(event,'modalAgregar')">
    <div class="modal-box modal-box-lg modal-servicio" onclick="event.stopPropagation()">
        <form id="formAgregar" method="POST"
              action="${pageContext.request.contextPath}/servicios"
              onsubmit="return validarYPrepararEnvio('mod')">
            <input type="hidden" name="accion" value="agregar" />

            <div class="modal-header-bar modal-header-servicio">
                <div class="modal-header-title-group">
                    <!-- ICONO: llave/herramienta de servicio (descargar de Figma) -->
                    <img src="${pageContext.request.contextPath}/Images/engranaje.svg" class="modal-header-icon" alt="" />
                    <span>Añadir Nuevo Servicio de Auto</span>
                </div>
                <!-- ICONO: engranaje de configuración (descargar de Figma) -->
                <!-- <img src="RUTA_ICONO_ENGRANAJE" class="modal-header-gear" alt="" /> -->
            </div>
            <p class="modal-subtitle">Ingrese los detalles para un nuevo tipo de servicio</p>

            <!-- Selector de Tipo de Servicio como botones (mismo orden que la referencia) -->
            <div class="modal-field">
                <label class="modal-label">Tipo de Servicio</label>
                <div class="tipo-btn-group" id="mod-tipo-group">
                    <c:forEach var="t" items="${listaTipos}">
                        <button type="button" class="tipo-btn" data-id="${t.id_tipo_servicio}" onclick="seleccionarTipo('mod', ${t.id_tipo_servicio}, this)">
                            <c:choose>
                                <c:when test="${t.nombre == 'Único'}">
                                    <img src="${pageContext.request.contextPath}/Images/servicioUnico.svg" class="tipo-btn-icon" alt="" />
                                </c:when>
                                <c:when test="${t.nombre == 'Mensual'}">
                                    <img src="${pageContext.request.contextPath}/Images/servicioMensual.svg" class="tipo-btn-icon" alt="" />
                                </c:when>
                                <c:when test="${t.nombre == 'Anual'}">
                                    <img src="${pageContext.request.contextPath}/Images/servicioAnual.svg" class="tipo-btn-icon" alt="" />
                                </c:when>
                            </c:choose>
                            <span>${t.nombre}</span>
                        </button>
                    </c:forEach>
                </div>
                <input type="hidden" id="mod-tipo" name="id_tipo_servicio" value="" />
                <span class="modal-error" id="err-tipo"></span>
            </div>

            <div class="modal-field">
                <label class="modal-label">
                    <!-- ICONO: engranaje pequeño junto al label (descargar de Figma) -->
                    <img src="${pageContext.request.contextPath}/Images/engranaje.svg" class="modal-label-icon" alt="" />
                    Nombre del Servicio
                </label>
                <input class="modal-input" type="text" placeholder="Ej: Alineación y Balanceo" id="mod-nombre-servicio" name="nombre" />
                <span class="modal-error" id="err-nombre-servicio"></span>
            </div>

            <div class="modal-field">
                <label class="modal-label">
                    <!-- ICONO: documento/descripción (descargar de Figma) -->
                   <img src="${pageContext.request.contextPath}/Images/carroServicio.svg" class="modal-label-icon" alt="" />
                    Descripción
                </label>
                <textarea class="modal-input modal-textarea" placeholder="Ej: Alineación completa y balanceo de llantas..." id="mod-descripcion" name="descripcion"></textarea>
            </div>

            <div class="modal-row">
                <div class="modal-field">
                    <label class="modal-label">
                        <!-- ICONO: signo de dólar (descargar de Figma) -->
                        <img src="${pageContext.request.contextPath}/Images/servicioCosto.svg" class="modal-label-icon" alt="" />
                        Precio Estimado
                    </label>
                    <input class="modal-input" type="number" min="0" step="0.01" placeholder="0.00" id="mod-precio" name="precio" />
                    <span class="modal-error" id="err-precio"></span>
                </div>
                <div class="modal-field">
                    <label class="modal-label">Imagen del Servicio</label>
                    <div class="modal-photo-upload" id="mod-foto-box" onclick="document.getElementById('mod-foto-input').click()">
                        <!-- El campo de imagen no se envía todavía: ADMIN.SERVICIOS no tiene columna de imagen.
                             Cuando exista, quitar disabled del input y mandarlo con enctype multipart/form-data -->
                        <input type="file" id="mod-foto-input" accept="image/jpg,image/png" hidden disabled />
                        <div class="upload-placeholder" id="mod-foto-placeholder">
                            <!-- ICONO: nube de subida (descargar de Figma) -->
                            <!-- <img src="RUTA_ICONO_UPLOAD" class="modal-label-icon" alt="" /> -->
                            <span>Haga clic para subir o arrastre y suelte una imagen (JPG, PNG)</span>
                        </div>
                        <img class="modal-photo-preview" id="mod-foto-preview" style="display:none" alt="Vista previa" />
                    </div>
                </div>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" onclick="cerrarModal('modalAgregar')">Cerrar</button>
                <button type="submit" class="btn-modal-save">Añadir Servicio</button>
            </div>
        </form>
    </div>
</div>

<!-- ============================================================
     MODAL EDITAR SERVICIO
============================================================ -->
<div class="modal-overlay" id="modalEditar" onclick="cerrarOverlay(event,'modalEditar')">
    <div class="modal-box modal-box-lg modal-servicio" onclick="event.stopPropagation()">
        <form id="formEditar" method="POST"
              action="${pageContext.request.contextPath}/servicios"
              onsubmit="return validarYPrepararEnvio('edit')">
            <input type="hidden" name="accion" value="editar" />
            <input type="hidden" name="id_servicio" id="edit-id" />

            <div class="modal-header-bar modal-header-servicio">
                <div class="modal-header-title-group">
                    <!-- <img src="RUTA_ICONO_SERVICIO" class="modal-header-icon" alt="" /> -->
                    <span>Editar Servicio de Auto</span>
                </div>
            </div>
            <p class="modal-subtitle">Modifica los detalles del servicio seleccionado</p>

            <!-- Selector de Tipo de Servicio como botones (mismo orden que la referencia) -->
            <div class="modal-field">
                <label class="modal-label">Tipo de Servicio</label>
                <div class="tipo-btn-group" id="edit-tipo-group">
                    <c:forEach var="t" items="${listaTipos}">
                        <button type="button" class="tipo-btn" data-id="${t.id_tipo_servicio}" onclick="seleccionarTipo('edit', ${t.id_tipo_servicio}, this)">
                            <!-- ICONO: propio de "${t.nombre}" (descargar de Figma) -->
                            <!-- <img src="RUTA_ICONO_TIPO_${t.id_tipo_servicio}" class="tipo-btn-icon" alt="" /> -->
                            <span>${t.nombre}</span>
                        </button>
                    </c:forEach>
                </div>
                <input type="hidden" id="edit-tipo" name="id_tipo_servicio" value="" />
                <span class="modal-error" id="edit-err-tipo"></span>
            </div>

            <div class="modal-field">
                <label class="modal-label">Nombre del Servicio</label>
                <input class="modal-input" type="text" id="edit-nombre" name="nombre" />
                <span class="modal-error" id="edit-err-nombre"></span>
            </div>

            <div class="modal-field">
                <label class="modal-label">Descripción</label>
                <textarea class="modal-input modal-textarea" id="edit-descripcion" name="descripcion"></textarea>
            </div>

            <div class="modal-row">
                <div class="modal-field">
                    <label class="modal-label">Precio Estimado</label>
                    <input class="modal-input" type="number" min="0" step="0.01" id="edit-precio" name="precio" />
                    <span class="modal-error" id="edit-err-precio"></span>
                </div>
                <div class="modal-field">
                    <label class="modal-label">Estado</label>
                    <select class="modal-select" id="edit-estado" name="estado">
                        <option value="1">Activo</option>
                        <option value="0">Inactivo</option>
                    </select>
                </div>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" onclick="cerrarModal('modalEditar')">Cerrar</button>
                <button type="submit" class="btn-modal-save">Guardar cambios</button>
            </div>
        </form>
    </div>
</div>

<!-- Formulario oculto para eliminar (POST real, no GET, por seguridad/consistencia con el servlet) -->
<form id="formEliminar" method="POST" action="${pageContext.request.contextPath}/servicios" style="display:none">
    <input type="hidden" name="accion" value="eliminar" />
    <input type="hidden" name="id_servicio" id="eliminar-id" />
</form>

<script src="${pageContext.request.contextPath}/js/duenioJS/gestionServicios.js"></script>
</body>
</html>
