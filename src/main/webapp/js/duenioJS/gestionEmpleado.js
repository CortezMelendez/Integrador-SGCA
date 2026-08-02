

const REGISTROS_POR_PAGINA = 5;
let paginaActual = 1;

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

  // Ajustar página si quedó fuera de rango (ej. al borrar registros)
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

  // Si no existe el contenedor en el HTML, lo creamos después de la tabla
  if (!contenedor) {
    contenedor = document.createElement('div');
    contenedor.id = 'paginacion';
    contenedor.className = 'paginacion';
    document.querySelector('.table-card').appendChild(contenedor);
  }

  const totalPag = totalPaginas();
  contenedor.innerHTML = '';

  // Si solo hay una página, no se muestran controles
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

// -------------------------------
// Agregar registro desde el modal
// -------------------------------
function agregarRegistro() {
  const nombre = document.getElementById('mod-nombre').value.trim();
  const rfc = document.getElementById('mod-rfc').value.trim();
  const telefono = document.getElementById('mod-telefono').value.trim();
  const curp = document.getElementById('mod-curp').value.trim();
  const estado = document.getElementById('mod-estado').value;
  const correo = document.getElementById('mod-correo').value.trim();

  if (!nombre || !rfc || !telefono || !curp || !correo) {
    alert('Por favor completa todos los campos.');
    return;
  }

  const claseBadge = estado === 'Activo' ? 'badge-active' : 'badge-inactive';

  const tr = document.createElement('tr');
  tr.innerHTML = `
    <td>${nombre}</td>
    <td>${rfc}</td>
    <td>${telefono}</td>
    <td>${curp}</td>
    <td><span class="badge ${claseBadge}" onclick="eliminarFila(this)">${estado}</span></td>
    <td>${correo}</td>
  `;

  document.querySelector('#tabla tbody').appendChild(tr);

  // Limpiar el formulario del modal
  document.getElementById('mod-nombre').value = '';
  document.getElementById('mod-rfc').value = '';
  document.getElementById('mod-telefono').value = '';
  document.getElementById('mod-curp').value = '';
  document.getElementById('mod-correo').value = '';
  document.getElementById('mod-estado').selectedIndex = 0;

  cerrarModal('modalAgregar');
  mostrarPagina(totalPaginas()); // ir a la última página donde quedó el nuevo registro
}

// -------------------------------
// Eliminar fila al hacer click en el badge
// -------------------------------
function eliminarFila(elemento) {
  const confirmar = confirm('¿Deseas eliminar este registro?');
  if (!confirmar) return;

  const fila = elemento.closest('tr');
  fila.remove();
  mostrarPagina(paginaActual);
}

// -------------------------------
// Filtro de búsqueda (respeta la paginación)
// -------------------------------
function filtrar(texto) {
  const filas = obtenerFilas();
  texto = texto.toLowerCase();

  if (texto === '') {
    mostrarPagina(1);
    return;
  }

  // Mientras se busca, se ignora la paginación y se muestran todas las coincidencias
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
  mostrarPagina(1);
});