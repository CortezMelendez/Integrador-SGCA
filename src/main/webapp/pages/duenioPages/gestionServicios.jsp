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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vendor/bootstrap-scoped.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/perfilModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css" />
</head>
<body class="bs">

<!-- BARRA DE NAVEGACIÓN -->
<header class="dash-navbar">
    <div class="dash-navbar-left">
        <div class="dash-logo-placeholder" aria-hidden="true">
            <img src="${pageContext.request.contextPath}/Images/logo2-SGCA.svg" class="logo-img" width="108" />
        </div>
        <span class="dash-brand">Concesionaria Automotriz</span>
    </div>
    <nav class="dash-nav-center">
        <a href="${pageContext.request.contextPath}/nav?action=inicio" class="dash-nav-link">Inicio</a>
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
                    <th>#</th>
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
                <c:forEach var="s" items="${listaServicios}" varStatus="fila">
                    <tr>
                        <td>${fila.count}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty s.foto}">
                                    <img class="foto-thumb" src="${pageContext.request.contextPath}/${s.foto}" alt="${s.nombre}" />
                                </c:when>
                                <c:otherwise>
                                    <div class="foto-placeholder"></div>
                                </c:otherwise>
                            </c:choose>
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
                                        onclick="abrirEditar(${s.id_servicio}, '${s.nombre}', '${s.descripcion}', ${s.precio}, ${s.tipoServicio.id_tipo_servicio}, '${s.estado == 1 ? 'Activo' : 'Inactivo'}', '${s.foto}')">
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
                        <td colspan="8" style="text-align:center; padding: 24px;">No hay servicios registrados todavía.</td>
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
    <span>© 2026 SGCA · Todos los derechos reservados</span>
    <a href="${pageContext.request.contextPath}/nav?action=dashboard" class="btn-back">
        <img src="${pageContext.request.contextPath}/Images/back.svg" alt="Atrás" />
        Atrás
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
              enctype="multipart/form-data"
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
                <span class="modal-error" id="err-descripcion"></span>
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
                        <input type="file" id="mod-foto-input" name="foto" accept="image/jpg,image/jpeg,image/png" hidden onchange="previsualizarFoto(this,'mod-foto-box')" />
                        <div class="upload-placeholder" id="mod-foto-placeholder">
                            <span>Haga clic para subir o arrastre y suelte una imagen (JPG, PNG)</span>
                        </div>
                        <img class="modal-photo-preview" id="mod-foto-preview" style="display:none" alt="Vista previa" />
                    </div>
                </div>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" onclick="cerrarModal('modalAgregar')">Cerrar</button>
                <button type="button" class="btn-modal-save" onclick="confirmarGuardarAgregar()">Añadir Servicio</button>
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
              enctype="multipart/form-data"
              onsubmit="return validarYPrepararEnvio('edit')">
            <input type="hidden" name="accion" value="editar" />
            <input type="hidden" name="id_servicio" id="edit-id" />
            <input type="hidden" name="foto_actual" id="edit-foto-actual" />

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
                <span class="modal-error" id="edit-err-descripcion"></span>
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

            <div class="modal-field">
                <label class="modal-label">Imagen del Servicio</label>
                <div class="modal-photo-upload" id="edit-foto-box" onclick="document.getElementById('edit-foto-input').click()">
                    <input type="file" id="edit-foto-input" name="foto" accept="image/jpg,image/jpeg,image/png" hidden onchange="previsualizarFoto(this,'edit-foto-box')" />
                    <div class="upload-placeholder" id="edit-foto-placeholder">
                        <span>Haga clic para subir o arrastre y suelte una imagen (JPG, PNG)</span>
                    </div>
                    <img class="modal-photo-preview" id="edit-foto-preview" style="display:none" alt="Vista previa" />
                </div>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" onclick="cerrarModal('modalEditar')">Cerrar</button>
                <button type="button" class="btn-modal-save" onclick="confirmarGuardarEdicion()">Guardar cambios</button>
            </div>
        </form>
    </div>
</div>

<!-- Formulario oculto para eliminar (POST real, no GET, por seguridad/consistencia con el servlet) -->
<form id="formEliminar" method="POST" action="${pageContext.request.contextPath}/servicios" style="display:none">
    <input type="hidden" name="accion" value="eliminar" />
    <input type="hidden" name="id_servicio" id="eliminar-id" />
</form>

<!-- Modal de confirmación (reemplaza los confirm() del navegador) -->
<div class="modal-overlay" id="modalConfirmar" onclick="cerrarOverlay(event,'modalConfirmar')">
    <div class="modal-box modal-confirm-box" onclick="event.stopPropagation()">
        <div class="modal-confirm-icon" id="confirmIcono">!</div>
        <h3 class="modal-confirm-title" id="confirmTitulo">Confirmar acción</h3>
        <p class="modal-confirm-msg" id="confirmMensaje">¿Estás seguro?</p>
        <div class="modal-actions modal-confirm-actions">
            <button type="button" class="btn-modal-cancel" onclick="cerrarModal('modalConfirmar')">Cancelar</button>
            <button type="button" class="btn-modal-save" id="confirmBtnAceptar">Confirmar</button>
        </div>
    </div>
</div>

<!-- Modal de éxito (se muestra tras guardar/editar/eliminar correctamente) -->
<div class="modal-overlay" id="modalExito" onclick="cerrarOverlay(event,'modalExito')">
    <div class="modal-box modal-confirm-box" onclick="event.stopPropagation()">
        <div class="modal-confirm-icon icono-guardar">✓</div>
        <h3 class="modal-confirm-title">¡Listo!</h3>
        <p class="modal-confirm-msg" id="exitoMensaje">Operación realizada correctamente.</p>
        <div class="modal-actions modal-confirm-actions">
            <button type="button" class="btn-modal-save" onclick="cerrarTodoYMostrarTabla()">Aceptar</button>
        </div>
    </div>
</div>

<c:if test="${not empty param.error}">
    <script>
        window.addEventListener('DOMContentLoaded', () => {
            const mensajes = {
                duplicado_nombre: 'Ya existe un servicio registrado con ese nombre.',
                error_servidor: 'Ocurrió un error en el servidor. Intenta de nuevo.'
            };
            const codigo = '${param.error}';
            alert(mensajes[codigo] || 'No se pudo guardar el servicio. Intenta de nuevo.');
        });
    </script>
</c:if>

<c:if test="${not empty param.exito}">
    <script>
        window.addEventListener('DOMContentLoaded', () => {
            const mensajesExito = {
                agregado: 'El servicio se agregó correctamente.',
                editado: 'Los cambios del servicio se guardaron correctamente.',
                eliminado: 'El servicio se eliminó correctamente.'
            };
            document.getElementById('exitoMensaje').textContent =
                mensajesExito['${param.exito}'] || 'Operación realizada correctamente.';
            abrirModal('modalExito');
        });
    </script>
</c:if>

<script src="${pageContext.request.contextPath}/js/duenioJS/gestionServicios.js"></script>
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
