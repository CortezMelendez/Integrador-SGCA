// --- SELECTORES PRINCIPALES ---
const modalAgregar = document.getElementById('modal-agregar');
const modalEditar = document.getElementById('modal-editar');
const btnAbrirAgregar = document.getElementById('btn-abrir-agregar');
const tablaBody = document.querySelector('#tabla tbody');
const buscador = document.getElementById('buscador-servicio');

// Variable global para recordar qué fila se está editando
let filaSeleccionada = null;

// --- CONTROL DE MODALES ---
function abrirModal(modal) {
    modal.classList.add('active');
    document.body.style.overflow = 'hidden';
}

function cerrarModal(modal) {
    modal.classList.remove('active');
    document.body.style.overflow = '';
}

// Escuchar clicks para abrir modal de agregar
btnAbrirAgregar.addEventListener('click', () => {
    // Limpiar campos antes de abrir
    document.getElementById('mod-nombre-servicio').value = '';
    document.getElementById('mod-precio').value = '';
    document.getElementById('mod-tipo').selectedIndex = 0;
    document.getElementById('mod-estado').selectedIndex = 0;
    abrirModal(modalAgregar);
});

// Escuchar todos los botones de cancelar en los modales
document.querySelectorAll('.btn-modal-cancel').forEach(btn => {
    btn.addEventListener('click', () => {
        cerrarModal(modalAgregar);
        cerrarModal(modalEditar);
    });
});

// Cerrar haciendo click en el fondo opaco (overlay)
window.addEventListener('click', (e) => {
    if (e.target === modalAgregar) cerrarModal(modalAgregar);
    if (e.target === modalEditar) cerrarModal(modalEditar);
});

// Cerrar con la tecla Escape
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        cerrarModal(modalAgregar);
        cerrarModal(modalEditar);
    }
});




// ACCIÓN: AGREGAR NUEVO REGISTRO (CON VALIDACIÓN)
document.getElementById('btn-guardar-agregar').addEventListener('click', () => {
    const nombre = document.getElementById('mod-nombre-servicio').value.trim();
    const tipo = document.getElementById('mod-tipo').value;
    const precio = document.getElementById('mod-precio').value.trim();
    const estado = document.getElementById('mod-estado').value;

    // Validación estricta para no dejar datos en blanco
    if (!nombre || !precio) {
        alert('Por favor, complete todos los campos obligatorios (Nombre y Precio).');
        return;
    }

    // Formatear precio de forma visual
    const precioFormateado = parseFloat(precio).toLocaleString('es-MX', { minimumFractionDigits: 0 });

    // Definir la clase del badge según estado
    const badgeClass = estado === 'Activo' ? 'badge-active' : 'badge-inactive';

    // Crear la estructura de la nueva fila HTML
    const nuevaFila = document.createElement('tr');
    nuevaFila.innerHTML = `
        <td><div class="foto-placeholder"></div></td>
        <td>${nombre}</td>
        <td><div class="precio">$${precioFormateado}</div></td>
        <td><span class="badge ${badgeClass}">${estado}</span></td>
        <td>${tipo}</td>
        <td>
            <div class="action-group">
                <button class="btn-icon btn-edit" title="Editar">
                    <img src="../../Images/edit.svg" alt="">
                </button>
                <button class="btn-icon btn-delete" title="Eliminar">
                    <img src="../../Images/delete.svg" alt="" width="20">
                </button>
            </div>
        </td>
    `;

    // Adjuntar a la tabla y cerrar
    tablaBody.appendChild(nuevaFila);
    cerrarModal(modalAgregar);
});


// DELEGACIÓN DE EVENTOS EN LA TABLA (ELIMINAR, EDITAR Y INTERRUPTOR DE ESTADO)
tablaBody.addEventListener('click', (e) => {
    
    // 1. Alternar estado haciendo click en el Badge directamente
    if (e.target.classList.contains('badge')) {
        const badge = e.target;
        if (badge.classList.contains('badge-inactive')) {
            badge.classList.remove('badge-inactive');
            badge.classList.add('badge-active');
            badge.textContent = 'Activo';
        } else {
            badge.classList.remove('badge-active');
            badge.classList.add('badge-inactive');
            badge.textContent = 'Inactivo';
        }
        return;
    }

    // 2. Acción del botón ELIMINAR con confirmación previa
    const btnDelete = e.target.closest('.btn-delete');
    if (btnDelete) {
        const fila = btnDelete.closest('tr');
        const nombreServicio = fila.cells[1].textContent.trim(); // Lee la columna 'Nombre'

        const confirmar = confirm(`¿De verdad desea borrar el registro del servicio "${nombreServicio}"?`);
        if (confirmar) {
            fila.remove();
        }
        return;
    }

    // 3. Acción del botón EDITAR (Toma los datos de la fila actual y los monta al modal)
    const btnEdit = e.target.closest('.btn-edit');
    if (btnEdit) {
        filaSeleccionada = btnEdit.closest('tr');

        // Extraer textos limpios quitando signos de dinero y espacios
        const nombre = filaSeleccionada.cells[1].textContent.trim();
        const precio = filaSeleccionada.cells[2].textContent.replace('$', '').replace(',', '').trim();
        const estado = filaSeleccionada.cells[3].textContent.trim();
        const tipo = filaSeleccionada.cells[4].textContent.trim();

        // Rellenar controles del modal editar
        document.getElementById('edit-nombre').value = nombre;
        document.getElementById('edit-precio').value = precio;
        document.getElementById('edit-tipo').value = tipo;
        document.getElementById('edit-estado').value = estado;

        abrirModal(modalEditar);
    }
});


// ACCIÓN: CONFIRMAR LA EDICIÓN Y ACTUALIZAR LA FILA
document.getElementById('btn-guardar-editar').addEventListener('click', () => {
    if (!filaSeleccionada) return;

    const nombre = document.getElementById('edit-nombre').value.trim();
    const precio = document.getElementById('edit-precio').value.trim();
    const tipo = document.getElementById('edit-tipo').value;
    const estado = document.getElementById('edit-estado').value;

    // Validación en edición
    if (!nombre || !precio) {
        alert('No puede dejar campos en blanco al editar el servicio.');
        return;
    }

    const precioFormateado = parseFloat(precio).toLocaleString('es-MX', { minimumFractionDigits: 0 });
    const badgeClass = estado === 'Activo' ? 'badge-active' : 'badge-inactive';

    // Inyectar los nuevos datos en las celdas correspondientes de la fila memorizada
    filaSeleccionada.cells[1].textContent = nombre;
    filaSeleccionada.cells[2].innerHTML = `<div class="precio">$${precioFormateado}</div>`;
    filaSeleccionada.cells[3].innerHTML = `<span class="badge ${badgeClass}">${estado}</span>`;
    filaSeleccionada.cells[4].textContent = tipo;

    // Resetear y cerrar
    cerrarModal(modalEditar);
    filaSeleccionada = null;
});


// --- FUNCIÓN DE BÚSQUEDA/FILTRADO ---
buscador.addEventListener('input', (e) => {
    const texto = e.target.value.toLowerCase();
    
    document.querySelectorAll('#tabla tbody tr').forEach(tr => {
        // Muestra u oculta filas basándose en si contienen el string ingresado
        tr.style.display = tr.textContent.toLowerCase().includes(texto) ? '' : 'none';
    });
});