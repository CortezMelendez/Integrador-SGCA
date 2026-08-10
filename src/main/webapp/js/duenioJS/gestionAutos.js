// Ruta base de la app (se calcula desde la ubicación del script)
const CONTEXT_PATH = (() => {
    const partes = window.location.pathname.split('/');
    return partes.length > 1 ? '/' + partes[1] : '';
})();

// Funciones de Modal
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

// Eliminar auto (icono de la tabla)
function confirmarEliminarAuto(id) {
    pedirConfirmacion('¿Deseas eliminar este auto? Esta acción no se puede deshacer.', () => {
        window.location.href = `${CONTEXT_PATH}/gestionAutos?accion=eliminar&id=${id}`;
    }, 'peligro');
}

// Guardar cambios del modal Editar
function confirmarGuardarEdicion() {
    if (!validarYPrepararEnvio('edit')) return;
    pedirConfirmacion('¿Deseas guardar los cambios de este auto?', () => {
        document.getElementById('formEditar').submit();
    });
}

// Limpia el formulario de "Agregar" cada vez que se abre desde cero
function resetearModalAgregar() {
    document.getElementById('formAgregar').reset();
    const preview = document.getElementById('mod-foto-preview');
    const placeholder = document.getElementById('mod-foto-placeholder');
    preview.removeAttribute('src');
    preview.style.display = 'none';
    placeholder.style.display = 'flex';
    limpiarErrores('mod');
}

// Función para llenar datos en modal Editar
function abrirEditar(id, marca, modelo, categoria, precio, color, placa, anio, idAgente, estado, foto, fechaActualizado) {
    document.getElementById('edit-id').value = id;
    document.getElementById('edit-marca').value = marca;
    document.getElementById('edit-modelo').value = modelo;
    document.getElementById('edit-precio').value = precio;
    document.getElementById('edit-color').value = color;
    document.getElementById('edit-placa').value = placa;
    document.getElementById('edit-anio').value = anio;

    ['edit-categoria', 'edit-agente', 'edit-estado'].forEach(id2 => {
        const sel = document.getElementById(id2);
        let val = categoria;
        if (id2 === 'edit-agente') val = String(idAgente);
        if (id2 === 'edit-estado') val = estado;
        [...sel.options].forEach(o => o.selected = o.value === val);
    });

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

    // Última actualización
    document.getElementById('edit-fecha-actualizado').textContent =
        fechaActualizado ? `Última actualización: ${fechaActualizado}` : '';

    limpiarErrores('edit');
    abrirModal('modalEditar');
}

// Función de filtrado en la tabla (marca las filas que coinciden; la paginación decide cuáles mostrar)
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
// PAGINACIÓN (8 registros por página)
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

document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('#tabla tbody tr').forEach(tr => {
        if (!tr.classList.contains('fila-vacia')) tr.dataset.oculta = 'false';
    });
    aplicarPaginacion();
});

// Alternar estado Activo/Inactivo (Click en Badge) y persistirlo en la BD
function toggleEstado(elemento, idVehiculo) {
    const activo = elemento.classList.contains('badge-active');
    const nuevoEstado = activo ? 0 : 1;

    elemento.classList.toggle('badge-inactive');
    elemento.classList.toggle('badge-active');
    elemento.textContent = nuevoEstado === 1 ? 'Activo' : 'Inactivo';

    fetch(`${CONTEXT_PATH}/gestionAutos?accion=cambiarEstado&id=${idVehiculo}&disponible=${nuevoEstado}`)
        .catch(err => console.error('No se pudo actualizar el estado:', err));
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

// --- Validación de campos (formato, no solo obligatorio) ---
const RE_MARCA = /^[A-Za-zÀ-ÖØ-öø-ÿ\s]{2,30}$/;
const RE_MODELO = /^[A-Za-z0-9À-ÖØ-öø-ÿ\s\-]{1,30}$/;
const RE_COLOR = /^[A-Za-zÀ-ÖØ-öø-ÿ\s]{2,30}$/;
const RE_PLACA = /^[A-Z0-9\-]{5,10}$/;
const ANIO_MINIMO = 1980;
const ANIO_MAXIMO = 2100;

// Bloquea caracteres no permitidos mientras el usuario escribe
function sanearMientrasEscribe() {
    ['mod-marca', 'edit-marca', 'mod-color', 'edit-color'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('input', () => {
            el.value = el.value.replace(/[^A-Za-zÀ-ÖØ-öø-ÿ\s]/g, '');
        });
    });

    ['mod-modelo', 'edit-modelo'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('input', () => {
            el.value = el.value.replace(/[^A-Za-z0-9À-ÖØ-öø-ÿ\s\-]/g, '');
        });
    });

    ['mod-placa', 'edit-placa'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('input', () => {
            el.value = el.value.toUpperCase().replace(/[^A-Z0-9\-]/g, '').slice(0, 10);
        });
    });
}

function limpiarErrores(prefijo) {
    document.querySelectorAll(`[id^="${prefijo === 'mod' ? 'err-' : 'edit-err-'}"]`)
        .forEach(el => el.textContent = '');
}

function validarCampos(prefijo, datos) {
    limpiarErrores(prefijo);
    const errPrefix = prefijo === 'mod' ? 'err-' : 'edit-err-';
    let valido = true;

    const marcarError = (campo, mensaje) => {
        const el = document.getElementById(errPrefix + campo);
        if (el) el.textContent = mensaje;
        valido = false;
    };

    if (!datos.marca) {
        marcarError('marca', 'La marca es obligatoria.');
    } else if (!RE_MARCA.test(datos.marca)) {
        marcarError('marca', 'Solo se permiten letras y espacios.');
    }

    if (!datos.modelo) {
        marcarError('modelo', 'El modelo es obligatorio.');
    } else if (!RE_MODELO.test(datos.modelo)) {
        marcarError('modelo', 'Usa solo letras, números, espacios o guiones.');
    }

    if (!datos.categoria) {
        marcarError('categoria', 'Selecciona una categoría.');
    }

    if (!datos.precio || isNaN(Number(datos.precio)) || Number(datos.precio) < 0) {
        marcarError('precio', 'Ingresa un precio válido (mayor o igual a 0).');
    }

    if (!datos.color) {
        marcarError('color', 'El color es obligatorio.');
    } else if (!RE_COLOR.test(datos.color)) {
        marcarError('color', 'Solo se permiten letras y espacios.');
    }

    if (!datos.placa) {
        marcarError('placa', 'La placa es obligatoria.');
    } else if (!RE_PLACA.test(datos.placa)) {
        marcarError('placa', 'La placa debe tener entre 5 y 10 caracteres (letras, números o guiones).');
    }

    const anioNum = Number(datos.anio);
    if (!datos.anio || isNaN(anioNum) || anioNum < ANIO_MINIMO || anioNum > ANIO_MAXIMO) {
        marcarError('anio', `Ingresa un año entre ${ANIO_MINIMO} y ${ANIO_MAXIMO}.`);
    }

    if (!datos.agente || isNaN(Number(datos.agente))) {
        marcarError('agente', 'Selecciona un agente.');
    }

    return valido;
}

// Se ejecuta en el onsubmit de los formularios reales (formAgregar / formEditar).
// Si retorna false, el navegador NO envía el formulario (evita el POST con datos inválidos).
function validarYPrepararEnvio(prefijo) {
    const val = id => {
        const el = document.getElementById(id);
        return el ? el.value.trim() : '';
    };

    const datos = {
        marca: val(`${prefijo}-marca`),
        modelo: val(`${prefijo}-modelo`),
        categoria: val(`${prefijo}-categoria`),
        precio: val(`${prefijo}-precio`),
        color: val(`${prefijo}-color`),
        placa: val(`${prefijo}-placa`).toUpperCase(),
        anio: val(`${prefijo}-anio`),
        agente: val(`${prefijo}-agente`)
    };

    return validarCampos(prefijo, datos);
}

document.addEventListener('DOMContentLoaded', sanearMientrasEscribe);