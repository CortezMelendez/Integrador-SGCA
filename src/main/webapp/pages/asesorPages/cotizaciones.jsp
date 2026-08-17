<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mis cotizaciones · Gestionaria Automotriz</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/gestiones.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/asesorStyles/cotizacionModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/comprobanteVenta.css">
</head>
<body>

<!-- NAVBAR -->
<header class="dash-navbar">

    <div class="dash-navbar-left">
        <a href="${pageContext.request.contextPath}/asesor" class="dash-brand">
            Gestionaria Automotriz
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
                <a href="${pageContext.request.contextPath}/gestionAutoAsesor">Registrar vehículo</a>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/gestionClienteAsesor" class="dash-nav-link">
            Clientes
        </a>

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
                <a href="${pageContext.request.contextPath}/asesor">Perfil</a>
                <a href="${pageContext.request.contextPath}/logout">Cerrar sesión</a>
            </div>
        </div>

    </nav>

</header>

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
                    </tr>
                </c:forEach>
                <c:if test="${empty cotizaciones}">
                    <tr class="fila-vacia">
                        <td colspan="7" style="text-align:center; padding: 24px;">Todavía no has registrado ninguna cotización.</td>
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
    <span style="color: rgb(8, 8, 8); font-size: 0.85rem;">© 2026 SGCA · Todos los derechos reservados</span>
    <a href="javascript:history.back()" class="btn-back">
        <img src="${pageContext.request.contextPath}/Images/back.svg" alt="atras" />
        Atras
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

<script>
    const CLIENTES_ASESOR = ${empty clientesJson ? '[]' : clientesJson};
    const VEHICULOS_DISPONIBLES = ${empty vehiculosJson ? '[]' : vehiculosJson};
    const SERVICIOS_ACTIVOS = ${empty serviciosJson ? '[]' : serviciosJson};
</script>
<script src="${pageContext.request.contextPath}/js/comprobanteVenta.js"></script>
<script src="${pageContext.request.contextPath}/js/asesorJS/cotizacionesAsesor.js"></script>
</body>
</html>
