  <!-- ════════════════════════════════
       PANTALLA 2  |  CÓDIGO DE ACCESO
  ════════════════════════════════ -->
  <div id="screen-codigo" class="screen">

    <div class="codigo-center">

      <div class="codigo-welcome">
        <p>
          Bienvenido.<br>
          Para acceder a tu evaluación, ingresa el código proporcionado y presiona el botón <strong>INGRESAR</strong>.
        </p>
      </div>
      <br>
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
            <span id="btn-codigo-text">INGRESAR</span>
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
        <div class="dot"></div>
      </div>
    </div>

  </div><!-- /screen-codigo -->
