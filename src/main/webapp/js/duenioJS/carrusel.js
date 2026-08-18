
document.addEventListener('DOMContentLoaded', () => {
  const DISTANCIA_SCROLL = 260;

  document.querySelectorAll('.carrusel-section').forEach((seccion) => {
    const track = seccion.querySelector('.carrusel-track');
    if (!track) return;

    const btnPrev = seccion.querySelector('.carrusel-prev');
    const btnNext = seccion.querySelector('.carrusel-next');
    const thumb = seccion.querySelector('.carrusel-scrollbar-thumb');

    if (btnPrev) {
      btnPrev.addEventListener('click', () => {
        track.scrollBy({ left: -DISTANCIA_SCROLL, behavior: 'smooth' });
      });
    }

    if (btnNext) {
      btnNext.addEventListener('click', () => {
        track.scrollBy({ left: DISTANCIA_SCROLL, behavior: 'smooth' });
      });
    }

    if (!thumb) return;

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
});
