<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<html lang="es">

<head>

    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Historial de ventas · Gestionaria Automotriz</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/gestiones.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/serviciosModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientePages/perfilModal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/asesorStyles/cotizacionModal.css">
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
                <c:forEach var="t" items="${listaTipos}">
                    <a href="${pageContext.request.contextPath}/automoviles?tipo=${t.nombre}">${t.nombre}</a>
                </c:forEach>
            </div>

        </div>

        <button type="button" class="dash-nav-link" id="btnAbrirServicios">
            Servicios
        </button>

        <button type="button" class="dash-nav-link" id="btnAbrirRegistrarCliente">
            Registrar Cliente
        </button>

        <button type="button" class="dash-nav-link" id="btnAbrirCotizacion">
            Cotización
        </button>

        <a href="${pageContext.request.contextPath}/historialAsesor" class="dash-nav-link active">
            Historial de ventas
        </a>

        <div class="dropdown">
            <button class="dash-nav-link dropdown-btn">
                Configuración ▾
            </button>
            <div class="dropdown-menu">

                <a href="#" id="btnAbrirPerfil">Perfil</a>

                <a href="${pageContext.request.contextPath}/logout">
                    Cerrar sesión
                </a>

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


<!-- MODAL REGISTRAR CLIENTE -->
<div class="modal-overlay" id="modalRegistrarCliente">

    <div class="modal-box modal-box-perfil">

        <div class="perfil-header">
            <h2>Registrar Cliente</h2>
            <button type="button" class="modal-cerrar" id="btnCerrarRegistrarCliente" aria-label="Cerrar">&times;</button>
        </div>

        <p class="perfil-nota">El cliente quedará asignado automáticamente a tu cartera.</p>

        <form id="formRegistrarCliente" novalidate>

            <div class="perfil-form-row">
                <div class="perfil-campo-edit">
                    <label class="perfil-form-label" for="regClienteNombre">Nombre</label>
                    <input class="perfil-input" type="text" id="regClienteNombre" name="nombre" maxlength="50">
                </div>
                <div class="perfil-campo-edit">
                    <label class="perfil-form-label" for="regClienteApellidoPaterno">Apellido paterno</label>
                    <input class="perfil-input" type="text" id="regClienteApellidoPaterno" name="apellidoPaterno" maxlength="30">
                </div>
            </div>

            <div class="perfil-campo-edit">
                <label class="perfil-form-label" for="regClienteApellidoMaterno">Apellido materno</label>
                <input class="perfil-input" type="text" id="regClienteApellidoMaterno" name="apellidoMaterno" maxlength="30">
            </div>

            <div class="perfil-form-row">
                <div class="perfil-campo-edit">
                    <label class="perfil-form-label" for="regClienteRfc">RFC</label>
                    <input class="perfil-input" type="text" id="regClienteRfc" name="rfc" maxlength="13">
                </div>
                <div class="perfil-campo-edit">
                    <label class="perfil-form-label" for="regClienteCurp">CURP</label>
                    <input class="perfil-input" type="text" id="regClienteCurp" name="curp" maxlength="18">
                </div>
            </div>

            <div class="perfil-form-row">
                <div class="perfil-campo-edit">
                    <label class="perfil-form-label" for="regClienteTelefono">Teléfono</label>
                    <input class="perfil-input" type="tel" id="regClienteTelefono" name="telefono" maxlength="10">
                </div>
                <div class="perfil-campo-edit">
                    <label class="perfil-form-label" for="regClienteCorreo">Correo</label>
                    <input class="perfil-input" type="email" id="regClienteCorreo" name="correo" maxlength="100">
                </div>
            </div>

            <div class="perfil-campo-edit">
                <label class="perfil-form-label" for="regClientePassword">Contraseña temporal</label>
                <input class="perfil-input" type="password" id="regClientePassword" name="password" autocomplete="new-password">
            </div>

            <p class="perfil-error" id="errorRegistrarCliente"></p>
            <p class="perfil-exito" id="exitoRegistrarCliente"></p>

            <div class="perfil-acciones">
                <button type="button" class="btn-perfil-cancelar" id="btnCancelarRegistrarCliente">Cancelar</button>
                <button type="submit" class="btn-perfil-guardar">Registrar</button>
            </div>

        </form>

    </div>

</div>


<!-- MODAL ARMAR COTIZACION -->
<div class="modal-overlay" id="modalArmarCotizacion">

    <div class="modal-box modal-box-servicios">

        <div class="modal-header-bar">
            <span>Armar cotización</span>
            <button type="button" class="modal-cerrar" id="btnCerrarArmarCotizacion" aria-label="Cerrar">&times;</button>
        </div>

        <div class="cotizacion-body">

            <div class="cotizacion-seccion">
                <h4>Vehículo</h4>
                <select class="perfil-input" id="cotizacionVehiculo">
                    <option value="0">-- Selecciona un vehículo --</option>
                    <c:forEach var="v" items="${vehiculos}">
                        <option value="${v.precio}">
                            ${v.marca.nombre} ${v.modelos.nombre} ${v.anio} — $${v.precio}
                        </option>
                    </c:forEach>
                </select>
                <c:if test="${empty vehiculos}">
                    <p class="servicios-vacio">No hay vehículos disponibles.</p>
                </c:if>
            </div>

            <div class="cotizacion-seccion">
                <h4>Servicios adicionales</h4>
                <div class="cotizacion-servicios-lista" id="cotizacionServiciosLista">
                    <c:forEach var="s" items="${servicios}">
                        <label class="cotizacion-servicio-item">
                            <input type="checkbox" class="cotizacion-servicio-checkbox" value="${s.precio}">
                            <span class="cotizacion-servicio-nombre">${s.nombre}</span>
                            <span class="cotizacion-servicio-tipo">${s.tipoServicio.nombre}</span>
                            <span class="cotizacion-servicio-precio">$${s.precio}</span>
                        </label>
                    </c:forEach>
                    <c:if test="${empty servicios}">
                        <p class="servicios-vacio">No hay servicios disponibles.</p>
                    </c:if>
                </div>
            </div>

            <div class="cotizacion-total">
                <span>Total estimado</span>
                <span id="cotizacionTotal">$0</span>
            </div>

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


<!-- CONTENIDO PRINCIPAL-->

<main class="dash-main">
    <div class="gest-header-left">
        <h1>Historial de ventas</h1>
    </div>

    <div class="gest-header">
        <!-- Buscador -->
        <div class="gest-search-inline">
            <input class="gest-input" type="text" placeholder="Buscar en historial..." oninput="filtrar(this.value)" />
            <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
        </div>

    </div>

    <!--  TABLA DE DATOS -->
    <div class="table-card">
        <div class="table-wrapper">
            <table class="gest-table" id="tabla">
                <thead>
                <tr>
                    <th>NO. de historial</th>
                    <th>Id Cliente</th>
                    <th>Fecha</th>
                    <th>Costo</th>
                    <th>Vehiculo</th>
                    <th>Servicio</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td colspan="7" style="text-align:center; padding: 24px;">
                        Todavía no hay ventas registradas para mostrar aquí.
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
    <a href="${pageContext.request.contextPath}/asesor" class="btn-atras">
        <img src="${pageContext.request.contextPath}/Images/back.svg" alt="atras" />
        Atrás
    </a>
</footer>


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
            modalRegistrarCliente.classList.remove("active");
            modalArmarCotizacion.classList.remove("active");
        }
    });


    // MODAL REGISTRAR CLIENTE

    const modalRegistrarCliente = document.getElementById("modalRegistrarCliente");
    const btnAbrirRegistrarCliente = document.getElementById("btnAbrirRegistrarCliente");
    const btnCerrarRegistrarCliente = document.getElementById("btnCerrarRegistrarCliente");
    const btnCancelarRegistrarCliente = document.getElementById("btnCancelarRegistrarCliente");
    const formRegistrarCliente = document.getElementById("formRegistrarCliente");
    const errorRegistrarCliente = document.getElementById("errorRegistrarCliente");
    const exitoRegistrarCliente = document.getElementById("exitoRegistrarCliente");

    function cerrarModalRegistrarCliente(){
        modalRegistrarCliente.classList.remove("active");
    }

    btnAbrirRegistrarCliente.addEventListener("click", function(e){
        e.stopPropagation();
        errorRegistrarCliente.textContent = "";
        exitoRegistrarCliente.textContent = "";
        formRegistrarCliente.reset();
        modalRegistrarCliente.classList.add("active");
    });

    btnCerrarRegistrarCliente.addEventListener("click", cerrarModalRegistrarCliente);
    btnCancelarRegistrarCliente.addEventListener("click", cerrarModalRegistrarCliente);

    modalRegistrarCliente.addEventListener("click", function(e){
        if(e.target === modalRegistrarCliente){
            cerrarModalRegistrarCliente();
        }
    });

    formRegistrarCliente.addEventListener("submit", async function(e){
        e.preventDefault();

        errorRegistrarCliente.textContent = "";
        exitoRegistrarCliente.textContent = "";

        const datos = new URLSearchParams(new FormData(formRegistrarCliente));

        try {
            const respuesta = await fetch("${pageContext.request.contextPath}/registrarClienteAsesor", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: datos.toString()
            });
            const texto = (await respuesta.text()).trim();

            if (respuesta.ok) {
                exitoRegistrarCliente.textContent = texto;
                formRegistrarCliente.reset();
            } else {
                errorRegistrarCliente.textContent = texto;
            }
        } catch (err) {
            errorRegistrarCliente.textContent = "No se pudo contactar al servidor. Intenta de nuevo.";
        }
    });


    // MODAL ARMAR COTIZACION

    const modalArmarCotizacion = document.getElementById("modalArmarCotizacion");
    const btnAbrirCotizacion = document.getElementById("btnAbrirCotizacion");
    const btnCerrarArmarCotizacion = document.getElementById("btnCerrarArmarCotizacion");
    const cotizacionVehiculo = document.getElementById("cotizacionVehiculo");
    const cotizacionCheckboxes = document.querySelectorAll(".cotizacion-servicio-checkbox");
    const cotizacionTotal = document.getElementById("cotizacionTotal");

    function calcularTotalCotizacion(){
        let total = parseFloat(cotizacionVehiculo.value) || 0;

        cotizacionCheckboxes.forEach(function(cb){
            if (cb.checked) {
                total += parseFloat(cb.value) || 0;
            }
        });

        cotizacionTotal.textContent = "$" + total.toLocaleString("es-MX");
    }

    btnAbrirCotizacion.addEventListener("click", function(e){
        e.stopPropagation();
        cotizacionVehiculo.value = "0";
        cotizacionCheckboxes.forEach(function(cb){ cb.checked = false; });
        calcularTotalCotizacion();
        modalArmarCotizacion.classList.add("active");
    });

    btnCerrarArmarCotizacion.addEventListener("click", function(){
        modalArmarCotizacion.classList.remove("active");
    });

    modalArmarCotizacion.addEventListener("click", function(e){
        if(e.target === modalArmarCotizacion){
            modalArmarCotizacion.classList.remove("active");
        }
    });

    cotizacionVehiculo.addEventListener("change", calcularTotalCotizacion);
    cotizacionCheckboxes.forEach(function(cb){
        cb.addEventListener("change", calcularTotalCotizacion);
    });

</script>

<script>
    window.PERFIL_CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/clienteJS/perfilModal.js"></script>
</body>
</html>
