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
        cerrarModal('modalConfirmar');
    }
});

// =========================================================
// MODAL DE CONFIRMACIÓN (reemplaza confirm() del navegador)
// =========================================================
let _confirmCallback = null;

function pedirConfirmacion(mensaje, callback, tipo = 'normal') {
    document.getElementById('confirmMensaje').textContent = mensaje;

    const icono = document.getElementById('confirmIcono');
    const titulo = document.getElementById('confirmTitulo');
    const btnAceptar = document.getElementById('confirmBtnAceptar');

    if (tipo === 'peligro') {
        icono.textContent = '!';
        icono.classList.remove('icono-guardar');
        titulo.textContent = 'Confirmar eliminación';
        btnAceptar.textContent = 'Eliminar';
        btnAceptar.className = 'btn-modal-delete';
    } else {
        icono.textContent = '✓';
        icono.classList.add('icono-guardar');
        titulo.textContent = 'Confirmar cambios';
        btnAceptar.textContent = 'Guardar';
        btnAceptar.className = 'btn-modal-save';
    }

    _confirmCallback = callback;
    abrirModal('modalConfirmar');
}

document.getElementById('confirmBtnAceptar') && (document.getElementById('confirmBtnAceptar').onclick = () => {
    cerrarModal('modalConfirmar');
    const callback = _confirmCallback;
    _confirmCallback = null;
    if (typeof callback === 'function') callback();
});

// Guardar cambios del modal Editar
function confirmarGuardarEdicion() {
    if (!validarYPrepararEnvio('edit')) return;
    pedirConfirmacion('¿Deseas guardar los cambios de este servicio?', () => {
        document.getElementById('formEditar').submit();
    });
}

// Agregar servicio (modal Agregar)
function confirmarGuardarAgregar() {
    if (!validarYPrepararEnvio('mod')) return;
    pedirConfirmacion('¿Deseas agregar este servicio?', () => {
        document.getElementById('formAgregar').submit();
    });
}

// Limpia el formulario de "Agregar" cada vez que se abre desde cero
function resetearModalAgregar() {
    document.getElementById('formAgregar').reset();
    document.getElementById('mod-tipo').value = '';
    document.querySelectorAll('#mod-tipo-group .tipo-btn').forEach(b => b.classList.remove('activo'));

    const preview = document.getElementById('mod-foto-preview');
    const placeholder = document.getElementById('mod-foto-placeholder');
    preview.removeAttribute('src');
    preview.style.display = 'none';
    placeholder.style.display = 'flex';

    limpiarErrores('mod');
}

// Vista previa de la imagen elegida en el <input type="file"> (Agregar / Editar)
function previsualizarFoto(input, boxId) {
    const box = document.getElementById(boxId);
    const preview = box.querySelector('.modal-photo-preview');
    const placeholder = box.querySelector('.upload-placeholder');
    const file = input.files && input.files[0];
    if (!file) return;

    const lector = new FileReader();
    lector.onload = e => {
        preview.src = e.target.result;
        preview.style.display = 'block';
        placeholder.style.display = 'none';
    };
    lector.readAsDataURL(file);
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
function abrirEditar(id, nombre, descripcion, precio, idTipo, estado, foto) {
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

    // Limpia el <input type="file">: si el usuario no elige una nueva imagen,
    // se conserva la que ya tenía (ver campo oculto foto_actual)
    document.getElementById('edit-foto-input').value = '';
    document.getElementById('edit-foto-actual').value = foto || '';

    const preview = document.getElementById('edit-foto-preview');
    const placeholder = document.getElementById('edit-foto-placeholder');
    if (foto && foto.trim() !== '') {
        preview.src = `${CONTEXT_PATH}/${foto}`;
        preview.style.display = 'block';
        placeholder.style.display = 'none';
    } else {
        preview.removeAttribute('src');
        preview.style.display = 'none';
        placeholder.style.display = 'flex';
    }

    limpiarErrores('edit');
    abrirModal('modalEditar');
}

// --- ELIMINAR SERVICIO ---
function eliminarServicio(id, nombre) {
    pedirConfirmacion(`¿Deseas eliminar el servicio "${nombre}"? Esta acción no se puede deshacer.`, () => {
        document.getElementById('eliminar-id').value = id;
        document.getElementById('formEliminar').submit();
    }, 'peligro');
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

// --- VALIDACIÓN DE CAMPOS (formato, no solo obligatorio) ---
const RE_NOMBRE_SERVICIO = /^[A-Za-z0-9À-ÖØ-öø-ÿ\s.,\-\/]{3,60}$/;
const RE_DESCRIPCION = /^[A-Za-z0-9À-ÖØ-öø-ÿ\s.,\-\/()]{0,300}$/;

function limpiarErrores(prefijo) {
    document.querySelectorAll(`[id^="${prefijo === 'mod' ? 'err-' : 'edit-err-'}"]`)
        .forEach(el => el.textContent = '');
}

// Bloquea caracteres no permitidos mientras el usuario escribe el nombre del servicio
function sanearMientrasEscribe() {
    ['mod-nombre-servicio', 'edit-nombre'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('input', () => {
            el.value = el.value.replace(/[^A-Za-z0-9À-ÖØ-öø-ÿ\s.,\-\/]/g, '');
        });
    });
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
    const descripcion = val(`${prefijo}-descripcion`);

    const marcarError = (campo, mensaje) => {
        const elA = document.getElementById(`${errPrefix}${campo}`);
        if (elA) elA.textContent = mensaje;
    };

    let valido = true;

    if (!nombre) {
        marcarError('nombre-servicio', 'El nombre es obligatorio.');
        marcarError('nombre', 'El nombre es obligatorio.');
        valido = false;
    } else if (!RE_NOMBRE_SERVICIO.test(nombre)) {
        marcarError('nombre-servicio', 'Nombre inválido (3 a 60 caracteres, sin símbolos raros).');
        marcarError('nombre', 'Nombre inválido (3 a 60 caracteres, sin símbolos raros).');
        valido = false;
    }

    if (!tipo) {
        marcarError('tipo', 'Selecciona un tipo de servicio.');
        valido = false;
    }

    if (!precio || isNaN(Number(precio)) || Number(precio) < 0) {
        marcarError('precio', 'Ingresa un precio válido (mayor o igual a 0).');
        valido = false;
    }

    if (descripcion && !RE_DESCRIPCION.test(descripcion)) {
        marcarError('descripcion', 'La descripción contiene caracteres no permitidos.');
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
    sanearMientrasEscribe();
});