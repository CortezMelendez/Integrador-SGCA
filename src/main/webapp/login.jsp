
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Concesionaria Automotriz — Inicio de Sesion</title>
    <link rel="stylesheet" href="css/duenioStyles/styles.css" />
    <link rel="stylesheet" href="css/duenioStyles/responsive.css" />
    <link rel="stylesheet" href="css/duenioStyles/login.css" />
    <link rel="stylesheet" href="css/duenioStyles/auth.css">
</head>
<body>

<!-- LAYOUT PRINCIPAL -->
<div class="page">

    <!-- COLUMNA IZQUIERDA — imagen del showroom -->
    <section class="hero-image" aria-hidden="true">
        <img src="Images/login.png" />
    </section>

    <!-- COLUMNA DERECHA — formulario + footer -->
    <main class="form-panel">

        <h1 class="brand-title">Concesionaria Automotriz</h1>
        <h2 class="form-title">Inicio de Sesión</h2>

        <form class="login-form" id="loginForm" novalidate>

            <!-- Mensaje de error general (oculto por defecto) -->
            <div class="error-message" id="errorMessage" role="alert" hidden>
                <svg class="error-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <path d="M12 2 1 21h22L12 2Z" stroke="#ff9d9d" stroke-width="1.6" stroke-linejoin="round"/>
                    <path d="M12 9v5" stroke="#ff9d9d" stroke-width="1.6" stroke-linecap="round"/>
                    <circle cx="12" cy="17" r="1" fill="#ff9d9d"/>
                </svg>
                <span id="errorMessageText">Usuario o contraseña incorrectos. Intente de nuevo</span>
            </div>



            <div class="field-group">
                <label class="field-label" for="email">Correo Electrónico</label>
                <div class="input-wrapper">
                    <img class="input-icon" src="Images/email.svg" alt="" />
                    <input class="input-field" type="email" id="email" name="email" placeholder="Ingresa tu correo" autocomplete="email" required />
                </div>
                <span class="field-error" id="emailError"></span>
            </div>

            <div class="field-group">
                <label class="field-label" for="password">Contraseña</label>
                <div class="input-wrapper">
                    <img class="input-icon" src="Images/llave-pass.svg" alt="" />
                    <input class="input-field" type="password" id="password" name="password" placeholder="Ingresa tu contraseña" autocomplete="current-password" required />
                </div>
                <span class="field-error" id="passwordError"></span>
            </div>

            <a href="#" class="forgot-link">¿Olvidaste tu contraseña?</a>

            <button type="submit" class="btn-primary">Iniciar Sesión</button>

            <hr class="divider" />

            <p class="register-text">
                ¿No tienes una cuenta? <a href="register.jsp" class="forgot-link" >Regístrate aquí</a>
            </p>

        </form>

        <footer class="footer login-footer">
            <a href="index.jsp" class="btn-back">
                <img src="Images/back.svg" alt="atras" />
                Atrás
            </a>
        </footer>

    </main>

</div>

<script src="js/login.js"></script>
</body>
</html>