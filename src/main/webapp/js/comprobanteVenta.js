// ==========================================================
// Comprobante informativo de venta (Módulo 5 del DFR).
// Se reutiliza desde cotizacionesAsesor.js, detalleVehiculo.jsp y
// automovilesCliente.jsp: recibe el JSON que devuelve
// /registrarVentaAsesor tras registrar la venta y lo muestra en un modal
// imprimible. No sustituye ningún cobro: el pago se hace fuera de la
// plataforma, esto solo confirma en pantalla los datos de la operación.
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
    const precioVehiculoFmt = Number(datos.precioVehiculo || 0).toLocaleString('es-MX', { style: 'currency', currency: 'MXN' });

    const serviciosHtml = (datos.servicios || []).map(s => {
        const precioFmt = Number(s.precio || 0).toLocaleString('es-MX', { style: 'currency', currency: 'MXN' });
        return `<div class="comprobante-servicio-item"><span>${escapeHtml(s.nombre)}</span><span>${precioFmt}</span></div>`;
    }).join('');

    overlay.innerHTML = `
        <div class="comprobante-box">
            <div class="comprobante-header">
                <h2>Comprobante de venta</h2>
                <p>Folio #${datos.folio} · ${escapeHtml(datos.fecha)}</p>
            </div>
            <div class="comprobante-body">
                <div class="comprobante-fila"><span>Cliente</span><span>${escapeHtml(datos.cliente)}</span></div>
                <div class="comprobante-fila"><span>Asesor</span><span>${escapeHtml(datos.asesor)}</span></div>
                <div class="comprobante-fila"><span>Vehículo</span><span>${escapeHtml(datos.vehiculo)}</span></div>
                <div class="comprobante-fila"><span>Placa</span><span>${escapeHtml(datos.placa)}</span></div>
                <div class="comprobante-fila"><span>Precio vehículo</span><span>${precioVehiculoFmt}</span></div>
                ${datos.servicios && datos.servicios.length ? `
                    <div class="comprobante-servicios">
                        <h4>Servicios contratados</h4>
                        ${serviciosHtml}
                    </div>
                ` : ''}
                <div class="comprobante-total"><span>Total</span><span>${totalFmt}</span></div>
                <p class="comprobante-nota">Este comprobante es informativo. El cobro se realiza de forma manual, fuera de la plataforma.</p>
            </div>
            <div class="comprobante-acciones">
                <button type="button" class="comprobante-btn-imprimir" onclick="window.print()">Imprimir</button>
                <button type="button" class="comprobante-btn-cerrar" id="btnCerrarComprobante">Cerrar</button>
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
