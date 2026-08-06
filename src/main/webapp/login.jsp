<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- CAMBIO: necesario para usar c:if --%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Concesionaria Automotriz — Inicio de Sesión</title>

    <%-- CAMBIO: usar contextPath para que funcione aunque cambie el nombre del proyecto --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/responsive.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css" />
</head>
<body>


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

            <a href="#" class="forgot-link">¿Olvidaste tu contraseña?</a>

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

<script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>