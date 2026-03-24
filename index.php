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
    <img src="assets/img/GatradisLogoFondoBlanco.png" alt="Logo" onerror="this.style.display='none'">
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

</div><!-- /eval-card -->

<script src="assets/js/index.js"></script>

</body>
</html>