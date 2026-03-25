<?php
declare(strict_types=1);
// api/obtenerBateria.php

header('Content-Type: application/json; charset=utf-8');

// ── Helpers ──────────────────────────────────────────────────────────────────
function jsonOut(array $data, int $status = 200): never {
    http_response_code($status);
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

function cleanStr(string $v, int $maxLen = 255): string {
    return mb_substr(trim(strip_tags($v)), 0, $maxLen);
}

// ── Sólo POST ─────────────────────────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    jsonOut(['ok' => false, 'mensaje' => 'Método no permitido'], 405);
}

// ── Leer JSON ─────────────────────────────────────────────────────────────────
$raw  = file_get_contents('php://input');
$body = json_decode($raw, true);

// El JS envía directamente el string: JSON.stringify(battery_code)
// por lo que $body es un string, no un array
if (!is_string($body) || trim($body) === '') {
    jsonOut(['ok' => false, 'mensaje' => 'Cuerpo JSON inválido'], 400);
}

$battery_code = cleanStr($body, 200);

if (!$battery_code) {
    jsonOut(['ok' => false, 'mensaje' => 'battery_code es obligatorio'], 422);
}

// ── Conexión a BD ─────────────────────────────────────────────────────────────
require_once __DIR__ . '/../config/db.php'; // devuelve $pdo (PDO)

try {
    // No se necesita transacción para una consulta de solo lectura
    $stmt = $pdo->prepare('CALL sp_get_battery(:json)');
    $stmt->execute([
        ':json' => json_encode(['clave' => $battery_code]),
    ]);

    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (empty($rows)) {
        jsonOut(['ok' => false, 'mensaje' => "Batería no encontrada: $battery_code"], 404);
    }

    jsonOut([
        'ok'   => true,
        'data' => $rows,
    ]);

} catch (Throwable $e) {
    error_log($e->getMessage()); // revisa logs de Apache/PHP
    jsonOut([
        'ok'      => false,
        'mensaje' => $e->getMessage(), // ← temporal solo para debug
    ], 500);
}