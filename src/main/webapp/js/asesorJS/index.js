const btnRegistrar = document.getElementById('btn-registrar');
const submenu = document.getElementById('submenu-registrar');
const btnCerrar = document.getElementById('btn-cerrar');
const contenedor = document.getElementById('contenedor-registrar');

// 1. Mostrar el menú al hacer clic en "Registrar"
btnRegistrar.addEventListener('click', () => {
  submenu.classList.remove('oculto');
});

// 2. Ocultar el menú al hacer clic en la "X"
btnCerrar.addEventListener('click', () => {
  submenu.classList.add('oculto');
});

// 3. Ocultar el menú automáticamente cuando el cursor SALE del contenedor
contenedor.addEventListener('mouseleave', () => {
  submenu.classList.add('oculto');
});