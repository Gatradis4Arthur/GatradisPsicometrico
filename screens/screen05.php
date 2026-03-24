  <!-- ════════════════════════════════
       PANTALLA 5  |  TEST
  ════════════════════════════════ -->
  <div id="screen-eval" class="screen">

    <div class="screen-body">
      <p class="screen-heading">Tus <em>datos</em></p>
      <p class="screen-subtitle">Completa el formulario para iniciar la evaluación</p>

      <form id="form-candidato" autocomplete="off" novalidate>
        <div class="form-grid">

          <div class="field-wrap full">
            <label class="field-label" for="nombre">Testing</label>
            <input class="field-input" type="text" id="nombre" name="nombre"
              placeholder="Ej. María García López" maxlength="200">
          </div>

          <div class="field-wrap">
            <label class="field-label" for="email">Correo electrónico</label>
            <input class="field-input" type="email" id="email" name="email"
              placeholder="correo@ejemplo.com" maxlength="150">
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

  </div><!-- /screen-eval -->
