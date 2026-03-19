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

  /* CARD: movil = full screen, desktop = card flotante */
  .eval-card {
    background: #fff;
    display: flex;
    flex-direction: column;
    overflow: hidden;
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

  /* TOP BAR */
  .card-top {
    background: var(--c-accent);
    padding: 0 20px;
    height: 52px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-shrink: 0;
  }
  @media (min-width: 640px) { .card-top { padding: 0 32px; height: 56px; } }

  .card-top .brand {
    font-family: 'DM Serif Display', serif;
    font-size: 17px;
    color: #fff;
    letter-spacing: .03em;
  }
  @media (min-width: 640px) { .card-top .brand { font-size: 18px; } }

  .card-top .badge {
    font-size: 10px;
    font-weight: 500;
    letter-spacing: .1em;
    text-transform: uppercase;
    color: rgba(255,255,255,.55);
  }

  /* LOGO AREA */
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

  /* SCREEN WRAPPER */
  .screen { display: none; flex-direction: column; flex: 1; min-height: 0; }
  .screen.active { display: flex; animation: fadeUp .25s ease; }

  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(8px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* SHARED body area */
  .screen-body {
    flex: 1;
    min-height: 0;
    padding: 20px 18px 12px;
    display: flex;
    flex-direction: column;
    gap: 12px;
    overflow: hidden;
  }
  @media (min-width: 640px) {
    .screen-body { padding: 22px 32px 14px; gap: 16px; }
  }

  .screen-heading {
    font-family: 'DM Serif Display', serif;
    font-size: 20px;
    color: var(--c-ink);
    line-height: 1.2;
    flex-shrink: 0;
  }
  .screen-heading em { font-style: italic; color: var(--c-accent); }

  .screen-subtitle {
    font-size: 12px;
    color: var(--c-mid);
    font-weight: 300;
    margin-top: -8px;
    flex-shrink: 0;
  }

  /* PANTALLA CODIGO */
  .codigo-center {
    flex: 1;
    min-height: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 22px;
    padding: 16px 24px;
  }
  @media (min-width: 640px) { .codigo-center { gap: 28px; padding: 20px 40px; } }

  .codigo-welcome {
    text-align: center;
    max-width: 400px;
  }
  .codigo-welcome p {
    font-size: 13px;
    color: var(--c-mid);
    line-height: 1.7;
  }
  .codigo-welcome p span { color: var(--c-ink); font-weight: 500; }

  .codigo-form {
    width: 100%;
    max-width: 280px;
    display: flex;
    flex-direction: column;
    gap: 12px;
  }

  .codigo-input {
    border: 1px solid var(--c-rule);
    border-radius: 3px;
    padding: 13px 16px;
    font-family: 'DM Sans', sans-serif;
    font-size: 24px;
    font-weight: 500;
    color: var(--c-ink);
    background: #fff;
    outline: none;
    text-align: center;
    letter-spacing: .3em;
    width: 100%;
    transition: border-color .15s, box-shadow .15s;
  }
  .codigo-input:focus {
    border-color: var(--c-accent);
    box-shadow: 0 0 0 3px var(--c-light);
  }
  .codigo-input.error { border-color: #c0392b; }
  .codigo-input::placeholder {
    color: #ccc;
    letter-spacing: .1em;
    font-size: 16px;
    font-weight: 400;
  }

  .codigo-lock {
    font-size: 11px;
    color: #b0b0b0;
    text-align: center;
    font-style: italic;
    max-width: 320px;
    line-height: 1.55;
  }

  /* INSTRUCCIONES */
  .rules-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 8px;
    flex: 1;
    min-height: 0;
    align-content: start;
  }
  @media (max-width: 480px) { .rules-grid { grid-template-columns: 1fr; } }

  .rule-item {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    padding: 10px 12px;
    background: var(--c-cream);
    border: 1px solid var(--c-rule);
    border-radius: 3px;
  }
  .rule-icon { font-size: 15px; flex-shrink: 0; margin-top: 1px; }
  .rule-text { font-size: 12px; color: var(--c-mid); line-height: 1.45; }
  .rule-text strong { color: var(--c-ink); font-weight: 500; }

  /* CAPTURA */
  .form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
    flex: 1;
    min-height: 0;
    align-content: start;
  }
  @media (max-width: 480px) { .form-grid { grid-template-columns: 1fr; } }

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
    transition: border-color .15s, box-shadow .15s;
    width: 100%;
  }
  .field-input:focus {
    border-color: var(--c-accent);
    box-shadow: 0 0 0 3px var(--c-light);
  }
  .field-input.error { border-color: #c0392b; }
  .field-input::placeholder { color: #bbb; }

  /* FOOTER */
  .card-footer {
    padding: 12px 18px 16px;
    display: flex;
    align-items: center;
    gap: 16px;
    border-top: 1px solid var(--c-rule);
    flex-shrink: 0;
  }
  @media (min-width: 640px) { .card-footer { padding: 12px 32px 16px; } }

  /* dots de progreso */
  .step-dots {
    display: flex;
    gap: 6px;
    align-items: center;
    margin-right: auto;
  }
  .dot {
    width: 7px; height: 7px;
    border-radius: 50%;
    background: var(--c-rule);
    transition: background .25s;
  }
  .dot.active { background: var(--c-accent); }

  /* BOTON */
  .btn-primary {
    background: var(--c-accent);
    color: #fff;
    border: none;
    border-radius: 3px;
    padding: 11px 24px;
    font-family: 'DM Sans', sans-serif;
    font-size: 14px;
    font-weight: 500;
    letter-spacing: .02em;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: background .15s, transform .1s;
    white-space: nowrap;
  }
  .btn-primary:hover  { background: #1e3329; }
  .btn-primary:active { transform: scale(.98); }
  .btn-primary svg    { transition: transform .2s; }
  .btn-primary:hover svg { transform: translateX(3px); }
  .btn-primary:disabled { opacity: .5; cursor: not-allowed; }
  .btn-primary:disabled svg { transform: none !important; }

  .btn-full { width: 100%; justify-content: center; }

  /* SPINNER */
  .spinner {
    width: 15px; height: 15px;
    border: 2px solid rgba(255,255,255,.3);
    border-top-color: #fff;
    border-radius: 50%;
    animation: spin .6s linear infinite;
    display: none;
    flex-shrink: 0;
  }
  @keyframes spin { to { transform: rotate(360deg); } }

  /* SPLASH: conectando */
  .splash-center {
    flex: 1;
    min-height: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 20px;
    padding: 24px;
  }

  .splash-ring {
    width: 44px; height: 44px;
    border: 3px solid var(--c-light);
    border-top-color: var(--c-accent);
    border-radius: 50%;
    animation: spin .8s linear infinite;
  }
  .splash-ring.ok {
    animation: none;
    border-color: var(--c-accent);
    border-top-color: var(--c-accent);
  }
  .splash-ring.fail {
    animation: none;
    border-color: #f0e0de;
    border-top-color: #c0392b;
  }

  .splash-title {
    font-family: 'DM Serif Display', serif;
    font-size: 18px;
    color: var(--c-ink);
    text-align: center;
  }
  .splash-sub {
    font-size: 12px;
    color: var(--c-mid);
    font-weight: 300;
    text-align: center;
    max-width: 280px;
    line-height: 1.6;
  }
  .splash-sub.error { color: #c0392b; }

  .btn-reintentar {
    display: none;
    background: none;
    border: 1px solid var(--c-rule);
    border-radius: 3px;
    padding: 9px 22px;
    font-family: 'DM Sans', sans-serif;
    font-size: 13px;
    color: var(--c-mid);
    cursor: pointer;
    transition: border-color .15s, color .15s;
    margin-top: 4px;
  }
  .btn-reintentar:hover { border-color: var(--c-accent); color: var(--c-accent); }
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


  <!-- ════════════════════════════════
       PANTALLA SPLASH  |  VERIFICANDO CONEXIÓN
  ════════════════════════════════ -->
  <div id="screen-splash" class="screen active">

    <div class="splash-center">
      <div class="splash-ring" id="splash-ring"></div>
      <p class="splash-title" id="splash-title">Conectando…</p>
      <p class="splash-sub" id="splash-sub">Verificando conexión con el servidor</p>
      <button class="btn-reintentar" id="btn-reintentar" onclick="probarConexion()">
        Reintentar
      </button>
    </div>

    <div class="card-footer">
      <div class="step-dots">
        <div class="dot"></div>
        <div class="dot"></div>
        <div class="dot"></div>
      </div>
    </div>

  </div><!-- /screen-splash -->


  <!-- ════════════════════════════════
       PANTALLA 0  |  CÓDIGO DE ACCESO
  ════════════════════════════════ -->
  <div id="screen-codigo" class="screen">

    <div class="codigo-center">

      <div class="codigo-welcome">
        <p>
          Bienvenido al portal de evaluaciones psicométricas.<br>
          Ingresa el <span>código de 4 dígitos</span> proporcionado por el departamento
          de <span>Recursos Humanos</span> para continuar.
        </p>
      </div>

      <form id="form-codigo" autocomplete="off" novalidate>
        <div class="codigo-form">
          <input
            type="text"
            id="codigo"
            name="codigo"
            class="codigo-input"
            placeholder="0000"
            maxlength="4"
            inputmode="numeric"
            autocomplete="off"
          >
          <button type="submit" id="btn-ingresar" class="btn-primary btn-full">
            <span id="btn-codigo-text">Ingresar</span>
            <div class="spinner" id="spinner-codigo"></div>
            <svg id="btn-codigo-arrow" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <path d="M5 12h14M13 6l6 6-6 6"/>
            </svg>
          </button>
        </div>
      </form>

      <p class="codigo-lock">
        🔒 La información es estrictamente confidencial y se utilizará
        únicamente con fines de evaluación.
      </p>

    </div>

    <div class="card-footer">
      <div class="step-dots">
        <div class="dot active"></div>
        <div class="dot"></div>
        <div class="dot"></div>
      </div>
    </div>

  </div><!-- /screen-codigo -->


  <!-- ════════════════════════════════
       PANTALLA 1  |  INSTRUCCIONES
  ════════════════════════════════ -->
  <div id="screen-instrucciones" class="screen">

    <div class="screen-body">
      <p class="screen-heading">Antes de <em>comenzar</em></p>
      <p class="screen-subtitle">Lee con atención las siguientes indicaciones</p>

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
      <div class="step-dots">
        <div class="dot"></div>
        <div class="dot active"></div>
        <div class="dot"></div>
      </div>
      <button class="btn-primary" id="btn-continuar-instrucciones">
        Continuar
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M5 12h14M13 6l6 6-6 6"/>
        </svg>
      </button>
    </div>

  </div><!-- /screen-instrucciones -->


  <!-- ════════════════════════════════
       PANTALLA 2  |  CAPTURA DE DATOS
  ════════════════════════════════ -->
  <div id="screen-captura" class="screen">

    <div class="screen-body">
      <p class="screen-heading">Tus <em>datos</em></p>
      <p class="screen-subtitle">Completa el formulario para iniciar la evaluación</p>

      <form id="form-candidato" autocomplete="off" novalidate>
        <div class="form-grid">

          <div class="field-wrap full">
            <label class="field-label" for="nombre">Nombre completo</label>
            <input class="field-input" type="text" id="nombre" name="nombre"
              placeholder="Ej. María García López" maxlength="200">
          </div>

          <div class="field-wrap">
            <label class="field-label" for="email">Correo electrónico</label>
            <input class="field-input" type="email" id="email" name="email"
              placeholder="correo@ejemplo.com" maxlength="150">
          </div>

          <div class="field-wrap">
            <label class="field-label" for="telefono">Teléfono</label>
            <input class="field-input" type="tel" id="telefono" name="telefono"
              placeholder="10 dígitos" maxlength="15" inputmode="numeric">
          </div>

          <div class="field-wrap full">
            <label class="field-label" for="puesto">Puesto al que aplica</label>
            <input class="field-input" type="text" id="puesto" name="puesto"
              placeholder="Ej. Chofer de autotanque" maxlength="150">
          </div>

        </div>
      </form>
    </div>

    <div class="card-footer">
      <div class="step-dots">
        <div class="dot"></div>
        <div class="dot"></div>
        <div class="dot active"></div>
      </div>
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
// ════════════════════════════════════════════════════
//  RUTAS DE API — ajusta si cambias la estructura
// ════════════════════════════════════════════════════
const API = {
  ping:      '/ping.php',
  verificar: '/api/verificar_codigo.php',
  guardar:   '/api/guardar_candidato.php',
};

// ════════════════════════════════════════════════════
//  NAVEGACIÓN
// ════════════════════════════════════════════════════
const screens = {
  splash:        document.getElementById('screen-splash'),
  codigo:        document.getElementById('screen-codigo'),
  instrucciones: document.getElementById('screen-instrucciones'),
  captura:       document.getElementById('screen-captura'),
};

function showScreen(name) {
  Object.values(screens).forEach(s => s.classList.remove('active'));
  screens[name].classList.add('active');
}



// ════════════════════════════════════════════════════
//  SPLASH · PRUEBA DE CONEXIÓN AL INICIAR
// ════════════════════════════════════════════════════
const splashRing  = document.getElementById('splash-ring');
const splashTitle = document.getElementById('splash-title');
const splashSub   = document.getElementById('splash-sub');
const btnReintentar = document.getElementById('btn-reintentar');

async function probarConexion() {
  // Resetear estado visual
  splashRing.className      = 'splash-ring';
  splashTitle.textContent   = 'Conectando…';
  splashSub.textContent     = 'Verificando conexión con el servidor';
  splashSub.classList.remove('error');
  btnReintentar.style.display = 'none';

  try {
    const ctrl = new AbortController();
    const timeout = setTimeout(() => ctrl.abort(), 8000); // 8s timeout

    const res = await fetch(API.ping, {
      method: 'GET',
      signal: ctrl.signal,
      cache:  'no-store',
    });
    clearTimeout(timeout);

    // Leer como texto primero para detectar errores PHP (warnings/notices) antes del JSON
    const raw  = await res.text();
    let data;
    try {
      // Buscar el JSON aunque haya output de PHP antes
      const jsonStart = raw.indexOf('{');
      data = JSON.parse(jsonStart >= 0 ? raw.slice(jsonStart) : raw);
    } catch {
      throw new Error('Respuesta inválida del servidor. Revisa los logs de PHP.\n' + raw.slice(0, 200));
    }

    if (res.ok && data.ok) {
      // Conexión exitosa
      splashRing.classList.add('ok');
      splashTitle.textContent = 'Conexión establecida';
      splashSub.textContent   = 'Todo listo. Redirigiendo…';

      await new Promise(r => setTimeout(r, 700)); // pausa breve para que se vea el check
      showScreen('codigo');
      document.getElementById('codigo').focus();

    } else {
      throw new Error(data.mensaje || 'El servidor no respondió correctamente.');
    }

  } catch (err) {
    const esTimeout = err.name === 'AbortError';
    let msg;
    if (esTimeout) {
      msg = 'El servidor tardó demasiado. Verifica tu conexión e intenta nuevamente.';
    } else if (err.message === 'Failed to fetch') {
      msg = 'No se encontró el archivo ping.php. Verifica que esté en la misma carpeta que index.html.';
    } else {
      msg = err.message || 'Error desconocido.';
    }

    splashRing.classList.add('fail');
    splashTitle.textContent     = 'Sin conexión';
    splashSub.textContent       = msg;
    splashSub.classList.add('error');
    btnReintentar.style.display = 'inline-block';
  }
}

// Ejecutar al cargar la página
probarConexion();


// ════════════════════════════════════════════════════
//  PANTALLA 0 · CÓDIGO DE ACCESO
// ════════════════════════════════════════════════════
const inputCodigo    = document.getElementById('codigo');
const btnIngresar    = document.getElementById('btn-ingresar');
const spinnerCodigo  = document.getElementById('spinner-codigo');
const btnCodigoArrow = document.getElementById('btn-codigo-arrow');
const btnCodigoText  = document.getElementById('btn-codigo-text');

// Solo dígitos
inputCodigo.addEventListener('input', () => {
  inputCodigo.value = inputCodigo.value.replace(/\D/g, '');
  inputCodigo.classList.remove('error');
});

document.getElementById('form-codigo').addEventListener('submit', async (e) => {
  e.preventDefault();

  const codigo = inputCodigo.value.trim();

  if (codigo.length < 4) {
    inputCodigo.classList.add('error');
    Swal.fire({
      icon: 'warning',
      title: 'Código inválido',
      text: 'El código debe tener 4 dígitos. Verifica e intenta nuevamente.',
      confirmButtonColor: '#2d4a3e',
      confirmButtonText: 'Entendido',
    });
    return;
  }

  btnIngresar.disabled         = true;
  spinnerCodigo.style.display  = 'block';
  btnCodigoArrow.style.display = 'none';
  btnCodigoText.textContent    = 'Verificando...';

  try {
    const res  = await fetch(API.verificar, {
      method:  'POST',
      headers: { 'Content-Type': 'application/json' },
      body:    JSON.stringify({ codigo }),
    });
    const raw  = await res.text();
    let data;
    try {
      const j = raw.indexOf('{');
      data = JSON.parse(j >= 0 ? raw.slice(j) : raw);
    } catch {
      throw new Error('Respuesta inválida: ' + raw.slice(0, 300));
    }

    if (data.ok) {
      sessionStorage.setItem('codigoEvaluacion', codigo);

      await Swal.fire({
        icon: 'success',
        title: '¡Bienvenido!',
        text: 'Código verificado. La evaluación está por comenzar.',
        timer: 1800,
        showConfirmButton: false,
        timerProgressBar: true,
      });

      showScreen('instrucciones');

    } else {
      inputCodigo.classList.add('error');
      inputCodigo.select();
      Swal.fire({
        icon: 'error',
        title: 'Código no encontrado',
        text: data.mensaje || 'El código ingresado no existe o ya fue utilizado.',
        confirmButtonColor: '#2d4a3e',
        confirmButtonText: 'Intentar de nuevo',
      });
    }

  } catch (err) {
    let msg = '';
    if (err.name === 'AbortError')          msg = 'Tiempo de espera agotado.';
    else if (err.message === 'Failed to fetch') msg = 'Archivo verificar_codigo.php no encontrado en el servidor.';
    else                                        msg = err.message || 'Error desconocido.';

    Swal.fire({
      icon:  'error',
      title: 'Error de conexión',
      html:  '<code style="font-size:12px;word-break:break-all">' + msg + '</code>',
      confirmButtonColor: '#2d4a3e',
      confirmButtonText:  'Reintentar',
    });
  } finally {
    btnIngresar.disabled         = false;
    spinnerCodigo.style.display  = 'none';
    btnCodigoArrow.style.display = 'inline';
    btnCodigoText.textContent    = 'Ingresar';
  }
});


// ════════════════════════════════════════════════════
//  PANTALLA 1 · INSTRUCCIONES
// ════════════════════════════════════════════════════
document.getElementById('btn-continuar-instrucciones')
  .addEventListener('click', () => showScreen('captura'));


// ════════════════════════════════════════════════════
//  PANTALLA 2 · CAPTURA DE DATOS
// ════════════════════════════════════════════════════
function validateEmail(v) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v.trim());
}
function validatePhone(v) {
  return /^[\d\s\-+]{7,15}$/.test(v.trim());
}
function markField(id, valid) {
  document.getElementById(id).classList.toggle('error', !valid);
  return valid;
}
function validateForm() {
  const n = document.getElementById('nombre').value;
  const e = document.getElementById('email').value;
  const t = document.getElementById('telefono').value;
  const p = document.getElementById('puesto').value;
  let ok = true;
  if (!n.trim())         ok = markField('nombre',   false) && ok; else markField('nombre',   true);
  if (!validateEmail(e)) ok = markField('email',    false) && ok; else markField('email',    true);
  if (!validatePhone(t)) ok = markField('telefono', false) && ok; else markField('telefono', true);
  if (!p.trim())         ok = markField('puesto',   false) && ok; else markField('puesto',   true);
  return ok;
}

['nombre','email','telefono','puesto'].forEach(id => {
  document.getElementById(id).addEventListener('input', () => {
    document.getElementById(id).classList.remove('error');
  });
});

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

  btn.disabled          = true;
  spinner.style.display = 'block';
  arrow.style.display   = 'none';
  texto.textContent     = 'Guardando...';

  const payload = {
    codigo:   sessionStorage.getItem('codigoEvaluacion'),
    nombre:   document.getElementById('nombre').value.trim(),
    email:    document.getElementById('email').value.trim(),
    telefono: document.getElementById('telefono').value.trim(),
    puesto:   document.getElementById('puesto').value.trim(),
  };

  try {
    const res  = await fetch(API.guardar, {
      method:  'POST',
      headers: { 'Content-Type': 'application/json' },
      body:    JSON.stringify(payload),
    });
    const data = await res.json();

    if (data.ok) {
      sessionStorage.setItem('candidato_id',     data.candidato_id);
      sessionStorage.setItem('session_id',       data.session_id);
      sessionStorage.setItem('battery_code',     data.battery_code);
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
    arrow.style.display   = 'inline';
    texto.textContent     = 'Iniciar evaluación';
  }
});
</script>

</body>
</html>