<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Concesionaria Automotriz</title>


    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&display=swap" rel="stylesheet">


    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/carruselIndex.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vendor/bootstrap-scoped.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">

</head>


<body class="bs">


<!-- NAVBAR -->
<header class="navbar">

    <span class="navbar-brand">
        Concesionaria Automotriz
    </span>

</header>




<!-- HERO -->

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




            <div class="hero-actions">


                <a href="${pageContext.request.contextPath}/login.jsp"
                   class="btn-outline">


                    <img
                            src="${pageContext.request.contextPath}/Images/user.svg"
                            class="hero-btn-icon">


                    Iniciar Sesión


                </a>




                <a href="${pageContext.request.contextPath}/register.jsp"
                   class="btn-register">

                    Registrarse

                </a>



            </div>


        </div>




        <div class="hero-logo">


            <div class="logo-placeholder">


                <img
                        src="${pageContext.request.contextPath}/Images/logo-SGCA.svg"
                        class="logo-img"
                        width="350">


            </div>


        </div>



    </section>




    <!-- Carrusel "Lo más nuevo" -->
    <section class="carrusel-section">

        <div class="carrusel-header">
            <h2>Lo más nuevo</h2>
            <div class="carrusel-controls">
                <button type="button" class="carrusel-btn carrusel-prev" aria-label="Anterior">&#8249;</button>
                <button type="button" class="carrusel-btn carrusel-next" aria-label="Siguiente">&#8250;</button>
            </div>
        </div>

        <div class="carrusel-track">
            <c:forEach var="v" items="${vehiculosNuevos}">
                <a class="auto-card" href="${pageContext.request.contextPath}/login.jsp">
                    <c:choose>
                        <c:when test="${not empty v.foto_Portada}">
                            <img class="auto-card-img" src="${pageContext.request.contextPath}/Images/imagesAutos/${v.foto_Portada}" alt="${v.marca.nombre} ${v.modelos.nombre}" />
                        </c:when>
                        <c:otherwise>
                            <div class="auto-card-img"></div>
                        </c:otherwise>
                    </c:choose>
                    <div class="auto-card-info">
                        <span class="auto-card-marca">${v.marca.nombre} ${v.modelos.nombre}</span>
                        <span class="auto-card-modelo">Año ${v.anio}</span>
                        <span class="auto-card-precio">$<fmt:formatNumber value="${v.precio}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </div>
                </a>
            </c:forEach>
            <c:if test="${empty vehiculosNuevos}">
                <p>No hay vehículos disponibles por el momento.</p>
            </c:if>
        </div>

        <div class="carrusel-scrollbar">
            <div class="carrusel-scrollbar-thumb"></div>
        </div>

    </section>



</main>





<!-- Carrusel "Lo más accesible" -->
<section class="carrusel-section">

    <div class="carrusel-header">
        <h2>Lo más accesible</h2>
        <div class="carrusel-controls">
            <button type="button" class="carrusel-btn carrusel-prev" aria-label="Anterior">&#8249;</button>
            <button type="button" class="carrusel-btn carrusel-next" aria-label="Siguiente">&#8250;</button>
        </div>
    </div>

    <div class="carrusel-track">
        <c:forEach var="v" items="${vehiculosAccesibles}">
            <a class="auto-card" href="${pageContext.request.contextPath}/login.jsp">
                <c:choose>
                    <c:when test="${not empty v.foto_Portada}">
                        <img class="auto-card-img" src="${pageContext.request.contextPath}/Images/imagesAutos/${v.foto_Portada}" alt="${v.marca.nombre} ${v.modelos.nombre}" />
                    </c:when>
                    <c:otherwise>
                        <div class="auto-card-img"></div>
                    </c:otherwise>
                </c:choose>
                <div class="auto-card-info">
                    <span class="auto-card-marca">${v.marca.nombre} ${v.modelos.nombre}</span>
                    <span class="auto-card-modelo">Año ${v.anio}</span>
                    <span class="auto-card-precio">$<fmt:formatNumber value="${v.precio}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                </div>
            </a>
        </c:forEach>
        <c:if test="${empty vehiculosAccesibles}">
            <p>No hay vehículos por debajo de este rango de precio por el momento.</p>
        </c:if>
    </div>

    <div class="carrusel-scrollbar">
        <div class="carrusel-scrollbar-thumb"></div>
    </div>

</section>


<!-- Carrusel "Recién agregado" -->
<section class="carrusel-section">

    <div class="carrusel-header">
        <h2>Recién agregado</h2>
        <div class="carrusel-controls">
            <button type="button" class="carrusel-btn carrusel-prev" aria-label="Anterior">&#8249;</button>
            <button type="button" class="carrusel-btn carrusel-next" aria-label="Siguiente">&#8250;</button>
        </div>
    </div>

    <div class="carrusel-track">
        <c:forEach var="v" items="${vehiculosRecientes}">
            <a class="auto-card" href="${pageContext.request.contextPath}/login.jsp">
                <c:choose>
                    <c:when test="${not empty v.foto_Portada}">
                        <img class="auto-card-img" src="${pageContext.request.contextPath}/Images/imagesAutos/${v.foto_Portada}" alt="${v.marca.nombre} ${v.modelos.nombre}" />
                    </c:when>
                    <c:otherwise>
                        <div class="auto-card-img"></div>
                    </c:otherwise>
                </c:choose>
                <div class="auto-card-info">
                    <span class="auto-card-marca">${v.marca.nombre} ${v.modelos.nombre}</span>
                    <span class="auto-card-modelo">Año ${v.anio}</span>
                    <span class="auto-card-precio">$<fmt:formatNumber value="${v.precio}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                </div>
            </a>
        </c:forEach>
        <c:if test="${empty vehiculosRecientes}">
            <p>No hay vehículos disponibles por el momento.</p>
        </c:if>
    </div>

    <div class="carrusel-scrollbar">
        <div class="carrusel-scrollbar-thumb"></div>
    </div>

</section>


<!-- Carrusel "Destacado" -->
<section class="carrusel-section">

    <div class="carrusel-header">
        <h2>Destacado</h2>
        <div class="carrusel-controls">
            <button type="button" class="carrusel-btn carrusel-prev" aria-label="Anterior">&#8249;</button>
            <button type="button" class="carrusel-btn carrusel-next" aria-label="Siguiente">&#8250;</button>
        </div>
    </div>

    <div class="carrusel-track">
        <c:forEach var="v" items="${vehiculosDestacados}">
            <a class="auto-card" href="${pageContext.request.contextPath}/login.jsp">
                <c:choose>
                    <c:when test="${not empty v.foto_Portada}">
                        <img class="auto-card-img" src="${pageContext.request.contextPath}/Images/imagesAutos/${v.foto_Portada}" alt="${v.marca.nombre} ${v.modelos.nombre}" />
                    </c:when>
                    <c:otherwise>
                        <div class="auto-card-img"></div>
                    </c:otherwise>
                </c:choose>
                <div class="auto-card-info">
                    <span class="auto-card-marca">${v.marca.nombre} ${v.modelos.nombre}</span>
                    <span class="auto-card-modelo">Año ${v.anio}</span>
                    <span class="auto-card-precio">$<fmt:formatNumber value="${v.precio}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                </div>
            </a>
        </c:forEach>
        <c:if test="${empty vehiculosDestacados}">
            <p>No hay vehículos disponibles por el momento.</p>
        </c:if>
    </div>

    <div class="carrusel-scrollbar">
        <div class="carrusel-scrollbar-thumb"></div>
    </div>

</section>

<footer class="footer">
    <p>
        © 2026 SGCA · Todos los derechos reservados
    </p>
</footer>

<script src="${pageContext.request.contextPath}/js/duenioJS/carrusel.js"></script>
</body>
</html>