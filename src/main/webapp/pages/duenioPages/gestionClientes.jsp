<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Gestión de Clientes — Concesionaria Automotriz</title>
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
        <h1>Gestión de clientes</h1>
        <p>Administra los clientes registrados.</p>
      </div>

      <button class="btn-agregar" onclick="abrirModal('modalAgregar')">+ Agregar cliente</button>
    </div>
    <div class="gest-search-inline">
        <input class="gest-input" type="text" placeholder="Buscar cliente por nombre, RFC o correo..." oninput="filtrar(this.value)" />
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
              <th>Nombre</th>
              <th>RFC</th>
              <th>Teléfono</th>
              <th>CURP</th>
              <th>Correo</th>
              <th>Asesor</th>
              <th>Fecha de registro</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="u" items="${listaUsuarios}" varStatus="fila">
              <c:set var="nombreCompleto" value="${u.nombre} ${u.apellidoPaterno} ${u.apellidoMaterno}" />
              <c:set var="nombreAsesor" value="${asesorPorCliente[u.id_usuario]}" />
              <c:set var="idClienteRow" value="${idClientePorUsuario[u.id_usuario]}" />
              <c:set var="idAgenteRow" value="${idAgentePorUsuario[u.id_usuario]}" />
              <tr>
                <td>${fila.count}</td>
                <td>
                  <div class="nombre-cell">
                    <span class="avatar-circle">${fn:substring(u.nombre,0,1)}${fn:substring(u.apellidoPaterno,0,1)}</span>
                    <span>${nombreCompleto}</span>
                  </div>
                </td>
                <td>${u.rfc}</td>
                <td>${u.telefono}</td>
                <td>${u.curp}</td>
                <td>${u.correo}</td>
                <td>
                  <button type="button" class="btn-asesor" title="Asignar asesor"
                          onclick="abrirModalAsesor(this, ${empty idClienteRow ? 0 : idClienteRow}, ${empty idAgenteRow ? 0 : idAgenteRow})">
                    <c:choose>
                      <c:when test="${empty nombreAsesor or nombreAsesor == 'Sin Agente Asignado'}">
                        <span class="asesor-sin-asignar">Sin asesor asignado</span>
                      </c:when>
                      <c:otherwise>${nombreAsesor}</c:otherwise>
                    </c:choose>
                  </button>
                </td>
                <td><fmt:formatDate value="${u.fechaRegistro}" pattern="dd/MM/yyyy"/></td>
                <td>
                  <span class="badge ${u.estado == 1 ? 'badge-active' : 'badge-inactive'}"
                        onclick="toggleEstado(this, ${u.id_usuario})">
                    ${u.estado == 1 ? 'Activo' : 'Inactivo'}
                  </span>
                </td>
                <td class="acciones-cell">
                  <div class="action-group">
                    <button type="button" class="btn-icon btn-edit" title="Editar"
                            onclick="abrirEditar(${u.id_usuario}, '${u.nombre}', '${u.apellidoPaterno}', '${u.apellidoMaterno}', '${u.rfc}', '${u.telefono}', '${u.curp}', '${u.correo}', '${u.estado == 1 ? 'Activo' : 'Inactivo'}')">
                      <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 26 26" fill="none"><path d="M2.83333 22.6667H4.85208L18.7 8.81875L16.6812 6.8L2.83333 20.6479V22.6667ZM0 25.5V19.4792L18.7 0.814583C18.9833 0.554861 19.2964 0.354167 19.6393 0.2125C19.9821 0.0708335 20.3419 0 20.7188 0C21.0956 0 21.4616 0.0708335 21.8167 0.2125C22.1718 0.354167 22.4787 0.566666 22.7375 0.85L24.6854 2.83333C24.9688 3.09306 25.1756 3.4 25.3059 3.75417C25.4363 4.10833 25.5009 4.4625 25.5 4.81667C25.5 5.19444 25.4353 5.55475 25.3059 5.89758C25.1765 6.24042 24.9697 6.55303 24.6854 6.83542L6.02083 25.5H0ZM17.6729 7.82708L16.6812 6.8L18.7 8.81875L17.6729 7.82708Z" fill="currentColor"/></svg>
                    </button>
                    <button type="button" class="btn-icon btn-delete" title="Eliminar"
                            onclick="confirmarEliminarUsuario(${u.id_usuario})">
                      <svg xmlns="http://www.w3.org/2000/svg" width="13" height="14" viewBox="0 0 14 15" fill="none"><path d="M2.5 15C2.04167 15 1.64944 14.8369 1.32333 14.5108C0.997222 14.1847 0.833889 13.7922 0.833333 13.3333V2.5H0V0.833333H4.16667V0H9.16667V0.833333H13.3333V2.5H12.5V13.3333C12.5 13.7917 12.3369 14.1842 12.0108 14.5108C11.6847 14.8375 11.2922 15.0006 10.8333 15H2.5ZM10.8333 2.5H2.5V13.3333H10.8333V2.5ZM4.16667 11.6667H5.83333V4.16667H4.16667V11.6667ZM7.5 11.6667H9.16667V4.16667H7.5V11.6667Z" fill="currentColor"/></svg>
                    </button>
                  </div>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty listaUsuarios}">
              <tr>
                <td colspan="10" style="text-align:center; padding: 24px;">No hay clientes registrados todavía.</td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>

  </main>

  <!-- FOOTER -->
  <footer class="footer">
      <span>© 2026 SGCA · Todos los derechos reservados</span>
      <a href="${pageContext.request.contextPath}/nav?action=dashboard" class="btn-back">
          <img src="${pageContext.request.contextPath}/Images/back.svg" alt="atras" />
          Atras
      </a>
  </footer>

  <!-- MODALES -->
  <!-- Modal Agregar -->
  <div class="modal-overlay" id="modalAgregar" onclick="cerrarOverlay(event,'modalAgregar')">
    <div class="modal-box modal-box-lg" onclick="event.stopPropagation()">
      <form id="formAgregar" method="POST"
            action="${pageContext.request.contextPath}/gestionUsuarios"
            onsubmit="return validarYPrepararEnvio('mod')">
        <input type="hidden" name="accion" value="registrar" />
        <input type="hidden" name="idRol" value="3" />

        <div class="modal-header-bar">Agregar Cliente</div>
        <p class="modal-subtitle">Completa la información para registrar un nuevo cliente</p>

        <div class="modal-row">
          <div class="modal-field">
            <label class="modal-label">Nombre(s) *</label>
            <input class="modal-input" type="text" id="mod-nombre" name="nombre" maxlength="40" placeholder="Ej. Juan" />
            <span class="modal-error" id="err-nombre"></span>
          </div>
          <div class="modal-field">
            <label class="modal-label">Apellido paterno *</label>
            <input class="modal-input" type="text" id="mod-apellidoPaterno" name="apellidoPaterno" maxlength="40" placeholder="Ej. Pérez" />
            <span class="modal-error" id="err-apellidoPaterno"></span>
          </div>
        </div>
        <div class="modal-row">
          <div class="modal-field">
            <label class="modal-label">Apellido materno</label>
            <input class="modal-input" type="text" id="mod-apellidoMaterno" name="apellidoMaterno" maxlength="40" placeholder="Ej. López" />
            <span class="modal-error" id="err-apellidoMaterno"></span>
          </div>
          <div class="modal-field">
            <label class="modal-label">Correo *</label>
            <input class="modal-input" type="email" id="mod-correo" name="correo" maxlength="80" placeholder="Ej. correo@ejemplo.com" />
            <span class="modal-error" id="err-correo"></span>
          </div>
        </div>
        <div class="modal-row">
          <div class="modal-field">
            <label class="modal-label">RFC *</label>
            <input class="modal-input" type="text" id="mod-rfc" name="rfc" maxlength="13" placeholder="Ej. PELJ900101AB1" />
            <span class="modal-error" id="err-rfc"></span>
          </div>
          <div class="modal-field">
            <label class="modal-label">Teléfono *</label>
            <input class="modal-input" type="tel" id="mod-telefono" name="telefono" maxlength="10" placeholder="Ej. 7771234567" />
            <span class="modal-error" id="err-telefono"></span>
          </div>
        </div>
        <div class="modal-row">
          <div class="modal-field">
            <label class="modal-label">CURP *</label>
            <input class="modal-input" type="text" id="mod-curp" name="curp" maxlength="18" placeholder="Ej. PELJ900101HMLRPN01" />
            <span class="modal-error" id="err-curp"></span>
          </div>
          <div class="modal-field">
            <label class="modal-label">Contraseña temporal *</label>
            <input class="modal-input" type="password" id="mod-password" name="password" maxlength="30" placeholder="Mínimo 8 caracteres" />
            <span class="modal-error" id="err-password"></span>
          </div>
        </div>
        <div class="modal-row">
          <div class="modal-field">
            <label class="modal-label">Estado</label>
            <select class="modal-select" id="mod-estado" name="estado">
              <option>Activo</option>
              <option>Inactivo</option>
            </select>
          </div>
          <div class="modal-field"></div>
        </div>

        <div class="modal-actions">
          <button type="button" class="btn-modal-cancel" onclick="cerrarModal('modalAgregar')">Cancelar</button>
          <button type="button" class="btn-modal-save" onclick="confirmarGuardarAgregar()">Guardar cambios</button>
        </div>
      </form>
    </div>
  </div>

  <!-- Modal Editar -->
  <div class="modal-overlay" id="modalEditar" onclick="cerrarOverlay(event,'modalEditar')">
    <div class="modal-box modal-box-lg" onclick="event.stopPropagation()">
      <form id="formEditar" method="POST"
            action="${pageContext.request.contextPath}/gestionUsuarios"
            onsubmit="return validarYPrepararEnvio('edit')">
        <input type="hidden" name="accion" value="actualizar" />
        <input type="hidden" name="idRol" value="3" />
        <input type="hidden" name="id_usuario" id="edit-id" />

        <div class="modal-header-bar">
          Editar Cliente
          <span class="badge-edicion">En edición</span>
        </div>
        <p class="modal-subtitle">Modifica la información del cliente seleccionado</p>

        <div class="modal-row">
          <div class="modal-field">
            <label class="modal-label">Nombre(s) *</label>
            <input class="modal-input" type="text" id="edit-nombre" name="nombre" maxlength="40" />
            <span class="modal-error" id="edit-err-nombre"></span>
          </div>
          <div class="modal-field">
            <label class="modal-label">Apellido paterno *</label>
            <input class="modal-input" type="text" id="edit-apellidoPaterno" name="apellidoPaterno" maxlength="40" />
            <span class="modal-error" id="edit-err-apellidoPaterno"></span>
          </div>
        </div>
        <div class="modal-row">
          <div class="modal-field">
            <label class="modal-label">Apellido materno</label>
            <input class="modal-input" type="text" id="edit-apellidoMaterno" name="apellidoMaterno" maxlength="40" />
            <span class="modal-error" id="edit-err-apellidoMaterno"></span>
          </div>
          <div class="modal-field">
            <label class="modal-label">Correo *</label>
            <input class="modal-input" type="email" id="edit-correo" name="correo" maxlength="80" />
            <span class="modal-error" id="edit-err-correo"></span>
          </div>
        </div>
        <div class="modal-row">
          <div class="modal-field">
            <label class="modal-label">RFC *</label>
            <input class="modal-input" type="text" id="edit-rfc" name="rfc" maxlength="13" />
            <span class="modal-error" id="edit-err-rfc"></span>
          </div>
          <div class="modal-field">
            <label class="modal-label">Teléfono *</label>
            <input class="modal-input" type="tel" id="edit-telefono" name="telefono" maxlength="10" />
            <span class="modal-error" id="edit-err-telefono"></span>
          </div>
        </div>
        <div class="modal-row">
          <div class="modal-field">
            <label class="modal-label">CURP *</label>
            <input class="modal-input" type="text" id="edit-curp" name="curp" maxlength="18" />
            <span class="modal-error" id="edit-err-curp"></span>
          </div>
          <div class="modal-field">
            <label class="modal-label">Estado</label>
            <select class="modal-select" id="edit-estado" name="estado">
              <option>Activo</option>
              <option>Inactivo</option>
            </select>
          </div>
        </div>

        <div class="modal-actions">
          <button type="button" class="btn-modal-cancel" onclick="cerrarModal('modalEditar')">Cancelar</button>
          <button type="button" class="btn-modal-save" onclick="confirmarGuardarEdicion()">Guardar cambios</button>
        </div>
      </form>
    </div>
  </div>

  <!-- Modal Asignar Asesor -->
  <div class="modal-overlay" id="modalAsesor" onclick="cerrarOverlay(event,'modalAsesor')">
    <div class="modal-box" onclick="event.stopPropagation()">
      <div class="modal-header-bar">Asignar asesor</div>
      <p class="modal-subtitle">Selecciona el asesor que atenderá a este cliente.</p>

      <input type="hidden" id="asesor-idCliente" />

      <div class="modal-field">
        <label class="modal-label">Asesor</label>
        <select class="modal-select" id="asesor-select">
          <option value="">Sin asesor asignado</option>
          <c:forEach var="a" items="${listaAgentes}">
            <c:if test="${a.estado == 1}">
              <option value="${a.idAgente}">${a.nombreCompletoUsuario}</option>
            </c:if>
          </c:forEach>
        </select>
        <span class="modal-error" id="err-asesor"></span>
      </div>

      <div class="modal-actions">
        <button type="button" class="btn-modal-cancel" onclick="cerrarModal('modalAsesor')">Cancelar</button>
        <button type="button" class="btn-modal-save" onclick="guardarAsesor()">Guardar</button>
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
          duplicado_correo: 'Ya existe un usuario registrado con ese correo.',
          duplicado_rfc: 'Ya existe un usuario registrado con ese RFC.',
          duplicado_curp: 'Ya existe un usuario registrado con ese CURP.',
          duplicado_telefono: 'Ya existe un usuario registrado con ese teléfono.',
          password_invalido: 'La contraseña debe tener al menos 8 caracteres.',
          no_se_pudo_eliminar: 'No se pudo eliminar: el cliente tiene compras o servicios contratados en su historial.',
          error_vinculo_cliente: 'El usuario se creó, pero no se pudo vincular como cliente. Intenta de nuevo.',
          error_servidor: 'Ocurrió un error en el servidor. Intenta de nuevo.'
        };
        const codigo = '${param.error}';
        alert(mensajes[codigo] || 'No se pudo guardar el cliente. Verifica que el correo, RFC, CURP y teléfono no estén ya registrados.');
      });
    </script>
  </c:if>

  <c:if test="${not empty param.exito}">
    <script>
      window.addEventListener('DOMContentLoaded', () => {
        const mensajesExito = {
          agregado: 'El cliente se agregó correctamente.',
          editado: 'Los cambios del cliente se guardaron correctamente.',
          eliminado: 'El cliente se eliminó correctamente.'
        };
        document.getElementById('exitoMensaje').textContent =
          mensajesExito['${param.exito}'] || 'Operación realizada correctamente.';
        abrirModal('modalExito');
      });
    </script>
  </c:if>

  <script src="${pageContext.request.contextPath}/js/duenioJS/gestionClientes.js"></script>
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
