// ==========================================================
// Gestión de Autos (Asesor) — mismo patrón que duenioJS/gestionAutos.js,
// pero marca y modelo se eligen de catálogos ya existentes (nunca texto
// libre) y no hay selector de "Agente responsable" (se resuelve en el
// servidor a partir de la sesión).
// ==========================================================

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
        cerrarModal('modalExito');
    }
});

function cerrarTodoYMostrarTabla() {
    ['modalExito', 'modalAgregar', 'modalEditar', 'modalConfirmar'].forEach(cerrarModal);
}

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

function confirmarEliminarAuto(id) {
    pedirConfirmacion('¿Deseas eliminar este auto? Esta acción no se puede deshacer.', () => {
        window.location.href = `${CONTEXT_PATH}/gestionAutoAsesor?accion=eliminar&id=${id}`;
    }, 'peligro');
}

function confirmarGuardarEdicion() {
    if (!validarYPrepararEnvio('edit')) return;
    pedirConfirmacion('¿Deseas guardar los cambios de este auto?', () => {
        document.getElementById('formEditar').submit();
    });
}

function confirmarGuardarAgregar() {
    if (!validarYPrepararEnvio('mod')) return;
    pedirConfirmacion('¿Deseas registrar este auto?', () => {
        document.getElementById('formAgregar').submit();
    });
}

function resetearModalAgregar() {
    document.getElementById('formAgregar').reset();
    document.getElementById('mod-modelo').innerHTML = '<option value="">Selecciona una marca primero...</option>';
    const preview = document.getElementById('mod-foto-preview');
    const placeholder = document.getElementById('mod-foto-placeholder');
    preview.removeAttribute('src');
    preview.style.display = 'none';
    placeholder.style.display = 'flex';
    document.getElementById('mod-galeria-extra').innerHTML = '';
    document.getElementById('err-fotosExtra').textContent = '';
    limpiarErrores('mod');
}

// =========================================================
// MARCA -> MODELO (cascada, siempre desde el catálogo ya existente)
// =========================================================
function actualizarModelos(prefijo) {
    const idMarca = document.getElementById(`${prefijo}-marca`).value;
    const sel = document.getElementById(`${prefijo}-modelo`);
    sel.innerHTML = '';

    if (!idMarca) {
        sel.innerHTML = '<option value="">Selecciona una marca primero...</option>';
        return;
    }

    const modelos = (MODELOS_POR_MARCA && MODELOS_POR_MARCA[idMarca]) || [];
    if (modelos.length === 0) {
        sel.innerHTML = '<option value="">Esta marca aún no tiene modelos registrados</option>';
        return;
    }

    sel.innerHTML = '<option value="">Selecciona...</option>';
    modelos.forEach(m => {
        const opt = document.createElement('option');
        opt.value = m.idModelo;
        opt.textContent = m.nombre;
        sel.appendChild(opt);
    });
}

// Pinta el <select> de solo lectura del modal Editar con los modelos de la
// marca del vehículo, dejando seleccionado el que ya tenía.
function renderModelosSoloLectura(idMarca, idModeloSeleccionado) {
    const sel = document.getElementById('edit-modelo-display');
    sel.innerHTML = '';

    const modelos = (MODELOS_POR_MARCA && MODELOS_POR_MARCA[idMarca]) || [];
    modelos.forEach(m => {
        const opt = document.createElement('option');
        opt.value = m.idModelo;
        opt.textContent = m.nombre;
        if (String(m.idModelo) === String(idModeloSeleccionado)) opt.selected = true;
        sel.appendChild(opt);
    });
}

// =========================================================
// IMÁGENES ADICIONALES (hasta 10 por vehículo, además de la portada)
// =========================================================
const MAX_IMAGENES_EXTRA = 10;
let idsImagenesAEliminar = [];

function manejarFotosExtra(input, prefijo) {
    const errorEl = document.getElementById(prefijo === 'mod' ? 'err-fotosExtra' : 'edit-err-fotosExtra');
    errorEl.textContent = '';

    const seleccionados = Array.from(input.files || []);
    const noImagenes = seleccionados.filter(f => !esArchivoImagen(f));

    // Los archivos que no son imagen se descartan del propio input (con
    // DataTransfer, porque FileList es de solo lectura) para que no viajen
    // en el formulario aunque el usuario los haya seleccionado.
    if (noImagenes.length > 0) {
        const dt = new DataTransfer();
        seleccionados.filter(esArchivoImagen).forEach(f => dt.items.add(f));
        input.files = dt.files;
    }

    const archivos = Array.from(input.files || []);
    const limiteRestante = prefijo === 'edit'
        ? Math.max(0, MAX_IMAGENES_EXTRA - contarImagenesExistentes())
        : MAX_IMAGENES_EXTRA;

    if (noImagenes.length > 0) {
        errorEl.textContent = `${noImagenes.map(f => `"${f.name}"`).join(', ')} no ${noImagenes.length === 1 ? 'es una imagen válida' : 'son imágenes válidas'} y no se subirá${noImagenes.length === 1 ? '' : 'n'}.`;
    } else if (archivos.length > limiteRestante) {
        errorEl.textContent = `Solo puedes agregar ${limiteRestante} imagen(es) más (máximo ${MAX_IMAGENES_EXTRA} en total).`;
    }

    document.querySelectorAll(`#${prefijo}-galeria-extra .galeria-extra-nueva`).forEach(el => el.remove());

    const contenedor = document.getElementById(`${prefijo}-galeria-extra`);
    archivos.slice(0, limiteRestante).forEach(archivo => {
        const item = document.createElement('div');
        item.className = 'galeria-extra-item galeria-extra-nueva';

        const img = document.createElement('img');
        img.alt = 'Nueva imagen';
        const lector = new FileReader();
        lector.onload = e => { img.src = e.target.result; };
        lector.readAsDataURL(archivo);

        item.appendChild(img);
        contenedor.appendChild(item);
    });
}

function contarImagenesExistentes() {
    return document.querySelectorAll('#edit-galeria-extra .galeria-extra-existente').length;
}

function renderGaleriaExistente(idVehiculo) {
    const contenedor = document.getElementById('edit-galeria-extra');
    contenedor.innerHTML = '';
    idsImagenesAEliminar = [];
    document.getElementById('edit-eliminar-imagenes').value = '';

    const imagenes = (IMAGENES_POR_VEHICULO && IMAGENES_POR_VEHICULO[idVehiculo]) || [];
    imagenes.forEach(img => {
        const item = document.createElement('div');
        item.className = 'galeria-extra-item galeria-extra-existente';
        item.dataset.idImagen = img.idImagen;

        const foto = document.createElement('img');
        foto.src = `${CONTEXT_PATH}/Images/imagesAutos/${img.ruta}`;
        foto.alt = 'Imagen del vehículo';

        const btnQuitar = document.createElement('button');
        btnQuitar.type = 'button';
        btnQuitar.className = 'btn-quitar-imagen';
        btnQuitar.title = 'Quitar imagen';
        btnQuitar.textContent = '×';
        btnQuitar.onclick = () => quitarImagenExistente(img.idImagen, item);

        item.appendChild(foto);
        item.appendChild(btnQuitar);
        contenedor.appendChild(item);
    });
}

function quitarImagenExistente(idImagen, elemento) {
    idsImagenesAEliminar.push(idImagen);
    document.getElementById('edit-eliminar-imagenes').value = idsImagenesAEliminar.join(',');
    elemento.remove();
}

// Función para llenar datos en modal Editar
function abrirEditar(id, idMarca, idModelo, categoria, precio, color, placa, anio, estado, foto, fechaActualizado) {
    document.getElementById('edit-id').value = id;

    document.getElementById('edit-marca').value = idMarca;
    document.getElementById('edit-modelo').value = idModelo;

    const selMarca = document.getElementById('edit-marca-display');
    [...selMarca.options].forEach(o => o.selected = o.value === String(idMarca));
    renderModelosSoloLectura(idMarca, idModelo);

    document.getElementById('edit-precio').value = precio;
    document.getElementById('edit-color').value = color;
    document.getElementById('edit-placa').value = placa;
    document.getElementById('edit-anio').value = anio;
    document.getElementById('edit-descripcion').value = (DESCRIPCION_POR_VEHICULO && DESCRIPCION_POR_VEHICULO[id]) || '';

    ['edit-categoria', 'edit-estado'].forEach(id2 => {
        const sel = document.getElementById(id2);
        let val = categoria;
        if (id2 === 'edit-estado') val = estado;
        [...sel.options].forEach(o => o.selected = o.value === val);
    });

    document.getElementById('edit-foto-input').value = '';
    document.getElementById('edit-foto-actual').value = foto || '';

    const preview = document.getElementById('edit-foto-preview');
    const placeholder = document.getElementById('edit-foto-placeholder');
    if (foto && foto.trim() !== '') {
        preview.src = `${CONTEXT_PATH}/Images/imagesAutos/${foto}`;
        preview.style.display = 'block';
        placeholder.style.display = 'none';
    } else {
        preview.removeAttribute('src');
        preview.style.display = 'none';
        placeholder.style.display = 'flex';
    }

    document.getElementById('edit-fotos-extra-input').value = '';
    document.getElementById('edit-err-fotosExtra').textContent = '';
    renderGaleriaExistente(id);

    document.getElementById('edit-fecha-actualizado').textContent =
        fechaActualizado ? `Última actualización: ${fechaActualizado}` : '';

    limpiarErrores('edit');
    abrirModal('modalEditar');
}

// Función de filtrado en la tabla
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

    fetch(`${CONTEXT_PATH}/gestionAutoAsesor?accion=cambiarEstado&id=${idVehiculo}&disponible=${nuevoEstado}`)
        .catch(err => console.error('No se pudo actualizar el estado:', err));
}

// Vista previa de la imagen elegida en el <input type="file"> (Agregar / Editar)
// Un archivo cuenta como imagen si el navegador lo reconoce como tal por su
// contenido (input type="file" ya filtra por accept="image/*", pero el
// usuario puede forzar "Todos los archivos" en el selector del SO).
function esArchivoImagen(file) {
    return !!file && !!file.type && file.type.toLowerCase().startsWith('image/');
}

// Vista previa de la imagen elegida en el <input type="file"> (Agregar / Editar).
// Si el archivo no es una imagen, se marca el error en rojo y NO se sube:
// se limpia el input para que el form no lo envíe.
function previsualizarFoto(input, boxId, errId) {
    const box = document.getElementById(boxId);
    const preview = box.querySelector('.modal-photo-preview');
    const placeholder = box.querySelector('.upload-placeholder');
    const errorEl = errId ? document.getElementById(errId) : null;
    const file = input.files && input.files[0];
    if (!file) return;

    if (!esArchivoImagen(file)) {
        if (errorEl) errorEl.textContent = `"${file.name}" no es un archivo de imagen válido.`;
        input.value = '';
        preview.removeAttribute('src');
        preview.style.display = 'none';
        placeholder.style.display = 'flex';
        return;
    }

    if (errorEl) errorEl.textContent = '';

    const lector = new FileReader();
    lector.onload = e => {
        preview.src = e.target.result;
        preview.style.display = 'block';
        placeholder.style.display = 'none';
    };
    lector.readAsDataURL(file);
}

// --- Validación de campos (formato, no solo obligatorio) ---
const RE_COLOR = /^[A-Za-zÀ-ÖØ-öø-ÿ\s]{2,30}$/;
const RE_PLACA = /^[A-Z0-9\-]{5,10}$/;
const ANIO_MINIMO = 1980;
const ANIO_MAXIMO = 2100;

function sanearMientrasEscribe() {
    ['mod-color', 'edit-color'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('input', () => {
            el.value = el.value.replace(/[^A-Za-zÀ-ÖØ-öø-ÿ\s]/g, '');
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

    if (!datos.idMarca) {
        marcarError('marca', 'Selecciona una marca del catálogo.');
    }

    if (!datos.idModelo) {
        marcarError('modelo', 'Selecciona un modelo del catálogo.');
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

    return valido;
}

function validarYPrepararEnvio(prefijo) {
    const val = id => {
        const el = document.getElementById(id);
        return el ? el.value.trim() : '';
    };

    const datos = {
        idMarca: val(`${prefijo}-marca`),
        idModelo: val(`${prefijo}-modelo`),
        categoria: val(`${prefijo}-categoria`),
        precio: val(`${prefijo}-precio`),
        color: val(`${prefijo}-color`),
        placa: val(`${prefijo}-placa`).toUpperCase(),
        anio: val(`${prefijo}-anio`)
    };

    return validarCampos(prefijo, datos);
}

document.addEventListener('DOMContentLoaded', sanearMientrasEscribe);
