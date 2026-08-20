<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Concesionaria Automotriz — Registrarse</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vendor/bootstrap-scoped.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>

<body class="bs">

<div class="page">

    <!-- Imagen -->
    <section class="hero-image" aria-hidden="true">
        <img src="Images/login.png"
             alt="Showroom de la concesionaria">
    </section>

    <!-- Formulario -->
    <main class="form-panel form-panel--compact">

        <h1 class="brand-title">
            Concesionaria Automotriz
        </h1>
        <h2 class="form-title">Crear cuenta</h2>


        <!-- Mensaje enviado por el servlet -->
        <c:if test="${not empty error}">
            <div class="error-message">
                    ${error}
            </div>
        </c:if>

        <form class="login-form register-form"
              id="registerForm"
              method="post"
              action="${pageContext.request.contextPath}/RegisterServlet">

            <!-- Nombre -->
            <div class="field-row">

                <div class="field-group">
                    <label class="field-label" for="nombre">Nombre</label>

                    <div class="input-wrapper">
                        <img class="input-icon"
                             src="${pageContext.request.contextPath}/Images/user.svg"
                             alt="">

                        <input
                                class="input-field"
                                type="text"
                                id="nombre"
                                name="nombre"
                                placeholder="Nombre"
                                required>
                    </div>
                </div>

                <div class="field-group">

                    <label class="field-label"
                           for="apellidoPaterno">
                        Apellido paterno
                    </label>

                    <div class="input-wrapper">

                        <img class="input-icon"
                             src="${pageContext.request.contextPath}/Images/user.svg"
                             alt="">

                        <input
                                class="input-field"
                                type="text"
                                id="apellidoPaterno"
                                name="apellidoPaterno"
                                placeholder="Apellido paterno"
                                required>

                    </div>
                </div>

            </div>

            <!-- Apellido Materno y Correo -->

            <div class="field-row">

                <div class="field-group">

                    <label class="field-label"
                           for="apellidoMaterno">
                        Apellido materno
                    </label>

                    <div class="input-wrapper">

                        <img class="input-icon"
                             src="${pageContext.request.contextPath}/Images/user.svg"
                             alt="">

                        <input
                                class="input-field"
                                type="text"
                                id="apellidoMaterno"
                                name="apellidoMaterno"
                                placeholder="Apellido materno"
                                required>

                    </div>

                </div>

                <div class="field-group">

                    <label class="field-label"
                           for="correo">
                        Correo electrónico
                    </label>

                    <div class="input-wrapper">

                        <img class="input-icon"
                             src="${pageContext.request.contextPath}/Images/email.svg"
                             alt="">

                        <input
                                class="input-field"
                                type="email"
                                id="correo"
                                name="correo"
                                placeholder="Correo electrónico"
                                required>

                    </div>

                </div>

            </div>

            <!-- Password y confirmar contraseña -->

            <div class="field-row">

                <div class="field-group">

                    <label class="field-label"
                           for="password">
                        Contraseña
                    </label>

                    <div class="input-wrapper input-wrapper--password">

                        <img class="input-icon"
                             src="${pageContext.request.contextPath}/Images/llave-pass.svg"
                             alt="">

                        <input
                                class="input-field"
                                type="password"
                                id="password"
                                name="password"
                                placeholder="Mínimo 8 caracteres"
                                required
                                maxlength="255">

                        <button type="button" class="password-toggle" data-toggle-password="password" aria-label="Mostrar contraseña">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                <g class="eye-open">
                                    <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7Z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                </g>
                                <path class="eye-closed" d="M3 3l18 18M10.6 10.6a3 3 0 0 0 4.24 4.24M6.1 6.1C3.5 7.9 1 12 1 12s4 7 11 7c1.9 0 3.6-.5 5.1-1.3M17.9 17.9C20.5 16.1 23 12 23 12s-1.2-2.1-3.2-4"></path>
                            </svg>
                        </button>

                    </div>
                    <span class="field-error" id="passwordError"></span>

                </div>

                <div class="field-group">

                    <label class="field-label"
                           for="confirmarPassword">
                        Confirmar contraseña
                    </label>

                    <div class="input-wrapper input-wrapper--password">

                        <img class="input-icon"
                             src="${pageContext.request.contextPath}/Images/llave-pass.svg"
                             alt="">

                        <input
                                class="input-field"
                                type="password"
                                id="confirmarPassword"
                                name="confirmarPassword"
                                placeholder="Repite tu contraseña"
                                required
                                maxlength="255">

                        <button type="button" class="password-toggle" data-toggle-password="confirmarPassword" aria-label="Mostrar contraseña">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                <g class="eye-open">
                                    <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7Z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                </g>
                                <path class="eye-closed" d="M3 3l18 18M10.6 10.6a3 3 0 0 0 4.24 4.24M6.1 6.1C3.5 7.9 1 12 1 12s4 7 11 7c1.9 0 3.6-.5 5.1-1.3M17.9 17.9C20.5 16.1 23 12 23 12s-1.2-2.1-3.2-4"></path>
                            </svg>
                        </button>

                    </div>
                    <span class="field-error" id="confirmarPasswordError"></span>

                </div>

            </div>

            <!-- Teléfono y RFC -->

            <div class="field-row">

                <div class="field-group">

                    <label class="field-label"
                           for="telefono">
                        Teléfono
                    </label>

                    <div class="input-wrapper">

                        <img class="input-icon"
                             src="${pageContext.request.contextPath}/Images/phone.svg"
                             alt="">

                        <input
                                class="input-field"
                                type="tel"
                                id="telefono"
                                name="telefono"
                                placeholder="##########"
                                maxlength="10"
                                required>

                    </div>

                </div>

                <div class="field-group">

                    <label class="field-label"
                           for="rfc">
                        RFC
                    </label>

                    <div class="input-wrapper">

                        <img class="input-icon"
                             src="${pageContext.request.contextPath}/Images/infoUser.svg"
                             alt=""
                        >

                        <input
                                class="input-field"
                                type="text"
                                id="rfc"
                                name="rfc"
                                placeholder="AAAA580812AA7"
                                maxlength="13">

                    </div>

                </div>

            </div>

            <!-- CURP -->

            <div class="field-group">

                <label class="field-label"
                       for="curp">
                    CURP
                </label>

                <div class="input-wrapper">

                    <img class="input-icon"
                         src="${pageContext.request.contextPath}/Images/infoUser.svg"
                         alt="">

                    <input
                            class="input-field"
                            type="text"
                            id="curp"
                            name="curp"
                            placeholder="AAAA800101HDFXXXX01"
                            maxlength="18">

                </div>

            </div>

            <button type="submit"
                    class="btn-primary">
                Registrarse
            </button>

            <hr class="divider">

            <a href="${pageContext.request.contextPath}/login.jsp"
               class="forgot-link">
                Ya tengo una cuenta
            </a>

        </form>

        <footer class="footer login-footer">

            <a href="${pageContext.request.contextPath}/login.jsp"
               class="btn-back">

                <img src="${pageContext.request.contextPath}/Images/back.svg"
                     alt="Atrás">

                Atrás

            </a>

        </footer>

    </main>

</div>

<script src="${pageContext.request.contextPath}/js/register.js"></script>

</body>
</html>