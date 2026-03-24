<?php declare(strict_types=1);
// api/verificar_codigo.php
// ─────────────────────────────────────────────────────────────────────────────
// Recibe: { codigo: "1234" }
// Devuelve: { ok: true } | { ok: false, mensaje: "..." }
//
// Ajusta la lógica según dónde guardes los códigos válidos:
// opción A → tabla `access_codes` en BD
// opción B → array fijo (para pruebas)
// ─────────────────────────────────────────────────────────────────────────────

header('Content-Type: application/json; charset=utf-8');

function jsonOut(array $data, int $status = 200): never {
    http_response_code($status);
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    jsonOut(['ok' => false, 'mensaje' => 'Método no permitido'], 405);
}

$body  = json_decode(file_get_contents('php://input'), true);
$codigo = trim($body['codigo'] ?? '');

if (!preg_match('/^\d{4}$/', $codigo)) {
    jsonOut(['ok' => false, 'mensaje' => 'El código debe tener exactamente 4 dígitos.']);
}

// ── OPCIÓN A: verificar contra la base de datos ───────────────────────────
// Descomenta y ajusta si tienes una tabla access_codes(code VARCHAR(4), used TINYINT)
/*
// db.php está un nivel arriba (en www/ raíz)
require_once __DIR__ . '/../config/db.php';
$stmt = $pdo->prepare('SELECT id FROM access_codes WHERE code = ? AND used = 0 LIMIT 1');
$stmt->execute([$codigo]);
if ($stmt->fetch()) {
    jsonOut(['ok' => true]);
} else {
    jsonOut(['ok' => false, 'mensaje' => 'El código no existe o ya fue utilizado.']);
}
*/

// ── OPCIÓN B: lista fija para pruebas/desarrollo ──────────────────────────
$codigosValidos = ['1010', '1020', '1030', '1040'];

if (in_array($codigo, $codigosValidos, true)) {
    jsonOut(['ok' => true]);
} else {
    jsonOut(['ok' => false, 'mensaje' => 'El código ingresado no existe. Verifica e intenta nuevamente.']);
}