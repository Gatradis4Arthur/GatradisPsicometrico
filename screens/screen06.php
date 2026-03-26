<!-- ════════════════════════════════
     PANTALLA 6  |  FIN
════════════════════════════════ -->
<div id="screen-end" class="screen">

  <div class="screen-body" style="display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:16px;">

    <!-- Ícono de éxito -->
    <div class="end-icon">
      <svg width="56" height="56" viewBox="0 0 24 24" fill="none"
           stroke="#2d4a3e" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="12" r="10"/>
        <polyline points="9 12 11 14 15 10"/>
      </svg>
    </div>

    <!-- Título -->
    <p class="screen-heading" style="margin:0;">¡Evaluación completada!</p>

    <!-- Subtítulo -->
    <p class="end-subtitle">Gracias por tu tiempo y dedicación.<br>Tus respuestas han sido registradas exitosamente.</p>

    <!-- Tarjeta de resumen -->
    <div class="end-summary-card">
      <div class="end-summary-item">
        <span class="end-summary-label">Candidato</span>
        <span class="end-summary-value" id="end-nombre">—</span>
      </div>
      <div class="end-summary-divider"></div>
      <div class="end-summary-item">
        <span class="end-summary-label">Preguntas respondidas</span>
        <span class="end-summary-value" id="end-total">—</span>
      </div>
    </div>

    <p class="end-note">Un representante de <strong>Gatradis</strong> se pondrá en contacto contigo próximamente.</p>

  </div>

  <div class="card-footer">
    <div class="step-dots">
      <div class="dot"></div>
      <div class="dot"></div>
      <div class="dot"></div>
      <div class="dot active"></div>
    </div>
    <button class="btn-primary" id="btn-GatradisWebSite" type="button"
            onclick="window.location.href='https://gatradis.com/'">
    <span>Visitar página oficial</span>
    <svg width="16" height="16" fill="none" stroke="currentColor"
        stroke-width="2" viewBox="0 0 24 24">
        <path d="M5 12h14M13 6l6 6-6 6"/>
    </svg>
    </button>
  </div>

</div><!-- /screen-end -->


<style>
.end-icon {
  width:           80px;
  height:          80px;
  border-radius:   50%;
  background:      #e8f0ed;
  display:         flex;
  align-items:     center;
  justify-content: center;
}

.end-subtitle {
  font-size:   14px;
  color:       #555;
  line-height: 1.6;
  margin:      0;
}

.end-summary-card {
  width:         100%;
  background:    #f7f9f8;
  border:        1.5px solid #d4e2dc;
  border-radius: 12px;
  padding:       16px 20px;
  display:       flex;
  flex-direction:column;
  gap:           10px;
}

.end-summary-item {
  display:         flex;
  justify-content: space-between;
  align-items:     center;
}

.end-summary-label {
  font-size:   13px;
  color:       #888;
}

.end-summary-value {
  font-size:   14px;
  font-weight: 700;
  color:       #2d4a3e;
}

.end-summary-divider {
  height:     1px;
  background: #d4e2dc;
}

.end-note {
  font-size:  12px;
  color:      #aaa;
  margin:     0;
  line-height:1.5;
}
</style>