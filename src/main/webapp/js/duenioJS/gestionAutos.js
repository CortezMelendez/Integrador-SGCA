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
    }
});

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
function abrirEditar(id, marca, modelo, categoria, precio, color, placa, anio, idAgente, estado, foto, fechaActualizado, urlEliminar) {
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

    // Link de eliminar de este auto en particular
    const eliminarLink = document.getElementById('edit-eliminar-link');
    if (urlEliminar) eliminarLink.setAttribute('href', urlEliminar);

    limpiarErrores('edit');
    abrirModal('modalEditar');
}

// Función de filtrado en la tabla
function filtrar(texto) {
    document.querySelectorAll('#tabla tbody tr').forEach(tr => {
        tr.style.display = tr.textContent.toLowerCase().includes(texto.toLowerCase()) ? '' : 'none';
    });
}

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

// --- Validación básica ---
function limpiarErrores(prefijo) {
    document.querySelectorAll(`[id^="${prefijo === 'mod' ? 'err-' : 'edit-err-'}"]`)
        .forEach(el => el.textContent = '');
}

function validarCampos(prefijo, datos) {
    limpiarErrores(prefijo);
    const errPrefix = prefijo === 'mod' ? 'err-' : 'edit-err-';
    let valido = true;

    const requeridos = {
        marca: 'La marca es obligatoria',
        modelo: 'El modelo es obligatorio',
        categoria: 'Selecciona una categoría',
        precio: 'Ingresa un precio válido',
        color: 'El color es obligatorio',
        placa: 'La placa es obligatoria',
        anio: 'Ingresa un año válido',
        agente: 'Selecciona un agente'
    };

    for (const campo in requeridos) {
        const val = datos[campo];
        const vacio = val === null || val === undefined || val === '' ||
            ((campo === 'precio' || campo === 'anio' || campo === 'agente') && isNaN(Number(val)));
        if (vacio) {
            const errEl = document.getElementById(errPrefix + campo);
            if (errEl) errEl.textContent = requeridos[campo];
            valido = false;
        }
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
        placa: val(`${prefijo}-placa`),
        anio: val(`${prefijo}-anio`),
        agente: val(`${prefijo}-agente`)
    };

    return validarCampos(prefijo, datos);
}