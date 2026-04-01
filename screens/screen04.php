  <!-- ════════════════════════════════
       PANTALLA 4  |  CAPTURA DE DATOS
  ════════════════════════════════ -->
  <div id="screen-captura" class="screen">

    <div class="screen-body">
      <p class="screen-heading">Completa el formulario para iniciar la evaluación</p>
      <br>
      <form id="form-candidato" autocomplete="off" novalidate>
        <div class="form-grid">

          <div class="field-wrap full">
            <label class="field-label" for="nombre">Nombre completo</label>
            <input class="field-input" type="text" id="nombre" name="nombre"
              placeholder="Ej. María García López" maxlength="50">
          </div>

          <div class="field-wrap">
            <label class="field-label" for="email">Correo electrónico</label>
            <input class="field-input" type="email" id="email" name="email"
              placeholder="correo@ejemplo.com" maxlength="30">
          </div>

        <div class="field-wrap">
          <label class="field-label" for="telefono">Teléfono</label>
          <input class="field-input" type="tel" id="telefono" name="telefono"
            placeholder="10 dígitos" maxlength="10" inputmode="numeric"
            pattern="[0-9]*"
            oninput="this.value = this.value.replace(/[^0-9]/g, '')">
        </div>

          <div class="field-wrap full">
            <label class="field-label" for="puesto">Puesto al que aplica</label>
            <input class="field-input" type="text" id="puesto" name="puesto"
              placeholder="Ej. Chofer de autotanque" maxlength="50">
          </div>

        </div>
      </form>
    </div>

    <div class="card-footer">
      <div class="step-dots">
        <div class="dot"></div>
        <div class="dot"></div>
        <div class="dot active"></div>
        <div class="dot"></div>
      </div>
      <button class="btn-primary" id="btn-iniciar" type="button">
        <span id="btn-text">Siguiente</span>
        <div class="spinner" id="spinner"></div>
        <svg id="btn-arrow" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M5 12h14M13 6l6 6-6 6"/>
        </svg>
      </button>
    </div>

  </div><!-- /screen-captura -->
