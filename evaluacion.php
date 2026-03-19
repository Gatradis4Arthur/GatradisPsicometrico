<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Evaluación Psicométrica</title>
<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display:ital@0;1&family=DM+Sans:opsz,wght@9..40,300;400;500&display=swap" rel="stylesheet">
<style>
  :root {
    --c-ink:    #1a1a1a;
    --c-mid:    #4a4a4a;
    --c-rule:   #d4d0c8;
    --c-cream:  #faf8f4;
    --c-accent: #2d4a3e;
    --c-light:  #e8f0ec;
  }

  * { box-sizing: border-box; margin: 0; padding: 0; }

  html, body {
    height: 100%;
    height: 100dvh;
    overflow: hidden;
  }

  body {
    font-family: 'DM Sans', sans-serif;
    background-color: var(--c-cream);
    height: 100vh;
    height: 100dvh;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  h1, h2, .serif { font-family: 'DM Serif Display', serif; }

  /* ── CARD: móvil = pantalla completa, desktop = card flotante ── */
  .eval-card {
    background: #fff;
    display: flex;
    flex-direction: column;
    overflow: hidden;
    /* Móvil: ocupa todo el viewport */
    width: 100vw;
    height: 100vh;
    height: 100dvh;
    border-radius: 0;
    border: none;
    box-shadow: none;
  }

  @media (min-width: 640px) {
    body { padding: 20px; }
    .eval-card {
      width: min(90vw, 680px);
      height: min(94vh, 700px);
      height: min(94dvh, 700px);
      border-radius: 6px;
      border: 1px solid var(--c-rule);
      box-shadow: 0 2px 40px rgba(0,0,0,.08);
    }
  }

  /* ── TOP BAR ── */
  .card-top {
    background: var(--c-accent);
    padding: 0 20px;
    height: 52px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-shrink: 0;
  }
  @media (min-width: 640px) {
    .card-top { padding: 0 32px; height: 56px; }
  }
  .card-top .brand {
    font-family: 'DM Serif Display', serif;
    font-size: 18px;
    color: #fff;
    letter-spacing: .03em;
  }
  .card-top .badge {
    font-size: 11px;
    font-weight: 500;
    letter-spacing: .1em;
    text-transform: uppercase;
    color: rgba(255,255,255,.55);
  }

  /* ── LOGO AREA ── */
  .logo-area {
    padding: 12px 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-bottom: 1px solid var(--c-rule);
    flex-shrink: 0;
  }
  .logo-area img { height: 34px; object-fit: contain; }
  @media (min-width: 640px) {
    .logo-area { padding: 14px 32px; }
    .logo-area img { height: 38px; }
  }

  /* ── SCREEN WRAPPER ── */
  .screen { display: none; flex-direction: column; flex: 1; }
  .screen.active { display: flex; }

  /* ── INSTRUCCIONES SCREEN ── */
  .instrucciones-body {
    flex: 1;
    padding: 16px 18px 10px;
    display: flex;
    flex-direction: column;
    gap: 12px;
    overflow: hidden;
  }
  @media (min-width: 640px) {
    .instrucciones-body { padding: 18px 32px 12px; gap: 14px; }
  }
  .instrucciones-body .heading {
    font-family: 'DM Serif Display', serif;
    font-size: 20px;
    color: var(--c-ink);
    line-height: 1.2;
  }
  .instrucciones-body .heading em {
    font-style: italic;
    color: var(--c-accent);
  }
  .instrucciones-body .subtitle {
    font-size: 12px;
    color: var(--c-mid);
    margin-top: -8px;
    font-weight: 300;
  }

  .rules-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 8px;
    flex: 1;
    align-content: start;
  }
  @media (max-width: 520px) { .rules-grid { grid-template-columns: 1fr; } }

  .rule-item {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    padding: 10px 13px;
    background: var(--c-cream);
    border: 1px solid var(--c-rule);
    border-radius: 3px;
  }
  .rule-icon {
    font-size: 16px;
    flex-shrink: 0;
    margin-top: 1px;
  }
  .rule-text {
    font-size: 12px;
    color: var(--c-mid);
    line-height: 1.45;
  }
  .rule-text strong { color: var(--c-ink); font-weight: 500; }

  /* ── CAPTURA SCREEN ── */
  .captura-body {
    flex: 1;
    padding: 16px 18px 10px;
    display: flex;
    flex-direction: column;
    gap: 12px;
    overflow: hidden;
  }
  @media (min-width: 640px) {
    .captura-body { padding: 18px 32px 12px; gap: 14px; }
  }
  .captura-body .heading {
    font-family: 'DM Serif Display', serif;
    font-size: 20px;
    color: var(--c-ink);
  }
  .captura-body .heading em { font-style: italic; color: var(--c-accent); }
  .captura-body .subtitle {
    font-size: 12px;
    color: var(--c-mid);
    font-weight: 300;
    margin-top: -8px;
  }

  .form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
  }
  @media (max-width: 520px) { .form-grid { grid-template-columns: 1fr; } }

  .field-wrap { display: flex; flex-direction: column; gap: 4px; }
  .field-wrap.full { grid-column: 1 / -1; }

  .field-label {
    font-size: 10px;
    font-weight: 500;
    letter-spacing: .08em;
    text-transform: uppercase;
    color: var(--c-mid);
  }

  .field-input {
    border: 1px solid var(--c-rule);
    border-radius: 3px;
    padding: 9px 13px;
    font-family: 'DM Sans', sans-serif;
    font-size: 14px;
    color: var(--c-ink);
    background: #fff;
    outline: none;
    transition: border-color .15s;
    width: 100%;
  }
  .field-input:focus {
    border-color: var(--c-accent);
    box-shadow: 0 0 0 3px var(--c-light);
  }
  .field-input.error { border-color: #c0392b; }
  .field-input::placeholder { color: #bbb; }

  /* ── FOOTER / BTN ── */
  .card-footer {
    padding: 12px 18px 16px;
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 16px;
    border-top: 1px solid var(--c-rule);
    flex-shrink: 0;
  }
  @media (min-width: 640px) {
    .card-footer { padding: 12px 32px 16px; }
  }

  .step-label {
    font-size: 12px;
    color: #aaa;
    letter-spacing: .04em;
    margin-right: auto;
  }

  .btn-primary {
    background: var(--c-accent);
    color: #fff;
    border: none;
    border-radius: 3px;
    padding: 11px 28px;
    font-family: 'DM Sans', sans-serif;
    font-size: 14px;
    font-weight: 500;
    letter-spacing: .02em;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: background .15s, transform .1s;
  }
  .btn-primary:hover { background: #1e3329; }
  .btn-primary:active { transform: scale(.98); }
  .btn-primary svg { transition: transform .2s; }
  .btn-primary:hover svg { transform: translateX(3px); }
  .btn-primary:disabled { opacity: .5; cursor: not-allowed; }

  /* ── SPINNER ── */
  .spinner {
    width: 16px; height: 16px;
    border: 2px solid rgba(255,255,255,.35);
    border-top-color: #fff;
    border-radius: 50%;
    animation: spin .6s linear infinite;
    display: none;
  }
  @keyframes spin { to { transform: rotate(360deg); } }

  /* ── DIVIDER ── */
  .divider {
    border: none;
    border-top: 1px solid var(--c-rule);
    margin: 0;
  }

  /* ── FADE IN ── */
  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(10px); }
    to   { opacity: 1; transform: translateY(0); }
  }
  .screen.active { animation: fadeUp .3s ease; }
</style>
</head>
<body>

<div class="eval-card">

  <!-- TOP BAR -->
  <div class="card-top">
    <span class="brand">Evaluación Psicométrica</span>
    <span class="badge">Proceso de selección</span>
  </div>

  <!-- LOGO -->
  <div class="logo-area">
    <img src="assets/img/GatradisLogoFondoBlanco.png" alt="Logo" onerror="this.style.display='none'">
  </div>

  <!-- ══ PANTALLA 1: INSTRUCCIONES ══ -->
  <div id="screen-instrucciones" class="screen active">

    <div class="instrucciones-body">
      <div>
        <p class="heading">Antes de <em>comenzar</em></p>
        <p class="subtitle">Lee con atención las siguientes indicaciones</p>
      </div>

      <div class="rules-grid">

        <div class="rule-item">
          <span class="rule-icon">📵</span>
          <span class="rule-text">Silencia tu teléfono y busca un <strong>lugar tranquilo</strong> sin distracciones.</span>
        </div>

        <div class="rule-item">
          <span class="rule-icon">🖥</span>
          <span class="rule-text">Asegúrate de tener una <strong>conexión estable</strong> a internet durante toda la prueba.</span>
        </div>

        <div class="rule-item">
          <span class="rule-icon">✅</span>
          <span class="rule-text">Responde con sinceridad. <strong>No hay respuestas correctas ni incorrectas.</strong></span>
        </div>

        <div class="rule-item">
          <span class="rule-icon">⛔</span>
          <span class="rule-text"><strong>No cierres ni recargues</strong> el navegador una vez iniciada la evaluación.</span>
        </div>

        <div class="rule-item">
          <span class="rule-icon">🔂</span>
          <span class="rule-text">Cada pregunta se responde <strong>una sola vez.</strong> No podrás regresar.</span>
        </div>

        <div class="rule-item">
          <span class="rule-icon">⏱</span>
          <span class="rule-text">Cada sección tiene un <strong>tiempo límite.</strong> Administra bien tu tiempo.</span>
        </div>

      </div>
    </div>

    <div class="card-footer">
      <span class="step-label">Paso 1 de 2</span>
      <button class="btn-primary" id="btn-continuar-instrucciones">
        Continuar
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M5 12h14M13 6l6 6-6 6"/>
        </svg>
      </button>
    </div>

  </div><!-- /screen-instrucciones -->


  <!-- ══ PANTALLA 2: CAPTURA DE DATOS ══ -->
  <div id="screen-captura" class="screen">

    <div class="captura-body">
      <div>
        <p class="heading">Tus <em>datos</em></p>
        <p class="subtitle">Completa el formulario para iniciar la evaluación</p>
      </div>

      <form id="form-candidato" autocomplete="off" novalidate>
        <div class="form-grid">

          <div class="field-wrap full">
            <label class="field-label" for="nombre">Nombre completo</label>
            <input
              class="field-input"
              type="text"
              id="nombre"
              name="nombre"
              placeholder="Ej. María García López"
              maxlength="200"
            >
          </div>

          <div class="field-wrap">
            <label class="field-label" for="email">Correo electrónico</label>
            <input
              class="field-input"
              type="email"
              id="email"
              name="email"
              placeholder="correo@ejemplo.com"
              maxlength="150"
            >
          </div>

          <div class="field-wrap">
            <label class="field-label" for="telefono">Teléfono</label>
            <input
              class="field-input"
              type="tel"
              id="telefono"
              name="telefono"
              placeholder="10 dígitos"
              maxlength="15"
              inputmode="numeric"
            >
          </div>

          <div class="field-wrap full">
            <label class="field-label" for="puesto">Puesto al que aplica</label>
            <input
              class="field-input"
              type="text"
              id="puesto"
              name="puesto"
              placeholder="Ej. Chofer de autotanque"
              maxlength="150"
            >
          </div>

        </div>
      </form>
    </div>

    <div class="card-footer">
      <span class="step-label">Paso 2 de 2</span>

      <button class="btn-primary" id="btn-iniciar" type="button">
        <span id="btn-text">Iniciar evaluación</span>
        <div class="spinner" id="spinner"></div>
        <svg id="btn-arrow" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M5 12h14M13 6l6 6-6 6"/>
        </svg>
      </button>
    </div>

  </div><!-- /screen-captura -->

</div><!-- /eval-card -->


<script>
// ── STEP NAVIGATION ─────────────────────────────────────────────────────────
const screens = {
  instrucciones: document.getElementById('screen-instrucciones'),
  captura:       document.getElementById('screen-captura'),
};

function showScreen(name) {
  Object.values(screens).forEach(s => s.classList.remove('active'));
  screens[name].classList.add('active');
}

document.getElementById('btn-continuar-instrucciones')
  .addEventListener('click', () => showScreen('captura'));


// ── VALIDACIÓN ───────────────────────────────────────────────────────────────
function validateEmail(v) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v.trim());
}
function validatePhone(v) {
  return /^[\d\s\-+]{7,15}$/.test(v.trim());
}

function markField(id, valid) {
  const el = document.getElementById(id);
  el.classList.toggle('error', !valid);
  return valid;
}

function validateForm() {
  const nombre   = document.getElementById('nombre').value;
  const email    = document.getElementById('email').value;
  const telefono = document.getElementById('telefono').value;
  const puesto   = document.getElementById('puesto').value;

  let ok = true;
  if (!nombre.trim())                        ok = markField('nombre',   false) && ok;
  else                                            markField('nombre',   true);
  if (!validateEmail(email))                 ok = markField('email',    false) && ok;
  else                                            markField('email',    true);
  if (!validatePhone(telefono))              ok = markField('telefono', false) && ok;
  else                                            markField('telefono', true);
  if (!puesto.trim())                        ok = markField('puesto',   false) && ok;
  else                                            markField('puesto',   true);

  return ok;
}

// Limpiar error al escribir
['nombre','email','telefono','puesto'].forEach(id => {
  document.getElementById(id).addEventListener('input', () => {
    document.getElementById(id).classList.remove('error');
  });
});


// ── SUBMIT ───────────────────────────────────────────────────────────────────
document.getElementById('btn-iniciar').addEventListener('click', async () => {

  if (!validateForm()) {
    Swal.fire({
      icon: 'warning',
      title: 'Datos incompletos',
      text: 'Por favor completa todos los campos correctamente.',
      confirmButtonColor: '#2d4a3e',
      confirmButtonText: 'Entendido',
    });
    return;
  }

  const btn     = document.getElementById('btn-iniciar');
  const spinner = document.getElementById('spinner');
  const arrow   = document.getElementById('btn-arrow');
  const texto   = document.getElementById('btn-text');

  btn.disabled     = true;
  spinner.style.display = 'block';
  arrow.style.display   = 'none';
  texto.textContent = 'Guardando...';

  const payload = {
    nombre:   document.getElementById('nombre').value.trim(),
    email:    document.getElementById('email').value.trim(),
    telefono: document.getElementById('telefono').value.trim(),
    puesto:   document.getElementById('puesto').value.trim(),
  };

  try {
    const res  = await fetch('api/guardar_candidato.php', {
      method:  'POST',
      headers: { 'Content-Type': 'application/json' },
      body:    JSON.stringify(payload),
    });

    const data = await res.json();

    if (data.ok) {
      // Guardar sesión y continuar
      sessionStorage.setItem('candidato_id',    data.candidato_id);
      sessionStorage.setItem('session_id',      data.session_id);
      sessionStorage.setItem('battery_code',    data.battery_code);
      sessionStorage.setItem('candidato_nombre', payload.nombre);

      window.location.href = 'evaluacion.php';

    } else {
      throw new Error(data.mensaje || 'Error del servidor');
    }

  } catch (err) {
    Swal.fire({
      icon: 'error',
      title: 'Error al guardar',
      text: err.message || 'No se pudo conectar con el servidor. Inténtalo de nuevo.',
      confirmButtonColor: '#2d4a3e',
      confirmButtonText: 'Reintentar',
    });

    btn.disabled          = false;
    spinner.style.display = 'none';
    arrow.style.display   = 'block';
    texto.textContent     = 'Iniciar evaluación';
  }
});
</script>

</body>
</html>