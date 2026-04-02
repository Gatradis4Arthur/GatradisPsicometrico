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
            <span class="answer-text">$5</span>
          </label>
        </div>

        <div class="field-wrap full">
          <label class="answer-option" id="answ02">
            <span class="answer-letter">B</span>
            <span class="answer-text">$45</span>
          </label>
        </div>

        <div class="field-wrap full">
          <label class="answer-option" id="answ03">
            <span class="answer-letter">C</span>
            <span class="answer-text">$56</span>
          </label>
        </div>

        <div class="field-wrap full">
          <label class="answer-option" id="answ04">
            <span class="answer-letter">D</span>
            <span class="answer-text">$225</span>
          </label>
        </div>

        <div class="field-wrap full">
          <label class="answer-option" id="answ05">
            <span class="answer-letter">E</span>
            <span class="answer-text">$552</span>
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
    <button class="btn-primary" id="btn-nextQuestion" type="button">
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
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f2f2f2;
  border-radius: 14px;
  padding: 16px 18px;
  cursor: pointer;
  border: 2.5px solid transparent;
  transition: border-color .15s, background .15s;
  user-select: none;
  position: relative;
  margin-left: 14px;
  margin-top: 14px; /* espacio para el círculo que sobresale */
}
.answer-option:hover { background: #dddcdc; }

.answer-option.selected {
  background: #c8e6f7;
  border-color: #EF7D00;
}

.answer-letter {
  position: absolute;
  left: -14px;        /* antes: top: -14px / left: 14px */
  top: 50%;
  transform: translateY(-50%);
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: #fff;
  border: 2px solid #ccc;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
  color: #555;
  box-shadow: 0 1px 3px rgba(0,0,0,.1);
}
.answer-option.selected .answer-letter {
  border-color: #EF7D00;
  color: #EF7D00;
}

.answer-text {
  font-family: 'GalanoGrotesque', sans-serif;
  font-weight: 500;  /* ✅ Light */
  font-size: 15px;   /* ✅ legible */
  color: #1a1a1a;
  line-height: 1.4;
  text-align: center;
  width: 100%;
}

.answer-option.selected .answer-text { 
  font-weight: 550;        /* Medium al seleccionar */
  font-family: 'GalanoGrotesque', sans-serif;
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
