// =============================================================
// carrusel.js
// Controla el carrusel de vehículos en index.html:
// - Botones de flecha (anterior / siguiente)
// - Barra de desplazamiento personalizada sincronizada con el scroll
// =============================================================

document.addEventListener('DOMContentLoaded', () => {
  const track = document.getElementById('carruselTrack');
  const btnPrev = document.getElementById('btnPrev');
  const btnNext = document.getElementById('btnNext');
  const thumb = document.getElementById('scrollThumb');

  if (!track) return;

  const DISTANCIA_SCROLL = 260; // aprox. el ancho de una tarjeta + separación

  btnPrev.addEventListener('click', () => {
    track.scrollBy({ left: -DISTANCIA_SCROLL, behavior: 'smooth' });
  });

  btnNext.addEventListener('click', () => {
    track.scrollBy({ left: DISTANCIA_SCROLL, behavior: 'smooth' });
  });

  // Sincronizar la barra de desplazamiento personalizada con el scroll real
  function actualizarBarra() {
    const scrollableWidth = track.scrollWidth - track.clientWidth;
    if (scrollableWidth <= 0) {
      thumb.style.width = '100%';
      thumb.style.left = '0';
      return;
    }

    const porcentajeVisible = (track.clientWidth / track.scrollWidth) * 100;
    const porcentajeScroll = (track.scrollLeft / scrollableWidth) * (100 - porcentajeVisible);

    thumb.style.width = porcentajeVisible + '%';
    thumb.style.left = porcentajeScroll + '%';
  }

  track.addEventListener('scroll', actualizarBarra);
  window.addEventListener('resize', actualizarBarra);
  actualizarBarra();

  // Permitir arrastrar la barra para desplazar el carrusel
  let arrastrando = false;

  thumb.addEventListener('mousedown', (e) => {
    arrastrando = true;
    e.preventDefault();
  });

  document.addEventListener('mouseup', () => arrastrando = false);

  document.addEventListener('mousemove', (e) => {
    if (!arrastrando) return;
    const barra = thumb.parentElement.getBoundingClientRect();
    const porcentaje = (e.clientX - barra.left) / barra.width;
    const scrollableWidth = track.scrollWidth - track.clientWidth;
    track.scrollLeft = porcentaje * scrollableWidth;
  });
});
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