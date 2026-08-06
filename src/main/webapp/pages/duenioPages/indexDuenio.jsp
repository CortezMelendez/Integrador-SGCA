<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestionaria Automotriz</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&family=Google+Sans+Code:ital,wght@1,300..800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="../../css/duenioStyles/styles.css">
    <link rel="stylesheet" href="../../css/duenioStyles/index.css" />
    <link rel="stylesheet" href="../../css/duenioStyles/carruselIndex.css" />
    <link rel="stylesheet" href="../../css/duenioStyles/responsive.css" />
</head>
<body>

<!-- NAVBAR -->
<header class="navbar">
    <span class="navbar-brand">Gestionaria Automotriz</span>
    <nav class="navbar-links">
        <a href="dashboard.jsp" class="dash-nav-link">Dashboard</a>
        <a href="#" class="dash-nav-link">Historial</a>
        <a href="" class="dash-nav-link">Perfil</a>
    </nav>
</header>

<!-- HERO -->
<main>
    <section class="hero">
        <div class="hero-content">
            <h1 class="hero-heading">
                El auto<br />
                que <em class="hero-accent">mereces</em><br />
                está aquí.
            </h1>
            <p class="hero-description">
                Accede al catálogo más completo, gestiona tus servicios y encuentra el vehículo ideal con la asesoría de nuestros expertos.
            </p>


        </div>

        <div class="hero-logo">
            <div class="logo-placeholder" aria-label="Logo Automotriz">
                <img src="../../Images/logo-SGCA.svg" class="logo-img" width="550" />
            </div>
        </div>

    </section>

    <!-- CARRUSEL DE AUTOS -->
    <section class="carrusel-section" id="carrusel">
        <!-- ... -->
    </section>
</main>

<footer class="footer">
    <p>© 2026 SGCA · Todos los derechos reservados</p>
</footer>

<script src="../../js/duenioJS/carrusel.js"></script>

</body>
</html>