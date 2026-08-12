// ==========================================================
// Gestión de Clientes — validación, modales y tabla (datos reales de BD)
// ==========================================================

const CONTEXT_PATH = (() => {
  const partes = window.location.pathname.split('/');
  return partes.length > 1 ? '/' + partes[1] : '';
})();

const REGISTROS_POR_PAGINA = 8;
let paginaActual = 1;

// -------------------------------
// Expresiones regulares de validación
// -------------------------------
const RE_NOMBRE = /^[A-Za-zÀ-ÖØ-öø-ÿ\s]{2,40}$/;
const RE_RFC = /^[A-ZÑ&]{4}\d{6}[A-Z0-9]{3}$/;
const RE_TELEFONO = /^\d{10}$/;
const RE_CURP = /^[A-Z]{4}\d{6}[HM][A-Z]{5}[A-Z0-9]\d$/;
const RE_CORREO = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// -------------------------------
// Modal
// -------------------------------
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
    cerrarModal('modalAsesor');
  }
});

// -------------------------------
// Modal de confirmación (reemplaza confirm() del navegador)
// -------------------------------
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

// Eliminar cliente (icono de la tabla)
function confirmarEliminarUsuario(id) {
  pedirConfirmacion('¿Deseas eliminar este cliente? Esta acción no se puede deshacer.', () => {
    window.location.href = `${CONTEXT_PATH}/gestionUsuarios?accion=eliminar&id=${id}&idRol=3`;
  }, 'peligro');
}

// Guardar cambios del modal Editar
function confirmarGuardarEdicion() {
  if (!validarYPrepararEnvio('edit')) return;
  pedirConfirmacion('¿Deseas guardar los cambios de este cliente?', () => {
    document.getElementById('formEditar').submit();
  });
}

function resetearModalAgregar() {
  document.getElementById('formAgregar').reset();
  limpiarErrores('mod');
}

// -------------------------------
// Sanitización en vivo (bloquea caracteres no permitidos mientras se escribe)
// -------------------------------
function sanearMientrasEscribe() {
  ['mod-nombre', 'edit-nombre', 'mod-apellidoPaterno', 'edit-apellidoPaterno', 'mod-apellidoMaterno', 'edit-apellidoMaterno'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.addEventListener('input', () => {
      el.value = el.value.replace(/[^A-Za-zÀ-ÖØ-öø-ÿ\s]/g, '');
    });
  });

  ['mod-telefono', 'edit-telefono'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.addEventListener('input', () => {
      el.value = el.value.replace(/\D/g, '').slice(0, 10);
    });
  });

  ['mod-rfc', 'edit-rfc'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.addEventListener('input', () => {
      el.value = el.value.toUpperCase().replace(/[^A-Z0-9Ñ&]/g, '').slice(0, 13);
    });
  });

  ['mod-curp', 'edit-curp'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.addEventListener('input', () => {
      el.value = el.value.toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 18);
    });
  });
}

// -------------------------------
// Validación de campos
// -------------------------------
function limpiarErrores(prefijo) {
  const errPrefix = prefijo === 'mod' ? 'err-' : 'edit-err-';
  document.querySelectorAll(`[id^="${errPrefix}"]`).forEach(el => el.textContent = '');
}

function obtenerDatos(prefijo) {
  const val = id => {
    const el = document.getElementById(id);
    return el ? el.value.trim() : '';
  };
  return {
    nombre: val(`${prefijo}-nombre`),
    apellidoPaterno: val(`${prefijo}-apellidoPaterno`),
    apellidoMaterno: val(`${prefijo}-apellidoMaterno`),
    rfc: val(`${prefijo}-rfc`).toUpperCase(),
    telefono: val(`${prefijo}-telefono`),
    curp: val(`${prefijo}-curp`).toUpperCase(),
    correo: val(`${prefijo}-correo`),
    password: prefijo === 'mod' ? val('mod-password') : null
  };
}

function validarDatos(prefijo, datos) {
  limpiarErrores(prefijo);
  const errPrefix = prefijo === 'mod' ? 'err-' : 'edit-err-';
  let valido = true;

  const marcarError = (campo, mensaje) => {
    const el = document.getElementById(errPrefix + campo);
    if (el) el.textContent = mensaje;
    valido = false;
  };

  if (!datos.nombre) {
    marcarError('nombre', 'El nombre es obligatorio.');
  } else if (!RE_NOMBRE.test(datos.nombre)) {
    marcarError('nombre', 'Solo se permiten letras y espacios.');
  }

  if (!datos.apellidoPaterno) {
    marcarError('apellidoPaterno', 'El apellido paterno es obligatorio.');
  } else if (!RE_NOMBRE.test(datos.apellidoPaterno)) {
    marcarError('apellidoPaterno', 'Solo se permiten letras y espacios.');
  }

  if (datos.apellidoMaterno && !RE_NOMBRE.test(datos.apellidoMaterno)) {
    marcarError('apellidoMaterno', 'Solo se permiten letras y espacios.');
  }

  if (!datos.rfc) {
    marcarError('rfc', 'El RFC es obligatorio.');
  } else if (!RE_RFC.test(datos.rfc)) {
    marcarError('rfc', 'RFC inválido. Formato: 4 letras + 6 dígitos + 3 caracteres.');
  }

  if (!datos.telefono) {
    marcarError('telefono', 'El teléfono es obligatorio.');
  } else if (!RE_TELEFONO.test(datos.telefono)) {
    marcarError('telefono', 'El teléfono debe tener exactamente 10 dígitos.');
  }

  if (!datos.curp) {
    marcarError('curp', 'El CURP es obligatorio.');
  } else if (!RE_CURP.test(datos.curp)) {
    marcarError('curp', 'CURP inválido. Debe tener 18 caracteres válidos.');
  }

  if (!datos.correo) {
    marcarError('correo', 'El correo es obligatorio.');
  } else if (!RE_CORREO.test(datos.correo)) {
    marcarError('correo', 'Ingresa un correo electrónico válido.');
  }

  if (prefijo === 'mod') {
    if (!datos.password) {
      marcarError('password', 'La contraseña es obligatoria.');
    } else if (datos.password.length < 8) {
      marcarError('password', 'Debe tener al menos 8 caracteres.');
    }
  }

  return valido;
}

// Se ejecuta en el onsubmit de los formularios reales (formAgregar / formEditar).
// Si retorna false, el navegador NO envía el formulario (evita el POST con datos inválidos).
function validarYPrepararEnvio(prefijo) {
  const datos = obtenerDatos(prefijo);
  return validarDatos(prefijo, datos);
}

// -------------------------------
// Editar: precarga los datos reales que vienen del servidor
// -------------------------------
function abrirEditar(id, nombre, apellidoPaterno, apellidoMaterno, rfc, telefono, curp, correo, estado) {
  document.getElementById('edit-id').value = id;
  document.getElementById('edit-nombre').value = nombre;
  document.getElementById('edit-apellidoPaterno').value = apellidoPaterno;
  document.getElementById('edit-apellidoMaterno').value = apellidoMaterno;
  document.getElementById('edit-rfc').value = rfc;
  document.getElementById('edit-telefono').value = telefono;
  document.getElementById('edit-curp').value = curp;
  document.getElementById('edit-correo').value = correo;

  const sel = document.getElementById('edit-estado');
  [...sel.options].forEach(o => o.selected = o.value === estado);

  limpiarErrores('edit');
  abrirModal('modalEditar');
}

// -------------------------------
// Estado Activo/Inactivo (click en badge) — se persiste en la BD
// -------------------------------
function toggleEstado(elemento, idUsuario) {
  const activo = elemento.classList.contains('badge-active');
  const nuevoEstado = activo ? 0 : 1;

  elemento.classList.toggle('badge-inactive');
  elemento.classList.toggle('badge-active');
  elemento.textContent = nuevoEstado === 1 ? 'Activo' : 'Inactivo';

  fetch(`${CONTEXT_PATH}/gestionUsuarios?accion=cambiarEstado&id=${idUsuario}&estado=${nuevoEstado}&idRol=3`)
    .catch(err => console.error('No se pudo actualizar el estado:', err));
}

// -------------------------------
// Modal Asignar Asesor (columna "Asesor" de la tabla)
// -------------------------------
let _asesorBtnActual = null;

function abrirModalAsesor(boton, idCliente, idAgenteActual) {
  _asesorBtnActual = boton;
  document.getElementById('asesor-idCliente').value = idCliente;

  const sel = document.getElementById('asesor-select');
  sel.value = idAgenteActual ? String(idAgenteActual) : '';

  document.getElementById('err-asesor').textContent = '';
  abrirModal('modalAsesor');
}

function guardarAsesor() {
  const idCliente = document.getElementById('asesor-idCliente').value;
  const sel = document.getElementById('asesor-select');
  const idAgente = sel.value;
  const nombreAsesor = sel.options[sel.selectedIndex].text;

  fetch(`${CONTEXT_PATH}/agentes`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest'
    },
    body: `accion=reasignarManual&idCliente=${encodeURIComponent(idCliente)}&idAgente=${encodeURIComponent(idAgente)}`
  })
    .then(res => {
      if (!res.ok) throw new Error('No se pudo asignar el asesor. Intenta de nuevo.');
      return res.text();
    })
    .then(() => {
      if (_asesorBtnActual) {
        _asesorBtnActual.setAttribute('onclick', `abrirModalAsesor(this, ${idCliente}, ${idAgente || 0})`);
        _asesorBtnActual.innerHTML = idAgente
          ? nombreAsesor
          : '<span class="asesor-sin-asignar">Sin asesor asignado</span>';
      }
      cerrarModal('modalAsesor');
    })
    .catch(err => {
      document.getElementById('err-asesor').textContent = err.message;
    });
}

// -------------------------------
// Tabla: filtrado y paginación (sobre las filas ya renderizadas por el servidor)
// -------------------------------
function obtenerFilas() {
  return Array.from(document.querySelectorAll('#tabla tbody tr'));
}

function totalPaginas() {
  const filas = obtenerFilas();
  return Math.max(1, Math.ceil(filas.length / REGISTROS_POR_PAGINA));
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
  let contenedor = document.getElementById('paginacion');
  if (!contenedor) {
    contenedor = document.createElement('div');
    contenedor.id = 'paginacion';
    contenedor.className = 'paginacion';
    document.querySelector('.table-card').appendChild(contenedor);
  }

  const totalPag = totalPaginas();
  contenedor.innerHTML = '';
  if (totalPag <= 1) return;

  const btnAnterior = document.createElement('button');
  btnAnterior.textContent = '←';
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
  btnSiguiente.textContent = '→';
  btnSiguiente.className = 'btn-pagina';
  btnSiguiente.disabled = paginaActual === totalPag;
  btnSiguiente.onclick = () => mostrarPagina(paginaActual + 1);
  contenedor.appendChild(btnSiguiente);
}

function filtrar(texto) {
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

// -------------------------------
// Inicialización
// -------------------------------
document.addEventListener('DOMContentLoaded', () => {
  sanearMientrasEscribe();
  mostrarPagina(1);
});
