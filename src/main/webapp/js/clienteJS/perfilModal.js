(function () {

    const CONTEXT_PATH = window.PERFIL_CONTEXT_PATH || "";

    const overlay = document.getElementById("modalPerfil");
    if (!overlay) {
        return;
    }

    const btnAbrir = document.getElementById("btnAbrirPerfil");
    const vista = document.getElementById("perfilVista");
    const editar = document.getElementById("perfilEditar");
    const form = document.getElementById("formEditarPerfil");
    const errorEl = document.getElementById("errorPerfil");
    const exitoEl = document.getElementById("exitoPerfil");

    function mostrarVista() {
        vista.classList.remove("oculto");
        editar.classList.add("oculto");
    }

    function mostrarEdicion() {
        errorEl.textContent = "";
        exitoEl.textContent = "";
        vista.classList.add("oculto");
        editar.classList.remove("oculto");
    }

    function abrir() {
        mostrarVista();
        overlay.classList.add("active");
    }

    function cerrar() {
        overlay.classList.remove("active");
    }

    btnAbrir.addEventListener("click", function (e) {
        e.preventDefault();
        abrir();
    });

    document.getElementById("btnEditarPerfil").addEventListener("click", mostrarEdicion);
    document.getElementById("btnCancelarEdicion").addEventListener("click", mostrarVista);

    document.querySelectorAll("[data-cerrar-perfil]").forEach(function (btn) {
        btn.addEventListener("click", cerrar);
    });

    overlay.addEventListener("click", function (e) {
        if (e.target === overlay) {
            cerrar();
        }
    });

    document.addEventListener("keydown", function (e) {
        if (e.key === "Escape" && overlay.classList.contains("active")) {
            cerrar();
        }
    });

    function correoValido(correo) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(correo);
    }

    function actualizarVista(nombre, apellidoPaterno, apellidoMaterno, correo, telefono) {
        const nombreCompleto = [nombre, apellidoPaterno, apellidoMaterno].filter(Boolean).join(" ");

        document.querySelectorAll(".perfil-nombre").forEach(function (el) {
            el.textContent = nombreCompleto;
        });
        document.querySelectorAll(".perfil-correo-chico").forEach(function (el) {
            el.textContent = correo;
        });
        document.querySelectorAll(".perfil-valor-correo").forEach(function (el) {
            el.textContent = correo;
        });
        document.querySelectorAll(".perfil-valor-telefono").forEach(function (el) {
            el.textContent = telefono;
        });
    }

    form.addEventListener("submit", async function (e) {
        e.preventDefault();

        errorEl.textContent = "";
        exitoEl.textContent = "";

        const nombre = document.getElementById("perfilNombre").value.trim();
        const apellidoPaterno = document.getElementById("perfilApellidoPaterno").value.trim();
        const apellidoMaterno = document.getElementById("perfilApellidoMaterno").value.trim();
        const telefono = document.getElementById("perfilTelefono").value.trim();
        const correo = document.getElementById("perfilCorreo").value.trim();
        const passwordActual = document.getElementById("perfilPasswordActual").value;
        const nuevaPassword = document.getElementById("perfilNuevaPassword").value;
        const confirmarPassword = document.getElementById("perfilConfirmarPassword").value;

        if (!nombre || !apellidoPaterno || !telefono || !correo) {
            errorEl.textContent = "Completa los campos obligatorios.";
            return;
        }

        if (!correoValido(correo)) {
            errorEl.textContent = "Ingresa un correo electrónico válido.";
            return;
        }

        if (nuevaPassword || confirmarPassword || passwordActual) {
            if (!passwordActual) {
                errorEl.textContent = "Ingresa tu contraseña actual para poder cambiarla.";
                return;
            }
            if (nuevaPassword.length < 8) {
                errorEl.textContent = "La nueva contraseña debe tener al menos 8 caracteres.";
                return;
            }
            if (nuevaPassword !== confirmarPassword) {
                errorEl.textContent = "Las contraseñas no coinciden.";
                return;
            }
        }

        const cuerpo = new URLSearchParams({
            nombre: nombre,
            apellidoPaterno: apellidoPaterno,
            apellidoMaterno: apellidoMaterno,
            telefono: telefono,
            correo: correo,
            passwordActual: passwordActual,
            nuevaPassword: nuevaPassword,
            confirmarPassword: confirmarPassword
        });

        try {
            const respuesta = await fetch(CONTEXT_PATH + "/perfil", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: cuerpo.toString()
            });
            const texto = (await respuesta.text()).trim();

            if (respuesta.ok) {
                exitoEl.textContent = texto;
                document.getElementById("perfilPasswordActual").value = "";
                document.getElementById("perfilNuevaPassword").value = "";
                document.getElementById("perfilConfirmarPassword").value = "";
                actualizarVista(nombre, apellidoPaterno, apellidoMaterno, correo, telefono);
            } else {
                errorEl.textContent = texto;
            }
        } catch (err) {
            errorEl.textContent = "No se pudo contactar al servidor. Intenta de nuevo.";
        }
    });

})();
