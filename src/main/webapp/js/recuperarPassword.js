(function () {

    const CONTEXT_PATH = window.RECUPERAR_CONTEXT_PATH || "";

    const overlay = document.getElementById("recuperarOverlay");
    const btnAbrir = document.getElementById("btnAbrirRecuperar");

    const pasos = {
        1: document.getElementById("paso1"),
        2: document.getElementById("paso2"),
        3: document.getElementById("paso3")
    };

    let correoActual = "";

    function mostrarPaso(numero) {
        Object.values(pasos).forEach(function (paso) {
            paso.classList.add("recuperar-oculto");
        });
        pasos[numero].classList.remove("recuperar-oculto");
    }

    function abrirModal() {
        mostrarPaso(1);
        limpiarTodo();
        overlay.classList.add("active");
    }

    function cerrarModal() {
        overlay.classList.remove("active");
    }

    function limpiarTodo() {
        document.getElementById("correoRecuperacion").value = "";
        limpiarDigitos();
        document.getElementById("nuevaPassword").value = "";
        document.getElementById("confirmarPassword").value = "";
        mostrarError("errorPaso1", "");
        mostrarError("errorPaso2", "");
        mostrarError("errorPaso3", "");
    }

    function mostrarError(idError, mensaje, esAviso) {
        const el = document.getElementById(idError);
        el.textContent = mensaje || "";
        el.classList.toggle("recuperar-aviso", !!esAviso);
    }

    function correoValido(correo) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(correo);
    }

    async function enviarCodigo(correo) {
        const respuesta = await fetch(CONTEXT_PATH + "/RecuperarPasswordServlet", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "destino=" + encodeURIComponent(correo)
        });
        const texto = await respuesta.text();
        return { ok: respuesta.ok, mensaje: texto.trim() };
    }


    // ===== ABRIR / CERRAR MODAL =====

    btnAbrir.addEventListener("click", function (e) {
        e.preventDefault();
        abrirModal();
    });

    document.querySelectorAll("[data-cerrar]").forEach(function (btn) {
        btn.addEventListener("click", cerrarModal);
    });

    overlay.addEventListener("click", function (e) {
        if (e.target === overlay) {
            cerrarModal();
        }
    });

    document.addEventListener("keydown", function (e) {
        if (e.key === "Escape" && overlay.classList.contains("active")) {
            cerrarModal();
        }
    });


    // ===== PASO 1: RECUPERAR CONTRASEÑA =====

    const formPaso1 = document.getElementById("formPaso1");
    const btnEnviarCodigo = document.getElementById("btnEnviarCodigo");

    formPaso1.addEventListener("submit", async function (e) {
        e.preventDefault();

        const correo = document.getElementById("correoRecuperacion").value.trim();

        if (!correo || !correoValido(correo)) {
            mostrarError("errorPaso1", "Ingresa un correo electrónico válido.");
            return;
        }

        mostrarError("errorPaso1", "");
        btnEnviarCodigo.disabled = true;

        try {
            const resultado = await enviarCodigo(correo);

            if (resultado.ok) {
                correoActual = correo;
                limpiarDigitos();
                mostrarPaso(2);
                enfocarPrimerDigito();
            } else {
                mostrarError("errorPaso1", resultado.mensaje);
            }
        } catch (err) {
            mostrarError("errorPaso1", "No se pudo contactar al servidor. Intenta de nuevo.");
        } finally {
            btnEnviarCodigo.disabled = false;
        }
    });


    // ===== PASO 2: VERIFICAR CÓDIGO =====

    const formPaso2 = document.getElementById("formPaso2");
    const digitos = Array.from(document.querySelectorAll(".recuperar-digito"));
    const btnReenviar = document.getElementById("btnReenviar");

    function limpiarDigitos() {
        digitos.forEach(function (input) { input.value = ""; });
    }

    function enfocarPrimerDigito() {
        if (digitos[0]) {
            digitos[0].focus();
        }
    }

    digitos.forEach(function (input, indice) {

        input.addEventListener("input", function () {
            input.value = input.value.replace(/\D/g, "").slice(0, 1);

            if (input.value && indice < digitos.length - 1) {
                digitos[indice + 1].focus();
            }
        });

        input.addEventListener("keydown", function (e) {
            if (e.key === "Backspace" && !input.value && indice > 0) {
                digitos[indice - 1].focus();
            }
        });

        input.addEventListener("paste", function (e) {
            const texto = (e.clipboardData || window.clipboardData).getData("text").replace(/\D/g, "");
            if (!texto) {
                return;
            }
            e.preventDefault();
            texto.slice(0, digitos.length).split("").forEach(function (caracter, i) {
                if (digitos[i]) {
                    digitos[i].value = caracter;
                }
            });
            const siguiente = digitos[Math.min(texto.length, digitos.length - 1)];
            if (siguiente) {
                siguiente.focus();
            }
        });
    });

    formPaso2.addEventListener("submit", async function (e) {
        e.preventDefault();

        const codigo = digitos.map(function (input) { return input.value; }).join("");

        if (codigo.length < digitos.length) {
            mostrarError("errorPaso2", "Completa los 6 dígitos del código.");
            return;
        }

        mostrarError("errorPaso2", "");

        try {
            const respuesta = await fetch(CONTEXT_PATH + "/ValidarCodigoServlet", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "codigo=" + encodeURIComponent(codigo)
            });
            const texto = (await respuesta.text()).trim();

            if (respuesta.ok) {
                mostrarPaso(3);
            } else {
                mostrarError("errorPaso2", texto);
            }
        } catch (err) {
            mostrarError("errorPaso2", "No se pudo contactar al servidor. Intenta de nuevo.");
        }
    });

    btnReenviar.addEventListener("click", async function () {
        if (!correoActual) {
            mostrarPaso(1);
            return;
        }

        btnReenviar.disabled = true;

        try {
            const resultado = await enviarCodigo(correoActual);

            if (resultado.ok) {
                limpiarDigitos();
                enfocarPrimerDigito();
                mostrarError("errorPaso2", "Te enviamos un nuevo código a tu correo.", true);
            } else {
                mostrarError("errorPaso2", resultado.mensaje);
            }
        } catch (err) {
            mostrarError("errorPaso2", "No se pudo contactar al servidor. Intenta de nuevo.");
        } finally {
            btnReenviar.disabled = false;
        }
    });


    // ===== PASO 3: NUEVA CONTRASEÑA =====

    const formPaso3 = document.getElementById("formPaso3");

    formPaso3.addEventListener("submit", async function (e) {
        e.preventDefault();

        const nuevaPassword = document.getElementById("nuevaPassword").value;
        const confirmarPassword = document.getElementById("confirmarPassword").value;

        if (nuevaPassword.length < 8) {
            mostrarError("errorPaso3", "La contraseña debe tener al menos 8 caracteres.");
            return;
        }

        if (nuevaPassword !== confirmarPassword) {
            mostrarError("errorPaso3", "Las contraseñas no coinciden.");
            return;
        }

        mostrarError("errorPaso3", "");

        try {
            const respuesta = await fetch(CONTEXT_PATH + "/CambiarPasswordServlet", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "nuevaPassword=" + encodeURIComponent(nuevaPassword)
                        + "&confirmarPassword=" + encodeURIComponent(confirmarPassword)
            });
            const texto = (await respuesta.text()).trim();

            if (respuesta.ok) {
                window.location.href = CONTEXT_PATH + "/login.jsp?exito=password_actualizada";
            } else {
                mostrarError("errorPaso3", texto);
            }
        } catch (err) {
            mostrarError("errorPaso3", "No se pudo contactar al servidor. Intenta de nuevo.");
        }
    });

})();
