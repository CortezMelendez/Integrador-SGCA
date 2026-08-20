document.addEventListener("DOMContentLoaded", function () {

    const input = document.getElementById("buscarCompra");
    const filas = document.querySelectorAll("#tablaCompras tbody tr");
    const sinResultados = document.getElementById("sinResultados");

    if (!input) {
        return;
    }

    input.addEventListener("input", function () {

        const termino = input.value.trim().toLowerCase();
        let visibles = 0;

        filas.forEach(function (fila) {

            const placa = (fila.dataset.placa || "").toLowerCase();
            const modelo = (fila.dataset.modelo || "").toLowerCase();
            const coincide = placa.includes(termino) || modelo.includes(termino);

            fila.hidden = !coincide;

            if (coincide) {
                visibles++;
            }
        });

        if (sinResultados) {
            sinResultados.hidden = visibles !== 0 || filas.length === 0;
        }
    });

});

/* =============================================
   Contratar servicio adicional para un vehículo ya adquirido
   (DFR módulo 5.2). abrirContratarServicio se llama desde el
   onclick de cada fila de la tabla, por eso queda como función global.
============================================= */
let _idVentaContratarServicio = null;

function abrirContratarServicio(idVenta, nombreVehiculo) {
    _idVentaContratarServicio = idVenta;

    document.getElementById("contratarServicioVehiculo").textContent = nombreVehiculo;
    document.getElementById("errorContratarServicio").textContent = "";
    document.getElementById("exitoContratarServicio").textContent = "";

    document.querySelectorAll("#contratarServiciosLista .cotizacion-servicio-checkbox")
        .forEach(function (cb) { cb.checked = false; });

    document.getElementById("modalContratarServicio").classList.add("active");
}

document.addEventListener("DOMContentLoaded", function () {
    const CONTEXT_PATH = window.COMPRAS_CONTEXT_PATH || "";

    const modal = document.getElementById("modalContratarServicio");
    const btnCerrar = document.getElementById("btnCerrarContratarServicio");
    const btnConfirmar = document.getElementById("btnConfirmarContratarServicio");
    const error = document.getElementById("errorContratarServicio");
    const exito = document.getElementById("exitoContratarServicio");

    if (!modal || !btnConfirmar) return;

    btnCerrar.addEventListener("click", function () {
        modal.classList.remove("active");
    });

    modal.addEventListener("click", function (e) {
        if (e.target === modal) modal.classList.remove("active");
    });

    btnConfirmar.addEventListener("click", async function () {
        error.textContent = "";
        exito.textContent = "";

        const idsSeleccionados = Array.from(
            document.querySelectorAll("#contratarServiciosLista .cotizacion-servicio-checkbox:checked")
        ).map(function (cb) { return cb.value; });

        if (idsSeleccionados.length === 0) {
            error.textContent = "Selecciona al menos un servicio.";
            return;
        }

        const cuerpo = new URLSearchParams();
        cuerpo.set("idVenta", _idVentaContratarServicio);
        idsSeleccionados.forEach(function (id) { cuerpo.append("idsServicios", id); });

        try {
            const respuesta = await fetch(CONTEXT_PATH + "/contratarServicio", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: cuerpo.toString()
            });
            const texto = (await respuesta.text()).trim();

            if (respuesta.ok) {
                exito.textContent = texto;
                setTimeout(function () { window.location.reload(); }, 900);
            } else {
                error.textContent = texto;
            }
        } catch (err) {
            error.textContent = "No se pudo contactar al servidor. Intenta de nuevo.";
        }
    });
});
