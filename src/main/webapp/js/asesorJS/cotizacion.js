document.addEventListener("DOMContentLoaded", () => {
    // 1. Base de datos simulada (En producción, esto se obtiene de una API o Base de Datos real)
    const baseDeDatos = {
        "125": {
            nombre: "Maria Gomez",
            direccion: "Av. de los Insurgentes Sur 123",
            id: "125",
            telefono: "55-1234-5678",
            vehiculo: "Chevrolet Spark 2019",
            servicios: "Cambio de balatas, Afinación mayor"
        }
        // Puedes agregar más registros aquí referenciando el data-id de otras filas
    };

    // 2. Referencias al DOM
    const modal = document.getElementById('modalCotizacion');
    const btnCerrar = document.getElementById('btn-cerrar-modal');

    const inputNombre = document.getElementById('modal-nombre');
    const inputDireccion = document.getElementById('modal-direccion');
    const inputId = document.getElementById('modal-id');
    const inputTelefono = document.getElementById('modal-telefono');
    const inputVehiculo = document.getElementById('modal-vehiculo');
    const inputServicios = document.getElementById('modal-servicios');

    // 3. Escuchar los clics en todos los botones de "Ver Cotización"
    const botonesVer = document.querySelectorAll('.btn-ver-cotizacion');
    
    botonesVer.forEach(boton => {
        boton.addEventListener('click', function() {
            // Obtener el TR más cercano al botón clickeado
            const fila = this.closest('tr');
            
            // Extraer el ID del atributo data-id
            const idCliente = fila.getAttribute('data-id');
            
            // Buscar los datos en nuestro objeto simulado
            const datosCliente = baseDeDatos[idCliente];
            
            if (datosCliente) {
                // Rellenar los campos
                inputNombre.value = datosCliente.nombre;
                inputDireccion.value = datosCliente.direccion;
                inputId.value = datosCliente.id;
                inputTelefono.value = datosCliente.telefono;
                inputVehiculo.value = datosCliente.vehiculo;
                inputServicios.value = datosCliente.servicios;
                
                // Mostrar el modal (usamos 'flex' para que funcione tu justify-content y align-items)
                modal.style.display = 'flex';
            } else {
                alert("No se encontraron los detalles para este cliente.");
            }
        });
    });

    // 4. Cerrar el modal al hacer clic en el botón "Cerrar"
    if (btnCerrar) {
        btnCerrar.addEventListener('click', () => {
            modal.style.display = 'none';
        });
    }

    // 5. (Opcional) Cerrar el modal si se hace clic afuera del recuadro blanco
    window.addEventListener('click', (evento) => {
        if (evento.target === modal) {
            modal.style.display = 'none';
        }
    });
});