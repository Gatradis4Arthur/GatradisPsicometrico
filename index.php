<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Evaluación Psicométrica</title>
  <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <link rel="icon" href="data:,">
  <link rel="stylesheet" href="assets/css/style_index.css">
</head>
<body>

<div class="eval-card">

  <!-- LOGO AREA: 20% de la card -->
  <div class="logo-area">
    <!-- Modo normal: solo logo -->
    <div id="logo-normal">
      <img src="assets/img/GatradisLogoFondoBlanco.png" alt="Logo" onerror="this.style.display='none'">
    </div>
  </div>

<!-- TIEMPO AREA: 15% -->
<div class="tiempo-area">
  <div id="logo-eval" style="display:none;">

    <div class="eval-progress">
      <div class="progress-badge">
        <span class="progress-num" id="eval-progress-num">1</span>
        <span class="progress-sep">/</span>
        <span class="progress-total" id="eval-progress-total">50</span>
      </div>
      <span class="progress-label">pregunta</span>
    </div>

    <div class="eval-timer">
      <span class="timer-sub">tiempo<br>restante</span>
      <svg class="timer-icon" width="28" height="28" viewBox="0 0 24 24" fill="none"
          stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="12" r="10"/>
        <polyline points="12 6 12 12 16 14"/>
      </svg>
      <div class="timer-blocks">
        <div class="t-block">
          <span class="num" id="eval-timer-min">05</span>
          <span class="lbl">min</span>
        </div>
        <span class="t-sep">:</span>
        <div class="t-block">
          <span class="num" id="eval-timer-seg">00</span>
          <span class="lbl">seg</span>
        </div>
      </div>
    </div>

  </div>
</div><!-- /tiempo-area -->

  <!-- PANTALLA 1  |  VERIFICANDO CONEXIÓN -->
  <?php include 'screens/screen01.php'; ?>

  <!-- PANTALLA 2  |  CÓDIGO DE ACCESO -->
  <?php include 'screens/screen02.php'; ?>

  <!-- PANTALLA 3  |  INSTRUCCIONES -->
  <?php include 'screens/screen03.php'; ?>

  <!-- PANTALLA 4  |  CAPTURA DE DATOS -->
  <?php include 'screens/screen04.php'; ?>

  <!-- PANTALLA 5  |  CAPTURA DE DATOS -->
  <?php include 'screens/screen05.php'; ?>

  <!-- PANTALLA 6  |  PANTALLA FINAL -->
  <?php include 'screens/screen06.php'; ?>

</div><!-- /eval-card -->

<script src="assets/js/index.js"></script>

</body>
</html>