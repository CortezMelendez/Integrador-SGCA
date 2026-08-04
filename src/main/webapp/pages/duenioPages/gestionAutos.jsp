<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Gestión de Autos — Concesionaria Automotriz</title>

     <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wght@100..900&family=Google+Sans+Code:wght@300..800&family=Google+Sans+Code:ital,wght@1,300..800&display=swap" rel="stylesheet">

   <link rel="stylesheet" href="../..//css/duenioStyles/styles.css">
  <link rel="stylesheet" href="../..//css/duenioStyles/gestiones.css" />
  <link rel="stylesheet" href="../..//css/duenioStyles/gestiones-extra.css" />
    <link rel="stylesheet" href="../..//css/duenioStyles/responsive.css">
</head>
<body>

  <!-- BARRA DE NAVEGACIÓN -->
  <header class="dash-navbar">
    <div class="dash-navbar-left">
      <div class="dash-logo-placeholder" aria-hidden="true">
        <img src="../..//Images/logo2-SGCA.svg" class="logo-img" width="108" />
      </div>
      <span class="dash-brand">Concesionaria Automotriz</span>
    </div>
    <nav class="dash-nav-center">
        <a href="index.jsp" class="dash-nav-link">Inicio</a>
      <a href="../../pages/duenioPages/dashboard.jsp" class="dash-nav-link">Dashboard</a>
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

  <!-- CONTENIDO PRINCIPAL-->
  <main class="dash-main">

    <div class="gest-header">
      <div class="gest-header-left">
        <h1>Gestión de servicios</h1>
        <p>Administra el inventario de autos registrados.</p>
      </div>

      <!-- Buscador -->

      <button class="btn-agregar" onclick="abrirModal('modalAgregar')">+ Agregar auto</button>
    </div>
<div class="gest-search-inline">
        <input class="gest-input" type="text" placeholder="Buscar auto..." oninput="filtrar(this.value)" />
        <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
      </div>

    <!--  TABLA DE DATOS -->
    <div class="table-card">
      <div class="table-wrapper">
        <table class="gest-table" id="tabla">
          <thead>
            <tr>
              <th>Marca</th>
              <th>Modelo</th>
              <th>Categoria</th>
              <th>Precio</th>
              <th>Placa</th>
              <th>Año</th>
              <th>Estado</th>
              <th>Fecha</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <!-- Las filas se generan dinámicamente desde la base de datos -->
          </tbody>
        </table>
      </div>
    </div>

  </main>

  <!-- FOOTER -->
  <footer class="footer" style="display: flex; justify-content: space-between; align-items: center; padding: 20px; background-color: #000;">
    <span style="color: rgb(8, 8, 8); font-size: 0.85rem;">© 2026 SGCA · Todos los derechos reservados</span>
    <a href="../../pages/duenioPages/dashboard.jsp" class="btn-atras" style="color: black; text-decoration: none; display: flex; align-items: center; gap: 8px; background: #CCCCCC; padding: 8px 16px; border-radius: 20px;">
      <img src="../..//Images/back.svg" alt="">
      Atrás
    </a>
  </footer>


  <!-- Ventana emergente agregar-->
  <div class="modal-overlay" id="modalAgregar" onclick="cerrarOverlay(event,'modalAgregar')">
    <div class="modal-box" onclick="event.stopPropagation()">
      <h2 class="modal-title">Agregar auto</h2>
      <div class="modal-row">
        <div class="modal-field">
          <label class="modal-label">Marca *</label>
          <input class="modal-input" id="mod-marca" type="text" placeholder="Ej. Toyota" />
          <span class="modal-error" id="err-marca"></span>
        </div>
        <div class="modal-field">
          <label class="modal-label">Modelo *</label>
          <input class="modal-input" id="mod-modelo" type="text" placeholder="Ej. Corolla" />
          <span class="modal-error" id="err-modelo"></span>
        </div>
      </div>
      <div class="modal-row">
        <div class="modal-field">
          <label class="modal-label">Categoría *</label>
          <select class="modal-select" id="mod-categoria">
            <option value="">Selecciona...</option>
            <option>Sedán</option>
            <option>SUV</option>
            <option>Pickup</option>
            <option>Hatchback</option>
            <option>Deportivo</option>
          </select>
          <span class="modal-error" id="err-categoria"></span>
        </div>
        <div class="modal-field">
          <label class="modal-label">Precio ($) *</label>
          <input class="modal-input" id="mod-precio" type="number" min="0" step="0.01" placeholder="0.00" />
          <span class="modal-error" id="err-precio"></span>
        </div>
      </div>
      <div class="modal-row">
        <div class="modal-field">
          <label class="modal-label">Placa *</label>
          <input class="modal-input" id="mod-placa" type="text" placeholder="Ej. ABC-123-A" />
          <span class="modal-error" id="err-placa"></span>
        </div>
        <div class="modal-field">
          <label class="modal-label">Año *</label>
          <input class="modal-input" id="mod-anio" type="number" min="1980" max="2100" placeholder="Ej. 2024" />
          <span class="modal-error" id="err-anio"></span>
        </div>
      </div>
      <div class="modal-field">
        <label class="modal-label">Estado</label>
        <select class="modal-select" id="mod-estado">
          <option>Activo</option>
          <option>Inactivo</option>
        </select>
      </div>
      <div class="modal-actions">
        <button class="btn-modal-cancel" onclick="cerrarModal('modalAgregar')">Cancelar</button>
        <button class="btn-modal-save" onclick="agregarRegistro()">Guardar</button>
      </div>
    </div>
  </div>

  <!-- ventana emergente Editar -->
  <div class="modal-overlay" id="modalEditar" onclick="cerrarOverlay(event,'modalEditar')">
    <div class="modal-box" onclick="event.stopPropagation()">
      <h2 class="modal-title">Editar auto</h2>
      <input type="hidden" id="edit-id" />
      <div class="modal-row">
        <div class="modal-field">
          <label class="modal-label">Marca *</label>
          <input class="modal-input" id="edit-marca" type="text" />
          <span class="modal-error" id="edit-err-marca"></span>
        </div>
        <div class="modal-field">
          <label class="modal-label">Modelo *</label>
          <input class="modal-input" id="edit-modelo" type="text" />
          <span class="modal-error" id="edit-err-modelo"></span>
        </div>
      </div>
      <div class="modal-row">
        <div class="modal-field">
          <label class="modal-label">Categoría *</label>
          <select class="modal-select" id="edit-categoria">
            <option value="">Selecciona...</option>
            <option>Sedán</option>
            <option>SUV</option>
            <option>Pickup</option>
            <option>Hatchback</option>
            <option>Deportivo</option>
          </select>
          <span class="modal-error" id="edit-err-categoria"></span>
        </div>
        <div class="modal-field">
          <label class="modal-label">Precio ($) *</label>
          <input class="modal-input" id="edit-precio" type="number" min="0" step="0.01" />
          <span class="modal-error" id="edit-err-precio"></span>
        </div>
      </div>
      <div class="modal-row">
        <div class="modal-field">
          <label class="modal-label">Placa *</label>
          <input class="modal-input" id="edit-placa" type="text" />
          <span class="modal-error" id="edit-err-placa"></span>
        </div>
        <div class="modal-field">
          <label class="modal-label">Año *</label>
          <input class="modal-input" id="edit-anio" type="number" min="1980" max="2100" />
          <span class="modal-error" id="edit-err-anio"></span>
        </div>
      </div>
      <div class="modal-field">
        <label class="modal-label">Estado</label>
        <select class="modal-select" id="edit-estado">
          <option>Activo</option>
          <option>Inactivo</option>
        </select>
      </div>
      <div class="modal-actions">
        <button class="btn-modal-cancel" onclick="cerrarModal('modalEditar')">Cancelar</button>
        <button class="btn-modal-save" onclick="guardarEdicion()">Guardar cambios</button>
      </div>
    </div>
  </div>
<script src="../../js/duenioJS/gestionAutos.js"></script>
</body>
</html>