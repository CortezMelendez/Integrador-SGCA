</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/duenioStyles/responsive.css">
</head>


<body>


<!-- NAVBAR -->
<header class="dash-navbar">


    <div class="dash-navbar-left">


        <span class="dash-brand">
            Gestionaria Automotriz
        </span>


    </div>



    <nav class="dash-nav-center">>


        <div class="dropdown">

            <button class="dash-nav-link dropdown-btn">
                Automóviles ▾
            </button>


            <div class="dropdown-menu">

                <a href="#">Sedán</a>
                <a href="#">Hatchback</a>
                <a href="#">Camioneta</a>
                <a href="#">Pickup</a>

            </div>

        </div>

        <a href="#" class="dash-nav-link">
            Servicios
        </a>


        <a href="#" class="dash-nav-link">
            Mis compras
        </a>



        <div class="dropdown">

            <button class="dash-nav-link dropdown-btn">
                Configuración ▾
            </button>


            <div class="dropdown-menu">

                <a href="#">Perfil</a>

                <a href="#">
                    Cambiar contraseña
                </a>

                <a href="${pageContext.request.contextPath}/logout">
                    Cerrar sesión
                </a>

            </div>

        </div>

        </div>


    </nav>

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




    <section class="carrusel-section" id="carrusel">

    </section>



</main>





<!-- CATALOGO -->

<section class="cliente">


    <!-- TITULO DEL CATALOGO -->
    <div class="catalogo-header">

        <h2 class="catalogo-titulo">
            Vehículos recién agregados
        </h2>

    </div>




    <!-- CONTENEDOR DE CARDS -->

    <div class="cards-container">



        <c:forEach var="v" items="${vehiculos}">


            <div class="card-auto">


                <img
                        class="card-imagen"
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

<footer class="footer">
    <p>
        © 2026 SGCA · Todos los derechos reservados
    </p>
</footer>

<script src="${pageContext.request.contextPath}/js/clienteJS/carrusel.js"></script>

<script>

    document.querySelectorAll(".dropdown-btn")
        .forEach(button => {


            button.addEventListener("click", function(e){


                e.stopPropagation();


                let menu = this.nextElementSibling;


                menu.classList.toggle("show");


            });


        });


    // Cerrar menú al hacer click fuera

    document.addEventListener("click", function(){


        document.querySelectorAll(".dropdown-menu")
            .forEach(menu => {

                menu.classList.remove("show");

            });


    });

</script>
</body>
