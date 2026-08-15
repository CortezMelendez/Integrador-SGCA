<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestión de Empleados — Concesionaria Automotriz</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&family=Google+Sans+Code:ital,wght@1,300..800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/gestiones.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/responsive.css" />
</head>
<body>

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
            <h1>Gestión de empleados</h1>
            <p>Administra los empleados registrados.</p>
        </div>

        <button class="btn-agregar" onclick="abrirModal('modalAgregar')">+ Agregar empleado</button>
    </div>
    <div class="gest-search-inline">
        <input class="gest-input" type="text" placeholder="Buscar empleado por nombre, RFC o correo..." oninput="filtrar(this.value)" />
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
                    <th>Clientes</th>
                    <th>Fecha de registro</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${listaUsuarios}" varStatus="fila">
                    <c:set var="nombreCompleto" value="${u.nombre} ${u.apellidoPaterno} ${u.apellidoMaterno}" />
                    <tr data-clientes="${clientesPorAgente[u.id_usuario]}">
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
                            <button type="button" class="btn-ver-clientes"
                                    onclick="verClientesAgente(${u.id_usuario}, '${nombreCompleto}')">
                                ${clientesPorAgente[u.id_usuario]} cliente(s)
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
                                <button type="button" class="btn-icon btn-delete" title="Dar de baja"
                                        onclick="confirmarEliminarUsuario(${u.id_usuario}, '${nombreCompleto}', ${clientesPorAgente[u.id_usuario]})">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="13" height="14" viewBox="0 0 14 15" fill="none"><path d="M2.5 15C2.04167 15 1.64944 14.8369 1.32333 14.5108C0.997222 14.1847 0.833889 13.7922 0.833333 13.3333V2.5H0V0.833333H4.16667V0H9.16667V0.833333H13.3333V2.5H12.5V13.3333C12.5 13.7917 12.3369 14.1842 12.0108 14.5108C11.6847 14.8375 11.2922 15.0006 10.8333 15H2.5ZM10.8333 2.5H2.5V13.3333H10.8333V2.5ZM4.16667 11.6667H5.83333V4.16667H4.16667V11.6667ZM7.5 11.6667H9.16667V4.16667H7.5V11.6667Z" fill="currentColor"/></svg>
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listaUsuarios}">
                    <tr>
                        <td colspan="10" style="text-align:center; padding: 24px;">No hay empleados registrados todavía.</td>
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

<!-- MODALES -->
<!-- Modal Agregar -->
<div class="modal-overlay" id="modalAgregar" onclick="cerrarOverlay(event,'modalAgregar')">
    <div class="modal-box modal-box-lg" onclick="event.stopPropagation()">
        <form id="formAgregar" method="POST"
              action="${pageContext.request.contextPath}/gestionUsuarios"
              onsubmit="return validarYPrepararEnvio('mod')">
            <input type="hidden" name="accion" value="registrar" />
            <input type="hidden" name="idRol" value="2" />

            <div class="modal-header-bar">Agregar Empleado</div>
            <p class="modal-subtitle">Completa la información para registrar un nuevo empleado</p>

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
            <input type="hidden" name="idRol" value="2" />
            <input type="hidden" name="id_usuario" id="edit-id" />

            <div class="modal-header-bar">
                Editar Empleado
                <span class="badge-edicion">En edición</span>
            </div>
            <p class="modal-subtitle">Modifica la información del empleado seleccionado</p>

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

<!-- Modal Transferir clientes al dar de baja -->
<div class="modal-overlay" id="modalTransferir" onclick="cerrarOverlay(event,'modalTransferir')">
    <div class="modal-box" onclick="event.stopPropagation()">
        <div class="modal-header-bar">Transferir clientes</div>
        <p class="modal-subtitle">
            <strong id="transferirNombreAgente"></strong> tiene
            <strong id="transferirClientesActivos"></strong> cliente(s) activo(s).
            Selecciona a qué agente se transferirán antes de darlo de baja.
        </p>

        <div class="modal-field">
            <label class="modal-label">Agente receptor *</label>
            <select class="modal-select" id="transferirReceptor">
                <option value="">Selecciona un agente...</option>
                <c:forEach var="a" items="${listaUsuarios}">
                    <c:if test="${a.estado == 1}">
                        <option value="${a.id_usuario}">${a.nombre} ${a.apellidoPaterno}</option>
                    </c:if>
                </c:forEach>
            </select>
            <span class="modal-error" id="err-transferirReceptor"></span>
        </div>

        <div class="modal-actions">
            <button type="button" class="btn-modal-cancel" onclick="cerrarModal('modalTransferir')">Cancelar</button>
            <button type="button" class="btn-modal-delete" onclick="confirmarTransferenciaYBaja()">Transferir y dar de baja</button>
        </div>
    </div>
</div>

<!-- Modal "Ver clientes" del agente: lista con filtro de búsqueda, igual al de la tabla -->
<div class="modal-overlay" id="modalClientesAgente" onclick="cerrarOverlay(event,'modalClientesAgente')">
    <div class="modal-box" onclick="event.stopPropagation()">
        <div class="modal-header-bar">
            Clientes de <span id="clientesAgenteNombre">&nbsp;</span>
        </div>
        <div class="gest-search-inline" style="margin-top:16px;">
            <input class="gest-input" type="text" id="clientesAgenteBuscador"
                   placeholder="Buscar cliente por nombre o correo..."
                   oninput="filtrarClientesAgente(this.value)" />
            <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
        </div>
        <ul class="clientes-agente-lista" id="clientesAgenteLista"></ul>
        <div class="modal-actions">
            <button type="button" class="btn-modal-cancel" onclick="cerrarModal('modalClientesAgente')">Cerrar</button>
        </div>
    </div>
</div>

<!-- Detalle de clientes por agente (JSON), consumido por verClientesAgente() en gestionEmpleado.js -->
<script>
    const CLIENTES_POR_AGENTE = ${clientesJsonPorAgente};
</script>

<c:if test="${not empty param.error}">
    <script>
        window.addEventListener('DOMContentLoaded', () => {
            const mensajes = {
                clientes_activos: 'Este agente tiene clientes activos. Debes transferirlos a otro agente antes de darlo de baja.',
                receptor_requerido: 'Selecciona un agente receptor para transferir los clientes.',
                receptor_invalido: 'El agente receptor debe ser distinto al agente que se da de baja.',
                error_transferencia: 'No se pudo transferir los clientes. Intenta de nuevo.',
                error_baja: 'No se pudo dar de baja al empleado. Intenta de nuevo.',
                no_se_pudo_eliminar: 'No se pudo eliminar el empleado.',
                duplicado_correo: 'Ya existe un usuario registrado con ese correo.',
                duplicado_rfc: 'Ya existe un usuario registrado con ese RFC.',
                duplicado_curp: 'Ya existe un usuario registrado con ese CURP.',
                duplicado_telefono: 'Ya existe un usuario registrado con ese teléfono.',
                password_invalido: 'La contraseña debe tener al menos 8 caracteres.',
                error_vinculo_agente: 'El empleado se creó, pero no se pudo vincular como agente. Contacta soporte.',
                error_servidor: 'Ocurrió un error en el servidor. Intenta de nuevo.'
            };
            const codigo = '${param.error}';
            alert(mensajes[codigo] || 'No se pudo guardar el empleado. Verifica que el correo, RFC, CURP y teléfono no estén ya registrados.');
        });
    </script>
</c:if>

<c:if test="${not empty param.exito}">
    <script>
        window.addEventListener('DOMContentLoaded', () => {
            const mensajesExito = {
                agregado: 'El empleado se agregó correctamente.',
                editado: 'Los cambios del empleado se guardaron correctamente.',
                eliminado: 'El empleado se eliminó correctamente.'
            };
            document.getElementById('exitoMensaje').textContent =
                mensajesExito['${param.exito}'] || 'Operación realizada correctamente.';
            abrirModal('modalExito');
        });
    </script>
</c:if>

<script src="${pageContext.request.contextPath}/js/duenioJS/gestionEmpleado.js"></script>
</body>
</html>