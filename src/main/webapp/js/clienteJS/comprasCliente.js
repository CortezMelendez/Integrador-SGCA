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
