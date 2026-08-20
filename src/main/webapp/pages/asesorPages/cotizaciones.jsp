<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mis cotizaciones · Concesionaria Automotriz</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/gestiones.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vendor/bootstrap-scoped.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/asesorStyles/cotizacionModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/comprobanteVenta.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/serviciosModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/perfilModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body class="bs">

<!-- NAVBAR -->
<header class="dash-navbar">

    <div class="dash-navbar-left">
        <div class="dash-logo-placeholder" aria-hidden="true">
            <img src="${pageContext.request.contextPath}/Images/logo2-SGCA.svg" class="logo-img" width="108" />
        </div>
        <a href="${pageContext.request.contextPath}/asesor" class="dash-brand">
            Concesionaria Automotriz
        </a>
    </div>

    <nav class="dash-nav-center">

        <a href="${pageContext.request.contextPath}/asesor" class="dash-nav-link">
            Inicio
        </a>

        <div class="dropdown">
            <button class="dash-nav-link dropdown-btn">
                Vehículos ▾
            </button>
            <div class="dropdown-menu">
                <a href="${pageContext.request.contextPath}/automoviles">Ver todos</a>
            </div>
        </div>

        <div class="dropdown">
            <button class="dash-nav-link dropdown-btn">
                Gestionar ▾
            </button>
            <div class="dropdown-menu">
                <a href="${pageContext.request.contextPath}/gestionClienteAsesor">Gestionar Clientes</a>
                <a href="${pageContext.request.contextPath}/gestionAutoAsesor">Registrar auto</a>
            </div>
        </div>

        <button type="button" class="dash-nav-link" id="btnAbrirServicios">
            Servicios
        </button>

        <a href="${pageContext.request.contextPath}/cotizacionesAsesor" class="dash-nav-link active">
            Cotizaciones
        </a>

        <a href="${pageContext.request.contextPath}/historialAsesor" class="dash-nav-link">
            Historial de ventas
        </a>

        <div class="dropdown">
            <button class="dash-nav-link dropdown-btn">
                Configuración ▾
            </button>
            <div class="dropdown-menu">
                <a href="#" id="btnAbrirPerfil">Perfil</a>
                <a href="${pageContext.request.contextPath}/logout">Cerrar sesión</a>
            </div>
        </div>

    </nav>

</header>

<!-- MODAL SERVICIOS -->
<div class="modal-overlay" id="modalServicios">

    <div class="modal-box modal-box-servicios">

        <div class="modal-header-bar">
            <span>Catálogo de servicios</span>
            <button type="button" class="modal-cerrar" id="btnCerrarServicios" aria-label="Cerrar">&times;</button>
        </div>

        <div class="modal-servicios-grid">

            <c:forEach var="s" items="${servicios}">

                <div class="card-servicio">

                    <div class="servicio-encabezado">
                        <h3>${s.nombre}</h3>
                        <span class="servicio-tipo">${s.tipoServicio.nombre}</span>
                    </div>

                    <p class="servicio-descripcion">${s.descripcion}</p>

                    <h2>$${s.precio}</h2>

                </div>

            </c:forEach>

            <c:if test="${empty servicios}">
                <p class="servicios-vacio">Por el momento no hay servicios disponibles.</p>
            </c:if>

        </div>

    </div>

</div>

<!-- MODAL PERFIL -->
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
                        <label class="perfil-form-label" for="perfilConfirmarPassword">Confirmar nueva contraseña</label>
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
            <h1>Mis cotizaciones</h1>
            <p>Arma una cotización para un cliente de tu cartera; al confirmarla queda registrada como venta.</p>
        </div>

        <button class="btn-agregar" onclick="abrirModalCotizacion()">+ Nueva cotización</button>
    </div>
    <div class="gest-search-inline">
        <input class="gest-input" type="text" placeholder="Buscar por cliente o vehículo..." oninput="filtrarTabla(this.value)" />
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
                    <th>Folio</th>
                    <th>Cliente</th>
                    <th>Vehículo</th>
                    <th>Servicios</th>
                    <th>Total</th>
                    <th>Fecha</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="venta" items="${cotizaciones}" varStatus="fila">
                    <c:choose>
                        <c:when test="${empty venta.detalles}">
                            <c:set var="serviciosVentaTexto" value="—"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="serviciosVentaTexto"><c:forEach var="d" items="${venta.detalles}" varStatus="st">${d.servicio.nombre}<c:if test="${!st.last}">, </c:if></c:forEach></c:set>
                        </c:otherwise>
                    </c:choose>
                    <tr>
                        <td>${fila.count}</td>
                        <td>${venta.id_venta}</td>
                        <td>${venta.cliente.nombreCliente}</td>
                        <td>${venta.vehiculo.marca.nombre} ${venta.vehiculo.modelos.nombre} — ${venta.vehiculo.placa}</td>
                        <td>${serviciosVentaTexto}</td>
                        <td>$<fmt:formatNumber value="${venta.total}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                        <td><fmt:formatDate value="${venta.fechaVenta}" pattern="dd/MM/yyyy"/></td>
                        <td>
                            <button type="button" class="btn-contratar-servicio"
                                    onclick="abrirContratarServicio(${venta.id_venta}, '${venta.vehiculo.marca.nombre} ${venta.vehiculo.modelos.nombre} — ${venta.vehiculo.placa}')">
                                + Contratar servicio
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty cotizaciones}">
                    <tr class="fila-vacia">
                        <td colspan="8" style="text-align:center; padding: 24px;">Todavía no has registrado ninguna cotización.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
        <div class="paginacion" id="paginacion"></div>
    </div>

</main>

<!-- FOOTER -->
<footer class="footer">
    <span>© 2026 SGCA · Todos los derechos reservados</span>
    <a href="${pageContext.request.contextPath}/asesor" class="btn-back">
        <img src="${pageContext.request.contextPath}/Images/back.svg" alt="Atrás" />
        Atrás
    </a>
</footer>

<!-- MODAL NUEVA COTIZACION -->
<div class="modal-overlay" id="modalCotizacion" onclick="cerrarOverlay(event,'modalCotizacion')">
    <div class="modal-box modal-box-lg" onclick="event.stopPropagation()">

        <div class="modal-header-bar">
            <span>Nueva cotización</span>
            <button type="button" class="modal-cerrar" onclick="cerrarModal('modalCotizacion')" aria-label="Cerrar">&times;</button>
        </div>
        <p class="modal-subtitle">Busca al cliente, el vehículo y los servicios adicionales que quiere contratar.</p>

        <div class="cotizacion-body">

            <div class="cotizacion-seccion">
                <h4>Cliente *</h4>
                <input class="modal-input" type="text" id="buscarCliente" placeholder="Buscar cliente por nombre..." oninput="filtrarBuscador('cliente', this.value)" autocomplete="off" />
                <div class="lista-buscable" id="listaClientes"></div>
                <p class="perfil-nota" id="clienteSeleccionadoTxt">Ningún cliente seleccionado.</p>
                <c:if test="${empty clientesAsesor}">
                    <p class="servicios-vacio">Todavía no tienes clientes registrados en tu cartera.</p>
                </c:if>
                <span class="modal-error" id="errorCliente"></span>
            </div>

            <div class="cotizacion-seccion">
                <h4>Vehículo *</h4>
                <input class="modal-input" type="text" id="buscarVehiculo" placeholder="Buscar por marca, modelo o placa..." oninput="filtrarBuscador('vehiculo', this.value)" autocomplete="off" />
                <div class="lista-buscable" id="listaVehiculos"></div>
                <p class="perfil-nota" id="vehiculoSeleccionadoTxt">Ningún vehículo seleccionado.</p>
                <span class="modal-error" id="errorVehiculo"></span>
            </div>

            <div class="cotizacion-seccion">
                <h4>Servicios adicionales</h4>
                <input class="modal-input" type="text" id="buscarServicio" placeholder="Buscar servicio..." oninput="filtrarBuscador('servicio', this.value)" autocomplete="off" />
                <div class="cotizacion-servicios-lista" id="listaServicios"></div>
                <c:if test="${empty servicios}">
                    <p class="servicios-vacio">No hay servicios disponibles.</p>
                </c:if>
            </div>

            <div class="cotizacion-total">
                <span>Total estimado</span>
                <span id="cotizacionTotal">$0</span>
            </div>

            <p class="perfil-error" id="errorCotizacion"></p>
            <p class="perfil-exito" id="exitoCotizacion"></p>

            <div class="perfil-acciones">
                <button type="button" class="btn-perfil-guardar" id="btnRegistrarVenta">Registrar cotización</button>
            </div>

        </div>

    </div>
</div>

<!-- MODAL CONTRATAR SERVICIO ADICIONAL (DFR módulo 5.2): agrega un servicio
     del catálogo a un vehículo que uno de tus clientes ya compró, sin tocar
     la venta original. -->
<div class="modal-overlay" id="modalContratarServicio" onclick="cerrarOverlay(event,'modalContratarServicio')">

    <div class="modal-box modal-box-servicios" onclick="event.stopPropagation()">

        <div class="modal-header-bar">
            <span>Contratar servicio adicional</span>
            <button type="button" class="modal-cerrar" id="btnCerrarContratarServicio" aria-label="Cerrar">&times;</button>
        </div>

        <p class="modal-subtitle" id="contratarServicioVehiculo"></p>

        <div class="cotizacion-servicios-lista" id="contratarServiciosLista">

            <c:forEach var="s" items="${servicios}">
                <label class="cotizacion-servicio-item">
                    <input type="checkbox" class="cotizacion-servicio-checkbox" value="${s.id_servicio}">
                    <span class="cotizacion-servicio-nombre">${s.nombre}</span>
                    <span class="cotizacion-servicio-tipo">${s.tipoServicio.nombre}</span>
                    <span class="cotizacion-servicio-precio">$${s.precio}</span>
                </label>
            </c:forEach>

            <c:if test="${empty servicios}">
                <p class="servicios-vacio">No hay servicios disponibles por el momento.</p>
            </c:if>

        </div>

        <p class="perfil-error" id="errorContratarServicio"></p>
        <p class="perfil-exito" id="exitoContratarServicio"></p>

        <div class="perfil-acciones">
            <button type="button" class="btn-perfil-guardar" id="btnConfirmarContratarServicio">Contratar</button>
        </div>

    </div>

</div>

<script>
    const CLIENTES_ASESOR = ${empty clientesJson ? '[]' : clientesJson};
    const VEHICULOS_DISPONIBLES = ${empty vehiculosJson ? '[]' : vehiculosJson};
    const SERVICIOS_ACTIVOS = ${empty serviciosJson ? '[]' : serviciosJson};
</script>
<script src="${pageContext.request.contextPath}/js/comprobanteVenta.js"></script>
<script src="${pageContext.request.contextPath}/js/asesorJS/cotizacionesAsesor.js"></script>

<script>

    document.querySelectorAll(".dropdown-btn")
        .forEach(button => {
            button.addEventListener("click", function(e){
                e.stopPropagation();
                let menu = this.nextElementSibling;
                menu.classList.toggle("show");
            });
        });

    document.addEventListener("click", function(){
        document.querySelectorAll(".dropdown-menu")
            .forEach(menu => menu.classList.remove("show"));
    });

    // MODAL SERVICIOS

    const modalServicios = document.getElementById("modalServicios");
    const btnAbrirServicios = document.getElementById("btnAbrirServicios");
    const btnCerrarServicios = document.getElementById("btnCerrarServicios");

    btnAbrirServicios.addEventListener("click", function(e){
        e.stopPropagation();
        modalServicios.classList.add("active");
    });

    btnCerrarServicios.addEventListener("click", function(){
        modalServicios.classList.remove("active");
    });

    modalServicios.addEventListener("click", function(e){
        if(e.target === modalServicios){
            modalServicios.classList.remove("active");
        }
    });

    document.addEventListener("keydown", function(e){
        if(e.key === "Escape"){
            modalServicios.classList.remove("active");
        }
    });

</script>

<script>
    window.PERFIL_CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/clienteJS/perfilModal.js"></script>
</body>
</html>
