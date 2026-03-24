// ════════════════════════════════════════════════════
//  RUTAS DE API — ajusta si cambias la estructura
// ════════════════════════════════════════════════════
// Detecta automáticamente la carpeta base según dónde corra el sitio
// Local:      http://localhost/          → BASE = '/'
// Producción: https://gatradis.com/evaluacionpsicometrica/ → BASE = '/evaluacionpsicometrica/'
const BASE = (() => {
  const path = location.pathname;
  // Obtiene todo hasta el último slash, incluyendo la subcarpeta si existe
  return path.substring(0, path.lastIndexOf('/') + 1).replace(/\/index\.php$/, '/') || '/';
})();

const API = {
  ping:      BASE + 'ping.php',
  verificar: BASE + 'api/verificar_codigo.php',
  guardar:   BASE + 'api/guardar_candidato.php',
};

// ════════════════════════════════════════════════════
//  NAVEGACIÓN
// ════════════════════════════════════════════════════
const screens = {
  splash:        document.getElementById('screen-splash'),
  codigo:        document.getElementById('screen-codigo'),
  instrucciones: document.getElementById('screen-instrucciones'),
  captura:       document.getElementById('screen-captura'),
  iniEval:       document.getElementById('screen-eval'),
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
      sessionStorage.setItem('candidato_id',        data.candidato_id);
      sessionStorage.setItem('battery_code',        data.battery_code);
      sessionStorage.setItem('battery_type_id',     data.battery_type_id);
      sessionStorage.setItem('candidato_nombre',    payload.nombre);
      //window.location.href = 'evaluacion.php';
      IniciarEvaluacion();
      


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
 
function IniciarEvaluacion() {
 showScreen('iniEval');
}