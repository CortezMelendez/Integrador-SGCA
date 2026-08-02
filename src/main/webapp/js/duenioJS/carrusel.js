
document.addEventListener('DOMContentLoaded', () => {
  const track = document.getElementById('carruselTrack');
  const btnPrev = document.getElementById('btnPrev');
  const btnNext = document.getElementById('btnNext');
  const thumb = document.getElementById('scrollThumb');

  if (!track) return;

  const DISTANCIA_SCROLL = 260;

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