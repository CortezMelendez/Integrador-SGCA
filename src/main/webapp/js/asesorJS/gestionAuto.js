
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
    function abrirEditar(nombre, tipo, precio, dur, estado) {
      document.getElementById('edit-nombre').value = nombre;
      document.getElementById('edit-precio').value = precio;
      document.getElementById('edit-dur').value = dur;
      
      ['edit-tipo','edit-estado'].forEach(id => {
        const sel = document.getElementById(id);
        const val = id === 'edit-tipo' ? tipo : estado;
        [...sel.options].forEach(o => o.selected = o.value === val);
      });
      abrirModal('modalEditar');
    }

    // Función de filtrado en la tabla
    function filtrar(texto) {
      document.querySelectorAll('#tabla tbody tr').forEach(tr => {
        tr.style.display = tr.textContent.toLowerCase().includes(texto.toLowerCase()) ? '' : 'none';
      });
    }

    // Función para alternar estado Activo/Inactivo (Click en Badge)
    function toggleEstado(elemento) {
      if (elemento.classList.contains('badge-inactive')) {
        elemento.classList.remove('badge-inactive');
        elemento.classList.add('badge-active');
        elemento.textContent = 'Activo';
      } else if (elemento.classList.contains('badge-active')) {
        elemento.classList.remove('badge-active');
        elemento.classList.add('badge-inactive');
        elemento.textContent = 'Inactivo';
      }
    }
  
document.addEventListener('DOMContentLoaded', () => {
  const btnRegistrar = document.getElementById('btn-registrar');
  const submenu = document.getElementById('submenu-registrar');
  const btnCerrar = document.getElementById('btn-cerrar');
  const contenedor = document.getElementById('contenedor-registrar');

  // Validamos que los elementos existan para evitar errores en consola
  if (btnRegistrar && submenu && contenedor) {
    
    // 1. Mostrar el menú al hacer clic en "Registrar"
    btnRegistrar.addEventListener('click', (e) => {
      e.preventDefault(); // Evita comportamientos raros del botón
      submenu.classList.remove('oculto');
    });

    // 2. Ocultar el menú al hacer clic en la "X"
    if (btnCerrar) {
      btnCerrar.addEventListener('click', (e) => {
        e.preventDefault();
        submenu.classList.add('oculto');
      });
    }

    // 3. Ocultar el menú automáticamente cuando el cursor SALE del contenedor
    contenedor.addEventListener('mouseleave', () => {
      submenu.classList.add('oculto');
    });
    
  } else {
    console.error("Falta un ID en el HTML. Revisa que estén: btn-registrar, submenu-registrar y contenedor-registrar.");
  }
});
  