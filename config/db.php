<?php
// config/db.php
// ─────────────────────────────────────────────────────────────────────────────
// Ajusta las constantes según tu entorno.
// ─────────────────────────────────────────────────────────────────────────────

define('DB_HOST', '127.0.0.1');
define('DB_PORT', '3307');
define('DB_NAME', 'psicometria');
define('DB_USER', 'root');
define('DB_PASS', 'root');
define('DB_CHARSET', 'utf8mb4');

//Producción 
 
/*
define('DB_HOST', 'db5011857982.hosting-data.io');
define('DB_PORT', '3306');
define('DB_NAME', 'dbs9987399');
define('DB_USER', 'dbu5577662');
define('DB_PASS', 'gatradisdb=1');
define('DB_CHARSET', 'utf8mb4');
*/

$dsn = sprintf(
    'mysql:host=%s;port=%s;dbname=%s;charset=%s',
    DB_HOST, DB_PORT, DB_NAME, DB_CHARSET
);

$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
} catch (PDOException $e) {
    http_response_code(500);
    header('Content-Type: application/json');
    echo json_encode(['ok' => false, 'mensaje' => 'No se pudo conectar a la base de datos']);
    exit;
}