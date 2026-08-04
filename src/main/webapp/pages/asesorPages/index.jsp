
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestionaria Automotriz</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&family=Google+Sans+Code:ital,wght@1,300..800&display=swap" rel="stylesheet">



    <link rel="stylesheet" href="../../css/asesorStyles/style.css">
    <link rel="stylesheet" href="../../css/asesorStyles/responsive.css">
    <link rel="stylesheet" href="../../css/asesorStyles/index.css" />
    <link rel="stylesheet" href="../../css/asesorStyles/carruselIndex.css" />

</head>
<body>

<!-- =============================================
     NAVBAR
============================================= -->
<header class="navbar">
    <span class="navbar-brand">Gestionaria Automotriz</span>
    <nav class="navbar-links">
        <a href="#carrusel" class="navbar-link">Vehículos</a>
        <a href="#" class="navbar-link">Servicios</a>
        <div class="nav-item" id="contenedor-registrar">
            <button id="btn-registrar" class="navbar-link">Registrar</button>

            <div id="submenu-registrar" class="submenu oculto">
                <a href="registrarUsuario.html" class="submenu-link">Usuario</a>
                <a href="gestionarAuto.html" class="submenu-link">Auto</a>
                <button id="btn-cerrar" class="btn-x">X</button>
            </div>
        </div>
        <a href="cotizacion.html" class="navbar-link">Cotización</a>
        <a href="historial.html" class="navbar-link">Historial</a>
        <div class="nav-item" id="contenedor-configuracion">
            <button id="btn-config" class="navbar-link">Configuración</button>

            <div id="dropdown-config" class="submenu oculto">
                <button id="btn-logout" class="submenu-link">Salir de la cuenta</button>
                <button id="btn-start-password-flow" class="submenu-link">Cambiar contraseña</button>
                <button id="btn-close-dropdown" class="btn-x">X</button>
            </div>
        </div>
    </nav>
</header>



<!-- =============================================
     HERO
============================================= -->
<main>
    <section class="hero">

        <!-- Columna izquierda: texto + botones -->
        <div class="hero-content">
            <h1 class="hero-heading">
                El auto<br />
                que <em class="hero-accent">mereces</em><br />
                está aquí.
            </h1>

            <p class="hero-description">
                Accede al catálogo más completo, gestiona tus servicios y encuentra el vehículo ideal con la asesoría de nuestros expertos.
            </p>

            <div class="hero-actions">
                <!-- Botón Iniciar Sesión (estilo outline/secundario) -->
                <a href="login.html" class="btn-outline">
                    <img src="content/images/user.svg" alt="" class="btn-icon" />
                    Iniciar Sesión
                </a>

                <!-- Botón Registrarse (estilo primario oscuro) -->
                <a href="register.html" class="btn-register">Registrarse</a>
            </div>
        </div>

        <!-- Columna derecha: logo -->
        <div class="hero-logo">
            <div class="logo-placeholder" aria-label="Logo Automotriz">
                <img src="content/images/logo-SGCA.svg" class="logo-img" width="550" />
            </div>
        </div>

    </section>

    <!-- =============================================
         CARRUSEL DE AUTOS
    ============================================= -->
    <section class="carrusel-section" id="carrusel">
        <div class="carrusel-header">
            <h2>Vehículos disponibles</h2>
            <div class="carrusel-controls">
                <button class="carrusel-btn" id="btnPrev" aria-label="Anterior">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 18l-6-6 6-6"/></svg>
                </button>
                <button class="carrusel-btn" id="btnNext" aria-label="Siguiente">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18l6-6-6-6"/></svg>
                </button>
            </div>
        </div>

        <div class="carrusel-track" id="carruselTrack">

            <article class="auto-card">
                <div class="auto-card-img"></div>
                <div class="auto-card-info">
                    <span class="auto-card-marca">Mazda</span>
                    <span class="auto-card-modelo">CX-5 2024</span>
                    <span class="auto-card-precio">$485,000</span>
                </div>
            </article>

            <article class="auto-card">
                <div class="auto-card-img"></div>
                <div class="auto-card-info">
                    <span class="auto-card-marca">Nissan</span>
                    <span class="auto-card-modelo">Versa 2023</span>
                    <span class="auto-card-precio">$320,000</span>
                </div>
            </article>

            <article class="auto-card">
                <div class="auto-card-img"></div>
                <div class="auto-card-info">
                    <span class="auto-card-marca">Toyota</span>
                    <span class="auto-card-modelo">Corolla 2024</span>
                    <span class="auto-card-precio">$410,000</span>
                </div>
            </article>

            <article class="auto-card">
                <div class="auto-card-img"></div>
                <div class="auto-card-info">
                    <span class="auto-card-marca">Honda</span>
                    <span class="auto-card-modelo">CR-V 2024</span>
                    <span class="auto-card-precio">$560,000</span>
                </div>
            </article>

            <article class="auto-card">
                <div class="auto-card-img"></div>
                <div class="auto-card-info">
                    <span class="auto-card-marca">Kia</span>
                    <span class="auto-card-modelo">Sportage 2023</span>
                    <span class="auto-card-precio">$395,000</span>
                </div>
            </article>

            <article class="auto-card">
                <div class="auto-card-img"></div>
                <div class="auto-card-info">
                    <span class="auto-card-marca">Ford</span>
                    <span class="auto-card-modelo">Escape 2024</span>
                    <span class="auto-card-precio">$470,000</span>
                </div>
            </article>

            <article class="auto-card">
                <div class="auto-card-img"></div>
                <div class="auto-card-info">
                    <span class="auto-card-marca">Volkswagen</span>
                    <span class="auto-card-modelo">Jetta 2023</span>
                    <span class="auto-card-precio">$355,000</span>
                </div>
            </article>

            <article class="auto-card">
                <div class="auto-card-img"></div>
                <div class="auto-card-info">
                    <span class="auto-card-marca">Chevrolet</span>
                    <span class="auto-card-modelo">Tracker 2024</span>
                    <span class="auto-card-precio">$340,000</span>
                </div>
            </article>

        </div>

        <!-- Barra de desplazamiento personalizada -->
        <div class="carrusel-scrollbar">
            <div class="carrusel-scrollbar-thumb" id="scrollThumb"></div>
        </div>
    </section>
</main>
<!-- ==========================================
         3. LAS VENTANAS EMERGENTES (Ocultas por defecto)
    =========================================== -->
<div id="modal-overlay" class="overlay hidden">

    <!-- Paso 1: Enviar Correo -->
    <div id="modal-step-1" class="modal-box hidden">
        <button class="close-modal">&times;</button>
        <h2>Recuperar Contraseña</h2>
        <p>Ingresa tu correo electrónico registrado. Te enviaremos un código para restablecer tu contraseña.</p>
        <div class="input-group">
            <input type="email" placeholder="Ingresa tu correo">
        </div>
        <button id="btn-send-code" class="btn-primary">ENVIAR CÓDIGO</button>
        <a href="#" class="back-link">Volver al inicio de sesión</a>
    </div>

    <!-- Paso 2: Verificar Código -->
    <div id="modal-step-2" class="modal-box hidden">
        <button class="close-modal">&times;</button>
        <h2>Verificar Código</h2>
        <p>Enviamos un código de 6 dígitos a tu correo. Ingrésalo a continuación para cambiar tu contraseña.</p>
        <div class="code-inputs">
            <input type="text" maxlength="1"><input type="text" maxlength="1">
            <input type="text" maxlength="1"><input type="text" maxlength="1">
            <input type="text" maxlength="1"><input type="text" maxlength="1">
        </div>
        <button id="btn-verify-code" class="btn-primary">VERIFICAR</button>
        <a href="#" class="back-link">Reenviar código</a>
    </div>

    <!-- Paso 3: Nueva Contraseña -->
    <div id="modal-step-3" class="modal-box hidden">
        <button class="close-modal">&times;</button>
        <h2>Nueva Contraseña</h2>
        <p>Al cambiar tu contraseña, todas las sesiones activas serán cerradas automáticamente.</p>
        <div class="input-group">
            <label>Nueva Contraseña</label>
            <input type="password" placeholder="Mínimo 8 caracteres">
        </div>
        <div class="input-group">
            <label>Confirmar Contraseña</label>
            <input type="password" placeholder="Repite tu contraseña">
        </div>
        <button id="btn-save-password" class="btn-primary">GUARDAR CONTRASEÑA</button>
    </div>
</div>
<!-- =============================================
     FOOTER
============================================= -->
<footer class="footer">
    <p>© 2026 SGCA · Todos los derechos reservados</p>
</footer>

<script src="content/js/carrusel.js"></script>
<script src="content/js/cambioContraseña.js"></script>


</body>
</html>