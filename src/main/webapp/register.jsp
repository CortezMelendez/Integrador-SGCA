
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Concesionaria Automotriz — Registrarse</title>
    <link rel="stylesheet" href="css/duenioStyles/styles.css" />
    <link rel="stylesheet" href="css/duenioStyles/responsive.css" />
    <link rel="stylesheet" href="css/duenioStyles/register.css" />
    <link rel="stylesheet" href="css/duenioStyles/auth.css">
</head>
<body>


<div class="page">

    <!-- COLUMNA IZQUIERDA — imagen del showroom -->
    <section class="hero-image" aria-hidden="true">
        <img src="Images/login.png" alt="Showroom de la concesionaria con autos de lujo" />
    </section>

    <!-- COLUMNA DERECHA — formulario -->
    <main class="form-panel">

        <h1 class="brand-title">Concesionaria Automotriz</h1>
        <h2 class="form-title">Crear cuenta</h2>

        <form class="login-form" id="registerForm" novalidate>

            <!-- Mensaje de error general (oculto por defecto) -->
            <div class="error-message" id="errorMessage" role="alert" hidden>
                <svg class="error-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <path d="M12 2 1 21h22L12 2Z" stroke="#ff9d9d" stroke-width="1.6" stroke-linejoin="round"/>
                    <path d="M12 9v5" stroke="#ff9d9d" stroke-width="1.6" stroke-linecap="round"/>
                    <circle cx="12" cy="17" r="1" fill="#ff9d9d"/>
                </svg>
                <span id="errorMessageText">Revisa los datos ingresados.</span>
            </div>

            <!-- Campo: Nombre -->
            <div class="field-group">
                <label class="field-label" for="nombre">Nombre</label>
                <div class="input-wrapper">
                    <img class="input-icon" src="Images/user.svg" alt="" />
                    <input class="input-field" type="text" id="nombre" name="nombre" placeholder="Ingresa tu nombre" autocomplete="name" maxlength="50" required />
                </div>
                <span class="field-error" id="nombreError"></span>
            </div>

            <!-- Campo: Correo Electronico -->
            <div class="field-group">
                <label class="field-label" for="email">Correo Electrónico</label>
                <div class="input-wrapper">
                    <img class="input-icon" src="Images/email.svg" alt="" />
                    <input class="input-field" type="email" id="email" name="email" placeholder="Ingresa tu correo" autocomplete="email" maxlength="100" required />
                </div>
                <span class="field-error" id="emailError"></span>
            </div>

            <!-- Campo: Contrasena -->
            <div class="field-group">
                <label class="field-label" for="password">Contraseña</label>
                <div class="input-wrapper">
                    <img class="input-icon" src="Images/llave-pass.svg" alt="" />
                    <input class="input-field" type="password" id="password" name="password" placeholder="Ingresa tu contraseña" autocomplete="new-password" maxlength="30" required />
                </div>
                <span class="field-error" id="passwordError"></span>
            </div>

            <!-- Campo: Numero de telefono -->
            <div class="field-group">
                <label class="field-label" for="telefono">Número de teléfono</label>
                <div class="input-wrapper">
                    <img class="input-icon" src="Images/phone.svg" alt="" />
                    <input class="input-field" type="tel" id="telefono" name="telefono" placeholder="##########" autocomplete="tel" maxlength="10" inputmode="numeric" required />
                </div>
                <span class="field-error" id="telefonoError"></span>
            </div>

            <!-- Boton: Registrarse -->
            <button type="submit" class="btn-primary">Registrarse</button>

            <!-- Divisor -->
            <hr class="divider" />

            <!-- Enlace: Ya tengo cuenta -->
            <a href="login.jsp" class="forgot-link">Ya tengo una cuenta</a>

        </form>

        <footer class="footer login-footer">
            <a href="login.jsp" class="btn-back" aria-label="Volver a la pagina anterior">
                <img src="Images/back.svg" alt="atras" />
                Atrás
            </a>
        </footer>

    </main>

</div>

<script src="js/register.js"></script>
</body>
</html>
