/* =============================================
   login.js — validación del formulario de inicio de sesión
============================================= */

document.addEventListener('DOMContentLoaded', () => {
  const form           = document.getElementById('loginForm');
  const emailInput     = document.getElementById('email');
  const passwordInput  = document.getElementById('password');
  const emailError     = document.getElementById('emailError');
  const passwordError  = document.getElementById('passwordError');
  const errorMessage   = document.getElementById('errorMessage');
  const errorMessageText = document.getElementById('errorMessageText');

  const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  // Simulación de credenciales válidas (reemplazar por llamada al backend real)
  const VALID_EMAIL    = 'admin@concesionaria.com';
  const VALID_PASSWORD = '123456';

  function setFieldError(input, errorEl, message) {
    input.classList.add('input-error');
    errorEl.textContent = message;
  }

  function clearFieldError(input, errorEl) {
    input.classList.remove('input-error');
    errorEl.textContent = '';
  }

  function showFormError(message) {
    errorMessageText.textContent = message;
    errorMessage.hidden = false;
  }

  function hideFormError() {
    errorMessage.hidden = true;
  }

  function clearAllErrors() {
    hideFormError();
    clearFieldError(emailInput, emailError);
    clearFieldError(passwordInput, passwordError);
  }

  // Limpia el error de un campo en cuanto el usuario empieza a corregirlo
  emailInput.addEventListener('input', () => clearFieldError(emailInput, emailError));
  passwordInput.addEventListener('input', () => clearFieldError(passwordInput, passwordError));

  form.addEventListener('submit', (event) => {
    event.preventDefault();
    clearAllErrors();

    const email    = emailInput.value.trim();
    const password = passwordInput.value;

    let hasEmptyOrInvalid = false;

    // Validar correo
    if (email === '') {
      setFieldError(emailInput, emailError, 'Ingresa tu correo electrónico.');
      hasEmptyOrInvalid = true;
    } else if (!EMAIL_REGEX.test(email)) {
      setFieldError(emailInput, emailError, 'Ingresa un correo electrónico válido.');
      hasEmptyOrInvalid = true;
    }

    // Validar contraseña
    if (password === '') {
      setFieldError(passwordInput, passwordError, 'Ingresa tu contraseña.');
      hasEmptyOrInvalid = true;
    } else if (password.length < 6) {
      setFieldError(passwordInput, passwordError, 'La contraseña debe tener al menos 6 caracteres.');
      hasEmptyOrInvalid = true;
    }

    // Si algún campo está vacío o mal formado, mostrar mensaje general y detener
    if (hasEmptyOrInvalid) {
      showFormError('Usuario o contraseña incorrectos. Intente de nuevo');
      return;
    }

    // Aquí ya email y password tienen formato válido: verificar credenciales
    if (email !== VALID_EMAIL || password !== VALID_PASSWORD) {
      emailInput.classList.add('input-error');
      passwordInput.classList.add('input-error');
      showFormError('Usuario o contraseña incorrectos. Intente de nuevo');
      return;
    }

    // Credenciales correctas: continuar
    window.location.href = '';
  });
});