// ==========================================================
// Confirmación de venta/cotización registrada (Módulo 5 del DFR).
// Se reutiliza desde cotizacionesAsesor.js, detalleVehiculo.jsp y
// automovilesCliente.jsp: recibe el JSON que devuelve
// /registrarVentaAsesor tras registrar la venta (que ya quedó guardada
// en ADMIN.VENTAS / ADMIN.DETALLE_VENTA_SERVICIOS en ese momento) y solo
// avisa en pantalla que la operación se completó, sin imprimir ni generar
// ningún archivo — el pago se sigue haciendo de forma manual, fuera de
// la plataforma.
// ==========================================================

function mostrarComprobanteVenta(datos, onCerrar) {
    let overlay = document.getElementById('comprobanteVentaOverlay');
    if (!overlay) {
        overlay = document.createElement('div');
        overlay.id = 'comprobanteVentaOverlay';
        overlay.className = 'comprobante-overlay';
        document.body.appendChild(overlay);
    }

    const totalFmt = Number(datos.total || 0).toLocaleString('es-MX', { style: 'currency', currency: 'MXN' });

    overlay.innerHTML = `
        <div class="comprobante-box">
            <div class="comprobante-icono-exito">&#10003;</div>
            <h2 class="comprobante-titulo">¡Cotización registrada!</h2>
            <p class="comprobante-subtitulo">Folio #${datos.folio} · Se guardó correctamente en el sistema.</p>
            <div class="comprobante-resumen">
                <div class="comprobante-fila"><span>Cliente</span><span>${escapeHtml(datos.cliente)}</span></div>
                <div class="comprobante-fila"><span>Vehículo</span><span>${escapeHtml(datos.vehiculo)}</span></div>
                <div class="comprobante-fila"><span>Total</span><span>${totalFmt}</span></div>
            </div>
            <div class="comprobante-acciones">
                <button type="button" class="comprobante-btn-cerrar" id="btnCerrarComprobante">Aceptar</button>
            </div>
        </div>
    `;

    overlay.classList.add('active');
    document.body.style.overflow = 'hidden';

    document.getElementById('btnCerrarComprobante').addEventListener('click', () => {
        overlay.classList.remove('active');
        document.body.style.overflow = '';
        if (typeof onCerrar === 'function') onCerrar();
    });
}

function escapeHtml(valor) {
    if (valor === undefined || valor === null) return '';
    const div = document.createElement('div');
    div.textContent = String(valor);
    return div.innerHTML;
}
