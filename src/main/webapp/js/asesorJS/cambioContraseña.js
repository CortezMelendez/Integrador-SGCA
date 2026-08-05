document.addEventListener("DOMContentLoaded", () => {
            // -- Referencias al menú Configuración --
            const btnConfig = document.getElementById("btn-config");
            const dropdownConfig = document.getElementById("dropdown-config");
            const btnCloseDropdown = document.getElementById("btn-close-dropdown");
            const btnStartPassword = document.getElementById("btn-start-password-flow");

            // -- Referencias a los modales --
            const overlay = document.getElementById("modal-overlay");
            const step1 = document.getElementById("modal-step-1");
            const step2 = document.getElementById("modal-step-2");
            const step3 = document.getElementById("modal-step-3");
            
            const btnSendCode = document.getElementById("btn-send-code");
            const btnVerifyCode = document.getElementById("btn-verify-code");
            const btnSavePassword = document.getElementById("btn-save-password");
            const btnsCloseModal = document.querySelectorAll(".close-modal");

            // 1. Mostrar/Ocultar el submenú de Configuración
            btnConfig.addEventListener("click", (e) => {
                e.preventDefault();
                dropdownConfig.classList.toggle("oculto"); 
            });

            btnCloseDropdown.addEventListener("click", () => {
                dropdownConfig.classList.add("oculto");
            });

            // 2. Iniciar el flujo de cambio de contraseña
            btnStartPassword.addEventListener("click", () => {
                dropdownConfig.classList.add("oculto"); // Oculta el menú
                overlay.classList.remove("hidden");     // Muestra el fondo oscuro
                
                // Muestra el paso 1 y oculta los demás
                step1.classList.remove("hidden");
                step2.classList.add("hidden");
                step3.classList.add("hidden");
            });

            // 3. Paso 1 a Paso 2 (Enviar Código)
            btnSendCode.addEventListener("click", () => {
                step1.classList.add("hidden");
                step2.classList.remove("hidden");
            });

            // 4. Paso 2 a Paso 3 (Verificar Código)
            btnVerifyCode.addEventListener("click", () => {
                step2.classList.add("hidden");
                step3.classList.remove("hidden");
            });

            // 5. Finalizar (Guardar Contraseña) y redirigir
            btnSavePassword.addEventListener("click", () => {
                alert("Contraseña actualizada correctamente.");
                // Cambia esto por el nombre exacto de tu archivo de inicio de sesión
                window.location.href = ""; 
            });

            // 6. Cerrar modales con la 'X'
            btnsCloseModal.forEach(btn => {
                btn.addEventListener("click", () => {
                    overlay.classList.add("hidden");
                    step1.classList.add("hidden");
                    step2.classList.add("hidden");
                    step3.classList.add("hidden");
                });
            });
        });