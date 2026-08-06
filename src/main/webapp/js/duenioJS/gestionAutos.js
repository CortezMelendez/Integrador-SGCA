// Ruta base de la app (se calcula desde la ubicación del script)
const CONTEXT_PATH = (() => {
    const partes = window.location.pathname.split('/');
    return partes.length > 1 ? '/' + partes[1] : '';
})();

// Funciones de Modal
function abrirModal(id) {
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

// Función para llenar datos en modal Editar
function abrirEditar(id, marca, modelo, categoria, precio, color, placa, anio, idAgente, estado) {
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

// Envía un formulario dinámico por POST hacia el servlet /gestionAutos
function enviarFormulario(datos) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = `${CONTEXT_PATH}/gestionAutos`;

    Object.entries(datos).forEach(([nombre, valor]) => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = nombre;
        input.value = valor;
        form.appendChild(input);
    });

    document.body.appendChild(form);
    form.submit();
}

// Guardar nuevo auto
function agregarRegistro() {
    const datos = {
        marca: document.getElementById('mod-marca').value.trim(),
        modelo: document.getElementById('mod-modelo').value.trim(),
        categoria: document.getElementById('mod-categoria').value,
        precio: document.getElementById('mod-precio').value,
        color: document.getElementById('mod-color').value.trim(),
        placa: document.getElementById('mod-placa').value.trim(),
        anio: document.getElementById('mod-anio').value,
        agente: document.getElementById('mod-agente').value,
        estado: document.getElementById('mod-estado').value
    };

    if (!validarCampos('mod', datos)) return;

    enviarFormulario({
        accion: 'registrar',
        marca: datos.marca,
        modelo: datos.modelo,
        categoria: datos.categoria,
        precio: datos.precio,
        color: datos.color,
        placa: datos.placa,
        anio: datos.anio,
        id_Agente: datos.agente,
        estado: datos.estado,
        foto_Portada: ''
    });
}

// Guardar edición de un auto existente
function guardarEdicion() {
    const datos = {
        marca: document.getElementById('edit-marca').value.trim(),
        modelo: document.getElementById('edit-modelo').value.trim(),
        categoria: document.getElementById('edit-categoria').value,
        precio: document.getElementById('edit-precio').value,
        color: document.getElementById('edit-color').value.trim(),
        placa: document.getElementById('edit-placa').value.trim(),
        anio: document.getElementById('edit-anio').value,
        agente: document.getElementById('edit-agente').value,
        estado: document.getElementById('edit-estado').value
    };

    if (!validarCampos('edit', datos)) return;

    enviarFormulario({
        accion: 'actualizar',
        id_Vehiculo: document.getElementById('edit-id').value,
        marca: datos.marca,
        modelo: datos.modelo,
        categoria: datos.categoria,
        precio: datos.precio,
        color: datos.color,
        placa: datos.placa,
        anio: datos.anio,
        id_Agente: datos.agente,
        estado: datos.estado,
        foto_Portada: ''
    });
}