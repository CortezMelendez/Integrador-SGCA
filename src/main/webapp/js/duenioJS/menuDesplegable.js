/* =============================================
   dashboard.js — menú desplegable del botón "Gestión"
============================================= */

document.addEventListener('DOMContentLoaded', () => {
  const gestionWrapper = document.getElementById('dashGestion');
  const btnGestion      = document.getElementById('btnGestion');
  const gestionMenu     = document.getElementById('gestionMenu');

  function openMenu() {
    gestionWrapper.classList.add('open');
    btnGestion.setAttribute('aria-expanded', 'true');
  }

  function closeMenu() {
    gestionWrapper.classList.remove('open');
    btnGestion.setAttribute('aria-expanded', 'false');
  }

  function toggleMenu() {
    if (gestionWrapper.classList.contains('open')) {
      closeMenu();
    } else {
      openMenu();
    }
  }

  btnGestion.addEventListener('click', (event) => {
    event.stopPropagation();
    toggleMenu();
  });

  // Cerrar al hacer clic fuera del menú
  document.addEventListener('click', (event) => {
    if (!gestionWrapper.contains(event.target)) {
      closeMenu();
    }
  });

  // Cerrar con la tecla Escape
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      closeMenu();
      btnGestion.focus();
    }
  });

  // Cerrar al seleccionar una opción
  gestionMenu.querySelectorAll('.gestion-menu-item').forEach((item) => {
    item.addEventListener('click', closeMenu);
  });
});