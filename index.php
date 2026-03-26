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

  <!-- TOP BAR -->
  <div class="card-top">
    <span class="brand">Evaluación Psicométrica</span>
    <span class="badge">Proceso de selección</span>
  </div>

 
  <!-- LOGO -->
  <div class="logo-area">

    <!-- Modo normal: solo logo -->
    <div id="logo-normal">
      <img src="assets/img/GatradisLogoFondoBlanco.png" alt="Logo" onerror="this.style.display='none'">
    </div>

    <!-- Modo evaluación: progreso + logo + reloj -->
    <div id="logo-eval" style="display:none;">

      <!-- Izquierda: contador de pregunta -->
      <div class="eval-progress">
        <span id="eval-progress-num">1</span>
        <span class="eval-progress-sep">/</span>
        <span id="eval-progress-total">50</span>
      </div>

      <!-- Centro: logo -->
      <img src="assets/img/GatradisLogoFondoBlanco.png" alt="Logo" onerror="this.style.display='none'">

      <!-- Derecha: reloj -->
      <div class="eval-timer">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"/>
          <polyline points="12 6 12 12 16 14"/>
        </svg>
        <span id="eval-timer-display">5:00</span>
      </div>

    </div>

  </div>

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