<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Gestión de Empleados — Concesionaria Automotriz</title>
  <!-- Asegúrate de que las rutas a tus CSS sean correctas -->
     <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&family=Google+Sans+Code:ital,wght@1,300..800&display=swap" rel="stylesheet">

   <link rel="stylesheet" href="../../css/duenioStyles/styles.css">
  <link rel="stylesheet" href="../../css/duenioStyles/gestiones.css" />
  <link rel="stylesheet" href="../../css/duenioStyles/responsive.css" />
</head>
<body>

  <!-- =============================================
       NAVBAR (BARRA DE NAVEGACIÓN)
  ============================================= -->
  <header class="dash-navbar">
    <div class="dash-navbar-left">
      <div class="dash-logo-placeholder" aria-hidden="true">
        <img src="../../Images/logo2-SGCA.svg" class="logo-img" width="108" />
      </div>
      <span class="dash-brand">Concesionaria Automotriz</span>
    </div>
    <nav class="dash-nav-center">
        <a href="index.html" class="dash-nav-link">Inicio</a>
      <a href="../../pages/duenioPages/dashboard.html" class="dash-nav-link">Dashboard</a>
      <a href="" class="dash-nav-link">Servicios</a>
      <a href="" class="dash-nav-link ">Perfil</a>
    </nav>
    <div class="dash-navbar-right">
      <div class="dash-user">
        <div class="dash-user-info">
          <span class="dash-user-name" id="userName"></span>
          <span class="dash-user-role" id="userRole"></span>
        </div>
      </div>
    </div>
  </header>

  <!-- =============================================
       CONTENIDO PRINCIPAL
  ============================================= -->
  <main class="dash-main">

    <div class="gest-header">
      <div class="gest-header-left">
        <h1>Gestión de empleados</h1>
        <p>Administra los empleados registrados.</p>
      </div>

      <!-- Buscador -->


      <button class="btn-agregar" onclick="abrirModal('modalAgregar')">+ Agregar empleado</button>
    </div>
<div class="gest-search-inline">
        <input class="gest-input" type="text" placeholder="Buscar empleado..." oninput="filtrar(this.value)" />
        <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
      </div>
    <!-- =============================================
         TABLA DE DATOS
    ============================================= -->
    <div class="table-card">
      <div class="table-wrapper">
        <table class="gest-table" id="tabla">
          <thead>
            <tr>
              <th>Fecha</th>
              <th>Nombre</th>
              <th>RFC</th>
              <th>Telefono</th>
              <th>Curp</th>
              <th>Estado</th>
              <th>Correo</th>

            </tr>
          </thead>
          <tbody>
            <!-- Las filas se generan dinámicamente desde la base de datos -->
          </tbody>
        </table>
      </div>
    </div>

  </main>

  <!-- =============================================
       FOOTER
  ============================================= -->
  <footer class="footer" style="display: flex; justify-content: space-between; align-items: center; padding: 20px; background-color: #000;">
    <span style="color: rgb(8, 8, 8); font-size: 0.85rem;">© 2026 SGCA · Todos los derechos reservados</span>
    <a href="../../pages/duenioPages/dashboard.html" class="btn-atras" style="color: black; text-decoration: none; display: flex; align-items: center; gap: 8px; background: #CCCCCC; padding: 8px 16px; border-radius: 20px;">
      <img src="../../Images/back.svg" alt="">
      Atrás
    </a>
  </footer>

  <!-- =============================================
       MODALES
  ============================================= -->
  <!-- Modal Agregar -->
  <div class="modal-overlay" id="modalAgregar" onclick="cerrarOverlay(event,'modalAgregar')">
    <div class="modal-box">
      <h2 class="modal-title">Agregar empleado</h2>
      <div class="modal-field">
        <label class="modal-label">Nombre completo</label>
        <input class="modal-input" type="text" id="mod-nombre" placeholder="Ej. Juan Pérez López" />
      </div>
      <div class="modal-row">
        <div class="modal-field">
          <label class="modal-label">RFC</label>
          <input class="modal-input" type="text" id="mod-rfc" placeholder="Ej. PELJ900101AB1" />
        </div>
        <div class="modal-field">
          <label class="modal-label">Teléfono</label>
          <input class="modal-input" type="text" id="mod-telefono" placeholder="Ej. 7771234567" />
        </div>
      </div>
      <div class="modal-row">
        <div class="modal-field">
          <label class="modal-label">CURP</label>
          <input class="modal-input" type="text" id="mod-curp" placeholder="Ej. PELJ900101HMLRPN01" />
        </div>
        <div class="modal-field">
          <label class="modal-label">Estado</label>
          <select class="modal-select" id="mod-estado">
            <option>Activo</option>
            <option>Inactivo</option>
          </select>
        </div>
      </div>
      <div class="modal-field">
        <label class="modal-label">Correo</label>
        <input class="modal-input" type="email" id="mod-correo" placeholder="Ej. correo@ejemplo.com" />
      </div>
      <div class="modal-field">

      </div>

      <div class="modal-actions">
        <button class="btn-modal-cancel" onclick="cerrarModal('modalAgregar')">Cancelar</button>
        <button class="btn-modal-save" onclick="agregarRegistro()">Guardar</button>
      </div>
    </div>
  </div>


  <!-- =============================================
       SCRIPTS JAVASCRIPT
  ============================================= -->
  <script>
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
  </script>
  <script src="js/gestionEmpleado.js"></script>
</body>
</html>