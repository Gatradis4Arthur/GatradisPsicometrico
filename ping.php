<?php declare(strict_types=1);
// api/ping.php
// Verifica conectividad con el servidor y MariaDB.

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store, no-cache, must-revalidate');

function jsonOut(array $data, int $status = 200): never {
    http_response_code($status);
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    jsonOut(['ok' => false, 'mensaje' => 'Método no permitido'], 405);
}

$debug = (bool) ini_get('display_errors');

try {
    require_once __DIR__ . '/config/db.php';

    $row = $pdo->query("SELECT VERSION() AS version")->fetch();

    jsonOut([
        'ok'    => true,
        'db'    => true,
        'motor' => $row['version'] ?? 'desconocido',
        'ts'    => date('Y-m-d H:i:s'),
    ]);

} catch (PDOException $e) {
    jsonOut([
        'ok'      => false,
        'db'      => false,
        'mensaje' => 'No se pudo conectar con MariaDB. Verifica host, puerto y credenciales.',
        'detalle' => $debug ? '[' . $e->getCode() . '] ' . $e->getMessage() : '',
    ], 503);

} catch (Throwable $e) {
    jsonOut([
        'ok'      => false,
        'mensaje' => 'Error inesperado en el servidor.',
        'detalle' => $debug ? $e->getMessage() : '',
    ], 500);
}