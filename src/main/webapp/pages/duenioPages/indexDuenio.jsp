<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<html lang="es">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Gestionaria Automotriz</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/carruselIndex.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/gestiones.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recuperarPassword.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/responsive.css">
</head>

<body>

<!-- Barra principal del usuario -->
<header class="navbar">

    <span class="navbar-brand">
        Gestionaria Automotriz
    </span>

    <header class="navbar">
        <nav class="navbar-links">
            <a href="${pageContext.request.contextPath}/nav?action=dashboard" class="dash-nav-link">Dashboard</a>
            <a href="${pageContext.request.contextPath}/nav?action=historial" class="dash-nav-link">Historial</a>

            <div class="dropdown" id="menuConfigDuenio">
                <button type="button" class="dash-nav-link dropdown-btn">Configuración ▾</button>
                <div class="dropdown-menu">
                    <a href="#" id="btnAbrirPerfilDuenio">Perfil</a>
                    <a href="#" id="btnAbrirRecuperar">Cambiar contraseña</a>
                    <a href="${pageContext.request.contextPath}/btn?action=cerrarSesionTodos">Cerrar sesión</a>
                </div>
            </div>
        </nav>
    </header>

</header>


<!-- Sección principal con presentación y logo -->
<main>

    <section class="hero">

        <div class="hero-content">

            <h1 class="hero-heading">
                El auto<br>
                que
                <em class="hero-accent">
                    mereces
                </em>
                <br>
                está aquí.
            </h1>

            <p class="hero-description">
                Accede al catálogo más completo, gestiona tus servicios y encuentra el vehículo ideal con la asesoría de nuestros expertos.
            </p>

        </div>

        <div class="hero-logo">

            <div class="logo-placeholder">

                <img src="${pageContext.request.contextPath}/Images/logo-SGCA.svg"
                     class="logo-img"
                     width="350">

            </div>

        </div>

    </section>

</main>


<!-- Catálogo de vehículos disponibles -->

<section class="catalogo">

    <div class="catalogo-header">

        <h2 class="catalogo-titulo">
            Vehículos recién agregados
        </h2>

    </div>


    <div class="cards-container">

        <c:forEach var="v" items="${vehiculos}">

            <div class="card-auto">

                <img class="card-imagen"
                     src="${pageContext.request.contextPath}/Images/imagesAutos/${v.foto_Portada}"
                     alt="Vehículo">

                <h3>
                        ${v.marca.nombre}
                        ${v.modelos.nombre}
                </h3>

                <p>
                    Año: ${v.anio}
                </p>

                <h2>
                    $${v.precio}
                </h2>

                <a class="btn-detalles"
                   href="${pageContext.request.contextPath}/detalleVehiculo?id=${v.id_Vehiculo}">
                    Ver detalles
                </a>

            </div>

        </c:forEach>

    </div>

</section>


<!-- Pie de página -->
<footer class="footer">

    <p>
        © 2026 SGCA · Todos los derechos reservados
    </p>

</footer>


<!-- MODAL EDITAR PERFIL -->
<div class="modal-overlay" id="modalPerfilDuenio">
    <div class="modal-box modal-box-lg">

        <div class="modal-header-bar">
            <span>Editar Perfil</span>
            <button type="button" class="modal-cerrar" id="btnCerrarPerfilDuenio" aria-label="Cerrar">&times;</button>
        </div>

        <p class="modal-subtitle">
            ${usuarioLogueado.nombre} ${usuarioLogueado.apellidoPaterno} ${usuarioLogueado.apellidoMaterno}
            &nbsp;·&nbsp;#${usuarioLogueado.id_usuario}
        </p>

        <form id="formPerfilDuenio">

            <div class="modal-row">
                <div class="modal-field">
                    <label class="modal-label">Rol</label>
                    <input class="modal-input" type="text" value="${usuarioLogueado.rol.rol}" disabled>
                </div>
                <div class="modal-field">
                    <label class="modal-label">Miembro desde</label>
                    <input class="modal-input" type="text"
                           value="<fmt:formatDate value="${usuarioLogueado.fechaRegistro}" pattern="dd/MM/yyyy"/>" disabled>
                </div>
            </div>

            <div class="modal-row">
                <div class="modal-field">
                    <label class="modal-label">RFC</label>
                    <input class="modal-input" type="text" value="${usuarioLogueado.rfc}" disabled>
                </div>
                <div class="modal-field">
                    <label class="modal-label">CURP</label>
                    <input class="modal-input" type="text" value="${usuarioLogueado.curp}" disabled>
                </div>
            </div>

            <div class="modal-field">
                <label class="modal-label" for="correoPerfilDuenio">Correo Principal</label>
                <input class="modal-input" type="email" id="correoPerfilDuenio" name="correo"
                       value="${usuarioLogueado.correo}">
            </div>

            <div class="modal-field">
                <label class="modal-label" for="telefonoPerfilDuenio">Teléfono Móvil</label>
                <input class="modal-input" type="tel" id="telefonoPerfilDuenio" name="telefono"
                       value="${usuarioLogueado.telefono}">
            </div>

            <p class="modal-error-perfil" id="errorPerfilDuenio"></p>

            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" id="btnCancelarPerfilDuenio">Cancelar</button>
                <button type="submit" class="btn-modal-save" id="btnGuardarPerfilDuenio">Guardar cambios</button>
            </div>

        </form>
    </div>
</div>


<!-- MODAL CAMBIAR CONTRASEÑA (reutiliza el flujo de recuperación por correo) -->
<div class="recuperar-overlay" id="recuperarOverlay">

    <!-- PASO 1: RECUPERAR CONTRASEÑA -->
    <div class="recuperar-modal" id="paso1">
        <div class="recuperar-card">

            <button type="button" class="recuperar-cerrar" data-cerrar aria-label="Cerrar">&times;</button>

            <h2 class="recuperar-titulo">Recuperar Contraseña</h2>
            <p class="recuperar-texto">
                Ingresa tu correo electrónico registrado. Te enviaremos un código para restablecer tu contraseña.
            </p>

            <form id="formPaso1" novalidate>

                <label class="recuperar-label" for="correoRecuperacion">Correo electrónico</label>
                <div class="recuperar-input-wrap">
                    <img class="recuperar-input-icono" src="${pageContext.request.contextPath}/Images/email.svg" alt="" />
                    <input
                            class="recuperar-input"
                            type="email"
                            id="correoRecuperacion"
                            name="correo"
                            value="${usuarioLogueado.correo}"
                            placeholder="Ingresa tu correo"
                            autocomplete="email" />
                </div>

                <p class="recuperar-error" id="errorPaso1"></p>

                <button type="submit" class="recuperar-btn" id="btnEnviarCodigo">ENVIAR CÓDIGO</button>

            </form>

            <button type="button" class="recuperar-volver" data-cerrar>
                &#8592; Cancelar
            </button>

        </div>
    </div>

    <!-- PASO 2: VERIFICAR CÓDIGO -->
    <div class="recuperar-modal recuperar-oculto" id="paso2">
        <div class="recuperar-card">

            <button type="button" class="recuperar-cerrar" data-cerrar aria-label="Cerrar">&times;</button>

            <h2 class="recuperar-titulo">Verificar Código</h2>
            <p class="recuperar-texto">
                Enviamos un código de 6 dígitos a tu correo. Ingrésalo a continuación.
            </p>

            <form id="formPaso2" novalidate>

                <div class="recuperar-codigo" id="grupoCodigo">
                    <input class="recuperar-digito" type="text" inputmode="numeric" pattern="[0-9]*" maxlength="1" data-index="0" autocomplete="one-time-code">
                    <input class="recuperar-digito" type="text" inputmode="numeric" pattern="[0-9]*" maxlength="1" data-index="1">
                    <input class="recuperar-digito" type="text" inputmode="numeric" pattern="[0-9]*" maxlength="1" data-index="2">
                    <input class="recuperar-digito" type="text" inputmode="numeric" pattern="[0-9]*" maxlength="1" data-index="3">
                    <input class="recuperar-digito" type="text" inputmode="numeric" pattern="[0-9]*" maxlength="1" data-index="4">
                    <input class="recuperar-digito" type="text" inputmode="numeric" pattern="[0-9]*" maxlength="1" data-index="5">
                </div>

                <p class="recuperar-error" id="errorPaso2"></p>

                <button type="submit" class="recuperar-btn">VERIFICAR</button>

            </form>

            <button type="button" class="recuperar-reenviar" id="btnReenviar">Reenviar código</button>

        </div>
    </div>

    <!-- PASO 3: NUEVA CONTRASEÑA -->
    <div class="recuperar-modal recuperar-oculto" id="paso3">
        <div class="recuperar-card">

            <button type="button" class="recuperar-cerrar" data-cerrar aria-label="Cerrar">&times;</button>

            <h2 class="recuperar-titulo">Nueva Contraseña</h2>
            <p class="recuperar-texto">
                Al cambiar tu contraseña, todas las sesiones activas serán cerradas automáticamente.
            </p>

            <form id="formPaso3" novalidate>

                <label class="recuperar-label" for="nuevaPassword">Nueva Contraseña</label>
                <div class="recuperar-input-wrap">
                    <img class="recuperar-input-icono" src="${pageContext.request.contextPath}/Images/llave-pass.svg" alt="" />
                    <input
                            class="recuperar-input"
                            type="password"
                            id="nuevaPassword"
                            name="nuevaPassword"
                            placeholder="Mínimo 8 caracteres"
                            autocomplete="new-password" />
                </div>

                <label class="recuperar-label" for="confirmarPassword">Confirmar Contraseña</label>
                <div class="recuperar-input-wrap">
                    <img class="recuperar-input-icono" src="${pageContext.request.contextPath}/Images/llave-pass.svg" alt="" />
                    <input
                            class="recuperar-input"
                            type="password"
                            id="confirmarPassword"
                            name="confirmarPassword"
                            placeholder="Repite tu contraseña"
                            autocomplete="new-password" />
                </div>

                <p class="recuperar-error" id="errorPaso3"></p>

                <button type="submit" class="recuperar-btn">GUARDAR CONTRASEÑA</button>

            </form>

        </div>
    </div>

</div>


<script>

    // ===== DROPDOWN "CONFIGURACIÓN" =====

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


    // ===== MODAL EDITAR PERFIL =====

    const modalPerfil = document.getElementById("modalPerfilDuenio");
    const btnAbrirPerfil = document.getElementById("btnAbrirPerfilDuenio");
    const btnCerrarPerfil = document.getElementById("btnCerrarPerfilDuenio");
    const btnCancelarPerfil = document.getElementById("btnCancelarPerfilDuenio");
    const formPerfil = document.getElementById("formPerfilDuenio");
    const errorPerfil = document.getElementById("errorPerfilDuenio");
    const inputCorreoPerfil = document.getElementById("correoPerfilDuenio");
    const inputTelefonoPerfil = document.getElementById("telefonoPerfilDuenio");
    const correoOriginal = inputCorreoPerfil.value;
    const telefonoOriginal = inputTelefonoPerfil.value;

    btnAbrirPerfil.addEventListener("click", function (e) {
        e.preventDefault();
        errorPerfil.textContent = "";
        modalPerfil.classList.add("active");
    });

    function cerrarModalPerfil() {
        modalPerfil.classList.remove("active");
        inputCorreoPerfil.value = correoOriginal;
        inputTelefonoPerfil.value = telefonoOriginal;
        errorPerfil.textContent = "";
    }

    btnCerrarPerfil.addEventListener("click", cerrarModalPerfil);
    btnCancelarPerfil.addEventListener("click", cerrarModalPerfil);

    modalPerfil.addEventListener("click", function (e) {
        if (e.target === modalPerfil) {
            cerrarModalPerfil();
        }
    });

    formPerfil.addEventListener("submit", async function (e) {
        e.preventDefault();

        const correo = inputCorreoPerfil.value.trim();
        const telefono = inputTelefonoPerfil.value.trim();

        errorPerfil.textContent = "";

        try {
            const respuesta = await fetch("${pageContext.request.contextPath}/btn?action=actualizarPerfil", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "correo=" + encodeURIComponent(correo) + "&telefono=" + encodeURIComponent(telefono)
            });

            const texto = (await respuesta.text()).trim();

            if (respuesta.ok) {
                window.location.reload();
            } else {
                errorPerfil.textContent = texto;
            }
        } catch (err) {
            errorPerfil.textContent = "No se pudo contactar al servidor. Intenta de nuevo.";
        }
    });

</script>

<script>
    window.RECUPERAR_CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/recuperarPassword.js"></script>

</body>
</html>