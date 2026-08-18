
document.addEventListener('DOMContentLoaded', () => {
    // Distancia de respaldo si el track todavía no tiene tarjetas (evita
    // dividir por cero / no mover nada cuando el carrusel está vacío).
    const DISTANCIA_SCROLL_RESPALDO = 260;

    // Calcula cuánto avanzar en cada click: el ancho real de una tarjeta más
    // el gap entre tarjetas (leído del propio track), en vez de un valor fijo
    // que no coincide con el ancho real de las tarjetas en cada breakpoint y
    // hacía que el scroll-snap del carrusel "se trabara" o pareciera no hacer nada.
    function distanciaScroll(track) {
        const primeraTarjeta = track.firstElementChild;
        if (!primeraTarjeta) return DISTANCIA_SCROLL_RESPALDO;

        const gap = parseFloat(getComputedStyle(track).columnGap) || 0;
        return primeraTarjeta.getBoundingClientRect().width + gap;
    }

    document.querySelectorAll('.carrusel-section').forEach((seccion) => {
        const track = seccion.querySelector('.carrusel-track');
        if (!track) return;

        const btnPrev = seccion.querySelector('.carrusel-prev');
        const btnNext = seccion.querySelector('.carrusel-next');
        const thumb = seccion.querySelector('.carrusel-scrollbar-thumb');

        if (btnPrev) {
            btnPrev.addEventListener('click', () => {
                track.scrollBy({ left: -distanciaScroll(track), behavior: 'smooth' });
            });
        }

        if (btnNext) {
            btnNext.addEventListener('click', () => {
                track.scrollBy({ left: distanciaScroll(track), behavior: 'smooth' });
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
