<!-- ════════════════════════════════
     PANTALLA 5  |  TEST
════════════════════════════════ -->
<div id="screen-eval" class="screen">

  <div class="screen-body">
    <p class="screen-heading">Si el presupuesto de un proyecto es $100,000 y se ha gastado el 35%, ¿cuánto queda disponible?</p>

    <form id="form-candidato" autocomplete="off" novalidate>
      <div class="form-grid">

        <div class="field-wrap full">
          <label class="answer-option" id="answ01">
            <span class="answer-letter">A</span>
            <span class="answer-text">$55,000</span>
          </label>
        </div>

        <div class="field-wrap full">
          <label class="answer-option" id="answ02">
            <span class="answer-letter">B</span>
            <span class="answer-text">$455,000</span>
          </label>
        </div>

        <div class="field-wrap full">
          <label class="answer-option" id="answ03">
            <span class="answer-letter">C</span>
            <span class="answer-text">$565,000</span>
          </label>
        </div>

        <div class="field-wrap full">
          <label class="answer-option" id="answ04">
            <span class="answer-letter">D</span>
            <span class="answer-text">$2255,000</span>
          </label>
        </div>

        <div class="field-wrap full">
          <label class="answer-option" id="answ05">
            <span class="answer-letter">E</span>
            <span class="answer-text">$552345,000</span>
          </label>
        </div>

      </div>
    </form>
  </div>

  <div class="card-footer">
    <div class="step-dots">
      <div class="dot"></div>
      <div class="dot"></div>
      <div class="dot"></div>
      <div class="dot active"></div>
    </div>
    <button class="btn-primary" id="btn-iniciar" type="button">
      <span id="btn-text">Siguiente</span>
      <div class="spinner" id="spinner"></div>
      <svg id="btn-arrow" width="16" height="16" fill="none" stroke="currentColor"
           stroke-width="2" viewBox="0 0 24 24">
        <path d="M5 12h14M13 6l6 6-6 6"/>
      </svg>
    </button>
  </div>

</div><!-- /screen-eval -->


<style>
  .answer-option {
  display:      flex;
  align-items:  center;
  gap:          12px;
  background:   #f0f0f0;       /* gris claro */
  border-radius: 10px;
  padding:      12px 16px;
  cursor:       pointer;
  border:       2px solid transparent;
  transition:   border-color .2s, background .2s;
  user-select:  none;
}

.answer-option:hover {
  background:   #e4e4e4;
}

/* Estado seleccionado — añadir clase .selected con JS */
.answer-option.selected {
  border-color: #2d4a3e;
  background:   #e8f0ed;
}

.answer-letter {
  flex-shrink:     0;
  width:           36px;
  height:          36px;
  border-radius:   50%;
  background:      #ffffff;
  border:          1.5px solid #ccc;
  display:         flex;
  align-items:     center;
  justify-content: center;
  font-weight:     600;
  font-size:       14px;
  color:           #2d4a3e;
}

/* Letra resaltada cuando está seleccionada */
.answer-option.selected .answer-letter {
  background:  #2d4a3e;
  color:       #ffffff;
  border-color:#2d4a3e;
}

.answer-text {
  font-size:   15px;
  font-weight: 700;
  color:       #1a1a1a;
}
</style>

<script>
document.querySelectorAll('.answer-option').forEach(option => {
  option.addEventListener('click', () => {
    // Quitar selección previa
    document.querySelectorAll('.answer-option').forEach(o => o.classList.remove('selected'));
    // Marcar la elegida
    option.classList.add('selected');
  });
});
</script>
