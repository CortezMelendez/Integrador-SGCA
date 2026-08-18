<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- necesario para usar c:if --%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Concesionaria Automotriz — Inicio de Sesión</title>

    <%-- Se usa contextPath para que funcione aunque cambie el nombre del proyecto --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vendor/bootstrap-scoped.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recuperarPassword.css" />
    <%-- responsive.css debe ir al final: sus media queries anulan los estilos
         de escritorio de arriba (mismo orden de carga que ya usa register.jsp) --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css" />
</head>
<body class="bs">


<div class="page">

    <section class="hero-image" aria-hidden="true">
        <img src="${pageContext.request.contextPath}/Images/login.png" alt="Showroom" />
    </section>

    <main class="form-panel">

        <a href="${pageContext.request.contextPath}/catalogo" class="brand-link">
            <h1 class="brand-title">
                Concesionaria Automotriz
            </h1>
        </a>
        <h2 class="form-title">Inicio de Sesión</h2>

        <%-- CAMBIO: el form ahora sí envía al servlet y por POST --%>
        <form class="login-form"
              id="loginForm"
              method="post"
              action="${pageContext.request.contextPath}/login"
              novalidate>

            <%-- CAMBIO: mensaje dinámico según el error que mande LoginServlet --%>
            <c:if test="${not empty param.error}">
                <div class="error-message" role="alert">
                    <c:choose>
                        <c:when test="${param.error == 'credenciales_invalidas'}">
                            Usuario o contraseña incorrectos. Intente de nuevo.
                        </c:when>
                        <c:when test="${param.error == 'sesion_requerida'}">
                            Debes iniciar sesión para acceder a esa página.
                        </c:when>
                        <c:when test="${param.error == 'server_error'}">
                            Ocurrió un error en el servidor. Intenta más tarde.
                        </c:when>
                        <c:otherwise>
                            Ocurrió un error inesperado.
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <div class="field-group">
                <label class="field-label" for="correo">Correo Electrónico</label>
                <div class="input-wrapper">
                    <img class="input-icon" src="${pageContext.request.contextPath}/Images/email.svg" alt="" />
                    <%-- CAMBIO: name="correo" porque LoginServlet lee req.getParameter("correo") --%>
                    <input class="input-field"
                           type="email"
                           id="correo"
                           name="correo"
                           placeholder="Ingresa tu correo"
                           autocomplete="email"
                           required />
                </div>
            </div>

            <div class="field-group">
                <label class="field-label" for="password">Contraseña</label>
                <div class="input-wrapper">
                    <img class="input-icon" src="${pageContext.request.contextPath}/Images/llave-pass.svg" alt="" />
                    <input class="input-field"
                           type="password"
                           id="password"
                           name="password"
                           placeholder="Ingresa tu contraseña"
                           autocomplete="current-password"
                           required />
                </div>
            </div>

            <a href="#" id="btnAbrirRecuperar" class="forgot-link">¿Olvidaste tu contraseña? | Click Aqui</a>

            <button type="submit" class="btn-primary">Iniciar Sesión</button>

            <hr class="divider" />

            <p class="register-text">
                ¿No tienes una cuenta?
                <a href="${pageContext.request.contextPath}/register.jsp" class="forgot-link">Regístrate aquí</a>
            </p>
        </form>

        <footer class="footer login-footer">
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn-back">
                <img src="${pageContext.request.contextPath}/Images/back.svg" alt="atras" />
                Atrás
            </a>
        </footer>

    </main>
</div>


<!-- MODAL RECUPERAR CONTRASEÑA -->
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
                            placeholder="Ingresa tu correo"
                            autocomplete="email" />
                </div>

                <p class="recuperar-error" id="errorPaso1"></p>

                <button type="submit" class="recuperar-btn" id="btnEnviarCodigo">ENVIAR CÓDIGO</button>

            </form>

            <button type="button" class="recuperar-volver" data-cerrar>
                &#8592; Volver al inicio de sesión
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


<script src="${pageContext.request.contextPath}/js/login.js"></script>
<script>
    window.RECUPERAR_CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/recuperarPassword.js"></script>
</body>
</html>