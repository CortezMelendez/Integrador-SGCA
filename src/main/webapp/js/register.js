/* =============================================
   register.js — validación del formulario de registro
   Solo valida: campos vacíos + límite de caracteres
============================================= */

document.addEventListener('DOMContentLoaded', () => {
  const form         = document.getElementById('registerForm');
  const errorMessage   = document.getElementById('errorMessage');
  const errorMessageText = document.getElementById('errorMessageText');

  // Cada campo con su límite máximo de caracteres (coincide con el maxlength del HTML)
  const fields = [
    { input: document.getElementById('nombre'),   error: document.getElementById('nombreError'),   label: 'Nombre',   maxLength: 50 },
    { input: document.getElementById('email'),    error: document.getElementById('emailError'),    label: 'Correo',   maxLength: 100 },
    { input: document.getElementById('password'), error: document.getElementById('passwordError'), label: 'Contraseña', maxLength: 30 },
    { input: document.getElementById('telefono'), error: document.getElementById('telefonoError'), label: 'Teléfono', maxLength: 10 },
  ];

  function setFieldError(field, message) {
    field.input.classList.add('input-error');
    field.error.textContent = message;
  }

  function clearFieldError(field) {
    field.input.classList.remove('input-error');
    field.error.textContent = '';
  }

  function showFormError(message) {
    errorMessageText.textContent = message;
    errorMessage.hidden = false;
  }

  function hideFormError() {
    errorMessage.hidden = true;
  }

  // Limpia el error del campo apenas el usuario empieza a corregirlo
  fields.forEach((field) => {
    field.input.addEventListener('input', () => clearFieldError(field));
  });

  form.addEventListener('submit', (event) => {
    event.preventDefault();
    hideFormError();

    let hasError = false;

    fields.forEach((field) => {
      const value = field.input.value.trim();

      clearFieldError(field);

      if (value === '') {
        setFieldError(field, `El campo "${field.label}" no puede estar vacío.`);
        hasError = true;
        return;
      }

      if (value.length > field.maxLength) {
        setFieldError(field, `"${field.label}" no puede tener más de ${field.maxLength} caracteres.`);
        hasError = true;
      }
    });

    if (hasError) {
      showFormError('Revisa los campos marcados en rojo.');
      return;
    }

    // Todos los campos son válidos: continuar con el registro
    // (aquí se conectaría la llamada real al backend)
    window.location.href = 'login.html';
  });
});

/* =============================================
   Mostrar/ocultar contraseña — mismo comportamiento
   que en login.js, reutilizable las veces que haga falta.
============================================= */
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('[data-toggle-password]').forEach((btn) => {
    const input = document.getElementById(btn.getAttribute('data-toggle-password'));
    if (!input) return;

    btn.addEventListener('click', () => {
      const estaOculta = input.type === 'password';
      input.type = estaOculta ? 'text' : 'password';
      btn.classList.toggle('is-visible', estaOculta);
      btn.setAttribute('aria-label', estaOculta ? 'Ocultar contraseña' : 'Mostrar contraseña');
    });
  });
});

/* =============================================
   RFC y CURP siempre en mayúsculas mientras se escriben
   (el servidor los normaliza igual, esto es solo para que
   el usuario vea de una vez el formato correcto).
============================================= */
document.addEventListener('DOMContentLoaded', () => {
  ['rfc', 'curp'].forEach((id) => {
    const input = document.getElementById(id);
    if (!input) return;

    input.addEventListener('input', () => {
      const inicio = input.selectionStart;
      const fin = input.selectionEnd;
      input.value = input.value.toUpperCase();
      input.setSelectionRange(inicio, fin);
    });
  });
});