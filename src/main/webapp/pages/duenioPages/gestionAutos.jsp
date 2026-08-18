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
        <a href="${pageContext.request.contextPath}/nav?action=indexDuenio" class="dash-nav-link">Inicio</a>
        <a href="${pageContext.request.contextPath}/nav?action=dashboard" class="dash-nav-link">Dashboard</a>
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
            <h1>Gestion de autos</h1>
            <p>Administra el inventario de autos registrados.</p>
        </div>

        <div class="gest-header-acciones">
            <button class="btn-agregar btn-agregar-secundario" onclick="abrirModal('modalMarcaModelo')">+ Marca / Modelo</button>
            <button class="btn-agregar" onclick="abrirModal('modalAgregar')">+ Agregar auto</button>
        </div>
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
                    <th>#</th>
                    <th>Placa</th>
                    <th>Foto</th>
                    <th>Marca</th>
                    <th>Modelo</th>
                    <th>Categoria</th>
                    <th>Precio</th>
                    <th>Año</th>
                    <th>Descripción</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="v" items="${listaVehiculos}" varStatus="fila">
                    <tr>
                        <td>${fila.count}</td>
                        <td>${v.placa}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty v.foto_Portada}">
                                    <img class="foto-thumb" src="${pageContext.request.contextPath}/Images/imagesAutos/${v.foto_Portada}" alt="${v.marca.nombre} ${v.modelos.nombre}" />
                                </c:when>
                                <c:otherwise>
                                    <div class="foto-placeholder"></div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${v.marca.nombre}</td>
                        <td>${v.modelos.nombre}</td>
                        <td>${v.tipoVehiculo.nombre}</td>
                        <td>$<fmt:formatNumber value="${v.precio}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                        <td>${v.anio}</td>
                        <td class="celda-descripcion">
                            <c:choose>
                                <c:when test="${not empty v.descripcion}">${v.descripcion}</c:when>
                                <c:otherwise><span class="asesor-sin-asignar">Sin descripción</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                  <span class="badge ${v.disponible == 1 ? 'badge-active' : 'badge-inactive'}"
                        onclick="toggleEstado(this, ${v.id_Vehiculo})">
                          ${v.disponible == 1 ? 'Activo' : 'Inactivo'}
                  </span>
                        </td>
                        <td><fmt:formatDate value="${v.fecha_registro}" pattern="dd/MM/yyyy"/></td>
                        <td class="acciones-cell">
                            <div class="action-group">
                                <button type="button" class="btn-icon btn-edit" title="Editar"
                                        onclick="abrirEditar(${v.id_Vehiculo}, ${v.marca.id_Marca}, ${v.modelos.id_Modelo}, '${v.tipoVehiculo.nombre}', ${v.precio}, '${v.color}', '${v.placa}', ${v.anio}, ${v.id_Agente}, '${v.disponible == 1 ? 'Activo' : 'Inactivo'}', '${v.foto_Portada}', '<fmt:formatDate value="${v.fecha_registro}" pattern="dd/MM/yyyy"/>')">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                </button>
                                <button type="button" class="btn-icon btn-delete" title="Eliminar"
                                        onclick="confirmarEliminarAuto(${v.id_Vehiculo})">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listaVehiculos}">
                    <tr class="fila-vacia">
                        <td colspan="12" style="text-align:center; padding: 24px;">No hay autos registrados todavía.</td>
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


<!-- Ventana emergente agregar-->
<div class="modal-overlay" id="modalAgregar" onclick="cerrarOverlay(event,'modalAgregar')">
    <div class="modal-box modal-box-lg" onclick="event.stopPropagation()">
        <form id="formAgregar" method="POST"
              action="${pageContext.request.contextPath}/gestionAutos"
              enctype="multipart/form-data"
              onsubmit="return validarYPrepararEnvio('mod')">
            <input type="hidden" name="accion" value="registrar" />

            <div class="modal-header-bar">Agregar Automóvil</div>
            <p class="modal-subtitle">Completa la información para registrar un nuevo vehículo</p>

            <div class="modal-photo-row">
                <div class="modal-photo-upload" id="mod-foto-box" onclick="document.getElementById('mod-foto-input').click()">
                    <input type="file" id="mod-foto-input" name="foto" accept="image/*" hidden onchange="previsualizarFoto(this,'mod-foto-box')" />
                    <div class="upload-placeholder" id="mod-foto-placeholder">
                        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" y1="3" x2="12" y2="15"></line></svg>
                        <span>Subir Imagen</span>
                    </div>
                    <img class="modal-photo-preview" id="mod-foto-preview" style="display:none" alt="Vista previa" />
                </div>

                <div class="modal-photo-fields">
                    <div class="modal-field">
                        <label class="modal-label">Marca *</label>
                        <select class="modal-select" id="mod-marca" name="idMarca" onchange="actualizarModelos('mod')">
                            <option value="">Selecciona...</option>
                            <c:forEach var="m" items="${listaMarcas}">
                                <option value="${m.id_Marca}">${m.nombre}</option>
                            </c:forEach>
                        </select>
                        <span class="modal-error" id="err-marca"></span>
                        <p class="modal-nota">¿No está la marca? Usa "+ Marca / Modelo" arriba para darla de alta.</p>
                    </div>
                    <div class="modal-field">
                        <label class="modal-label">Modelo *</label>
                        <select class="modal-select" id="mod-modelo" name="idModelo">
                            <option value="">Selecciona una marca primero...</option>
                        </select>
                        <span class="modal-error" id="err-modelo"></span>
                    </div>
                </div>
            </div>

            <div class="modal-row modal-row-3">
                <div class="modal-field">
                    <label class="modal-label">Año *</label>
                    <input class="modal-input" id="mod-anio" name="anio" type="number" min="1980" max="2100" placeholder="2024" />
                    <span class="modal-error" id="err-anio"></span>
                </div>
                <div class="modal-field">
                    <label class="modal-label">Tipo *</label>
                    <select class="modal-select" id="mod-categoria" name="categoria">
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
                    <input class="modal-input" id="mod-precio" name="precio" type="number" min="0" step="0.01" placeholder="0.00" />
                    <span class="modal-error" id="err-precio"></span>
                </div>
            </div>

            <div class="modal-row">
                <div class="modal-field">
                    <label class="modal-label">Color *</label>
                    <input class="modal-input" id="mod-color" name="color" type="text" placeholder="Ej. Gris Metálico" />
                    <span class="modal-error" id="err-color"></span>
                </div>
                <div class="modal-field">
                    <label class="modal-label">Placa *</label>
                    <input class="modal-input" id="mod-placa" name="placa" type="text" placeholder="Ej. ABC-123-A" />
                    <span class="modal-error" id="err-placa"></span>
                </div>
            </div>

            <div class="modal-row">
                <div class="modal-field">
                    <label class="modal-label">Agente responsable *</label>
                    <select class="modal-select" id="mod-agente" name="id_Agente">
                        <option value="">Selecciona...</option>
                        <c:forEach var="a" items="${listaAgentes}">
                            <option value="${a.idAgente}">${a.nombreCompletoUsuario}</option>
                        </c:forEach>
                    </select>
                    <span class="modal-error" id="err-agente"></span>
                </div>
                <div class="modal-field">
                    <label class="modal-label">Estado</label>
                    <select class="modal-select" id="mod-estado" name="estado">
                        <option>Activo</option>
                        <option>Inactivo</option>
                    </select>
                </div>
            </div>

            <div class="modal-field">
                <label class="modal-label">Descripción / Detalles</label>
                <textarea class="modal-input modal-textarea" id="mod-descripcion" name="descripcion" maxlength="1000"
                          placeholder="Equipamiento, condiciones, observaciones..."></textarea>
            </div>

            <div class="modal-field">
                <label class="modal-label">Imágenes adicionales (máx. 10)</label>
                <div class="galeria-extra" id="mod-galeria-extra"></div>
                <input type="file" id="mod-fotos-extra-input" name="fotosExtra" accept="image/*" multiple hidden
                       onchange="manejarFotosExtra(this, 'mod')" />
                <button type="button" class="btn-agregar-imagen" onclick="document.getElementById('mod-fotos-extra-input').click()">
                    + Agregar imágenes
                </button>
                <span class="modal-error" id="err-fotosExtra"></span>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" onclick="cerrarModal('modalAgregar')">Cancelar</button>
                <button type="button" class="btn-modal-save" onclick="confirmarGuardarAgregar()">Guardar cambios</button>
            </div>
        </form>
    </div>
</div>

<!-- ventana emergente Editar -->
<div class="modal-overlay" id="modalEditar" onclick="cerrarOverlay(event,'modalEditar')">
    <div class="modal-box modal-box-lg" onclick="event.stopPropagation()">
        <form id="formEditar" method="POST"
              action="${pageContext.request.contextPath}/gestionAutos"
              enctype="multipart/form-data"
              onsubmit="return validarYPrepararEnvio('edit')">
            <input type="hidden" name="accion" value="actualizar" />
            <input type="hidden" name="id_Vehiculo" id="edit-id" />
            <input type="hidden" name="foto_actual" id="edit-foto-actual" />
            <input type="hidden" name="eliminarImagenes" id="edit-eliminar-imagenes" />

            <div class="modal-header-bar">
                Editar Automóvil
                <span class="badge-edicion">En edición</span>
            </div>
            <p class="modal-subtitle">Modifica la información del vehículo seleccionado</p>

            <div class="modal-photo-row">
                <div class="modal-photo-upload" id="edit-foto-box" onclick="document.getElementById('edit-foto-input').click()">
                    <input type="file" id="edit-foto-input" name="foto" accept="image/*" hidden onchange="previsualizarFoto(this,'edit-foto-box')" />
                    <div class="upload-placeholder" id="edit-foto-placeholder">
                        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" y1="3" x2="12" y2="15"></line></svg>
                        <span>Subir Imagen</span>
                    </div>
                    <img class="modal-photo-preview" id="edit-foto-preview" style="display:none" alt="Vista previa" />
                </div>

                <div class="modal-photo-fields">
                    <div class="modal-field">
                        <label class="modal-label">Marca *</label>
                        <select class="modal-select" id="edit-marca" name="idMarca" onchange="actualizarModelos('edit')">
                            <option value="">Selecciona...</option>
                            <c:forEach var="m" items="${listaMarcas}">
                                <option value="${m.id_Marca}">${m.nombre}</option>
                            </c:forEach>
                        </select>
                        <span class="modal-error" id="edit-err-marca"></span>
                    </div>
                    <div class="modal-field">
                        <label class="modal-label">Modelo *</label>
                        <select class="modal-select" id="edit-modelo" name="idModelo">
                            <option value="">Selecciona una marca primero...</option>
                        </select>
                        <span class="modal-error" id="edit-err-modelo"></span>
                    </div>
                </div>
            </div>

            <div class="modal-row modal-row-3">
                <div class="modal-field">
                    <label class="modal-label">Año *</label>
                    <input class="modal-input" id="edit-anio" name="anio" type="number" min="1980" max="2100" />
                    <span class="modal-error" id="edit-err-anio"></span>
                </div>
                <div class="modal-field">
                    <label class="modal-label">Tipo *</label>
                    <select class="modal-select" id="edit-categoria" name="categoria">
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
                    <input class="modal-input" id="edit-precio" name="precio" type="number" min="0" step="0.01" />
                    <span class="modal-error" id="edit-err-precio"></span>
                </div>
            </div>

            <div class="modal-row">
                <div class="modal-field">
                    <label class="modal-label">Color *</label>
                    <input class="modal-input" id="edit-color" name="color" type="text" />
                    <span class="modal-error" id="edit-err-color"></span>
                </div>
                <div class="modal-field">
                    <label class="modal-label">Placa (no editable)</label>
                    <input class="modal-input" id="edit-placa" name="placa" type="text" readonly title="La placa es de referencia y no puede modificarse." />
                    <span class="modal-error" id="edit-err-placa"></span>
                </div>
            </div>

            <div class="modal-row">
                <div class="modal-field">
                    <label class="modal-label">Agente responsable *</label>
                    <select class="modal-select" id="edit-agente" name="id_Agente">
                        <option value="">Selecciona...</option>
                        <c:forEach var="a" items="${listaAgentes}">
                            <option value="${a.idAgente}">${a.nombreCompletoUsuario}</option>
                        </c:forEach>
                    </select>
                    <span class="modal-error" id="edit-err-agente"></span>
                </div>
                <div class="modal-field">
                    <label class="modal-label">Estado</label>
                    <select class="modal-select" id="edit-estado" name="estado">
                        <option>Activo</option>
                        <option>Inactivo</option>
                    </select>
                </div>
            </div>

            <div class="modal-field">
                <label class="modal-label">Descripción / Detalles</label>
                <textarea class="modal-input modal-textarea" id="edit-descripcion" name="descripcion" maxlength="1000"
                          placeholder="Equipamiento, condiciones, observaciones..."></textarea>
            </div>

            <div class="modal-field">
                <label class="modal-label">Imágenes adicionales (máx. 10)</label>
                <div class="galeria-extra" id="edit-galeria-extra"></div>
                <input type="file" id="edit-fotos-extra-input" name="fotosExtra" accept="image/*" multiple hidden
                       onchange="manejarFotosExtra(this, 'edit')" />
                <button type="button" class="btn-agregar-imagen" id="edit-btn-agregar-imagen"
                        onclick="document.getElementById('edit-fotos-extra-input').click()">
                    + Agregar imágenes
                </button>
                <span class="modal-error" id="edit-err-fotosExtra"></span>
            </div>

            <p class="modal-updated" id="edit-fecha-actualizado"></p>

            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" onclick="cerrarModal('modalEditar')">Cancelar</button>
                <button type="button" class="btn-modal-save" onclick="confirmarGuardarEdicion()">Guardar cambios</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Registrar marca / modelo (solo dueño). Al registrar un vehículo,
     tanto el dueño como el asesor eligen de esta lista, nunca escriben una
     marca/modelo libre. -->
<div class="modal-overlay" id="modalMarcaModelo" onclick="cerrarOverlay(event,'modalMarcaModelo')">
    <div class="modal-box" onclick="event.stopPropagation()">
        <div class="modal-header-bar">Registrar marca / modelo</div>

        <div class="modal-field" style="padding:20px 28px 0;">
            <label class="modal-label">Nueva marca</label>
            <div class="modal-row-inline">
                <input class="modal-input" id="mm-nombre-marca" type="text" placeholder="Ej. Mazda" />
                <button type="button" class="btn-modal-save" onclick="registrarMarcaNueva()">Registrar</button>
            </div>
            <span class="modal-error" id="mm-err-marca"></span>
            <span class="modal-exito" id="mm-exito-marca"></span>
        </div>

        <hr class="modal-divisor" />

        <div class="modal-field" style="padding:0 28px;">
            <label class="modal-label">Nuevo modelo</label>
            <select class="modal-select" id="mm-marca-para-modelo">
                <option value="">Selecciona una marca...</option>
                <c:forEach var="m" items="${listaMarcas}">
                    <option value="${m.id_Marca}">${m.nombre}</option>
                </c:forEach>
            </select>
            <div class="modal-row-inline">
                <input class="modal-input" id="mm-nombre-modelo" type="text" placeholder="Ej. CX-5" />
                <button type="button" class="btn-modal-save" onclick="registrarModeloNuevo()">Registrar</button>
            </div>
            <span class="modal-error" id="mm-err-modelo"></span>
            <span class="modal-exito" id="mm-exito-modelo"></span>
        </div>

        <div class="modal-actions" style="padding:0 28px 28px;">
            <button type="button" class="btn-modal-cancel" onclick="cerrarModal('modalMarcaModelo')">Cerrar</button>
        </div>
    </div>
</div>

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
                duplicado_placa: 'Ya existe un vehículo registrado con esa placa.',
                formato_placa: 'El formato de placa no es válido. Debe ser 3 letras mayúsculas, guión y 3 o 4 dígitos (ej. ABC-1234).',
                precio_invalido: 'El precio debe ser un valor numérico positivo.',
                marca_modelo_invalido: 'Selecciona una marca y un modelo válidos del catálogo.',
                vehiculo_no_encontrado: 'El vehículo que intentas editar ya no existe.',
                error_servidor: 'Ocurrió un error en el servidor. Intenta de nuevo.'
            };
            const codigo = '${param.error}';
            alert(mensajes[codigo] || 'No se pudo guardar el vehículo. Intenta de nuevo.');
        });
    </script>
</c:if>

<c:if test="${not empty param.exito}">
    <script>
        window.addEventListener('DOMContentLoaded', () => {
            const mensajesExito = {
                agregado: 'El auto se agregó correctamente.',
                editado: 'Los cambios del auto se guardaron correctamente.',
                eliminado: 'El auto se eliminó correctamente.'
            };
            document.getElementById('exitoMensaje').textContent =
                mensajesExito['${param.exito}'] || 'Operación realizada correctamente.';
            abrirModal('modalExito');
        });
    </script>
</c:if>

<script>
    // Galería de imágenes extra de cada vehículo (id → [{idImagen, ruta}]), para el modal Editar.
    const IMAGENES_POR_VEHICULO = ${empty imagenesJsonPorVehiculo ? '{}' : imagenesJsonPorVehiculo};
    // Descripción de cada vehículo (id → texto), aparte del onclick para no romper
    // el JavaScript si el dueño escribió saltos de línea en el textarea.
    const DESCRIPCION_POR_VEHICULO = ${empty descripcionJsonPorVehiculo ? '{}' : descripcionJsonPorVehiculo};
    // id de marca -> [{idModelo, nombre}], para poblar el <select> de Modelo
    // sin peticiones extra al elegir una marca.
    const MODELOS_POR_MARCA = ${empty modelosJsonPorMarca ? '{}' : modelosJsonPorMarca};
</script>
<script src="${pageContext.request.contextPath}/js/duenioJS/gestionAutos.js"></script>
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
