// ==========================================================
// Mis cotizaciones (Asesor) — tabla de ventas propias + modal "Nueva
// cotización" con buscador de cliente, vehículo y servicios.
// ==========================================================

const CONTEXT_PATH = (() => {
    const partes = window.location.pathname.split('/');
    return partes.length > 1 ? '/' + partes[1] : '';
})();

// -------------------------------
// Modal
// -------------------------------
function cerrarModal(id) {
    document.getElementById(id).classList.remove('active');
    document.body.style.overflow = '';
}

function cerrarOverlay(e, id) {
    if (e.target === document.getElementById(id)) cerrarModal(id);
}

document.addEventListener('keydown', e => {
    if (e.key === 'Escape') cerrarModal('modalCotizacion');
});

// -------------------------------
// Estado de la selección actual
// -------------------------------
let clienteSeleccionado = null;   // {id, nombre}
let vehiculoSeleccionado = null;  // {id, nombre, precio}
const serviciosSeleccionados = new Set();

function abrirModalCotizacion() {
    clienteSeleccionado = null;
    vehiculoSeleccionado = null;
    serviciosSeleccionados.clear();

    document.getElementById('buscarCliente').value = '';
    document.getElementById('buscarVehiculo').value = '';
    document.getElementById('buscarServicio').value = '';
    document.getElementById('clienteSeleccionadoTxt').textContent = 'Ningún cliente seleccionado.';
    document.getElementById('vehiculoSeleccionadoTxt').textContent = 'Ningún vehículo seleccionado.';
    document.getElementById('errorCliente').textContent = '';
    document.getElementById('errorVehiculo').textContent = '';
    document.getElementById('errorCotizacion').textContent = '';
    document.getElementById('exitoCotizacion').textContent = '';

    renderBuscador('cliente', CLIENTES_ASESOR, '');
    renderBuscador('vehiculo', VEHICULOS_DISPONIBLES, '');
    renderServicios('');
    calcularTotal();

    document.getElementById('modalCotizacion').classList.add('active');
    document.body.style.overflow = 'hidden';
}

// -------------------------------
// Buscadores de Cliente y Vehículo (selección única)
// -------------------------------
function filtrarBuscador(tipo, texto) {
    const t = texto.trim().toLowerCase();
    const datos = tipo === 'cliente' ? CLIENTES_ASESOR : (tipo === 'vehiculo' ? VEHICULOS_DISPONIBLES : null);

    if (tipo === 'servicio') {
        renderServicios(t);
        return;
    }

    const filtrados = datos.filter(item => item.nombre.toLowerCase().includes(t));
    renderBuscador(tipo, filtrados, t);
}

function renderBuscador(tipo, items, textoActual) {
    const contenedor = document.getElementById(tipo === 'cliente' ? 'listaClientes' : 'listaVehiculos');
    contenedor.innerHTML = '';

    if (items.length === 0) {
        const vacio = document.createElement('p');
        vacio.className = 'buscable-vacio';
        vacio.textContent = tipo === 'cliente' ? 'No se encontraron clientes.' : 'No se encontraron vehículos.';
        contenedor.appendChild(vacio);
        return;
    }

    const seleccionActual = tipo === 'cliente' ? clienteSeleccionado : vehiculoSeleccionado;

    items.forEach(item => {
        const fila = document.createElement('div');
        fila.className = 'buscable-item' + (seleccionActual && seleccionActual.id === item.id ? ' seleccionado' : '');

        const nombre = document.createElement('span');
        nombre.textContent = item.nombre;
        fila.appendChild(nombre);

        if (tipo === 'vehiculo') {
            const precio = document.createElement('span');
            precio.textContent = '$' + Number(item.precio).toLocaleString('es-MX');
            fila.appendChild(precio);
        }

        fila.addEventListener('click', () => seleccionar(tipo, item));
        contenedor.appendChild(fila);
    });
}

function seleccionar(tipo, item) {
    if (tipo === 'cliente') {
        clienteSeleccionado = item;
        document.getElementById('clienteSeleccionadoTxt').textContent = `Seleccionado: ${item.nombre}`;
        document.getElementById('errorCliente').textContent = '';
        renderBuscador('cliente', filtrarLocal(CLIENTES_ASESOR, document.getElementById('buscarCliente').value), '');
    } else {
        vehiculoSeleccionado = item;
        document.getElementById('vehiculoSeleccionadoTxt').textContent = `Seleccionado: ${item.nombre}`;
        document.getElementById('errorVehiculo').textContent = '';
        renderBuscador('vehiculo', filtrarLocal(VEHICULOS_DISPONIBLES, document.getElementById('buscarVehiculo').value), '');
    }
    calcularTotal();
}

function filtrarLocal(datos, texto) {
    const t = (texto || '').trim().toLowerCase();
    return datos.filter(item => item.nombre.toLowerCase().includes(t));
}

// -------------------------------
// Buscador de Servicios (selección múltiple, checkboxes)
// -------------------------------
function renderServicios(texto) {
    const contenedor = document.getElementById('listaServicios');
    contenedor.innerHTML = '';

    const t = (texto || '').trim().toLowerCase();
    const filtrados = SERVICIOS_ACTIVOS.filter(s => s.nombre.toLowerCase().includes(t));

    if (filtrados.length === 0) {
        const vacio = document.createElement('p');
        vacio.className = 'buscable-vacio';
        vacio.textContent = 'No se encontraron servicios.';
        contenedor.appendChild(vacio);
        return;
    }

    filtrados.forEach(s => {
        const label = document.createElement('label');
        label.className = 'cotizacion-servicio-item';

        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.className = 'cotizacion-servicio-checkbox';
        checkbox.value = s.id;
        checkbox.checked = serviciosSeleccionados.has(s.id);
        checkbox.addEventListener('change', () => {
            if (checkbox.checked) serviciosSeleccionados.add(s.id);
            else serviciosSeleccionados.delete(s.id);
            calcularTotal();
        });

        const nombre = document.createElement('span');
        nombre.className = 'cotizacion-servicio-nombre';
        nombre.textContent = s.nombre;

        const tipo = document.createElement('span');
        tipo.className = 'cotizacion-servicio-tipo';
        tipo.textContent = s.tipo;

        const precio = document.createElement('span');
        precio.className = 'cotizacion-servicio-precio';
        precio.textContent = '$' + Number(s.precio).toLocaleString('es-MX');

        label.appendChild(checkbox);
        label.appendChild(nombre);
        label.appendChild(tipo);
        label.appendChild(precio);
        contenedor.appendChild(label);
    });
}

// -------------------------------
// Total estimado
// -------------------------------
function calcularTotal() {
    let total = vehiculoSeleccionado ? Number(vehiculoSeleccionado.precio) || 0 : 0;

    serviciosSeleccionados.forEach(id => {
        const servicio = SERVICIOS_ACTIVOS.find(s => s.id === id);
        if (servicio) total += Number(servicio.precio) || 0;
    });

    document.getElementById('cotizacionTotal').textContent = '$' + total.toLocaleString('es-MX');
}

// -------------------------------
// Registrar (misma lógica que la cotización rápida del dashboard)
// -------------------------------
document.getElementById('btnRegistrarVenta').addEventListener('click', async function () {
    const errorCotizacion = document.getElementById('errorCotizacion');
    const exitoCotizacion = document.getElementById('exitoCotizacion');
    errorCotizacion.textContent = '';
    exitoCotizacion.textContent = '';

    let valido = true;
    if (!clienteSeleccionado) {
        document.getElementById('errorCliente').textContent = 'Selecciona un cliente.';
        valido = false;
    }
    if (!vehiculoSeleccionado) {
        document.getElementById('errorVehiculo').textContent = 'Selecciona un vehículo.';
        valido = false;
    }
    if (!valido) return;

    const datos = new URLSearchParams();
    datos.append('idCliente', clienteSeleccionado.id);
    datos.append('idVehiculo', vehiculoSeleccionado.id);
    serviciosSeleccionados.forEach(id => datos.append('idsServicios', id));

    try {
        const respuesta = await fetch(`${CONTEXT_PATH}/registrarVentaAsesor`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: datos.toString()
        });

        if (respuesta.ok) {
            const comprobante = await respuesta.json();
            cerrarModal('modalCotizacion');
            mostrarComprobanteVenta(comprobante, () => window.location.reload());
        } else {
            errorCotizacion.textContent = (await respuesta.text()).trim();
        }
    } catch (err) {
        errorCotizacion.textContent = 'No se pudo contactar al servidor. Intenta de nuevo.';
    }
});

// -------------------------------
// Tabla: filtrado y paginación
// -------------------------------
const REGISTROS_POR_PAGINA = 8;
let paginaActual = 1;

function obtenerFilas() {
    return Array.from(document.querySelectorAll('#tabla tbody tr')).filter(tr => !tr.classList.contains('fila-vacia'));
}

function totalPaginas() {
    return Math.max(1, Math.ceil(obtenerFilas().length / REGISTROS_POR_PAGINA));
}

function mostrarPagina(pagina) {
    const filas = obtenerFilas();
    const totalPag = totalPaginas();

    if (pagina > totalPag) pagina = totalPag;
    if (pagina < 1) pagina = 1;
    paginaActual = pagina;

    const inicio = (pagina - 1) * REGISTROS_POR_PAGINA;
    const fin = inicio + REGISTROS_POR_PAGINA;

    filas.forEach((fila, index) => {
        fila.style.display = (index >= inicio && index < fin) ? '' : 'none';
    });

    renderPaginacion();
}

function renderPaginacion() {
    const contenedor = document.getElementById('paginacion');
    if (!contenedor) return;

    const totalPag = totalPaginas();
    contenedor.innerHTML = '';
    if (totalPag <= 1 || obtenerFilas().length === 0) return;

    const btnAnterior = document.createElement('button');
    btnAnterior.textContent = '‹ Anterior';
    btnAnterior.className = 'btn-pagina';
    btnAnterior.disabled = paginaActual === 1;
    btnAnterior.onclick = () => mostrarPagina(paginaActual - 1);
    contenedor.appendChild(btnAnterior);

    for (let i = 1; i <= totalPag; i++) {
        const btn = document.createElement('button');
        btn.textContent = i;
        btn.className = 'btn-pagina' + (i === paginaActual ? ' activo' : '');
        btn.onclick = () => mostrarPagina(i);
        contenedor.appendChild(btn);
    }

    const btnSiguiente = document.createElement('button');
    btnSiguiente.textContent = 'Siguiente ›';
    btnSiguiente.className = 'btn-pagina';
    btnSiguiente.disabled = paginaActual === totalPag;
    btnSiguiente.onclick = () => mostrarPagina(paginaActual + 1);
    contenedor.appendChild(btnSiguiente);
}

function filtrarTabla(texto) {
    const filas = obtenerFilas();
    texto = texto.toLowerCase();

    if (texto === '') {
        mostrarPagina(1);
        return;
    }

    const contenedor = document.getElementById('paginacion');
    if (contenedor) contenedor.innerHTML = '';

    filas.forEach(fila => {
        fila.style.display = fila.textContent.toLowerCase().includes(texto) ? '' : 'none';
    });
}

document.addEventListener('DOMContentLoaded', () => mostrarPagina(1));
