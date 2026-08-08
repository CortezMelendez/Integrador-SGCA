// Ruta base de la app (se calcula desde la ubicación del script)
const CONTEXT_PATH = (() => {
    const partes = window.location.pathname.split('/');
    return partes.length > 1 ? '/' + partes[1] : '';
})();

// --- CONTROL DE MODALES ---
function abrirModal(id) {
    if (id === 'modalAgregar') resetearModalAgregar();
    document.getElementById(id).classList.add('active');
    document.body.style.overflow = 'hidden';
}

function cerrarModal(id) {
    document.getElementById(id).classList.remove('active');
    document.body.style.overflow = '';
}

function cerrarOverlay(e, id) {
    if (e.target === document.getElementById(id)) cerrarModal(id);
}

document.addEventListener('keydown', e => {
    if (e.key === 'Escape') {
        cerrarModal('modalAgregar');
        cerrarModal('modalEditar');
    }
});

// Limpia el formulario de "Agregar" cada vez que se abre desde cero
function resetearModalAgregar() {
    document.getElementById('formAgregar').reset();
    document.getElementById('mod-tipo').value = '';
    document.querySelectorAll('#mod-tipo-group .tipo-btn').forEach(b => b.classList.remove('activo'));
    limpiarErrores('mod');
}

// --- SELECCIÓN DE "TIPO DE SERVICIO" (botones tipo Único/Mensual/Anual) ---
function seleccionarTipo(prefijo, id, boton) {
    document.getElementById(`${prefijo}-tipo`).value = id;
    document.querySelectorAll(`#${prefijo}-tipo-group .tipo-btn`).forEach(b => b.classList.remove('activo'));
    boton.classList.add('activo');

    const errEl = document.getElementById(prefijo === 'mod' ? 'err-tipo' : 'edit-err-tipo');
    if (errEl) errEl.textContent = '';
}

// --- LLENAR MODAL EDITAR CON LOS DATOS DE LA FILA ---
function abrirEditar(id, nombre, descripcion, precio, idTipo, estado) {
    document.getElementById('edit-id').value = id;
    document.getElementById('edit-nombre').value = nombre;
    document.getElementById('edit-descripcion').value = descripcion;
    document.getElementById('edit-precio').value = precio;

    document.getElementById('edit-tipo').value = idTipo;
    document.querySelectorAll('#edit-tipo-group .tipo-btn').forEach(b => {
        b.classList.toggle('activo', b.dataset.id === String(idTipo));
    });

    const selEstado = document.getElementById('edit-estado');
    const valorEstado = estado === 'Activo' ? '1' : '0';
    [...selEstado.options].forEach(o => o.selected = o.value === valorEstado);

    limpiarErrores('edit');
    abrirModal('modalEditar');
}

// --- ELIMINAR SERVICIO ---
function eliminarServicio(id, nombre) {
    const confirmar = confirm(`¿De verdad desea borrar el registro del servicio "${nombre}"?`);
    if (!confirmar) return;

    document.getElementById('eliminar-id').value = id;
    document.getElementById('formEliminar').submit();
}

// --- BÚSQUEDA / FILTRADO (marca las filas que coinciden, la paginación decide cuáles mostrar) ---
function filtrar(texto) {
    const t = texto.toLowerCase();
    document.querySelectorAll('#tabla tbody tr').forEach(tr => {
        const coincide = tr.textContent.toLowerCase().includes(t);
        tr.dataset.oculta = coincide ? 'false' : 'true';
    });
    paginaActual = 1;
    aplicarPaginacion();
}

// =========================================================
// PAGINACIÓN (5-8 registros por página)
// =========================================================
const REGISTROS_POR_PAGINA = 8;
let paginaActual = 1;

function filasVisiblesPorFiltro() {
    return [...document.querySelectorAll('#tabla tbody tr')]
        .filter(tr => tr.dataset.oculta !== 'true' && !tr.classList.contains('fila-vacia'));
}

function aplicarPaginacion() {
    const filas = filasVisiblesPorFiltro();
    const totalPaginas = Math.max(1, Math.ceil(filas.length / REGISTROS_POR_PAGINA));

    if (paginaActual > totalPaginas) paginaActual = totalPaginas;
    if (paginaActual < 1) paginaActual = 1;

    filas.forEach((fila, i) => {
        const inicio = (paginaActual - 1) * REGISTROS_POR_PAGINA;
        const fin = inicio + REGISTROS_POR_PAGINA;
        fila.style.display = (i >= inicio && i < fin) ? '' : 'none';
    });

    // Las filas ocultas por el buscador siempre quedan ocultas
    document.querySelectorAll('#tabla tbody tr').forEach(tr => {
        if (tr.dataset.oculta === 'true') tr.style.display = 'none';
    });

    renderizarControlesPaginacion(totalPaginas, filas.length);
}

function renderizarControlesPaginacion(totalPaginas, totalFilas) {
    const contenedor = document.getElementById('paginacion');
    if (!contenedor) return;

    if (totalFilas === 0 || totalPaginas <= 1) {
        contenedor.innerHTML = '';
        return;
    }

    let html = '';

    html += `<button type="button" class="btn-pagina" ${paginaActual === 1 ? 'disabled' : ''} onclick="irAPagina(${paginaActual - 1})">‹ Anterior</button>`;

    for (let p = 1; p <= totalPaginas; p++) {
        html += `<button type="button" class="btn-pagina ${p === paginaActual ? 'activo' : ''}" onclick="irAPagina(${p})">${p}</button>`;
    }

    html += `<button type="button" class="btn-pagina" ${paginaActual === totalPaginas ? 'disabled' : ''} onclick="irAPagina(${paginaActual + 1})">Siguiente ›</button>`;

    contenedor.innerHTML = html;
}

function irAPagina(numero) {
    paginaActual = numero;
    aplicarPaginacion();
}

// --- ALTERNAR ESTADO ACTIVO/INACTIVO (click en badge), persistido en BD ---
function toggleEstado(elemento, idServicio) {
    const activo = elemento.classList.contains('badge-active');
    const nuevoEstado = activo ? 0 : 1;

    elemento.classList.toggle('badge-inactive');
    elemento.classList.toggle('badge-active');
    elemento.textContent = nuevoEstado === 1 ? 'Activo' : 'Inactivo';

    fetch(`${CONTEXT_PATH}/servicios`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `accion=estado&id_servicio=${idServicio}&estado=${nuevoEstado}`
    }).catch(err => console.error('No se pudo actualizar el estado:', err));
}

// --- VALIDACIÓN BÁSICA ---
function limpiarErrores(prefijo) {
    document.querySelectorAll(`[id^="${prefijo === 'mod' ? 'err-' : 'edit-err-'}"]`)
        .forEach(el => el.textContent = '');
}

function validarYPrepararEnvio(prefijo) {
    limpiarErrores(prefijo);
    const errPrefix = prefijo === 'mod' ? 'err-' : 'edit-err-';
    const val = id => {
        const el = document.getElementById(id);
        return el ? el.value.trim() : '';
    };

    const nombre = val(`${prefijo}-nombre-servicio`) || val(`${prefijo}-nombre`);
    const tipo = val(`${prefijo}-tipo`);
    const precio = val(`${prefijo}-precio`);

    let valido = true;

    if (!nombre) {
        document.getElementById(`${errPrefix}nombre-servicio`) &&
        (document.getElementById(`${errPrefix}nombre-servicio`).textContent = 'El nombre es obligatorio');
        document.getElementById(`${errPrefix}nombre`) &&
        (document.getElementById(`${errPrefix}nombre`).textContent = 'El nombre es obligatorio');
        valido = false;
    }
    if (!tipo) {
        const errTipo = document.getElementById(`${errPrefix}tipo`);
        if (errTipo) errTipo.textContent = 'Selecciona un tipo de servicio';
        valido = false;
    }
    if (!precio || isNaN(Number(precio)) || Number(precio) < 0) {
        const errPrecio = document.getElementById(`${errPrefix}precio`);
        if (errPrecio) errPrecio.textContent = 'Ingresa un precio válido';
        valido = false;
    }

    return valido;
}

// --- BÚSQUEDA (input externo, mantiene compatibilidad con el buscador de la vista) ---
const buscadorEl = document.getElementById('buscador-servicio');
if (buscadorEl) {
    buscadorEl.addEventListener('input', (e) => filtrar(e.target.value));
}

// --- INICIALIZAR PAGINACIÓN AL CARGAR LA PÁGINA ---
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('#tabla tbody tr').forEach(tr => {
        if (!tr.classList.contains('fila-vacia')) tr.dataset.oculta = 'false';
    });
    aplicarPaginacion();
});