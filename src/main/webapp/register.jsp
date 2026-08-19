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

            <!-- Password y teléfono -->

            <div class="field-row">

                <div class="field-group">

                    <label class="field-label"
                           for="password">
                        Contraseña
                    </label>

                    <div class="input-wrapper">

                        <img class="input-icon"
                             src="${pageContext.request.contextPath}/Images/llave-pass.svg"
                             alt="">

                        <input
                                class="input-field"
                                type="password"
                                id="password"
                                name="password"
                                placeholder="Contraseña"
                                required
                                maxlength="255">

                    </div>

                </div>

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

            </div>

            <!-- CURP y RFC -->

            <div class="field-row">

                <div class="field-group">

                    <label class="field-label"
                           for="curp">
                        AAAA800101HDFXXXX01
                    </label>

                    <div class="input-wrapper">

                        <img class="input-icon"
                             src="${pageContext.request.contextPath}/Images/infoUser.svg"
                             alt=""
                        >

                        <input
                                class="input-field"
                                type="text"
                                id="curp"
                                name="curp"
                                placeholder="CURP"
                                maxlength="18">

                    </div>

                </div>

                <div class="field-group">

                    <label class="field-label"
                           for="rfc">
                        AAAA580812AA7
                    </label>

                    <div class="input-wrapper">

                        <img class="input-icon"
                             src="${pageContext.request.contextPath}/Images/infoUser.svg"
                             alt="">

                        <input
                                class="input-field"
                                type="text"
                                id="rfc"
                                name="rfc"
                                placeholder="RFC"
                                maxlength="13">

                    </div>

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